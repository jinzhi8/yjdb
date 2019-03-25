<%@page language="java" contentType="text/html;charset=UTF-8" %>

<%@page import="com.kizsoft.commons.workflow.Activity" %>
<%@page import="com.kizsoft.commons.workflow.ActivityAppbinding" %>
<%@page import="com.kizsoft.commons.workflow.FlowTransmitInfo" %>
<%@page import="com.kizsoft.commons.workflow.WorkflowFactory" %>
<%@page import="java.util.Collection" %>
<%@page import="java.util.Iterator" %>
<%
	FlowTransmitInfo flowTransmitInfo = (FlowTransmitInfo) request.getAttribute("flowTransmitInfo");
	Activity curActivity = flowTransmitInfo.getCurActivity();

	if (curActivity != null) {
		Collection appbindingList = WorkflowFactory.getActivityManager().getActivityAppbindingList(curActivity.getActivId());
		if (appbindingList != null && appbindingList.size() > 0) {
%>
<SCRIPT LANGUAGE="JavaScript">
	<%
			for (Iterator itr = appbindingList.iterator();itr.hasNext();)
			{
				ActivityAppbinding appbinding = (ActivityAppbinding)itr.next();
	%>
	new itemContent("<%=(appbinding.getItemId()==null?"":appbinding.getItemId())%>", "<%=(appbinding.getItemName()==null?"":appbinding.getItemName())%>", "<%=(appbinding.getStatus()==null?"":appbinding.getStatus())%>", "<%=(appbinding.getNullable()==null?"":appbinding.getNullable())%>", "<%=(appbinding.getDataType()==null?"":appbinding.getDataType())%>", "<%=(appbinding.getDataPattern()==null?"":appbinding.getDataPattern())%>");
	<%
			}
	%>
</SCRIPT>
<%
		}
	}
%>

<SCRIPT LANGUAGE="JavaScript">
	initContext();
</SCRIPT>
<!--索思奇智版权所有-->