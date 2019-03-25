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

			<html:form action="formModuleTypeAction">
				<bean:define id="moduleTypeID" property="moduleTypeID" name="moduleTypeForm"/>
				<bean:define id="saveFlag" property="saveFlag" name="moduleTypeForm"/>
				<%

					if ((String) saveFlag != null && "1".equals(saveFlag)) {

						if ((String) moduleTypeID != null && !"".equals((String) moduleTypeID)) {%>

				<script language="javascript">window.parent.mframe.location = "nav.jsp?moduletypeid=<%=(String)moduleTypeID%>"</script>
				<%}
				}%>

				<table border="0" align="center" cellpadding="0" cellspacing="0" class="round" style="width:100%" width=800px>
					<tr>
						<td class="title">模 块 类 型 管 理</td>
					</tr>
					<tr>
						<td>
							<TABLE width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="table">
								<TR VALIGN=top>
									<TD WIDTH="94" class="deeptd">
										<DIV ALIGN=center> 类型名称</DIV>
									</TD>
									<TD class="tinttd">
										<html:text property="moduleType"/>
									</TD>
									<TD WIDTH="94" class="deeptd">
										<DIV ALIGN=center> 排序号</DIV>
									</TD>
									<TD WIDTH="100" class="tinttd">
										<html:text property="orderNum"/>
									</TD>
									<TD WIDTH="94" class="deeptd">
										<DIV ALIGN=center>状态</DIV>
									</TD>
									<TD WIDTH="100" class="tinttd">
										<html:select property="isAvailabled">
											<html:option value="1">启用</html:option>
											<html:option value="0">禁用</html:option>
										</html:select>
									</TD>
								</TR>
								<TR VALIGN=top>
									<TD WIDTH="94" class="deeptd">
										<DIV ALIGN=center>访问人员</DIV>
									</TD>
									<TD colspan="5" class="tinttd">
										<html:textarea rows="3" property="visitors" readonly="true" style="width:90%"/> &nbsp;<img src="<%=request.getContextPath()%>/resources/images/actn133.gif" onclick="openSelWin('<%=request.getContextPath()%>/address/tree.jsp?utype=3&rtype=1&count=0&fields=visitors,visitorsID');">
										<html:textarea rows="3" property="visitorsID" style="display:none"/>
									</TD>
								</TR>
							</TABLE>
						</td>
					</tr>
					<tr>
						<td colspan="6" height="30" align="center">
							<input type="submit" name="save" value="保存" class="formbutton">

						</td>
					</tr>
				</table>
				<table style="display:none">
					<tr>
						<td>
							<html:text property="moduleTypeID"/>
						</td>
					</tr>
				</table>
			</html:form>
		</td>
	</tr>
</table>
<br><!--索思奇智版权所有-->