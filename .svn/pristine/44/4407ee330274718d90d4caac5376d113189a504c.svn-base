<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="java.util.ArrayList" %>

<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<%@taglib prefix="html" uri="/WEB-INF/struts-html.tld" %>
<%@taglib prefix="bean" uri="/WEB-INF/struts-bean.tld" %>


<link href="<%=request.getContextPath()%>/resources/css/css.css" rel="stylesheet" type="text/css">
<link href="<%=request.getContextPath()%>/resources/css/switch.css" rel="stylesheet" type="text/css">

<table width="100%">
	<tr>
		<td class="content">
			<html:form action="formModuleAction">

				<bean:define id="moduleUNID" property="moduleUNID" name="moduleInfoForm"/>
				<bean:define id="roleList_1" property="roleList_1" name="moduleInfoForm"/>
				<bean:define id="roleList_2" property="roleList_2" name="moduleInfoForm"/>

				<jsp:include page="switchTitle.jsp">
					<jsp:param name="pageidx" value="3"/>
					<jsp:param name="unid" value="<%=(String)moduleUNID%>"/>
				</jsp:include>


				<!-- ******************* Part One **************** -->
				<table border='0' align='center' cellpadding='0' cellspacing='0' class='round'>
					<tr>
						<td class='title'>角 色 管 理</td>
					</tr>
					<tr>
						<td align='center'><BR>
							<table width='80%' border='0' cellpadding='0' cellspacing='0' class='table'>
								<tr>
									<td width='30%' bgcolor='#EAEAEA' class='deeptd'>
										<div align='center'>角色类型</div>
									</td>
									<td bgcolor='#EAEAEA' class='deeptd' width='10%'>
										<div align='center'>编号</div>
									</td>
									<td width='30%' bgcolor='#EAEAEA' class='deeptd'>
										<div align='center'>角色ID</div>
									</td>
									<td width='40%' bgcolor='#EAEAEA' class='deeptd'>
										<div align='center'>角色名称</div>
									</td>
								</tr>

								<%String tdBeg = "<td bgcolor='#EAEAEA' class='tinttd' > <div align='center'>";
									String tdEnd = "&nbsp;</div></td>";
									String imgStr = "<img src='" + request.getContextPath() + "/resources/images/icon03.gif' width='16' height='16' hspace='2' border='0'>";

									ArrayList arrList_1 = (ArrayList) roleList_1;
									String tabStr = "";
									for (int i = 0; i < arrList_1.size(); i++) {
										ModuleRoleInfo moduleRoleInfo = (ModuleRoleInfo) arrList_1.get(i);

										String linkBeg = "<a href='editModuleRoleAction.do?roleid=" + moduleRoleInfo.getRoleId() + "'>";
										String linkEnd = "</a>";

										if (i == 0) {
											tabStr += "<tr><td bgcolor='#EAEAEA' style='vertical-align:middle' class='tinttd' rowspan='" + arrList_1.size() + "'><div align='center' valign='middle'>" + moduleRoleInfo.getRoleType() + "</div></td>";
											tabStr += tdBeg + imgStr + (i + 1) + tdEnd;
										} else {
											tabStr += "<tr>" + tdBeg + imgStr + (i + 1) + tdEnd;
										}

										tabStr += tdBeg + linkBeg + (moduleRoleInfo.getRoleId() == null || "".equals(moduleRoleInfo.getRoleId()) ? "" : moduleRoleInfo.getRoleId()) + linkEnd + tdEnd;
										tabStr += tdBeg + linkBeg + (moduleRoleInfo.getRolename() == null || "".equals(moduleRoleInfo.getRolename()) ? "" : moduleRoleInfo.getRolename()) + linkEnd + tdEnd + "</tr>";

										moduleRoleInfo.getRoleTypeID();
									}
									out.print(tabStr);

									ArrayList arrList_2 = (ArrayList) roleList_2;
									tabStr = "";
									for (int i = 0; i < arrList_2.size(); i++) {
										ModuleRoleInfo moduleRoleInfo = (ModuleRoleInfo) arrList_2.get(i);

										if (i == 0) {
											tabStr += "<tr><td bgcolor='#EAEAEA' style='vertical-align:middle' class='tinttd' rowspan='" + arrList_2.size() + "'><div align='center'>" + moduleRoleInfo.getRoleType() + "</div></td>";
											tabStr += tdBeg + imgStr + (i + 1) + tdEnd;
										} else {
											tabStr += "<tr>" + tdBeg + imgStr + (i + 1) + tdEnd;
										}

										tabStr += tdBeg + ((moduleRoleInfo.getRoleId() == null || "".equals(moduleRoleInfo.getRoleId())) ? "&nbsp" : moduleRoleInfo.getRoleId()) + tdEnd;
										tabStr += tdBeg + ((moduleRoleInfo.getRolename() == null || "".equals(moduleRoleInfo.getRolename())) ? "&nbsp;" : moduleRoleInfo.getRolename()) + tdEnd + "</tr>";

										moduleRoleInfo.getRoleTypeID();
									}
									out.print(tabStr);%>


								<tr>
									<td colspan='4' class='tinttd'>
										<div align='center'>&nbsp;
											<!--<input type='button' class='button' value='返回' onclick='window.location=""'>-->
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