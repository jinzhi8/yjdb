<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.component.entity.FieldEntity" %>
<%@page import="com.kizsoft.commons.uum.pojo.Owner" %>
<%@page import="com.kizsoft.commons.uum.service.IUUMService" %>
<%@page import="com.kizsoft.commons.uum.utils.UUMContend" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.ArrayList" %>
<%@page import="java.util.Date" %>

<%@page import="com.kizsoft.oa.wzbwsq.util.CommonUtil" %>


<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<%@taglib prefix="html" uri="/WEB-INF/oa-html.tld" %>
<%@taglib prefix="oa" uri="/WEB-INF/oa.tld" %>
<%//用户登陆验证
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
	}
	//获取系统地址
	String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
	//获取用户对象
	User userInfo = (User) session.getAttribute("userInfo");
	String userID = userInfo.getUserId();
	String userName = userInfo.getUsername();
	Group groupInfo = userInfo.getGroup();
	String groupID = groupInfo.getGroupId();
	String groupName = groupInfo.getGroupname();
	
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	
	String docUNID = getAttr(request,"unid");
	String isNewDoc = (docUNID == null || "".equals(docUNID)) ? "0" : "1";
	
	String curdate = null;
	String department = CommonUtil.doStr(getAttr(request,"department"));
	String departmentid = CommonUtil.doStr(getAttr(request,"departmentid"));
	String content = CommonUtil.doStr(getAttr(request,"content"));
	String issueManID = CommonUtil.doStr(getAttr(request,"issuemanid"));
	String issueMan = CommonUtil.doStr(getAttr(request,"issueman"));
	String issueflag = CommonUtil.doStr(getAttr(request,"issueflag"));
	String effectdays = "";
	
	if("".equals(issueManID)){
		issueManID = userID;
	}
	if("".equals(issueMan)){
		issueMan = userName;
	}
	if("".equals(content)){
		content = "";
	}
	if("".equals(effectdays)){
		effectdays = "7";
	}
	if("".equals(department)){
		department = groupName;
	}
	if("".equals(departmentid)){
		departmentid = groupID;
	}
	
	/*FieldEntity daysntity = (FieldEntity) request.getAttribute("effectdays");
	if (daysntity == null || daysntity.getValue() == null || "".equals(daysntity.getValue().toString())) {
		effectdays = "7";
	} else {
		effectdays = daysntity.getValue().toString();
	}*/
	
	FieldEntity issuetimeentity = (FieldEntity) request.getAttribute("issuetime");
	if (issuetimeentity == null || issuetimeentity.getValue() == null || "".equals(issuetimeentity.getValue())) {
		curdate = CommonUtil.getDateStr();
	} else {
		curdate = issuetimeentity.getValue().toString();
		
	}		

%>
<%!
	//获取表单返回对象
	public String getAttr(HttpServletRequest request,String name){
		String temp="";
		FieldEntity tempentity = (FieldEntity) request.getAttribute(name);
		if (tempentity == null || tempentity.getValue() == null || "".equals(tempentity.getValue())) {
		} else {
			temp = (String) tempentity.getValue();
		}
		return temp;
	}
%>

<%
	String templatename = (String) session.getAttribute("templatename");
	String templatestr = "/resources/template/" + templatename + "/template.jsp";
	if (templatename == null || "".equals(templatename)) {
		templatestr = "/resources/jsp/template.jsp";
	}
%>
<template:insert template="<%=templatestr%>">
<template:put name='title' content='公告信息' direct='true'/>
<%String str = "<a class=\"menucur\" href=\"sharebulletin\">公告信息</a>";%>
<template:put name='moduleNav' content='<%=str%>' direct='true'/>
<template:put name='content'>

<script language="javascript">

	function setFlag() {
		$("input[name='issueflag']").val("1");
	}
	function SubmitFun() {
		if ($("input[name='title']").val() == "") {
			alert("请输入标题！");
			return false;
		}
		if ($("input[name='effectdays']").val() == "") {
			alert("有效天数不能为空！");
			return false;
		}
		if (isNaN($("input[name='effectdays']").val())) {
			alert("有效天数必须是数字！");
			return false;
		}
		if ($("textarea[name='visitPurview']").val() == "") {
			alert("请选择发布范围！");
			return false;
		}
		return true;
	}
	/*function setRange() {
		var BDStr = "";
		if ($("input[name='visitPurviewID']").val()!= "") BDStr = ",";
		$("input[name='visitPurviewID2']").val($("input[name='issuemanid']").val()+BDStr+$("input[name='visitPurviewID']").val());
	}*/
</script>
<script type="text/javascript">
	KindEditor.ready(function(K) {
		var editor = K.create('textarea[name="content"]', {
			allowFileManager : true
		});
	});
