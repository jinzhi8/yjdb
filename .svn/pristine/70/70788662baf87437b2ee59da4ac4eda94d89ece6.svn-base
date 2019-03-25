<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.commons.user.User,com.kizsoft.commons.commons.util.ReadInfo,com.kizsoft.commons.commons.util.ReadInfoManager,
                java.text.SimpleDateFormat,
                java.util.ArrayList" %>
<%@page import="java.util.Date" %>
<% 
	String id = request.getParameter("id");
 %>				
 <br>
<table border="0" align="center" cellpadding="0" cellspacing="0" class="round">
	<b>阅读情况</b>
	<tr>
		<td align=center class="deeptd">部门名称</td>
		<td align=center class="deeptd">阅读人</td>
		<td align=center class="deeptd">阅读时间</td>
	</tr>
	<%ReadInfoManager readInfoManager = new ReadInfoManager();
		ArrayList readInfoList = (ArrayList) readInfoManager.getAllReadInfoByUnid(id);
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		StringBuffer readInfoBuff = new StringBuffer();

		for (int i = 0; i < readInfoList.size(); i++) {
			ReadInfo readInfo = (ReadInfo) readInfoList.get(i);
			//String readDepartmentID = readInfo.getReadDepartmentID();
			//String readManID = readInfo.getReadManID();
			String readDepartmentName = readInfo.getReadDepartmentName();
			String readManName = readInfo.getReadManName();
			Date readTime = readInfo.getReadTime();
			String strReadTime = format.format(readTime);
			readInfoBuff = readInfoBuff.append("<tr><td align=center class=\"tinttd\">" + readDepartmentName + "</td><td align=center class=\"tinttd\">" + readManName + "</td><td align=center class=\"tinttd\">" + strReadTime + "</td></tr>");
		}
		out.print(readInfoBuff.toString());%>
</table><!--索思奇智版权所有-->