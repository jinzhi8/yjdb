<%@page language="java" contentType="text/html;charset=UTF-8" %>

<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>

<%@taglib prefix="html" uri="/WEB-INF/struts-html.tld" %>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<%@taglib prefix="bean" uri="/WEB-INF/struts-bean.tld" %>
<%if (session.getAttribute("userInfo") == null) {
	response.sendRedirect(request.getContextPath() + "/login.jsp");
} else {
String userTemplateName = (String) session.getAttribute("templatename");
String userTemplateStr = "/resources/template/" + userTemplateName + "/template.jsp";
if(userTemplateName==null||"".equals(userTemplateName)){
	userTemplateStr = "/resources/jsp/template.jsp";
}
%>
<template:insert template="<%=userTemplateStr%>">
	<template:put name='title' content='工作流管理' direct='true'/>
	<%String str = "<a class=\"menucur\" href=\"\">工作流管理</a>"; %>
	<template:put name='moduleNav' content='<%=str%>' direct='true'/>
	<template:put name='content'>


		<%//用户登陆验证
			User userInfo = (User) session.getAttribute("userInfo");
			String userID = userInfo.getUserId();
			Group groupInfo = userInfo.getGroup();
			String groupID = groupInfo.getGroupId();
			String idsStr = userID;%>

		<style type="text/css">
			.leftvcd{width:230px;height:100%;position:absolute;border-right: #eeeeee 3px solid;}
			.rightnrvcd{height:100%;position:absolute;left:230px;right:0px;}
		</style>
		<%String contextpath = "http://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath();%>
		<table border="0" align="center" cellpadding="0" cellspacing="0" class="round" style="width:100%;height:95%;position:absolute">
			<tr>
				<td class="left_col leftvcd" valign="top">
					<iframe frameborder="0" scrolling="no" name="mframe" src="nav2.jsp" style="width:100%;height:100%;"></iframe>
				</td>
				<td valign="top" class="rightnrvcd">
					<!--end content-->
					<iframe frameborder="0" scrolling="yes" name="cframe" src="mxGraph.jsp" style="width:100%;height:100%;"></iframe>
				</td>
			</tr>
		</table>

	</template:put>
</template:insert>
<%}%>
<!--索思奇智版权所有-->