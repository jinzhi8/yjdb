<%@ page language="java" contentType="text/html;charset=utf-8"%>

<%@page import="com.kizsoft.commons.commons.user.*"%>
<%@page import="com.kizsoft.commons.commons.util.StringHelper"%>
<%@page import="java.util.*"%>
<%@page import="java.text.SimpleDateFormat"%>

<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld"%> 
<%@taglib prefix="html" uri="/WEB-INF/oa-html.tld"%>
<%@taglib prefix="oa" uri="/WEB-INF/oa.tld"%>

<script language="javascript" src="<%=request.getContextPath()%>/resources/js/calendar.js"></script>
<%
String templatename = (String) session.getAttribute("templatename");
String templatestr = "/resources/template/" + templatename + "/template.jsp";
if(templatename==null||"".equals(templatename)){
	templatestr = "/resources/jsp/template.jsp";
}
%>
<template:insert template="<%=templatestr%>">
<template:put name='title' content='收文流转' direct='true'/>
    <%
    String str="<a href=\"\">收文流转</a>";
	%>
<template:put name='moduleNav' content='<%=str%>' direct='true'/>
<template:put name='content'>

<table border="0" align="center" cellpadding="0" cellspacing="0" class="round">
    <tr>
	<td align="center">
	<oa:stat name="getshou_stat" page="1" styleClass="" />
	</td>
	</tr>
</table>

</template:put> 
</template:insert>
