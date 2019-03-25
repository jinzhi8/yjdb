<%@page language="java" contentType="text/html;charset=UTF-8" %>

<%@page import="com.kizsoft.commons.Constant" %>
<%@page import="com.kizsoft.commons.commons.attachment.AttachmentEntity" %>
<%@page import="com.kizsoft.commons.commons.attachment.AttachmentManager" %>
<%@page import="com.kizsoft.commons.commons.struts.text.RTFFormat" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
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
<%@page import="java.sql.Connection" %>
<%@page import="java.sql.PreparedStatement" %>
<%@page import="java.sql.ResultSet" %>
<%@page import="java.sql.Statement" %>
<%@page import="java.sql.Timestamp" %>
<%@page import="com.kizsoft.commons.commons.db.ConnectionProvider" %>

<%@taglib prefix="html" uri="/WEB-INF/oa-html.tld" %>
<%!
public static String htmlencode(String str){
        if (str == null || str == ""){
            return "";
        }
        str = str.replace("&", "&amp;");
        str = str.replace(">", "&gt;");
        str = str.replace("<", "&lt;");
        str = str.replace(" ", "&nbsp;");
        str = str.replace("\"", "&quot;");
        //str = str.replace("\'", "'");
        str = StringHelper.replaceAll(str,"\n", "<br/>");
        str = StringHelper.replaceAll(str,"\r", "<br/>");
        return str;
}
 public Collection getUNfinishTasksByInstanceID(String instanceID)
  {
    Collection livingTasksList = null;
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String sql = null;
    try {
      con = ConnectionProvider.getConnection();
      sql = "SELECT * FROM view_flow_tasks_unfinishs WHERE task_status = '0' AND instance_id = ? order by create_time,work_order";

      pstmt = con.prepareStatement(sql);
      pstmt.setString(1, instanceID);
      rs = pstmt.executeQuery();

      livingTasksList = new ArrayList();

      while (rs.next()) {
        Task task = new Task();
        task.setInstanceId(rs.getString("instance_id"));
        task.setAppId(rs.getString("app_id"));
        task.setAppTitle(rs.getString("app_title"));
        task.setFlowId(rs.getString("flow_id"));
        task.setTaskId(rs.getString("task_id"));
        task.setActivId(rs.getString("activ_id"));
        task.setActivName(rs.getString("activ_name"));
        task.setParticipant(rs.getString("participant"));
        task.setParticipant_cn(rs.getString("participant_cn"));
        task.setDepartmentId(rs.getString("departmentid"));
        task.setDepartmentName(rs.getString("departmentname"));
        task.setPosition(rs.getString("position"));
        task.setCreateTime(rs.getTimestamp("create_time"));
        task.setCompleteTime(rs.getTimestamp("complete_time"));
        task.setTimeLimit(rs.getTimestamp("time_limit"));
        task.setPreTaskId(rs.getString("pre_task_id"));

        livingTasksList.add(task);
      }
    } catch (Exception ex) {
      ex.printStackTrace();
    } finally {
      ConnectionProvider.close(con, pstmt, rs);
    }
    return livingTasksList;
  }
