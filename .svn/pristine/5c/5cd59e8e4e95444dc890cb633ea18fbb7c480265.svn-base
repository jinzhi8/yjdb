<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.commons.db.ConnectionProvider" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.commons.util.StringHelper" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleAction" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleActionManager" %>
<%@page import="java.sql.Connection" %>
<%@page import="java.sql.PreparedStatement" %>
<%@page import="java.util.ArrayList" %>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<%@taglib prefix="html" uri="/WEB-INF/oa-html.tld" %>
<%@taglib prefix="oa" uri="/WEB-INF/oa.tld" %>
<% //用户登陆验证
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
		//response.sendRedirect(request.getContextPath() + "/login.jsp");
		return;
	}
	String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
	User userInfo = (User) session.getAttribute("userInfo");
	String userID = userInfo.getUserId();
	//Group groupInfo = userInfo.getGroup();
	//String groupID = groupInfo.getGroupId();
	String idsStr = userID;
	String moduleID = "systemlog";
	ModuleActionManager moduleActionManager = new ModuleActionManager();
	ArrayList actionsList = (ArrayList) moduleActionManager.getUserActionList(moduleID, idsStr);
	boolean allowed = false;
	for (int i = 0; i < actionsList.size(); i++) {
		ModuleAction moduleAction = (ModuleAction) actionsList.get(i);
		if (moduleAction.getActionURL().equals(request.getRequestURI().substring(request.getRequestURI().lastIndexOf("/") + 1))) {
			allowed = true;
		}
	}
	if (!allowed) {
		response.sendRedirect(request.getContextPath() + "/" + moduleID);
		//request.getRequestDispatcher("/"+moduleID).forward(request,response);        
	}%>
