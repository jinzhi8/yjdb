<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<html>
<head>
	<title>错误提醒</title>
	<link href="<%=request.getContextPath()%>/resources/jsp/css.css" type="text/css" rel="stylesheet"/>
	<link href="<%=request.getContextPath()%>/resources/css/application.css" type="text/css" rel="stylesheet"/>
</head>
<body bgcolor="#C3E5F0" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td align="center" bgcolor="#ffffff">
			<br>
			<br>
			<table width="770" border="0" align="center" cellpadding="0" cellspacing="0">
				<tr>
					<td align="center">
						提示信息：您没有权限查看！
					</td>
				</tr>
			</table>
			<br>
			<br>
			<br>
			<div align="center">
				<input type="button" class="formbutton" value="关闭窗口" onclick="window.close()">
			</div>
			<br>
		</td>
	</tr>
</table>
</body>
</html><!--索思奇智版权所有-->