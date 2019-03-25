<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleView" %>
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
				<bean:define id="viewList" name="moduleInfoForm" property="viewList"/>
				<jsp:include page="switchTitle.jsp">
					<jsp:param name="pageidx" value="3"/>
					<jsp:param name="unid" value="<%=(String)moduleUNID%>"/>
				</jsp:include>

				<!-- ******************* Part One **************** -->
				<table border='0' align='center' cellpadding='0' cellspacing='0' class='round'>
					<tr>
						<td class='title'>视 图 管 理</td>
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
										<div align='center'>视图名称</div>
									</td>
									<td width='30%' bgcolor='#EAEAEA' class='deeptd'>
										<div align='center'>链接地址</div>
									</td>
									<td width='40%' bgcolor='#EAEAEA' class='deeptd'>
										<div align='center'>访问范围</div>
									</td>
								</tr>
								<%String tdBeg = "<td bgcolor='#EAEAEA' class='tinttd' ><div align='center'>";
									String tdEnd = "&nbsp;</div></td>";
									String imgStr = "<img src='" + request.getContextPath() + "/resources/images/icon03.gif' width='16' height='16' hspace='2' border='0'>";

									ArrayList moduleViewList = (ArrayList) viewList;

									for (int i = 0; i < moduleViewList.size(); i++) {
										String tabStr = "";
										ModuleView moduleView = (ModuleView) moduleViewList.get(i);

										String linkBeg = "<a href='editModuleViewAction.do?viewid=" + moduleView.getViewID() + "'>";
										String linkEnd = "</a>";

										tabStr += tdBeg + imgStr + moduleView.getViewOrder() + tdEnd;
										tabStr += tdBeg + linkBeg + (moduleView.getViewName() == null || "".equals(moduleView.getViewName()) ? "" : moduleView.getViewName()) + linkEnd + tdEnd;
										tabStr += tdBeg + linkBeg + (moduleView.getViewURL() == null || "".equals(moduleView.getViewURL()) ? "" : moduleView.getViewURL()) + linkEnd + tdEnd;
										tabStr += tdBeg + linkBeg + (moduleView.getViewPurview_cn() == null || "".equals(moduleView.getViewPurview_cn()) ? "" : moduleView.getViewPurview_cn()) + linkEnd + tdEnd;
										out.println("<tr>" + tabStr + "</tr>");
									}%>
								<tr>
									<td colspan='4' class='tinttd'>
										<div align='center'>&nbsp;
											<input type='button' class='button' value='增加' onclick="window.location='editModuleViewAction.do?moduleid=<%=moduleID%>'">
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