<%@ page language="java" contentType="text/html;charset=utf-8" %>

<%@page import="com.kizsoft.commons.acl.ACLManager" %>
<%@page import="com.kizsoft.commons.acl.ACLManagerFactory" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.component.entity.FieldEntity" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Date" %>
<%@ page import="com.kizsoft.commons.commons.user.UserManagerFactory" %>
<%@ page import="com.kizsoft.commons.workflow.Instance" %>
<%@ page import="com.kizsoft.commons.workflow.Request" %>
<%@ page import="com.kizsoft.commons.workflow.*" %>
<%@ page import="com.kizsoft.commons.workflow.dao.DAOFactory" %>
<%@ page import="com.kizsoft.commons.workflow.dao.RequestDAO" %>
<%@ page import="java.util.ArrayList" %>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<%@taglib prefix="html" uri="/WEB-INF/oa-html.tld" %>
<%@taglib prefix="oa" uri="/WEB-INF/oa.tld" %>

<%
	//用户登陆验证
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
	} else {
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		String app_id = (request.getParameter("appId") == null) ? "" : request.getParameter("appId");
		String taskid = (request.getParameter("taskid") == null) ? "" : request.getParameter("taskid");
		//System.out.println("taskid:"+taskid);
		String userflag = (String) session.getAttribute("userFlag");
		if (userflag == null) userflag = "0";
		FieldEntity docIdField = (FieldEntity) request.getAttribute("requestid");	
		String docUNID=getAttr(request,"requestid","");

		String receivedepid=getAttr(request,"receivedepid","");
	
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
<%
	String templatename = (String) session.getAttribute("templatename");
	String templatestr = "/resources/template/" + templatename + "/template.jsp";
	if (templatename == null || "".equals(templatename)) {
		templatestr = "/resources/jsp/template.jsp";
	}
%>
<template:insert template="<%=templatestr%>">
<template:put name='title' content='收文登记' direct='true'/>
<%
	String str = "<a href=\"getshou\">收文登记</a>";
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
		if (document.all.title.value == '') {
			alert("标题为空，请输入！");
			document.all.title.focus();
			return false;
		}
		/*if (document.all.send_issue_dep_code.value == '' || document.all.send_issue_year.value == '' || document.all.send_issue_num.value == '') {
			alert("来文文号必须填写完整，请输入！");
			return false;
		}*/
		return true;
	}
	function qians(){
        $.ajax({ 
                async: true, 
                type : "POST", 
                url : "<%=request.getContextPath()%>/getshou/qs.jsp?",
                cache: false,                      
                data : {taskid:"<%=taskid%>"},
            success:function(data){  
            }
        });
	}
</script>
<script language="javascript" src="<%=request.getContextPath()%>/resources/js/deleteconfig/delconfig.js"></script>
<script language="javascript" src="<%=request.getContextPath()%>/resources/js/calendar.js"></script>

