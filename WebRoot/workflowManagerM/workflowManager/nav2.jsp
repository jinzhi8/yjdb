<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleManager" %>
<%@page import="com.kizsoft.commons.workflow.Flow" %>
<%@page import="com.kizsoft.commons.workflow.dao.FlowDAO" %>
<%@page import="java.util.ArrayList" %>
<%@page import="java.util.Collection" %>
<%@page import="java.util.Iterator" %>
<% //用户登陆验证
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
	}
	String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
	User userInfo = (User) session.getAttribute("userInfo");
	String userID = userInfo.getUserId();
	Group groupInfo = userInfo.getGroup();
	String groupID = groupInfo.getGroupId();
	String idsStr = userID;

	String moduleID = request.getParameter("moduleid");

	ModuleManager moduleManager = new ModuleManager();
	ArrayList arrList = (ArrayList) moduleManager.getModuleListWithFlow(idsStr);

	FlowDAO flowDAO = new FlowDAO();%>
<SCRIPT LANGUAGE="JavaScript">
	//<!--
	function openflow(flowId) {
		var appletwin = window.parent.document.cframe.window;
		var appletobj = appletwin.document.workflow;
		appletobj.openFlow(flowId);
		//appletwin.location.href="<%=contextPath%>/workflowManager/editvmlflow.jsp?flowid="+flowId;
	}	//-->
</SCRIPT>
<SCRIPT src="<%=contextPath%>/resources/tree/tree.js" type=text/javascript></SCRIPT>
<SCRIPT type=text/javascript>
	//<!--
	var Tree = new Array;
	<%int menuIndex = 0;
			int parentNodeId = 0;
			for (int i = 1; i <= arrList.size(); i++) {
				String[] moduleInfo = (String[]) arrList.get(i - 1);
				//ModuleInfo moduleInfo = (ModuleInfo)
				Collection flowsList = flowDAO.getFlowList(userID,
						moduleInfo[0]);
				Iterator iterator = flowsList.iterator();
				int flowLength = flowsList.size();%>
	Tree[<%=menuIndex%>] = "<%=menuIndex + 1%>|0|<%=moduleInfo[1]%>||cframe";
	<%menuIndex++;
					parentNodeId = menuIndex;
					for (int j = 1; j <= flowLength; j++) {
						Flow flow = (Flow) iterator.next();%>
	Tree[<%=menuIndex%>] = "<%=menuIndex + 1%>|<%=parentNodeId%>|<%=flow.getFlowName()%>|javascript:openflow('<%=flow.getFlowId()%>');void(0);|";
	<%menuIndex++;
			  }
		  }%>//-->
</SCRIPT>
<style type="text/css">
	html {
		overflow-x: hidden;
		width: 100%;
		height: 100%;
		scrollbar-base-color: #f0f0f0;
	}

	body {
		overflow-x: hidden;
		margin: 0px;
		background-color: #FFFFFF;
		color: #555555;
		width: 100%;
		height: 100%;
		font-size: 12px;
	}

	td {
		padding: 0px;
		font-size: 12px;
	}

	a {
		font-size: 12px;
		color: #555555;
		text-decoration: none;
	}

	img {
		border: 0px;
	}
</style>
<body>
<DIV style="margin-left: 0px; margin-top: 10px" class="explore">
	<TABLE border=0 cellPadding=0 cellSpacing=0>
		<TBODY>
		<TR>
			<TD bgColor=#ffffff noWrap>
				<P style="MARGIN-LEFT: 0px; MARGIN-TOP: 3px">
					<A><IMG border=0 hspace=0 src="<%=request.getContextPath()%>/resources/images/computer.gif" align="middle"></A>
				</P>
			</TD>
			<TD bgColor=#ffffff style="BORDER-LEFT: #ffffff 3px solid" align=left>
				<P style="MARGIN-LEFT: 2px; MARGIN-RIGHT: 2px; MARGIN-TOP: 2px">
					<A>应用模块导航</A></P>
			</TD>
		</TR>
		</TBODY>
	</TABLE>
</DIV>
<SCRIPT type=text/javascript>
	//<!--
	createTree(Tree);
	//-->
</SCRIPT>
</body>

<!--索思奇智版权所有-->