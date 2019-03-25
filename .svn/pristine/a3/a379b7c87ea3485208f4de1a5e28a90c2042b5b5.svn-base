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
	<template:put name='title' content='统一用户管理' direct='true'/>
	<%String str = "<a class=\"menucur\" href=\"\">统一用户管理</a>";%>
	<template:put name='moduleNav' content='<%=str%>' direct='true'/>
	<template:put name='content'>
	<style type="text/css">
		.leftvcd{
			width: 230px;
			/* height: 100%; */
			position: absolute;
			left: 0px;
			top: 0px;
			bottom: 0px;
		}
		.rightnrvcd{
			/* height: 100%; */
			position: absolute;
			left: 230px;
			right: 0px;
			top: 0px;
			bottom: 0px;
		}
		.rightnrvcd_iframe{
			min-height: 99%;
			width: 100%;
			box-sizing: border-box;
		}
	</style>
	<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td class="left_col leftvcd" valign="top">
				<iframe name="toc" src="tree.jsp" frameborder="0" width="100%" scrolling="yes" marginwidth="0" marginheight="0" class="rightnrvcd_iframe"></iframe>
			</td>
			<td valign="top" class="rightnrvcd">
				<iframe name="toc1" src="childowner.jsp" frameborder="0" width="100%" scrolling="yes" class="rightnrvcd_iframe"></iframe>
			</td>
		</tr>
	</table>
	</template:put>
</template:insert>
<div style="display:none"><!--索思奇智版权所有-->