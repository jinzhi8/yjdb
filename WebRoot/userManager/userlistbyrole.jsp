<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@page import="com.kizsoft.commons.acl.pojo.Acluser" %>
<%@page import="java.util.List" %>

<% List userlist = (List) request.getAttribute("userlist");
	String roleid = (String) request.getAttribute("roleid");%>
<html>
<head>
	<title>统一用户管理</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<script type="text/javascript" src="js/comm.js"></script>
	<link href="css/styles.css" rel="stylesheet" type="text/css"/>
</head>

<body style="background:#FFFFFF;">
<form name=form1 action="aclroleAction.do" method="post">
	<br/>
	<table cellspacing="1" align="center" width="400" class="table-view">
		<tr valign="top" height="10">
			<input type=hidden name="roleid" value="<%=roleid%>">
			<th height="30" align="center" class="table-header">登陆名</th>
			<th height="30" align="center" class="table-header">真实姓名</th>
			<th height="30" align="center" class="table-header">删除</th>
		</tr>
		<% for (int i = 0; i < userlist.size(); i++) {
			Acluser user = (Acluser) userlist.get(i);%>
		<%if (i % 2 == 0) {%>
		<tr class="even" onmouseover=MouseOverChange(this) onmouseout=MouseOutChange1(this)> <%} else {%>
		<tr class="odd" onmouseover=MouseOverChange(this) onmouseout=MouseOutChange2(this)>
				<%}%>
			<td><%=user.getLoginname()%>
			</td>
			<td><%=user.getTruename()%>
			</td>
			<td><a href="Javascript:deleterelation('<%=user.getUserid()%>')">删除</a></td>
				<%}%>
	</table>
</form>
<table width="400" align="center">
	<tr>
		<td align="right">
			<input type="button" value="关闭" onclick="Javascript:window.close()" class="btn">
		</td>
	</tr>
</table>
<script language="Javascript">
	function deleterelation(userid) {
		document.form1.action = "aclroleAction.do?action=deleteuserrole&userid=" + userid;
		document.form1.method = "post";
		document.form1.submit();
	}
</script>
</body>
</html>
	
<!--索思奇智版权所有-->