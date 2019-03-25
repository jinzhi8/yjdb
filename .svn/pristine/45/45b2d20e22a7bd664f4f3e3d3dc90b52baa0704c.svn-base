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
    <title></title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="format-detection" content="telephone=no">
    <link rel="stylesheet" href="../js/layui/css/layui.css" media="all"/>
    <link rel="stylesheet" href="../js/layui/css/public.css" media="all"/>
    <style>
	    .hide {
	        display: none;
	    }
    </style>
</head>
<body style="padding:10px">
<form class="layui-form" lay-filter="forma">
	<div class="layui-form-item">
	    <label class="layui-form-label">选择</label>
	    <div class="layui-input-block">
	       <select name="tjxz" class="" lay-verify="required" lay-filter="tjxz">
               <option value="1">县政府重点交办事项督办落实情况的报告（呈林万乐县长）</option>
               <option value="2">县政府督办件落实情况（线上通报）</option>
               <option value="3">县政府督办件落实情况的通报（部门单位）</option>
           </select>
	    </div>
  	</div>
  	<div class="layui-form-item">
	    <label class="layui-form-label">期数</label>
	    <div class="layui-input-block">
             <input type="text" name="qs" lay-verify=""   class="layui-input"  placeholder="请填写数字例如（10）">
	    </div>
  	</div>
  	<div class="layui-form-item">
	    <label class="layui-form-label">导出区间</label>
	    <div class="layui-input-block">
	        <input type="text" class="layui-input" readonly placeholder="请选择日期范围" lay-verify="required" name="yfxz" id="yfxz">
	    </div>
  	</div>
  	<div class="layui-form-item">
	    <div class="layui-input-block">
	       <submit class="layui-btn" lay-submit="" lay-filter="button" >导出</submit>
	    </div>
  	</div>
</form>
<script type="text/javascript" src="../js/layui/layui.js"></script>
<script type="text/javascript" src="tableList.js"></script>

</body>
</html>