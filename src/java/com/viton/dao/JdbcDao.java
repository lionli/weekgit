/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.viton.dao;

import com.viton.model.Agent;
import com.viton.model.AgentConfiguration;
import com.viton.model.BackupResource;
import com.viton.model.Device;
import com.viton.model.Host;
import com.viton.model.VitonLog;
import com.viton.model.VolumeGroup;
import java.io.ByteArrayOutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.zip.InflaterInputStream;
import javax.sql.DataSource;
import org.postgresql.largeobject.LargeObject;
import org.postgresql.largeobject.LargeObjectManager;

/**
 *
 * @author lion
 */
public class JdbcDao {
    private static final String LARGE_TAG = "<LARGE>";
    private DataSource dataSource;

    public void setDataSource(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public List<Host> getHostAgent(String hostId, String agentName) throws Exception {
        List<Host> hosts = new ArrayList<Host>();
        String sql = "select h.host_id as hostid, host_name, port_for_control, "
                + "hostip_for_control as host_ip, h.pguser as host_pguser, "
                + "host_desc, a.agent_name, backup_prog_path, restore_prog_path, "
                + "list_prog_path, a.pguser as agent_pguser, agent_desc from "
                + "host_reg h,host_agent_reg a, agent_reg ar where "
                + "ar.agent_name=a.agent_name and h.host_id=? and a.agent_name=?";
        Connection conn = null;
        try {
            conn = dataSource.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, hostId);
            ps.setString(2, agentName);
            ps.executeQuery();
            ResultSet rs = ps.getResultSet();
            while (rs.next()) {
                Host host = new Host(rs.getString("hostid"));
                if (!hosts.contains(host)) {
                    host.setHostName(rs.getString("host_name"));
                    host.setHostIp(rs.getString("host_ip"));
                    host.setHostPort(Integer.valueOf(rs.getString("port_for_control")));
                    host.setDesc(rs.getString("host_desc"));
                    host.setPguser(rs.getString("host_pguser"));
                    hosts.add(host);
                }
                Agent agent = new Agent();
                agent.setAgentName(rs.getString("agent_name"));
                agent.setPguser(rs.getString("agent_pguser"));
                agent.setBackupProgramPath(rs.getString("backup_prog_path"));
                agent.setRestoreProgramPath(rs.getString("restore_prog_path"));
                agent.setListProgramPath(rs.getString("list_prog_path"));
                agent.setDescription(rs.getString("agent_desc"));
                //   System.out.println(hosts.indexOf(host));
                hosts.get(hosts.indexOf(host)).addAgent(agent);
            }
            rs.close();
            ps.close();
        } catch (SQLException ex) {
            ex.printStackTrace();
            throw new Exception(ex.getMessage());
        } finally {
            if (conn != null) {
                conn.close();
            }
        }
        return hosts;
    }

    public AgentConfiguration getAgentConfiguration(String hostId,String agentName) throws Exception{
        Map<String,String> vgidName=getVgidName();
        AgentConfiguration config=new AgentConfiguration();
        String sql="select resource_name, id_name, id_value, default_vgid, description "
                + "from resource_reg where host_id=? and agent_name=?";
        Connection conn=null;
        try{
            conn=dataSource.getConnection();
            PreparedStatement ps=conn.prepareStatement(sql);
            ps.setString(1, hostId);
            ps.setString(2, agentName);
            ResultSet rs=ps.executeQuery();
            while(rs.next()){
                config.setResourceName(rs.getString("resource_name"));
                config.setInstName(rs.getString("id_name"));
                config.setInstValue(rs.getString("id_value"));
                String defaultVgid=rs.getString("default_vgid");
                if(defaultVgid==null||defaultVgid.isEmpty())
                    config.setDefaultVg("");
                else{
                    config.setDefaultVg(vgidName.get(defaultVgid));
                }
                
            }
            rs.close();
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
            throw new Exception(e);
        }finally{
            if(conn!=null){
                conn.close();
            }
        }
        return config;
    }

