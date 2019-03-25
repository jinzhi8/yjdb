<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="com.kizsoft.commons.uum.pojo.Owner" %>
<%@page import="com.kizsoft.commons.uum.pojo.Role" %>
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
	<%String str = "<a class=\"menucur\" href=\"\">统一用户管理</a>";%>
	<template:put name='moduleNav' content='<%=str%>' direct='true'/>
	<template:put name='content'>
		<%try {%>
		<title></title>
		<!-- 面板css -->
		<link id="luna-tab-style-sheet" type="text/css" rel="stylesheet" href="css/tab.css"/>
		<!--面板js -->
		<script type="text/javascript" src="js/tabpane.js"></script>
		<script type="text/javascript" src="js/comm.js"></script>
		<link href="css/styles.css" rel="stylesheet" type="text/css"/>
		<body style="background:#FFFFFF;">
		<% List list = (List) request.getAttribute("list");
			Owner owner = (Owner) request.getAttribute("owner");

		%>
		<html:form action="/uum/post.do" method="post">
			<br/>
			<table width="770" align="center">
				<tr>
					<td width="100%" align="left">
						<table align="center">
							<tr>
								<td width="77" height="25" align=center>
									上级部门：
								</td>
								<td width="128">
									<%=owner.getOwnername()%>
									<html:hidden styleClass="inp1" property="parentid" value="<%=owner.getId()%>"/>
								</td>
								<td align="center" width="87"><font color=red>*</font>职位名称</td>
								<td width="129"><html:text styleClass="inp1" property="rolename" size="20"/></td>
								<td height="25" align="center">描&nbsp;&nbsp;&nbsp;述</td>
								<td width="129" align="left">
									<html:text property="description" styleClass="inp1" size="30"/></td>
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
					<th class="table-header" width="25%">职位名称</th>
					<th class="table-header" width="20%">对应人员</th>
					<th class="table-header" width="35%">描述</th>
					<th class="table-header" width="10%">职位操作</th>
					<th class="table-header" width="10%">关系操作</th>
				</tr>
				<%if (list != null) {%>
				<%
					for (int i = 0; i < list.size(); i++) {
						Role role = (Role) list.get(i);
						if (i % 2 == 0) {
				%>
				<tr class="even" onmouseover=MouseOverChange(this) onmouseout=MouseOutChange1(this)> <%} else {%>
				<tr class="odd" onmouseover=MouseOverChange(this) onmouseout=MouseOutChange2(this)>
					<%}%>
					<td><%=role.getRolename()%>
					</td>
					<td><%=role.getOwnername()%>
					</td>
					<td><%=role.getDescription()%>
					</td>
					<td>
						<a href="post.do?action=edit&id=<%=role.getId()%>&parentid=<%=owner.getId()%>">编辑</a>
						<a href="#" onclick="cdelete('<%=role.getId()%>')">删除</a>
					</td>
					<td>
						<%if (role.getOwnername() == null || role.getOwnername().equals("")) {%>
						&nbsp;
						<%} else {%>
						<a href="#" onclick="resetRole('<%=role.getId()%>','<%=role.getRolename()%>','<%=role.getOwnername()%>')">
							撤销职位
						</a>
						<%}%>
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
			function setRole(id) {
				window.open("tree.do?action=getUserChild2&id=" + id, "", "width=500,height=250;");
			}

			function send() {
				var target = "addnew" ;
				if (checkNull(document.postForm.rolename)) {
					if (document.postForm.ID.value == "") {
						target = "addnew";
					} else {
						target = "modify";
					}
					document.postForm.action = "post.do?action=" + target;
					document.postForm.submit();
					this.clrpage();
				}
			}
			function resetRole(id, rolename, username) {
				if (confirm("你确定要撤销'" + username + "'的'" + rolename + "'职位?")) {
					document.postForm.ID.value = id;
					document.postForm.action = "post.do?action=resetrole";
					document.postForm.submit();
				}
			}
			function cdelete(id) {
				document.postForm.ID.value = id;
				document.postForm.action = "post.do?action=delete&id=" + id;
				document.postForm.submit();
				this.clrpage();
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