/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.viton.service;

import ch.ethz.ssh2.Connection;
import ch.ethz.ssh2.Session;
import ch.ethz.ssh2.StreamGobbler;
import com.viton.dao.JdbcDao;
import com.viton.model.Agent;
import com.viton.model.Device;
import com.viton.model.Host;
import com.viton.model.VolumeGroup;
import com.viton.util.JSONUtils;
import com.viton.util.Utils;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

/**
 *
 * @author lion
 */
public class JdbcService {
    private JdbcDao dao;

    public void setDao(JdbcDao dao) {
        this.dao = dao;
    }

    public String getRegHostAgents() throws Exception{
        String xx=JSONUtils.hostAgentToJSONString(dao.getRegHostClients());
        System.out.println(xx);
        return xx;
    }

    public String getRegMediaServers() throws Exception{
        List<Host> mediaServers=dao.getRegMediaServer();
        List<Device> devices=dao.getRegDevices();
        List<VolumeGroup> vgs=dao.getRegVolumeGroup();
        for(Host host:mediaServers){
            Iterator<Device> dIterator=devices.iterator();
            while(dIterator.hasNext()){
                Device d=dIterator.next();
                if(d.getHostId().equals(host.getHostId())){
                    host.addDevice(d);
                    dIterator.remove();
                }
            }
            Iterator<VolumeGroup> vIterator=vgs.iterator();
            while(vIterator.hasNext()){
                VolumeGroup vg=vIterator.next();
                if(vg.getHostId().equals(host.getHostId())){
                    host.addVolumeGroup(vg);
                    vIterator.remove();
                }
            }
        }
        String xx=JSONUtils.hostMediaServerToJSONString(mediaServers);
        System.out.println(xx);
        return xx;
    }

    public String getRegHostIdAndNames() throws Exception{
        String xx=JSONUtils.hostToJSONString(dao.getRegHostIdAndNames());
        System.out.println(xx);
        return xx;
    }

    public String getRegAgentNameAndDesc() throws Exception{
        String xx=JSONUtils.agentToJSONString(dao.getRegAgents());
        System.out.println(xx);
        return xx;
    }

    public String getRegHostAndAgents() throws Exception{
        String xx=JSONUtils.hostAndAgentsToJSONString(dao.getRegHostIdAndNames(),
                dao.getRegAgents());
        System.out.println(xx);
        return xx;
    }
    
    public String getHostAgentNames(String hostId) throws Exception{
        String xx=JSONUtils.agentToJSONString(dao.getHostAgentNameAndDesc(hostId));
        System.out.println(xx);
        return xx;
    }

    public String getHostAgentInstances(String hostId,String agentDesc) throws Exception{
        String xx=Utils.toJSArray(dao.getHostAgentInstance(hostId, agentDesc));
        System.out.println(xx);
        return xx;
    }

    public String getBackupResource(String hostId) throws Exception{
        String xx=JSONUtils.encodeBackupResourceToJSONString(dao.getBackupResourceByHostId(hostId));
        System.out.println(xx);
        return xx;
    }

    public String getFileList(String agentInfo,String path) throws Exception{
        Map<String,String> agentMap=JSONUtils.parseAgentInfo(agentInfo);
        Host host=dao.getHostAgent(agentMap.get("hostid"), agentMap.get("agentname")).get(0);
        Agent agent=host.getAgents().get(0);
        Connection conn=new Connection(host.getHostIp(),Integer.valueOf(agentMap.get("port")));
        conn.connect();
        if(!conn.authenticateWithPassword(agentMap.get("osusername"), agentMap.get("ospassword"))){
            throw new Exception("can not connect to host "+host.getHostName());
        }
        Session session=conn.openSession();
        session.requestDumbPTY();
        session.startShell();
        PrintWriter pw=new PrintWriter(session.getStdin());
        String cmd="\""+agent.getListProgramPath()+"Launcher\""+" \"filelist\" \""
                +agentMap.get("osusername")+"\" \""+agentMap.get("ospassword")+"\"";

        if(path!=null&&!path.isEmpty()){
            cmd=cmd+" \""+path+"\"";
        }
     //   System.out.println(cmd);
        pw.println(cmd);
        pw.println("exit");
        pw.close();
        List<String> outputMsg=getExecuteOutput(session.getStdout());
        session.close();
        conn.close();
      //  System.out.println(outputMsg);
        String xx=JSONUtils.encodeFileList(outputMsg);
        System.out.println(xx);
        return xx;
    }

    private List<String> getExecuteOutput(InputStream in) throws Exception{
        List<String> messages=new ArrayList<String>();
        InputStream inStream=new StreamGobbler(in);
        BufferedReader br=new BufferedReader(new InputStreamReader(inStream));
        boolean isUsefulMsg=false;
        while(true){
            String line=br.readLine();
            System.out.println(line);
            if(line==null)
                break;
            if(line.contains("launch program ends"))
                break;
            if(isUsefulMsg){
                if(line.equals("\n")||line.trim().isEmpty()){
                    continue;
                }
                messages.add(line);
            }
            if(line.contains("launch program starts")){
                isUsefulMsg=true;
            }
        }
        return messages;
    }

    public void test(String text) throws Exception{
        JSONUtils.parseFileNode(text);
    }
}
