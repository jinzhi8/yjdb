<%@page language="java" contentType="text/html;charset=UTF-8" %>

<%@taglib prefix="html" uri="/WEB-INF/struts-html.tld" %>
<%@taglib prefix="bean" uri="/WEB-INF/struts-bean.tld" %>


<link href="<%=request.getContextPath()%>/resources/css/css.css" rel="stylesheet" type="text/css">
<link href="<%=request.getContextPath()%>/resources/css/switch.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript" charset="utf-8" src="<%=request.getContextPath()%>/resources/js/jquery/jquery-1.11.0.min.js"></script>
<script language="javascript" type="text/javascript" charset="utf-8" src="<%=request.getContextPath()%>/resources/js/layer/layerFunction.js"></script>
<table width="100%">
	<tr>
		<td class="content">
			<html:form action="formModuleAction">

				<bean:define id="moduleTypeID" property="moduleTypeID" name="moduleInfoForm"/>
				<bean:define id="moduleUNID" property="moduleUNID" name="moduleInfoForm"/>
				<bean:define id="saveFlag" property="saveFlag" name="moduleInfoForm"/>
				<jsp:include page="switchTitle.jsp">
					<jsp:param name="pageidx" value="1"/>
					<jsp:param name="unid" value="<%=(String)moduleUNID%>"/>
				</jsp:include>
				<%if ((String) saveFlag != null && "1".equals((String) saveFlag)) if ((String) moduleTypeID != null && !"".equals((String) moduleTypeID)) {%>
				<script language="javascript">window.parent.mframe.location = "nav.jsp?moduletypeid=<%=(String)moduleTypeID%>"</script>
				<%}%>
				<!-- ******************* Part One **************** -->
				<table border="0" align="center" cellpadding="0" cellspacing="0" class="round">
					<tr>
						<td class="title">模 块 信 息</td>
					</tr>
					<tr>
						<td>
							<TABLE width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="table">
								<TR VALIGN=top>
									<TD WIDTH="94" class="deeptd">
										<DIV ALIGN=center> 模块名称</DIV>
									</TD>
									<TD class="tinttd" width="180">
										<html:text property="moduleName"/>
									</TD>
									<TD WIDTH="94" class="deeptd" style="width:94px">
										<DIV ALIGN=center> 模块类型</DIV>
									</TD>
									<TD class="tinttd" width="180px">
										<html:select property="moduleTypeID">
											<html:optionsCollection name="moduleInfoForm" property="moduleTypeBeans"/>
										</html:select>
									</TD>
								</TR>
								<TR VALIGN=top>
									<TD WIDTH="94" class="deeptd">
										<DIV ALIGN=center> 模 块 ID</DIV>
									</TD>
									<TD class="tinttd" width="180">
										<%if ((String) moduleUNID == null || "".equals((String) moduleUNID)) {%>
										<html:text property="moduleID"/>
										<%} else {%>
										<html:text property="moduleID" readonly="false"/>
										<%}%>
									</TD>
									<TD WIDTH="94" class="deeptd">
										<DIV ALIGN=center> 排 序 号</DIV>
									</TD>
									<TD class="tinttd">
										<html:text property="orderNum"/>
									</TD>
								</TR>
								<TR VALIGN=top>
									<TD WIDTH="94" class="deeptd">
										<DIV ALIGN=center> 模块访问地址</DIV>
									</TD>
									<TD class="tinttd">
										<div><html:text property="visitURLCode"/></div>
									</TD>
									<TD WIDTH="94" class="deeptd" style="width:94px">
										<DIV ALIGN=center>状态</DIV>
									</TD>
									<TD class="tinttd" width="180px">
										<html:select property="isAvailabled">
											<html:option value="1">启用</html:option>
											<html:option value="0">禁用</html:option>
										</html:select>
									</TD>
								</TR>
								<TR VALIGN=top>
									<TD WIDTH="100" class="deeptd">
										<DIV ALIGN=center> 是否使用流程</DIV>
									</TD>
									<TD class="tinttd">
										<div><html:checkbox property="flowFlag" styleClass="radio"/>
										</div>
									</TD>
									<TD WIDTH="100" class="deeptd">
										<DIV ALIGN=center> 是否事务委托</DIV>
									</TD>
									<TD class="tinttd">
										<div><html:checkbox property="consignFlag" styleClass="radio"/>
										</div>
									</TD>
								</TR>
								<TR VALIGN=top>
									<TD WIDTH="94" class="deeptd">
										<DIV ALIGN=center> 访问用户</DIV>
									</TD>
									<TD COLSPAN=3 class="tinttd">
										<div>
											<html:textarea property="visitPurview" readonly="true" style="width:90%" rows="3"/> &nbsp;<img src="<%=request.getContextPath()%>/resources/images/actn133.gif" onclick="openSelWin('<%=request.getContextPath()%>/address/tree.jsp?utype=3&rtype=1&count=0&fields=visitPurview,visitPurviewID');">
											<html:textarea property="visitPurviewID" style="display:none"/>
										</div>
									</TD>
								</TR>
								<TR VALIGN=top>
									<TD WIDTH="94" class="deeptd">
										<DIV ALIGN=center> 模块描述</DIV>
									</TD>
									<TD COLSPAN=3 class="tinttd">
										<div><html:textarea property="description" rows="5"/></div>
									</TD>
								</TR>
							</TABLE>
						</td>
					</tr>
					<tr>
						<td colspan="4" height="30" align="center">
							<input type="submit" name="save" value="保存" class="formbutton">
							<!--<input type="button" value="返回" onclick="window.location=''" class="formbutton">-->
						</td>
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