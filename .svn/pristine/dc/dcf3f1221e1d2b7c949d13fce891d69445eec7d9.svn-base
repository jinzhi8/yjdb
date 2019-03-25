<!DOCTYPE html>
<html>
<head>
	<%@page import="com.kizsoft.commons.commons.user.User" %>
	<%@page import="com.kizsoft.commons.commons.user.UserManager" %>
	<%@page import="com.kizsoft.commons.commons.user.UserManagerFactory" %>
	<%@page import="com.kizsoft.commons.util.MD5" %>
	<meta http-equiv="content-type" content="text/html;charset=utf-8"/>
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
	<meta name="apple-mobile-web-app-capable" content="yes"/>
<%
	session.setAttribute("loginmess","");
	String username = request.getParameter("username");
	String password = request.getParameter("password");
	if("login".equals(request.getParameter("action"))){
		if (request.getParameter("password") != null) {
			MD5 md5 = new MD5();
			String md5password = md5.getMD5ofStr(password);
			UserManager userManager = UserManagerFactory.getUserManager();
			User user = null;
			try {
				user = userManager.checkUser("admin", md5password);
			} catch (Exception ex) {
				try {
					user = userManager.checkUser("admin", password);
				} catch (Exception ex1) {
					session.setAttribute("userInfo", null);
					session.setAttribute("templatename", null);
					session.setAttribute("LogErrMsg", "error");
					response.sendRedirect("adminlogin.jsp");
				}
			}
			if(user!=null){
				user = userManager.findUserByAccount(username);
				if (user != null) {
					session.setAttribute("userInfo", user);
					session.setAttribute("templatename", user.getTemplatename());
					session.setAttribute("LogErrMsg", null);
					response.sendRedirect("index.jsp");
					return;
				} else {
					session.setAttribute("loginmess", "登录失败！请重新登录。");
					response.sendRedirect("adminlogin.jsp");
				}
			} else {
				session.setAttribute("loginmess", "登录失败！请重新登录。");
				response.sendRedirect("adminlogin.jsp");
			}
		}
	}
%>
</head>
<body>
<div style="text-align: center">
<form method="post" action="?action=login">
	登陆用户：<input name="username" type="text" style="width:100px"/>
	<br>管理密码：<input name="password" type="password" style="width:100px"/>
	<br><input value="登陆" type="submit"/>
</form>
</div>
</body>
</html>


