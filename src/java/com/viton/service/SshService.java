/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.viton.service;

import ch.ethz.ssh2.Connection;
import com.viton.dao.JdbcDao;

/**
 *
 * @author lion
 */
public class SshService {
    private JdbcDao dao;

    public void setDao(JdbcDao dao) {
        this.dao = dao;
    }

    public boolean isAuthenticated(String hostId,String username,String password,int port){
        try{
            String hostIp=dao.getHostIpById(hostId);
            Connection conn=new Connection(hostIp,port);
            conn.connect();
            if(!conn.authenticateWithPassword(username, password)){
                return false;
            }
        }catch(Exception e){
            return false;
        }
        return true;
    }
}
