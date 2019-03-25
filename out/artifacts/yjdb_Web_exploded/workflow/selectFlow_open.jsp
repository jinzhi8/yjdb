<%@page language="java" contentType="text/html;charset=UTF-8" %>

<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.workflow.Flow" %>
<%@page import="com.kizsoft.commons.workflow.dao.FlowDAO" %>
<%@page import="java.util.ArrayList" %>
<%//用户登陆验证
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/html/loginremind.jsp");
	}
	User userInfo = (User) session.getAttribute("userInfo");
	String moduleID = request.getParameter("moduleID");
	String userID = userInfo.getUserId();
	Group groupInfo = userInfo.getGroup();
	String groupID = groupInfo.getGroupId();
	String idsStr = userID;
	String sendtoget = request.getParameter("sendtoget");
	String docunid = request.getParameter("docunid");%>
<html>
<head>
	<title>请选择流程</title>
	<script language="javaScript">
		var userAgent = navigator.userAgent.toLowerCase();
		var isNoIE=/(mozilla|opera|webkit)/.test(userAgent) && !/(compatible)/.test(userAgent);
		if(isNoIE){
			window.dialogArguments = window.opener;
		}
		function submitFileInfo() {
			var flowID = document.all.flowselector.value;
			if (<%out.print(sendtoget);%> == "1"
		)
		{
			url = "../senddoc/doGetAction.do?docunid=<%out.print(docunid);%>&flowID=" + flowID;
			//window.location=url;
			window.dialogArguments.location.href = url;
			//window.open(url,'_blank','');
		}
		else
		{
			if (<%out.print(sendtoget);%> == "2"
		)
		{
			url = "../docreport/DoGetDocAction.do?docunid=<%out.print(docunid);%>&flowID=" + flowID;
			window.dialogArguments.location.href = url;
			//window.open(url,'_blank','');
		}
		else
		{
			window.dialogArguments.openDocument(flowID);
		}
		}
			window.close();
		}
	</script>
</head>
<body bgcolor="#e0e0e0">
<table width="97%" align="center" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<fieldset style="width:98%;padding:1px">
				<legend>
					<b style="font-size:14px">请选择流程：</b>
				</legend>
				<form style="padding:0px">
					<table border="0" align="center">
						<tr>
							<td>
								<%

									FlowDAO flowDAO = new FlowDAO();
									ArrayList arrList = (ArrayList) flowDAO.getFlowList(userID, moduleID);
									if (arrList.size() > 0) {
										out.println("<SELECT NAME=\"flowselector\" style=\"width:100%\">");
										for (int i = 0; i < arrList.size(); i++) {
											Flow flow = (Flow) arrList.get(i);
											out.println("<OPTION VALUE=\"" + flow.getFlowId() + "\">" + flow.getFlowName());
										}
										out.println("</SELECT>");
									}

								%>
							</td>
						</tr>

					</table>
				</form>
			</fieldset>
		</td>
	</tr>

	<tr>
		<td height="50px" align="center">
			<input type="button" value="确定" onclick="submitFileInfo()">
			<input type="button" value="取消" onclick="self.close()">
		</td>
	</tr>
</table>
</body>
</html>
<!--索思奇智版权所有-->