<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>

<% User userInfo = (User) session.getAttribute("userInfo");
	String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
	if (userInfo == null) {
		try {
			response.sendRedirect(request.getContextPath() + "/login.jsp");
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
	String userflag = (String) session.getAttribute("userFlag");
	String templatename = (String) session.getAttribute("templatename");
%>
<html>
<!--
<META HTTP-EQUIV="Pragma" CONTENT="no-cache" />
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache" />
<META HTTP-EQUIV="Expires" CONTENT="0" />
-->
<head>
	<title><template:get name='title'/></title>
	<template:get name='script'/>
	<template:get name='style'/>
	<style type="text/css">
		html {
			overflow-x: hidden;
			scrollbar-base-color: #d6e4ef;
		}
	</style>
	<script language="javascript" type="text/javascript" charset="utf-8" src="<%=contextPath%>/resources/js/jquery/jquery.js"></script>
	<script language="javascript" type="text/javascript" charset="utf-8" src="<%=contextPath%>/resources/js/workflow/workflow.js"></script>
	<script language="javascript" type="text/javascript" charset="utf-8" src="<%=contextPath%>/resources/js/workflow/selectflow.js"></script>
	<script language="javascript" type="text/javascript" charset="utf-8" src="<%=contextPath%>/resources/js/cims/catalogs.js"></script>
	<script language="javascript" type="text/javascript" charset="utf-8" src="<%=contextPath%>/resources/js/function.js"></script>
	<script language="javascript" type="text/javascript" charset="utf-8" src="<%=contextPath%>/resources/js/kindeditor/kindeditor.js"></script>
	<script language="javascript" type="text/javascript" charset="utf-8" src="<%=contextPath%>/resources/template/<%=templatename%>/js/js.js"></script>
	<script language="javascript" type="text/javascript" charset="utf-8" src="<%=contextPath%>/resources/js/datepicker/WdatePicker.js"></script>
	<script type="text/javascript">
		function deleteattach() {
			var objcheck = document.all.checkboxattach;
			var attachs = "";
			if (!objcheck[0]) {
				if (objcheck.checked) {
					attachs = attachs + objcheck.value + ",";
				}
			} else {
				for (m = 0; m < objcheck.length; m++) {
					if (objcheck[m].checked) {
						attachs = attachs + objcheck[m].value + ",";
					}
				}
			}
			var strurl = replaceAll(window.location.href, "&", "*");
			window.location.href = "<%=contextPath%>/attach?returnurl=" + strurl + "&attachs=" + attachs;
		}
	</script>
	<SCRIPT LANGUAGE="JavaScript">
		//<!--//if (top.location != self.location) top.location=self.location;//-->
	</SCRIPT>
	<link href="<%=contextPath%>/resources/template/<%=templatename%>/css/css.css" rel="stylesheet" type="text/css">
</head>
<body topmargin="0px" bottommargin="0px" leftmargin="0px" rightmargin="0px">
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" style="display:block;">
	<tr>
		<td height="29" background="<%=request.getContextPath()%>/resources/theme/images/bgpt_dqwz_bg.jpg">
			<table border="0" class="position_table" width="100%" cellSpacing=0 cellPadding=0>
				<tr class="menu">
					<td class="position_td" style="width:500px">
						&nbsp;<img src="<%=request.getContextPath()%>/resources/theme/images/bgpt_dqwz_icon.gif" width="10" height="12">&nbsp;您当前的位置：<template:get name="moduleNav"/>
					</td>
					<td class="position_td" style="align:right;">
						<template:get name="viewLinkList"/>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<template:get name='content'/>
</body>
</html><!--索思奇智版权所有-->