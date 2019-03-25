<%@page language="java" contentType="text/html;charset=UTF-8" %>

<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.commons.util.StringHelper" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleAction" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleActionManager" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleView" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleViewManager" %>
<%@page import="java.util.ArrayList" %>

<%@taglib prefix="oa" uri="/WEB-INF/oa.tld" %>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<%@taglib prefix="html" uri="/WEB-INF/struts-html.tld" %>
<%
	String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
	User userInfo = (User) session.getAttribute("userInfo");
	if (userInfo == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
		return;
	} 
	String templatename = (String) session.getAttribute("templatename");
	String template = "/resources/template/" + templatename + "/template.jsp";
%>
<template:insert template="<%=template%>">
<template:put name='title' content='收文办理' direct='true'/>
<%String str = "<a class=\"menucur\" href=\"\">收文办理</a>";%>
<template:put name='moduleNav' content='<%=str%>' direct='true'/>
<template:put name='content'>

<script language="javascript" src="<%=request.getContextPath()%>/resources/js/view/commons.js"></script>
<%//页面初始化
	String moduleID = null;

	String userID = userInfo.getUserId();
	Group groupInfo = userInfo.getGroup();
	String groupID = groupInfo.getGroupId();

	String idsStr = userID;
	String viewID = (String) request.getParameter("viewid");

	String moduleIDs = "supgetdoc";
	String moduleTitles = null;
	request.getSession().setAttribute("moduleId", moduleIDs);
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
	pageContext.setAttribute("curPage", String.valueOf(curPage));%>

<%int k = 0;
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
				viewLinkList.append("<table width=\"126\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\"><tr><td>" + moduleTitleList[idx] + "</td></tr></table>");%>

<%}
	for (int i = 0; i < viewCount; i++) {
		ModuleView moduleView = (ModuleView) viewList.get(i);
		if (moduleView.getViewID().equals(viewID)) {
			moduleID = moduleView.getModuleID();
			curView = moduleView;
		}
		viewLinkList.append("<table width=\"188\" height=\"24\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\"  class=\"" + (moduleView.getViewID().equals(viewID) ? "table2" : "table1") + "\"> " + "<tr><td align=\"center\">" + "<a hidefocus href=\"" + moduleView.getViewURL() + ((moduleView.getViewURL().indexOf("?") > -1) ? "&" : "?") + "viewid=" + moduleView.getViewID() + "\">" + moduleView.getViewName() + "</a>" + "</td></tr></table>");
	}
}
}%>

<table border="0" class="main_table" width="100%" cellpadding="0" cellspacing="0">
	<tr class="main_row">
		<td class="mid_col" valign="top">
			<table border="0" width="100%" class="content" cellpadding="0" cellspacing="0">
				<!--search-->
				<tr style="display:inline">
					<td>
						<table width="576" border="0" cellpadding="0" cellspacing="0">
							<!--
											  <tr style="display:inline" id="fastSearch">
												<td height="36" align="center" background="<%=request.getContextPath()%>/resources/theme/images/xt_searchbg2.jpg">
												<table width="529" height="33" border="0" cellpadding="0" cellspacing="0">
													<tr>
													  <td width=446>&nbsp;</td>
													  <td width="31"><img src="<%=request.getContextPath()%>/resources/theme/images/xt_icon.gif" width="29" height="30"></td>
													  <td width="52" class="red"><div style="cursor:hand" onclick="advSearch()">全文检索</div></td>
													</tr>
												  </table>
												</td>
											  </tr>
											 -->
							<tr style="display:none" id="advSearch">
								<td align="center" background="<%=request.getContextPath()%>/resources/theme/images/xt_searchbg2.jpg">
									<br>
									<%if (curView != null) {
										String searchConfig = curView.getViewSearch();
										pageContext.setAttribute("searchConfig", searchConfig);
									}%>
									<oa:showSearch moduleid="datalink" format="{pageContext.searchConfig}"/>
								</td>
							</tr>
							<tr>
								<td></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			<table class="view_table" height="444" border="0" cellpadding="0" cellspacing="0" background="<%=request.getContextPath()%>/resources/theme/images/xt_leftbg.jpg">
				<tr>
					<td height="444" align="center" valign="top">
						<!--View Content-->
						<table class="view_content_table" height="410" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td class="view_action_table" height="37" align="right">
									<!--action-->
									<%

										ModuleActionManager moduleActionManager = new ModuleActionManager();
										ArrayList actionsList = (ArrayList) moduleActionManager.getUserActionList(moduleIDs, idsStr);

										for (int i = 0; i < actionsList.size(); i++) {
											ModuleAction moduleAction = (ModuleAction) actionsList.get(i);
											if (moduleAction.getActionImgURL() == null || "".equals(moduleAction.getActionImgURL())) {%>
									<a class="viewbutton" hidefocus href="<%=moduleAction.getActionURL()%>"><span><%=moduleAction.getActionName()%></span></a>
									<%} else {%>
									<input type="image" src="<%=moduleAction.getActionImgURL()%>" onclick="<%=moduleAction.getActionURL()%>" title="<%=moduleAction.getActionName()%>">
									<%}
									}%>
									<!--action-->
								</td>
							</tr>
							<tr>
								<td align="center" valign="top">
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
		</td>
		<!-- Other Link-->
		<td class="right_col" valign="top">
			
			<table class="view_right_table" height="405" border="0" cellpadding="0" cellspacing="0">
				<tr>
					
					<td height="405" align="right" valign="top" background="<%=request.getContextPath()%>/resources/theme/images/xt_rightbg.jpg">
						<table class="view_right_link_table" height="400" border="0" cellpadding="0" cellspacing="0" background="<%=request.getContextPath()%>/resources/theme/images/xt_rightbg2.jpg">
							<tr>
								<td height="400" valign="top">
									<table class="view_right_pic_table" border="0" cellspacing="0" cellpadding="0">
										<tr>
										<td style="height:122px;width:191px;" align="right" valign="top" background="<%=request.getContextPath()%>/resources/theme/images/xt_pic.jpg"></td>
											<td></td>
										</tr>
									</table>
									<!--view link start-->
									<%out.print(viewLinkList.toString());%>

									<!--view link start-->
								</td>
							</tr>
						</table>
						<table class="view_right_pic_table" border="0" cellspacing="0" cellpadding="0">
							<tr>

								<td>
									<img class="view_right_pic" src="<%=request.getContextPath()%>/resources/theme/images/xt_right.jpg" height="38">
								</td>

							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</template:put>
</template:insert>
<div style="display:none">
	<jsp:include page="/resources/jsp/search1.jsp"/>
<!--索思奇智版权所有-->