%>
<%
	String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
	FlowTransmitInfo flowTransmitInfo = (FlowTransmitInfo) request.getAttribute("flowTransmitInfo");
	Instance curInstance = null;
	if (flowTransmitInfo.getCurInstance() != null) curInstance = flowTransmitInfo.getCurInstance();

	if (curInstance != null) {
		String instanceId = curInstance.getInstanceId();

		pageContext.setAttribute("attTabName", Constant.FLOW_ATTACHMENT_TABLENAME);

		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		Collection requestList = WorkflowFactory.getRequestManager().getRequestListByInstanceWithSubflow(curInstance);

		if (requestList.size() > 0) {
			out.println("已处理任务过程列表：<a href=\"javascript:void(0);\" onclick=\"showPreOperation();\" style=\"color:red\"><span id=\"yclcz\">点击隐藏已执行操作</span></a><br/><br/><table id=\"preopertab\" border=\"0\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" style=\"word-break:break-all\" class=\"table\"><tr><td class=\"deeptd\" width=\"120px\">处理时间</td><td class=\"deeptd\" width=\"100px\">处理人员</td>"+"<td class=\"deeptd\" width=\"100px\">职务</td>" +"<td class=\"deeptd\" width=\"150px\">流程操作</td><td class=\"deeptd\">处理意见</td></tr>");

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
				String participant_cn = oldRequest.getParticipant_cn();
				if(StringHelper.isNull(participant_cn)){
					User reqUser = null;
					try {
						reqUser = UserManagerFactory.getUserManager().findUser(oldRequest.getParticipant());
					} catch (Exception e) {}
					if(reqUser!=null){
						participant_cn = reqUser.getUsername();
					}else{
						participant_cn = "";
					}
					
				}
				String reqPosition = oldRequest.getPosition();
				if(StringHelper.isNull(reqPosition)){
					User reqUser = null;
					try {
						reqUser = UserManagerFactory.getUserManager().findUser(oldRequest.getParticipant());
					} catch (Exception e) {}
					if(reqUser!=null){
						reqPosition = reqUser.getPosition();
					}else{
						reqPosition = "";
					}
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

				oper_message = oldRequest.getActivName();
				User participantUser = null;
				Group participantGroup = null;
				try {
					participantUser = UserManagerFactory.getUserManager().findUser(oldRequest.getParticipant());
					participantGroup = participantUser.getGroup();
				} catch (Exception ex) {
					System.out.println("获取Task用户的时候出错！");
					participantUser = null;
				}
				out.println("<tr>");
				/******
				out.print("<td class=\"tinttd\">");
				out.print(format.format(oldRequest.getReqTime()));
				out.println("</td>");
				********/
				out.print("<td class=\"tinttd\">");
				out.print(WorkflowFactory.getTaskManager().getTask(oldRequest.getTaskId()).getCompleteTime()==null?format.format(oldRequest.getReqTime()):format.format(WorkflowFactory.getTaskManager().getTask(oldRequest.getTaskId()).getCompleteTime()));
				out.println("</td>");
				/********
				out.print("<td class=\"tinttd\">");
				out.print(WorkflowFactory.getTaskManager().getTask(oldRequest.getTaskId()).getTimeLimit()==null?"":format.format(WorkflowFactory.getTaskManager().getTask(oldRequest.getTaskId()).getTimeLimit()));
				out.println("</td>");
				*******/
				if(participantGroup!=null)
				{
			    out.print("<td class=\"tinttd\" title=\""+participantGroup.getGroupname()+"\">");
				out.print(participant_cn);
				}
				else {
				out.print("<td class=\"tinttd\">");
				out.print(participant_cn);
				}
				//out.print("&nbsp;<input type=\"button\" value=\"短信提醒\" onclick=\"window.showModalDialog('"+contextPath+"/sendmsn/smstitle.jsp?userid="+oldRequest.getParticipant()+"',window,'status:no;dialogWidth:345px;dialogHeight:220px;scroll:no;help:no;');\">");
				out.println("&nbsp;</td>");
				//out.print("<td class=\"tinttd\" >");
				//if (participantGroup != null) {
				//	out.print(participantGroup.getGroupname());
				//}
				//out.println("&nbsp;</td>");
				out.print("<td class=\"tinttd\" style=\"width:120px;\">");
				out.print(reqPosition==null?"":reqPosition);
				out.println("&nbsp;</td>");
				out.print("<td class=\"tinttd\">");
				out.print(oper_message);
				//out.print(oldRequest.getActivName());
				out.println("&nbsp;</td>");
				//out.println("<td class=\"tinttd\" style=\"text-align:right;\" rowspan=\"" + historyRowspan + "\">附件</td>");
				//out.print("<td class=\"tinttd\" colspan=\"5\">");
	//out.println("&nbsp;</td>");
	//out.println("</tr>");
	//out.println("<tr>");
	//out.println("<td class=\"tinttd\" style=\"text-align:right;\" rowspan=\"" + historyRowspan + "\">处理意见</td>");
	out.print("<td class=\"tinttd\" colspan=\"5\" style=\"color:red;\">");
	if (oper_message.equals("传阅") && RTFFormat.format(oldRequest.getMessage()).equals("")) {
		out.print("已阅");
	} else {
		//out.print(oldRequest.getMessage());
		out.print(RTFFormat.format(oldRequest.getMessage()));
		//out.print(htmlencode(oldRequest.getMessage()));
	}
	%>
	<html:attachment moduleid="workflow" unid="curRequestID" showdelete="false"/>
<%
	if (handleFlag) {
		String srcUrl = contextPath + handleProp.getProperty(oldReqId);
		//out.println("<tr>");
		//out.print("<td class=\"tinttd\" colspan=\"4\">");
		out.println("<br/>");
		out.println("<img src=\"" + srcUrl + "\">");
		//out.println("</td>");
		//out.println("</tr>");
	}
	out.println("&nbsp;</td>");
	out.println("</tr>");
	
}
	out.println("</table>");
}
	ArrayList livingTaskList = (ArrayList) WorkflowFactory.getTaskManager().getLivingTasksList(instanceId);
	if (livingTaskList != null) {
		if (livingTaskList.size() > 0) {

%>
<!--
<br/>
<br/>
待处理任务过程列表：<a href="javascript:void(0);" onclick="showCurOperation();" style="color:red"><span id="dclcz">点击此处查看当前执行中操作</span></a>
<br/>
<br/>
-->
<table id="curopertab" width="100%" align="center" style="display:none;word-break:break-all" class="table" >
	<tr>
		<td class="deeptd" width="120px">创建时间</td>
		<!--<td class="deeptd" width="120px">限期时间</td>-->
		<td class="deeptd" width="150px">处理人员</td>
		<td class="deeptd" width="150px">单位</td>
		<td class="deeptd" width="150px">职务</td>
		<td class="deeptd">流程操作</td>
	</tr>
	<%for (int n = 0; n < livingTaskList.size(); n++) {
		Task task = (Task) livingTaskList.get(n);

		Date date = task.getCreateTime();
		String strDate = format.format(date);
		Date timeLimitDate = task.getTimeLimit();
		String strTimeLimitDate = timeLimitDate==null?"":format.format(timeLimitDate);
		String taskParticipant_cn = task.getParticipant_cn();
		if(StringHelper.isNull(taskParticipant_cn)){
			User taskUser = null;
			try {
				taskUser = UserManagerFactory.getUserManager().findUser(task.getParticipant());
			} catch (Exception e) {}
			if(taskUser!=null){
				taskParticipant_cn = taskUser.getUsername();
			}else{
				taskParticipant_cn = "";
			}
		}
		String taskDepartmentName = task.getDepartmentName();
		if(StringHelper.isNull(taskDepartmentName)){
			User taskUser = null;
			try {
				taskUser = UserManagerFactory.getUserManager().findUser(task.getDepartmentId());
			} catch (Exception e) {}
			if(taskUser!=null){
				taskDepartmentName = taskUser.getUsername();
			}else{
				taskDepartmentName = "";
			}
		}
		String taskPosition = task.getPosition();
		if(StringHelper.isNull(taskPosition)){
			User taskUser = null;
			try {
				taskUser = UserManagerFactory.getUserManager().findUser(task.getParticipant());
			} catch (Exception e) {}
			if(taskUser!=null){
				taskPosition = taskUser.getPosition();
			}else{
				taskPosition = "";
			}
		}
	%>
	<tr>
		<td class="tinttd"><%=strDate%></td>
		<!--<td class="tinttd"><%=strTimeLimitDate%></td>-->
		<td class="tinttd"><%=taskParticipant_cn == null ? "" : taskParticipant_cn%>
		<%if(!(((User) session.getAttribute("userInfo")).getUserId()).equals(task.getParticipant())){%>
		&nbsp;<input type="button" value="短信提醒" onclick="window.showModalDialog('<%=contextPath%>/sendmsn/smstitle.jsp?userid=<%=task.getParticipant()%>',window,'status:no;dialogWidth:345px;dialogHeight:220px;scroll:no;help:no;');">
		<%}%>
		</td>
		<td class="tinttd"><%=taskDepartmentName == null ? "" : taskDepartmentName%></td>
		<td class="tinttd"><%=taskPosition==null?"":taskPosition%>&nbsp;</td>
		<td class="tinttd"><%=task.getActivName()%></td>
	</tr>
	<%}%>
</table>
<br/>
<%}
} 
  
  ArrayList unfinishTaskList = (ArrayList)getUNfinishTasksByInstanceID(instanceId);
     //out.println("88888888888888888"+instanceId);
   	if (unfinishTaskList != null) {
		if (unfinishTaskList.size() > 0) {
		//out.println("size="+unfinishTaskList.size()); 
 %>
 <br/>
<br/>
未处理任务过程列表：<a href="javascript:void(0);" onclick="showCurOperationW();" style="color:red"><span id="wclrw">点击此处查看当前执行中操作</span></a>
<br/>
<br/>
<table id="curopertabW" width="100%" align="center" style="display:none;word-break:break-all" class="table">
	<tr>
		<td class="deeptd" width="120px">创建时间</td>
		<!--<td class="deeptd" width="120px">限期时间</td>-->
		<td class="deeptd" width="150px">处理人员</td>
		<td class="deeptd" width="150px">单位</td>
		<td class="deeptd" width="150px">职务</td>
		<td class="deeptd">流程操作</td>
	</tr>
	<%for (int n = 0; n < unfinishTaskList.size(); n++) {
		Task task = (Task) unfinishTaskList.get(n);

		Date date = task.getCreateTime();
		String strDate = format.format(date);
		Date timeLimitDate = task.getTimeLimit();
		String strTimeLimitDate = timeLimitDate==null?"":format.format(timeLimitDate);
		String taskParticipant_cn = task.getParticipant_cn();
		if(StringHelper.isNull(taskParticipant_cn)){
			User taskUser = null;
			try {
				taskUser = UserManagerFactory.getUserManager().findUser(task.getParticipant());
			} catch (Exception e) {}
			if(taskUser!=null){
				taskParticipant_cn = taskUser.getUsername();
			}else{
				taskParticipant_cn = "";
			}
		}
		String taskDepartmentName = task.getDepartmentName();
		if(StringHelper.isNull(taskDepartmentName)){
			User taskUser = null;
			try {
				taskUser = UserManagerFactory.getUserManager().findUser(task.getDepartmentId());
			} catch (Exception e) {}
			if(taskUser!=null){
				taskDepartmentName = taskUser.getUsername();
			}else{
				taskDepartmentName = "";
			}
		}
		String taskPosition = task.getPosition();
		if(StringHelper.isNull(taskPosition)){
			User taskUser = null;
			try {
				taskUser = UserManagerFactory.getUserManager().findUser(task.getParticipant());
			} catch (Exception e) {}
			if(taskUser!=null){
				taskPosition = taskUser.getPosition();
			}else{
				taskPosition = "";
			}
		}
	%>
	<tr>
		<td class="tinttd"><%=strDate%></td>
		<!--<td class="tinttd"><%=strTimeLimitDate%></td>-->
		<td class="tinttd"><%=taskParticipant_cn == null ? "" : taskParticipant_cn%></td>
		<td class="tinttd"><%=taskDepartmentName == null ? "" : taskDepartmentName%></td>
		<td class="tinttd"><%=taskPosition==null?"":taskPosition%>&nbsp;</td>
		<td class="tinttd"><%=task.getActivName()%></td>
	</tr>
	<%}%>
</table>


<br/>
<%}
}%>
<br>
<%}%>

