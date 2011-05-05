<%-- 
    Document   : clientPage
    Created on : 2011-4-12, 9:23:08
    Author     : lion
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Host Agent Manager Page</title>

        <style type="text/css">
            /*margin and padding on body element
              can introduce errors in determining
              element position and are not recommended;
              we turn them off as a foundation for YUI
              CSS treatments. */
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
            #hostInfo tr,#agentInfo tr,#resourceInfo tr{
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
            <div id="hostInfo">
                <p>主机配置信息</p>
                <div id="hostTable" style="margin-top:10%;margin-left:10%;"></div>
            </div>
            <div id="agentInfo">
                <p>代理配置信息</p>
                <div id="agentTable" style="margin-top:10%;margin-left: 10%"></div>
            </div>
            <div id="resourceInfo">
                <p>资源配置信息</p>
                <div id="resourceTable" style="margin-top:10%;margin-left: 10%"></div>
            </div>
        </div>


        <script type="text/javascript">
            function displayHost(){
                hideComponents(new Array(document.getElementById('agentInfo'),
                    document.getElementById('resourceInfo')));
                document.getElementById('hostInfo').style.display="block";
            }

            function displayAgent(){
                hideComponents(new Array(document.getElementById('hostInfo'),
                    document.getElementById('resourceInfo')));
                document.getElementById('agentInfo').style.display="block";
            }

            function displayResource(){
                hideComponents(new Array(document.getElementById('hostInfo'),
                    document.getElementById('agentInfo')));
                document.getElementById('resourceInfo').style.display="block";
            }

            function hideComponents(comps){
                for(var i=0;i<comps.length;i++){
                    comps[i].style.display="none";
                }
            }

            var hostArr=[];
            var agentArr=[];
            var resourceArr=[];

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
                var oHostIpTr=createTableRow("主机IP",hostInfo.hostIp);
                var oHostPortTr=createTableRow("主机端口",hostInfo.hostPort);
                var oHostPgUserTr=createTableRow("所属用户",hostInfo.pgUser);
                var oHostDescTr=createTableRow("实例描述",hostInfo.hostDesc);
                oTBody.appendChild(oHostNameTr);
                oTBody.appendChild(oHostIpTr);
                oTBody.appendChild(oHostPortTr);
                oTBody.appendChild(oHostPgUserTr);
                oTBody.appendChild(oHostDescTr);

                hostTable.appendChild(oTable);
            }

            function createAgentTable(index){
                displayAgent();
                var agentInfo=agentArr[index];

                var agentTable=document.getElementById('agentTable');
                for(var i=0;i<agentTable.children.length;i++){
                    agentTable.removeChild(agentTable.children[i]);
                }

                var oTable=document.createElement("table");
                oTable.setAttribute("id", "agent");
                oTable.setAttribute("width", "100%");

                var oTBody=document.createElement("tbody");
                oTable.appendChild(oTBody);

                var oHostNameTr=createTableRow("主机名",agentInfo.hostName);
                var oAgentTr=createTableRow("代理名",agentInfo.agentName);
                var oAgentPgUserTr=createTableRow("所属用户",agentInfo.pgUser);
                var oInstallTimeTr=createTableRow("安装时间",agentInfo.installTime);
                var oBackupProgTr=createTableRow("备份程序路径",agentInfo.backupPath);
                var oRestoreProgTr=createTableRow("恢复程序路径",agentInfo.restorePath);
                var oListProgTr=createTableRow("列表程序路径",agentInfo.listPath);

                oTBody.appendChild(oHostNameTr);
                oTBody.appendChild(oAgentTr);
                oTBody.appendChild(oAgentPgUserTr);
                oTBody.appendChild(oInstallTimeTr);
                oTBody.appendChild(oBackupProgTr);
                oTBody.appendChild(oRestoreProgTr);
                oTBody.appendChild(oListProgTr);

                agentTable.appendChild(oTable);
            }

            function createProgTable(index){
                displayResource();
                var prog=resourceArr[index];

                var resourceTable=document.getElementById('resourceTable');
                for(var i=0;i<resourceTable.children.length;i++){
                    resourceTable.removeChild(resourceTable.children[i]);
                }

                var oTable=document.createElement("table");
                oTable.setAttribute("id", "resource");
                oTable.setAttribute("width", "100%");

                var oTBody=document.createElement("tbody");
                oTable.appendChild(oTBody);

                var oHostNameTr=createTableRow("主机名",prog.hostName);
                var oAgentTr=createTableRow("代理名",prog.agentName);
                var oResourceNameTr=createTableRow("资源名",prog.resourceName);
                var oInstValueTr=createTableRow("实例值",prog.instValue);
                var oInstNameTr=createTableRow("实例名",prog.instName);
                var oDefaultVgTr=createTableRow("缺省卷组",prog.defaultVg);
                var oPgUserTr=createTableRow("所属用户",prog.pgUser);
                var oInstDescTr=createTableRow("实例描述",prog.instDesc);

                oTBody.appendChild(oHostNameTr);
                oTBody.appendChild(oAgentTr);
                oTBody.appendChild(oResourceNameTr);
                oTBody.appendChild(oInstValueTr);
                oTBody.appendChild(oInstNameTr);
                oTBody.appendChild(oDefaultVgTr);
                oTBody.appendChild(oPgUserTr);
                oTBody.appendChild(oInstDescTr);

                resourceTable.appendChild(oTable);
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

            function Host(sHostName,sHostIp,iHostPort,sPgUser,sHostDesc){
                var obj=new Object;
                obj.hostName=sHostName;
                obj.hostIp=sHostIp;
                obj.hostPort=iHostPort;
                obj.pgUser=sPgUser;
                obj.hostDesc=sHostDesc;
                return obj;
            }

            function Agent(hostName,agentName,pgUser,backupPath,restorePath,listPath){
                var obj=new Object;
                obj.hostName=hostName;
                obj.agentName=agentName;
                obj.pgUser=pgUser;
                obj.installTime="";
                obj.backupPath=backupPath;
                obj.restorePath=restorePath;
                obj.listPath=listPath;
                return obj;
            }

            function AgentProg(hostName,agentName,resourceName,
                instName,instValue,defaultVg,pgUser,instDesc){
                var obj=new Object;
                obj.hostName=hostName;
                obj.agentName=agentName;
                obj.resourceName=resourceName;
                obj.instName=instName;
                obj.instValue=instValue;
                obj.defaultVg=defaultVg;
                obj.pgUser=pgUser;
                obj.instDesc=instDesc;
                return obj;
            }

            //Wrap our initialization code in an anonymous function
            //to keep out of the global namespace:
            (function(){
                hideComponents(new Array(document.getElementById('hostInfo'),
                    document.getElementById('agentInfo'),document.getElementById('resourceInfo')));
                var init = function() {
                    Test.getRegHostAgents(function(data){
                    
                        //create the TreeView instance:
                        var tree = new YAHOO.widget.TreeView("treediv");

                        //get a reusable reference to the root node:
                        var root = tree.getRoot();

                        var rootNode = new YAHOO.widget.HTMLNode("<label>Host</label>", root, true);
                        var arr=eval('('+data+')');
                        var len=arr.length;
                        for(var i=0;i<len;i++){
                            var host=Host(arr[i].hostName,arr[i].hostIP,arr[i].hostPort,
                                        arr[i].hostPgUser,arr[i].hostDesc);
                            hostArr.push(host);
                         //   var hostNode=new YAHOO.widget.HTMLNode("<label onclick=\"createHostTable(\'"+arr[i].hostName+"\',\'"+arr[i].hostIP+"\',\'"+arr[i].hostPort+"\',\'"+arr[i].hostPgUser+"\',\'"+arr[i].hostDesc+"\')\">"+arr[i].hostName+"</label>",rootNode,true);
                            var hostNode=new YAHOO.widget.HTMLNode("<label onclick=\"createHostTable("+(hostArr.length-1)+")\">"+arr[i].hostName+"</label>",rootNode,true);
                            var agents=eval('('+arr[i].agents+')');

                            for(var j=0;j<agents.length;j++){
                                var agent=Agent(arr[i].hostName,agents[j].agentName,
                                    agents[j].agentPgUser,agents[j].backupProgPath,
                                    agents[j].restoreProgPath,agents[j].listProgPath);
                                agentArr.push(agent);
                                var agentNode=new YAHOO.widget.HTMLNode("<label onclick=\"createAgentTable("+(agentArr.length-1)+")\">"+agents[j].agentName+"</label>",hostNode,true);
                               
                                var agentResource=eval('('+agents[j].resourceConfig+')');
                                var agentProg=AgentProg(arr[i].hostName,agents[j].agentName,
                                    agentResource.resourceName,agentResource.instName,
                                    agentResource.instValue,agentResource.defaultVg,
                                    agents[j].agentPgUser,agentResource.instDesc);
                                resourceArr.push(agentProg);
                                var progNode=new YAHOO.widget.HTMLNode("<label onclick=\"createProgTable("+(resourceArr.length-1)+")\">"+agentProg.instValue+"</label>",agentNode,false);
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

        <!--END SOURCE CODE FOR EXAMPLE =============================== -->

    </body>
</html>