    private Map<String,String> getVgidName() throws Exception{
        Map<String,String> map=new HashMap<String,String>();
        String sql="select vgid, name from volume_group";
        Connection conn=null;
        try{
            conn=dataSource.getConnection();
            Statement stat=conn.createStatement();
            ResultSet rs=stat.executeQuery(sql);
            while(rs.next()){
                map.put(rs.getString("vgid"), rs.getString("name"));
            }
            rs.close();
            stat.close();
        }catch(Exception e){
            e.printStackTrace();
            throw new Exception(e);
        }finally{
            if(conn!=null)
                conn.close();
        }
        return map;
    }
    
    public List<Host> getRegHostClients() throws Exception {
        Map<String,String> vgidName=getVgidName();
        List<Host> hosts = new ArrayList<Host>();
        String sql = "select h.host_id as hostid, host_name, port_for_control, "
                + "hostip_for_control as host_ip, h.pguser as host_pguser, "
                + "host_desc, a.agent_name, backup_prog_path, restore_prog_path, "
                + "list_prog_path, a.pguser as agent_pguser, agent_desc, "
                + "resource_name, id_name, id_value, default_vgid, r.description as resourceDesc "
                + "from host_reg h,host_agent_reg a, agent_reg ar, resource_reg r "
                + "where ar.agent_name=a.agent_name and h.host_id=a.host_id and "
                + "r.host_id=a.host_id and r.agent_name=a.agent_name";
        Connection conn = null;
        try {
            conn = dataSource.getConnection();
            Statement stat = conn.createStatement();
            stat.executeQuery(sql);
            ResultSet rs = stat.getResultSet();
            while (rs.next()) {
                Host host = new Host(rs.getString("hostid"));
                if (!hosts.contains(host)) {
                    host.setHostName(rs.getString("host_name"));
                    host.setHostIp(rs.getString("host_ip"));
                    host.setHostPort(Integer.valueOf(rs.getString("port_for_control")));
                    host.setDesc(rs.getString("host_desc"));
                    host.setPguser(rs.getString("host_pguser"));
                    hosts.add(host);
                }
                Agent agent = new Agent();
                agent.setAgentName(rs.getString("agent_name"));
                agent.setPguser(rs.getString("agent_pguser"));
                agent.setBackupProgramPath(rs.getString("backup_prog_path"));
                agent.setRestoreProgramPath(rs.getString("restore_prog_path"));
                agent.setListProgramPath(rs.getString("list_prog_path"));
                agent.setDescription(rs.getString("agent_desc"));
                AgentConfiguration config=new AgentConfiguration();
                config.setResourceName(rs.getString("resource_name"));
                config.setInstName(rs.getString("id_name"));
                config.setInstValue(rs.getString("id_value"));
                String vgid=rs.getString("default_vgid");
                if(vgid==null||vgid.isEmpty()){
                    config.setDefaultVg("");
                }else{
                    config.setDefaultVg(vgidName.get(vgid));
                }
                config.setInstDescription(rs.getString("resourceDesc"));
                agent.setResourceConfig(config);
                hosts.get(hosts.indexOf(host)).addAgent(agent);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
            throw new Exception(ex.getMessage());
        } finally {
            if (conn != null) {
                conn.close();
            }
        }
        return hosts;
    }

    public List<Host> getRegMediaServer() throws Exception {
        List<Host> hosts = new ArrayList<Host>();
    /**    String sql = "select h.host_id as hostid,host_name,pguser as hostPgUser,"
                + "hostip_for_data,host_desc, dev_name,dev_type,dev_path,dev_descript "
                + "from host_reg h, device d where h.host_id=d.host_id order by host_name";*/
        String sql="select host_id, host_name, pguser, hostip_for_data, host_desc "
                + "from host_reg where is_ms='true' order by host_id";

        Connection conn = null;
        try {
            conn = dataSource.getConnection();
            Statement stat = conn.createStatement();
            ResultSet rs = stat.executeQuery(sql);
            while (rs.next()) {
                Host host=new Host(rs.getString("host_id"));
                host.setHostName(rs.getString("host_name"));
                host.setPguser(rs.getString("pguser"));
                host.setIpForData(rs.getString("hostip_for_data"));
                host.setDesc(rs.getString("host_desc"));
                hosts.add(host);
            /**    Host host = new Host(rs.getString("hostid"));
                if (!hosts.contains(host)) {
                    host.setHostName(rs.getString("host_name"));
                    host.setPguser(rs.getString("hostPgUser"));
                    host.setIpForData(rs.getString("hostip_for_data"));
                    host.setDesc(rs.getString("host_desc"));
                    hosts.add(host);
                }
                Device dev = new Device();
                dev.setName(rs.getString("dev_name"));
                dev.setType(rs.getString("dev_type"));
                dev.setPath(rs.getString("dev_path"));
                dev.setDesc(rs.getString("dev_descript"));
                hosts.get(hosts.indexOf(host)).addDevice(dev);*/
            }
            rs.close();
            stat.close();
        } catch (SQLException ex) {
            Logger.getLogger(JdbcDao.class.getName()).log(Level.SEVERE, null, ex);
            throw new Exception(ex.getMessage());
        } finally {
            if (conn != null) {
                conn.close();
            }
        }
        return hosts;
    }

    public List<Device> getRegDevices() throws Exception{
        String sql="select host_id, dev_name, dev_type, dev_parent, dev_path, dev_descript "
                + "from device order by host_id";
        Connection conn=null;
        List<Device> allDevices=new ArrayList<Device>();
        try{
            conn=dataSource.getConnection();
            PreparedStatement ps=conn.prepareStatement(sql);
            ResultSet rs=ps.executeQuery();
            while(rs.next()){
                Device device=new Device();
                String hostId=rs.getString("host_id");
                device.setHostId(hostId);
                device.setName(rs.getString("dev_name"));
                device.setType(rs.getString("dev_type"));
                device.setParentName(rs.getString("dev_parent"));
                device.setPath(rs.getString("dev_path"));
                device.setDesc(rs.getString("dev_descript"));
                allDevices.add(device);
            }
            rs.close();
            ps.close();
            Device[] tmpArr=allDevices.toArray(new Device[0]);
            for(int i=0;i<tmpArr.length;i++){
                Device device=tmpArr[i];
                if(!device.getParentName().equals("*")){
                    for(Device dev:allDevices){
                        if(dev.getName().equals(device.getParentName())){
                            dev.addChild(device);
                            allDevices.remove(device);
                            break;
                        }
                    }
                }
            }
        }catch(Exception e){
            e.printStackTrace();
            throw new Exception(e);
        }finally{
            if(conn!=null)
                conn.close();
        }
        return allDevices;
    }

    public List<VolumeGroup> getRegVolumeGroup() throws Exception{
        List<VolumeGroup> vgs=new ArrayList<VolumeGroup>();
        String sql="select host_id, vgid, name, current_volume, vg_type, quota, description "
                + "from volume_group order by host_id";
        Connection conn=null;
        try{
            conn=dataSource.getConnection();
            PreparedStatement ps=conn.prepareStatement(sql);
            ResultSet rs=ps.executeQuery();
            while(rs.next()){
                VolumeGroup vg=new VolumeGroup();
                vg.setHostId(rs.getString("host_id"));
                vg.setVgid(rs.getString("vgid"));
                vg.setName(rs.getString("name"));
                vg.setCurrentVolume(Integer.toString(rs.getInt("current_volume")));
                vg.setType(rs.getString("vg_type"));
                vg.setCapability(Integer.toString(rs.getInt("quota")));
                vg.setDesc(rs.getString("description"));
                vgs.add(vg);
            }
            rs.close();
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
            throw new Exception(e);
        }finally{
            if(conn!=null)
                conn.close();
        }
        return vgs;
    }

    public Map<String,Long> getVgUsed() throws Exception{
        String sql="select vgid, sum(size) as usedSize from archive group by vgid";
        Map<String,Long> map=new HashMap<String,Long>();
        Connection conn=null;
        try{
            conn=dataSource.getConnection();
            PreparedStatement ps=conn.prepareStatement(sql);
            ResultSet rs=ps.executeQuery();
            while(rs.next()){
                map.put(rs.getString("vgid"), rs.getLong("usedSize"));
            }
            rs.close();
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
            throw new Exception(e);
        }finally{
            if(conn!=null)
                conn.close();
        }
        return map;
    }

    public List<VitonLog> getLogByHostId(String hostId) throws Exception {
        String sql = "select l.class as logClass, l.type as logType, record_time, log_message, j.title as jobName "
                + "from log l, job_def_ j where l.host_id=? and j.job_def_id="
                + "(select job_def_id from job where job_id=l.job_id) order by l.host_id";
        Connection conn = null;
        try {
            conn = dataSource.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, hostId);
            ResultSet rs = ps.executeQuery();
            List<VitonLog> logs = getHostLog(rs);
            rs.close();
            ps.close();
            return logs;
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        } finally {
            if (conn != null) {
                conn.close();
            }
        }
    }

