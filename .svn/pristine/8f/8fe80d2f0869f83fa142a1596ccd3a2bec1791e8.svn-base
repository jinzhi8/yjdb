<%@ page import="com.kizsoft.yjdb.utils.CommonUtil" %>
<%@ page language="java" contentType="text/html;charset=utf-8" %>
<!DOCTYPE html>
<html>
<head>
<%
	//用户登陆验证
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
	}
	//首页点击
	String num = CommonUtil.doStr(request.getParameter("num"));
	String dtype = CommonUtil.doStr(request.getParameter("dtype"));
	String type = CommonUtil.doStr(request.getParameter("type"));
	String hyid = CommonUtil.doStr(request.getParameter("hyid"));
	String v = CommonUtil.doStr(request.getParameter("v"));//如果v=521则表示是从首页点击日历跳转来的，需要过滤掉办结，挂起的件
%>
	<meta charset="utf-8">
	<title>督办件回复</title>
	<meta name="renderer" content="webkit">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
	<meta name="apple-mobile-web-app-status-bar-style" content="black">
	<meta name="apple-mobile-web-app-capable" content="yes">
	<meta name="format-detection" content="telephone=no">
	<link rel="stylesheet" href="../js/layui/css/layui.css" media="all" />
	<link rel="stylesheet" href="../js/layui/css/public.css" media="all"/>
	<script>var num = '<%=num%>';dtype = '<%=dtype%>',hyid='<%=hyid%>',v='<%=v%>',type='<%=type%>'</script>
</head>
<body class="childrenBody">
<form class="layui-form">
	<blockquote class="layui-elem-quote quoteBox newclass-bw-quoteBox">
		<form class="layui-form" lay-filter="formDemo">
			<div class="layui-inline">
				<div class="layui-input-inline">
					<input type="text" name="title" class="layui-input" placeholder="请输入搜索的内容" />
				</div>
				<a class="layui-btn" lay-submit lay-filter="formsubmit2"><i class="layui-icon layui-icon-search"></i>搜索</a>
			</div>
		<!-- 	<div class="layui-inline">
				<a id="pldc" class="layui-btn layui-btn-noremal layui-btn-normal import_btn">批量导出</a>
			</div>
			 -->
			<div class="layui-inline">
				<select name="state" lay-verify="" lay-filter="state">
				  <option value="">请选择一办结状态</option>
				  <option value="0">未办结</option>
				  <option value="1">已办结</option>
				</select>
			</div>
			<div class="layui-inline">
				<select name="lsqk" lay-verify="lsqk" lay-filter="lsqk">
				  <option value="">请选择一落实情况</option>
				  <option value="0">两个月以内未落实</option>
				  <option value="1">三个月以内未落实</option>
				  <option value="2">三个月以上未落实</option>
				</select>
			</div>
			<div class="layui-inline">
				<a class="layui-btn biaoji"><i class="layui-icon">&#xe67a;</i>标记</a>
				<button type="button" class="layui-btn chaogao">协同配合<span class="layui-badge layui-bg-gray" style="display:none"></span></button>
			</div>
			<div class="layui-inline">
				<select name="ishy" lay-verify="type" id="ishy">
					<option value="">请选择一督办件类型</option>
					<option value="1">会议件</option>
					<option value="0">批示件</option>
				</select>
			</div>
			<div class="layui-inline">
				<button type="button" class="layui-btn" lay-submit lay-filter="formsubmit"><i class="layui-icon layui-icon-export"></i>批量导出</button></div>
			</div>

		<%--<div class="layui-inline">
				<a class="layui-btn run"><i class="layui-icon">&#xe67a;</i>run</a>
			</div>--%>
		</form>
	</blockquote>
	<table id="tableList" lay-filter="newsList"></table>
	<!--操作
	<script type="text/html" id="newsListBar">
		<a class="layui-btn layui-btn-xs layui-btn-primary" lay-event="look">预览</a>
	</script>-->
