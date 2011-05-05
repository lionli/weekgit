/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.viton.model;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author lion
 */
public class BackupResource {

    private String hostName;
    private Map<String, Map<String, String>> agentBackupResource;

    public BackupResource() {
        agentBackupResource = new HashMap<String, Map<String, String>>();
    }

    public void addAgent(String agentName){
        agentBackupResource.put(agentName,new HashMap<String,String>());
    }

    public Map<String, String> getAgentBackupResource(String agentName) {
        if (!agentBackupResource.containsKey(agentName)) {
            addAgent(agentName);
        }
        return agentBackupResource.get(agentName);
    }

    public Collection<String> getAgentNames(){
        return agentBackupResource.keySet();
    }

    public String getHostName() {
        return hostName;
    }

    public void setHostName(String hostName) {
        this.hostName = hostName;
    }
}
