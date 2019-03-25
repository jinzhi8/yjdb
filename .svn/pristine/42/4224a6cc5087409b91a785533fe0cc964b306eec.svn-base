<%@page language="java" contentType="text/html;charset=UTF-8" %>

<%@taglib prefix="html" uri="/WEB-INF/struts-html.tld" %>
<%@taglib prefix="bean" uri="/WEB-INF/struts-bean.tld" %>


<link href="<%=request.getContextPath()%>/resources/css/css.css" rel="stylesheet" type="text/css">
<link href="<%=request.getContextPath()%>/resources/css/switch.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript" charset="utf-8" src="<%=request.getContextPath()%>/resources/js/jquery/jquery-1.11.0.min.js"></script>
<script language="javascript" type="text/javascript" charset="utf-8" src="<%=request.getContextPath()%>/resources/js/layer/layerFunction.js"></script>
<table>
	<tr>
		<td class="content">
			<html:form action="formModuleAction">

				<bean:define id="moduleUNID" property="moduleUNID" name="moduleInfoForm"/>
				<jsp:include page="switchTitle.jsp">
					<jsp:param name="pageidx" value="4"/>
					<jsp:param name="unid" value="<%=(String)moduleUNID%>"/>
				</jsp:include>

				<!-- ******************* Part Two **************** -->
				<table border="0" align="center" cellpadding="0" cellspacing="0" class="round">
					<tr>
						<td class="title">模 块 管 理</td>
					</tr>
					<tr>
						<td>
							<TABLE width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="table">
								<TR VALIGN=top>
									<TD WIDTH="94" class="deeptd">
										<DIV ALIGN=center> 管理者</DIV>
									</TD>
									<TD COLSPAN=3 class="tinttd">
										<div>
											<html:textarea property="managePurview" readonly="true" rows="3" style="width:90%"/>&nbsp;<img src="<%=request.getContextPath()%>/resources/images/actn133.gif" onclick="openSelWin('<%=request.getContextPath()%>/address/winet_maddress.jsp?managePurview,managePurviewID');" />
											<html:textarea property="managePurviewID" rows="3" style="display:none"/>
										</div>
									</TD>
								</TR>
							</TABLE>
							<br><br><br><br>
						</td>
					</tr>
					<tr>
						<td colspan="4" height="30" align="center">
							<input type="submit" name="save" value="保存" class="formbutton">
							<!--<input type="button" value="返回" onclick="window.location=''"class="formbutton">-->
						</td>
					</tr>
				</table>
				<table style="display:none">
					<tr>
						<td>
							<html:text property="moduleUNID"/>
							<html:text property="action" value="control"/>
						</td>
					</tr>
				</table>
			</html:form>
		</td>
	</tr>
</table>
<!--索思奇智版权所有-->