    private List<VitonLog> getHostLog(ResultSet rs) throws SQLException {
        List<VitonLog> logs = new ArrayList<VitonLog>();
        while (rs.next()) {
            VitonLog log = new VitonLog();
            log.setAgentType(rs.getString("logClass"));
            log.setLogType(rs.getString("logType"));
            log.setJobName(rs.getString("jobName"));
            log.setRecordDate(new Date(rs.getTimestamp("record_time").getTime()));
            log.setLogInfo(rs.getString("log_message"));
            logs.add(log);
        }
        return logs;
    }

    public Map<String, String> getRegHostIdAndNames() throws Exception {
        String sql = "select host_id, host_name from host_reg order by host_name";
        Map<String, String> hostMap = new LinkedHashMap<String, String>();
        Connection conn = null;
        try {
            conn = dataSource.getConnection();
            Statement stat = conn.createStatement();
            ResultSet rs = stat.executeQuery(sql);
            while (rs.next()) {
                hostMap.put(rs.getString("host_id"), rs.getString("host_name"));
            }
            rs.close();
            stat.close();
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        } finally {
            if (conn != null) {
                conn.close();
            }
        }
        return hostMap;
    }

    public Map<String,String> getRegAgents() throws Exception{
        Map<String,String> agents=new HashMap<String,String>();
        String sql="select a.agent_name as agentname, agent_desc from agent_reg a, host_agent_reg h "
                + "where a.agent_name=h.agent_name";
        Connection conn=null;
        try{
            conn=dataSource.getConnection();
            Statement stat=conn.createStatement();
            ResultSet rs=stat.executeQuery(sql);
            while(rs.next()){
                agents.put(rs.getString("agentname"),rs.getString("agent_desc"));
            }
            rs.close();
            stat.close();
        }catch(Exception e){
            e.printStackTrace();
            throw new Exception(e);
        }finally{
            if(conn!=null)
                conn.close();
        }
        return agents;
    }

