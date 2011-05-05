/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.viton.model;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

/**
 *
 * @author lion
 */
public class Host {
    private final String hostId;
    private String hostName;
    private String hostIp;
    private int hostPort;
    private String pguser;
    private String desc;
    private String ipForData;

    private List<Agent> agents;
    private List<Device> devices;
    private List<VolumeGroup> vgs;

    public Host(String hostId){
        agents=new ArrayList<Agent>();
        devices=new ArrayList<Device>();
        vgs=new ArrayList<VolumeGroup>();
        this.hostId=hostId;
    }

    public String getIpForData() {
        return ipForData;
    }

    public void setIpForData(String ipForData) {
        this.ipForData = ipForData;
    }

    public String getHostId() {
        return hostId;
    }

    public String getDesc() {
        return desc;
    }

    public void setDesc(String desc) {
        this.desc = desc;
    }

    public String getHostIp() {
        return hostIp;
    }

    public void setHostIp(String hostIp) {
        this.hostIp = hostIp;
    }

    public String getHostName() {
        return hostName;
    }

    public void setHostName(String hostName) {
        this.hostName = hostName;
    }

    public int getHostPort() {
        return hostPort;
    }

    public void setHostPort(int hostPort) {
        this.hostPort = hostPort;
    }

    public String getPguser() {
        return pguser;
    }

    public void setPguser(String pguser) {
        this.pguser = pguser;
    }

    public void addAgent(Agent agent){
        agents.add(agent);
    }

    public List<Agent> getAgents(){
        return agents;
    }

    public void addDevice(Device device){
        devices.add(device);
    }

    public List<Device> getDevices(){
        return devices;
    }

    public void addVolumeGroup(VolumeGroup vg){
        vgs.add(vg);
    }

    public List<VolumeGroup> getVolumeGroups(){
        return vgs;
    }
    
    @Override
    public boolean equals(Object obj){
        if(obj==null)
            return false;
        if(obj==this)
            return true;
        if(!(obj instanceof Host))
            return false;
        Host other=(Host)obj;
        if(other.hostId.equals(hostId))
            return true;
        return false;
    }

    @Override
    public int hashCode() {
        int hash = 7;
        hash = 89 * hash + (this.hostId != null ? this.hostId.hashCode() : 0);
        return hash;
    }

    @Override
    public String toString() {
        return "Host{" + "hostId=" + hostId + "hostName=" + hostName +
                "hostIp=" + hostIp + "hostPort=" + hostPort + "pguser=" +
                pguser + "desc=" + desc + '}';
    }

}
