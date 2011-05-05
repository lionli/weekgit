/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.viton.util;

import com.viton.model.VitonLog;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import org.json.simple.JSONValue;

/**
 *
 * @author lion
 */
public class Utils {
    public static String toJSArray(List<String> list){
        String[] arr=list.toArray(new String[0]);
        StringBuilder sb=new StringBuilder();
        sb.append("[");
        for(int i=0;i<arr.length-1;i++){
            sb.append("\"").append(arr[i]).append("\",");
        }
        if(arr.length!=0)
            sb.append("\"").append(arr[arr.length-1]).append("\"");
        sb.append("]");
        return sb.toString();
    }

    public static String toString(String value){
        return value==null?"":value;
    }
}
