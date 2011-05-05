/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.viton.model;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author lion
 */
public class Device {
    private String hostId;
    private String name;
    private String type;
    private String path;
    private String desc;
    private String parentName;
    private List<Device> children;

    public Device(){
        children=new ArrayList<Device>();
    }

    public String getHostId() {
        return hostId;
    }

    public void setHostId(String hostId) {
        this.hostId = hostId;
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

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getParentName() {
        return parentName;
    }

    public void setParentName(String parentName) {
        this.parentName = parentName;
    }

    public void addChild(Device dev){
        children.add(dev);
    }

    public List<Device> getChildren(){
        return children;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        final Device other = (Device) obj;
        if(other.getName().equals(name)){
            return true;
        }
        return false;
    }

    @Override
    public int hashCode() {
        int hash = 7;
        hash = 67 * hash + (this.hostId != null ? this.hostId.hashCode() : 0);
        hash = 67 * hash + (this.name != null ? this.name.hashCode() : 0);
        hash = 67 * hash + (this.type != null ? this.type.hashCode() : 0);
        hash = 67 * hash + (this.path != null ? this.path.hashCode() : 0);
        hash = 67 * hash + (this.desc != null ? this.desc.hashCode() : 0);
        hash = 67 * hash + (this.parentName != null ? this.parentName.hashCode() : 0);
        return hash;
    }


}
