<%@page language="java" contentType="text/html;charset=UTF-8" %>

<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleAction" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleActionManager" %>
<%@page import="java.util.ArrayList" %>
<%@page import="java.util.Date" %>

<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<%@taglib prefix="html" uri="/WEB-INF/oa-html.tld" %>
<%@taglib prefix="oa" uri="/WEB-INF/oa.tld" %>


<script language="javascript" src="<%=request.getContextPath()%>/resources/js/calendar.js"></script>
<script>
	function getDateValue() {
		var doc = document.forms[0];
	<%
		  String DateFirst;
		String DateLast;
		String TimeValue;
		int YearInt = new Date().getYear()+1900;
		int MonthInt = new Date().getMonth()+1;
		int DateInt = new Date().getDate()+1;
		if(new Integer(MonthInt).toString().length()==1){
			  TimeValue = new Integer(YearInt).toString() + "-0" + new Integer(MonthInt).toString();
		}
		else{
			  TimeValue = new Integer(YearInt).toString() + "-" + new Integer(MonthInt).toString();
		}
		if(new Integer(DateInt).toString().length()==1){
			  DateFirst = "-0" + (DateInt-1);
			DateLast = "-0" + DateInt;
		}
		else{
			DateFirst = "-"+ (DateInt-1);
			DateLast = "-"+ DateInt;
		}
		out.println("doc.acttime_first.value=\'" + TimeValue + DateFirst+"\';");
		if(MonthInt==2){
			  out.println("doc.acttime_last.value=\'"+TimeValue + DateLast+"\';");
		}
		else{
			  out.println("doc.acttime_last.value=\'"+TimeValue + DateLast+"\';");
		}
	 %>
	}
</script>
<%if (request.getParameter("statflag") == null) {%>
<BODY onLoad="getDateValue()">
<%}%>
<%
String userTemplateName = (String) session.getAttribute("templatename");
String userTemplateStr = "/resources/template/" + userTemplateName + "/template.jsp";
if(userTemplateName==null||"".equals(userTemplateName)){
	userTemplateStr = "/resources/jsp/template.jsp";
}
%>
<template:insert template="<%=userTemplateStr%>">
	<template:put name='title' content='用户操作日志' direct='true'/>
	<%String str = "<a class=\"menucur\" href=\"\">系统日志</a>"; %>
	<template:put name='moduleNav' content='<%=str%>' direct='true'/>
	<template:put name='content'>
		<% //用户登陆验证
			if (session.getAttribute("userInfo") == null) {
				response.sendRedirect(request.getContextPath() + "/login.jsp");
				//response.sendRedirect(request.getContextPath() + "/login.jsp");
			}
			User userInfo = (User) session.getAttribute("userInfo");
			String userID = userInfo.getUserId();
			//Group groupInfo = userInfo.getGroup();
			//String groupID = groupInfo.getGroupId();
			String idsStr = userID;
			String moduleID = "systemlog";
			ModuleActionManager moduleActionManager = new ModuleActionManager();
			ArrayList actionsList = (ArrayList) moduleActionManager.getUserActionList(moduleID, idsStr);
			boolean allowed = false;
			for (int i = 0; i < actionsList.size(); i++) {
				ModuleAction moduleAction = (ModuleAction) actionsList.get(i);
				if (moduleAction.getActionURL().equals(request.getRequestURI().substring(request.getRequestURI().lastIndexOf("/") + 1))) {
					allowed = true;
				}
			}
			if (!allowed) {
				response.sendRedirect(request.getContextPath() + "/" + moduleID);
				//request.getRequestDispatcher("/"+moduleID).forward(request,response);
			}%>
		<table border="0" align="center" cellpadding="0" cellspacing="0" class="view_content_table nypublic_table">
			<tr>
				<td align="center">
					<oa:stat name="systemlog_activity_stat" page="1" styleClass=""/>
				</td>
			</tr>
		</table>

	</template:put>
</template:insert><!--索思奇智版权所有-->