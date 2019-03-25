<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.module.beans.*" %>
<%@page import="java.util.ArrayList" %>

<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<%@taglib prefix="html" uri="/WEB-INF/struts-html.tld" %>
<%if (session.getAttribute("userInfo") == null) {
	response.sendRedirect(request.getContextPath() + "/login.jsp");
	return;
}%>
<%
String userTemplateName = (String) session.getAttribute("templatename");
String userTemplateStr = "/resources/template/" + userTemplateName + "/template.jsp";
if(userTemplateName==null||"".equals(userTemplateName)){
	userTemplateStr = "/resources/jsp/template.jsp";
}
%>
<template:insert template="<%=userTemplateStr%>">
	<template:put name='title' content='模块管理' direct='true'/>
	<%String str = "<a class=\"menucur\" href=\"\">模块管理</a>";%>
	<template:put name='moduleNav' content='<%=str%>' direct='true'/>
	<template:put name='content'>

		<%//用户登陆验证
			User userInfo = (User) session.getAttribute("userInfo");
			String moduleID = null;
			String userID = userInfo.getUserId();
			Group groupInfo = userInfo.getGroup();
			String groupID = groupInfo.getGroupId();
			String idsStr = userID;%>
		<%//页面初始化
			moduleID = "moduleManager";
			String cType = request.getParameter("type");
			if (cType == null) {
				cType = "module";
			}
			ArrayList fileList;
			ModuleManager moduleManager = new ModuleManager();
			ModuleInfo moduleInfo;
			ModuleType moduleTypeInfo;%>
		<style type="text/css">
			.leftvcd{width:230px;height:100%;position:absolute;}
			.rightnrvcd{height:100%;position:absolute;left:230px;right:0px;}
		</style>
		<table border="0" class="main_table" width="100%" height="100%">
			<tr class="main_row">
				<!--search+viewlink-->
				<td class="left_col leftvcd" valign="top">
					<iframe frameborder="0" scrolling="auto" src="nav.jsp" width="100%" height="100%" name="mframe"></iframe>
					<!--jsp:include page="nav.jsp" />-->
				</td>
				<!--View Content-->
				<td valign="top" class="rightnrvcd">
					<table border="0" width="100%" height="100%" class="content">
						<tr height="30px">
							<td>
								<!--action-->
								<%

									ModuleActionManager moduleActionManager = new ModuleActionManager();
									ArrayList actionsList = (ArrayList) moduleActionManager.getUserActionList(moduleID, idsStr);

									for (int i = 0; i < actionsList.size(); i++) {
										ModuleAction moduleAction = (ModuleAction) actionsList.get(i);
										if (moduleAction.getActionImgURL() == null || "".equals(moduleAction.getActionImgURL())) {%>
								<a class="viewbutton" hidefocus href="<%=moduleAction.getActionURL()%>"><span><%=moduleAction.getActionName()%></span></a>
								<%} else {%>
								<input type="image" src="<%=moduleAction.getActionImgURL()%>" onclick="<%=moduleAction.getActionURL()%>" title="<%=moduleAction.getActionName()%>">
								<%}
								}%>
							</td>
						</tr>
						<tr>
							<td valign="top">
								<!--end content-->
								<iframe frameborder="0" width="100%" height="100%" name="cframe"></iframe>
							</td>
						</tr>
					</table>
				</td>
				<!-- Other Link-->
				<td class="right_col"></td>
			</tr>
		</table>
		<LINK REL="stylesheet" TYPE="text/css" HREF="css/iaddress.css"/>
	</template:put>
</template:insert><!--索思奇智版权所有-->