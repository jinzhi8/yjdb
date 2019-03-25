<%@page language="java" contentType="text/html;charset=UTF-8" %>

<%@page import="com.kizsoft.commons.Constant" %>
<%@page import="com.kizsoft.commons.commons.attachment.AttachmentEntity" %>
<%@page import="com.kizsoft.commons.commons.attachment.AttachmentManager" %>
<%@page import="com.kizsoft.commons.commons.struts.text.RTFFormat" %>
<%@page import="com.kizsoft.commons.commons.util.StringHelper" %>
<%@page import="com.kizsoft.commons.workflow.Request" %>
<%@page import="com.kizsoft.commons.workflow.WorkflowFactory" %>
<%@page import="org.apache.xpath.XPathAPI" %>

<%@page import="org.w3c.dom.Document" %>
<%@page import="org.w3c.dom.Element" %>
<%@page import="org.w3c.dom.NodeList" %>
<%@page import="org.xml.sax.InputSource" %>
<%@page import="javax.xml.parsers.DocumentBuilder" %>
<%@page import="javax.xml.parsers.DocumentBuilderFactory" %>
<%@page import="java.io.StringReader" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.ArrayList" %>
<%@page import="java.util.Iterator" %>
<%@page import="java.util.Properties" %>

<%@taglib prefix="html" uri="/WEB-INF/oa-html.tld" %>

<html>
<head>
	<link href="<%=request.getContextPath()%>/resources/css/css.css" type="text/css" rel="stylesheet"/>

	<SCRIPT LANGUAGE="JavaScript">
		<!--

		function confirmSelect() {
			var getbackradio = document.all["getbackradio"];
			var checkflag = false;
			var taskid = null;

			for (var i = 0; i < getbackradio.length; i++) {
				if (getbackradio[i].checked) {
					checkflag = true;
					taskid = getbackradio[i].value;
					break;
				}
			}

			if (checkflag) {
				if (confirm("是否需要取回该工作？")) {
					window.dialogArguments.document.flowoperateform.dobackTaskId.value = taskid;
					window.dialogArguments.dosubmitoperateform("getback");

					return true;
				}
			} else {
				alert("请选择需要取回的工作");
			}
			return false;
		}

		//-->
	</SCRIPT>

</head>
<body>
<table width="100%">
	<tr>
		<td align="center">
			<% String showTaskIds = request.getParameter("taskids");
				String[] taskIds = showTaskIds.split(",");

				String contextPath = request.getContextPath();
				pageContext.setAttribute("attTabName", Constant.FLOW_ATTACHMENT_TABLENAME);

				SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm");

				ArrayList requestList = new ArrayList();

				if (taskIds.length > 0) {
					out.println("<table border=\"1\" width=\"90%\" cellpadding=\"0\" cellspacing=\"0\" class=\"table\">" + "<tr><td class=\"deeptd\" width=\"15%\">选择</td>" + "<td class=\"deeptd\" width=\"15%\">时间</td>" + "<td class=\"deeptd\" width=\"15%\">操作</td>" + "<td class=\"deeptd\" width=\"35%\">处理意见</td>" + "<td class=\"deeptd\" width=\"20%\">附件</td></tr>");

					String[] requestIds = new String[taskIds.length];
					for (int i = 0; i < taskIds.length; i++) {
						Request lastReq = WorkflowFactory.getRequestManager().getLastRequestByTaskId(taskIds[i]);

						requestIds[i] = lastReq.getReqId();
						requestList.add(lastReq);
					}
					Properties handleProp = new Properties();

//		String[] requestIds = WorkflowFactory.getRequestManager().getRequestIdsByInstanceId(instanceId);

					ArrayList handleList = new AttachmentManager().getAttachmentsByIDs(Constant.MODULE_NAME_WORKFLOWHANDWRITE, requestIds, null);

					for (Iterator handleItr = handleList.iterator(); handleItr.hasNext();) {
						AttachmentEntity handleEntity = (AttachmentEntity) handleItr.next();
						String docunid = handleEntity.getDocunid();
						String handlePath = handleEntity.getAttachmentPath() + "/" + handleEntity.getAttachmentName();

						handleProp.setProperty(docunid, handlePath);
					}

					//int reqIdx = 0;
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

						out.println("<tr>");
						out.print("<td class=\"tinttd\" rowspan=\"" + historyRowspan + "\">");
						out.print("<input type=\"radio\" class=\"radio\" name=\"getbackradio\" value=\"" + oldRequest.getTaskId() + "\">");
						out.println("&nbsp;</td>");
						out.print("<td class=\"tinttd\" rowspan=\"" + historyRowspan + "\">");
						out.print(format.format(oldRequest.getReqTime()));
						out.println("&nbsp;</td>");
						out.print("<td class=\"tinttd\" rowspan=\"" + historyRowspan + "\">");
						out.print(oper_message);
						//out.print(oldRequest.getActivName());
						out.println("&nbsp;</td>");
						out.print("<td class=\"tinttd\">");
						out.print(RTFFormat.format(oldRequest.getMessage()));
						out.println("&nbsp;</td>");
						out.print("<td class=\"tinttd\">");%>
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
			}%>
		</td>
	</tr>
</table>
<div align="center">
	<input type="button" onclick="if (confirmSelect()){window.close();}" value="确定" class="formbutton">
	<input type="button" onclick="window.close();" value="取消" class="formbutton">
</div>
</body>
</html><!--索思奇智版权所有-->