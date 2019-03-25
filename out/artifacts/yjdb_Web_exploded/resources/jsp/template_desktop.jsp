<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>

<% User userInfo = (User) session.getAttribute("userInfo");
	String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
	if (userInfo == null) {
		try {
			//response.sendRedirect(request.getContextPath() + "/login.jsp");
			return;
		} catch (Exception e) {
			response.sendRedirect(contextPath + "/login.jsp");
			return;
		}
	}
	String userName = userInfo.getUsername();
	String userId = userInfo.getUserId();
	String udepartment = userInfo.getGroup().getGroupname();
	String[] userConfig = userInfo.getUserConfig();
	Group groupInfo = (Group) userInfo.getGroup();
	String idsStr = userInfo.getUserId();
	String userflag = (String) session.getAttribute("userFlag");%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<!--
 <META HTTP-EQUIV="Pragma" CONTENT="no-cache"></META>
 <META HTTP-EQUIV="Cache-Control" CONTENT="no-cache"></META>
 <META HTTP-EQUIV="Expires" CONTENT="0"></META>
 -->
	<title>协同办公系统</title>
	<link href="<%=contextPath%>/resources/template/default/css.css" rel="stylesheet" type="text/css">
	<style>
		html {
			overflow-y: hidden;
			width: 100%;
			height: 100%;
		}

		body {
			overflow-y: hidden;
			margin: 0px;
			background-color: #f5faee;
			width: 100%;
			height: 100%;
		}
	</style>
	<SCRIPT LANGUAGE="JavaScript">
		//<!--
		if (top.location != self.location) top.location = self.location;
		//-->
	</SCRIPT>
</head>
<body class="mainbody">
<table class="maincontent" height="100%">
	<tr>
		<td colspan="2">
			<div class="banner" id="banner">
				<table width="100%">
					<tr>
						<td width="290" align="right">
							<div class="logo"/>
						</td>
						<td>
							<table width="150" border="0" align="right" cellpadding="0" cellspacing="0">
								<tr>
									<td width="44">
										<img src="<%=contextPath%>/resources/template/default/images/banner_bu.png" width="36" height="24">
									</td>
									<td width="43" class="bannerbu">首页</td>
									<td width="43" class="bannerbu">后退</td>
									<td width="43" class="bannerbu">前进</td>
									<td width="43" class="bannerbu">刷新</td>
									<td width="43" class="bannerbu">退出</td>
									<td width="17"></td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</div>
		</td>
	</tr>
	<tr>
		<td width="142px" height="100%">
			<iframe name="menu" src="menu.jsp" width=100% height=100% frameborder=0 scrolling=auto></iframe>
		</td>
		<td height="100%">
			<iframe name=content src="desktop.jsp" width=100% height=100% frameborder=0 scrolling=auto></iframe>
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<div>
				<table width="100%">
					<tr>
						<td class="footer">&nbsp;</td>
					</tr>
				</table>
			</div>
		</td>
	</tr>
</table>
</body>
</html>
<!--索思奇智版权所有-->