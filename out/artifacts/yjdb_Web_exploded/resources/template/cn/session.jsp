<%@page language="Java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.commons.session.SessionCounter" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="java.util.List" %>
<%@page import="java.text.SimpleDateFormat" %>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>在线列表</title>
<body bgcolor="#FFFFFF">
<!--在线人数:<%=SessionCounter.getActiveSessions()%>-->
<% List sessionlist = SessionCounter.getActiveSessionsList();
	out.println("在线会话：" + sessionlist.size());
	out.println("<br/>");
	int totalOnline = 0;
	SimpleDateFormat sdf = new SimpleDateFormat("H:mm:ss");
	for (int i = 1; i <= sessionlist.size(); i++) {
		//out.println("__"+sessionlist.get(i-1));
		//out.println(((HttpSession)sessionlist.get(i-1)).getLastAccessedTime());
		if (((HttpSession) sessionlist.get(i - 1)).getAttribute("userInfo") != null) {
			totalOnline++;
			out.println("用户名：" + ((User) ((HttpSession) sessionlist.get(i - 1)).getAttribute("userInfo")).getUsername());
			out.println("<br/>");
			out.println("登陆时间：" + sdf.format(new java.util.Date(((HttpSession) sessionlist.get(i - 1)).getCreationTime())));
			out.println("<br/>");
			out.println("操作时间：" + sdf.format(new java.util.Date(((HttpSession) sessionlist.get(i - 1)).getLastAccessedTime())));
			out.println("<br/>");
			//out.println("<a href=/oa/index.jsp?;jsessionid="+((HttpSession) sessionlist.get(i - 1)).getId()+">点击此处</a>");
			out.println("<br/>");
		}
	}
	out.println("在线人数：" + totalOnline);
	out.println("<br/>");%>
</body>
</html><!--索思奇智版权所有-->