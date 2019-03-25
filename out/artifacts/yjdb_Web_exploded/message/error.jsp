<%@page language="java" contentType="text/html;charset=UTF-8" %>
<html>
<head>
	<title>
		错误提醒 </title>
</head>
<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<br><br>
<table width="100%" height="300px">
	<tr class="main_row">
		<td align="center">
			<!--<img src="<%=request.getContextPath()%>/resources/other/forbid.jpg" border="0">-->
			提示信息：您没有权限查看该文档!
		</td>
	</tr>
	<tr>
		<td align="center">
			<input type="button" value="点击返回" class="formbutton" onclick="history.back();">
		</td>
	</tr>
</table>
</body>
</html>
<!--索思奇智版权所有-->