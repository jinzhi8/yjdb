<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="com.kizsoft.commons.acl.pojo.Aclapp" %>
<%@page import="com.kizsoft.commons.acl.pojo.Aclprivileresourcetype" %>
<%@page import="com.kizsoft.commons.acl.pojo.Aclrole" %>
<%@page import="java.util.List" %>

<%@taglib prefix="oa" uri="/WEB-INF/oa.tld" %>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<%@taglib prefix="html" uri="/WEB-INF/struts-html.tld" %>
<%
String userTemplateName = (String) session.getAttribute("templatename");
String userTemplateStr = "/resources/template/" + userTemplateName + "/template.jsp";
if(userTemplateName==null||"".equals(userTemplateName)){
	userTemplateStr = "/resources/jsp/template.jsp";
}
%>
<template:insert template="<%=userTemplateStr%>">
<template:put name='title' content='统一用户管理系统' direct='true'/>
<%String str = "<a class=\"menucur\" href=\"\">统一用户管理</a>→角色管理";%>
<template:put name='moduleNav' content='<%=str%>' direct='true'/>
<template:put name='content'>
<link href="<%=request.getContextPath()%>/resources/css/css.css" rel="stylesheet" type="text/css">
<link href="<%=request.getContextPath()%>/resources/theme/script/css.css" rel="stylesheet" type="text/css">
<% int typesize = 0;
	List list = (List) request.getAttribute("list");
	//应用系统列表
	List applist = (List) request.getAttribute("applist");
	//资源类型列表
	List typelist = (List) request.getAttribute("typelist");
	if (typelist != null && typelist.size() > 0) {
		typesize = typelist.size();
	}
	//编辑的角色ID
	String editroleid = (String) request.getAttribute("editroleid");
	//添加一行标志
	String addrow = (String) request.getAttribute("addrow");
	//出错信息
	String message = (String) request.getAttribute("message");%>
<html>
<head>
	<title>统一用户管理</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<script type="text/javascript" src="js/comm.js"></script>
	<link href="css/styles.css" rel="stylesheet" type="text/css"/>
</head>

<body style="background:#FFFFFF;" class="border-index">
<html:form action="/uum/aclroleAction.do" method="post">
	<br/>


	<%if (message != null) {%>
	<table width="90%" border="0" cellpadding="0" cellspacing="1" align="center">
		<tr valign="top" height="10">
			<td class="message">
				<%=message%>
			</td>
		</tr>
	</table>
	<%}%>
	<table cellspacing="1" align="center" width="90%" class="table-view">
		<tr valign="top" height="30">
			<th width="10%" rowspan="2" align="center" class="table-header">角色代码</th>
			<th width="10%" rowspan="2" align="center" class="table-header">角色名称</th>
			<th width="20%" rowspan="2" align="center" class="table-header">描述</th>
			<th width="15%" rowspan="2" align="center" class="table-header">应用系统名称</th>
			<%if (typesize > 0) {%>
			<th width="20%" height="15" colspan="<%=typesize%>" align="center" class="table-header">权限维护</th>
			<%}%>
			<th width="10%" rowspan="2" align="center" class="table-header">对应人员</th>
			<th width="10%" rowspan="2" align="center" class="table-header">操作</th>
		</tr>
		<tr valign="top" height="10">
			<% for (int i = 0; i < typelist.size(); i++) {
				Aclprivileresourcetype sourcetype = (Aclprivileresourcetype) typelist.get(i); %>
			<th align="center" class="table-header"><%=sourcetype.getWorkname()%>
			</th>
			<%}%>
		</tr>
		<%if (list != null) {
			for (int i = 0; i < list.size(); i++) {
				Aclrole role = (Aclrole) list.get(i);
				if (i % 2 == 0) { %>
		<tr class="even" height="20" onmouseover=MouseOverChange(this) onmouseout=MouseOutChange1(this)> <%} else {%>
		<tr class="odd" height="20" onmouseover=MouseOverChange(this) onmouseout=MouseOutChange2(this)>
			<%}%>
			<%if (editroleid != null && editroleid.equals(role.getRoleid())) {%>
			<td height="20">
				<%=role.getRolecode()%>
				<html:hidden property="roleid" value="<%=role.getRoleid()%>"/>
				<html:hidden property="rolecode" value="<%=role.getRolecode()%>"/>
			</td>
			<td>
				<html:text styleClass="inp1" property="rolename" size="15" value="<%=role.getRolename()%>"/>
			</td>
			<td>
				<html:text styleClass="inp1" property="description" size="15" value="<%=role.getRoledesc()%>"/>
			</td>
			<td>
				<html:select property="appid">
					<% for (int j = 0; j < applist.size(); j++) {
						Aclapp app = (Aclapp) applist.get(j);
						if (app.getAppcode().equals(role.getAppid())) { %>
					<option value="<%=app.getAppcode()%>" selected="true"><%=app.getAppname()%>
					</option>
					<%} else {%>
					<option value="<%=app.getAppcode()%>"><%=app.getAppname()%>
					</option>
					<%
							}
						}
					%>
				</html:select>
			</td>
			<% for (int j = 0; j < typelist.size(); j++) {
				Aclprivileresourcetype sourcetype = (Aclprivileresourcetype) typelist.get(j); %>
			<td align="center">
				<a href="Javascript:showCategory('<%=sourcetype.getCategoryid()%>','<%=role.getRoleid()%>')">编辑</a>
			</td>
			<%}%>
			<td align="center">
				<a href="Javascript:showUser('<%=role.getRoleid()%>')">查看</a>
			</td>
			<td>
				<a href="Javascript:saverole()"><font color="#FF0000">保存</font></a>
				<a href="Javascript:init()"><font color="#FF0000">取消</font></a>
			</td>
			<%} else {%>
			<td><%=role.getRolecode()%>
			</td>
			<td><%=role.getRolename()%>
			</td>
			<td><%=role.getRoledesc()%>
			</td>
			<td>
				<% for (int j = 0; j < applist.size(); j++) {
					Aclapp app = (Aclapp) applist.get(j);
					if (app.getAppcode().equals(role.getAppid())) { %>
				<%=app.getAppname()%>
				<%
						}
					}
				%>
			</td>
			<% for (int j = 0; j < typelist.size(); j++) {
				Aclprivileresourcetype sourcetype = (Aclprivileresourcetype) typelist.get(j); %>
			<td align="center">
				<a href="Javascript:showCategory('<%=sourcetype.getCategoryid()%>','<%=role.getRoleid()%>')">编辑</a>
			</td>
			<%}%>
			<td align="center">
				<a href="Javascript:showUser('<%=role.getRoleid()%>')">查看</a>
			</td>

			<td>
				<a href="Javascript:edit('<%=role.getRoleid()%>')">编辑</a>
				<a href="Javascript:delrole('<%=role.getRoleid()%>')">删除</a>
			</td>
			<%}%>
		</tr>
		<%
				}
			}
		%>
		<% if (addrow != null && !addrow.equals("")) {%>
		<tr class="even" onmouseover=MouseOverChange(this) onmouseout=MouseOutChange1(this)>
			<td>
				<html:text styleClass="inp1" property="rolecode" size="10"/>
			</td>
			<td>
				<html:text styleClass="inp1" property="rolename" size="10"/>
			</td>
			<td>
				<html:text styleClass="inp1" property="description" size="15"/>
			</td>
			<td>
				<html:select property="appid">
					<% for (int j = 0; j < applist.size(); j++) {
						Aclapp app = (Aclapp) applist.get(j); %>
					<html:option value="<%=app.getAppcode()%>"><%=app.getAppname()%>
					</html:option>
					<%}%>
				</html:select>
			</td>
			<% for (int j = 0; j < typelist.size(); j++) {
				Aclprivileresourcetype sourcetype = (Aclprivileresourcetype) typelist.get(j); %>
			<td align="center">

			</td>
			<%}%>
			<td></td>
			<td>
				<a href="Javascript:newrole()">保存</a>
				<a href="Javascript:init()"> 取消</a>
			</td>
		</tr>
		<%}%>
	</table>