</form>
<script type="text/javascript" src="../js/layui/layui.js"></script>
<script type="text/javascript" src="tableList.js?v=<%=Math.random()%>"></script>
<script type="text/html" id="titleTpl">
	{{# if( d.ystate == "0" || d.ystate == null ) { }}
		{{# if(d.important == "1") { }}
		<i style="font-size: 20px; color: #FF5722;" class="layui-icon">&#xe67a;</i>{{#  if(d.dbwhstatus == "1"){ }}<span class="break-sign snail"></span>{{# }}}{{#  if(d.dbwhstatus == "2"){ }}<span class="break-sign redflag"></span>{{# }}}<i class="stateicon stateicon-blue">未读</i><a class="layui-table-link">{{d.title}}</a>
		{{# } else { }}
	{{#  if(d.dbwhstatus == "1"){ }}<span class="break-sign snail"></span>{{# }}}{{#  if(d.dbwhstatus == "2"){ }}<span class="break-sign redflag"></span>{{# }}}<i class="stateicon stateicon-blue">未读</i><a class="layui-table-link">{{d.title}}</a>
		{{# } }}
	{{# } else { }}
		{{# if(d.important == "1") { }}
		<i style="font-size: 20px; color: #FF5722;" class="layui-icon">&#xe67a;</i><i class="stateicon stateicon-red">已读</i><a class="layui-word-aux">{{d.title}}</a>
		{{# } else { }}
		{{#  if(d.dbwhstatus == "1"){ }}<span class="break-sign snail"></span>{{# }}}{{#  if(d.dbwhstatus == "2"){ }}<span class="break-sign redflag"></span>{{# }}}<a class="layui-word-aux"><i class="stateicon stateicon-green">已读</i>{{d.title}}</a>
		{{# } }}
	{{# } }}
</script>
<script type="text/html" id="state">
 		{{# if(d.state == "1"){ }}

			{{# if(d.ystate == "3"){ }}
				<span style="color:#009688">已办结</span>	
			{{# } else { }}
				{{# if(d.bjsq == "1") { }}
					<span style="color:#009688">已申请办结</span>	
				{{# } else if(d.gqsq == "1"){ }}
					<span style="color:#009688">已申请挂起</span>	
				{{# } else if(d.gqsq == "2" || d.gqsq == "3" || d.gqstate == "1"){ }}
					<span style="color:#009688">已挂起</span>	
				{{# } else if(d.ystate == "2"){ }}
					<span style="color:#009688">已反馈</span>	
				{{# } else if(d.ystate == "1"){ }}
					{{# if(d.time > 0){ }}
						<span style="color:#ff5722">超时未反馈</span>
					{{# } else{ }}
						<span style="color:#ff5722">未反馈</span>
					{{# }}}
				{{# } else { }}
					<span style="color:#ff5722">未签收</span>	
				{{# } }}	
			{{# } }}
		{{# } else if(d.state == "2") { }}
			<span style="color:#009688">已办结</span>	
		{{# } }}
</script>
<script type="text/html" id="hftime">
  {{# if(d.fklx == 1) { }}
	{{d.yjbsx == null ? "暂无":d.yjbsx}}【期限性】
  {{# } else if(d.fklx == 2) { }}
	{{d.yjbsx == null ? "暂无":d.yjbsx}}【周期性】
  {{# } else if(d.fklx == 3) { }}
	{{d.yjbsx == null ? "暂无":d.yjbsx}}【每月定期】
  {{# } else if(d.fklx == 4) { }}
	{{d.yjbsx == null ? "暂无":d.yjbsx}}【特定星期】
  {{# } }}
</script>
<script type="text/html" id="jbsx">
	{{# if(d.ystate != "3"&&d.iscs=="1" &&d.gqsq!="2"&&d.gqsq!='3') { }}
		<span style="color:red">{{d.jbsx}}</span>
	{{# } else  { }}
		{{d.jbsx}}
	{{# } }}
</script>
</body>
</html>