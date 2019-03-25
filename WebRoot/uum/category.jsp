<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.commons.db.ConnectionProvider" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.commons.util.StringHelper" %>
<%@page import="java.sql.Connection" %>
<%@page import="java.sql.ResultSet" %>
<%@page import="java.sql.Statement" %>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>

<%
String userTemplateName = (String) session.getAttribute("templatename");
String userTemplateStr = "/resources/template/" + userTemplateName + "/template.jsp";
if(userTemplateName==null||"".equals(userTemplateName)){
	userTemplateStr = "/resources/jsp/template.jsp";
}
User userInfo = (User) session.getAttribute("userInfo");
if (userInfo == null) {
	response.sendRedirect(request.getContextPath() + "/login.jsp");
}
%>
<template:insert template="<%=userTemplateStr%>">
<template:put name='title' content='用户排序' direct='true'/>
<% String str = "<a class=\"menucur\" href=\"category.jsp\">用户排序</a>";%>
<template:put name='moduleNav' content='<%=str%>' direct='true'/>
<template:put name='content'>
<link rel="stylesheet" href="<%=request.getContextPath() %>/resources/template/cn/layui/css/layui.css" media="all" />
<body style="padding:10px;">
<blockquote class="layui-elem-quote">
	用户排序<span class="layui-word-aux">单击排序号列单元格可编辑</span>
	<button style="position:absolute;right:29px;top:17px" class="layui-btn layui-btn-normal" id="bianhao">编号</button>
</blockquote>
<table id="userTab" lay-filter="userTab"></table>

<script type="text/html" id="barDemo">
  <a class="layui-btn layui-btn-xs" lay-event="up">上移</a>
  <a class="layui-btn layui-btn-xs" lay-event="downd">下移</a>
</script>
<script type="text/javascript" src="<%=request.getContextPath() %>/resources/template/cn/layui/layui.js"></script>
<script>
	layui.use(['table','form','layer','jquery'], function() {
		var table = layui.table
		,form = layui.form
		,$ = layui.jquery
		,layer = layui.layer;
		
		var boo = true;
		 //渲染tab
		var tab = table.render({
		  elem: '#userTab'
		  ,height: 'full-135'
		  ,url: 'userAction.jsp'
		  ,where: {action: 'category', pid: '<%=request.getParameter("pid")%>'}
		  ,cols: [[ //表头
		    {field: 'OWNERCODE', title: '登陆名'}
		    ,{field: 'OWNERNAME', title: '真实姓名'}
		    ,{field: 'TYPE', title: '类型'}
		    ,{field: 'ORDERID', title: '排序号', edit: 'text'} 
		    ,{title: '移动',align: 'center', toolbar:'#barDemo'}
		  ]]
		});
		 
		//监听工具条
		table.on('tool(userTab)', function(obj){ //
		  var data = obj.data; //获得当前行数据
		  var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
		  var tr = obj.tr; //获得当前行 tr 的DOM对象
		 
		  if(layEvent === 'up'){ //查看
		  	  var index = $(tr).attr("data-index");
			  if(index == 0) {
				  layer.msg('已经是第一行元素');
			  } else {
				  $.ajax({
					  url: 'userAction.jsp',
					  data: {
						  action: 'categorySort',
						  index: index ,
						  pid: '<%=request.getParameter("pid")%>',
						  dd: 'up'
					  },
					  success: function(){
						  tab.reload();
						  layer.msg('修改成功');
					  }
				  });
			  }
		    //do somehing
		  }
		  if(layEvent === 'downd'){ //删除
		 	  var down = $(tr).next().find('.laytable-cell-1-ORDERID').text();
		 	  var index = $(tr).attr("data-index");
		 	  if(down == "") {
			  	  layer.msg('已经是最后一行元素');
			  } else {
				  $.ajax({
				    url: 'userAction.jsp',
				    data: {
					    action: 'categorySort',
					    index: index ,
					    pid: '<%=request.getParameter("pid")%>',
					    dd: 'down'
				    },
				    success: function(){
					    tab.reload();
					    layer.msg('修改成功');
				    }
			      });
			  }
		  }
		});
		
		//单元格编辑
		table.on('edit(userTab)', function(obj){
			  if(isNumber(obj.value)) {
				  $.ajax({
					  url: 'userAction.jsp',
					  data: {action: 'categoryEdit', ownerid: obj.data.OWNERID, orderid: obj.value},
					  success: function(){
						  tab.reload();
						  layer.msg('修改成功', {icon:6});
					  }
				  });
			  } else {
				  layer.msg('保存失败，排序号必须为数字', {icon:5});
			  }
			  
		});
		
		//点击编号
		$('#bianhao').click(function(){
			$.ajax({
				  url: 'userAction.jsp',
				  data: {action: 'categoryBh',pid: '<%=request.getParameter("pid")%>'},
				  success: function(){
					  tab.reload();
					  layer.msg('操作成功', {icon:6});
				  }
			  });
		});
		
		
	});
	
	function isNumber(value) {
	    var patrn = /^[0-9]*$/;
	    if (patrn.exec(value) == null || value == "") {
	        return false
	    } else {
	        return true
	    }
	}
</script>		 		
</body> 
</template:put>
</template:insert><!--索思奇智版权所有-->