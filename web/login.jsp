<%-- 
    Document   : login
    Created on : 2011-3-22, 15:41:53
    Author     : lion
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login Page</title>
        <link rel="stylesheet" type="text/css" href="build/fonts/fonts-min.css"/>
        <link rel="stylesheet" type="text/css" href="build/container/assets/skins/sam/container.css"/>
        <script type="text/javascript" src="build/yahoo-dom-event/yahoo-dom-event.js"></script>
        <script type="text/javascript" src="build/container/container-min.js"></script>
    </head>
    <body class="yui-skin-sam">
        <script>
            (function(){
                var setAdvanceSetVisibility=function(e){
                    var vis=YAHOO.util.Dom.getStyle('advanceset','visibility');
                    if(vis=="hidden"){
                        YAHOO.util.Dom.setStyle('advanceset','visibility','visible');
                    }else{
                        YAHOO.util.Dom.setStyle('advanceset','visibility','hidden');
                    }
                }
                
                YAHOO.util.Event.addListener("advencesetbutton","click",setAdvanceSetVisibility);
            })();
        </script>
        <div class="mainbody">
            <div>
                <form method="POST" action="<c:url value="/j_spring_security_check"/>">
                    <table>
                        <tr>
                            <td align="left">Username</td>
                            <td><input type="text" name="j_username"/></td>
                        </tr>
                        <tr>
                            <td align="left">Password</td>
                            <td><input type="password" name="j_password"/></td>
                        </tr>
                        <tr>
                            <td colspan="2" align="right">
                                <input type="submit" value="Login"/>
                                <input type="reset" value="Reset"/>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="right">
                                <input type="button" id="advencesetbutton" value="Advance Set"/>
                            </td>
                        </tr>
                    </table>
                </form>
            </div>
            <div id="advanceset" style="visibility:hidden">
                <table>
                    <tr>
                        <td align="left">IP</td>
                        <td><input type="text" name="serverip"/></td>
                    </tr>
                    <tr>
                        <td align="left">Database</td>
                        <td><input type="text" name="dbname"/></td>
                    </tr>
                    <tr>
                        <td align="left">Port</td>
                        <td><input type="text" name="dbport"/></td>
                    </tr>
                </table>
            </div>
        </div>
    </body>
</html>