    public Map<String,String> getHostRegAgentNameAndDesc(String hostId) throws Exception {
        Map<String,String> agent = new HashMap<String,String>();
        String sql = "select agent_name, agent_desc from agent_reg a, host_agent_reg h where "
                + "a.agent_name=h.agent_name and h.host_id=? order by agent_desc";
        Connection conn = null;
        try {
            conn = dataSource.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, hostId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                agent.put(rs.getString("agent_name"), rs.getString("agent_desc"));
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        } finally {
            if (conn != null) {
                conn.close();
            }
        }
        return agent;
    }

    public Map<String,String> getHostAgentNameAndDesc(String hostId) throws Exception{
        Map<String,String> hostAgent = new HashMap<String,String>();
        String sql = "select h.agent_name as agentname,agent_desc from agent_reg a, host_agent_reg h where "
                + "a.agent_name=h.agent_name and h.host_id=? order by agent_desc";
        Connection conn = null;
        try {
            conn = dataSource.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, hostId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                hostAgent.put(rs.getString("agentname"),rs.getString("agent_desc"));
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        } finally {
            if (conn != null) {
                conn.close();
            }
        }
        return hostAgent;
    }

    public List<String> getHostAgentInstance(String hostId, String agentName) throws Exception {
        List<String> instances = new ArrayList<String>();
        String sql = "select id_value from resource_reg "
                + "where host_id=? and "
                + "agent_name=?";
        Connection conn = null;
        try {
            conn = dataSource.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, hostId);
            ps.setString(2, agentName);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                instances.add(rs.getString("id_value"));
            }
            rs.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception(e.getMessage());
        } finally {
            if (conn != null) {
                conn.close();
            }
        }
        return instances;
    }

    public String getHostIpById(String hostId) throws Exception{
        String sql="select hostip_for_control from host_reg where host_id=?";
        Connection conn=null;
        String hostIp="";
        try{
            conn=dataSource.getConnection();
            PreparedStatement ps=conn.prepareStatement(sql);
            ps.setString(1,hostId);
            ResultSet rs=ps.executeQuery();
            while(rs.next()){
                hostIp=rs.getString("hostip_for_control");
            }
            rs.close();
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
            throw new Exception(e.getMessage());
        } finally {
            if(conn!=null)
                conn.close();
        }
        return hostIp;
    }

    public Map<String,String> getVolumeGroupByUser(String userName) throws Exception{
        Map<String,String> map=new HashMap<String,String>();
        String sql="select name, vgid from volume_group where pguser=?";
        Connection conn=null;
        try{
            conn=dataSource.getConnection();
            PreparedStatement ps=conn.prepareStatement(sql);
            ps.setString(1, userName);
            ResultSet rs=ps.executeQuery();
            while(rs.next()){
                map.put(rs.getString("name"), rs.getString("vgidn"));
            }
            rs.close();
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
            throw new Exception(e);
        }finally{
            if(conn!=null)
                conn.close();
        }
        return map;
    }


    public BackupResource getBackupResourceByHostId(String hostId) throws Exception{
        BackupResource br=new BackupResource();
        Map<String,String> hostAgentNameAndDesc=getHostAgentNameAndDesc(hostId);
        Collection<String> hostAgentNames=hostAgentNameAndDesc.keySet();
        for(String agentName:hostAgentNames){
            br.addAgent(agentName);
        }
        
        String sql="select h.host_name as hostname,r.agent_name as agentname,"
                + "backup_set_id,b.name as name "
                + "from host_reg h, resource_reg r,backup_set_version b "
                + "where r.resource_id=b.resource_id and r.host_id=h.host_id and h.host_id=?";
        
        Connection conn=null;
        try{
            conn=dataSource.getConnection();
            PreparedStatement ps=conn.prepareStatement(sql);
            ps.setString(1, hostId);
            ResultSet rs=ps.executeQuery();

            while(rs.next()){
                String hostName=rs.getString("hostname");
                br.setHostName(hostName);
                String agentName=rs.getString("agentname");
                Map<String,String> agentBackupResource=br.getAgentBackupResource(agentName);
                String backupSetId=rs.getString("backup_set_id");
                String backupSetName=rs.getString("name");
                agentBackupResource.put(backupSetId,backupSetName);
            }
            rs.close();
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
            throw new Exception(e);
        }finally{
            if(conn!=null)
                conn.close();
        }
        return br;
    }

    public String getFileRestoreSelectionSet(String backupSetId) throws Exception{  
        Connection conn=null;
        String xmlData;
        try{
            conn=dataSource.getConnection();
            if((xmlData=getXmlDataFromFileInfo(conn,backupSetId)).equals(LARGE_TAG)){
                xmlData=getXmlDataFromFileInfoLarge(conn,backupSetId);
            }
        }catch(Exception e){
            e.printStackTrace();
            throw new Exception(e);
        }finally{
            if(conn!=null)
                conn.close();
        }
        return xmlData;
    }

    private String getXmlDataFromFileInfo(Connection conn,String backupSetId) throws Exception{
        String sSql = "select xml_data from file_info where backup_set_id = ?";
        PreparedStatement ps=conn.prepareStatement(sSql);
        ps.setString(1, backupSetId);
        ResultSet rs=ps.executeQuery();
        String xmlData="";
        while(rs.next()){
            xmlData=rs.getString("xml_data");
        }
        rs.close();
        ps.close();
        return xmlData;
    }

    private String getXmlDataFromFileInfoLarge(Connection conn,String backupSetId) throws Exception{
        String sSql = "select xml_data from file_info_large where backup_set_id = ?";
        PreparedStatement ps=conn.prepareStatement(sSql);
        ps.setString(1, backupSetId);
        ResultSet rs=ps.executeQuery();
        int oid = rs.getInt("xml_data");

        LargeObjectManager lobm = ((org.postgresql.PGConnection)conn).getLargeObjectAPI();
        LargeObject lobj = lobm.open(oid, LargeObjectManager.READ);
        InflaterInputStream infin = new InflaterInputStream(lobj.getInputStream());
        ByteArrayOutputStream baos=new ByteArrayOutputStream();
        int n;
        byte[] bytes=new byte[1024];
        while((n=infin.read(bytes))!=-1){
            baos.write(bytes, 0, n);
        }
        infin.close();
        lobj.close();
        rs.close();
        ps.close();
        return baos.toString();
    }
}
