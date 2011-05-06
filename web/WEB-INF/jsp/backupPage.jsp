<%-- 
    Document   : backupPage
    Created on : 2011-4-14, 13:45:03
    Author     : lion
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Backup Page</title>
        <style type="text/css">
            body{
                margin:0;
                padding:0;
            }
        </style>

        <link rel="stylesheet" type="text/css" href="build/fonts/fonts-min.css"/>
        <link rel="stylesheet" type="text/css" href="build/tabview/assets/skins/sam/tabview.css"/>
        <link rel="stylesheet" type="text/css" href="build/layout/assets/skins/sam/layout.css" />
        <link rel="stylesheet" type="text/css" href="js/css/smoothness/jquery-ui-1.7.2.custom.css">
        <link rel="stylesheet" type="text/css" href="assets/dpSyntaxHighlighter.css">
        <!--Script and CSS includes for YUI dependencies on this page-->
        <link rel="stylesheet" type="text/css" href="build/logger/assets/skins/sam/logger.css" />
        <link rel="stylesheet" type="text/css" href="build/treeview/assets/skins/sam/treeview.css" />
        <link rel="stylesheet" type="text/css" href="build/button/assets/skins/sam/button.css" />
        <link rel="stylesheet" type="text/css" href="build/container/assets/skins/sam/container.css"/>

        <script type="text/javascript" src="build/yahoo-dom-event/yahoo-dom-event.js"></script>
        <script type="text/javascript" src="build/element/element-min.js"></script>
        <script type="text/javascript" src="build/tabview/tabview-min.js"></script>
        <script type="text/javascript" src="build/yuiloader/yuiloader-min.js"></script>
        <script type="text/javascript" src="build/event/event-min.js"></script>
        <script type="text/javascript" src="build/dom/dom-min.js"></script>
        <script type="text/javascript" src="build/logger/logger-min.js"></script>
        <script type="text/javascript" src="build/treeview/treeview-debug.js"></script>
        <script type="text/javascript" src="build/button/button-min.js"></script>
        <script type="text/javascript" src="build/yahoo/yahoo-min.js"></script>
        <script type="text/javascript" src="build/dom/dom-min.js"></script>
        <script type="text/javascript" src="build/animation/animation-min.js"></script>
        <script type="text/javascript" src="build/layout/layout-min.js"></script>
        <script type="text/javascript" src="build/container/container-min.js"></script>

        <script type="text/javascript" src="assets/js/TaskNode.js"></script>

        <style type="text/css">
            .yui-navset-left .yui-nav li,
            .yui-navset-right .yui-nav li{
                margin:0 0 0 .5em;
            }
            .ygtvcheck0 { background: url(assets/img/check/check0.gif) 0 0 no-repeat; width:16px; cursor:pointer }
            .ygtvcheck1 { background: url(assets/img/check/check1.gif) 0 0 no-repeat; width:16px; cursor:pointer }
            .ygtvcheck2 { background: url(assets/img/check/check2.gif) 0 0 no-repeat; width:16px; cursor:pointer }

            #controlButtonPanel{
                float:right;
            }
            .ui-timepicker-div .ui-widget-header{ margin-bottom: 8px; }
            .ui-timepicker-div dl{ text-align: left; }
            .ui-timepicker-div dl dt{ height: 25px; }
            .ui-timepicker-div dl dd{ margin: -25px 0 10px 65px; }
            .ui-timepicker-div td { font-size: 90%; }

            #loginDialog label{
                display:block;
                float:left;
                width:30%;
                clear: left;
}

        </style>
        <script type="text/javascript" src="dwr/engine.js"></script>
        <script type="text/javascript" src="dwr/util.js"></script>
        <script type="text/javascript" src="dwr/interface/Test.js"></script>
        <script type="text/javascript" src="dwr/interface/SshService.js"></script>
        <script type="text/javascript" src="dwr/interface/BackupService.js"></script>
        <script type="text/javascript">
            Agent=function(hostid,agentname,osname,ospassword,port){
                this.hostid=hostid;
                this.agentname=agentname;
                this.osusername=osname;
                this.ospassword=ospassword;
                this.port=port;
            };

            function agentLaunch(hostid,agentname,osname,ospassword,port){
                //     var agentJSON="{\"hostid\":\"012cd863-9853-4c7d-aaa1-eeb617434575\",\"agentname\":\"ext2-lnx-agent\",\"osusername\":\"root\",\"ospassword\":\"lionli\", \"port\":\"22\"}";
                var xx=new Agent("012cd863-9853-4c7d-aaa1-eeb617434575",
                "ext2-lnx-agent","root","lionli","22");
                Test.getFileList(constructAgentJSON(xx),function(data){
                    alert(data);
                });
            }

            function constructAgentJSON(agentInfo){
                var jsonText="{"+makePair("hostid",agentInfo.hostid)+","
                    +makePair("agentname",agentInfo.agentname)+","
                    +makePair("osusername",agentInfo.osusername)+","
                    +makePair("ospassword",agentInfo.ospassword)+","
                    +makePair("port",agentInfo.port)+"}";
                return jsonText;
            }

            function makePair(name,value){
                return "\""+name+"\":\""+value+"\"";
            }

            var tree;
            var nodes = [];
            var nodeIndex;

            var osUserName="root";
            var osPassword="lionli";
            var osPort="22";
            
            function drawTree(){
                var hostBox=document.getElementById('hostSelection');
                var agentBox=document.getElementById('agentSelection');
                var selectedHost=hostBox.options[hostBox.selectedIndex].value;
                var selectedAgent=agentBox.options[agentBox.selectedIndex].value;

                var xx=new Agent(selectedHost,selectedAgent,osUserName,osPassword,osPort);

                Test.getFileList(constructAgentJSON(xx),function(data){
                    var fileList=eval('('+data+')');

                    tree = new YAHOO.widget.TreeView("treeDiv1");
                    var rootNode=tree.getRoot();
                    var hostNode=new YAHOO.widget.TaskNode("Local drivers",rootNode,true);
                    var len=fileList.length;
                    for(var i=0;i<len;i++){
                        var tmpNode = new YAHOO.widget.TaskNode( fileList[i].filename , hostNode, false);
                        if(fileList[i].filetype=='d' || fileList[i].filetype=='v'){
                            var childNode=new YAHOO.widget.TaskNode(" ",tmpNode,false);
                        }
                    }
                    // Expand and collapse happen prior to the actual expand/collapse,
                    // and can be used to cancel the operation
                    tree.subscribe("expand", function(node) {
                        if(node.isExpendedBefore){
                            return;
                        }
                   /**     var xx=new Agent("012cd863-9853-4c7d-aaa1-eeb617434575",
                        "ext2-lnx-agent","root","lionli","22");*/
                        var dirPath="";
                        var tmpNode=node;
                        while(tmpNode!=tree.getRoot().children[0]){
                            dirPath=tmpNode.label+"/"+dirPath;
                            tmpNode=tmpNode.parent;
                        }
                  //      alert(constructAgentJSON(xx));
                        Test.getFileList(constructAgentJSON(xx),dirPath,function(data){
                            for(var i=0;i<node.children.length;i++){
                                tree.removeNode(node.children[i]);
                            }
                            var fileList=eval('('+data+')');
                            var isChecked=(node.checkState>0)?true:false;
                            for(var i=0;i<fileList.length;i++){
                                var tmpNode=new YAHOO.widget.TaskNode(fileList[i].filename, node, false,isChecked);
                                if(fileList[i].filetype=='d' || fileList[i].filetype=='v'){
                                    var childNode=new YAHOO.widget.TaskNode(" ",tmpNode,false,isChecked);
                                }
                            }
                            node.refresh();
                            node.isExpendedBefore=true;
                        });
                    });

                tree.subscribe("collapse", function(node) {
                    YAHOO.log(node.index + " was collapsed", "info", "example");
                });

                // Trees with TextNodes will fire an event for when the label is clicked:
                tree.subscribe("labelClick", function(node) {
                    YAHOO.log(node.index + " label was clicked", "info", "example");
                });

                // Trees with TaskNodes will fire an event for when a check box is clicked
                tree.subscribe("checkClick", function(node) {
                    YAHOO.log(node.index + " check was clicked", "info", "example");
                });

                tree.subscribe("clickEvent", function(node) {
                    YAHOO.log(node.index + " clickEvent", "info", "example");
                });

                YAHOO.util.Event.on("expand", "click", function(e) {
                    YAHOO.log("Expanding all TreeView  nodes.", "info", "example");
                    tree.expandAll();
                    YAHOO.util.Event.preventDefault(e);
                });

                //handler for collapsing all nodes
                YAHOO.util.Event.on("collapse", "click", function(e) {
                    YAHOO.log("Collapsing all TreeView  nodes.", "info", "example");
                    tree.collapseAll();
                    YAHOO.util.Event.preventDefault(e);
                });

                //handler for checking all nodes
                YAHOO.util.Event.on("check", "click", function(e) {
                    YAHOO.log("Checking all TreeView  nodes.", "info", "example");
                    checkAll();
                    YAHOO.util.Event.preventDefault(e);
                });

                //handler for unchecking all nodes
                YAHOO.util.Event.on("uncheck", "click", function(e) {
                    YAHOO.log("Unchecking all TreeView  nodes.", "info", "example");
                    uncheckAll();
                    YAHOO.util.Event.preventDefault(e);
                });


                YAHOO.util.Event.on("getchecked", "click", function(e) {
                    YAHOO.log("Checked nodes: " + YAHOO.lang.dump(getCheckedNodes()), "info", "example");

                    YAHOO.util.Event.preventDefault(e);
                });
                    
                tree.draw();

                function onCheckClick(node) {
                    YAHOO.log(node.label + " check was clicked, new state: " +
                        node.checkState, "info", "example");
                }

                function checkAll() {
                    var topNodes = tree.getRoot().children;
                    for(var i=0; i<topNodes.length; ++i) {
                        topNodes[i].check();
                    }
                }

                function uncheckAll() {
                    var topNodes = tree.getRoot().children;
                    for(var i=0; i<topNodes.length; ++i) {
                        topNodes[i].uncheck();
                    }
                }

            });
        }

        

        function getCheckedNodes(nodes) {
            nodes = nodes || tree.getRoot().children[0].children;
            checkedNodes = [];
            for(var i=0, l=nodes.length; i<l; i=i+1) {
                var n = nodes[i];
                //if (n.checkState > 0) { // if we were interested in the nodes that have some but not all children checked
                if (n.checkState > 0) {
                    checkedNodes.push(n); 
                }

                if (n.checkState===1 && n.hasChildren()) {
                    checkedNodes = checkedNodes.concat(getCheckedNodes(n.children));
                }
            }

            return checkedNodes;
        }

        function FileNode(sFileType,sFilePath,sFileParent,iCheckState){
            var obj=new Object;
            obj.fileType=sFileType;
            obj.filePath=sFilePath;
            obj.fileParent=sFileParent;
            obj.checkState=iCheckState;
            return obj;
        }

        function fileNodeJSON(fileObj){
            var json="{"+
                makePair("filePath",fileObj.filePath)+","+
                makePair("fileType",fileObj.fileType)+","+
                makePair("fileParent",fileObj.fileParent)+","+
                makePair("checkState",fileObj.checkState)+"}";
        //    alert(json);
            return json;
        }

        function arrToJSON(arr){
            var json="[";
            for(var i=0;i<arr.length-1;i++){
                json=json+arr[i]+",";
            }
            json=json+arr[arr.length-1];
            json=json+"]";
            return json;
        }

        function getSelected(){
            var nodes=getCheckedNodes();
            var arr=[];
            for(var i=0;i<nodes.length;i++){
                var fileName=getFilePath(nodes[i]);
                var fileType=nodes[i].hasChildren()?"d":"f";
                var checkState=nodes[i].checkState;
                var fileParent=getFilePath(nodes[i].parent);
                var fileObj=FileNode(fileType,fileName,fileParent,checkState);
                arr.push(fileNodeJSON(fileObj));
            }
            BackupService.getFileBackupSelectionSet(arrToJSON(arr),function(data){
              //  alert(data);
            });
        }

        function getFilePath(tNode){
            var rootNode=tree.getRoot();
            var tmpNode=tNode;
            if(tmpNode==rootNode.children[0]){
                return "FixedDrives";
            }
            var filePath=tmpNode.label;
            tmpNode=tmpNode.parent;
            while(tmpNode!=rootNode.children[0]){
                filePath=tmpNode.label+"/"+filePath;
                tmpNode=tmpNode.parent;
            }
            return filePath;
        }

        (function(){
            var init = function() {
                Test.getRegHostIdAndNames(function(data){
                    var hosts=eval('('+data+')');
                    initHostSelection(hosts);
                });

            }
            YAHOO.util.Event.onDOMReady(init);
        })();

        (function(){
            var init=function(){
                var xx=document.getElementsByName('whenToAction');
                var once=document.getElementById('once_time');
                var period=document.getElementById('period_time');
                var periodSelectedBox=document.getElementsByName('period_day');
                for(var i=0;i<xx.length;i++){
                    xx[i].onchange=function(){
                        var selectedValue=this.value;
                        if(selectedValue==="immediate"){
                            disabledElement(new Array(once,period));
                            disabledElement(periodSelectedBox);
                            document.getElementById('dayTable').style.display="none";
                        }else if(selectedValue==="once"){
                            enabledElement(new Array(once));
                            disabledElement(new Array(period));
                            disabledElement(periodSelectedBox);
                            document.getElementById('dayTable').style.display="none";
                        }else if(selectedValue==="period"){
                            enabledElement(new Array(period));
                            enabledElement(periodSelectedBox);
                            disabledElement(new Array(once));
                            document.getElementById('dayTable').style.display="block";
                            var dayOfWeek=document.getElementById('dayOfWeek');
                            var dayOfMonth=document.getElementById('dayOfMonth');
                            for(var i=0;i<periodSelectedBox.length;i++){
                                periodSelectedBox[i].onchange=function(){
                                    var value=this.value;
                                    if(value==="everyday"){
                                        dayOfWeek.style.display='none';
                                        dayOfMonth.style.display='none';
                                    }else if(value==="everyweek"){
                                        dayOfMonth.style.display='none';
                                        dayOfWeek.style.display='block';
                                    }else if(value=="everymonth"){
                                        dayOfWeek.style.display='none';
                                        dayOfMonth.style.display='block';
                                    }
                                };
                            }
                        }
                    };
                }
                disabledElement(new Array(once,period));
                disabledElement(periodSelectedBox);
                document.getElementById('dayTable').style.display="none";
            };
            YAHOO.util.Event.onDOMReady(init);
        })();

            
        function disabledElement(elementArr){
            for(var i=0;i<elementArr.length;i++){
                elementArr[i].disabled=true;
            }
        }

        function enabledElement(elementArr){
            for(var i=0;i<elementArr.length;i++){
                elementArr[i].disabled=false;
            }
        }

        function initHostSelection(items){
            var len=items.length;
            var oS=document.getElementById("hostSelection");
            clearSelection(document.getElementById('agentSelection'));
            clearSelection(document.getElementById('instanceSelection'));
            for(var i=0;i<len;i++){
                var oOption=document.createElement("option");
                oOption.setAttribute("value", items[i].hostId);
                var oNode=document.createTextNode(items[i].hostName);
                oOption.appendChild(oNode);
                oS.appendChild(oOption);
            }
            oS.selectedIndex=-1;
        }

        function loginToHost(){
         //   resetLoginDialog();
         //   document.getElementById('showLoginDialog').click();
         fillAgent();
        }

        function fillAgent(){
            var hostSelection=document.getElementById("hostSelection");
            var selectedIndex=hostSelection.selectedIndex;
            var selectedValue=hostSelection.options[selectedIndex].value;

            clearSelection(document.getElementById('instanceSelection'));

            Test.getHostAgentNames(selectedValue,function(data){
                var agentNames=eval('('+data+')');
                var len=agentNames.length;
                var agentSelection=document.getElementById('agentSelection');
                clearSelection(agentSelection);
                for(var i=0;i<len;i++){
                    var oOption=document.createElement("option");
                    oOption.setAttribute("value", agentNames[i].agentName);
                    var oNode=document.createTextNode(agentNames[i].agentDesc);
                    oOption.appendChild(oNode);
                    agentSelection.appendChild(oOption);
                }
                agentSelection.selectedIndex=-1;
            });
        }

        function fillInstance(){
            var hostSelection=document.getElementById("hostSelection");
            var agentSelection=document.getElementById("agentSelection");

            var hostSelectedValue=hostSelection.options[hostSelection.selectedIndex].value;
            var agentSelectedValue=agentSelection.options[agentSelection.selectedIndex].value;

            Test.getHostAgentInstances(hostSelectedValue,agentSelectedValue,function(data){
                var inst=eval('('+data+')');
                var len=inst.length;
                var instSelection=document.getElementById('instanceSelection');
                clearSelection(instSelection);
                for(var i=0;i<len;i++){
                    var oOption=document.createElement("option");
                    oOption.setAttribute("value", inst[i]);
                    var oNode=document.createTextNode(inst[i]);
                    oOption.appendChild(oNode);
                    instSelection.appendChild(oOption);
                }
                drawTree();
            });
            
        }
        
        function clearSelection(oList){
            for(var i=oList.options.length-1;i>=0;i--){
                oList.remove(i);
            }
        }

        
        (function(){
            var init = function() {
                var handleSubmit=function(){
                    var hostList=document.getElementById('hostSelection');
                    var selectedHost=hostList.options[hostList.selectedIndex].value;

                    var username=document.getElementById('username').value;
                   var password=document.getElementById('password').value;
                   var port=document.getElementById('port').value;

                   var errorInfo=document.getElementById('loginerrormsg');
                   if(username==""){
                       errorInfo.innerHTML="Please provide username";
                       errorInfo.style.display="block";
                   }
                   if(port==""){
                       errorInfo.innerHTML="Please provide access port.";
                       errorInfo.style.display="block";
                   }
                   SshService.isAuthenticated(selectedHost,username,password,port,function(data){
                        var isAuthenticated=eval('('+data+')');
                        if(!isAuthenticated){
                            errorInfo.innerHTML="Login failed. Click cancel to leave this dialog";
                            errorInfo.style.display="block";
                        }else{
                            document.getElementById('hideLoginDialog').click();
                            osUserName=username;
                            osPassword=password;
                            osPort=port;
                            fillAgent();
                        }
                    });
                }

                var handleCancel=function(){
                    this.hide();
                    resetLoginDialg();
                }

                var loginDialog=new YAHOO.widget.Dialog("loginDialog",
                    {
                        width:"25em",
                        fixedcenter:true,
                        modal:true,
                        draggable:true,
                        visible:false,
                        constraintoviewport:true,
                        buttons:[
                            {text:"Submit",handler:handleSubmit,isDefault:true},
                            {text:"Cancel",handler:handleCancel}
                        ]
                    });

               loginDialog.render();
               YAHOO.util.Event.addListener("showLoginDialog","click",loginDialog.show,loginDialog,true);
               YAHOO.util.Event.addListener("hideLoginDialog", "click", loginDialog.hide, loginDialog, true);
            }
            YAHOO.util.Event.onDOMReady(init);
        })();

        function resetLoginDialog(){
            document.getElementById('loginerrormsg').style.display="none";
            document.getElementById('username').value="";
            document.getElementById('password').value="";
            document.getElementById('port').value="22";
        }
        </script>
    </head>
    <body class="yui-skin-sam">
        <div id="loginDialog">
            <div class="hd">Login to </div>
            <div class="bd">
                <div id="loginerrormsg" style="color:red;display: none"></div>
                <label>User Name:</label><input type="textbox" name="username" id="username"/>
                <label>Password:</label><input type="password" name="password" id="password"/>
                <label>Port:</label><input type="textbox" name="port" id="port" value="22"/>
            </div>
        </div>
        <div id="topPanel">
            <label>主机</label><select id="hostSelection" onchange="loginToHost()" style="width:170px"></select>
            <label style="margin-left:20px">代理</label><select id="agentSelection" onchange="fillInstance()" style="width:170px"></select>
            <label style="margin-left:20px">实例</label><select id="instanceSelection" style="width:170px"></select>
        </div>
        <div id="mainPanel">
            <div id="backupConfig" class="yui-navset">
                <ul class="yui-nav">
                    <li><a href="#selectionTab">备份选择</a></li>
                    <li><a href="#optionTab">备份选项</a></li>
                    <li><a href="#scheduleTab">调度选项</a></li>
                    <li><a href="#targetTab">目标指定</a></li>
                    <li><a href="#submitTab">提交作业</a></li>
                </ul>
                <div class="yui-content">
                    <div id="selectionTab">
                        
                        <div id="selectionTree">
                            <div id="treeDiv1" style="height: 600px;overflow:scroll"></div>
                        </div>
                    </div>
                    <div id="optionTab">
                        <div id="file-agent-option" style="height:600px">
                            <p>请选择备份类型</p>
                            <label for="完全备份"><input type="radio" name="backup-type" id="full" value="full" checked="checked"/>完全备份</label><br/>
                            <p>选择该选项将备份所有被选中的文件</p>
                            <br/>
                            <label for="增量备份"><input type="radio" name="backup-type" id="incremental" value="incremental"/>增量备份</label>
                            <label style="float:right;margin-right: 30%">级别<input type="input" name="incrlevel" id="incrlevel" size="3" value="0"></label><br/>
                            <p>选择该选项将只对最近一次低级别备份（即完全备份或增量级别比本次设置级别低的增量备份）后被修改的文件进行备份</p>
                            <p>你需要选择一个全备份的选择集作为增量备份的基础</p><br/><br/>
                            <label><input type="checkbox" name="compresslevel" id="compresslevel"/>压缩级别</label>
                            <label style="float:right;margin-right:30%"><select id="compresslevelbox">
                                    <option value="1">1-最快</option>
                                    <option value="3">3-较快</option>
                                    <option value="6" selected="selected">6-默认</option>
                                    <option value="7">7-较好</option>
                                    <option value="9">9-最好</option>
                                </select>
                            </label>
                        </div>
                    </div>
                    <div id="scheduleTab" style="height:600px">
                        <p>请选择调度选项</p>
                        <div><label><input type="radio" name="whenToAction" id="immediate" value="immediate" checked="checked" />立即</label></div><br/>
                        <div>
                            <label><input type="radio" name="whenToAction" id="once" value="once"/>一次</label><br/>
                            <input type="text" name="once_time" id="once_time" style="margin-left:3%;" value=""/>
                        </div><br/>
                        <div>
                            <label><input type="radio" name="whenToAction" id="period" value="period"/>周期</label><br/>
                            <input type="text" name="period_time" id="period_time" value="" style="margin-left:3%;"/><br/>
                            <div>
                                <div style="float:left;margin-left: 3%;">
                                    <label><input type="radio" name="period_day" id="everyday" value="everyday" checked="checked"/>每日</label><br/>
                                    <label><input type="radio" name="period_day" id="everyweek" value="everyweek"/>每周中的某(几)天</label><br/>
                                    <label><input type="radio" name="period_day" id="everymonth" value="everymonth"/>每月中的某(几)天</label>
                                </div>
                                <div style="float:left;" id="dayTable">
                                    <div id="dayOfWeek" style="float:left;margin-left:30px;display:none">
                                        <table>
                                            <tr><td><label><input type="checkbox" id="c1"/>星期一</label></td></tr>
                                            <tr><td><label><input type="checkbox" id="c1"/>星期二</label></td></tr>
                                            <tr><td><label><input type="checkbox" id="c1"/>星期三</label></td></tr>
                                            <tr><td><label><input type="checkbox" id="c1"/>星期四</label></td></tr>
                                            <tr><td><label><input type="checkbox" id="c1"/>星期五</label></td></tr>
                                            <tr><td><label><input type="checkbox" id="c1"/>星期六</label></td></tr>
                                            <tr><td><label><input type="checkbox" id="c1"/>星期日</label></td></tr>
                                        </table>
                                    </div>
                                    <div id="dayOfMonth" style="float:left;margin-left:30px;display:none">
                                        <table>
                                            <tr>
                                                <td><label><input type="checkbox" id="c1"/>1</label></td>
                                                <td><label><input type="checkbox" id="c1"/>2</label></td>
                                                <td><label><input type="checkbox" id="c1"/>3</label></td>
                                                <td><label><input type="checkbox" id="c1"/>4</label></td>
                                                <td><label><input type="checkbox" id="c1"/>5</label></td>
                                                <td><label><input type="checkbox" id="c1"/>6</label></td>
                                                <td><label><input type="checkbox" id="c1"/>7</label></td>
                                            </tr>
                                            <tr>
                                                <td><label><input type="checkbox" id="c1"/>8</label></td>
                                                <td><label><input type="checkbox" id="c1"/>9</label></td>
                                                <td><label><input type="checkbox" id="c1"/>10</label></td>
                                                <td><label><input type="checkbox" id="c1"/>11</label></td>
                                                <td><label><input type="checkbox" id="c1"/>12</label></td>
                                                <td><label><input type="checkbox" id="c1"/>13</label></td>
                                                <td><label><input type="checkbox" id="c1"/>14</label></td>
                                            </tr>
                                            <tr>
                                                <td><label><input type="checkbox" id="c1"/>15</label></td>
                                                <td><label><input type="checkbox" id="c1"/>16</label></td>
                                                <td><label><input type="checkbox" id="c1"/>17</label></td>
                                                <td><label><input type="checkbox" id="c1"/>18</label></td>
                                                <td><label><input type="checkbox" id="c1"/>19</label></td>
                                                <td><label><input type="checkbox" id="c1"/>20</label></td>
                                                <td><label><input type="checkbox" id="c1"/>21</label></td>
                                            </tr>
                                            <tr>
                                                <td><label><input type="checkbox" id="c1"/>22</label></td>
                                                <td><label><input type="checkbox" id="c1"/>23</label></td>
                                                <td><label><input type="checkbox" id="c1"/>24</label></td>
                                                <td><label><input type="checkbox" id="c1"/>25</label></td>
                                                <td><label><input type="checkbox" id="c1"/>26</label></td>
                                                <td><label><input type="checkbox" id="c1"/>27</label></td>
                                                <td><label><input type="checkbox" id="c1"/>28</label></td>
                                            </tr>
                                            <tr>
                                                <td><label><input type="checkbox" id="c1"/>29</label></td>
                                                <td><label><input type="checkbox" id="c1"/>30</label></td>
                                                <td><label><input type="checkbox" id="c1"/>31</label></td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="targetTab" style="height:600px;">
                        <label>请选择介质</label>
                        <table>
                            <tr>
                                <td><label><input type="radio"/>缺省卷组</label></td>
                                <td><input type="text"/></td>
                            </tr>
                            <tr>
                                <td width="50%" align="center"><input type="button" value="指定为缺省卷组"/></td>
                                <td><select id="availablevg" style="width:170px"></select></td>
                            </tr>
                            <tr>
                                <td><label><input type="radio"/>指定卷组</label></td>
                                <td><select id="vgs" style="width:170px"></select></td>
                            </tr>
                        </table>
                        <div id="submitTab"></div>
                    </div>
                </div>
            </div>
        </div>
            <div id="controlButtonPanel">
                <input type="button" value="上一步" id="preButton" onclick="previousTab()"/>
                <input type="button" value="下一步" id="nextButton" onclick="nextTab()"/>
                <input type="button" value="提交作业" onclick="submitJob()"/>

                <input type="button" value="Get selected" onclick="getSelected()"/>
                <button id="showLoginDialog" style="display:none">Show Dailog</button>
                <button id="hideLoginDialog" style="display:none">Hide Dialog</button>

            </div>

            <script type="text/javascript">
            var tabView;
            var activeTab;
            (function(){
                tabView=new YAHOO.widget.TabView('backupConfig',{orientation:'left'});
                tabView.selectTab(0);
                activeTab=tabView.getTab(0);
                document.getElementById('preButton').disabled=true;
                var tabLen=tabView.get('tabs').length;
                for(var i=0;i<tabLen;i++){
                    tabView.getTab(i).addListener("click",function(){
                        activeTab=this;
                        buttonStateMonitor();
                    });
                }
            })();

            function nextTab(){
                var index=tabView.getTabIndex(activeTab);
                if(index!==4){
                    tabView.selectTab(index+1);
                    activeTab=tabView.getTab(index+1);
                }
                buttonStateMonitor();

            }

            function previousTab(){
                var index=tabView.getTabIndex(activeTab);
                if(index!==0){
                    tabView.selectTab(index-1);
                    activeTab=tabView.getTab(index-1);
                }
                buttonStateMonitor();
            }

            function submitJob(){
                
            }
            
            function buttonStateMonitor(){
                var index=tabView.getTabIndex(activeTab);
                if(index===0){
                    changeButtonState(true,false);
                }else if(index==4){
                    changeButtonState(false,true);
                }else{
                    changeButtonState(false,false);
                }
            }

            function changeButtonState(preButtonDisabled,nextButtonDisabled){
                document.getElementById('preButton').disabled=preButtonDisabled;
                document.getElementById('nextButton').disabled=nextButtonDisabled;
            }
            </script>
            <script type="text/javascript" src="js/jquery-1.3.2.min.js"></script>
            <script type="text/javascript" src="js/jquery-ui-1.7.2.custom.min.js"></script>
            <script type="text/javascript" src="js/jquery-ui-timepicker-addon.js"></script>
            <script type="text/javascript" src="js/jquery-spin.js"></script>
            <script type="text/javascript">
            $(document).ready(function(){
                $.spin.imageBasePath='js/img/spin2/';
                $('#incrlevel').spin();

                $('#once_time').datetimepicker({
                    showSecond:true,
                    timeFormat:'hh:mm:ss',
                    dateFormat:'yy-mm-dd'
                });
                $('#period_time').timepicker({
                    showSecond:true,
                    timeFormat:'hh:mm:ss'
                });
            });

            (function() {
                var Dom = YAHOO.util.Dom,
                Event = YAHOO.util.Event;

                Event.onDOMReady(function() {
                    var layout = new YAHOO.widget.Layout({
                        units: [
                            { position: 'top', height: 30, body: 'topPanel'},
                            { position: 'center', body: 'mainPanel'},
                            { position: 'bottom',body:'controlButtonPanel',height:50}
                        ]
                    });

                    layout.render();

                });
            })();
            </script>
    </body>
</html>
