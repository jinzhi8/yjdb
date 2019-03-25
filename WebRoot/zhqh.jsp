<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" class="loginHtml">
<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="java.net.*"%>
<%@taglib prefix="html" uri="/WEB-INF/struts-html.tld" %>
<%@page import="com.kizsoft.commons.commons.config.SystemConfig" %>
<%
	String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
	String redirectPath = (String) request.getAttribute("redirectpath");
	redirectPath = redirectPath == null ? "" : redirectPath;
	session.setAttribute("userInfo", null);
	String errMsg = (String)session.getAttribute("LogErrMsg");
%>
<head>
<meta charset="UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge"> 
<meta name="viewport" content="width=device-width, initial-scale=1"> 
<title><%=SystemConfig.getFieldValue("/config/systemconfig.xml", "//systemconfig/system/name")%></title>
<link rel="stylesheet" href="resources/template/cn/layui/css/layui.css" media="all" />
<link rel="stylesheet" href="resources/template/cn/css/public.css" media="all" />
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/jquery/jquery.js"></script>
</head>
<body class="loginBody">
	<div class="layui-form">
				<html:form action="login.do" focus="username" >
					<html:hidden property="userflag" value="1"/>
					<html:hidden property="depid" value=""/>
					
					<div class="login_face"><img src="resources/template/cn/images/Galogo.png" class="userAvatar"></div>
					<div class="layui-form-item input-item">
						<label for="userName">用户名</label>
						<input type="text" placeholder="请输入用户名" autocomplete="off" name="username" id="userName" class="layui-input" lay-verify="required">
					</div>
					<div class="layui-form-item input-item">
						<label for="password">密码</label>
						<input type="password" placeholder="请输入密码" autocomplete="off" name="password" id="password" class="layui-input" lay-verify="required">
					</div>
					<div class="layui-form-item">
			          <input type="checkbox" lay-skin="primary" title="记住密码" id="issave" name="issavepassword" value="1">
			        </div>
					<div class="layui-form-item">
						<button class="layui-btn layui-block sub" lay-submit lay-filter="sub">登录</button>
						<!--<a class="act-but submit" href="https://41.246.147.7:8443/tzgaww/ZsTest/TzgaZs.jsp" style="color: #FFFFFF">证书登录</a>-->
					</div>
					
			</html:form>				 
	</div>
	
<script type="text/javascript" src="resources/template/cn/layui/layui.js"></script>
</body>

</html>