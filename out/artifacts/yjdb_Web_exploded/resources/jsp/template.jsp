<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleAction" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleActionManager" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleView" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleViewManager" %>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>

<% 	
	User userInfo = (User) session.getAttribute("userInfo");
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
	String viewID = (String)request.getAttribute("moduleIDs");
	
%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<title><template:get name='title'/></title>
	<template:get name='script'/>
	<template:get name='style'/>
	<style type="text/css">
	.tab-line{
	background-color: #fff;
	margin-bottom: 0;
}
.search-wrap{
	display: flex;
	background-color: #f5f5f5;
}
.search-wrap blockquote {
	flex: 1;
	padding: 10px;
}
.search-wrap .btn-wrap{
	display: flex;
	justify-content: flex-end;
	align-items: flex-end;
	padding: 0 15px;
	margin: 10px 0;
	flex-flow: row wrap;
}
.search-wrap .btn-wrap .btn-item{

 text-align: center;
 float: left;
}
.search-wrap .btn-wrap button{
	margin: 5px;
}
.search-wrap .search-item{
	float: left;
	margin: 5px;
}
.search-item label{
	text-align: right;
	display: inline-block;
	vertical-align: middle;
}
.position_td img{
	margin-top: -1px;
}
	</style>
	<link href="<%=contextPath%>/resources/template/cn/layui/css/layui.css" rel="stylesheet" rel="stylesheet"  type="text/css">
	<script language="javascript" type="text/javascript" charset="utf-8" src="<%=contextPath%>/resources/js/jquery/jquery-1.11.0.min.js"></script>
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
	<link href="<%=contextPath%>/resources/template/<%=templatename%>/css/css.css" rel="stylesheet" type="text/css">
</head>
<body topmargin="0px" bottommargin="0px" leftmargin="0px" rightmargin="0px">
<script language="javascript" type="text/javascript" charset="utf-8" src="<%=contextPath%>/resources/template/cn/layui/layui.js"></script>
<!--<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" style="display:block;background-color:white;">
	<tr>
		<td height="29">
			<table border="0" class="position_table" width="100%" cellSpacing=0 cellPadding=0>
				<tr class="menu">
					<td class="position_td" style="width:500px"><img src="<%=request.getContextPath()%>/resources/theme/images/bgpt_dqwz_icon.gif" width="10" height="12">&nbsp;您当前的位置：<template:get name="moduleNav"/>
					</td>
					<td class="position_td" style="align:right;">
						<template:get name="viewLinkList"/>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>-->
<template:get name='content'/>
<script>
layui.use('form', function(){
  var form = layui.form;
  
});
</script>
</body>
</html><!--索思科技版权所有-->