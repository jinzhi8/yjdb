<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="java.util.Date"%>
<%@page import="java.util.Map"%>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.sql.Clob" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.yjdb.utils.CommonUtil" %>
<%@page import="com.kizsoft.commons.commons.orm.MyDBUtils"%>
<%@page import="com.kizsoft.yjdb.utils.GsonHelp"%>
<!DOCTYPE html>
<html>
<%
	 //用户登陆验证
	 if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
	 }
	 User userInfo = (User) session.getAttribute("userInfo");
	 String userID = userInfo.getUserId();
	 String userName = userInfo.getUsername();
	 Group groupInfo = userInfo.getGroup();
	 String groupName = groupInfo.getGroupname();
	 String groupID = groupInfo.getGroupId();
%>
<head>
	<meta charset="utf-8">
	<meta name="renderer" content="webkit">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
	<meta name="apple-mobile-web-app-status-bar-style" content="black">
	<meta name="apple-mobile-web-app-capable" content="yes">
	<meta name="format-detection" content="telephone=no">
	<link rel="stylesheet" href="../js/layui/css/layui.css" media="all" />
	<link rel="stylesheet" href="../css/public.css" media="all" />
	<script type="text/javascript" src="../js/layui/layui.js"></script>
	<script type="text/javascript" src="../js/jquery-1.11.0.min.js"></script>
	<script type="text/javascript" src="../js/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="newsAdd.js"></script>
</head>
<body class="childrenBody">
<form class="layui-form layui-row layui-col-space10"  id="infoform" enctype="multipart/form-data" method="post" >	
	<div align=center>
		<fieldset class="layui-elem-field layui-field-title" style="margin-top: 30px;">
		  <legend>拖拽上传</legend>
		</fieldset> 
		 
		<div class="layui-upload-drag" id="test10">
		  <i class="layui-icon"></i>
		  <p>点击上传，或将文件拖拽到此处</p>
		</div>
	</div>
</form>
<script language="javascript" type="text/javascript" charset="utf-8" src="../resources/js/layer/layerFunction.js"></script>
</body>
</html>