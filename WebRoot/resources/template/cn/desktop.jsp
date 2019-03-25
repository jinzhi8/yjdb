<%@page language="java" contentType="text/html;charset=UTF-8" %>

<%@page import="com.kizsoft.commons.acl.ACLManager" %>
<%@page import="com.kizsoft.commons.acl.ACLManagerFactory" %>
<%@page import="com.kizsoft.commons.commons.db.ConnectionProvider" %>
<%@page import="com.kizsoft.commons.commons.config.SystemConfig" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.commons.orm.SimpleORMUtils" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.sql.Timestamp" %>
<%@page import="java.util.*" %>
<%@page import="java.lang.*" %>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>

<% User userInfo = (User) session.getAttribute("userInfo");
	String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
	if (userInfo == null) {
		try {
			response.sendRedirect(contextPath + "/login.jsp");
			return;
		} catch (Exception e) {
			response.sendRedirect(contextPath + "/login.jsp");
			return;
		}
	}
	
%>

<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title><%=SystemConfig.getFieldValue("//systemconfig/system/name")%></title>
	<link href="<%=contextPath%>/resources/template/cn/css/style.css" rel="stylesheet" type="text/css">
	<script language="javascript" type="text/javascript" charset="utf-8" src="<%=contextPath%>/resources/js/jquery/jquery-1.11.0.min.js"></script>
	<style type="text/css">
	
	</style>
	<script type="text/javascript" language="javascript"> 
		
	</script>
</head>
<body >
<img style="width:100%;height:100%"  src="<%=contextPath%>/resources/template/cn/images/desktop.jpg"/>

</body>
</html>
<!--索思奇智版权所有-->