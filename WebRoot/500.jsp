<%@page language="java" contentType="text/html;charset=UTF-8"%>
<%
    response.setStatus(200); 
%>
<html>
<head>
<style type="text/css">
.formbutton{
width:66px;HEIGHT:25px;BORDER-RIGHT: #54c620 1px solid; PADDING-RIGHT: 2px; BORDER-TOP: #54c620 1px solid; PADDING-LEFT: 2px; FONT-SIZE: 12px; FILTER: progid:DXImageTransform.Microsoft.Gradient(GradientType=0, StartColorStr=#b8ed47, EndColorStr=#3cad11); BORDER-LEFT: #54c620 1px solid; CURSOR: hand; COLOR: #ffffff; PADDING-TOP: 2px; BORDER-BOTTOM: #54c620 1px solid;font-weight:bold;font-size:12px;
}
</style>
<title>
服务暂时不可用
</title>
</head>
<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<br><br>
<table width="100%" height="200px">
	<tr>
		<td align="center">
			<font color="red"><b>服务暂时不可用！请稍候再试！</b></font>
		</td>
	</tr>
	<tr>
		<td align="center">
			<input type="button" value="关&nbsp;闭" class="formbutton" onclick="window.close()">
			<input type="button" value="返&nbsp;回" class="formbutton" onclick="history.back();">
			<input type="button" value="首&nbsp;页" class="formbutton" onclick="location.href='/';">
		</td>
	</tr>
</table>
</body>
</html>
<!--索思奇智版权所有-->