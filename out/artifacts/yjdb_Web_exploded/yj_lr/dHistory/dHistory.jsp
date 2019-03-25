<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="java.util.Date"%>
<%@page import="java.util.Map"%>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.yjdb.utils.CommonUtil" %>
<%@page import="com.kizsoft.commons.commons.orm.MyDBUtils"%>
<%@page import="com.kizsoft.yjdb.utils.GsonHelp"%>
<html>
<head>
<%
	//用户登陆验证
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
	}
	User userInfo = (User) session.getAttribute("userInfo");
	String userID = userInfo.getUserId();
	String userName = userInfo.getUsername();
	Group groupInfo = userInfo.getGroup();
	String groupName = groupInfo.getGroupname();
	String groupID = groupInfo.getGroupId();
	String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
    String docunid=CommonUtil.doStr(request.getParameter("docunid"));
%>
	<meta charset="utf-8">
	<title>批示件督办</title>
	<meta name="renderer" content="webkit">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
	<meta name="apple-mobile-web-app-status-bar-style" content="black">
	<meta name="apple-mobile-web-app-capable" content="yes">
	<meta name="format-detection" content="telephone=no">
	<link rel="stylesheet" href="../../js/layui/css/layui.css" media="all" />
	<link rel="stylesheet" href="../../css/public.css" media="all" />		
	<script type="text/javascript" src="../../js/layui/layui.js"></script>
	<script type="text/javascript" src="../../js/jquery-1.11.0.min.js"></script>
	<script language="javascript" type="text/javascript" charset="utf-8" src="history.js"></script>	
	<script>
		var docunid="<%=docunid%>";
	</script>
</head>
<body class="childrenBody">
	<form class="layui-form layui-form-pane newclass-layui-form" action="<%=contextPath%>/yj_common/save.jsp"  id="infoform" enctype="multipart/form-data" method="post" >	
		<div class="layui-form-item">
			<table style='width:100%;' class="table01 newclass-table01" id="return">
				<input type="hidden" id="trnum" name="trnum" value="0">
				<tr>
					<TD VALIGN=middle style="width:10%;font-size:14;">
						<DIV ALIGN=center >姓名</DIV>
					</TD>
					<TD VALIGN=middle style="width:70%;font-size:14;">
						<DIV ALIGN=center >推送内容</DIV>
					</TD>
					<TD VALIGN=middle style="width:20%;font-size:14;">
						<DIV ALIGN=center>推送结果</DIV>
					</TD>
				</tr>	
			</table>
		</div>
	</form>
</body>
</html>