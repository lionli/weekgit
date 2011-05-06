/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.viton.service;

import com.viton.util.JSONUtils;
import com.viton.util.XMLUtils;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author lion
 */
public class BackupService {
    public String getFileBackupSelectionSet(String text) throws Exception{
        List<Map<String,String>> list=JSONUtils.parseFileNode(text);
        Map<String,Map<String,String>> map=new HashMap<String,Map<String,String>>();
        for(Map<String,String> tmp:list){
            map.put(tmp.get("filePath"), tmp);
        }
        String xml=XMLUtils.createFileSelectionSet(map);
        return xml;
    }

    public String getFileBackupOptionSet(String text) throws Exception{
        Map<String,String> jsonObj=JSONUtils.parseJSON(text);
        String xml=XMLUtils.createFileOptionSet(jsonObj);
        return xml;
    }

    public String getFileBackupScheduleSet(String text) throws Exception{
        Map<String,String> jsonObj=JSONUtils.parseJSON(text);
        String xml=XMLUtils.createScheduleSet(jsonObj);
        return xml;
    }

    public String getFileBackupTargetSet(String text) throws Exception{
        Map<String,String> jsonObj=JSONUtils.parseJSON(text);
        String xml=XMLUtils.createTargetSet(jsonObj);
        return xml;
    }
}
