<%@page language="java" contentType="text/html;charset=UTF-8" %>

<%@page import="java.util.Date" %>

<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<%@taglib prefix="html" uri="/WEB-INF/oa-html.tld" %>
<%@taglib prefix="oa" uri="/WEB-INF/oa.tld" %>

<script language="javascript" src="<%=request.getContextPath()%>/resources/js/calendar.js"></script>
<template:insert template="/resources/jsp/template.jsp">
	<template:put name='title' content='县领导会议督办' direct='true'/>
	<%String str = "<a class=\"menucur\" href=\"\">县领导会议督办</a>"; %>
	<template:put name='moduleNav' content='<%=str%>' direct='true'/>
	<template:put name='content'>

		<table border="0" align="center" cellpadding="0" cellspacing="0" class="round">
			<tr>
				<td align="center">
					<oa:stat name="zwdbhyfk_stat" page="1" styleClass=""/>
				</td>
			</tr>
		</table>

	</template:put>
</template:insert><!--温州奇智版权所有-->