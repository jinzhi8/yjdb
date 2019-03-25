<%@page language="java" contentType="text/html;charset=UTF-8" %>

<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.workflow.Flow" %>
<%@page import="com.kizsoft.commons.workflow.dao.FlowDAO" %>
<%@page import="com.kizsoft.commons.setttings.beans.TemplatesManager" %>
<%@page import="com.kizsoft.commons.setttings.beans.TemplatesInfo" %>
<%@page import="java.util.ArrayList" %>

<%//用户登陆验证
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
		return;
	}
	User userInfo = (User) session.getAttribute("userInfo");
	String moduleID = request.getParameter("moduleID");
	String userID = userInfo.getUserId();
	String moduleCode = request.getParameter("module");
	String typeCode = request.getParameter("type");
%>
<html>
<head>
	<META HTTP-EQUIV="Pragma" CONTENT="no-cache" />
	<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache" />
	<META HTTP-EQUIV="Expires" CONTENT="0" />
	<title>请选择流程和模版</title>
	<script language="javaScript">
		var userAgent = navigator.userAgent.toLowerCase();
		var isNoIE=/(mozilla|opera|webkit)/.test(userAgent) && !/(compatible)/.test(userAgent);
		if(isNoIE){
			window.dialogArguments = window.opener;
		}
		function submitFlowWithTemplates() {
			var flowItem = document.all.flowselector;
			var templatesItem = document.all.templatesselector;
			if (flowItem != null) {
				var flowID = flowItem.value;
				var templatesID = templatesItem.value;
				window.dialogArguments.location.href="../workflowEntry.do?flowid="+flowID+"&templates="+templatesID+"<%="documents".equals(moduleID)?"&sendget=1":""%>";
				self.close();
			} else {
				//alert("您没有发文的权限！\n请确认系统参数已经配置完整！");
				alert("请选择相应流程");
			}
		}
	</script>
</head>
<body bgcolor="#f5f5f5">
<table width="97%" align="center" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<fieldset style="width:98%;padding:1px">
				<legend>
					<b style="font-size:14px">请选择模版：</b>
				</legend>
				<form style="padding:0px">
					<table border="0" align="center">
						<tr>
							<td>
								<SELECT NAME="templatesselector" style="width:300px">
									<option value="">请选择...</option>
								<%
									TemplatesManager templatesManager = new TemplatesManager();
									ArrayList arrList = (ArrayList) templatesManager.getTemplatesInfoList(moduleCode,typeCode,userID);
									if (arrList.size() > 0) {
										for (int i = 0; i < arrList.size(); i++) {
											TemplatesInfo templatesInfo = (TemplatesInfo) arrList.get(i);
											out.println("<OPTION VALUE=\"" + templatesInfo.getUuid() + "\">" + templatesInfo.getTepmlateName());
										}
									}
								%>
								</SELECT>
							</td>
						</tr>
					</table>
				</form>
			</fieldset>
		</td>
	</tr>
	<tr>
		<td>
			<fieldset style="width:98%;padding:1px">
				<legend>
					<b style="font-size:14px">请选择流程：</b>
				</legend>
				<form style="padding:0px">
					<table border="0" align="center">
						<tr>
							<td align="center">
								<SELECT NAME="flowselector" style="width:300px">
								<%
									FlowDAO flowDAO = new FlowDAO();
									arrList = (ArrayList) flowDAO.getFlowList(userID, moduleID);
									if (arrList.size() > 0) {
										for (int i = 0; i < arrList.size(); i++) {
											Flow flow = (Flow) arrList.get(i);
											if("0".equals(flow.getFlowStatus())){
											out.println("<OPTION VALUE=\"" + flow.getFlowId() + "\">" + flow.getFlowName());
											}
										}
									}
								%>
								</SELECT><br/><a href="#" onclick="window.showModalDialog('<%=request.getContextPath()%>/workflow/viewvmlflow.jsp?flowid='+document.all.flowselector.value,window,'status:no;dialogWidth:800px;dialogHeight:600px;scroll:auto;help:no;');" style="font-size:12px;color:red">查看流程图</a>
							</td>
						</tr>
					</table>
				</form>
			</fieldset>
		</td>
	</tr>
	<tr>
		<td height="50px" align="center">
			<input type="button" value="确定" onclick="submitFlowWithTemplates();">
			<input type="button" value="取消" onclick="self.close()">
		</td>
	</tr>
</table>
</body>
</html>
<!--索思奇智版权所有-->