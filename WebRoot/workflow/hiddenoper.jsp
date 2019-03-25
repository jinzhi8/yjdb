<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.workflow.FlowTransmitInfo" %>
<% FlowTransmitInfo flowTransmitInfo = (FlowTransmitInfo) request.getAttribute("flowTransmitInfo");
	String flowID = flowTransmitInfo.getFlowID();
	String taskID = flowTransmitInfo.getTaskID();
	String instanceID = flowTransmitInfo.getInstanceID();
	String moduleID = flowTransmitInfo.getModuleID();%>
<table border="0" style="border: 1px solid black; display: none" width="100%">
	<tr>
		<td><input name="flowID" value="<%=(flowID == null ? "" : flowID)%>" style="display:none;" readonly>
			<input name="taskID" value="<%=(taskID == null ? "" : taskID)%>" style="display:none;" readonly>
			<input name="instanceID" value="<%=(instanceID == null ? "" : instanceID)%>" style="display:none;" readonly>
			<input name="moduleID" value="<%=(moduleID == null ? "" : moduleID)%>" style="display:none;" readonly>
			<input name="submitMethod" value="0" style="display:none;" readonly>
		</td>
	</tr>
</table>
<script language="javaScript">
	function greturn() {
	}

	function setSubmitMethod(submitmethod) {
		document.all.submitMethod.value = submitmethod;
	}
</script>
<!--索思奇智版权所有-->