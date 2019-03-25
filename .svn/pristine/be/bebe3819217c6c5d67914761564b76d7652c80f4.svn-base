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
    %>
    <meta charset="utf-8">
    <title>秘书配置</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="format-detection" content="telephone=no">
    <link rel="stylesheet" href="../js/layui/css/layui.css" media="all"/>
</head>
<body style="padding:10px">
<div class="layui-form">
    <blockquote class="layui-elem-quote quoteBox">
        <div class="layui-inline">
            <label class="layui-form-label">用户名</label>
            <div class="layui-input-inline">
                <input type="text" style="width:250px" class="layui-input searchVal"
                       placeholder=""/>
            </div>
            <a class="layui-btn search_btn" data-type="reload"><i class="layui-icon"></i>搜索</a>
        </div>
    </blockquote>

</div>

<table id="tableList" lay-filter="tableList"></table>

<script type="text/html" id="mss">
    {{# if(d.mss === undefined){ }}
    <input type="text" name="mss_{{d.LAY_TABLE_INDEX}}" value="" readonly style="width:100%;height:100%;color:#666;font-size:14px;border:0px;background: none"/>
    <input type="hidden" name="msids_{{d.LAY_TABLE_INDEX}}" value="">
    {{# } else { }}
    <input type="text" name="mss_{{d.LAY_TABLE_INDEX}}" value="{{d.mss}}" readonly style="width:100%;height:100%;color:#666;font-size:14px;border:0px;background: none"/>
    <input type="hidden" name="msids_{{d.LAY_TABLE_INDEX}}" value="{{d.msids}}">
    {{# } }}
</script>

<script type="text/html" id="cz">
    <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
    <a class="layui-btn layui-btn-xs" lay-event="save">保存</a>
</script>

<script type="text/javascript" src="../js/jquery-1.11.0.min.js"></script>
<script type="text/javascript" src="../js/layui/layui.js"></script>
<script type="text/javascript" src="js/tableList.js"></script>
<script language="javascript" type="text/javascript" charset="utf-8" src="../resources/js/layer/layerFunction.js"></script>
</body>
</html>