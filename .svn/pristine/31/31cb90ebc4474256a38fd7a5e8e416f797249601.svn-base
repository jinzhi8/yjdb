<%@ page import="com.kizsoft.yjdb.utils.CommonUtil" %>
<%@ page import="com.kizsoft.commons.commons.orm.MyDBUtils" %>
<%@ page import="java.util.Map" %>
<%@ page language="java" contentType="text/html;charset=utf-8" %>
<!DOCTYPE html>
<html>
<head>
<%
	//用户登陆验证
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
	}
	String unid = CommonUtil.doStr(request.getParameter("unid"));
	String title = "";
	if(!"".equals(unid)){
		Map<String, Object> map = MyDBUtils.queryForUniqueMapToUC("select title from yj_lr where unid = ?", unid);
		title = (String) map.get("title");
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
	<style type="text/css">
		.layui-form-label {
			width:50px
		}
		.layui-input-block {
			margin-left: 80px
		}
		.fontbg {
			font-size: 13px;
			font-weight:bold
		}
		.huise {
			background-color: #f2f2f2
		}
	</style>
</head>
<body style="padding:10px">

	<div>
		<button class="layui-btn layui-btn-sm layui-btn-primary select">
		  <i class="layui-icon">&#x1002;</i>收件箱
		</button>
		<button class="layui-btn layui-btn-sm layui-btn-primary send">
			<i class="layui-icon">&#x1002;</i>发件箱
		</button>
		<button class="layui-btn layui-btn-sm layui-btn-primary add">
		  <i class="layui-icon">&#xe654;</i>新建
		</button>
		<button class="layui-btn layui-btn-sm layui-btn-primary del">
		  <i class="layui-icon">&#xe640;</i>批量删除
		</button>
	</div>
	<hr class="layui-bg-green">
	<!-- 信息 -->
	<div class="tab1">
		<table id="tableList" lay-filter="newsList"></table>
	</div>
	<!-- 新建 -->
	<div class="tab2" style="display:none">
		<form class="layui-form">
			<%--<input type="text" name="unid" hidden value="<%=request.getParameter("unid")%>">--%>
			<input type="text" name="flaga" value="1" hidden>
			<input type="text" name="flagb" value="1" hidden>
			<input type="text" name="flag" value="1" hidden>
			<div class="layui-form-item">
			    <label class="layui-form-label">收件人</label>
			    <div class="layui-input-block">
			      <input type="text" name="sname" required readonly lay-verify="required" placeholder="点击选择收件人" autocomplete="off" class="layui-input" onclick="openSelWinNew('<%=request.getContextPath()%>/address/tree_ry.jsp?utype=1&sflag=0&count=1&fields=sname,sid');">
			      <input type="text" name="sid" hidden>
				</div>
			</div>
			
			<div class="layui-form-item">
			    <label class="layui-form-label">主题</label>
			    <div class="layui-input-block">
			      <input type="text" name="title" required value="<%=title%>"  lay-verify="required" placeholder="请输入标题" autocomplete="off" class="layui-input">
			    </div>
			</div>
			
			<div class="layui-form-item">
			    <label class="layui-form-label">正文</label>
			    <div class="layui-input-block">
					<textarea id="content" name="content" required  lay-verify="content" style="display: none;"></textarea>			    
				</div>
			</div>
			
			<div class="layui-form-item">
			    <div class="layui-input-block">
			      <button class="layui-btn" type="button" lay-submit lay-filter="formDemo">发送</button>
			      <button type="reset" class="layui-btn layui-btn-primary">重置</button>
			    </div>
			</div>
		</form>
	</div>
	<!-- 查看 -->
	<div class="tab3" style="display:none">
		<table class="layui-table" lay-skin="line">
		  <colgroup>
		    <col width="80">
		    <col>
		  </colgroup>
		  <tbody>
		    <tr>
		      <td>主题</td>
		      <td class="title"></td>
		    </tr>
		    <tr>
		      <td>发件人</td>
		      <td class="username"></td>
		    </tr>
		    <tr>
		      <td>时间</td>
		      <td class="createtime"></td>
		    </tr>
		  </tbody>
		</table>
		<fieldset class="layui-elem-field">
		  <div class="layui-field-box content">
		  </div>
		</fieldset>
		<div class="tab3-1" style="display:none">
			<form class="layui-form">
				<input type="text" name="unid" value="<%=request.getParameter("unid")%>" hidden>
				<input type="text" name="sid" hidden>
				<input type="text" name="title" hidden>
				<input type="text" name="sname" hidden>
				<input type="text" name="id" hidden>
				<input type="text" name="flaga" value="1" hidden>
				<input type="text" name="flagb" value="1" hidden>
				<input type="text" name="flag" value="2" hidden>
				<div class="layui-form-item">
					<textarea id="contenta" name="content" required  lay-verify="content" style="display: none;">
					</textarea>			    
				</div>
				<div class="layui-form-item">
				      <button class="layui-btn" style="width:100px" type="button" lay-submit lay-filter="send">发送</button>
				</div>
			</form>
		</div>
		<div class="tab3-2" style="display:none">
			<p>----- 原始邮件 -----</p>
			<p><span class="fontbg">发件人：</span><span class="username"></span></p>
		  	<p><span class="fontbg">发件时间：</span><span class="createtime"></span></p>
		  	<p><span class="fontbg">收件人：</span><span class="sname"></span></p>
		  	<p><span class="fontbg">主题：</span><span class="title"></span></p>
		  	
		</div>
		<button class="layui-btn layui-btn-fluid layui-btn-primary show">点击回复</button>
	</div>
	<!-- 发件箱-->
	<div class="tab4" style="display:none">
		<table id="sendList" lay-filter="sendList"></table>
	</div>
<script>
	var unid = '<%=request.getParameter("unid")%>';
</script>
<script type="text/javascript" src="../js/jquery-1.11.0.min.js"></script>
<script type="text/javascript" src="../js/layui/layui.js"></script>
<script type="text/javascript" src="dbTalk.js?v=<%=Math.random()%>"></script>
<script language="javascript" type="text/javascript" charset="utf-8" src="../resources/js/layer/layerFunction.js"></script>
</body>
</html>