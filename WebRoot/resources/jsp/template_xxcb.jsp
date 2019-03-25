<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<% User userInfo = (User) session.getAttribute("userInfo");
	if (userInfo == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
	} else {
		String userName = userInfo.getUsername();
		String udepartment = userInfo.getGroup().getGroupname();
		String[] userConfig = userInfo.getUserConfig();%>

<html>
<head>
	<title>
		<template:get name='title'/>
	</title>
	<link href="<%=request.getContextPath()%>/resources/css/<%=userConfig[2]%>" type="text/css" rel="stylesheet"/>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" style="background-image: url(<%=request.getContextPath()%>/resources/theme/images/bg.png);	background-repeat: repeat-x; background-color:E0F6FF">
<table width="770" border="0" cellspacing="0" cellpadding="0" align="center" style="border:1px solid #38CCE7">
	<tr>
		<td align="center" bgcolor="#996666">
			<table width=770 border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td colspan=3 background="" bgcolor=#ffffff>
						<jsp:include page="/resources/jsp/newGov_header.jsp"/>
						<div style="width:100%">
							<jsp:include page="/desktop/menu.jsp"/>
						</div>
						<table width="770" border="0" align="center" cellpadding="0" cellspacing="0">
							<tr>
								<td height="29" background="<%=request.getContextPath()%>/resources/theme/images/bgpt_dqwz_bg.jpg">
									<table border="0" class="position_table" width="100%" cellSpacing=0 cellPadding=0>
										<tr class="menu">
											<td class="position_td" width="400px" style="width:500px">
												&nbsp;<img src="<%=request.getContextPath()%>/resources/theme/images/bgpt_dqwz_icon.gif" width="10" height="12">&nbsp;您当前的位置：<template:get name="moduleNav"/>
											</td>
											<td class="menu" style="width:160px">
												<%=udepartment%>：<%=userName%>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
						<template:get name='content'/>
						<jsp:include page="/resources/jsp/newGov_footer.jsp"/>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</body>
</html>
<%}%>
<!--索思奇智版权所有-->