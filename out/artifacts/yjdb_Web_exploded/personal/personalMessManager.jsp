<%@page language="java" contentType="text/html;charset=UTF-8" %>

<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%
User userInfo = (User) session.getAttribute("userInfo");
	if (userInfo == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
return;
	} 
%>
<%
String userTemplateName = (String) session.getAttribute("templatename");
String userTemplateStr = "/resources/template/" + userTemplateName + "/template.jsp";
if(userTemplateName==null||"".equals(userTemplateName)){
	userTemplateStr = "/resources/jsp/template.jsp";
}
%>
<template:insert template="<%=userTemplateStr%>">
	<template:put name='title' content='个人批示管理' direct='true'/>
	<%String str = "<a class=\"menucur\" href=\"\">个人批示管理</a>";%>
	<template:put name='moduleNav' content='<%=str%>' direct='true'/>
	<template:put name='content'>
	<div style="margin: 0px 25px;">
		<% String moduleID = null;
			String userID = userInfo.getUserId();
			Group groupInfo = userInfo.getGroup();
			String groupID = groupInfo.getGroupId();
			String idsStr = userID;%>
		<jsp:include page="personalMessengerView.jsp">
			<jsp:param name="userId" value="<%=userID%>"/>
		</jsp:include>
	</div>	
	</template:put>
</template:insert>
<!--索思奇智版权所有-->