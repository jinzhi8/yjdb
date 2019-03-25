<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleConfig" %>
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
				<bean:define id="configList" property="configList" name="moduleInfoForm"/>

				<jsp:include page="switchTitle.jsp">
					<jsp:param name="pageidx" value="5"/>
					<jsp:param name="unid" value="<%=(String)moduleUNID%>"/>
				</jsp:include>


				<!-- ******************* Part One **************** -->
				<table border='0' align='center' cellpadding='0' cellspacing='0' class='round'>
					<tr>
						<td class='title'>配 置 管 理</td>
					</tr>
					<tr>
						<td align='center'>
							<BR>
							<table width='100%' border='0' cellpadding='0' cellspacing='0' class='table'>
								<tr>
									<td bgcolor='#EAEAEA' class='deeptd' width='10%'>
										<div align='center'>编号</div>
									</td>
									<td width='30%' bgcolor='#EAEAEA' class='deeptd'>
										<div align='center'>配置名称</div>
									</td>
									<td width='45%' bgcolor='#EAEAEA' class='deeptd'>
										<div align='center'>配置链接</div>
									</td>
									<td width='15%' bgcolor='#EAEAEA' class='deeptd'>
										<div align='center'>序号</div>
									</td>
								</tr>
								<%String tdBeg = "<td bgcolor='#EAEAEA' class='tinttd' style='word-break:break-all'> <div align='center'>";
									String tdEnd = "&nbsp;</div></td>";
									String imgStr = "<img src='" + request.getContextPath() + "/resources/images/icon03.gif' width='16' height='16' hspace='2' border='0'>";
									ArrayList moduleConfigList = (ArrayList) configList;

									for (int i = 0; i < moduleConfigList.size(); i++) {
										String tabStr = "";
										ModuleConfig moduleConfig = (ModuleConfig) moduleConfigList.get(i);

										String linkBeg = "<a href='editModuleConfigAction.do?configid=" + moduleConfig.getModule_config_id() + "'>";
										String linkEnd = "</a>";

										tabStr += tdBeg + imgStr + (i + 1) + tdEnd;
										tabStr += tdBeg + linkBeg + (moduleConfig.getConfig_name() == null ? "" : moduleConfig.getConfig_name()) + linkEnd + tdEnd;
										tabStr += tdBeg + linkBeg + (moduleConfig.getConfig_path() == null ? "" : moduleConfig.getConfig_path()) + linkEnd + tdEnd;
										tabStr += tdBeg + linkBeg + (moduleConfig.getConfig_order() == null ? "" : moduleConfig.getConfig_order()) + linkEnd + tdEnd;
										out.println("<tr>" + tabStr + "</tr>");
									}%>
								<tr>
									<td colspan='4' class='tinttd'>
										<div align='center'>&nbsp;
											<input type='button' class='button' value='增加' onclick="window.location='editModuleConfigAction.do?moduleid=<%=moduleID%>'">
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