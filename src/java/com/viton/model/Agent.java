/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.viton.model;

/**
 *
 * @author lion
 */
public class Agent {
    private String agentName;
    private String pguser;
    private String backupProgramPath;
    private String restoreProgramPath;
    private String listProgramPath;
    private String description;
    private AgentConfiguration agentConfig;

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getAgentName() {
        return agentName;
    }

    public void setAgentName(String agentName) {
        this.agentName = agentName;
    }

    public String getBackupProgramPath() {
        return backupProgramPath;
    }

    public void setBackupProgramPath(String backupProgramPath) {
        this.backupProgramPath = backupProgramPath;
    }

    public String getListProgramPath() {
        return listProgramPath;
    }

    public void setListProgramPath(String listProgramPath) {
        this.listProgramPath = listProgramPath;
    }

    public String getPguser() {
        return pguser;
    }

    public void setPguser(String pguser) {
        this.pguser = pguser;
    }

    public String getRestoreProgramPath() {
        return restoreProgramPath;
    }

    public void setRestoreProgramPath(String restoreProgramPath) {
        this.restoreProgramPath = restoreProgramPath;
    }

    public AgentConfiguration getResourceConfig() {
        return agentConfig;
    }

    public void setResourceConfig(AgentConfiguration agentConfig) {
        this.agentConfig = agentConfig;
    }

    @Override
    public String toString() {
        return "Agent{" + "agentName=" + agentName + "pguser=" + pguser +
                "backupProgramPath=" + backupProgramPath + "restoreProgramPath=" +
                restoreProgramPath + "listProgramPath=" + listProgramPath + '}';
    }


    
}
