<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/xml; charset=UTF-8" language="java" %>
<%@page import="com.kizsoft.commons.acl.ACLManager" %>
<%@page import="com.kizsoft.commons.acl.ACLManagerFactory" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleManager" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleMenu" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleView" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleViewManager" %>
<%@page import="java.util.ArrayList" %>

<menus>
	<%
		if (session.getAttribute("userInfo") == null) {
			response.sendRedirect(request.getContextPath() + "/login.jsp");
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
	<folders foldersName="<%=menuName%>">
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
		<folder folderName="<%=submenuName%>" menuUrl="<%=contextPath%><%=submenuLink%>">
			<%
				menuIndex++;
				viewParentNodeId = menuIndex;
				ModuleViewManager moduleViewManager = new ModuleViewManager();
				ArrayList viewList = (ArrayList) moduleViewManager.getUserViewCollection(submenuId, userId);
				int viewCount = viewList.size();
				ModuleView moduleView = null;
				for (int ii = 0; ii < viewCount; ii++) {
					moduleView = (ModuleView) viewList.get(ii);
			%>
			<menu menuName="<%=moduleView.getViewName()%>" menuUrl="<%=contextPath%>/<%=subModuleMenu.getModuleId()%>/<%=moduleView.getViewURL()%><%=((moduleView.getViewURL().indexOf("?") > -1)? "&amp;":"?")%>viewid=<%=moduleView.getViewID()%>"/>

			<%
					menuIndex++;
				}
			%>
		</folder>
		<%
			}
		%>
	</folders>
	<%
		}
	%>
</menus>
<!--索思奇智版权所有-->