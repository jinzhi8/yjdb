<%@ page language="java" contentType="text/html;charset=utf-8" %>

<%@page import="com.kizsoft.commons.acl.ACLManager" %>
<%@page import="com.kizsoft.commons.acl.ACLManagerFactory" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.component.entity.FieldEntity" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Date" %>
<%@page import="java.util.List" %>
<%@page import="java.util.Map" %>
<%@ page import="com.kizsoft.commons.workflow.FlowTransmitInfo" %>
<%@page import="com.kizsoft.commons.commons.orm.SimpleORMUtils"%>
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
			String rangeidlist=getAttr(request,"rangeidlist","");
			SimpleORMUtils instance=SimpleORMUtils.getInstance();
			List<Map<String,Object>> list=instance.queryForMap("select * from DOCUMENTS where documentsid=?",requestid);
			String main_send="";
			String copy_to="";
			String copy_to_user="";
			if(list.size()!=0){
				Map<String,Object> map=list.get(0);
				main_send=(String)map.get("main_send")==null?"":(String)map.get("main_send")+" ";
				copy_to=(String)map.get("copy_to")==""?"":(String)map.get("copy_to")+" ";
				copy_to_user=(String)map.get("copy_to_user");
				main_send=main_send+copy_to+copy_to_user;
			}
			
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
		<form action="<%=request.getContextPath()%>/save" method="post" enctype="multipart/form-data" onSubmit="return validateContext();">
			<input type="hidden" name="xmlName" value="<%=(String)request.getAttribute("xmlName")%>">
			<input type="hidden" name="xmlType" value="<%=(String)request.getAttribute("xmlType")%>">
			<input type="hidden" name="moduleId" value="getshou"/>
			<input type="hidden" name="issuetime" value="<%=curdate%>"/>
			<input type="hidden" name="issueflag" value="1"/>
			<html:hidden name="requestid"></html:hidden>
			<table border="0" align="center" cellpadding="0" cellspacing="0" class="round">
				<tr>
					<td class="title">收文登记处理单</td>
				</tr>
				<tr>
					<td align="center">
						<TABLE width="99%" border="0" align="center" cellpadding="0" cellspacing="0" class="table">
							<TR VALIGN=top>
								<TD WIDTH="120px" VALIGN=middle class="deeptd">
									<DIV ALIGN=center>标题<font color="red">*</font></DIV>
								</TD>
								<TD COLSPAN="3" class="tinttd">
									<html:write name="title"/>
								</TD>
							</TR>
							<TR VALIGN=top>
								<TD WIDTH="120px" VALIGN=middle class="deeptd">
									<DIV ALIGN=center>来文文号<font color="red">*</font></DIV>
								</TD>
								<TD class="tinttd" colspan="3">
									<html:write name="send_issue_dep_code"/>
									<html:write name="send_issue_year"/>
									<html:write name="send_issue_num"/>号
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
									<DIV ALIGN=center>来文文号</DIV>
								</TD>
								<TD class="tinttd">
									<html:write name="senddep"/>
									<html:hidden name="senddepid" style="display:none"/>
								</TD>
								<TD WIDTH="120px" VALIGN=middle class="deeptd">
									<DIV ALIGN=center>来文分类</DIV>
								</TD>
								<TD class="tinttd">
									<html:write name="receivedep"/>
									<html:hidden name="receivedepid" style="display:none"/>
								</TD>
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
									<html:attachment moduleid="getshou" unid="requestid" type="contentattach" showdelete="false"/> &nbsp;
								</TD>
							</TR>
							<TR VALIGN=top>
								<TD WIDTH="120px" VALIGN=middle class="deeptd">
									<DIV ALIGN=center>附件</DIV>
								</TD>
								<TD class="tinttd" COLSPAN="3">
									<div id="attachdiv">
										<html:attachment moduleid="getshou" unid="requestid" type="attach" showdelete="false"/>&nbsp;
									</div>
								</TD>
							</TR>
							<TR VALIGN=top>
								<TD WIDTH="120px" VALIGN=middle class="deeptd">
									<DIV ALIGN=center>下发状态</DIV>
								</TD>
								<TD class="tinttd">
									<html:write name="rangeidlist"></html:write>
								</TD>
								<TD WIDTH="120px" VALIGN=middle class="deeptd">
									<DIV ALIGN=center>下发时间</DIV>
								</TD>
								<TD class="tinttd">
									<html:write name="xftime"></html:write>
								</TD>
							</TR>
							<TR VALIGN=top>
								<TD WIDTH="120px" VALIGN=middle class="deeptd">
									<DIV ALIGN=center>接收人员</DIV>
								</TD>
								<TD COLSPAN="3" class="tinttd">
									<%=main_send%>
								</TD>
							</TR>
							<!-- <TR VALIGN=top style="display:none">
								<TD WIDTH="120px" VALIGN=middle class="deeptd">
									<DIV ALIGN=center style="color:red;">是否督办</DIV>
								</TD>
								<TD COLSPAN="3" class="tinttd">
									<html:write name="receivedepid"/>
								</TD>
							</TR> -->
							
						</TABLE>
						</br>
						<%
							if ("2".equals(flowTransmitInfo.getCurInstance().getInstanceStatus())) {
						%>
							<!-- <a  class="viewbutton" hidefocus href="javascript:selectFlow('zwdb');"><span>转入督办并分配</span></a> -->
						<%if(!rangeidlist.equals("已下发")){%>	
							<a  class="viewbutton" hidefocus href="javascript:selectxf();"><span>下发部门</span></a>
						<%}%>
						<%if(rangeidlist.equals("已下发")){%>	
							<a  class="viewbutton" hidefocus href="javascript:qh();"><span>取回</span></a>
						<%}%>		
							<a class="viewbutton" target="_blank" href="<%=request.getContextPath()%>/getshou/request.jsp?id=<html:write name="requestid"/>"><span>打印收文登记处理单</span></a>
						<%}%>
					</td>
				</tr>
			</table>
		</form>
		<BR>
		<script type="text/javascript">
			function updatestatus(status){
			    var unid="<%=requestid%>";
			        $.ajax({ 
			                async: true, 
			                type : "POST", 
			                url : "<%=request.getContextPath()%>/getshou/updatestatus.jsp?",
			                cache: false,                      
			                data : {
			                    unid:unid,
			                    status:status  
			            },
			            success:function(data){               
			            }
			        });
			}
			function qh(){
			    var unid="<%=requestid%>";
			        $.ajax({ 
			                async: true, 
			                type : "POST", 
			                url : "<%=request.getContextPath()%>/getshou/qh.jsp?",
			                cache: false,                      
			                data : {
			                    unid:unid,
			                    status:status  
			            },
			            success:function(data){  
			            	window.location.href=window.location.href;             
			            }
			        });
			}
			function selectxf(){
				updatestatus('1');
				window.location.href = "<%=request.getContextPath()%>/getshou/tosend.jsp?id=<html:write name="requestid"/>";
			}

			function selectFlow(moduleID){
				updatestatus('0');
				var urlstr = "<%=request.getContextPath()%>/getshou/selectFlow.jsp?docunid=<%=requestid%>&moduleID="+moduleID;
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

