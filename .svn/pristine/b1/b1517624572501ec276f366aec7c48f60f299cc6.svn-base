<%@page language="java" contentType="text/html;charset=UTF-8" %>

<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.commons.util.StringHelper" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleInfo" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleManager" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleAction" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleActionManager" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleView" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleViewManager" %>
<%@page import="java.util.ArrayList" %>

<%@taglib prefix="oa" uri="/WEB-INF/oa.tld" %>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<%@taglib prefix="html" uri="/WEB-INF/struts-html.tld" %>
<%
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
		return;
	}
%>

<%
String userTemplateName = (String) session.getAttribute("templatename");
String templatestr = "/resources/template/" + userTemplateName + "/indextemplate.jsp";
if(userTemplateName==null||"".equals(userTemplateName)){
	templatestr = "/resources/jsp/template.jsp";
}
%>

<%//用户登陆验证
	User userInfo = (User) session.getAttribute("userInfo");
	String moduleID = null;
	String userID = userInfo.getUserId();
	Group groupInfo = userInfo.getGroup();
	String groupID = groupInfo.getGroupId();
	String idsStr = userID;
	
	String viewID = (String) request.getParameter("viewid");
	String moduleIDs = "zwdb";
	String moduleTitles = null;

	//String moduleIDs = (String)request.getAttribute("moduleIDs");
	//String moduleTitles = (String)request.getAttribute("moduleTitles");


	String[] moduleIDList = StringHelper.split(moduleIDs, ",");
	String[] moduleTitleList = moduleTitles == null || "".equals(moduleTitles) ? null : StringHelper.split(moduleTitles, ",");

	String viewDefine = "";
	String viewSearch = "";
	StringBuffer viewLinkList = new StringBuffer();
	boolean isUserView = false;
	ModuleView defaultView = null;
	ModuleView curView = null;

	ModuleManager moduleManager = new ModuleManager();
	String curModuleName = moduleManager.getModuleInfo(moduleIDs).getModuleName();
	ModuleViewManager moduleViewManager = new ModuleViewManager();
	isUserView = moduleViewManager.isUserView(moduleIDs, viewID, idsStr);
	//视图初始化
	int curPage = 1;
	int rowsPerPage = 10;
	if (request.getParameter("page") != null && !request.getParameter("page").equals("")) {
		curPage = Integer.parseInt(request.getParameter("page"));
	} else {
		curPage = 1;
	}
	pageContext.setAttribute("curPage", String.valueOf(curPage));

	int k = 0;
	for (int idx = 0; idx < moduleIDList.length; idx++) {
		ArrayList viewList = (ArrayList) moduleViewManager.getUserViewCollection(moduleIDList[idx], idsStr);
		int viewCount = viewList.size();
		if (viewCount > 0) {
			if (k == 0 && !isUserView) {
				defaultView = moduleViewManager.getUserDefaultViewInfo(moduleIDList[idx], idsStr);
				viewID = defaultView.getViewID();
			}
			k++;

			if (moduleTitleList != null && idx < moduleTitleList.length) {
				viewLinkList.append("<table width=\"126\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\"><tr><td>" + moduleTitleList[idx] + "</td></tr></table>");
			}
			for (int i = 0; i < viewCount; i++) {
				ModuleView moduleView = (ModuleView) viewList.get(i);
				if (moduleView.getViewID().equals(viewID)) {
					moduleID = moduleView.getModuleID();
					curView = moduleView;
				}
				viewLinkList.append("<table width=\"188\" height=\"24\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\"  class=\"" + (moduleView.getViewID().equals(viewID) ? "table2" : "table1") + "\"> " + "<tr><td align=\"center\">" + "<a hidefocus href=\"" + moduleView.getViewURL() + "?viewid=" + moduleView.getViewID() + "\">" + moduleView.getViewName() + "</a>" + "</td></tr></table>");
			}
		}
	}
%>
<template:insert template="<%=templatestr%>">
	<template:put name='title' content='<%=curModuleName%>' direct='true'/>
	<%String str = "<a class='menucur' href=''>"+curModuleName+"</a> → <a class='menucur' href='"+curView.getViewURL()+"?viewid="+curView.getViewID()+"'>"+curView.getViewName()+"</a>";%>
	<template:put name='moduleNav' content='<%=str%>' direct='true'/>
	<template:put name='content'>
		<script language="javascript" src="<%=request.getContextPath()%>/resources/js/view/commons.js"></script>
		<script language="javascript" src="<%=request.getContextPath()%>/resources/js/workflow/selectflow.js"></script>

		

		<table border="0" class="main_table" width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td class="right_col" valign="top">
					<table class="view_right_table" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td align="right" valign="top">
								<table class="view_right_link_table xizeng_ys15" border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td valign="top" class="pad_left">
											<table class="view_right_pic_table" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td></td>
												</tr>
											</table>
											<%out.print(viewLinkList.toString());%>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr class="main_row">
				<td class="mid_col" valign="top">
						<table class="view_table" height="444" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td height="444" align="center" valign="top">
									<!--View Content-->
									<table class="view_content_table nypublic_table" height="410" border="0" cellpadding="0" cellspacing="0">
										<tr>
											<td align="center" valign="top">
											<div class="view_action_table zx_xz15btn" align="right">
												<!--action-->
												<%
													ModuleActionManager moduleActionManager = new ModuleActionManager();
													ArrayList actionsList = (ArrayList) moduleActionManager.getUserActionList(moduleID, idsStr);

													for (int i = 0; i < actionsList.size(); i++) {
														ModuleAction moduleAction = (ModuleAction) actionsList.get(i);
														if (moduleAction.getActionImgURL() == null || "".equals(moduleAction.getActionImgURL())) {%>
												<a class="viewbutton" hidefocus href="<%=moduleAction.getActionURL()%>"><span><%=moduleAction.getActionName()%></span></a>
												<%} else {%>
												<input type="image" src="<%=moduleAction.getActionImgURL()%>" onclick="<%=moduleAction.getActionURL()%>" title="<%=moduleAction.getActionName()%>">
												<%}
												}%>
											</div>
												<%if (curView != null) {
													String viewConfig = curView.getViewDefine();
													pageContext.setAttribute("viewConfig", viewConfig);
												}%>
												<oa:showview page="{pageContext.curPage}" format="{pageContext.viewConfig}"/>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</div>
				</td>
			</tr>
		</table>
	</template:put>
</template:insert>
<!--索思奇智版权所有-->