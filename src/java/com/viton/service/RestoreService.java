/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.viton.service;

import com.viton.dao.JdbcDao;

/**
 *
 * @author lion
 */
public class RestoreService {
    private JdbcDao dao;

    public void setDao(JdbcDao dao) {
        this.dao = dao;
    }

  /**  public String getRestoreSelectionSet(String backupSetId,String agentType){
        
    }*/

    public String getFileRestoreSelectionSet(String backupSetId) throws Exception{
        String xx=dao.getFileRestoreSelectionSet(backupSetId);
        System.out.println(xx);
        return xx;
    }

    private String getRestoreSelectionSet(String backupSetId){
        return "";
    }
}
