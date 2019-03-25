<%@page language="java" contentType="text/html;charset=UTF-8"%>
<%@ page isELIgnored="true" %> 
<%@taglib prefix="oa" uri="/WEB-INF/oa.tld" %>
<%
if (session.getAttribute("userInfo") == null) {
	response.sendRedirect(request.getContextPath() + "/login.jsp");
	return;
}
String pageIndex = request.getParameter("page");
pageIndex = (pageIndex==null||"".equals(pageIndex))?"1":pageIndex;
String formatname = request.getParameter("format");
String templatename = (String) session.getAttribute("templatename");
pageContext.setAttribute("viewConfig", formatname);
request.setAttribute("page", pageIndex);
%>
<html>
<head>
<link href="<%=request.getContextPath()%>/resources/template/<%=templatename%>/css/css.css" rel="stylesheet" type="text/css">
</head>
<body style="margin:0px;">
<oa:showview format="{pageContext.viewConfig}" page="1" desktop="1"/>
<!--索思奇智版权所有-->
</body>
</html>