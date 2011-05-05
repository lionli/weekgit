/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.viton.dao;

import ch.ethz.ssh2.Connection;
import ch.ethz.ssh2.Session;
import com.viton.model.Agent;
import com.viton.model.Host;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author lion
 */
public class SshDao {
    private JdbcDao dao;

    public void setDao(JdbcDao dao) {
        this.dao = dao;
    }

    public List<String> getFileList(String hostId,String agentName,
            String osName,String osPassword,int port,String path) throws Exception{
        List<Host> hosts=dao.getHostAgent(hostId, agentName);
        if(hosts.size()!=1){
            throw new Exception("error while getting agent info");
        }
        Host host=hosts.get(0);
        Agent agent=host.getAgents().get(0);

        List<String> fileList=new ArrayList<String>();
        Connection conn=new Connection(host.getHostIp(),port);
        conn.connect();
        if(!conn.authenticateWithPassword(osName, osPassword)){
            throw new Exception("can not connect to host "+host.getHostName());
        }
        Session session=conn.openSession();
        session.requestDumbPTY();
        session.startShell();
        PrintWriter pw=new PrintWriter(session.getStdin());
        String sshCommand="\""+agent.getListProgramPath()+"Launcher\""+" \"filelist\""+" \""+
                    osName+"\" \""+osPassword+"\" \""+path+"/\"";
        
        session.close();
        conn.close();
        return fileList;
    }
}
