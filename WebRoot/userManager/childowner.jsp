<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="com.kizsoft.commons.acl.ACLManager" %>
<%@page import="com.kizsoft.commons.acl.ACLManagerFactory" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>

<%@page import="com.kizsoft.commons.uum.actions.Pagination" %>
<%@page import="com.kizsoft.commons.uum.pojo.Owner" %>
<%@page import="java.util.List" %>
<%//用户登陆验证
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
	}
	User userInfo = (User) session.getAttribute("userInfo");
	String userID = userInfo.getUserId();
	ACLManager aclManager = ACLManagerFactory.getACLManager();

	Owner currentowner = (Owner) request.getAttribute("currentowner");
	Pagination pagination = (Pagination) request.getAttribute("pagination");
	List userlist = null;
	if (pagination != null) {
		userlist = pagination.getList();
	} else userlist = (List) request.getAttribute("userlist");

%>
<html>
<head>
	<title>统一用户管理</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<script type="text/javascript" src="js/xtree.js"></script>
	<script type="text/javascript" src="js/comm.js"></script>
	<link href="css/styles.css" rel="stylesheet" type="text/css"/>
</head>
<script language=Javascript>
	function loadData() {
		document.form2.submit();
	}
</script>
<form name="form2" method="post" action="tree.do?action=getUserChild">
	<input type="hidden" name="id"  <%if (currentowner!=null){  out.print("value="+currentowner.getId());}%>>
</form>

<body style="background:#FFFFFF;">
<form name="form1" method="post" action="user.do">
	<table width="95%" border="0" align="center">
		<tr>
			<td width="15%" height="6"></td>
			<td colspan="2"></td>
		</tr>
		<tr>
			<td width="15%" height="19" align="center">当前部门:</td>
			<td width="23%">
				<% if (currentowner == null) {%>
				未选择部门
				<input type=hidden name="parentid" value="">
				<%} else {%>
				<%=currentowner.getOwnername()%>
				<input type="hidden" name="parentid" value="<%=currentowner.getId()%>">
				<%}%>

			</td>
			<td width="62%" align="right">
				<!--<input type="button" name="Submit2" value="删除部门" class="btn2" onClick="deleteDept()"/>
							   <input type="button" name="Submit22" value="编辑部门"  class="btn2" onClick="editDept()"/>
							   <input type="button" name="Submit222" value="添子部门"  class="btn2" onClick="newSubDept()"/>-->
				<input type="button" value="添加用户" class="btn2" onClick="newUser()"/>
				<%if (aclManager.isOwnerRole(userID, "sysadmin")) {%>
				<input type="button" value="角色维护" class="btn2" onClick="aclrole()"/>
				<%}%>
				<%if (currentowner != null) {%>
				<input type="button" value="职位维护" class="btn2" onClick="role()"/>
				<%}%>
			</td>
		</tr>
		<tr background="images/blank.png">
			<td height="6" colspan="3"></td>
		</tr>
	</table>

	<table width="95%" border="0" class="table-view" cellpadding="0" cellspacing="1" align="center">
		<tr valign="top" height="10">
			<th width="6%" height="30" align="center" class="table-header">
				<input name="chkall" type="checkbox" onClick="CheckAll(this.form)">
			</th>
			<th width="16%" height="30" align="center" class="table-header">登陆名</th>
			<th width="13%" height="30" align="center" class="table-header">真实姓名</th>
			<th width="25%" height="30" align="center" class="table-header">邮箱</th>
			<th width="14%" height="30" align="center" class="table-header">类别</th>
			<th width="18%" height="30" align="center" class="table-header">操作</th>

			<th width="8%" height="30" lign="center" class="table-header">&nbsp; </th>
		</tr>
		<%if (userlist != null) {
			for (int i = 0; i < userlist.size(); i++) {
				Owner owner = (Owner) userlist.get(i);
				if (i % 2 == 0) { %>
		<tr class="even" onmouseover=MouseOverChange(this) onmouseout=MouseOutChange1(this)> <%} else {%>
		<tr class="odd" onmouseover=MouseOverChange(this) onmouseout=MouseOutChange2(this)>
			<%}%>
			<td height="27">
				<div align="center"><span class="table-header">
          <input type="checkbox" name="chkid" value="<%=owner.getId()%>"/>
      </span></div>
			</td>
			<td height="27"><a href="javascript:editUser('<%=owner.getId()%>')"><%=owner.getOwnercode()%>
			</a></td>
			<td><%=owner.getOwnername()%>
			</td>
			<td><%=owner.getEmail()%>
			</td>
			<td><%=owner.getUUMType()%>
			</td>
			<td>
				<%if (owner.getStatus().toString().equals("1")) {%>
				<a href="Javascript:disableUser('<%=owner.getId()%>')">停用帐号</a>
				<%} else {%>
				<a href="Javascript:ableUser('<%=owner.getId()%>')">启动帐号</a>
				<%}%>
			</td>
			<td>
				<div align="center">
					<img src="images/up.gif" width="16" height="16" onclick="upnode('<%=owner.getId()%>')"/>
					<img src="images/down.gif" width="16" height="16" onclick="downnode('<%=owner.getId()%>')"/>
				</div>
			</td>
		</tr>
		<%
				}
			}
		%>
	</table>
