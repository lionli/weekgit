/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.viton.model;

/**
 *
 * @author lion
 */
public class VolumeGroup {

    private String hostId;
    private String vgid;
    private String name;
    private String currentVolume;
    private String type;
    private String capability;
    private String used;
    private String desc;

    public String getHostId() {
        return hostId;
    }

    public void setHostId(String hostId) {
        this.hostId = hostId;
    }

    public String getVgid() {
        return vgid;
    }

    public void setVgid(String vgid) {
        this.vgid = vgid;
    }

    public String getCapability() {
        return capability;
    }

    public void setCapability(String capability) {
        this.capability = capability;
    }

    public String getCurrentVolume() {
        return currentVolume;
    }

    public void setCurrentVolume(String currentVolume) {
        this.currentVolume = currentVolume;
    }

    public String getDesc() {
        return desc;
    }

    public void setDesc(String desc) {
        this.desc = desc;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getUsed() {
        return used;
    }

    public void setUsed(String used) {
        this.used = used;
    }
}
