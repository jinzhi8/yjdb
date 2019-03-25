<%@ page language="java" contentType="text/html;charset=utf-8" %>
<!DOCTYPE html>
<html>
<head>
<%
	//用户登陆验证
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
	}
%>
	<meta charset="utf-8">
	<title>督办统计</title>
	<meta name="renderer" content="webkit">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
	<meta name="apple-mobile-web-app-status-bar-style" content="black">
	<meta name="apple-mobile-web-app-capable" content="yes">
	<meta name="format-detection" content="telephone=no">
	<link rel="stylesheet" href="../js/layui/css/layui.css" media="all" />
	<link rel="stylesheet" href="../yj_dbhf/field.css" media="all" />
	<link rel="stylesheet" href="../js/layui/css/public.css" media="all"/>
</head>
<body style="padding:10px">
<form class="layui-form">
	<table id="tableList" lay-filter="newsList"></table>
	<!--操作-->
	<script type="text/html" id="newsListBar">
		<a class="layui-btn layui-btn-xs" lay-event="edit"><i class="layui-icon layui-icon-edit"></i>编辑</a>  
		<a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del"><i class="layui-icon layui-icon-delete"></i>删除</a>
		<a class="layui-btn layui-btn-xs layui-btn-primary" lay-event="dbtj">预览</a>
	</script>
</form>
<script>
	var unid = '<%=request.getParameter("unid")%>';
</script>
<script type="text/javascript" src="../js/layui/layui.js"></script>
<script type="text/javascript" src="dbtj.js?v=<%=Math.random()%>"></script>
<script type="text/html" id="state">
要求反馈：{{d.fkzqnum}}
	{{# if(d.fknum != null){ }}
		<a class="layui-table-link" href="javascript:;" lay-event="look">已反馈：{{d.fknum}}</a>
	{{# } else { }}
		<span>已反馈：0</span>
	{{# } }}
</script>
<script type="text/html" id="titleTpl">
    	<div>{{#  if(d.whstatus == "1"){ }}<span class="break-sign snail"></span>{{# }}}{{#  if(d.whstatus == "2"){ }}<span class="break-sign redflag"></span>{{# }}}{{d.ownername}}</div>
</script>
<form id="forma" class="layui-from" style="padding:5px;display:none">
	<table class="layui-table">
		<colgroup>
			<col width="100">
			<col>
		</colgroup>
		<tbody>
			<tr>
				<td id="zttitle"></td>
				<td id="zt"></td>
			</tr>
			<tr>
				<td>发送内容</td>
				<td><textarea id="dbnra" placeholder="请输入内容" class="layui-textarea"></textarea></td>
			</tr>
		</tbody>
	</table>
</form>
</body>
</html>