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
public class FileInfo {
    private String fileName;
    private String fileType;
    private List<FileInfo> children;

    public FileInfo(String fileName,String fileType){
        this.fileName=fileName;
        this.fileType=fileType;
        children=new ArrayList<FileInfo>();
    }

 /**   public FileInfo(String filePath){
        if(filePath.isEmpty()){
            throw new IllegalArgumentException("Illegal file name");
        }
        String[] sub=filePath.split("[/ ]");
        fileName=sub[0];
        fileType=sub.length>1?"d":"f";
        if(fileType.equals("d")){
            children=new ArrayList<FileInfo>();
            StringBuilder sb=new StringBuilder();
            for(int i=1;i<sub.length-2;i++){
                sb.append(sub[i]).append("/");
            }
            sb.append(sub[sub.length-1]);
            children.add(new FileInfo(sb.toString()));
        }
    }*/

    public void addChild(FileInfo fileInfo){
        children.add(fileInfo);
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getFileType() {
        return fileType;
    }

    public void setFileType(String fileType) {
        this.fileType = fileType;
    }

    
}
