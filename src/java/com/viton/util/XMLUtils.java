/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.viton.util;

import java.io.BufferedOutputStream;
import java.io.IOException;
import java.io.StringWriter;
import java.util.Map;
import java.util.Set;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.XMLWriter;

/**
 *
 * @author lion
 */
public class XMLUtils {
    public static String createFileSelectionSet(Map<String,Map<String,String>> fileSelection) throws Exception{
        Document doc=DocumentHelper.createDocument();
        Element root=doc.addElement("FixedDrives").addAttribute("id", "FixedDrives")
                .addAttribute("Value","Fixed Drives").addAttribute("NodeType", "FixedDrives")
                .addAttribute("NodeStatus", "121").addAttribute("NodeIcon", "11");
        addElement(root,"FixedDrives",fileSelection);
        return outputDocument(doc);
    }

    private static String outputDocument(Document document) throws IOException{
        OutputFormat format=OutputFormat.createPrettyPrint();
        StringWriter sw=new StringWriter();
        XMLWriter writer=new XMLWriter(sw,format);
        writer.write(document);
        return sw.toString();
    }

    private static void addElement(Element parent,String parentId,
            Map<String,Map<String,String>> nodes){
        Set<String> nodeNames=nodes.keySet();
        for(String nodeName:nodeNames){
            Map<String,String> node=nodes.get(nodeName);
            if(node.get("fileParent").equals(parentId)){
                String nodePath=node.get("filePath");
                String nodeType=node.get("fileType");
                String nodeStatus=nodeType.equals("d")?"121":"011";
                Element el=parent.addElement(nodeType).addAttribute("id", nodePath)
                        .addAttribute("Value", nodePath).addAttribute("NodeType", nodeType)
                        .addAttribute("NodeStatus", nodeStatus).addAttribute("NodeIcon", "0");
              //  nodes.remove(nodeName);
                addElement(el,nodePath,nodes);
            }
        }
    }

    public static String createFileOptionSet(Map<String,String> map) throws IOException{
        Document doc=DocumentHelper.createDocument();
        Element root=doc.addElement("backupOption");
        root.addElement("BackupLevel").addAttribute("Level", map.get("backupLevel"));
        root.addElement("BackupType").addAttribute("Value", map.get("backupType"));
        root.addElement("CompressionLevel").addAttribute("Value",map.get("compressLevel"));
        return outputDocument(doc);
    }

    public static String createScheduleSet(Map<String,String> map) throws Exception{
        Document doc=DocumentHelper.createDocument();
        Element root=doc.addElement("ScheduleSet");
        String scheduleType=map.get("scheduleType");
        root.addElement("ScheduleType").addAttribute("Value", map.get("scheduleType"));
        if(!scheduleType.equals("immedidate")){
            String dateTime=map.get("scheduleTime");
            String date=dateTime.substring(0, dateTime.indexOf(" "));
            String time=dateTime.substring(dateTime.indexOf(" ")+1);
            root.addElement("ScheduleTime").addAttribute("Time", time).addAttribute("Date", date);
            if(scheduleType.equals("repeating")){
                String scheduleMethod=map.get("scheduleMethod");
                root.addElement("Method").addAttribute("Value", scheduleMethod);
                if(!scheduleMethod.equals("EveryDay")){
                    Element optionElement=root.addElement("MethodOptions").addAttribute("Value", map.get("methodValues"));
                    if(scheduleMethod.equals("DaysOfMonth")){
                        optionElement.addAttribute("Type", "month").addAttribute("Week","null");
                    }
                }
            }
        }
        return outputDocument(doc);
    }

    public static String createTargetSet(Map<String,String> map) throws Exception{
        Document doc=DocumentHelper.createDocument();
        Element root=doc.addElement("TargetSet");
        root.addElement("Media").addAttribute("Type", map.get("mediaType"))
                .addAttribute("Value", map.get("mediaValue"));
        return outputDocument(doc);
    }
}
