 <%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleAction" %>
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
				<bean:define id="actionList" property="actionList" name="moduleInfoForm"/>

				<jsp:include page="switchTitle.jsp">
					<jsp:param name="pageidx" value="4"/>
					<jsp:param name="unid" value="<%=(String)moduleUNID%>"/>
				</jsp:include>


				<!-- ******************* Part One **************** -->
				<table border='0' align='center' cellpadding='0' cellspacing='0' class='round'>
					<tr>
						<td class='title'>操作管理</td>
					</tr>
					<tr>
						<td align='center'>
							<BR>
							<table width='100%' border='0' cellpadding='0' cellspacing='0' class='table'>
								<tr>
									<td bgcolor='#EAEAEA' class='deeptd' width='10%'>
										<div align='center'>编号</div>
									</td>
									<td width='20%' bgcolor='#EAEAEA' class='deeptd'>
										<div align='center'>操作名称</div>
									</td>
									<td width='40%' bgcolor='#EAEAEA' class='deeptd'>
										<div align='center'>操作链接</div>
									</td>
									<td width='30%' bgcolor='#EAEAEA' class='deeptd'>
										<div align='center'>使用范围</div>
									</td>
								</tr>
								<%
									String tdBeg = "<td bgcolor='#EAEAEA' class='tinttd' style='word-break:break-all'> <div align='center'>";
									String tdEnd = "&nbsp;</div></td>";
									String imgStr = "<img src='" + request.getContextPath() + "/resources/images/icon03.gif' width='16' height='16' hspace='2' border='0'>";
									ArrayList moduleActionList = (ArrayList) actionList;

									for (int i = 0; i < moduleActionList.size(); i++) {
										String tabStr = "";
										ModuleAction action = (ModuleAction) moduleActionList.get(i);

										String linkBeg = "<a href='editModuleActionAction.do?actionid=" + action.getActionID() + "'>";
										String linkEnd = "</a>";

										tabStr += tdBeg + imgStr + action.getActionOrder() + tdEnd;
										tabStr += tdBeg + linkBeg + (action.getActionName() == null || "".equals(action.getActionName()) ? "" : action.getActionName()) + linkEnd + tdEnd;
										tabStr += tdBeg + linkBeg + (action.getActionURL() == null || "".equals(action.getActionURL()) ? "" : action.getActionURL()) + linkEnd + tdEnd;
										tabStr += tdBeg + linkBeg + (action.getActionPurview_cn() == null || "".equals(action.getActionPurview_cn()) ? "" : action.getActionPurview_cn()) + linkEnd + tdEnd;
										out.println("<tr>" + tabStr + "</tr>");
									}
								%>
								<tr>
									<td colspan='4' class='tinttd'>
										<div align='center'>&nbsp;
											<input type='button' class='button' value='增加' onclick="window.location='editModuleActionAction.do?moduleid=<%=moduleID%>'">
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
							<html:text property="action" value="define"/>
						</td>
					</tr>
				</table>
			</html:form>
		</td>
	</tr>
</table>
<!--索思奇智版权所有-->