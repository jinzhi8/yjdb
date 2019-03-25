<%@page language="java" contentType="text/html;charset=UTF-8" %>

<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<%@taglib prefix="html" uri="/WEB-INF/struts-html.tld" %>
<%@taglib prefix="bean" uri="/WEB-INF/struts-bean.tld" %>


<link href="<%=request.getContextPath()%>/resources/css/css.css" rel="stylesheet" type="text/css">
<link href="<%=request.getContextPath()%>/resources/css/switch.css" rel="stylesheet" type="text/css">

<table width="100%">
	<tr>
		<td class="content">
			<html:form action="formModuleRoleAction">
				<%boolean isNew = false;%>
				<!-- ******************* Part One **************** -->
				<table border="0" align="center" cellpadding="0" cellspacing="0" class="round">
					<tr>
						<td class="title">角 色 信 息</td>
					</tr>
					<tr>
						<td>
							<TABLE width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="table">
								<%if (isNew) {%>
								<TR VALIGN=top>
									<TD WIDTH="94" class="deeptd">
										<DIV ALIGN=center> 角色名称</DIV>
									</TD>
									<TD class="tinttd" width="200">
										<html:text property="rolename"/>
									</TD>
									<TD WIDTH="94" class="deeptd" style="width:94px">
										<DIV ALIGN=center> 角色ID</DIV>
									</TD>
									<TD class="tinttd" width="150px">
										<html:text property="roleId"/>
									</TD>
								</TR>
								<TR VALIGN=top>
									<TD WIDTH="94" class="deeptd">
										<DIV ALIGN=center> 角色描述</DIV>
									</TD>
									<TD COLSPAN=3 class="tinttd">
										<div><html:textarea property="description"/></div>
									</TD>
								</TR>
								<%} else {%>
								<TR VALIGN=top>
									<TD WIDTH="94" class="deeptd">
										<DIV ALIGN=center> 角色名称</DIV>
									</TD>
									<TD class="tinttd" width="200">
										<bean:write name="moduleRoleForm" property="rolename"/>&nbsp;
										<html:hidden property="rolename"/>
									</TD>
									<TD WIDTH="94" class="deeptd" style="width:94px">
										<DIV ALIGN=center> 角色ID</DIV>
									</TD>
									<TD class="tinttd" width="150px">
										<bean:write name="moduleRoleForm" property="roleId"/>&nbsp;
										<html:hidden property="roleId"/>
									</TD>
								</TR>
								<TR VALIGN=top>
									<TD WIDTH="94" class="deeptd">
										<DIV ALIGN=center> 角色描述</DIV>
									</TD>
									<TD COLSPAN=3 class="tinttd" height="50px">
										<div>
											<bean:write name="moduleRoleForm" property="description"/>&nbsp;
										</div>
									</TD>
								</TR>
								<%}%>
								<TR VALIGN=top>
									<TD WIDTH="94" class="deeptd">
										<DIV ALIGN=center> 访问用户</DIV>
									</TD>
									<TD COLSPAN=3 class="tinttd">
										<div>
											<html:textarea property="roleVisitors" style="width:90%" rows="3"/> &nbsp;<img src="<%=request.getContextPath()%>/resources/images/actn133.gif" onclick="window.showModalDialog('<%=request.getContextPath()%>/address/winet_maddress.jsp?roleVisitors,roleVisitorsID',window,'status:no;dialogWidth:475px;dialogHeight:470px;scroll:no;help:no;')">
											<html:textarea property="roleVisitorsID" style="display:none"/>
										</div>
									</TD>
								</TR>
							</TABLE>
						</td>
					</tr>
					<tr>
						<td colspan="4" height="30" align="center">
							<input type="submit" name="save" value="保存" class="formbutton">
						</td>
					</tr>
				</table>
				<table style="display:none">
					<tr>
						<td>
							<html:text property="moduleID"/>
						</td>
					</tr>
				</table>

			</html:form>
		</td>
	</tr>
</table>
<!--索思奇智版权所有-->