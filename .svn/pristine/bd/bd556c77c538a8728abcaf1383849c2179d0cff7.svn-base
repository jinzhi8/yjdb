<%@ page language="java" contentType="text/html;charset=utf-8" %>
<%@page import="com.kizsoft.yjdb.utils.CommonUtil" %>
<!DOCTYPE html>
<html>
<head>
    <%
        //用户登陆验证
        if (session.getAttribute("userInfo") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        String deptid = CommonUtil.doStr(request.getParameter("deptid"));
    %>
    <meta charset="utf-8">
    <title>详情</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="format-detection" content="telephone=no">
    <link rel="stylesheet" href="../js/layui/css/layui.css" media="all"/>
    <script>var deptid = '<%=deptid%>'</script>
</head>
<body style="padding:5px">

<table id="tableList" lay-filter="tableList"></table>

<script type="text/html" id="zt">
    {{# if(d.state == '2'){ }}
    办结 {{d.statetime}}
    {{# }else{ }}
        {{# if(d.dstate == '3'){ }}
        办结{{d.bjtime}}
        {{# } else { }}
        未办结
        {{# } }}
    {{# } }}
</script>
<script type="text/html" id="gq">
    {{# if(d.gqstate == '1'){ }}
    挂起
    {{# }else{ }}
        {{# if(d.gqsq == '2' || d.gqsq == '3'){ }}
        挂起
        {{# } else { }}
        未挂起
        {{# } }}
    {{# } }}
</script>

<script type="text/javascript" src="../js/jquery-1.11.0.min.js"></script>
<script type="text/javascript" src="../js/layui/layui.js"></script>
<script type="text/javascript" src="js/detail.js"></script>
</body>
</html>