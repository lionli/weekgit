<%-- 
    Document   : restorePage
    Created on : 2011-4-22, 10:11:03
    Author     : lion
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Restore Page</title>
        <link rel="stylesheet" type="text/css" href="build/fonts/fonts-min.css"/>
        <link rel="stylesheet" type="text/css" href="build/tabview/assets/skins/sam/tabview.css"/>
        <script type="text/javascript" src="build/yahoo-dom-event/yahoo-dom-event.js"></script>
        <script type="text/javascript" src="build/element/element-min.js"></script>
        <script type="text/javascript" src="build/tabview/tabview-min.js"></script>
        <style type="text/css">
            .yui-navset-left .yui-nav li,
            .yui-navset-right .yui-nav li{
                margin:0 0 0 .5em;
            }
            .ygtvcheck0 { background: url(assets/img/check/check0.gif) 0 0 no-repeat; width:16px; cursor:pointer }
            .ygtvcheck1 { background: url(assets/img/check/check1.gif) 0 0 no-repeat; width:16px; cursor:pointer }
            .ygtvcheck2 { background: url(assets/img/check/check2.gif) 0 0 no-repeat; width:16px; cursor:pointer }

            #buttonPanel{
                float:right;
            }
        </style>
        <style type="text/css">
            .ui-timepicker-div .ui-widget-header{ margin-bottom: 8px; }
            .ui-timepicker-div dl{ text-align: left; }
            .ui-timepicker-div dl dt{ height: 25px; }
            .ui-timepicker-div dl dd{ margin: -25px 0 10px 65px; }
            .ui-timepicker-div td { font-size: 90%; }

            #resourceSection{
                height:80%;
}
        </style>
        <link rel="stylesheet" type="text/css" href="js/css/smoothness/jquery-ui-1.7.2.custom.css">
        <link rel="stylesheet" type="text/css" href="assets/dpSyntaxHighlighter.css">
        
        
        <!--Script and CSS includes for YUI dependencies on this page-->
        <link rel="stylesheet" type="text/css" href="build/logger/assets/skins/sam/logger.css" />
        <link rel="stylesheet" type="text/css" href="build/treeview/assets/skins/sam/treeview.css" />
        <link rel="stylesheet" type="text/css" href="build/button/assets/skins/sam/button.css" />
        <link rel="stylesheet" type="text/css" href="build/layout/assets/skins/sam/layout.css" />
        <link rel="stylesheet" type="text/css" href="assets/css/folders/tree.css"/>

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

        <script type="text/javascript" src="assets/js/TaskNode.js"></script>

        <script type="text/javascript" src="dwr/engine.js"></script>
        <script type="text/javascript" src="dwr/util.js"></script>
        <script type="text/javascript" src="dwr/interface/Test.js"></script>
        <script type="text/javascript">
            (function(){
                var init = function() {
                    Test.getRegHostIdAndNames(function(data){
                        var oHosts=eval('('+data+')');
                        initHostBox(oHosts);
                    });
                }

                YAHOO.util.Event.onDOMReady(init);
            })();

            function initHostBox(oData){
                var hostBox=document.getElementById('hostBox');
                for(var i=0;i<oData.length;i++){
                    hostBox.appendChild(createOptionElement(oData[i].hostName,
                    oData[i].hostId));
                }
                hostBox.selectedIndex=-1;
            }

            function createOptionElement(name,value){
                var option=document.createElement("option");
                option.setAttribute("value", value);
                var oNode=document.createTextNode(name);
                option.appendChild(oNode);
                return option;
            }

            var agentTree;
            function setHostInfo(){
                var index=document.getElementById('hostBox').selectedIndex;
                var hostId=document.getElementById('hostBox').options[index].value;
                var hostName=document.getElementById('hostBox').options[index].text;
                Test.getBackupResource(hostId,function(data){
                    var hostAgents=eval('('+data+')');
                    agentTree = new YAHOO.widget.TreeView("selectionTree");
                    var rootNode=agentTree.getRoot();
                    var hostNameNode=new YAHOO.widget.HTMLNode(hostName,rootNode,true);

                    var agents=eval('('+hostAgents.agents+')');
                    for(var i=0;i<agents.length;i++){
                        var agentNode=new YAHOO.widget.HTMLNode(agents[i].agentName,hostNameNode,false,true);  
                        var backupResource=eval('('+agents[i].backupResource+')');
                  //      alert(agents[i].backupResource);
                        if(backupResource.length==0){
                            agentNode.setDynamicLoad(loadData);
                        }else{
                            for(var j=0;j<backupResource.length;j++){
                                var label="<label onclick=\"getRestoreSelectionSet(\'"+backupResource[j].backupSetId+"\')\">"+backupResource[j].backupSetName+"</label>";
                                var resourceNode=new YAHOO.widget.HTMLNode(label,agentNode,false);
                            }
                        }
                    }
                    agentTree.draw();
                });
            }

            function getRestoreSelectionSet(backupSetId){
                alert(backupSetId);
            }
            
            function loadData(node,fnLoadComplete){
                fnLoadComplete();
            }
        </script>
    </head>
    <body class="yui-skin-sam">
        <div id="topPanel">
            <label>主机<select id="hostBox" onchange="setHostInfo()"></select></label>
        </div>
        <div id="mainPanel">
            <div id="restoreConfig" class="yui-navset">
                <ul class="yui-nav">
                    <li><a href="#selectionTab">恢复选择</a></li>
                    <li><a href="#optionTab">恢复选项</a></li>
                    <li><a href="#scheduleTab">调度选项</a></li>
                    <li><a href="#targetTab">目标指定</a></li>
                    <li><a href="#submitTab">提交作业</a></li>
                </ul>
                <div class="yui-content">
                    <div id="selectionTab" style="height:600px">
                        <p>请选择恢复资源</p>
                        <div id="resourceSection">
                            <div id="selectionTree" class="pane ui-layout-west"></div>
                            <div id="backupSetTree" class="pane ui-layout-center"></div>
                        </div>
                    </div>
                    <div id="optionTab" style="height:600px">

                    </div>
                    <div id="scheduleTab" style="height:600px">

                    </div>
                    <div id="targetTab" style="height:600px">

                    </div>
                    <div id="submitTab" style="height:600px"></div>
                </div>
            </div>
        </div>
        <div id="buttonPanel">
            <input type="button" value="上一步" id="preButton" onclick="previousTab()"/>
            <input type="button" value="下一步" id="nextButton" onclick="nextTab()"/>
            <input type="button" value="提交作业" onclick="submitJob()"/>
        </div>
        <script type="text/javascript" src="js/jquery-1.3.2.min.js"></script>
        <script type="text/javascript" src="js/jquery-ui-1.7.2.custom.min.js"></script>
        <script type="text/javascript" src="js/jquery.layout-latest.js"></script>
        <script type="text/javascript">
            var tabView;
            var activeTab;
            (function(){
                tabView=new YAHOO.widget.TabView('restoreConfig',{orientation:'left'});
                tabView.selectTab(0);
                activeTab=tabView.getTab(0);

            })();
            (function() {
                var Dom = YAHOO.util.Dom,
                Event = YAHOO.util.Event;

                Event.onDOMReady(function() {
                    var layout = new YAHOO.widget.Layout({
                        units: [
                            { position: 'top', height: 30, body: 'topPanel'},
                            { position: 'center', body: 'mainPanel'},
                            { position: 'bottom',body:'buttonPanel',height:50}
                        ]
                    });
                    layout.render();
                });
            })();
            $(document).ready(function(){
                $('#resourceSection').layout({applyDefaultStyles:true});
            });
        </script>
    </body>
</html>
