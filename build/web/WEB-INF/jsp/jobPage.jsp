<%-- 
    Document   : jobPage
    Created on : 2011-4-21, 9:19:21
    Author     : lion
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Job Manage</title>
        <link rel="stylesheet" type="text/css" href="flexigrid/style.css"/>
        <link rel="stylesheet" type="text/css" href="flexigrid/css/flexigrid/flexigrid.css"/>

        <link rel="stylesheet" type="text/css" href="build/fonts/fonts-min.css"/>
        <link rel="stylesheet" type="text/css" href="build/tabview/assets/skins/sam/tabview.css"/>
        <link rel="stylesheet" type="text/css" href="build/datatable/assets/skins/sam/datatable.css"/>
        <link rel="stylesheet" type="text/css" href="build/treeview/assets/skins/sam/treeview.css" />

        <script type="text/javascript" src="flexigrid/lib/jquery/jquery.js"></script>
        <script type="text/javascript" src="flexigrid/flexigrid.js"></script>

        <script type="text/javascript" src="build/yahoo-dom-event/yahoo-dom-event.js"></script>
        <script type="text/javascript" src="build/element/element-min.js"></script>
        <script type="text/javascript" src="build/tabview/tabview-min.js"></script>
        <script type="text/javascript" src="build/yahoo-dom-event/yahoo-dom-event.js"></script>
        <script type="text/javascript" src="build/datasource/datasource-min.js"></script>
        <script type="text/javascript" src="build/datatable/datatable-min.js"></script>

        <script type="text/javascript" src="dwr/engine.js"></script>
        <script type="text/javascript" src="dwr/util.js"></script>
        <script type="text/javascript" src="dwr/interface/Test.js"></script>
        <script type="text/javascript">
            (function(){
                var init = function() {
                    Test.getRegHostAndAgents(function(data){
                        var items=eval('('+data+')');
                        initHostBox(items.hosts);
                        initAgentBox(items.agents);
                    });
                }

                YAHOO.util.Event.onDOMReady(init);
            })();

            YAHOO.util.Event.addListener(window,"load",function(){
                var xxx=function(){
                    var columnDefs=[
                        {key:"host"},
                        {key:"agenttype"},
                        {key:"jobname"},
                        {key:"jobtype"},
                        {key:"starttime"},
                        {key:"exectime"},
                        {key:"jobstatus"}
                    ];
                    var oData=[
                        {host:"xxx",agenttype:"file",jobname:"xxa",jobtype:"backup",
                            starttime:"a1020",exectime:"1232",jobstatus:"success"}
                    ];
                    var jobDataSource=new YAHOO.util.DataSource(oData);
                    jobDataSource.responseType=YAHOO.util.DataSource.TYPE_JSARRAY;
                    jobDataSource.responseSchema={
                        fields:["host","agenttype","jobname","jobtype","starttime","exectime","jobstatus"]
                    };

                    var jobDataTable=new YAHOO.widget.DataTable("runStatusTable",columnDefs,jobDataSource,{scrollable:true,width:"100%"});
                    var jobTab=new YAHOO.widget.TabView("jobTab");
                    jobTab.getTab(0).addListener("click",function(){jobDataTable.onShow()});

                    return {
                        oDS:jobDataSource,
                        oDT:jobDataTable,
                        oTV:jobTab
                    }
                }();
            });

          /**  (function(){
                var tabView=new YAHOO.widget.TabView('jobTab');
                tabView.selectTab(0);

            })();*/;

            function initHostBox(oData){
                var oHosts=eval('('+oData+')');
                var hostBox=document.getElementById('hostBox');
                hostBox.appendChild(createOptionElement('<全部主机>','all'));
                for(var i=0;i<oHosts.length;i++){
                    hostBox.appendChild(createOptionElement(oHosts[i].hostName,
                    oHosts[i].hostId));
                }
            }

            function initAgentBox(oData){
                var oAgents=eval('('+oData+')');
                var agentBox=document.getElementById('agentBox');
                agentBox.appendChild(createOptionElement('所有代理','all'));
                for(var i=0;i<oAgents.length;i++){
                    agentBox.appendChild(createOptionElement(oAgents[i].agentDesc,
                    oAgents[i].agentName));
                }
            }

            function createOptionElement(name,value){
                var option=document.createElement("option");
                option.setAttribute("value", value);
                var oNode=document.createTextNode(name);
                option.appendChild(oNode);
                return option;
            }

            function clearListBox(oListBox){
                for(var i=oListBox.children.length-1;i>=0;i--){
                    oListBox.removeChild(oListBox.children[i]);
                }
            }

            function resetAgent(){
                var hostBox=document.getElementById('hostBox');
                var selectedIndex=hostBox.selectedIndex;
                var value=hostBox.options[selectedIndex].value;
                clearListBox(document.getElementById('agentBox'));
                
            }
        </script>
    </head>
    <body class="yui-skin-sam">
        <div id="topPanel">
            <label>主机<select id="hostBox" onchange="resetAgent()"></select></label>
            <label>代理<select id="agentBox"></select></label>
        </div>
        <div id="tabPanel">
            <div id="jobTab" class="yui-navset">
                <ul class="yui-nav">
                    <li><a href="#runStatusTab">运行状态</a></li>
                    <li><a href="#scheduleTab">周期作业</a></li>
                </ul>
                <div class="yui-content">
                    <div id="runStatusTab" style="height:500px">
                        <div id="runStatusTable"></div>
                    </div>
                    <div id="scheduleTab">
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
