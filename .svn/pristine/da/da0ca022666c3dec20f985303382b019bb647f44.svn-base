<%@page language="java" contentType="text/html;charset=UTF-8" %>

<%@page import="com.kizsoft.commons.Constant" %>
<%@page import="com.kizsoft.commons.commons.attachment.AttachmentEntity" %>
<%@page import="com.kizsoft.commons.commons.attachment.AttachmentManager" %>
<%@page import="com.kizsoft.commons.commons.struts.text.RTFFormat" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.commons.user.UserManagerFactory" %>
<%@page import="com.kizsoft.commons.commons.util.StringHelper" %>
<%@page import="com.kizsoft.commons.workflow.*" %>

<%@page import="com.sun.org.apache.xpath.internal.XPathAPI" %>
<%@page import="org.w3c.dom.Document" %>
<%@page import="org.w3c.dom.Element" %>
<%@page import="org.w3c.dom.NodeList" %>
<%@page import="org.xml.sax.InputSource" %>
<%@page import="javax.xml.parsers.DocumentBuilder" %>
<%@page import="javax.xml.parsers.DocumentBuilderFactory" %>
<%@page import="java.io.StringReader" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.*" %>
<%

	String contextPath = request.getContextPath();

	FlowTransmitInfo flowTransmitInfo = (FlowTransmitInfo) request.getAttribute("flowTransmitInfo");
	Instance curInstance = null;

	if (flowTransmitInfo.getCurInstance() != null) curInstance = flowTransmitInfo.getCurInstance();

	if (curInstance != null) {
		String instanceId = curInstance.getInstanceId();

		pageContext.setAttribute("attTabName", Constant.FLOW_ATTACHMENT_TABLENAME);

		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm");

		Collection requestList = WorkflowFactory.getRequestManager().getRequestListByInstanceWithSubflow(curInstance);

		if (requestList.size() > 0) {
			out.println("<table border=\"1\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" class=\"table\">" + "<tr><td class=\"deeptd\" width=\"18%\">时间</td>" + "<td class=\"deeptd\" width=\"12%\">处理人员</td>" + "<td class=\"deeptd\" width=\"14%\">流程操作</td>" + "<td class=\"deeptd\" width=\"38%\">处理意见</td>" + "<td class=\"deeptd\" width=\"18%\">附件</td></tr>");

			Properties handleProp = new Properties();

			String[] requestIds = WorkflowFactory.getRequestManager().getRequestIdsByInstanceId(instanceId);

			ArrayList handleList = new AttachmentManager().getAttachmentsByIDs(Constant.MODULE_NAME_WORKFLOWHANDWRITE, requestIds, null);

			for (Iterator handleItr = handleList.iterator(); handleItr.hasNext();) {
				AttachmentEntity handleEntity = (AttachmentEntity) handleItr.next();
				String docunid = handleEntity.getDocunid();
				String handlePath = handleEntity.getAttachmentPath() + "/" + handleEntity.getAttachmentName();

				handleProp.setProperty(docunid, handlePath);
			}

			for (Iterator itr = requestList.iterator(); itr.hasNext();) {
				Request oldRequest = (Request) itr.next();
				String oldReqId = oldRequest.getReqId();
				pageContext.setAttribute("curRequestID", oldReqId);

				boolean handleFlag = false;
				String historyRowspan = "1";

				if (handleProp.containsKey(oldReqId)) {
					handleFlag = true;
					historyRowspan = "2";
				}
				User reqUser = null;
				try {
					reqUser = UserManagerFactory.getUserManager().findUser(oldRequest.getParticipant());
				} catch (Exception ex) {
					System.out.println("获取Request用户的时候出错！");
					reqUser = null;
				}
				String participant_cn = reqUser == null ? "" : reqUser.getUsername();

				String reqAction = oldRequest.getReqAction();
				String oper_message = oldRequest.getOperationMessage();

				if (StringHelper.isNull(oper_message) && !StringHelper.isNull(reqAction)) {
					oper_message = "";
					StringReader xmlStr = new StringReader(reqAction);
					DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
					DocumentBuilder builder = dbf.newDocumentBuilder();
					Document doc = builder.parse(new InputSource(xmlStr));
					String xpath = "/activities";
					Element node = (Element) XPathAPI.selectSingleNode(doc, xpath);
					if (node != null) {
						NodeList nodeList = node.getElementsByTagName("activity");
						if (nodeList != null) {
							for (int i = 0; i < nodeList.getLength(); i++) {
								Element activNode = (Element) nodeList.item(i);
								String transName = activNode.getAttribute("transname");
								String performer_cn = "";

								Element pfNode = (Element) activNode.getFirstChild();
								if (pfNode != null) {
									performer_cn = pfNode.getAttribute("cvalue");
								}

								if ("".equals(oper_message)) {
									oper_message = transName;
								} else {
									oper_message += "; <br>" + " " + transName;
								}
							}
						}
					}

					xmlStr.close();
				}

				if ("".equals(oper_message)) oper_message = "&nbsp;";

				oper_message = oldRequest.getActivName();

				out.println("<tr>");
				out.print("<td class=\"tinttd\" rowspan=\"" + historyRowspan + "\">");
				out.print(format.format(oldRequest.getReqTime()));
				out.println("&nbsp;</td>");
				out.print("<td class=\"tinttd\" rowspan=\"" + historyRowspan + "\">");
				out.print(participant_cn);
				out.println("&nbsp;</td>");
				out.print("<td class=\"tinttd\" rowspan=\"" + historyRowspan + "\">");
				out.print(oper_message);
				//out.print(oldRequest.getActivName());
				out.println("&nbsp;</td>");
				out.print("<td class=\"tinttd\">");
				if (oper_message.equals("传阅") && RTFFormat.format(oldRequest.getMessage()).equals("")) {
					out.print("已阅");
				} else {
					out.print(RTFFormat.format(oldRequest.getMessage()));
				}
				out.println("&nbsp;</td>");
				out.print("<td class=\"tinttd\">&nbsp;");%>
<html:attachment moduleid="workflow" unid="curRequestID" showdelete="false"/>
<% out.println("</td>");
	out.println("</tr>");
	if (handleFlag) {
		String srcUrl = contextPath + handleProp.getProperty(oldReqId);
		out.println("<tr>");
		out.print("<td class=\"tinttd\" colspan=\"2\">");
		out.println("<img src=\"" + srcUrl + "\">");
		out.println("</td>");
		out.println("</tr>");
	}
}
	out.println("</table>");
}
	ArrayList livingTaskList = (ArrayList) WorkflowFactory.getTaskManager().getLivingTasksList(instanceId);
	if (livingTaskList != null) {
		if (livingTaskList.size() > 0) {

%>
<script>
	function showCurOperation() {
		var obj = document.all.curopertab;
		if (obj != null) {
			if (obj.style.display == "none") {
				obj.style.display = "inline";
			} else {
				obj.style.display = "none";
			}
		}
	}
</script>
<!--a href="javascript:void(0);" onclick="showCurOperation();">点击此处查看当前执行中操作：</a-->
当前执行中操作：
<table id="curopertab" style="display:inline" width="100%" border="1" align="center" cellpadding="0" cellspacing="0" class="table">
	<tr>
		<td class="deeptd" width="120px">创建时间</td>
		<td class="deeptd">流程操作</td>
		<td class="deeptd">执行人</td>
	</tr>
	<% for (int n = 0; n < livingTaskList.size(); n++) {
		Task task = (Task) livingTaskList.get(n);

		Date date = task.getCreateTime();
		String strDate = format.format(date);
		User taskUser = null;
		try {
			taskUser = UserManagerFactory.getUserManager().findUser(task.getParticipant());
		} catch (Exception ex) {
			System.out.println("获取Task用户的时候出错！");
			taskUser = null;
		}%>
	<tr>
		<td class="tinttd"><%=strDate%>
		</td>
		<td class="tinttd"><%=task.getActivName()%>
		</td>
		<td class="tinttd"><%=taskUser == null ? "" : taskUser.getUsername()%>
		</td>
	</tr>
	<% }%>
</table>
<% }
}%>
<%}

