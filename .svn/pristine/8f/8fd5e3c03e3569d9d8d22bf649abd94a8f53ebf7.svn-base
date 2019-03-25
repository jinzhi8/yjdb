<%@ page language="java" contentType="text/html;charset=utf-8" %>

<%@page import="com.kizsoft.commons.acl.ACLManager" %>
<%@page import="com.kizsoft.commons.acl.ACLManagerFactory" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.component.entity.FieldEntity" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Date" %>
<%@ page import="com.kizsoft.commons.workflow.FlowTransmitInfo" %>

<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<%@taglib prefix="html" uri="/WEB-INF/oa-html.tld" %>
<%@taglib prefix="oa" uri="/WEB-INF/oa.tld" %>

<%
	//用户登陆验证
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
	} else {
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		String getCurYear = format.format(new java.util.Date()).substring(0, 4);
		String app_id = (request.getParameter("appId") == null) ? "" : request.getParameter("appId");
		String userflag = (String) session.getAttribute("userFlag");
		if (userflag == null) userflag = "0";
		FieldEntity docIdField = (FieldEntity) request.getAttribute("requestid");
		FlowTransmitInfo flowTransmitInfo = (FlowTransmitInfo) request.getAttribute("flowTransmitInfo");
%>
<%
	String templatename = (String) session.getAttribute("templatename");
	String templatestr = "/resources/template/" + templatename + "/template.jsp";
	if (templatename == null || "".equals(templatename)) {
		templatestr = "/resources/jsp/template.jsp";
	}
%>
<template:insert template="<%=templatestr%>">
	<template:put name='title' content='督办批示' direct='true'/>
	<%
		String str = "<a href=\"zwdb\">督办批示</a>";
	%>
	<template:put name='moduleNav' content='<%=str%>' direct='true'/>
	<template:put name='content'>
		<script>
			function addFile(Str) {
				var inputElement = document.createElement("INPUT");
				inputElement.type = "file";
				inputElement.name = Str;
				document.getElementsByName(Str)[0].parentNode.appendChild(inputElement);
				//document.getElementsByName(Str)[0].parentNode.insertBefore(inputElement,document.getElementsByName(Str)[0]);
			}
			function chkform() {
				return true;
			}
		</script>
		<script language="javascript" src="<%=request.getContextPath()%>/resources/js/deleteconfig/delconfig.js"></script>
		<script language="javascript" src="<%=request.getContextPath()%>/resources/js/calendar.js"></script>

		<%
			User userInfo = (User) session.getAttribute("userInfo");
			String userID = userInfo.getUserId();
			Group groupInfo = userInfo.getGroup();
			String groupID = groupInfo.getGroupId();
			String curdate = "";
			String senddate = "";
			String getdate = "";
			String onclick = "";
			FieldEntity senddateentity = (FieldEntity) request.getAttribute("senddate");
			FieldEntity getdateentity = (FieldEntity) request.getAttribute("getdate");
			FieldEntity yearentity = (FieldEntity) request.getAttribute("issue_year");
			if (docIdField == null || docIdField.getValue() == null || "".equals(docIdField.getValue())) {
				curdate = format.format(new Date()).toString();
				senddate = format.format(new Date()).toString();
				getdate = format.format(new Date()).toString();
				onclick = "openCalendar(this);";
			} else {
				curdate = format.format(new Date()).toString();
				senddate = senddateentity.getValue().toString();
				getdate = getdateentity.getValue().toString();
				getCurYear = (String) yearentity.getValue();
			}
			String requestid=getAttr(request,"requestid","");

			String issuetime=getAttr(request,"issuetime");
		    SimpleDateFormat sdfp=new SimpleDateFormat("yyyy-MM-dd");
		    issuetime=format.format(sdfp.parse(issuetime));
		%>
		<%!
			public String getAttr(HttpServletRequest request,String name){
				return getAttr(request,name,"");
			}

			public String getAttr(HttpServletRequest request,String name,String replace){
				String temp=replace;
				FieldEntity tempentity = (FieldEntity) request.getAttribute(name);
				if (tempentity == null || tempentity.getValue() == null || "".equals(tempentity.getValue())) {
				} else {
					temp = (String) tempentity.getValue();
				}
				return temp;
			}
		%>
		<form class="layui-form layui-form-pane"  action="<%=request.getContextPath()%>/save" method="post" enctype="multipart/form-data" onSubmit="return validateContext();">
			<input type="hidden" name="xmlName" value="<%=(String)request.getAttribute("xmlName")%>">
			<input type="hidden" name="xmlType" value="<%=(String)request.getAttribute("xmlType")%>">
			<input type="hidden" name="moduleId" value="zwdb"/>
			<input type="hidden" name="issuetime" value="<%=curdate%>"/>
			<input type="hidden" name="issueflag" value="1"/>
			<html:hidden name="requestid"></html:hidden>
			<table border="0" align="center" cellpadding="0" cellspacing="0" class="round">
				<tr>
		            <td class="title">
		                <div align=center>永嘉县人民政府领导批示督办单</div>
		            </td>
		        </tr>
				<tr>
					<td align="center">
						<TABLE width="99%" border="0" align="center" cellpadding="0" cellspacing="0" class="table">
							<TR VALIGN=top>
								<TD class="deeptd">
									<DIV ALIGN=center>标题<font color="red">*</font></DIV>
								</TD>
								<TD COLSPAN="3" class="tinttd">
									<html:write name="title"/>
								</TD>
							</TR>
							<TR VALIGN=top>
								<TD WIDTH="120px" VALIGN=middle class="deeptd">
									<DIV ALIGN=center>文号<font color="red">*</font></DIV>
								</TD>
								<TD class="tinttd" colspan="3">
									永批督〔<html:write name="send_issue_year"/>〕
									<html:write name="send_issue_dep_code"/>号
								</TD>
								<!-- <TD WIDTH="120px" VALIGN=middle class="deeptd">
									<DIV ALIGN=center>内部编号<font color="red">*</font></DIV>
								</TD>
								<TD class="tinttd">
									<html:write name="issue_dep_code"/>
									〔<html:write name="issue_year"/>〕
									<html:write name="issue_num"/>号
								</TD> -->
							</TR>
							<TR VALIGN=top>
								<TD WIDTH="120px" VALIGN=middle class="deeptd">
									<DIV ALIGN=center>来文日期<font color="red">*</font></DIV>
								</TD>
								<TD class="tinttd">
									<html:write name="senddate"></html:write>
								</TD>
								<TD WIDTH="120px" VALIGN=middle class="deeptd">
									<DIV ALIGN=center>接收日期<font color="red">*</font></DIV>
								</TD>
								<TD class="tinttd">
									<html:write name="getdate"></html:write>
								</TD>
							</TR>
							<TR VALIGN=top style="display:none">
								<TD WIDTH="120px" VALIGN=middle class="deeptd">
									<DIV ALIGN=center>正文</DIV>
								</TD>
								<TD COLSPAN="3" class="tinttd">
									<html:attachment moduleid="zwdb" unid="requestid" type="contentattach" showdelete="false"/> &nbsp;
								</TD>
							</TR>
							<TR VALIGN=top>
								<TD WIDTH="120px" VALIGN=middle class="deeptd">
									<DIV ALIGN=center>附件</DIV>
								</TD>
								<TD class="tinttd" COLSPAN="3">
									<div id="attachdiv">
										<html:attachment moduleid="zwdb" unid="requestid" type="attach" showdelete="false"/>&nbsp;
									</div>
								</TD>
							</TR>
							<TR VALIGN=top>
								<TD WIDTH="120px" VALIGN=middle class="deeptd">
									<DIV ALIGN=center >领导意见</DIV>
								</TD>
								<TD COLSPAN="3" class="tinttd">
									<html:write name="rangelist"/>
								</TD>
							</TR>
							 <tr valign="top">
				                <td width="120px" valign="middle" class="deeptd">
				                    <div align="center">批示领导</div>
				                </td>
				                <td class="tinttd" style="width:40%">
				                    <html:write name="qfmanid"/>
				                </td>
				                <td width="120px" valign="middle" class="deeptd">
				                    <div align="center">发布时间</div>
				                </td>
				                <td class="tinttd" style="width:40%">
				                    <%=issuetime%>
				                </td>
				            </tr>   
				            <tr valign="top">
				                <td width="120px" valign="middle" class="deeptd">
				                    <div align="center">牵头领导</div>
				                </td>
				                <td class="tinttd" style="width:40%">
				                    <html:write name="leadername"/>
				                </td>
				                <td width="120px" valign="middle" class="deeptd">
				                    <div align="center">配合领导</div>
				                </td>
				                <td class="tinttd" style="width:40%">
				                    <html:write name="source"/>
				                </td>
				            </tr>
				            <tr valign="top">
				                <td width="120px" valign="middle" class="deeptd">
				                    <div align="center">交办时限</div>
				                </td>
				                <td class="tinttd" >
				                    <html:write name="jbsx"/>
				                </td>
				                <td width="120px" valign="middle" class="deeptd">
				                    <div align="center">报送周期</div>
				                </td>
				                <td class="tinttd">
				                    <html:write name = "fklx" />&nbsp;&nbsp;<html:write name = "fkzq" />
				                </td>
				            </tr>
				            <tr valign="top">
				                <td width="120px" valign="middle" class="deeptd">
				                    <div align="center">牵头单位</div>
				                </td>
				                <td colspan="3" class="tinttd">
				                    <html:write name="managedepname"/>
				                </td>
				            </tr>
							<tr valign="top">
				                <td width="120px" valign="middle" class="deeptd">
				                    <div align="center">配合单位</div>
				                </td>
				                <td colspan="3" class="tinttd">
				                    <html:write name="copyto"/>
				                </td>
				            </tr>
				            <tr valign="top">
				                <td width="120px" VALIGN=middle class="deeptd">
				                    <div align="center">督办机构联系人</div>
				                </td>
				                <td class="tinttd">
				                    <html:write name="lxr" />
				                </td>
				                <td width="120px" VALIGN=middle class="deeptd">
				                    <div align="center">电话号码</div>
				                </td>
				                <td class="tinttd">
				                    <html:write name="lxdh"/>
				                </td>
				            </tr>
				            <tr valign="top">
				                <td width="120px" VALIGN=middle class="deeptd">
				                    <div align="center">传真号码</div>
				                </td>
				                <td  class="tinttd" colspan="3">
				                    <html:write name="czhm"/>
				                </td>
				            </tr>
						</TABLE>
						</br>
						<%
							if ("2".equals(flowTransmitInfo.getCurInstance().getInstanceStatus())) {
						%>
							
							<a class="viewbutton" target="_blank" href="<%=request.getContextPath()%>/zwdb/request.jsp?id=<html:write name="requestid"/>"><span>打印公文处理单</span></a>
						<%}%>
					</td>
				</tr>
			</table>
		</form>
		<BR>
		<script type="text/javascript">
			function selectFlow(moduleID) {
				var urlstr = "<%=request.getContextPath()%>/zwdb/selectFlow.jsp?docunid=<%=requestid%>&moduleID=zwdb";
				window.showModalDialog(urlstr, window, 'status:no;dialogWidth:345px;dialogHeight:250px;scroll:no;help:no;');
			}
		</script>
		<table border="0" width="100%">
			<tr>
				<td>
					<jsp:include page="/workflow/history.jsp"/>
				</td>
			</tr>
		</table>

		<jsp:include page="/workflow/appbinding.jsp"/>
	</template:put>
</template:insert>
<%}%>

