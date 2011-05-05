/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.viton.util;

import java.io.BufferedOutputStream;
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
        doc.addElement("FixedDrives").addAttribute("id", "FixedDrives")
                .addAttribute("Value","Fixed Drives").addAttribute("NodeType", "FixedDrives")
                .addAttribute("NodeStatus", "121").addAttribute("NodeIcon", "11");
        addElement(doc,fileSelection);
        OutputFormat format=OutputFormat.createPrettyPrint();
        StringWriter sw=new StringWriter();
        XMLWriter writer=new XMLWriter(sw,format);
        writer.write(doc);
        return sw.toString();
    }

    private static void addElement(Document doc,Map<String,Map<String,String>> nodes){
        Set<String> nodeNames=nodes.keySet();
        for(String nodeName:nodeNames){
            addElement(doc,nodes,nodeName);
        }
    }

    private static void addElement(Document doc,Map<String,Map<String,String>> nodes,
            String nodeId){
        if(doc.elementByID(nodeId)!=null){
            Map<String,String> node=nodes.get(nodeId);
            String nodeParentId=node.get("fileParent");
            Element parentElement=doc.elementByID(nodeParentId);
            if(parentElement==null){
                addElement(doc,nodes,nodeParentId);
            }else{
                String nodeType=node.get("fileType");
                String nodeStatus=nodeType.equals("d")?"121":"011";
                parentElement.addElement(nodeType).addAttribute("id", nodeId)
                        .addAttribute("Value", nodeId).addAttribute("NodeType", nodeType)
                        .addAttribute("NodeStatus", nodeStatus).addAttribute("NodeIcon", "0");
            }
        }
    }
}
