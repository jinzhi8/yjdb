<!--Generated by Weblogic Workshop-->
<%@page language="java" contentType="text/html;charset=UTF-8" %>

<%@page import="com.kizsoft.commons.commons.user.User,com.kizsoft.commons.commons.util.ReadInfo,com.kizsoft.commons.commons.util.ReadInfoManager,
                java.text.SimpleDateFormat,
                java.util.ArrayList" %>
<%@page import="java.util.Date" %>

<% String id = request.getParameter("id");
	User userInfo = (User) request.getSession().getAttribute("userInfo");
	String userID = userInfo.getUserId();
	String groupID = userInfo.getGroup().getGroupId();

	boolean readFlag = false; %>				<br>
<table border="0" align="center" cellpadding="0" cellspacing="0" class="round">
	<b>阅读情况</b>
	<tr>
		<td align=center class="deeptd">部门名称</td>
		<td align=center class="deeptd">阅读人</td>
		<td align=center class="deeptd">阅读时间</td>
	</tr>
	<%ReadInfoManager readInfoManager = new ReadInfoManager();

		//readFlag = readInfoManager.getReadInfoFlag(id,userID,groupID); //单位和个人
		readFlag = readInfoManager.getReadInfoFlag_User(id, userID, groupID); //个人

		if (!readFlag) {
			ReadInfo readInfo = new ReadInfo();
			readInfo.setId(id);
			readInfo.setReadDepartmentID(groupID);
			readInfo.setReadManID(userID);
			readInfo.setReadTime(new Date());
			readInfoManager.addReadInfo(readInfo);
		}

		ArrayList readInfoList = (ArrayList) readInfoManager.getAllReadInfoByUnid(id);
		for (int i = 0; i < readInfoList.size(); i++) {
			ReadInfo readInfo = (ReadInfo) readInfoList.get(i);
			String readDepartmentID = readInfo.getReadDepartmentID();
			String readManID = readInfo.getReadManID();
			String readDepartmentName = readInfo.getReadDepartmentName();
			String readManName = readInfo.getReadManName();
			Date readTime = readInfo.getReadTime();
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm");
			String strReadTime = format.format(readTime);%>
	<tr>
		<td align=center class="tinttd"><%=readDepartmentName%>
		</td>
		<td align=center class="tinttd"><%=readManName%>
		</td>
		<td align=center class="tinttd"><%=strReadTime%>
		</td>
	</tr>
	<% }%>
</table><!--索思奇智版权所有-->