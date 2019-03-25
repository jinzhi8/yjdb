<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.login.UserFlagManage" %>
<%@page import="com.kizsoft.commons.acl.ACLManager" %>
<%@page import="com.kizsoft.commons.acl.ACLManagerFactory" %>
<%@taglib prefix="html" uri="/WEB-INF/struts-html.tld" %>
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
	String userID = userInfo.getUserId();
	String udepartment = userInfo.getGroup().getGroupname();
	String[] userConfig = userInfo.getUserConfig();
	String depHeaderIMG = userConfig[0];
	String depFooterIMG = userConfig[1];
	String depStyleCSS = userConfig[2];
	String userflag = (String) session.getAttribute("userFlag");
	Group groupInfo = (Group) userInfo.getGroup();

	ACLManager aclManager = ACLManagerFactory.getACLManager();
	String templatestr= "/resources/template/cn/index.jsp";
%>
<% 
	UserFlagManage userflagManage = new UserFlagManage();
	String UserFlag = userflagManage.UserFlagValue(userID);
	if (UserFlag == null) UserFlag = "";
	session.setAttribute("userFlag", UserFlag); 
%>
<template:insert template="<%=templatestr%>">
	<template:put name='title' content='' direct='true'/>
	<% String str = "<a href=\"compiles\"></a>"; %>
	<template:put name='moduleNav' content='<%=str%>' direct='true'/>
	<template:put name='content'><!----></template:put>
</template:insert>
<!--索思科技版权所有-->