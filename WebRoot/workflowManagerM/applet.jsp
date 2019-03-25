<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>

<link href="<%=request.getContextPath()%>/resources/css/css.css" type="text/css" rel="stylesheet"/>
<SCRIPT LANGUAGE="JavaScript">
	<!--
	function openDialog() {
		if (document.all.selType.value == 'flowrange') {
			window.showModalDialog('<%=request.getContextPath()%>/address/treeforflow.jsp?utype=3&rtype=1&count=0&fields=rangeNames,rangeIds', window, 'status:no;dialogWidth:300px;dialogHeight:380px;scroll:no;help:no;')
		} else if (document.all.selType.value == 'nodeperformer') {
			window.showModalDialog('<%=request.getContextPath()%>/address/treeforflow.jsp?utype=1&sflag=0&count=0&fields=rangeNames,rangeIds', window, 'status:no;dialogWidth:300px;dialogHeight:380px;scroll:no;help:no;')
		} else if (document.all.selType.value == 'performerpur') {
			window.showModalDialog('<%=request.getContextPath()%>/address/treeforflow.jsp?utype=3&sflag=0&count=0&fields=rangeNames,rangeIds', window, 'status:no;dialogWidth:300px;dialogHeight:380px;scroll:no;help:no;')
		}
	}
	function setRange() {
		document.workflow.setRangeValue();
	}
	function reloadWin() {
		var navwin = window.parent.mframe;
		navwin.location.reload();
	}		//-->
</SCRIPT>
<%//用户登陆验证
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
		return;
	}
	User userInfo = (User) session.getAttribute("userInfo");
	String moduleID = null;
	String userID = userInfo.getUserId();
	Group groupInfo = userInfo.getGroup();
	String groupID = groupInfo.getGroupId();
	String idsStr = userID;

	String contextpath = "http://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath();%>
<table border="0" class="main_table" width="100%">
	<tr>
		<td class="title">流程设置</td>
	</tr>
	<tr>
		<td class="mid_col" width="100%">
			<APPLET name="workflow" archive="workflowmanager.jar" CODE="com.kizsoft.commons.workflow.applet.Drawing.class" WIDTH="800" HEIGHT="1000">
				<param name="contextpath" value="<%=contextpath%>">
				您请安装Sun Java 虚拟机。<a href="jre.exe">点击下载</a>
			</APPLET>
			<FORM name="selform">
				<div style="display:none">
					<INPUT TYPE="text" NAME="selType" value="flowrange">
					<textarea id="rangeNames"></textarea>
					<textarea id="rangeIds"></textarea>
					<INPUT TYPE="button" NAME="openaddress" onclick="openDialog()">
					<INPUT TYPE="button" NAME="setvalue" onclick="setRange()">
					<INPUT TYPE="button" NAME="reloadwindow" onclick="reloadWin()">
				</div>
			</FORM>
		</td>
	</tr>
</table><!--索思奇智版权所有-->