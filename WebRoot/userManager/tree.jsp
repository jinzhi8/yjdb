<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="com.kizsoft.commons.acl.ACLManager" %>
<%@page import="com.kizsoft.commons.acl.ACLManagerFactory" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.uum.utils.UUMConf" %>
<%//用户登陆验证
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
		return;
	}
	User userInfo = (User) session.getAttribute("userInfo");
	String userID = userInfo.getUserId();
	ACLManager aclManager = ACLManagerFactory.getACLManager();%>
<html>
<head>
	<title>用户组织机构</title>
	<script type="text/javascript" src="js/xtree.js"></script>
	<link type="text/css" rel="stylesheet" href="css/xtree.css"/>
	<link type="text/css" rel="stylesheet" href="css/styles.css"/>
	<link href="<%=request.getContextPath()%>/resources/css/application.css" type="text/css" rel="stylesheet"/>
	<link href="<%=request.getContextPath()%>/resources/css/ViewStyle.css" rel="stylesheet" type="text/css">
	<% String treename = (String) UUMConf.get("tree.rootvalue");%>
	<script language="javascript">
		var tmp ;
		function reload() {
			if (tmp == "") {
				atree.reload();
			} else {
				refreshNode(tmp);

			}
		}

		function upnode(id, parentid, divid) {
			if (!parentid) {
				tmp = "";
			} else {
				tmp = divid;
			}
			var xmlHttp1 = XmlHttp.create();
			var aa = "userTree.do?action=upnode&id=" + id + "&parentid=" + parentid ;
			xmlHttp1.open("POST", aa, false);	// async
			xmlHttp1.send(null);
			this.reload();
		}
		function downnode(id, parentid, divid) {
			if (!parentid) {
				tmp = "";
			} else {
				tmp = divid;
			}
			var xmlHttp2 = XmlHttp.create();
			var aa = "tree.do?action=downnode&id=" + id + "&parentid=" + parentid ;
			xmlHttp2.open("POST", aa, false);	// async
			xmlHttp2.send(null);
			this.reload();
		}

		function newsubchild(id, divid) {
			tmp = divid;
			newopen = window.open("subowner.do?action=addnewsub&id=" + id, "", "width=500,height=250");
		}
		/**
		 *edit the nodes
		 * ◎parm the node is
		 */
		function editNode(id, divid, parentvalue) {
			tmp = divid;
			if (!parentvalue) {
				tmp = "";
			}
			newopen = window.open("owner.do?action=edit&id=" + id, "", "width=500,height=250");
		}

		function rmchild() {
			if (confirm("执行此操作！请再仔细核对一下，确实要删除该部门嘛？")) {
				tmp = "";
				document.form1.ids.value = atree.getSelectIds();
				document.form1.submit();
			} else {
				return false;
			}
		}

		function newdept() {
			tmp = "";
			newopen = window.open("tree.do?action=newdept", "", "width=500,height=250");
		}
		function showNode(id) {
			parent.toc1.form2.id.value = id;
			parent.toc1.loadData();
		}
	</script>
</head>
<body style="background:#eeeeee;font-size:9pt">
<form action="tree.do?action=rmnode" name="form1" method="post">
	<input type="hidden" name="ids"/>
</form>
<br>
<table width="200" border="0">
	<tr>
		<td>
			<input type="button" onclick="rmchild()" class="btn" value="删除">
			<%if (aclManager.isOwnerRole(userID, "sysadmin")) {%>
			<input type="button" onclick="newdept()" class="btn" value="添加部门">
			<%}%>
		</td>
	</tr>
	<tr>
		<td>
			<div style="background:#eeeeee;width:100%;height:300px;overflow:auto">
				<script type="text/javascript">
					var atree = new WebFXLoadTree("<%=treename%>", "userTree.do");
					document.write(atree);
				</script>
			</div>
		</td>
	</tr>
	<tr valign="top">
		<td>
			<table width="200" border="0">
				<tr>
					<td colspan="2"><strong>快捷键定义: </strong></td>
				</tr>
				<tr>
					<td width="96" align="right"><strong><u>e</u>(edit)</strong></td>
					<td width="94"><strong>编辑节点</strong></td>
				</tr>
				<tr>
					<td align="right"><strong><u>n</u>(new)</strong></td>
					<td><strong>添加子部门</strong></td>
				</tr>
				<tr>
					<td align="center"><strong><u><</u></strong>：上移</td>
					<td align="center"><strong><strong><u>></u></strong>：下移</strong></td>
				</tr>
			</table>
		</td>
	</tr>
</table>


<br>
<br>

<hr>
</body>
</html>
<!--索思奇智版权所有-->