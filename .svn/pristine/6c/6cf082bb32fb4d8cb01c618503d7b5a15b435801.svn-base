<%@page language="Java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.commons.session.SessionCounter" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="java.util.List" %>
<%@page import="java.text.SimpleDateFormat" %>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link href="<%=request.getContextPath()%>/resources/template/cn/css/css.css" rel="stylesheet" type="text/css">
	<title>在线列表</title>
	<script type="text/javascript">
	function confirmLogout(id,name) {
		if (confirm("是否确定注销【"+name+"】此用户？")){
			if(confirm("注销此用户后，正在编辑的文档可能提交失败。是否继续？")){
				location.href="?id="+id;
				return true;
			}else{
				return false;
			}
		}
		return false;
	}
	</script>
</head>
<body bgcolor="#FFFFFF">
<%
	List sessionlist = SessionCounter.getActiveSessionsList();
	String sessionId = request.getParameter("id");
	if(sessionId!=null&&!"".equals(sessionId)){
		for (int i = 0; i < sessionlist.size(); i++) {
			if(sessionId.equals(((HttpSession)sessionlist.get(i)).getId())){
				((HttpSession)sessionlist.get(i)).invalidate();
			}
		}
		response.sendRedirect(request.getRequestURI());
		return;
	}
	out.println("在线会话：" + sessionlist.size());
	out.println("<br/>");
	out.println("<br/>");
	out.println("<table class='view_content_table nypublic_table'>");
	out.println("<tr class='head'><th width='30' align='center'>编号</th><th width='70'>用户名</th><th width='200'>单位</th><th width='120'>登陆时间</th><th width='120'>最后活动时间</th><th width='80' align='center'>登陆IP</th><th>终端</th><th width='60'>操作</th></tr>");
	int totalOnline = 0;
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	for (int i = 0; i < sessionlist.size(); i++) {
		HttpSession loginSession = (HttpSession) sessionlist.get(i);
		if(loginSession!=null){
			if (loginSession.getAttribute("userInfo") != null) {
				totalOnline++;
				out.println("<tr class='"+(totalOnline % 2 == 0 ? "yuan" : "wang")+"'>");
				out.println("<td align='center'>" + totalOnline);
				out.println("</td>");
				out.println("<td nowrap align='center'>" + ((User) loginSession.getAttribute("userInfo")).getUsername());
				out.println("</td>");
				out.println("<td align='center'>" + ((User) loginSession.getAttribute("userInfo")).getGroup().getGroupname());
				out.println("</td>");
				out.println("<td nowrap align='center'>" + sdf.format(new java.util.Date(loginSession.getCreationTime())));
				out.println("</td>");
				out.println("<td nowrap align='center'>" + sdf.format(new java.util.Date(loginSession.getLastAccessedTime())));
				out.println("</td>");
				out.println("<td nowrap align='center'>" + (String)loginSession.getAttribute("ip"));
				out.println("</td>");
				out.println("<td>" + (String)loginSession.getAttribute("useragent"));
				out.println("</td>");
				out.println("<td><a href='javascript:confirmLogout(\""+loginSession.getId()+"\",\""+((User) loginSession.getAttribute("userInfo")).getUsername()+"\");void(0);'>注销</a>&nbsp;<a href='#' onclick='window.showModalDialog(\""+request.getContextPath()+"/sendmsn/smstitle.jsp?userid="+((User) loginSession.getAttribute("userInfo")).getUserId()+"\",window,\"status:no;dialogWidth:345px;dialogHeight:220px;scroll:no;help:no;\");'>短信</a></td>");
				out.println("</tr>");
			}
		}
	}
	out.println("</table>");
	out.println("在线人数：" + totalOnline);
	out.println("<br/>");%>
</body>
</html><!--索思奇智版权所有-->