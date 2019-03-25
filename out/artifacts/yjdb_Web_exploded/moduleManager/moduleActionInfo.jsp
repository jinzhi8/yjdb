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
			<html:form action="formModuleActionAction">
				<!-- ******************* Part One **************** -->
				<table border="0" align="center" cellpadding="0" cellspacing="0" class="round">
					<tr>
						<td class="title">操 作 信 息</td>
					</tr>
					<tr>
						<td>
							<TABLE width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="table">
								<TR VALIGN=top>
									<TD WIDTH="94" class="deeptd">
										<DIV ALIGN=center> 操作名称</DIV>
									</TD>
									<TD class="tinttd" width="200">
										<html:text property="actionName"/>
									</TD>
									<TD WIDTH="94" class="deeptd" style="width:94px">
										<DIV ALIGN=center> 操作排序</DIV>
									</TD>
									<TD class="tinttd" width="150px">
										<html:text property="actionOrder"/>
									</TD>
								</TR>
								<TR VALIGN=top>
									<TD WIDTH="94" class="deeptd">
										<DIV ALIGN=center> 图片链接</DIV>
									</TD>
									<TD COLSPAN=3 class="tinttd">
										<div><html:text property="actionImgURL"/></div>
									</TD>
								</TR>
								<TR VALIGN=top>
									<TD WIDTH="94" class="deeptd">
										<DIV ALIGN=center> 操作链接</DIV>
									</TD>
									<TD COLSPAN=3 class="tinttd">
										<div><html:text property="actionURL"/></div>
									</TD>
								</TR>
								<TR VALIGN=top>
									<TD WIDTH="94" class="deeptd">
										<DIV ALIGN=center> 访问用户</DIV>
									</TD>
									<TD COLSPAN=3 class="tinttd">
										<div>
											<html:textarea property="actionPurview_cn" readonly="true" style="width:90%" rows="3"/> &nbsp;<img src="<%=request.getContextPath()%>/resources/images/actn133.gif" onclick="openSelWin('<%=request.getContextPath()%>/address/tree.jsp?utype=3&rtype=1&count=0&fields=actionPurview_cn,actionPurview',window);" />
											<html:textarea property="actionPurview" style="display:none"/>
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
							<html:text property="actionID"/>
							<html:text property="moduleID"/>
						</td>
					</tr>
				</table>

			</html:form>
		</td>
	</tr>
</table>
<!--索思奇智版权所有-->