<%@page language="java" contentType="text/html;charset=UTF-8" %>

<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.commons.orm.SimpleORMUtils"%>
<%@page import="java.util.Map" %>
<%
	//用户登陆验证
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
		return;
	}
	User userInfo = (User) session.getAttribute("userInfo");
	String userID = userInfo.getUserId();
	String userName = userInfo.getUsername();
	Group groupInfo = userInfo.getGroup();
	String groupID = groupInfo.getGroupId();
	
	String unid=request.getParameter("unid");
	String title="反馈修改";
	SimpleORMUtils instance=SimpleORMUtils.getInstance();
	
	Map<String,Object> map=instance.queryForUniqueMap("select * from ZWDBFKPG where unid=?",unid);
	
	
	
%> 
<html>
<head>
	<title><%=title%></title>
	<link href="<%=request.getContextPath()%>/resources/template/cn/css/css.css" rel="stylesheet" type="text/css">
	<script language="javascript" type="text/javascript" charset="utf-8" src="<%=request.getContextPath()%>/resources/js/jquery/jquery.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath()%>/zwdb/lib/jquery.raty.min.js"></script>
	<script type="text/javascript" src="<%=request.getContextPath()%>/zwdb/lib/jquery-form.js"></script> 
</head>
<body>
	<table border="0" align="center" cellpadding="0" cellspacing="0" class="round">

		<tr>
			<td>
			<form id='fileForm' enctype='multipart/form-data'>
				<TABLE align="center" cellpadding=1 BORDER="0" CELLSPACING=0 class="table">

					<tr VALIGN=top>
						<td width="80px" VALIGN="middle" class="deeptd">
							<div align="center">反馈内容</div>
						</td>
						<td class="tinttd" colspan="3">
							<textarea name="fklsqk" rows=5><%=map.get("fklsqk")%></textarea>
						</td>
					</tr>
					<tr VALIGN=top>
						<td width="80px" VALIGN="middle" class="deeptd">
							<div align="center">反馈附件</div>
						</td>
						<td class="tinttd" colspan="3">
							<!-- <a href="<%=request.getContextPath()+(String)map.get("fkattachpath")%>"><%=(String)map.get("fkattachname")%></a><br/> -->
							<input type="file" name="fkattach" style="width:98%">
						</td>
					</tr>

				</TABLE>
				<br/>
				<div style="text-align:center">
					<input type="hidden" name="unid" value="<%=unid%>">
					<input type="button" class="formbutton" value="修 改" onclick="edit();"/>
					<input type="button" class="formbutton" value="关 闭" onclick="window.close();"/>
				</div>
				</form>
			</td>
		</tr>
	</table>
	
<script>
	function edit(){
		if(!confirm("是否进行修改？"))
			return;
		 $("#fileForm").ajaxSubmit({
            type: "post",
            url: "<%=request.getContextPath()%>/zwdbfk/updatefk.jsp",
            success: function (data) {
				if(trim(data)=='ok'){
					window.returnValue = "ok";
					window.close();
				}else{
					alert("系统异常，请重试！");
				}
            }
        });
	}
	
	function trim(str){ //删除左右两端的空格
		if(str==''){
			return '';
		}
　　     return str.replace(/(^\s*)|(\s*$)/g, "");
　　 }
</script>
	
<body>
<html>