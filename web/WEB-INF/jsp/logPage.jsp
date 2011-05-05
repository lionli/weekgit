<%-- 
    Document   : logPage
    Created on : 2011-4-13, 14:08:26
    Author     : lion
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Log Page</title>
        <link rel="stylesheet" type="text/css" href="build/fonts/fonts-min.css" />
        <link rel="stylesheet" type="text/css" href="build/treeview/assets/skins/sam/treeview.css" />
        <script type="text/javascript" src="build/yahoo-dom-event/yahoo-dom-event.js"></script>
        <script type="text/javascript" src="build/treeview/treeview-min.js"></script>
        
        <script type="text/javascript" src="dwr/engine.js"></script>
        <script type="text/javascript" src="dwr/util.js"></script>
        <script type="text/javascript" src="dwr/interface/Test.js"></script>
        <script type="text/javascript">
            (function(){
                var init = function() {
                    Test.getRegHostNames(function(data){
                        var items=eval('('+data+')');
                        var len=items.length;
                        var oS=document.getElementById("hostNames");
                        for(var i=0;i<len;i++){
                            var oOption=document.createElement("option");
                            oOption.setAttribute("value", items[i].hostId);
                            var oNode=document.createTextNode(items[i].hostName);
                            oOption.appendChild(oNode);
                            oS.appendChild(oOption);
                        }
                    });

                }
                YAHOO.util.Event.onDOMReady(init);
            })();

            function fillLog(){
                var oSelected=document.getElementById('hostNames');
                for(var i=0;i<oSelected.options.length;i++){
                    if(oSelected.options[i].selected){
                        alert(oSelected.options[i].value);
                    }
                }
            }
            
        </script>
    </head>
    <body>
        <label>主机</label><select id="hostNames" onchange="fillLog()"></select><br/>
        <div id="logTable">

        </div>
    </body>
</html>
