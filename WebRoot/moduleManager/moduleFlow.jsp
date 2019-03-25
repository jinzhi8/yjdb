<%@page language="java" contentType="text/html;charset=UTF-8" %>

<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<%@taglib prefix="html" uri="/WEB-INF/struts-html.tld" %>
<%@taglib prefix="bean" uri="/WEB-INF/struts-bean.tld" %>


<link href="<%=request.getContextPath()%>/resources/css/css.css" rel="stylesheet" type="text/css">
<link href="<%=request.getContextPath()%>/resources/css/switch.css" rel="stylesheet" type="text/css">

<script>

	function initFlowFlag(flag) {
		var flowBindingFlag = document.all.flowBindingFlag;
		if (flag) {
			document.all.flowBindingFlag.disabled = false;
			document.all.consignFlag.disabled = false;
			initFlowBindingFlag(flowBindingFlag.checked);
		} else {
			document.all.flowBindingFlag.disabled = true;
			document.all.consignFlag.disabled = true;
			document.all.flowBindingID.disabled = true;
			document.all.appURL.disabled = true;
		}
	}

	function initFlowBindingFlag(flag) {
		if (flag) {
			document.all.flowBindingID.disabled = false;
			document.all.appURL.disabled = false;
		} else {
			document.all.flowBindingID.disabled = true;
			document.all.appURL.disabled = true;
		}
	}
</script>

<table>
	<tr>
		<td class="content">
			<html:form action="formModuleAction">

				<bean:define id="moduleUNID" property="moduleUNID" name="moduleInfoForm"/>
				<jsp:include page="switchTitle.jsp">
					<jsp:param name="pageidx" value="2"/>
					<jsp:param name="unid" value="<%=(String)moduleUNID%>"/>
				</jsp:include>

				<!--**************** Part Two **************** -->
				<table border="0" align="center" cellpadding="0" cellspacing="0" class="round">
					<tr>
						<td class="title">模 块 流 程</td>
					</tr>
					<tr>
						<td>
							<TABLE width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="table">
								<TR VALIGN=top>
									<td colspan="4" class="tinttd">
										<html:checkbox property="flowFlag" styleClass="radio" onclick="initFlowFlag(this.checked)"/>允许使用流程
									</td>
								</TR>
								<TR VALIGN=top>
									<TD WIDTH="361" class="tinttd" colspan="2">
										<html:checkbox property="flowBindingFlag" styleClass="radio" onclick="initFlowBindingFlag(this.checked)"/>固定流程绑定
									</TD>
									<TD WIDTH="361" class="tinttd" colspan="2">
										<html:checkbox property="consignFlag" styleClass="radio"/>允许事务委托
									</TD>
								</TR>
								<TR VALIGN=top>
									<TD WIDTH="94" class="deeptd">
										<DIV ALIGN=center> 绑定流程</DIV>
									</TD>
									<TD WIDTH="267" class="tinttd">
										<html:text property="flowBindingID"/>
									</TD>
									<TD WIDTH="94" class="deeptd">
										<DIV ALIGN=center> &nbsp; </DIV>
									</TD>
									<TD WIDTH="267" class="tinttd">
										&nbsp;
									</TD>
								</TR>
								<TR VALIGN=top>
									<TD WIDTH="94" class="deeptd">
										<DIV ALIGN=center> 应用访问地址</DIV>
									</TD>
									<TD WIDTH="665" COLSPAN=3 class="tinttd">
										<html:text property="appURL"/>
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
							<html:text property="action" value="flow"/>
						</td>
					</tr>
				</table>
			</html:form>
		</td>
	</tr>
</table>


<script>
	initFlowFlag(document.all.flowFlag.checked);
</script>

<!--索思奇智版权所有-->