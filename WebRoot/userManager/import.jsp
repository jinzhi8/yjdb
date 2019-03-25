<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="com.kizsoft.commons.acl.ACLManager" %>
<%@page import="com.kizsoft.commons.acl.ACLManagerFactory" %>
<%@page import="com.kizsoft.commons.commons.db.ConnectionProvider" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.uum.actions.Pagination" %>
<%@page import="com.kizsoft.commons.uum.pojo.Owner" %>
<%@page import="java.sql.Connection" %>
<%@page import="java.sql.PreparedStatement" %>
<%@page import="java.sql.ResultSet" %>
<%@page import="java.util.List" %>
<% if (session.getAttribute("userInfo") == null) {
	response.sendRedirect(request.getContextPath() + "/login.jsp");
} else {

	Pagination pagination = (Pagination) request.getAttribute("pagination");
	Owner currentowner = (Owner) request.getAttribute("currentowner");
	List userlist = pagination.getList();
	String ut = (String) request.getAttribute("ut");
	//**************************************** alter on 2006-06-16
	String getSelFlag = request.getParameter("selflag");
	String getLoginName = request.getParameter("loginname");
	if (getLoginName == null) getLoginName = "";
	String getUserName = request.getParameter("username");
	if (getUserName == null) getUserName = "";
	/*
		 if (getUserName!=null) {
			 getUserName = new String(getUserName.getBytes("iso-8859-1"),"gbk");
		 }else {getUserName = "";}
		 */
	String getParentID = request.getParameter("parentid");
	StringBuffer resultBuff = new StringBuffer();
	if (getSelFlag != null && getSelFlag.equals("1")) {
		Connection db = null;
		PreparedStatement stat = null;
		ResultSet rs = null;
		int num = 0;
		String sql = "select id,ownercode,ownername,email,phone,type  from owner";
		if ((getLoginName != null && !"".equals(getLoginName)) && (getUserName == null || "".equals(getUserName))) {
			sql = sql + " where ownercode='" + getLoginName + "'";
		} else if ((getLoginName == null || "".equals(getLoginName)) && (getUserName != null && !"".equals(getUserName))) {
			sql = sql + " where ownername like '%" + getUserName + "%'";
		} else {
			sql = sql + " where ownercode='" + getLoginName + "' and ownername like '%" + getUserName + "%'";
		}
		try {
			db = ConnectionProvider.getConnection();
			stat = db.prepareStatement(sql);
			rs = stat.executeQuery();
			while (rs.next()) {
				num++;
				if (num % 2 == 0) {
					resultBuff = resultBuff.append("<tr class=\"even\" onmouseover=MouseOverChange(this) onmouseout=MouseOutChange1(this)>");
				} else {
					resultBuff = resultBuff.append("<tr class=\"odd\"  onmouseover=MouseOverChange(this) onmouseout=MouseOutChange2(this)>");
				}
				resultBuff = resultBuff.append("<td height=\"27\"  ><div align=\"center\"><span class=\"table-header\">");
				resultBuff = resultBuff.append("<input type=\"checkbox\" name=\"chkid\" value=\"" + rs.getString("id") + "\"></span></div></td>");
				resultBuff = resultBuff.append("<td height=\"27\"><a href=\"javascript:editUser('" + rs.getString("ownercode") + "')\">" + rs.getString("ownercode") + "</a></td>");
				resultBuff = resultBuff.append("<td>" + rs.getString("ownername") + "</td>");
				String getEmail = rs.getString("email");
				if (getEmail == null) getEmail = "";
				resultBuff = resultBuff.append("<td>" + getEmail + "</td>");
				String getPhone = rs.getString("phone");
				if (getPhone == null) getPhone = "";
				resultBuff = resultBuff.append("<td>" + getPhone + "</td>");
				String getUserType = rs.getString("type");
				if (getUserType == null) {
					getUserType = "";
				} else if (getUserType.equals("1")) {
					getUserType = "系统管理员";
				} else if (getUserType.equals("2")) {
					getUserType = "部门管理员";
				} else {
					getUserType = "普通用户";
				}
				resultBuff = resultBuff.append("<td>" + getUserType + "</td>");
				resultBuff = resultBuff.append("<td></td></tr>");
			}
		} catch (Exception e) {
		} finally {
			ConnectionProvider.close(db, stat, rs);
		}
	}
	//*************************************** alter end

%>
<html>
<head>
	<title>人事调入</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<script type="text/javascript" src="js/xtree.js"></script>
	<script type="text/javascript" src="js/comm.js"></script>
	<link href="css/styles.css" rel="stylesheet" type="text/css"/>
	<link type="text/css" rel="stylesheet" href="css/styles-main.css"/>
</head>
<script language=Javascript>
	function loadData() {
		document.form2.submit();
	}
</script>

<body style="background:#FFFFFF;">
<form name="form1" method="post" action="user.do">
	<table width="95%" border="0" align="center">
		<tr>
			<td width="15%" height="6"></td>
			<td colspan="2"></td>
		</tr>
		<tr>
			<td width="15%" height="19" align="center">用户类别:</td>
			<td width="15%">
				<select name="selusertype" onchange="refresh()">
					<option value="0" <% if (ut.equals("0")) out.print("selected");%>>无部门</option>
					<option value="1" <% if (ut.equals("1")) out.print("selected");%>> 本部门</option>
				</select>
			</td>
			<% User userInfo = (User) session.getAttribute("userInfo");
				String userID = userInfo.getUserId();
				ACLManager aclManager = ACLManagerFactory.getACLManager();
				if (aclManager.isOwnerRole(userID, "sysadmin")) { %>
			<td width="62%" bgcolor="#00ccff">
				<!--alter on                    2006-06-16                         -->
				登入名：<input type="text" name="loginname" style="width:20%" value="<%=getLoginName%>">&nbsp;&nbsp;
				姓名：<input type="text" name="username" style="width:20%" value="<%=getUserName%>">
				<input type="button" name="seluser" value="查询" style="width:30" onclick="doselect();" class="btn">
				<input type=hidden name="selflag" value="0">
			</td>
			<!--alter end                                                             -->
			<% } else { %>
			<td width="62%">&nbsp;
			</td>
			<%}%>
		</tr>
		<tr background="images/blank.png">
			<td height="6" colspan="3"></td>
		</tr>
	</table>
	<input type=hidden name="parentid" value="<%=currentowner.getId()%>">
	<table width="95%" border="0" class="table-view" cellpadding="0" cellspacing="1" align="center">
		<tr valign="top" height="10">
			<th width="6%" height="30" align="center" class="table-header">
				<input name="chkall" type="checkbox" onClick="CheckAll(this.form)">
			</th>
			<th width="16%" height="30" align="center" class="table-header">登陆名</th>
			<th width="13%" height="30" align="center" class="table-header">真实姓名</th>
			<th width="25%" height="30" align="center" class="table-header">邮箱</th>
			<th width="18%" height="30" align="center" class="table-header">电话</th>
			<th width="14%" height="30" align="center" class="table-header">类别</th>
		</tr>
		<%

			if (getSelFlag == null || getSelFlag.equals("0")) {
				if (userlist != null) {
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
			<td><%=owner.getPhone()%>
			</td>
			<td><%=owner.getUUMType()%>
			</td>
			<td></td>
		</tr>
		<% }
		}
			if (ut != null && pagination != null) {
				pagination.setTempParam("usertype", ut);
				pagination.setTempParam("parentid", currentowner.getId());
				out.println(pagination.writePaginationFlag());
			}
		} else if (getSelFlag != null && getSelFlag.equals("1")) {
			out.println(resultBuff.toString());
		} %>

	</table>
</form>
<center><input name="Submit" type="button" class="btn" value="保  存" onClick="saveimport()"/>

	<script language="javascript">
		//确认调入
		function saveimport() {
			document.form1.action = "user.do?action=saveimport";
			document.form1.submit();
		}
		function refresh() {
			var usertype = document.form1.selusertype.value;
			document.form1.action = "user.do?action=import&usertype=" + usertype;
			document.form1.submit();
		}


		//alter on 2006-06-16 用户查询功能
		function doselect() {
			var loginname = document.form1.loginname.value;
			var username = document.form1.username.value;
			if ((loginname == null || loginname == "") && (username == null || username == "")) {
				alert("请输入查询条件！");
				return false;
			}
			document.form1.selflag.value = "1";
			var url = "user.do?action=import&usertype=0&parentid=" + document.form1.parentid.value + "&loginname=" + loginname + "&username=" + encodeURIComponent(username) + "&selflag=" + document.form1.selflag.value;
			window.location = url;
		}		//alter end
	</script>
</body>
</html>
<%}%><!--索思奇智版权所有-->