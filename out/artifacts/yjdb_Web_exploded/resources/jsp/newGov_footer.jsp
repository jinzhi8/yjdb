<%@page language="java" contentType="text/html;charset=UTF-8" %>

<%@page import="com.kizsoft.commons.commons.user.User" %>
<% User userInfo = (User) session.getAttribute("userInfo");
	String userName = userInfo.getUsername();
	String udepartment = userInfo.getGroup().getGroupname();
	String[] userConfig = userInfo.getUserConfig();%>
<table width="770" border="0" align="center" cellpadding="0" cellspacing="0">
	<tr>
		<td><img src="<%=request.getContextPath()%>/resources/theme/images/<%=userConfig[1]%>" width="770"></td>
	</tr>
</table><!--索思奇智版权所有-->