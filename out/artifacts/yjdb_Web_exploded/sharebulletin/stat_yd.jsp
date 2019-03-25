<%@ page language="java" contentType="text/html;charset=utf-8"%>

<%@page import="com.kizsoft.commons.commons.user.*"%>
<%@page import="com.kizsoft.commons.commons.util.StringHelper"%>
<%@page import="java.util.*"%>
<%@page import="java.text.SimpleDateFormat"%>

<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld"%> 
<%@taglib prefix="html" uri="/WEB-INF/oa-html.tld"%>
<%@taglib prefix="oa" uri="/WEB-INF/oa.tld"%>
<%
	//用户登陆验证
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
		return;
	}
	
	String status = request.getParameter("status");
	
	
	String templatename = (String) session.getAttribute("templatename");
	String templatestr = "/resources/template/" + templatename + "/template.jsp";
	if(templatename==null||"".equals(templatename)){
		templatestr = "/resources/jsp/template.jsp";
	}
%>
<template:insert template="<%=templatestr%>">
<template:put name='title' content='公告信息' direct='true'/>
<% String str="<a href=\"\">公告信息</a>";%>
<template:put name='moduleNav' content='<%=str%>' direct='true'/>
<template:put name='content'>
<style>
.nav-wrap{
	padding-top: 10px;
}
.nav-wrap a{
	padding: 12px 0px;
	min-width: 110px;
    font-size: 15px;
    border-radius: 3px;
    display: inline-block;
    margin-right: 5px;
    text-align: center;
    color: #fff;
    
}
.nav-wrap a.wd{
	background-color: #1b93ec;
}
.nav-wrap a.yd{
	background-color: #1564F3;
}

</style>
<table border="0" align="center" cellpadding="0" cellspacing="0" class="view_content_table nypublic_table">
    <tr>
		<td class="nav-wrap" align="left">
			<a hidefocus="" href="stat.jsp" class="tab_a wd">未读信息</a><a hidefocus=""  href="stat_yd.jsp" class="tab_a yd">已读信息</a>
		</td>
	</tr>
    <tr>
		<td align="center">
			<oa:stat name="sharebulletin_yd_stat" page="1" styleClass="" />
		</td>
	</tr>
</table>
</template:put> 
</template:insert>
