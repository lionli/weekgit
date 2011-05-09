/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.viton.util;

import com.viton.model.Agent;
import com.viton.model.AgentConfiguration;
import com.viton.model.BackupResource;
import com.viton.model.Device;
import com.viton.model.Host;
import com.viton.model.Job;
import com.viton.model.VolumeGroup;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import org.json.simple.JSONArray;
import org.json.simple.JSONValue;
import org.json.simple.parser.ContainerFactory;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

/**
 *
 * @author lion
 */
public class JSONUtils {
    public static String hostAgentToJSONString(List<Host> hosts){
        List list=new LinkedList();
        for(Host host:hosts){
            Map item=new LinkedHashMap();
            item.put("hostID", host.getHostId());
            item.put("hostName", host.getHostName());
            item.put("hostIP", host.getHostIp());
            item.put("hostPgUser", host.getPguser());
            item.put("hostPort",host.getHostPort());
            item.put("hostDesc", host.getDesc());
            List agentList=new LinkedList();
            for(Agent agent:host.getAgents()){
                Map agentItem=new LinkedHashMap();
                agentItem.put("agentName", agent.getAgentName());
                agentItem.put("agentPgUser", agent.getPguser());
                agentItem.put("backupProgPath", agent.getBackupProgramPath());
                agentItem.put("restoreProgPath", agent.getRestoreProgramPath());
                agentItem.put("listProgPath", agent.getListProgramPath());
                agentItem.put("description",agent.getDescription());
                Map resourceItem=new LinkedHashMap();
                AgentConfiguration ar=agent.getResourceConfig();
                resourceItem.put("resourceName", ar.getResourceName());
                resourceItem.put("instName", ar.getInstName());
                resourceItem.put("instValue", ar.getInstValue());
                resourceItem.put("defaultVg", ar.getDefaultVg());
                resourceItem.put("instDesc", ar.getInstDescription());
                agentItem.put("resourceConfig", JSONValue.toJSONString(resourceItem));
                agentList.add(agentItem);
            }
            item.put("agents", JSONValue.toJSONString(agentList));
            list.add(item);
        }
        return JSONValue.toJSONString(list);
    }

    public static String hostMediaServerToJSONString(List<Host> hosts){
        List list=new LinkedList();
        for(Host host:hosts){
            Map item=new LinkedHashMap();
            item.put("hostID",host.getHostId());
            item.put("hostName", host.getHostName());
            item.put("hostPgUser", host.getPguser());
            item.put("ipForData", host.getIpForData());
            item.put("hostDesc", host.getDesc());
            List deviceList=new LinkedList();
            for(Device device:host.getDevices()){
                Map devItem=new LinkedHashMap();
                devItem.put("deviceName", device.getName());
                devItem.put("deviceType", device.getType());
                devItem.put("devicePath", device.getPath());
                devItem.put("deviceDesc", device.getDesc());
                deviceList.add(devItem);
            }
            item.put("devices", JSONValue.toJSONString(deviceList));
            List vgList=new LinkedList();
            for(VolumeGroup vg:host.getVolumeGroups()){
                Map vgItem=new LinkedHashMap();
                vgItem.put("vgName", vg.getName());
                vgItem.put("currentVolume", Utils.toString(vg.getCurrentVolume()));
                vgItem.put("vgType", vg.getType());
                vgItem.put("capability", vg.getCapability());
                vgItem.put("used", Utils.toString(vg.getUsed()));
                vgItem.put("desc", Utils.toString(vg.getDesc()));
                vgList.add(vgItem);
            }
            item.put("vgs", JSONValue.toJSONString(vgList));
            list.add(item);
        }
        return JSONValue.toJSONString(list);
    }

    public static String hostToJSONString(Map<String,String> map){
        return encodeMapToJSONString(map,"hostId","hostName");
    }

    public static String agentToJSONString(Map<String,String> map){
        return encodeMapToJSONString(map,"agentName","agentDesc");
    }

    public static String hostAndAgentsToJSONString(Map<String,String> hosts,Map<String,String> agents ){
        String hostJSONString=hostToJSONString(hosts);
        String agentJSONString=agentToJSONString(agents);
        Map map=new LinkedHashMap();
        map.put("hosts", hostJSONString);
        map.put("agents", agentJSONString);
        return JSONValue.toJSONString(map);
    }

    private static String encodeMapToJSONString(Map<String,String> map,
        String keyName,String valueName){
        List list=new LinkedList();
        Set<Entry<String,String>> set=map.entrySet();
        for(Entry<String,String> entry:set){
            Map item=new LinkedHashMap();
            item.put(keyName,entry.getKey());
            item.put(valueName, entry.getValue());
            list.add(item);
        }
        return JSONValue.toJSONString(list);
    }
    
    public static String encodeFileList(List<String> msg){
        List list=new LinkedList();
        for(String fileInfo:msg){
            String fileType=fileInfo.substring(0, 1);
            String fileName=fileInfo.substring(fileInfo.indexOf("\"")+1,fileInfo.lastIndexOf("\""));
            Map item=new LinkedHashMap();
            item.put("filetype", fileType);
            item.put("filename", fileName);
            list.add(item);
        }
   //     System.out.println(JSONValue.toJSONString(list));
        String xx=JSONValue.toJSONString(list);
        return xx;
    }

    public static String encodeBackupResourceToJSONString(BackupResource br){
        Map json=new LinkedHashMap();
        json.put("hostName", br.getHostName());
        List agentList=new LinkedList();
        Collection<String> agents=br.getAgentNames();
        for(String agent:agents){
            Map agentMap=new LinkedHashMap();
            agentMap.put("agentName", agent);
            List resourceList=new LinkedList();
            Map<String,String> resourceMap=br.getAgentBackupResource(agent);
            for(Entry<String,String> resourceEntry:resourceMap.entrySet()){
                Map resourceItem=new LinkedHashMap();
                resourceItem.put("backupSetId", resourceEntry.getKey());
                resourceItem.put("backupSetName", resourceEntry.getValue());
                resourceList.add(resourceItem);
            }
            agentMap.put("backupResource", JSONValue.toJSONString(resourceList));
            agentList.add(agentMap);
        }
        json.put("agents", JSONValue.toJSONString(agentList));

        String xx=JSONValue.toJSONString(json);
    //    System.out.println(xx);
        return xx;
    }

    public static class MyContainerFactory implements ContainerFactory{

        @Override
        public Map createObjectContainer() {
            return new LinkedHashMap();
        }

        @Override
        public List creatArrayContainer() {
            return new LinkedList();
        }
    }

    public static Map<String,String> parseAgentInfo(String jsonText) throws Exception{
        JSONParser parser=new JSONParser();
        return (Map)parser.parse(jsonText,new MyContainerFactory());
    }

    public static Map<String,String> parseJSON(String jsonText) throws Exception{
        JSONParser parser=new JSONParser();
        return (Map)parser.parse(jsonText,new MyContainerFactory());
    }

    public static List<Map<String,String>> parseFileNode(String fileNodeJSON) throws Exception{
        List<Map<String,String>> list=new ArrayList<Map<String,String>>();
        JSONParser parser=new JSONParser();
        Object obj=parser.parse(fileNodeJSON);
        JSONArray arr=(JSONArray)obj;
        for(int i=0;i<arr.size();i++){
            Map<String,String> info=parseJSON(arr.get(i).toString());
            list.add(info);
        }
        return list;
    }

    public static String encodingJob(List<Job> jobs) throws Exception{
        List jobList=new LinkedList();
        return JSONValue.toJSONString(jobList);
    }
}
