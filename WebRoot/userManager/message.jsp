<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String reloadParent = (String) request.getAttribute("reloadParentNode");
	String closeflag = (String) request.getAttribute("closeflag");%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link href="css/default.css" rel="stylesheet" type="text/css">
</head>

<script language="javascript1.2">
	<%if (reloadParent !=null && reloadParent.equals("true")){%>
	opener.window.reload();
	<%}%>
	<%if (closeflag !=null && closeflag.equals("true")){%>
	window.close();
	<%}%>
	window.focus();
	function closeFunc() {
		window.close();
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
					保存成功！
					<p>
						<input type=button name=btnok class="btn" onClick="closeFunc()" value="关闭">
					</p>
				</div>
			</div>
		</td>
	</tr>
</table>
</html>
<!--索思奇智版权所有-->