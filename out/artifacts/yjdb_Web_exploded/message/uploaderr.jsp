<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="html" uri="/WEB-INF/struts-html.tld" %>
<html>
<head>
	<title>
		错误提醒 </title>
</head>
<body bgcolor="#C3E5F0" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<br><br>
<table width="100%" height="300px">
	<tr class="main_row">
		<td align="center"><font color="red"><html:errors/></font></td>
	</tr>
	<tr class="main_row">
		<td align="center">
			<img src="<%=request.getContextPath()%>/resources/other/tolarge.gif" border="0">
		</td>
	</tr>
	<tr id="close1">
		<td align="center">
			<input type="button" value="关&nbsp;闭" class="formbutton" onclick="window.close()">
		</td>
	</tr>
	<tr id="back">
		<td align="center">
			<input type="button" value="返&nbsp;回" class="formbutton" onclick="history.back()">
		</td>
	</tr>
</table>
</body>
</html>

<script language="javascript">
	if (window.opener != null) {
		close1.style.display = "inline";
		back.style.display = "none";
	} else {
		close1.style.display = "none";
		back.style.display = "inline";
	}
</script><!--索思奇智版权所有-->