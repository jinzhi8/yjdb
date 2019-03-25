<%@page language="java" contentType="text/html;charset=UTF-8" %>

<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.workflow.Flow" %>
<%@page import="com.kizsoft.commons.workflow.dao.FlowDAO" %>
<%@page import="java.util.ArrayList" %>
<%//用户登陆验证
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
		return ;
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
<META HTTP-EQUIV="Pragma" CONTENT="no-cache"></META>
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache"></META>
<META HTTP-EQUIV="Expires" CONTENT="0"></META>

<head>
  	<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery-1.11.0.min.js" ></script>
  	<script type="text/javascript" src="<%=request.getContextPath()%>/js/layer/layer.js" ></script>
	<title>请选择流程</title>
	<script language="javaScript">
		var userAgent = navigator.userAgent.toLowerCase();
		var isNoIE=/(mozilla|opera|webkit)/.test(userAgent) && !/(compatible)/.test(userAgent);
		if(isNoIE){
			window.dialogArguments = window.opener;
		}
		function autoselect() {
			if (document.all.flowselector.options.length==1) {
				//submitFileInfo();
			}
		}
		function submitFileInfo() {
			var flowID = document.all.flowselector.value;
			url = "<%=request.getContextPath()%>/workflowEntry.do?flowid=" + flowID;
			window.parent.location.href=url;
			var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
			window.parent.layer.close(index);
			
		}
	</script>
<style type="text/css">
<!--
body {
	font-family: Arial, Helvetica, sans-serif;
	font-size:12px;
	color:#666666;
	background:#fff;
	text-align:center;

}
	fieldset {
	padding:10px;
	margin-top:5px;
	border:1px solid #1E7ACE;
	background:#fff;
}

fieldset legend {
	color:#1E7ACE;
	font-weight:bold;
	padding:3px 20px 3px 20px;
	border:1px solid #1E7ACE;	
	background:#fff;
}
-->
	</style>
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
											if("0".equals(flow.getFlowStatus())){
											out.println("<OPTION VALUE=\"" + flow.getFlowId() + "\">" + flow.getFlowName());
											}
										}
									}
									out.println("</SELECT>");
								%>
							</td>
						</tr>
						<tr><td align="center">
						<br/><a href="#" onclick="openNew(document.all.flowselector.value);" style="font-size:12px;color:red">查看流程图</a>
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
<script type="text/javascript">
function openNew(unid) {
    var width = 1006;
    var height =640;
    var iTop = (window.screen.availHeight - height ) / 2;
    var iLeft = (window.screen.availWidth - width) / 2 + 90;
    var win = window.open("<%=request.getContextPath()%>/workflow/viewvmlflow.jsp?flowid="+unid, "弹出窗口", "width=" + width + ", height=" + height + ",top=" + iTop + ",left=" + iLeft + ",toolbar=no, menubar=no, scrollbars=yes, resizable=no,location=no, status=no,alwaysRaised=yes,depended=yes");
}
</script>
<!--索思奇智版权所有-->