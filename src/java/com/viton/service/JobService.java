/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.viton.service;

import com.viton.dao.JdbcDao;
import com.viton.util.JSONUtils;

/**
 *
 * @author lion
 */
public class JobService {
    private JdbcDao dao;

    public void setDao(JdbcDao dao) {
        this.dao = dao;
    }

    public String getHostAgents(String hostId) throws Exception{
        String xx=JSONUtils.agentToJSONString(dao.getHostAgentNameAndDesc(hostId));
        System.out.println(xx);
        return xx;
    }
}
