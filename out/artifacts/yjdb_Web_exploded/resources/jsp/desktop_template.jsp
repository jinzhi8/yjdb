<%@page language="java" contentType="text/html;charset=UTF-8" %>

<%@page import="com.kizsoft.commons.Constant" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>

<% String[] userConfig;
	String userName = "";
	String udepartment = "";
	//用户登陆验证
	if (session.getAttribute("userInfo") != null) {
		User userInfo = (User) session.getAttribute("userInfo");
		Group groupInfo = userInfo.getGroup();
		userName = userInfo.getUsername();
		udepartment = groupInfo.getGroupname();
		userConfig = userInfo.getUserConfig();
	} else {
		userConfig = new String[3];
		userConfig[0] = Constant.HEADER_IMG;
		userConfig[1] = Constant.FOOTER_IMG;
		userConfig[2] = Constant.STYLE_CSS;
	}%>
<html>
<head>
	<title>
		<template:get name='title'/>
	</title>
	<link href="<%=request.getContextPath()%>/resources/css/<%=userConfig[2]%>" type="text/css" rel="stylesheet"/>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" style="background-image: url(<%=request.getContextPath()%>/resources/theme/images/bg.png);	background-repeat: repeat-x; background-color:E0F6FF">
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td align="center">
			<table width="770" border=0 cellpadding=0 cellspacing=0 bgcolor="#ffffff" align="center" style="border:1px solid #38CCE7">
				<tr>
					<td colspan=3 bgcolor=#ffffff>
						<%if (userConfig[0].indexOf(".swf") == -1) { %>
						<table width="770" border="0" align="center" cellpadding="0" cellspacing="0">
							<tr>
								<td>
									<image src="<%=request.getContextPath()%>/resources/theme/images/<%=userConfig[0]%>" width="770">
								</td>
							</tr>
						</table>
						<%} else { %>
						<iframe width=100% frameborder=0 height=127 scrolling='no' src='<%=request.getContextPath()%>/resources/jsp/swf.jsp'></iframe>
						<% } %>
						<%if (session.getAttribute("userInfo") != null) {%>
						<div style="width:100%">
							<jsp:include page="/desktop/menu.jsp"/>
						</div>
						<%}%>
						<table width="770" border="0" align="center" cellpadding="0" cellspacing="0">
							<tr>
								<td height="29" background="<%=request.getContextPath()%>/resources/theme/images/bgpt_dqwz_bg.jpg">

									<table border="0" class="position_table" width="100%" cellSpacing=0 cellPadding=0>
										<tr class="menu">
											<td class="position_td" width="350px" style="width:350px">
												&nbsp;<img src="<%=request.getContextPath()%>/resources/theme/images/bgpt_dqwz_icon.gif" width="10" height="12">&nbsp;您当前的位置：
												<script language="javascript" src="<%=request.getContextPath()%>/resources/js/homepage.js"></script>
												<a class="menucur" href="<%=request.getContextPath ()%>/desktop.jsp">首页</a>
												<template:get name="moduleNav"/></td>
											<td class="menu" width="230px" style="width:230px">
												<%if (session.getAttribute("userInfo") != null) {%>
												<%=udepartment%>：<%=userName%>
												<%}%>
											</td>
											<td class="menu" width="160px" style="width:160px" valign="top">
												<img src="<%=request.getContextPath()%>/resources/theme/images/bgpt_menu_icon4.gif" width="20" height="22">
												<a href="<%=request.getContextPath()%>/logout.jsp"><font color="#000000">退出系统</font></a>
												　<img src="<%=request.getContextPath()%>/resources/theme/images/bgpt_menu_icon5.gif" width="27" height="22">
												<a href="<%=request.getContextPath()%>/share/index.jsp"><font color="#000000">帮助</font></a>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
						<template:get name='content'/>
						<table width="770" border="0" align="center" cellpadding="0" cellspacing="0">
							<tr>
								<td>
									<img src="<%=request.getContextPath()%>/resources/theme/images/<%=userConfig[1]%>" width="770">
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</body>
</html>
<!--索思奇智版权所有-->