<%
	ACLManager aclManager = ACLManagerFactory.getACLManager();
	User userInfo = (User) session.getAttribute("userInfo");
	String userID = userInfo.getUserId();
	String userName = userInfo.getUsername();
	Group groupInfo = userInfo.getGroup();
	String groupName = groupInfo.getGroupname();
	String groupID = groupInfo.getGroupId();
	String curdate = "";
	String senddate = "";
	String getdate = "";
	String issuetime = "";
	String onclick = "";
	String unid = "";
	FieldEntity unidentity = (FieldEntity) request.getAttribute("unid");
	if (unidentity == null || unidentity.getValue() == null || "".equals(unidentity.getValue())) {
		unid = "";
	} else {
		unid = (String) unidentity.getValue();
	}
	FieldEntity senddepentity = (FieldEntity) request.getAttribute("senddep");
	FieldEntity senddepidentity = (FieldEntity) request.getAttribute("senddepid");
	String senddep = "";
	String senddepid = "";
	if (senddepentity == null || senddepentity.getValue() == null || "".equals(senddepentity.getValue())) {
		senddep = groupInfo.getGroupname();
		senddepid = groupInfo.getGroupId();
	} else {
		senddep = (String) senddepentity.getValue();
		senddepid = (String) senddepidentity.getValue();
	}
	String draftMan = "";
	FieldEntity draftmanentity = (FieldEntity) request.getAttribute("draftman");
	if (draftmanentity == null || draftmanentity.getValue() == null || "".equals(draftmanentity.getValue())) {
		draftMan = userInfo.getUsername();
	} else {
		draftMan = (String) draftmanentity.getValue();
	}
	String draftManId = "";
	FieldEntity draftmanidentity = (FieldEntity) request.getAttribute("draftmanid");
	if (draftmanidentity == null || draftmanidentity.getValue() == null || "".equals(draftmanidentity.getValue())) {
		draftManId = userInfo.getUserId();
	} else {
		draftManId = (String) draftmanidentity.getValue();
	}
	String department = "";
	FieldEntity departmententity = (FieldEntity) request.getAttribute("department");
	if (departmententity == null || departmententity.getValue() == null || "".equals(departmententity.getValue())) {
		department = groupInfo.getGroupname();
	} else {
		department = (String) departmententity.getValue();
	}
	String departmentId = "";
	FieldEntity departmentidentity = (FieldEntity) request.getAttribute("departmentid");
	if (departmentidentity == null || departmentidentity.getValue() == null || "".equals(departmentidentity.getValue())) {
		departmentId = groupInfo.getGroupId();
	} else {
		departmentId = (String) departmentidentity.getValue();
	}

	String getIssueYear = format.format(new java.util.Date()).substring(0, 4);
	String getSendIssueYear = format.format(new java.util.Date()).substring(0, 4);
	FieldEntity senddateentity = (FieldEntity) request.getAttribute("senddate");
	FieldEntity getdateentity = (FieldEntity) request.getAttribute("getdate");
	FieldEntity issueyearentity = (FieldEntity) request.getAttribute("issue_year");
	FieldEntity sendissueyearentity = (FieldEntity) request.getAttribute("send_issue_year");
	FieldEntity issuetimeentity = (FieldEntity) request.getAttribute("issuetime");
	SimpleDateFormat issuetimeformat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String requestId = "";
	if (docIdField == null || docIdField.getValue() == null || "".equals(docIdField.getValue())) {
		curdate = format.format(new Date()).toString();
		senddate = format.format(new Date()).toString();
		getdate = format.format(new Date()).toString();
		issuetime = issuetimeformat.format(new Date()).toString();
		onclick = "openCalendar(this);";
	} else {
		curdate = format.format(new Date()).toString();
		senddate = senddateentity.getValue().toString();
		getdate = getdateentity.getValue().toString();
		issuetime = issuetimeformat.format(new Date()).toString();
		getIssueYear = (String) issueyearentity.getValue();
		getSendIssueYear = (String) sendissueyearentity.getValue();
		requestId = (String) docIdField.getValue();
	}

	String xzyj = "";
	String fxzyj = "";
	String xfbzryj = "";
	String xzyj_flownote = "县长意见";
	String fxzyj_flownote = "副县长意见";
	String xfbzryj_flownote ="县府办主任意见";
	String fknr="";
	if(docUNID!=null&&!docUNID.equals("")){
	Instance curInstance = WorkflowFactory.getFlowInstanceManager().getFlowInstance("getshou", docUNID);
	String instanceId = curInstance.getInstanceId();

	xzyj = getDealMessage(instanceId,xzyj_flownote);
	fxzyj = getDealMessage(instanceId,fxzyj_flownote);
	xfbzryj =getDealMessage(instanceId,xfbzryj_flownote);
	fknr=xzyj+"o"+fxzyj+"o"+xfbzryj;
	fknr=fknr.replaceAll("o","\n");
	}
	FlowTransmitInfo flowTransmitInfo = (FlowTransmitInfo) request.getAttribute("flowTransmitInfo");
	Flow  active=null;
	String activeName="";
	if (flowTransmitInfo.getCurFlow() != null) {
		active = flowTransmitInfo.getCurFlow();
		if (active != null) {
			activeName = active.getFlowName();
			System.out.println("activeName:"+activeName);
		}
	}
	String titleShow="";
	if(activeName.equals("传阅件流程")){
		titleShow="传阅件-";
	}
	String title=getAttr(request,"title",titleShow);
