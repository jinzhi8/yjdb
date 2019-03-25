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
        String date = CommonUtil.doStr(request.getParameter("date"));
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
    <script>var deptid = '<%=deptid%>', date = '<%=date%>';</script>
</head>
<body style="padding:5px">
<div style="height:23px;widht:100%;text-align: right">
    <button class="layui-btn layui-btn-primary layui-btn-sm add">
        <i class="layui-icon">&#xe654;</i>新增
    </button>
</div>

<table id="tableList" lay-filter="tableList"></table>

<form class="layui-form add_form" style="display: none;padding: 5px;">
    <div class="layui-form-item">
        <label class="layui-form-label"><i style="color:red">*&nbsp;</i>分数</label>
        <div class="layui-input-inline">
            <input type="text" name="fs" required lay-verify="required|number" placeholder="请输入分数" autocomplete="off"
                   class="layui-input">
        </div>
        <div class="layui-form-mid layui-word-aux">例：1、-1</div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label"><i style="color:red">*&nbsp;</i>备注</label>
        <div class="layui-input-inline">
            <input type="text" name="bz" required lay-verify="required" placeholder="请输入备注" autocomplete="off"
                   class="layui-input">
        </div>
    </div>
    <button type="button" lay-submit lay-filter="add_form_submit" id="add_form_submit"></button>
</form>
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
<script type="text/javascript" src="js/qt.js?v=<%=Math.random()%>"></script>
</body>
</html>