//StringBuffer strBuff = new StringBuffer();
//StringBuffer taskIdBuff = new StringBuffer();

	int taskCount = 0;

	String curInstanceId = flowTransmitInfo.getInstanceID();
	StringBuffer taskIdBuff = new StringBuffer();

	if (flowTransmitInfo.getGetbackFlag()) {
		Collection preTaskIDs = flowTransmitInfo.getGetbackTaskIDs();

		if (preTaskIDs != null) for (Iterator itr = preTaskIDs.iterator(); itr.hasNext();) {
			String preTaskID = (String) itr.next();

			if (taskCount == 0) {
				taskIdBuff.append(preTaskID);
			} else {
				taskIdBuff.append(",");
				taskIdBuff.append(preTaskID);
			}
			taskCount++;
		}
	}

%>

<%if (taskCount > 0) {%>
<FORM METHOD=POST ACTION="<%=(request.getContextPath()+"/workflowBackAction.do")%>" name="flowoperateform">

	<table border="1" width="100%" cellpadding="0" cellspacing="0" class="table">
		<tr>
			<td class="deeptd" width="16%">
				取回意见：
			</td>
			<td class="tinttd">
				<textarea name="dobackMessage" cols="50" rows="4"></textarea>
			</td>
		</tr>
		<tr>
			<td colspan="2" class="tinttd">
				<div align="center">
					<input type="button" value="取 回" onclick="doGetbackDoc()" class="formbutton">
				</div>
			</td>
		</tr>
	</table>

	<div style="display:none">
		<input name="dobackTaskCount" value="<%=taskCount%>">
		<input name="dobackTaskId" value="<%=taskIdBuff.toString()%>">
		<input name="dobackInstanceId" value="<%=curInstanceId%>">
		<input name="dobackMethod" value="">
	</div>

</FORM>

<SCRIPT LANGUAGE="JavaScript">
	<!--

	var flowOperateForm = document.forms["flowoperateform"];
	var taskCount = parseInt(flowOperateForm.dobackTaskCount.value);

	function doGetbackDoc() {
		if (taskCount == 1) {
			if (confirm("是否需要取回该文件？")) {
				dosubmitoperateform("getback");
			}
		} else if (taskCount > 1) {
			doshowpretasks();
		} else {
		}
		return false;
	}

	function dosubmitoperateform(method) {
		flowOperateForm.dobackMethod.value = method;
		flowOperateForm.submit();
	}

	function doshowpretasks() {
		var taskids = flowoperateform.dobackTaskId.value;
		window.showModalDialog('<%=request.getContextPath()%>/workflow/showTaskRequests.jsp?taskids=' + taskids, window, 'status:no;dialogWidth:475px;dialogHeight:280px;scroll:no;help:no;');
	}

	//-->
</SCRIPT>
<%}%><!--索思奇智版权所有-->