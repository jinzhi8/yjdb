<%@page language="java" contentType="text/html;charset=UTF-8" %>

<%@page import="com.kizsoft.commons.commons.user.User" %>
<% User userInfo = (User) session.getAttribute("userInfo");
	String userName = userInfo.getUsername();
	String udepartment = userInfo.getGroup().getGroupname();
	String[] userConfig = userInfo.getUserConfig();%>
<%if (userConfig[0].indexOf(".swf") == -1) { %>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<image src="<%=request.getContextPath()%>/resources/theme/images/<%=userConfig[0]%>" width="100%" height="137">
		</td>
	</tr>
</table>
<%} else { %>
<iframe width=100% frameborder=0 height=127 scrolling='no' src='<%=request.getContextPath()%>/resources/jsp/swf.jsp'></iframe>
<% } %>
<!--
<table width="100%" height="38" border="0" align="center" cellpadding="0" cellspacing="0" background="<%=request.getContextPath()%>/resources/theme/images/bgpt_menu_bg.jpg">
<tr>
<td width="234" align="center">&nbsp;</td>
<td width="486" align="right"><img src="<%=request.getContextPath()%>/resources/theme/images/bgpt_menu_icon4.gif" width="26" height="25">
<a href="<%=request.getContextPath()%>/logout.jsp">退出系统</a>　　<img src="<%=request.getContextPath()%>/resources/theme/images/bgpt_menu_icon5.gif" width="27" height="26">
<a href="#">帮助</a></td><td width="50px"></td>
</table>
-->
<!--索思奇智版权所有-->