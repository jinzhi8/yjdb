<%@page language="java" contentType="text/html;charset=UTF-8" %>

<%@taglib prefix="oa" uri="/WEB-INF/oa.tld" %>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<%@taglib prefix="html" uri="/WEB-INF/struts-html.tld" %>
<% //用户登陆验证
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
		//request.getRequestDispatcher("/login.jsp").forward(request,response);
		return;
	}
	String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();%>
<%
String userTemplateName = (String) session.getAttribute("templatename");
String userTemplateStr = "/resources/template/" + userTemplateName + "/template.jsp";
if(userTemplateName==null||"".equals(userTemplateName)){
	userTemplateStr = "/resources/jsp/template.jsp";
}
%>
<template:insert template="<%=userTemplateStr%>">
	<template:put name='title' content='用户管理' direct='true'/>
	<%String str = "<a class=\"menucur\" href=\"\">用户管理</a>";%>
	<template:put name='moduleNav' content='<%=str%>' direct='true'/>
	<template:put name='content'>
		<link href="<%=request.getContextPath()%>/resources/css/css.css" rel="stylesheet" type="text/css">
		<link href="<%=request.getContextPath()%>/resources/theme/script/css.css" rel="stylesheet" type="text/css">

		<script type="text/javascript" src="js/xtree.js"></script>
		<link href="css/xtree.css" type="text/css" rel="stylesheet"/>
		<link href="css/styles.css" rel="stylesheet" type="text/css"/>
		<link href="<%=contextPath%>/resources/css/css.css" rel="stylesheet" type="text/css"/>
		<TABLE cellSpacing=0 cellPadding=0 width="100%" height="100%" align="center" bgcolor="#FFFFFF" class="border-index">
			<tr valign="top" height="450">
				<td height="450">
					<table width="100%" height="450" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td width="205px">
								<iframe name="toc" src="tree.jsp" frameborder="0" width="100%" height="450" scrolling="no" marginwidth="0" marginheight="0"></iframe>
							</td>
							<td>
								<iframe name="toc1" src="childowner.jsp" frameborder="0" width="100%" height="450" scrolling="yes"></iframe>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>

	</template:put>
</template:insert><!--索思奇智版权所有-->