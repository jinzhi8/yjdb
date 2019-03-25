<%@page language="java" contentType="text/html;charset=UTF-8" %>

<%@page import="java.util.Date" %>
<%//用户登陆验证
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
	}%>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<%@taglib prefix="html" uri="/WEB-INF/oa-html.tld" %>
<%@taglib prefix="oa" uri="/WEB-INF/oa.tld" %>
<script>
	function getDateValue() {
		var doc = document.forms[0];
	<%
	  String DateValue;
	  int YearInt = new Date().getYear()+1900;
	  int MonthInt = new Date().getMonth()+1;
	  if(new Integer(MonthInt).toString().length()==1)
		  DateValue = new Integer(YearInt).toString() + "-0" + new Integer(MonthInt).toString();
	  else
		  DateValue = new Integer(YearInt).toString() + "-" + new Integer(MonthInt).toString();
	  out.println("doc.date_first.value=\'" + DateValue + "-01\';");
	  if(MonthInt==2)
		 out.println("doc.date_last.value=\'"+DateValue+"-28\';");
	  else
		 out.println("doc.date_last.value=\'"+DateValue+"-30\';");
	 %>
	}
</script>
<%if (request.getParameter("statflag") == null) {%>
<BODY onLoad="getDateValue()">
<%}%>
<script language="javascript" src="<%=request.getContextPath()%>/resources/js/calendar.js"></script>


<link href="<%=request.getContextPath()%>/resources/css/css.css" rel="stylesheet" type="text/css">
<%-- <link href="<%=request.getContextPath()%>/resources/theme/script/css.css" rel="stylesheet" type="text/css"> --%>

<%
String userTemplateName = (String) session.getAttribute("templatename");
String userTemplateStr = "/resources/template/" + userTemplateName + "/template.jsp";
if(userTemplateName==null||"".equals(userTemplateName)){
	userTemplateStr = "/resources/jsp/template.jsp";
}
%>
<template:insert template="<%=userTemplateStr%>">
	<template:put name='title' content='登录日志' direct='true'/>
	<%String str = "<a class=\"menucur\" href=\"\">登录日志</a>"; %>
	<template:put name='moduleNav' content='<%=str%>' direct='true'/>
	<template:put name='content'>
		<table border="0" align="center" cellpadding="0" cellspacing="0" class="view_content_table nypublic_table" style="width:100%">
			<tr>
				<td align="center">
					<oa:stat name="systemlog_stat" page="1" styleClass=""/>
				</td>
			</tr>
		</table>

	</template:put>
</template:insert><!--索思奇智版权所有-->