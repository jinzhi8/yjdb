<%@page language="java" contentType="text/html;charset=UTF-8" %>

<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.commons.user.UserException" %>
<%@page import="com.kizsoft.commons.commons.user.UserManager" %>
<%@page import="com.kizsoft.commons.commons.user.UserManagerFactory" %>

<% 
	User userInfo = (User) session.getAttribute("userInfo");
	String message = (String) request.getAttribute("message");
	if (message == null) {
		message = "";
	}
	User newUserInfo = null;
	UserManager userManager = UserManagerFactory.getUserManager();
	try {
		newUserInfo = userManager.findUser(userInfo.getUserId());
		//session.invalidate();
		session.setAttribute("userInfo", null);
		session.setAttribute("userInfo", newUserInfo);
	} catch (Exception e) {
		e.printStackTrace();
	}
%>
<script language="javascript">
	alert("<%=message%>");
	window.history.go(-2);
</script><!--索思奇智版权所有-->