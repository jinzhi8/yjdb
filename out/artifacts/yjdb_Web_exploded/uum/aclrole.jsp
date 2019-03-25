<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
	<template:put name='title' content='统一用户管理' direct='true'/>
	<%String str = "<a class=\"menucur\" href=\"\">统一用户管理</a>";%>
	<template:put name='moduleNav' content='<%=str%>' direct='true'/>
	<template:put name='content'>

		<% List list = (List) request.getAttribute("list");
			String mode = (String) request.getAttribute("mode");%>

		<%try {%>
		<title></title>
		<!-- 面板css -->
		<link id="luna-tab-style-sheet" type="text/css" rel="stylesheet" href="css/tab.css"/>
		<!--面板js -->
		<script type="text/javascript" src="js/tabpane.js"></script>
		<script type="text/javascript" src="js/comm.js"></script>
		<link href="css/styles.css" rel="stylesheet" type="text/css"/>
		<body style="background:#FFFFFF;">

		<html:form action="/uum/aclroleAction.do" method="post">
			<br/>
			<table width="770" align="center">
				<tr>
					<td width="100%" align="left">
						<table align="center">
							<tr>
								<td width="77" height="25" align=center><font color=red>*</font>角色代码</td>
								<td width="128">
									<%if (mode != null && mode.equals("edit")) {%>
									<html:text styleClass="inp1" property="rolecode" readonly="true" size="20"/>
									<%} else {%>
									<html:text styleClass="inp1" property="rolecode" size="20"/>
									<%}%>
								</td>
								<td align="center" width="87"><font color=red>*</font>角色名称</td>
								<td width="129"><html:text styleClass="inp1" property="rolename" size="20"/></td>
								<td height="25" align="center">描&nbsp;&nbsp;&nbsp;述</td>
								<td align="left"><html:text property="description" styleClass="inp1" size="30"/></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			<table width="770" cellspacing="1">
				<tr>
					<td align="right">
						<html:button styleClass="btn" value="保存" property="" onclick="send()"/>
						<html:button styleClass="btn" value="重置" property="" onclick="clrpage()"/>
					</td>
				</tr>
			</table>

			<table cellspacing="1" align="center" width="770" class="table-view">
				<tr class="table-header">
					<th class="table-header" width="25%">角色代码</th>
					<th class="table-header" width="25%">角色名称</th>
					<th class="table-header" width="40%">描&nbsp;&nbsp;&nbsp;述</th>
					<th class="table-header" width="10%"></th>
				</tr>
				<%if (list != null) {%>
				<%
					for (int i = 0; i < list.size(); i++) {
						Aclrole role = (Aclrole) list.get(i);
						if (i % 2 == 0) {
				%>
				<tr class="even" onmouseover=MouseOverChange(this) onmouseout=MouseOutChange1(this)> <%} else {%>
				<tr class="odd" onmouseover=MouseOverChange(this) onmouseout=MouseOutChange2(this)>
					<%}%>
					<td><%=role.getRolecode()%>
					</td>
					<td><%=role.getRolename()%>
					</td>
					<td><%=role.getRoledesc()%>
					</td>
					<td>
						<a href="aclroleAction.do?action=edit&id=<%=role.getRoleid()%>">编辑</a>
						<a href="#" onclick="cdelete('<%=role.getRoleid()%>')">删除</a>
					</td>
				</tr>
				<%
						}
					}
				%>
				<html:hidden property="ID"/>
			</table>

		</html:form>
		<script language="javascript">
			function send() {
				var target = "addnew" ;
				if (checkNull(document.postForm.rolecode) && checkNull(document.postForm.rolename)) {
					if (document.postForm.ID.value == "") {
						target = "addnew";
					} else {
						target = "modify";
					}
					document.postForm.action = "aclroleAction.do?action=" + target;
					document.postForm.submit();
				}
			}
			function cdelete(id) {
				document.postForm.ID.value = id;
				document.postForm.action = "aclroleAction.do?action=delete&id=" + id;
				document.postForm.submit();
			}
			function checkNull(obj) {
				if (obj.value == "") {
					alert("请将*号的都输入信息.");
					return false;
				}
				return true;
			}
			function clrpage() {
				document.postForm.ID.value = "";
				document.postForm.rolecode.value = "";
				document.postForm.rolename.value = "";
				document.postForm.description.value = "";

			}
		</script>
		<br/>
		<br/>
		<%
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		%>
	</template:put>
</template:insert><!--索思奇智版权所有-->