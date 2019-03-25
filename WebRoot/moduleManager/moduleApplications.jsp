<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleApplication" %>
<%@page import="java.util.ArrayList" %>

<%@taglib prefix="html" uri="/WEB-INF/struts-html.tld" %>
<%@taglib prefix="bean" uri="/WEB-INF/struts-bean.tld" %>

<link href="<%=request.getContextPath()%>/resources/css/css.css" rel="stylesheet" type="text/css">
<link href="<%=request.getContextPath()%>/resources/css/switch.css" rel="stylesheet" type="text/css">
<table width="100%">
	<tr>
		<td class="content">
			<html:form action="formModuleAction">

				<bean:define id="moduleUNID" property="moduleUNID" name="moduleInfoForm"/>
				<bean:define id="moduleID" property="moduleID" name="moduleInfoForm"/>
				<bean:define id="applicationList" name="moduleInfoForm" property="applicationList"/>
				<jsp:include page="switchTitle.jsp">
					<jsp:param name="pageidx" value="2"/>
					<jsp:param name="unid" value="<%=(String)moduleUNID%>"/>
				</jsp:include>

				<!-- ******************* Part One **************** -->
				<table border='0' align='center' cellpadding='0' cellspacing='0' class='round'>
					<tr>
						<td class='title'>应 用 管 理</td>
					</tr>
					<tr>
						<td align='center'>
							<BR>
							<table width='100%' border='0' cellpadding='0' cellspacing='0' class='table'>
								<tr>
									<td width='10%' bgcolor='#EAEAEA' class='deeptd'>
										<div align='center'>顺序</div>
									</td>
									<td width='30%' bgcolor='#EAEAEA' class='deeptd'>
										<div align='center'>应用名称</div>
									</td>
									<td width='30%' bgcolor='#EAEAEA' class='deeptd'>
										<div align='center'>应用入口</div>
									</td>
									<td width='40%' bgcolor='#EAEAEA' class='deeptd'>
										<div align='center'>访问范围</div>
									</td>
								</tr>
								<%String tdBeg = "<td bgcolor='#EAEAEA' class='tinttd' ><div align='center'>";
									String tdEnd = "&nbsp;</div></td>";
									String imgStr = "<img src='" + request.getContextPath() + "/resources/images/icon03.gif' width='16' height='16' hspace='2' border='0'>";

									ArrayList appList = (ArrayList) applicationList;

									for (int i = 0; i < appList.size(); i++) {
										String tabStr = "";
										ModuleApplication applicationInfo = (ModuleApplication) appList.get(i);

										String linkBeg = "<a href='editApplicationAction.do?appid=" + applicationInfo.getApplicationId() + "'>";
										String linkEnd = "</a>";

										tabStr += tdBeg + imgStr + (i + 1) + tdEnd;
										tabStr += tdBeg + linkBeg + (applicationInfo.getApplicationName() == null || "".equals(applicationInfo.getApplicationName()) ? "" : applicationInfo.getApplicationName()) + linkEnd + tdEnd;
										tabStr += tdBeg + linkBeg + (applicationInfo.getApplicationEntry() == null || "".equals(applicationInfo.getApplicationEntry()) ? "" : applicationInfo.getApplicationEntry()) + linkEnd + tdEnd;
										tabStr += tdBeg + linkBeg + (applicationInfo.getApplicationPurviewCn() == null || "".equals(applicationInfo.getApplicationPurviewCn()) ? "" : applicationInfo.getApplicationPurviewCn()) + linkEnd + tdEnd;
										out.println("<tr>" + tabStr + "</tr>");
									}%>
								<tr>
									<td colspan='4' class='tinttd'>
										<div align='center'>&nbsp;
											<input type='button' class='button' value='增加' onclick="window.location='editApplicationAction.do?moduleid=<%=moduleID%>'">
										</div>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td align='center'>&nbsp;</td>
					</tr>
				</table>
				<table style="display:none">
					<tr>
						<td>
							<html:text property="moduleUNID"/>
							<html:text property="action" value="applications"/>
						</td>
					</tr>
				</table>
			</html:form>
		</td>
	</tr>
</table>
<!--索思奇智版权所有-->