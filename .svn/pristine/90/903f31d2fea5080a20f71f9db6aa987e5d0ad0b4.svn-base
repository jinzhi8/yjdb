<%@page language="java" contentType="text/html;charset=UTF-8" %>

<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.workflow.Flow" %>
<%@page import="com.kizsoft.commons.workflow.dao.FlowDAO" %>
<%@page import="java.util.ArrayList" %>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="com.kizsoft.commons.commons.db.ConnectionProvider"%>
<%//用户登陆验证
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/html/loginremind.jsp");
	}
	User userInfo = (User) session.getAttribute("userInfo");
	String moduleID = request.getParameter("moduleID");
	System.out.println("moduleID:"+moduleID);
	String userID = userInfo.getUserId();
	Group groupInfo = userInfo.getGroup();
	String groupID = groupInfo.getGroupId();
	String idsStr = userID;
	String docunid = request.getParameter("docunid");
%>	
<html>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache"></META>
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache"></META>
<META HTTP-EQUIV="Expires" CONTENT="0"></META>

<head>
	<title>请选择流程</title>
	<script language="javaScript">
		var userAgent = navigator.userAgent.toLowerCase();
		var isNoIE=/(mozilla|opera|webkit)/.test(userAgent) && !/(compatible)/.test(userAgent);
		if(isNoIE){
			window.dialogArguments = window.opener;
		}
		function autoselect() {

			if (document.all.flowselector.options.length==1) {
				submitFileInfo();
			}
		}
		function submitFileInfo() {
			var flowID = document.all.flowselector.value;
				/*url = "../costscrap/DoGetScrapAction.do?appId=<%=docunid%>&flowId=" + flowID;*/
				url = "../zwdb/toDocAction.do?appId=<%=docunid%>&moduleID=<%=moduleID%>&flowId=" + flowID;	
				//window.location=url;
				window.dialogArguments.location.href = url;
			window.close();
		}
	</script>
</head>
<body bgcolor="#e0e0e0" onload="autoselect();">
<table width="97%" align="center" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<fieldset style="width:98%;padding:1px">
				<legend>
					<b style="font-size:14px">请选择流程：</b>
				</legend>
				<form style="padding:0px">
					<table border="0" align="center" width="80%">
						<tr>
							<td>
								<%
									FlowDAO flowDAO = new FlowDAO();
									ArrayList arrList = (ArrayList) flowDAO.getFlowList(userID, moduleID);
									out.println("<SELECT NAME=\"flowselector\" style=\"width:100%;\">");
									if (arrList.size() > 0) {
										for (int i = 0; i < arrList.size(); i++) {
											Flow flow = (Flow) arrList.get(i);
											String flowStatus =flow.getFlowStatus();
											if("0".equals(flowStatus))
											{
											out.println("<OPTION VALUE=\"" + flow.getFlowId() + "\">" + flow.getFlowName());
											}
										}
									}
									out.println("</SELECT>");
								%>
							</td>
						</tr>
						<tr><td align="center">
						<br/><a href="#" onclick="window.showModalDialog('<%=request.getContextPath()%>/workflow/viewvmlflow.jsp?flowid='+document.all.flowselector.value,window,'status:no;dialogWidth:800px;dialogHeight:600px;scroll:auto;help:no;');" style="font-size:12px;color:red">查看流程图</a>
						</td></tr>
            <tr>
                <td height="50px" align="center">
                  <input type="button" value="确定" onclick="submitFileInfo()">
                  <input type="button" value="取消" onclick="self.close()">
                </td>
            </tr>
					</table>
				</form>
			</fieldset>
		</td>
	</tr>

	
</table>
</body>
</html>
<!--索思奇智版权所有-->