<%//StringBuffer strBuff = new StringBuffer();
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
	}%>

<%if (taskCount > 0) {%>
<FORM METHOD=POST ACTION="<%=(request.getContextPath()+"/workflowBackAction.do")%>" name="flowoperateform" style="display:none">

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
	//<!--
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
		window.showModalDialog('<%=request.getContextPath()%>/workflow/showTaskRequests.jsp?taskids=' + taskids, window, 'status:no;dialogWidth:475px;dialogHeight:280px;scroll:auto;help:no;');
	}

	//-->
</SCRIPT>
<%}%>
<script>
	function showCurOperation() {
		var obj = document.all.curopertab;
		var spanobj = document.all.dclcz;
		if (obj != null) {
			if (obj.style.display == "none") {
				obj.style.display = "inline";
				spanobj.innerHTML="点击隐藏当前执行中操作";
			} else {
				obj.style.display = "none";
				spanobj.innerHTML="点击此处查看当前执行中操作";
			}
		}
	}
	function showCurOperationW() {
		var obj = document.all.curopertabW;
		var spanobj = document.all.wclrw;
		if (obj != null) {
			if (obj.style.display == "none") {
				obj.style.display = "inline";
				spanobj.innerHTML="点击隐藏当前执行中操作";
			} else {
				obj.style.display = "none";
				spanobj.innerHTML="点击此处查看当前执行中操作";
			}
		}
	}
	
	showCurOperationW
	function showPreOperation() {
		var obj = document.all.preopertab;
		var spanobj = document.all.yclcz;
		if (obj != null) {
			if (obj.style.display == "none") {
				obj.style.display = "inline";
				spanobj.innerHTML="点击隐藏已执行操作";
			} else {
				obj.style.display = "none";
				spanobj.innerHTML="点击此处查看已执行操作";
			}
		}
	}
</script><!--索思奇智版权所有-->