</html:form>
<table width="90%" align="center">
	<tr>
		<td align="left">
			<input type="button" value="添加角色" onclick="addrow()" class="btn">
		</td>
	</tr>
</table>
<script language="Javascript">
	function delrole(id) {
		if (confirm("你确信要删除该角色?")) {
			document.aclroleForm.action = "aclroleAction.do?action=delete&roleid=" + id;
			document.aclroleForm.method = "post";
			document.aclroleForm.submit();
		} else {
			return;
		}
	}
	function init() {
		document.aclroleForm.action = "aclroleAction.do?action=init";
		document.aclroleForm.method = "post";
		document.aclroleForm.submit();
	}

	function edit(id) {
		document.aclroleForm.action = "aclroleAction.do?action=edit&editroleid=" + id;
		document.aclroleForm.method = "post";
		document.aclroleForm.submit();
	}
	function cancel() {
		document.aclroleForm.action = "aclroleAction.do?action=init";
		document.aclroleForm.method = "post";
		document.aclroleForm.submit();
	}
	function saverole() {
		document.aclroleForm.action = "aclroleAction.do?action=save";
		document.aclroleForm.method = "post";
		document.aclroleForm.submit();
	}
	function addrow() {
		document.aclroleForm.action = "aclroleAction.do?action=addrow";
		document.aclroleForm.method = "post";
		document.aclroleForm.submit();
	}
	function newrole() {
		document.aclroleForm.action = "aclroleAction.do?action=new";
		document.aclroleForm.method = "post";
		document.aclroleForm.submit();
	}
	function showCategory(categoryid, roleid) {
		window.open("aclroleAction.do?action=getcategory&categoryid=" + categoryid + "&roleid=" + roleid, "", "width=480px,height=300px,left=" + (window.screen.width - 300) / 2 + ",top=" + (window.screen.height - 200) / 2 + '"');
	}
	function showUser(roleid) {
		window.open("aclroleAction.do?action=showuser&roleid=" + roleid, "", "width=480px,height=300px,left=" + (window.screen.width - 300) / 2 + ",top=" + (window.screen.height - 200) / 2 + '"');
	}
</script>
</body>
</html>

</template:put>
</template:insert>
<div style="display:none"><!--索思奇智版权所有-->