</form>
<table align="center" width="95%">
	<tr>
		<td height="25" align="left">
			<input name="Submit" type="button" class="btn" value="彻底删除" onClick="deleteUser()"/>
			<!--
					  <input name="Submit3" type="button" class="btn" value="重置密码" onClick="initPassword()" />
					  -->
			<input name="Submit42" type="button" class="btn" value="人事调出" onClick="swap()"/>
			<input name="Submit43" type="button" class="btn" value="人事调入" onClick="invoke()"/>
			<%if (currentowner != null) {%>
			<a href="category.jsp?pid=<%=currentowner.getId()%>">用户排序</a>
			<%} else {%>
			<a href="category.jsp">用户排序</a>
			<%}%>
			<!-- <input name="Submit4" type="button" class="btn" value="设为无效" onClick="disUser()" />--></td>
		<td align="right">
			<%
				if (currentowner != null && pagination != null) {
					pagination.setTarget("user.do");
					pagination.setAction("page");
					pagination.setTempParam("parentid", currentowner.getId());
					out.print(pagination.writePaginationFlag());
				}
			%></td>
	</tr>
</table>
<script language="javascript">

	function aclrole() {

		document.form1.method = "post";
		document.form1.target = "_parent";
		document.form1.action = "aclroleAction.do?action=init";
		document.form1.submit();

	}
	function role() {
	<%if (currentowner!=null){%>
		document.form1.method = "post";
		document.form1.target = "_parent";
		document.form1.action = "post.do?action=init&deptid=<%=currentowner.getId()%>";
		document.form1.submit();
	<%}%>
	}	//排序
	function upnode(id) {
		document.form1.action = "user.do?action=upnode&id=" + id;
		document.form1.submit();
	}
	function wen() {
		if (newopen.closed) {
			clearTimeout(to);
			loadData();
		} else
			to = setTimeout('wen()', 100);
	}
	function downnode(id) {
		document.form1.action = "user.do?action=downnode&id=" + id;
		document.form1.submit();
	}	//编辑用户信息
	function editUser(id) {
	<%if (currentowner!=null){%>
		newopen = window.open("user.do?action=edit&oid=" + id + "&parentid=<%=currentowner.getId()%>", "", "width=480px,height=300px");
		wen();
	<%}%>
	}	//添加用户
	function newUser() {
	<%if (currentowner!=null){%>
		newopen = window.open("user.do?action=addnew&oid=<%=currentowner.getId()%>", "", "width=480px,height=300px;");
		wen();
	<%}%>
	}	//删除部门或分部门
	function deleteDept() {
		if (confirm("您确信要删除部门'信息中心'?")) {
			document.form1.submit();
		} else {
			return null;
		}
	}	//编辑部门
	function editDept() {
		window.showModalDialog("deptNew.jsp", "", "dialogWidth:450px; dialogHeight:280px; dialogLeft:200px; dialogTop:200px; status:no; directories:yes;scrollbars:no;Resizable=no; ");
	}	//新建子部门
	function newSubDept() {
		var AtWnd = window.open("subowner.do?action=addnewsub&id=" + id, "", "width=500,height=250;");
		if (!AtWnd.opener)
			AtWnd.opener = window;  //attached window
		AtWnd.focus();  //show the window

	}	//彻底删除用户,允许多个
	function deleteUser() {
		if (confirm("您确信要删除你所选的用户?")) {
			document.form1.action = "user.do?action=deleteUser";
			document.form1.submit();
		} else {
			return null;
		}
	}	//初始化用户密码
	function initPassword() {
		if (confirm("您确信要初始化你所选的用户的密码?")) {
			document.form1.action = "user.do?action=initpassword";
			document.form1.submit();
		} else {
			return null;
		}
	}	//人事调出
	function swap() {
		if (confirm("您确信要将你所选的用户调出?")) {
			document.form1.action = "user.do?action=swap";
			document.form1.submit();
		} else {
			return null;
		}
	}	//人事调入
	function invoke() {
		if (document.form1.parentid.value == "") {
			alert("请选择一个部门");
			return null;
		}

		newopen = window.open("user.do?action=import&usertype=0&parentid=" + document.form1.parentid.value, "", "width=580px,height=400px,scrollbars=yes,resizable=yes");
		wen();
	}	//将用户设为无效
	function disableUser(id) {
		if (confirm("您确信要将你所选的用户设为无效,该用户将不能登陆?")) {
			document.form1.action = "user.do?action=disableaccount&id=" + id;
			document.form1.submit();
		} else {
			return null;
		}
	}	//用户帐号重新启用
	function ableUser(id) {
		if (confirm("你要启用该帐号?")) {
			document.form1.action = "user.do?action=ableaccount&id=" + id;
			document.form1.submit();
		} else {
			return null;
		}
	}
</script>
</body>
</html>
<!--索思奇智版权所有-->