%>
<%!
    public String getDealMessage(String instanceId,String flownote)throws Exception{
	    String result = "";
		SimpleDateFormat format = new SimpleDateFormat("yyyy年M月d日");
	    RequestDAO dao = DAOFactory.getRequestDAO();
		ArrayList requestList = (ArrayList) dao.getRequestListByInstanceIdAndDescription(instanceId, flownote);
		for (int i = 0; i < requestList.size(); i++) {
			Request oldRequest = (Request) requestList.get(i);
			String participant_cn = UserManagerFactory.getUserManager().findUser(oldRequest.getParticipant()).getUsername();
			if (oldRequest.getMessage() != null&&!oldRequest.getMessage().equals("")) {
				result += format.format(oldRequest.getReqTime())+" "+oldRequest.getActivName()+" "+participant_cn + "：" + oldRequest.getMessage() + "  ";
			} else {
				result="";
			}
		}
		return result;
	}
%>
<form action="<%=request.getContextPath()%>/save" method="post" enctype="multipart/form-data" onSubmit="return validateContext();">
	<input type="hidden" name="xmlName" value="<%=(String)request.getAttribute("xmlName")%>">
	<input type="hidden" name="xmlType" value="<%=(String)request.getAttribute("xmlType")%>">
	<input type="hidden" name="moduleId" value="getshou"/>
	<input type="hidden" name="draftman" value="<%=draftMan%>"/>
	<input type="hidden" name="draftmanid" value="<%=draftManId%>"/>
	<input type="hidden" name="department" value="<%=department%>"/>
	<input type="hidden" name="departmentid" value="<%=departmentId%>"/>
	<input type="hidden" name="issuetime" value="<%=issuetime%>"/>
	<input type="hidden" name="receivedepid" value="<%=receivedepid%>"/>
	<input type="hidden" name="issueflag" value="1"/>
	<input type="hidden" name="rangelist" value="<%=fknr%>"/>
	<input type="hidden" name="rangeidlist" value='未下发'/>
	<html:hidden name="requestid"></html:hidden>
	<table border="0" align="center" cellpadding="0" cellspacing="0" class="round">
		<tr>
			<td class="title">收文登记处理单</td>
		</tr>
		<tr>
			<td>
				<TABLE id="baseinfo" width="99%" border="0" align="center" cellpadding="0" cellspacing="0" class="table">
					<TR VALIGN=top>
						<TD WIDTH="120px" VALIGN=middle class="deeptd">
							<DIV ALIGN=center>标题<font color="red">*</font></DIV>
						</TD>
						<TD COLSPAN=3 class="tinttd">
							<html:text name="title" value="<%=title%>"></html:text>
						</TD>
					</TR>
					<TR VALIGN=top>
						<TD WIDTH="120px" VALIGN=middle class="deeptd">
							<DIV ALIGN=center>来文文号<!--<font color="red">*</font>--></DIV>
						</TD>
						<TD class="tinttd" colspan="3">
							<html:text style="width:160px" name="send_issue_dep_code"/>号
						</TD>
						<!-- <TD WIDTH="120px" VALIGN=middle class="deeptd">
							<DIV ALIGN=center>内部编号<%if (!"".equals(unid)) {%><font color="red">*</font><%}%></DIV>
						</TD>
						<TD class="tinttd" nowrap style="width:40%">
							<div id="issuediv" <%if("".equals(unid)){%>style="display:none;"<%}%>>
								<html:text style="width:80px;display:none" name="issue_dep_code"/>
								〔<html:text style="width:40px" name="issue_year" value="<%=getIssueYear%>"/>〕
								<html:text style="width:40px" name="issue_num"/>号
							</div>〔<html:write name="issue_year"/>〕<html:write name="issue_num"/>号
						</TD> -->
					</TR>
					<TR VALIGN=top>
						<TD WIDTH="120px" VALIGN=middle class="deeptd">
							<DIV ALIGN=center>来文文号</DIV>
						</TD>
						<TD class="tinttd">
							<html:text name="senddep"  />
							<html:hidden name="senddepid"  style="display:none"/>
						</TD>
						<TD WIDTH="120px" VALIGN=middle class="deeptd">
							<DIV ALIGN=center>来文分类</DIV>
						</TD>
						<TD class="tinttd" style="width:40%">
							<html:select name = "receivedep" style="width:150px">
		                            <html:option value = "上级OA来文">上级OA来文</html:option>
		                            <html:option value = "上级纸质来文">上级纸质来文</html:option>
		                             <html:option value = "其他纸质来文">其他纸质来文</html:option>
		                    </html:select>
						</TD>
					</TR>
					<TR VALIGN=top>
						<TD WIDTH="120px" VALIGN=middle class="deeptd">
							<DIV ALIGN=center>来文日期<!--<font color="red">*</font>--></DIV>
						</TD>
						<TD class="tinttd">

							<html:text readonly="true" style="width:100px;" styleClass="Wdate" onclick="WdatePicker();" name="senddate" value="<%=senddate%>"></html:text>
						</TD>
						<TD WIDTH="120px" VALIGN=middle class="deeptd">
							<DIV ALIGN=center>接收日期</DIV>
						</TD>
						<TD class="tinttd">
							<html:text readonly="true" name="getdate" value="<%=getdate%>"></html:text>
						</TD>
					</TR>
					<TR VALIGN=top style="display:none">
						<TD WIDTH="120px" VALIGN=middle class="deeptd">
							<DIV ALIGN=center>正文</DIV>
						</TD>
						<TD colspan="3" class="tinttd">
							<html:attachment moduleid="getshou" unid="requestid" type="contentattach" showdelete="true"/>
							<html:file name="contentattach"/>
						</TD>
					</TR>
					<TR VALIGN=top>
						<TD WIDTH="120px" VALIGN=middle class="deeptd">
							<DIV ALIGN=center>附件</DIV>
						</TD>
						<TD class="tinttd" colspan="3">
							<div id="attachment">
								<html:attachment moduleid="getshou" unid="requestid" type="attach" showdelete="true"/>
								<html:file name="attach"/>
							</div>
						</TD>
					</TR>
					<!-- <%
						if (aclManager.isOwnerRole(userID, "requestprint") || aclManager.isOwnerRole(userID, "sysadmin")) {
					%> -->
					
					<TR VALIGN=top>
						<TD WIDTH="120px" VALIGN=middle class="deeptd">
							<DIV ALIGN=center>协同配合单位</DIV>
						</TD>
						<TD COLSPAN=3 class="tinttd">
							<html:text name="copydep" style="width:95%"></html:text>
							<img src="<%=request.getContextPath()%>/resources/images/actn133.gif" onClick="window.showModalDialog('<%=request.getContextPath()%>/address/tree.jsp?utype=1&sflag=0&count=0&fields=copydep,copydepid',window,'status:no;dialogWidth:300px;dialogHeight:380px;scroll:no;help:no;')">
						</TD>
					</TR>
					<!-- <%}%> -->
					<!-- <tr valign="top" style="display:none">
							                <td width="120px" VALIGN=middle class="deeptd">
							                    <div align="center" style="color:red;">是否督办</div>
							                </td>
							            <%if(receivedepid.equals("是")){%>    
							                <td class="tinttd"  colspan="3">
							                    <input type="radio" name="receivedepid" checked=checked  value="是" />是&nbsp;
							<input type="radio" name="receivedepid"  value="否" />否&nbsp;
							                </td>
							            <%}else{%>
							            	<td class="tinttd"  colspan="3">
							            		<input type="radio" name="receivedepid"  value="是" />是&nbsp;
							<input type="radio" name="receivedepid" checked=checked  value="否" />否&nbsp;
						</td>
							            <%}%>
							            </tr> -->
				</TABLE>
				<BR>
				<table border="0" width="100%">
					<tr>
						<td>
							<jsp:include page="/workflow/history.jsp"/>
							<jsp:include page="/workflow/operation.jsp"/>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td height="30">
				<DIV align="center">
					<input type="submit" name="submitContent" class="formbutton defaultbtn" value="提  交" onclick="if(chkform()){setSubmitMethod('2');return checkperformer(submitFlow());}else{return false;}"/>
					<input type="submit" name="saveContent" class="formbutton" style='display:none;' value="保存草稿" onclick="if(chkform()){setSubmitMethod('0');submitFlow();}else{return false;}"/>

					<%if(!docUNID.equals("")){%>
					<input type="submit" name="qianshou" class="formbutton defaultbtn"  value="签  收" onclick="qians();"/>
					<%}%>

					<input type="submit" name="finishContent" class="formbutton defaultbtn"  value="办结归档" onclick="if(chkform()){setSubmitMethod('4');}else{return false;}"/>
					

					<input type="submit" name="delContent" class="formbutton" style='display:none;' value="删  除" onclick="setSubmitMethod('9');document.all.xmlType.value='delete';return confirmDelete();"/>
					
					<%
						if (aclManager.isOwnerRole(userID, "sysadmin")) {
					%>
					<!--
					<input type="submit" class="formbutton" value="删  除" onclick="setSubmitMethod('9');document.all.xmlType.value='delete';return confirmDelete();"/>
					-->
					<%}%>
					<!--
					 <div id="smsreminddiv" style="display:block"><input class=checkbox type=checkbox name=issmsremindchk id=issmsremindchk onpropertychange="if(this.checked){document.getElementById('issmsremind').value=1}else{document.getElementById('issmsremind').value=0};"><label for=issmsremindchk>短信提醒下一步操作人员</label><input type=hidden name=issmsremind id=issmsremind value="0"></div>
					 -->
				</DIV>
			</td>
		</tr>
	</table>
