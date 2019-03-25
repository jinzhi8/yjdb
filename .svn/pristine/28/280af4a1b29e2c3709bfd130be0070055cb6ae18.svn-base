<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<html>
<head><title>个性化定制错误页面</title>
</head>
<head>
	<link rel="stylesheet" type="text/css" href="test.css"/>
</head>
<body bgcolor="#999999" text="#000000" topmargin="0">
<table width="62%" border="0" cellspacing="1" cellpadding="0" align="center" bgcolor="#000066">
	<tbody>
	<tr>
		<td bgcolor="#FFFFFF">
			<table width="66%" border="0" cellspacing="0" cellpadding="0">
				<tbody>
				<tr>
					<td><img src="userimages/U_001.GIF" width="768" height="96"/></td>
				</tr>
				</tbody>
			</table>
		</td>
	</tr>
	</tbody>
</table>
<td></td>
<tr></tr>
<table></table>
<table width="768" border="0" cellspacing="1" cellpadding="0" align="center" bgcolor="#000066" height="75%" valign="top">
	<tbody>
	<tr valign="top">
		<td bgcolor="#FFFFFF">
			<br/>
			<br/>

			<font color="black">
				<%//先得到属性，如果有属性则覆盖
					javax.servlet.ServletException e = (javax.servlet.ServletException) request.getAttribute("javax.servlet.ServletException");
					if (e != null) {
						exception = e;
						//System.err.println("属性获得！");
					}
//System.err.println(exception.getClass().getName());
					if (exception.getClass().getName().equals("com.office.unify.base.LoginException")) {
						//如果是登录失败则显示重新登录%>
				<p><a href="/">对不起，请重新登录</a></p>

				<p>
					<%}
//exception.printStackTrace(response.getWriter());
						out.println(exception.getMessage());%>
				</p>
			</font>
		</td>
	</tr>
	</tbody>
</table>
</body>
</html>
<!--索思奇智版权所有-->