/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.viton.service;

import com.viton.dao.JdbcDao;
import com.viton.util.JSONUtils;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author lion
 */
public class JobService {
    private JdbcDao dao;

    private final static Logger logger=Logger.getLogger(JobService.class.getName());

    public void setDao(JdbcDao dao) {
        this.dao = dao;
    }

    public String getHostAgents(String hostId) throws Exception{
        String xx=JSONUtils.agentToJSONString(dao.getHostAgentNameAndDesc(hostId));
        logger.log(Level.WARNING, "Host Agents: "+xx);
        return xx;
    }

    public String getJobs() throws Exception{
        
        return "";
    }
}
