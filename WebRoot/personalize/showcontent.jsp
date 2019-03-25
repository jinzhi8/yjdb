<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@taglib prefix="oa" uri="/WEB-INF/oa.tld" %>
<%
if (session.getAttribute("userInfo") == null) {
	response.sendRedirect(request.getContextPath() + "/login.jsp");
	return;
}
String formatname = request.getParameter("format");
String templatename = (String) session.getAttribute("templatename");
pageContext.setAttribute("viewConfig", formatname);
%>
<html>
<head>
<link href="<%=request.getContextPath()%>/resources/template/<%=templatename%>/css/css.css" rel="stylesheet" type="text/css">
</head>
<body style="margin:0px;">
<oa:showview page="1" format="{pageContext.viewConfig}" desktop="1"/>
<!--索思奇智版权所有-->
</body>
</html>