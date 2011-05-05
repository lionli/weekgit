/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.viton.model;

import java.util.Date;

/**
 *
 * @author lion
 */
public class VitonLog {
    private String logType;
    private String jobName;
    private String agentType;
    private Date recordTime;
    private String logInfo;

    public String getAgentType() {
        return agentType;
    }

    public void setAgentType(String agentType) {
        this.agentType = agentType;
    }

    public String getJobName() {
        return jobName;
    }

    public void setJobName(String jobName) {
        this.jobName = jobName;
    }

    public String getLogInfo() {
        return logInfo;
    }

    public void setLogInfo(String logInfo) {
        this.logInfo = logInfo;
    }

    public String getLogType() {
        return logType;
    }

    public void setLogType(String logType) {
        this.logType = logType;
    }

    public Date getRecordDate() {
        return recordTime;
    }

    public void setRecordDate(Date recordTime) {
        this.recordTime = recordTime;
    }

    
}
