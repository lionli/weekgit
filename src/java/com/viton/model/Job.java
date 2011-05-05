/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.viton.model;

/**
 *
 * @author lion
 */
public class Job {
    private String hostName;
    private String agentType;
    private String jobName;
    private String jobType;
    private String startTime;
    private String executionTime;
    private String jobStatus;
    private String preRunTime;
    private String nextRunTime;
    private String firstRunTime;

    public String getAgentType() {
        return agentType;
    }

    public void setAgentType(String agentType) {
        this.agentType = agentType;
    }

    public String getExecutionTime() {
        return executionTime;
    }

    public void setExecutionTime(String executionTime) {
        this.executionTime = executionTime;
    }

    public String getFirstRunTime() {
        return firstRunTime;
    }

    public void setFirstRunTime(String firstRunTime) {
        this.firstRunTime = firstRunTime;
    }

    public String getHostName() {
        return hostName;
    }

    public void setHostName(String hostName) {
        this.hostName = hostName;
    }

    public String getJobName() {
        return jobName;
    }

    public void setJobName(String jobName) {
        this.jobName = jobName;
    }

    public String getJobStatus() {
        return jobStatus;
    }

    public void setJobStatus(String jobStatus) {
        this.jobStatus = jobStatus;
    }

    public String getJobType() {
        return jobType;
    }

    public void setJobType(String jobType) {
        this.jobType = jobType;
    }

    public String getNextRunTime() {
        return nextRunTime;
    }

    public void setNextRunTime(String nextRunTime) {
        this.nextRunTime = nextRunTime;
    }

    public String getPreRunTime() {
        return preRunTime;
    }

    public void setPreRunTime(String preRunTime) {
        this.preRunTime = preRunTime;
    }

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }
}
