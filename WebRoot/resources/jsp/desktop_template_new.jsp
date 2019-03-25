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
<template:get name='content'/>

<!--索思奇智版权所有-->