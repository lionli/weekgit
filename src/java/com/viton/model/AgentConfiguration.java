/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.viton.model;

/**
 *
 * @author lion
 */
public class AgentConfiguration {
    private String resourceName;
    private String instName;
    private String instValue;
    private String defaultVg;
    private String instDescription;

    public String getDefaultVg() {
        return defaultVg;
    }

    public void setDefaultVg(String defaultVg) {
        this.defaultVg = defaultVg;
    }

    public String getInstDescription() {
        return instDescription;
    }

    public void setInstDescription(String instDescription) {
        this.instDescription = instDescription;
    }

    public String getInstName() {
        return instName;
    }

    public void setInstName(String instName) {
        this.instName = instName;
    }

    public String getInstValue() {
        return instValue;
    }

    public void setInstValue(String instValue) {
        this.instValue = instValue;
    }

    public String getResourceName() {
        return resourceName;
    }

    public void setResourceName(String resourceName) {
        this.resourceName = resourceName;
    }
}
