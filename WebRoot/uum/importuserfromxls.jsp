<%@page language="java" contentType="text/html;charset=UTF-8" %>

<%@page import="com.kizsoft.commons.acl.ACLManager" %>
<%@page import="com.kizsoft.commons.acl.ACLManagerFactory" %>
<%@page import="com.kizsoft.commons.commons.db.ConnectionProvider" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<%@taglib prefix="html" uri="/WEB-INF/oa-html.tld" %>
<%@taglib prefix="oa" uri="/WEB-INF/oa.tld" %>

<script language="javascript" src="<%=request.getContextPath()%>/resources/js/getdoc/getdocform.js"></script>
<script language="javascript" src="<%=request.getContextPath()%>/resources/js/deleteconfig/delconfig.js"></script>
<script language="javascript" src="<%=request.getContextPath()%>/resources/js/calendar.js"></script>
<script language="javascript" src="<%=request.getContextPath()%>/resources/js/addresslist/addressform.js"></script>
<%
String userTemplateName = (String) session.getAttribute("templatename");
String userTemplateStr = "/resources/template/" + userTemplateName + "/template.jsp";
if(userTemplateName==null||"".equals(userTemplateName)){
	userTemplateStr = "/resources/jsp/template.jsp";
}
%>
<template:insert template="<%=userTemplateStr%>">
<template:put name='title' content='用户批量导入' direct='true'/>
<%String str = "<a class=\"menucur\" href=\"import.jsp\">用户批量导入</a>";%>
<template:put name='moduleNav' content='<%=str%>' direct='true'/>
<link rel="stylesheet" href="<%=request.getContextPath() %>/resources/template/cn/layui/css/layui.css" media="all" />
<style type="text/css">
</style>
<template:put name='content'>
<%//用户登陆验证
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
	}
	User userInfo = (User) session.getAttribute("userInfo");
	String userID = userInfo.getUserId();
	Group groupInfo = userInfo.getGroup();
	String groupID = groupInfo.getGroupId();

%>

<SCRIPT LANGUAGE="JavaScript">
	extArray = new Array(".xls");
	
	
	<% 
		String flag=request.getParameter("flag");
		//System.out.println(flag);
		if("1".equals(flag)){
			if (session.getAttribute("msg") != null) {
				String msg=(String)session.getAttribute("msg");
				//System.out.println("alert('"+msg+"');");
				out.println("layer.alert('"+msg+"');");
				session.setAttribute("msg", "");
			}
		}
	%>

	
    
	
</script>
<body style="padding: 10px">
<form action="../userManager/UserImportAction.do" method="post" enctype="multipart/form-data">
<blockquote class="layui-elem-quote">用户批量导入</blockquote>

	<table border="0" align="center" id="table" cellpadding="0" cellspacing="0" class="round" >
		<tr>
			<td>
				<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="table" style="border-left: 1px solid #e2e2e2; border-top: 1px solid #e2e2e2;">
					<TR>
						<TD width="10%" VALIGN=middle class="deeptd" style=" border-right: 1px solid #e2e2e2; border-bottom: 1px solid #e2e2e2; background-color: #f2f2f2;">
							<DIV ALIGN=center>说明</DIV>
						</TD>
						<TD width="90%" class="tinttd" style="border-right: 1px solid #e2e2e2;border-bottom: 1px solid #e2e2e2;" colspan=5>
							<b><font color=red size="5px">注意事项：</font></b><br>
							<li>请下载并解压系统提供的模板文件（格式：XLS 文件：User.xls）后，请把对应数据输入或拷入相应列，再上载附件，<br>&nbsp&nbsp系统将会根据你的附件直接导入单位通讯录或者个人通知录。系统不支持其它的文件上载，这点请大家注意。<br>
							<li><b><font color=red size="3px">请不要添加、删除或移动数据列，将您的数据添加至摸板中相应的列中，<br>&nbsp&nbsp不用或不需要的列请留空！</font></b><br>
							<li><b><font color=red size="3px">中间不要留空行!</font></b><br>
							<li><b><font color=red size="3px">在Excel中编辑时，不要用英文半角的逗号（","）、请改用其他顿号或<br>&nbsp&nbsp中文全角的逗号，否者会造成数据错位。</font></b><br>
							<li><b><font color=red size="3px">出生日期格式：1999-1-1</font></b><br>
								&nbsp&nbsp&nbsp&nbsp<b><font color=red>模板文件下载：</font></b><img src=<%=request.getContextPath()%>/resources/images/text.gif><a href=<%=request.getContextPath()%>/uum/user.zip>&nbsp;模板文件</a>
						</TD>
					</TR>
					<TR>
						<TD width="10%" VALIGN=middle class="deeptd" style=" border-right: 1px solid #e2e2e2; border-bottom: 1px solid #e2e2e2; background-color: #f2f2f2;">
							<DIV ALIGN=center>导入单位</DIV>
						</TD>
						<TD width="90%" class="tinttd" colspan=5 style="border-right: 1px solid #e2e2e2;border-bottom: 1px solid #e2e2e2;"> 
						<html:text style="width:75%" name="importdep" readonly="true"/><img title="树形选择组" id="iimg" src="<%=request.getContextPath()%>/resources/images/actn133.gif">
						<html:hidden name="importdepid" />
						</TD>
					</TR>
					<TR>
						<TD width="10%" VALIGN=middle class="deeptd" style=" border-right: 1px solid #e2e2e2; border-bottom: 1px solid #e2e2e2; background-color: #f2f2f2;">
							<DIV ALIGN=center>用户信息</DIV>
						</TD>
						<TD width="90%" class="tinttd" style="border-right: 1px solid #e2e2e2;border-bottom: 1px solid #e2e2e2;" colspan=5>
							<input type="file" class="" style="width:83%" onkeydown="return false" name="theFile"/>
						</TD>
					</TR>
					
				</TABLE>
				<table border="0" width="100%">
					<tr>
						<td height="30">
							<DIV align="center">
								<input type="submit" name="saveConent" class="formbutton" value="导入" onclick="return LimitAttach(this.form, this.form.theFile.value)"/>
							</DIV>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</form>
<script type="text/javascript" src="<%=request.getContextPath() %>/resources/template/cn/layui/layui.js"></script>
<script type="text/javascript">
var $;
var layer;
	layui.use(['layer','jquery'], function() {
		layer = layui.layer
		,$ = layui.jquery;
		
		$('#iimg').click(function(){
			openSelWin('<%=request.getContextPath()%>/address/tree.jsp?utype=2&rtype=0&ptype=0&sflag=0&count=0&fields=importdep,importdepid'); 
		});
	});
	function LimitAttach(form, file) {
		allowSubmit = false;
		if (!file) {
			layer.alert("请您选择一个文件再导入");
			return false;
		}
		while (file.indexOf("\\") != -1)
			file = file.slice(file.indexOf("\\") + 1);
		ext = file.slice(file.indexOf(".")).toLowerCase();
		for (var i = 0; i < extArray.length; i++) {
			if (extArray[i] == ext) {
				allowSubmit = true;
				break;
			}
		}
		if (allowSubmit) {
			//form.submit();
			return true;
		} else {
			layer.alert("对不起，您只能导入以下格式的文件:  " + (extArray.join("  ")) + "\n请重新选择符合条件的文件再导入.");
			return false;
		}
	}
</script>
<script type="text/javascript" src="<%=request.getContextPath() %>/resources/js/layer/layerFunction.js"></script>
</template:put>
</template:insert>
<!--索思奇智版权所有-->