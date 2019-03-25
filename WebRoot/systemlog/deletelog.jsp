<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.login.UserFlagManage" %>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<%@taglib prefix="html" uri="/WEB-INF/oa-html.tld" %>
<%@taglib prefix="oa" uri="/WEB-INF/oa.tld" %>


<%
String userTemplateName = (String) session.getAttribute("templatename");
String userTemplateStr = "/resources/template/" + userTemplateName + "/template.jsp";
if(userTemplateName==null||"".equals(userTemplateName)){
	userTemplateStr = "/resources/jsp/template.jsp";
}
%>
<template:insert template="<%=userTemplateStr%>">
	<template:put name='title' content='系统日志' direct='true'/>
	<%String str = "<a class=\"menucur\" href=\"index.jsp\">系统日志</a>";%>
	<template:put name='moduleNav' content='<%=str%>' direct='true'/>
	<template:put name='content'>
		<%//用户登陆验证
			if (session.getAttribute("userInfo") == null) {
				response.sendRedirect(request.getContextPath() + "/login.jsp");
			}
			User userInfo = (User) session.getAttribute("userInfo");
			String userAcc = userInfo.getAccount();
			String delflag = null;
			String userFlag = (String) session.getAttribute("userFlag");
			if (userAcc.equals("admin")) delflag = "1";
			else delflag = "0";
			UserFlagManage userflagManage = new UserFlagManage();
			boolean flag = userflagManage.deleteUserLogin(userFlag, delflag);%>
		<script>
			alert("成功清除用户登录日志!");
			window.location.href = "<%=request.getContextPath()%>/systemlog/index.jsp";
		</script>
	</template:put>
</template:insert><!--索思奇智版权所有-->