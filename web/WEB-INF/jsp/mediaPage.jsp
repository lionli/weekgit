<%-- 
    Document   : mediaPage
    Created on : 2011-3-22, 22:52:40
    Author     : lion
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Media Page</title>
        <style type="text/css">
        body {
                margin:0;
                padding:0;
            }
            #toggle {
                text-align: center;
                padding: 1em;
            }
            #toggle a {
                padding: 0 5px;
                border-left: 1px solid black;
            }
            #tRight {
                border-left: none !important;
            }
            </style>
            <link rel="stylesheet" type="text/css" href="build/fonts/fonts-min.css" />
        <link rel="stylesheet" type="text/css" href="build/treeview/assets/skins/sam/treeview.css" />
        <link rel="stylesheet" type="text/css" href="build/reset-fonts-grids/reset-fonts-grids.css" />
        <link rel="stylesheet" type="text/css" href="build/resize/assets/skins/sam/resize.css" />
        <link rel="stylesheet" type="text/css" href="build/layout/assets/skins/sam/layout.css" />
        <link rel="stylesheet" type="text/css" href="build/button/assets/skins/sam/button.css" />

        <script type="text/javascript" src="build/yahoo-dom-event/yahoo-dom-event.js"></script>
        <script type="text/javascript" src="build/treeview/treeview-min.js"></script>
        <script type="text/javascript" src="build/yahoo/yahoo-min.js"></script>
        <script type="text/javascript" src="build/event/event-min.js"></script>
        <script type="text/javascript" src="build/dom/dom-min.js"></script>
        <script type="text/javascript" src="build/element/element-min.js"></script>
        <script type="text/javascript" src="build/dragdrop/dragdrop-min.js"></script>
        <script type="text/javascript" src="build/resize/resize-min.js"></script>
        <script type="text/javascript" src="build/animation/animation-min.js"></script>
        <script type="text/javascript" src="build/layout/layout-min.js"></script>

        <!--begin custom header content for this example-->
        <!--Bring in the folder-style TreeView CSS:-->
        <link rel="stylesheet" type="text/css" href="assets/css/folders/tree.css"/>

        <!--Additional custom style rules for this example:-->
        <style type="text/css">
            #treewrapper {background: #fff; position:relative;}
            #treediv {position:relative; width:250px; background: #fff; padding:1em;}
            .icon-ppt { display:block; height: 22px; padding-left: 20px; background: transparent url(assets/img/icons.png) 0 0px no-repeat; }
            .icon-dmg { display:block; height: 22px; padding-left: 20px; background: transparent url(assets/img/icons.png) 0 -36px no-repeat; }
            .icon-prv { display:block; height: 22px; padding-left: 20px; background: transparent url(assets/img/icons.png) 0 -72px no-repeat; }
            .icon-gen { display:block; height: 22px; padding-left: 20px; background: transparent url(assets/img/icons.png) 0 -108px no-repeat; }
            .icon-doc { display:block; height: 22px; padding-left: 20px; background: transparent url(assets/img/icons.png) 0 -144px no-repeat; }
            .icon-jar { display:block; height: 22px; padding-left: 20px; background: transparent url(assets/img/icons.png) 0 -180px no-repeat; }
            .icon-zip { display:block; height: 22px; padding-left: 20px; background: transparent url(assets/img/icons.png) 0 -216px no-repeat; }
            .htmlnodelabel { margin-left: 20px; }

            #hostInfo tr,#deviceInfo tr,#vgInfo tr{
                height:50px;
            }
        </style>

        <script type="text/javascript" src="dwr/engine.js"></script>
        <script type="text/javascript" src="dwr/util.js"></script>
        <script type="text/javascript" src="dwr/interface/Test.js"></script>

    </head>
    <body class=" yui-skin-sam">
        <div id="left1">
            <div id="treewrapper">
                <div id="treediv"> </div>
            </div>
        </div>
        <div id="center1" style="font-size:1.5em">
            <div id="hostInfo" style="display:none">
                <p>主机信息</p>
                <div id="hostTable" style="margin-top:10%;margin-left: 10%"></div>
            </div>
            <div id="deviceInfo" style="display:none">
                <p>设备信息</p>
                <div id="deviceTable" style="margin-top:10%;margin-left: 10%"></div>
            </div>
            <div id="vgInfo" style="display:none">
                <p>卷组信息</p>
                <div id="vgTable" style="margin-top:10%;margin-left: 10%"></div>
            </div>
        </div>


        <script type="text/javascript">
            var hostArr=[];
            var deviceArr=[];
            var volumeGroupArr=[];
            
            function displayHost(){
                hideComponents(new Array(document.getElementById('deviceInfo'),
                    document.getElementById('vgInfo')));
                document.getElementById('hostInfo').style.display="block";
            }

            function displayDevice(){
                hideComponents(new Array(document.getElementById('hostInfo'),
                    document.getElementById('vgInfo')));
                document.getElementById('deviceInfo').style.display="block";
            }

            function displayVolumeGroup(){
                hideComponents(new Array(document.getElementById('hostInfo'),
                    document.getElementById('deviceInfo')));
                document.getElementById('vgInfo').style.display="block";
            }

            function hideComponents(comps){
                for(var i=0;i<comps.length;i++){
                    comps[i].style.display="none";
                }
            }

        /**    function Host(sHostName,sHostIp,iHostPort,sHostDesc){
                this.hostName=sHostName;
                this.hostIp=sHostIp;
                this.hostPort=iHostPort;
                this.hostDesc=sHostDesc;
            }*/

            function host(sHostName,sPgUser,sHostIpForData,sHostDesc){
                var obj=new Object;
                obj.hostName=sHostName;
                obj.hostIpForData=sHostIpForData;
                obj.pgUser=sPgUser;
                obj.hostDesc=sHostDesc;
                return obj;
            }

            function device(sDeviceName,sDeviceType,sDevicePath,sDeviceDesc){
                var obj=new Object;
                obj.deviceName=sDeviceName;
                obj.deviceType=sDeviceType;
                obj.devicePath=sDevicePath;
                obj.deviceDesc=sDeviceDesc;
                return obj;
            }

            function volumeGroup(sVgName,sCurrentVolume,sVgType,sCapability,sUsed,sDesc){
                var obj=new Object;
                obj.vgName=sVgName;
                obj.currentVolume=sCurrentVolume;
                obj.vgType=sVgType;
                obj.capability=sCapability;
                obj.used=sUsed;
                obj.vgDescription=sDesc;
                return obj;
            }

            function createHostTable(index){
                displayHost();
                var hostInfo=hostArr[index];
                var hostTable=document.getElementById('hostTable');
                for(var i=0;i<hostTable.children.length;i++){
                    hostTable.removeChild(hostTable.children[i]);
                }

                var oTable=document.createElement("table");
                oTable.setAttribute("id", "host");
                oTable.setAttribute("width", "100%");

                var oTBody=document.createElement("tbody");
                oTable.appendChild(oTBody);

                var oHostNameTr=createTableRow("主机名",hostInfo.hostName);
                var oHostPgUserTr=createTableRow("数据库用户",hostInfo.pgUser);
                var oHostIpForDataTr=createTableRow("用于数据传输的IP",hostInfo.hostIpForData);
                var oHostDescTr=createTableRow("描述",hostInfo.hostDesc);
                oTBody.appendChild(oHostNameTr);
                oTBody.appendChild(oHostPgUserTr);
                oTBody.appendChild(oHostIpForDataTr);
                oTBody.appendChild(oHostDescTr);

                document.getElementById("hostTable").appendChild(oTable);

            }

            function createDeviceTable(index){
                displayDevice();
                var deviceInfo=deviceArr[index];
                var deviceTable=document.getElementById('deviceTable');
                for(var i=0;i<deviceTable.children.length;i++){
                    deviceTable.removeChild(deviceTable.children[i]);
                }

                var oTable=document.createElement("table");
                oTable.setAttribute("id", "device");
                oTable.setAttribute("width", "100%");

                var oTBody=document.createElement("tbody");
                oTable.appendChild(oTBody);

                var oDeviceNameTr=createTableRow("设备名",deviceInfo.deviceName);
                var oDeviceTypeTr=createTableRow("设备类型",deviceInfo.deviceType);
                var oDevicePathTr=createTableRow("路径",deviceInfo.devicePath);
                var oDeviceDescTr=createTableRow("描述",deviceInfo.deviceDesc);
                oTBody.appendChild(oDeviceNameTr);
                oTBody.appendChild(oDeviceTypeTr);
                oTBody.appendChild(oDevicePathTr);
                oTBody.appendChild(oDeviceDescTr);

                deviceTable.appendChild(oTable);
            }

            function createVgTable(index){
                displayVolumeGroup();
                var vgInfo=volumeGroupArr[index];
                var vgTable=document.getElementById('vgTable');
                for(var i=0;i<vgTable.children.length;i++){
                    vgTable.removeChild(vgTable.children[i]);
                }

                var oTable=document.createElement("table");
                oTable.setAttribute("id", "volumegroup");
                oTable.setAttribute("width", "100%");

                var oTBody=document.createElement("tbody");
                oTable.appendChild(oTBody);

                var oVgNameTr=createTableRow("卷组名",vgInfo.vgName);
                var oCurrentVolumeTr=createTableRow("当前卷",vgInfo.currentVolume);
                var oVgTypeTr=createTableRow("卷组类型",vgInfo.vgType);
                var oCapabilityTr=createTableRow("总空间",vgInfo.capability);
                var oUsedTr=createTableRow("已用空间",vgInfo.used);
                var oVgDescTr=createTableRow("描述",vgInfo.vgDescription);
                oTBody.appendChild(oVgNameTr);
                oTBody.appendChild(oCurrentVolumeTr);
                oTBody.appendChild(oVgTypeTr);
                oTBody.appendChild(oCapabilityTr);
                oTBody.appendChild(oUsedTr);
                oTBody.appendChild(oVgDescTr);

                vgTable.appendChild(oTable);

            }
            function createTableRow(name,value){
                var oTR=document.createElement("tr");
                var oTD1=document.createElement("td");
                oTD1.appendChild(document.createTextNode(name));
                oTR.appendChild(oTD1);
                var oTD2=document.createElement("td");
                oTD2.appendChild(document.createTextNode(value));
                oTR.appendChild(oTD2);
                return oTR;
            }

            //Wrap our initialization code in an anonymous function
            //to keep out of the global namespace:
            (function(){
                var init = function() {
                    Test.getRegMediaServers(function(data){

                        //create the TreeView instance:
                        var tree = new YAHOO.widget.TreeView("treediv");

                        //get a reusable reference to the root node:
                        var root = tree.getRoot();

                        var rootNode = new YAHOO.widget.HTMLNode("<label>Host</label>", root, true);
                        var arr=eval('('+data+')');
                        var len=arr.length;
                        for(var i=0;i<len;i++){
                            var hostInfo=host(arr[i].hostName,arr[i].hostPgUser,arr[i].ipForData,arr[i].hostDesc);
                            hostArr.push(hostInfo);
                            var hostNode=new YAHOO.widget.HTMLNode("<label onclick=\"createHostTable("+(hostArr.length-1)+")\">"+arr[i].hostName+"</label>",rootNode,true);
                            var deviceRootNode=new YAHOO.widget.HTMLNode("Device",hostNode,false);
                            var vgRootNode=new YAHOO.widget.HTMLNode("VolumeGroup",hostNode,false);
                            var devices=eval('('+arr[i].devices+')');
                            for(var j=0;j<devices.length;j++){
                                var deviceInfo=device(devices[j].deviceName,devices[j].deviceType,devices[j].devicePath,devices[j].deviceDesc);
                                deviceArr.push(deviceInfo);
                                var deviceNode=new YAHOO.widget.HTMLNode("<label onclick=\"createDeviceTable("+(deviceArr.length-1)+")\">"+devices[j].deviceName+"</label>",deviceRootNode,true);
                            }

                            var vgs=eval('('+arr[i].vgs+')');
                            for(var j=0;j<vgs.length;j++){
                                var vgInfo=volumeGroup(vgs[j].vgName,vgs[j].currentVolume,vgs[j].vgType,vgs[j].capability,vgs[j].used,vgs[j].desc);
                                volumeGroupArr.push(vgInfo);
                                var vgNode=new YAHOO.widget.HTMLNode("<label onclick=\"createVgTable("+(volumeGroupArr.length-1)+")\">"+vgs[j].vgName+"</label>",vgRootNode,false);
                            }
                        }
                        tree.draw();
                    });

                }
                YAHOO.util.Event.onDOMReady(init);
            })();

            (function() {
                var Dom = YAHOO.util.Dom,
                Event = YAHOO.util.Event;

                Event.onDOMReady(function() {
                    var layout = new YAHOO.widget.Layout({
                        units: [
                            { position: 'left', width: 350, resize: true, body: 'left1', gutter: '5px', collapse: true, collapseSize: 30, scroll: true, animate: true },
                            { position: 'center', body: 'center1' }
                        ]
                    });

                    layout.render();

                });
            })();
        </script>
    </body>
</html>
