<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="com.kizsoft.commons.uum.Visit" %>
<% Visit visit = (Visit) session.getAttribute("visit");
	String username = "";
	if (visit != null) {
		username = (String) visit.getOwner().getOwnername();
	}%>
<html>
<head>
	<title>统一用户管理系统</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<script type="text/javascript" src="js/xtree.js"></script>
	<link href="css/xtree.css" type="text/css" rel="stylesheet"/>
	<link href="css/styles.css" rel="stylesheet" type="text/css"/>
</head>
<body>
<jsp:include page="sessioncheck.jsp" flush="false"/>
<table cellspacing=0 cellpadding=0 width="775" height="100%" align="center" bgcolor="#FFFFFF" class="border-index">
	<tr valign="top">
		<td height="110" background="images/top.jpg"/>
	</tr>
	<tr style="height: 4px;" valign="top">
		<td style=" width: 100%; background-image: url(images/line_pic.jpg); height: 4px;"></td>
	</tr>
	<tr>
		<td width="100%" background="images/bg_top_menu.gif" height="30">
			&nbsp;&nbsp;当前用户:<%=username%>
		</td>
	</tr>
	<tr valign="top" height="450">
		<td height="450">
			<table width="100%" height="450" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="26%">
						<iframe name="toc" src="tree.jsp" id="toc" frameborder="0" width="100%" height="450" scrolling="no" marginwidth="0" marginheight="0"></iframe>
					</td>
					<td width="74%">
						<iframe name="toc1" src="childowner.jsp" frameborder="0" width="100%" height="450" scrolling="no"></iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr valign="bottom" height=2>
		<TD width="100%" background="images/line_pic.jpg" height=2></TD>
	</tr>
	<tr valign="bottom">
		<td height="20" align="center">版权所有&copy;</td>
	</tr>
</table>
</body>
</html>
<!--索思奇智版权所有-->