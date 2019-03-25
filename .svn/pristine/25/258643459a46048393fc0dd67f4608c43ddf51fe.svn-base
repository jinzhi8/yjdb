<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link href="css/default.css" rel="stylesheet" type="text/css">
</head>

<script language="javascript1.2">
	opener.window.reload1();
	window.focus();
	function closeFunc() {
		window.close();
	}
	function backFunc() {
		window.history.go(-1);
	}
</script>
<table width="500" border="0" align="center" cellpadding="0" cellspacing="0" height="100%">
	<tr>
		<td>
			<div class="sidebox" height="100%">
				<div class="boxhead">
					<h2>系统信息</h2>
				</div>
				<div class="boxbody">
					<%String mes = (String) request.getAttribute("message");%>
					<%=mes%>
					<p>
						<input type=button name=btnok class="btn" onClick="closeFunc()" value="关闭">
						<a href=# onclick="backFunc()">重新输入</a>
					</p>
				</div>
			</div>
		</td>
	</tr>
</table>
</html>
<!--索思奇智版权所有-->