</script>
<div style="margin: 0px 25px;">
<form action="<%=request.getContextPath()%>/save" name="NewsForm" method="post" enctype="multipart/form-data">
	<input type="hidden" name="xmlName" value="sharebulletin">
	<input type="hidden" name="xmlType" value="<%=(String) request.getAttribute("xmlType")%>">
	<input type="hidden" name="moduleId" value="sharebulletin">
	<input type="hidden" name="docsign" value="1">
	<input type="hidden" name="effectdays" value="0">
	
	<html:hidden name="issueflag" value="0"/>
	<html:hidden name="unid"/>
	<table border="0" align="center" cellpadding="0" cellspacing="0" class="round">
		<tr>
			<td class="title">公告信息</td>
		</tr>
		<tr>
			<td><br>
				<TABLE cellpadding=1 BORDER="0" CELLSPACING=0 class="table">
					<TR VALIGN=top>
						<TD WIDTH="100" VALIGN=middle class="deeptd">
							<DIV ALIGN=center>&nbsp;&nbsp;公告标题 <font color="red">*</font></DIV>
						</TD>
						<TD COLSPAN="3" class="tinttd">
							<html:text name="title" style="width:98%" />
						</TD>
					</TR>
					<TR VALIGN=top>
						<TD WIDTH="100" VALIGN=middle class="deeptd">
							<DIV ALIGN=center>发布部门</DIV>
						</TD>
						<TD class="tinttd">
							<html:text name="department" readonly="true" style="width:98%" value="<%=department%>"></html:text>
							<html:hidden name="departmentid" value="<%=departmentid%>"  />
						</TD>
						<TD WIDTH="100" VALIGN=middle class="deeptd">
							<DIV ALIGN=center>发布人员</DIV>
						</TD>
						<TD class="tinttd">
							<html:text name="issueman" readonly="true" style="width:98%" value="<%=userName%>"></html:text>
							<html:text name="issuemanid" readonly="true" value="<%=issueManID%>" style="display:none"></html:text>
						</TD>
					</TR>
					<TR VALIGN=top style="display:none;">
						<TD WIDTH="100" VALIGN=middle class="deeptd">
							<DIV ALIGN=center> 公告范围</DIV>
						</TD>
						<TD colspan="3" class="tinttd">
							<!--<html:textarea name="rangelist" style="width:94%" rows="3" readonly="true"/> 
							<img src="<%=request.getContextPath()%>/resources/images/actn133.gif" onclick="openSelWin('<%=request.getContextPath()%>/address/tree.jsp?utype=3&rtype=0&count=0&fields=rangelist,rangeidlist')">-->
							<html:hidden name="rangelist" value="*" /> 
							<html:hidden name="rangeidlist" value="*" />
							<html:textarea name="visitPurviewID2" style="display:none"/>
						</TD>
					</TR>
					<TR VALIGN=top>
						<TD WIDTH="100" VALIGN=middle class="deeptd">
							<DIV ALIGN=center>公告分类</DIV>
						</TD>
						<TD class="tinttd">
							<html:select name="typeid" style="width:200px;">
								<html:optionsCollection name="typeids"/>
							</html:select>
						</TD>
						<TD WIDTH="100" VALIGN=middle class="deeptd">
							<DIV ALIGN=center>发布时间</DIV>
						</TD>
						<TD class="tinttd">
							<html:text name="issuetime" readonly="true" value="<%=curdate%>" style="width:98%;" />
							<!--<html:text name="issuetime" readonly="true" styleClass="Wdate" style="width:150px" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'});" value="<%=curdate%>"></html:text>-->
						</TD>
					</TR>
					<TR VALIGN=top>
						<TD WIDTH="100" VALIGN=middle class="deeptd">
							<DIV ALIGN=center>公告正文</DIV>
						</TD>
						<TD colspan="3" class="tinttd">
							<html:textarea name="content" style="height:500px;"/>
						</TD>
					</TR>
					<TR VALIGN=top>
						<TD WIDTH="100" VALIGN=middle class="deeptd">
							<DIV ALIGN=center>附&nbsp;&nbsp;&nbsp;&nbsp;件</DIV>
						</TD>
						<TD colspan="3" class="tinttd">
							<%if(userID.equals(issueManID) || isNewDoc.equals("0")) {%>
							<html:file name="content2"/>
							<html:attachment moduleid="sharebulletin" unid="unid" type="content2"/>
							<% } else {%>
							<html:attachment moduleid="sharebulletin" unid="unid" type="content2" showdelete="false"/>
							<% }%>
						</TD>
					</TR>
				</TABLE>
				<BR>
				<table border="0" width="100%">
					<tr>
						<td height="30">
							<%if (userID.equals(issueManID) || isNewDoc.equals("0")) {%>
							<DIV align="center">
								<%if (!issueflag.equals("1")) {%>
								<input type="submit" name="saveConent" class="formbutton" value="保  存" onclick="return SubmitFun();"/>
								<%}%>
								<input type="submit" name="saveConent" class="formbutton" value="发  布" onclick="setFlag();return SubmitFun();"/>
								<%if (isNewDoc.equals("1")) {%>
								<input type="submit" name="delContent" class="formbutton" value="删  除" onclick="document.all.xmlType.value='delete';return confirmDelete();"/>
								<%}%>
							</DIV>
							<%}%>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>	
</form>
</template:put>
</template:insert>			
<!--索思奇智版权所有-->