<%String action = StringHelper.isNull(request.getParameter("action")) ? "" : request.getParameter("action");
	if ("delete".equals(action)) {
		String getUserName = StringHelper.isNull(request.getParameter("username")) ? "" : request.getParameter("username");
		String getDepName = StringHelper.isNull(request.getParameter("depname")) ? "" : request.getParameter("depname");
		String getClientIP = StringHelper.isNull(request.getParameter("clientip")) ? "" : request.getParameter("clientip");
		String getModuleID = StringHelper.isNull(request.getParameter("moduleid")) ? "" : request.getParameter("moduleid");
		String getDocID = StringHelper.isNull(request.getParameter("docid")) ? "" : request.getParameter("docid");
		String getTitle = StringHelper.isNull(request.getParameter("title")) ? "" : request.getParameter("title");
		String getActivity = StringHelper.isNull(request.getParameter("activity")) ? "" : request.getParameter("activity");
		String getStartDate = StringHelper.isNull(request.getParameter("startdate")) ? "" : request.getParameter("startdate");
		String getStartHour = StringHelper.isNull(request.getParameter("starthour")) ? "" : request.getParameter("starthour");
		String getStartMinute = StringHelper.isNull(request.getParameter("startminute")) ? "" : request.getParameter("startminute");
		String getStartSecond = StringHelper.isNull(request.getParameter("startsecond")) ? "" : request.getParameter("startsecond");
		String getEndDate = StringHelper.isNull(request.getParameter("enddate")) ? "" : request.getParameter("enddate");
		String getEndHour = StringHelper.isNull(request.getParameter("endhour")) ? "" : request.getParameter("endhour");
		String getEndMinute = StringHelper.isNull(request.getParameter("endminute")) ? "" : request.getParameter("endminute");
		String getEndSecond = StringHelper.isNull(request.getParameter("endsecond")) ? "" : request.getParameter("endsecond");

		String timeFirst = getStartDate + " " + getStartHour + ":" + getStartMinute + ":" + getStartSecond;
		String timeLast = getEndDate + " " + getEndHour + ":" + getEndMinute + ":" + getEndSecond;
		int ret = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		try {
			conn = ConnectionProvider.getConnection();
			StringBuffer sql = new StringBuffer();
			sql.append("delete from activitylog");
			sql.append(" where (acttime between to_date('" + timeFirst + "','yyyy-mm-dd hh24-mi-ss') and to_date('" + timeLast + "','yyyy-mm-dd hh24-mi-ss'))");
			if (!StringHelper.isNull(getUserName)) {
				sql.append(" and username like '%" + getUserName + "%'");
			}
			if (!StringHelper.isNull(getDepName)) {
				sql.append(" and department like '%" + getDepName + "%'");
			}
			if (!StringHelper.isNull(getClientIP)) {
				sql.append(" and clientip like '%" + getClientIP + "%'");
			}
			if (!StringHelper.isNull(getModuleID)) {
				sql.append(" and moduleid like '%" + getModuleID + "%'");
			}
			if (!StringHelper.isNull(getDocID)) {
				sql.append(" and docid like '%" + getDocID + "%'");
			}
			if (!StringHelper.isNull(getTitle)) {
				sql.append(" and title like '%" + getTitle + "%'");
			}
			if (!StringHelper.isNull(getActivity)) {
				sql.append(" and activity like '%" + getActivity + "%'");
			}
			pstmt = conn.prepareStatement(sql.toString());
			ret = pstmt.executeUpdate();
			conn.commit();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			ConnectionProvider.close(conn, pstmt);
		}
		response.sendRedirect(request.getContextPath() + "/" + moduleID);
	} else {%>
<%
String userTemplateName = (String) session.getAttribute("templatename");
String userTemplateStr = "/resources/template/" + userTemplateName + "/template.jsp";
if(userTemplateName==null||"".equals(userTemplateName)){
	userTemplateStr = "/resources/jsp/template.jsp";
}
%>
<template:insert template="<%=userTemplateStr%>">
	<template:put name='title' content='删除用户操作日志' direct='true'/>
	<%String str = "<a class=\"menucur\" href=\"\">用户操作日志</a>"; %>
	<template:put name='moduleNav' content='<%=str%>' direct='true'/>
	<template:put name='content'>
		<script language="javascript" src="<%=request.getContextPath()%>/resources/js/calendar.js"></script>
		<script>
			function getDateValue() {
				var doc = document.forms[0];
			<%
				  String DateFirst;
				String DateLast;
				String TimeValue;
				int YearInt = new java.util.Date().getYear()+1900;
				int MonthInt = new java.util.Date().getMonth()+1;
				int DateInt = new java.util.Date().getDate()+1;
				if(new Integer(MonthInt).toString().length()==1){
					  TimeValue = new Integer(YearInt).toString() + "-0" + new Integer(MonthInt).toString();
				}
				else{
					  TimeValue = new Integer(YearInt).toString() + "-" + new Integer(MonthInt).toString();
				}
				if(new Integer(DateInt).toString().length()==1){
					  DateFirst = "-0" + (DateInt-1);
					DateLast = "-0" + (DateInt-1);
				}
				else{
					DateFirst = ""+ (DateInt-1);
					DateLast = ""+ (DateInt-1);
				}
				out.println("doc.startdate.value=\'" + TimeValue + "-"+DateFirst+"\';");
				if(MonthInt==2){
					  out.println("doc.enddate.value=\'"+TimeValue+"-"+DateLast+"\';");
				}
				else{
					  out.println("doc.enddate.value=\'"+TimeValue+"-"+DateLast+"\';");
				}
			 %>
				doc.endhour.options.selectedIndex = 23;
				doc.endminute.options.selectedIndex = 59;
				doc.endsecond.options.selectedIndex = 59;
			}
		</script>
		<script language="javascript" src="<%=contextPath%>/resources/js/search.js"></script>
		<BODY onLoad="getDateValue()">
		<table border="0" align="center" cellpadding="0" cellspacing="0" class="round">
			<tr>
				<td align="center">
					<FORM method="post" action="activitydel.jsp" onsubmit="disablebutton(true);">
						<table class="searchview" width="400px" cellpadding="0" cellspacing="0">
							<tr>
								<td class="searchFormTitle" colspan="4" style="background-color:#A5CDF0" align="center">
									<strong>删除操作记录</strong>
								</td>
							</tr>
							<tr bgcolor="#FFFFFF">
								<td width="80px">用户姓名</td>
								<td width="120px"><input class="input_line" name="username" value=""></td>
								<td width="80px">部门名称</td>
								<td width="120px"><input class="input_line" name="depname" value=""></td>
							</tr>
							<tr bgcolor="#FFFFFF">
								<td width="80px">模块ID</td>
								<td width="120px"><input class="input_line" name="moduleid" value=""></td>
								<td width="80px">文档ID</td>
								<td width="120px"><input class="input_line" name="docid" value=""></td>
							</tr>
							<tr bgcolor="#FFFFFF">
								<td width="80px">IP地址</td>
								<td width="120px"><input class="input_line" name="clientip" value=""></td>
								<td width="80px">操作类型</td>
								<td width="120px"><select name="activity">
									<option value="" selected>选择类型...</option>
									<option value="insert">新增</option>
									<option value="update">修改</option>
									<option value="delete">删除</option>
								</select></td>
							</tr>
							<tr bgcolor="#FFFFFF">
								<td width="80px">文档标题</td>
								<td width="320px" colspan="3"><input class="input_line2" name="title" value=""></td>
							</tr>
							<% StringBuffer ehiStr = new StringBuffer();
								for (int ehi = 0; ehi < 24; ehi++) {
									if (new Integer(ehi).toString().length() == 1) {
										ehiStr.append("<option value=\"0" + ehi + "\">0" + ehi + "</option>");
									} else {
										ehiStr.append("<option value=\"" + ehi + "\">" + ehi + "</option>");
									}
								}
								StringBuffer emiStr = new StringBuffer();
								for (int emi = 0; emi < 60; emi++) {
									if (new Integer(emi).toString().length() == 1) {
										emiStr.append("<option value=\"0" + emi + "\">0" + emi + "</option>");
									} else {
										emiStr.append("<option value=\"" + emi + "\">" + emi + "</option>");
									}
								}%>
							<tr bgcolor="#FFFFFF">
								<td width="80px">开始时间</td>
								<td colspan="3">
									<input class="input_line" name="startdate" value="2006-04-07" onclick="opencurCalendar(this)" readonly>
									<select name="starthour" style="width:40"><%=ehiStr.toString()%>
									</select>时
									<select name="startminute" style="width:40"><%=emiStr.toString()%>
									</select>分
									<select name="startsecond" style="width:40"><%=emiStr.toString()%>
									</select>秒
								</td>
							</tr>
							<tr>
								<td width="80px">结束时间</td>
								<td colspan="3">
									<input class="input_line" name="enddate" value="2006-04-14" onclick="opencurCalendar(this)" readonly>
									<select name="endhour" style="width:40"><%=ehiStr.toString()%>
									</select>时
									<select name="endminute" style="width:40"><%=emiStr.toString()%>
									</select>分
									<select name="endsecond" style="width:40"><%=emiStr.toString()%>
									</select>秒
								</td>
							</tr>
							<tr bgcolor="#FFFFFF">
								<td colspan=4 align="center">
									<input class="searchbutton" type="submit" onclick="" value="删除">&nbsp;
									<input onclick="location.href='index.jsp'" class="searchbutton" type="button" value="取消">
								</td>
							</tr>
						</table>
						<input type="hidden" name="action" value="delete">
					</FORM>
				</td>
			</tr>
		</table>
		</BODY>
	</template:put>
</template:insert>
<%}%>
<!--索思奇智版权所有-->