</form>
<jsp:include page="/workflow/appbinding.jsp"/>
<script>
	function openNew()
    {	
    	var title=$("[name=title]").val();
    	var fknr="<%=fknr%>";
        var ret_val;//接受返回值
        //var strReturn;//返回值处理后存的变量
        // var url = "bm_select.aspx";
        var url="<%=request.getContextPath()%>/getshou/openContent.jsp?title="+encodeURIComponent(encodeURIComponent(title,"utf-8"))+"&fknr="+encodeURIComponent(encodeURIComponent(fknr,"utf-8"))+"&docunid=<%=docUNID%>";
        var sFeatures = "dialogHeight: 800px; dialogWidth: 700px; center: Yes; help: No; resizable: No; status: No;toolbar: No;menubar:No;";
        ret_val = window.showModalDialog (url,"",sFeatures);
        if(ret_val=="ok"){ 	
	    	return true;

    	}else{
    		alert(督办不成功);
    		return false;	
    	} 
    	   
    }
	function openNewl()
            {
             	var title=$("[name=title]").val();	
                var width = 800;
                var height = 700;
                var iTop = (window.screen.availHeight - 30 - width) / 2;
                var iLeft = (window.screen.availWidth - 10 - height) / 2;
                var win = window.open("<%=request.getContextPath()%>/getshou/openContent.jsp?title="+title+"&docunid=<%=docUNID%>&fknr=<%=fknr%>", "弹出窗口", "width=" + width + ", height=" + height + ",top=" + iTop + ",left=" + iLeft + ",toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no,alwaysRaised=yes,depended=yes"); 
            }
    function goback(ret_val){    	
    	if(ret_val=="ok"){ 		
	    	return true;
    	}
    	return false;
    }
</script>
<%
	if (requestId != null && !"".equals(requestId)) {%>
<div style="display:none;">
	<jsp:include page="docread.jsp">
		<jsp:param name="unid" value="<%=requestId%>"/>
		<jsp:param name="xmlName" value="getshou"/>
		<jsp:param name="showread" value="1"/>
		<jsp:param name="showreply" value="0"/>
		<jsp:param name="rereply" value="0"/>
	</jsp:include>
</div>
<%}%>
</template:put>
</template:insert>
<%}%>
