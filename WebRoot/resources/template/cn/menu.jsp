<%@page contentType="text/html; charset=UTF-8" language="java" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleManager" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleMenu" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleView" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleViewManager" %>
<%@page import="java.util.ArrayList" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.acl.ACLManager" %>
<%@page import="com.kizsoft.commons.acl.ACLManagerFactory" %>


<%
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
		return;
	}
	String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
	User userInfo = (User) session.getAttribute("userInfo");
	String userName = userInfo.getUsername();
	String userId = userInfo.getUserId();
	String udepartment = userInfo.getGroup().getGroupname();
	String[] userConfig = userInfo.getUserConfig();
	Group groupInfo = (Group) userInfo.getGroup();
	String idsStr = userInfo.getUserId();
	String userflag = (String) session.getAttribute("userFlag");
	String templatename = (String) session.getAttribute("templatename");
	if (templatename == null) {
		templatename = "cn";
	}
	%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title></title>
</head>
<style type="text/css">
	html {
		overflow-x: hidden;
		width: 100%;
		height: 100%;
		scrollbar-base-color: #d6e4ef;;
	}

	body {
		overflow-x: hidden;
		margin: 0px;
		background-color: #2f4050;
		color: #a7b1c2;
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
		color: #2d52a5;
		text-decoration: none;
	}

	img {
		border: 0px;
	}
	.topdTreeNode{
		display: none;
	}
</style>
<link rel="StyleSheet" href="<%=contextPath%>/resources/js/dtree/dtree.css" type="text/css" />
<SCRIPT src="<%=contextPath%>/resources/js/dtree/dtree.js"  type=text/javascript></SCRIPT>
<SCRIPT type=text/javascript>
	<!--
	var d = new dTree('d');
	d.add(0,-1,'功能模块</a>','javascript:location.reload();void(0);','功能模块','_self');
	<%
		int menuIndex = 0;	
		ModuleManager moduleManager = new ModuleManager();
		ACLManager aclManager = ACLManagerFactory.getACLManager();
		ArrayList menuList = (ArrayList) moduleManager.getUserMenuInfoList(idsStr);
		int menuParentNodeId = 0;
		int viewParentNodeId = 0;
		for (int menuTypeIndex = 0; menuTypeIndex < menuList.size(); menuTypeIndex++) {
			ModuleMenu moduleMenu = (ModuleMenu) menuList.get(menuTypeIndex);
			String menuName = moduleMenu.getMenuName();
			String menuLink = moduleMenu.getMenuLink();
	%>
	d.add(<%=menuIndex+1%>,0,'<%=menuName%>','javascript:d.o(<%=menuIndex+1%>);void(0);','<%=menuName%>','','','',false);
	<%
			menuIndex++;
			menuParentNodeId = menuIndex;
			ArrayList submenuList = (ArrayList) moduleMenu.getSubMenuList();
			for (int j = 0; j < submenuList.size(); j++) {
				ModuleMenu subModuleMenu = (ModuleMenu) submenuList.get(j);
				String submenuName = subModuleMenu.getMenuName();
				String submenuLink = subModuleMenu.getMenuLink();
				String submenuId = subModuleMenu.getModuleId();
	%>
	d.add(<%=menuIndex+1%>,<%=menuParentNodeId%>,'<%=submenuName%>','<%=contextPath%><%=submenuLink%>','<%=submenuName%>','content');
	<%
				menuIndex++;
				viewParentNodeId = menuIndex;
				ModuleViewManager moduleViewManager = new ModuleViewManager();
				ArrayList viewList = (ArrayList) moduleViewManager.getUserViewCollection(submenuId, userId);
				int viewCount = viewList.size();
				ModuleView moduleView = null;
				for (int ii = 0; ii < viewCount; ii++) {
					//moduleView = (ModuleView) viewList.get(ii);					

					//menuIndex++;
				}
			}
		}
	%>	
	//-->
</SCRIPT>
<body>
<DIV style="margin-left: 0px;">
	<TABLE border=0 cellPadding=0 cellSpacing=0 width="100%">
		<TBODY>
		<TR>
			<TD bgColor=#293846  align=left nowrap>
				<div class="dtree">
					<script type="text/javascript">
						<!--
						//d.add(12,0,'Recycle Bin','example01.html','','','img/trash.gif');
						//d.config.target = 'content';
						//d.config.useStatusText = true;
						//d.config.closeSameLevel = false;
						//target String true Target for all the nodes. 
						//folderLinks Boolean true Should folders be links. 
						//useSelection Boolean true Nodes can be selected(highlighted). 
						//useCookies Boolean true The tree uses cookies to rember it's state. 
						//useLines Boolean true Tree is drawn with lines. 
						//useIcons Boolean true Tree is drawn with icons. 
						//useStatusText Boolean false Displays node names in the statusbar instead of the url. 
						//closeSameLevel Boolean false Only one node within a parent can be expanded at the same time. openAll() and closeAll() functions do not work when this is enabled. 
						//inOrder Boolean false If parent nodes are always added before children, setting this to true speeds up the tree. 
						d.config.folderLinks = true;
						d.config.useSelection = true;
						d.config.useCookies = true;
						d.config.useLines = true;
						d.config.useIcons = true;
						d.config.useStatusText = false;
						d.config.inOrder = true;
						document.write(d);
						if(!d.isOpen(1))
						{
							d.o(1);
						}
						//d.openAll();
						//-->
					</script>
				</div>
			</TD>
		</TR>
		</TBODY>
	</TABLE>
</DIV>
<script type="text/javascript" src="jquery.min.js"></script>
<script type="text/javascript">
  var urlstr = location.href;
  //alert((urlstr + '/').indexOf($(this).attr('href')));
  var urlstatus=false;
  $("#dd0 a").each(function () {
    if ((urlstr + '/').indexOf($(this).attr('href')) > -1&&$(this).attr('href')!='') {
      $(this).addClass('cur'); urlstatus = true;
    } else {
      $(this).removeClass('cur');
    }
  });
  if (!urlstatus) {$("#dd0 a").eq(0).addClass('cur'); }

</script>
</body>
</html>
<!--索思奇智版权所有-->