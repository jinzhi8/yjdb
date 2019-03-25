<%@page language="java" contentType="text/html;charset=UTF-8" %>

<%@taglib prefix="html" uri="/WEB-INF/struts-html.tld" %>
<%@taglib prefix="bean" uri="/WEB-INF/struts-bean.tld" %>


<link href="<%=request.getContextPath()%>/resources/css/css.css" rel="stylesheet" type="text/css">
<link href="<%=request.getContextPath()%>/resources/css/switch.css" rel="stylesheet" type="text/css">

<table width="100%">
	<tr>
		<td class="content">
			<html:form action="formModuleConfigAction">

				<table border="0" align="center" cellpadding="0" cellspacing="0" class="round">
					<tr>
						<td class="title">配 置 信 息</td>
					</tr>
					<tr>
						<td>
							<TABLE width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="table">
								<TR VALIGN=top>
									<TD WIDTH="94" class="deeptd">
										<DIV ALIGN=center> 配置名称</DIV>
									</TD>
									<TD class="tinttd" width="200">
										<html:text property="config_name"/>
									</TD>
									<TD WIDTH="94" class="deeptd" style="width:94px">
										<DIV ALIGN=center> 排序</DIV>
									</TD>
									<TD class="tinttd" width="150px">
										<html:text property="config_order"/>
									</TD>
								</TR>
								<TR VALIGN=top>
									<TD WIDTH="94" class="deeptd">
										<DIV ALIGN=center> 配置链接</DIV>
									</TD>
									<TD COLSPAN=3 class="tinttd">
										<html:text property="config_path"/>
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
							<html:text property="module_id"/>
							<html:text property="config_id"/>
						</td>
					</tr>
				</table>

			</html:form>
		</td>
	</tr>
</table>
<!--索思奇智版权所有-->