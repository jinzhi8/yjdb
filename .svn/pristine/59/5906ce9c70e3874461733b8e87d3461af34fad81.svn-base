<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="com.kizsoft.commons.uum.pojo.Owner" %>
<%@page import="com.kizsoft.commons.uum.pojo.Role" %>
<%@page import="java.util.List" %>


<%@taglib prefix="oa" uri="/WEB-INF/oa.tld" %>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<%@taglib prefix="html" uri="/WEB-INF/struts-html.tld" %>
<%
	String userTemplateName = (String) session.getAttribute("templatename");
	String userTemplateStr = "/resources/template/" + userTemplateName + "/template.jsp";
	if(userTemplateName==null||"".equals(userTemplateName)){
		userTemplateStr = "/resources/jsp/template.jsp";
	}
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
	}
	Owner owner = (Owner)request.getAttribute("owner");
%>
<template:insert template="<%=userTemplateStr%>">
<template:put name='title' content='统一用户管理系统' direct='true'/>
<% String str = "<a class=\"menucur\" href=\"\">统一用户管理</a>";%>
<template:put name='moduleNav' content='<%=str%>' direct='true'/>
<template:put name='content'>
<%try {%>
<title>
</title>
<link rel="stylesheet" href="<%=request.getContextPath() %>/resources/template/cn/layui/css/layui.css" media="all" />
<body style="padding:10px">
<form action="" class="layui-form">
  <blockquote class="layui-elem-quote">
	<span style="margin-right:196px">上级部门: <font color="red"><%=owner.getOwnername() %></font></span>
	<div style="width: 95%; position: absolute; text-align: right; top: 17px;">
	  <div class="layui-inline">
        <label class="layui-form-label">职位名称</label>
        <div class="layui-input-inline">
          <input type="tel" name="rolename" lay-verify="required" placeholder="请输入职位名称" autocomplete="off" class="layui-input">
        </div>
      </div>
	  <div class="layui-inline">
        <label class="layui-form-label">描述</label>
        <div class="layui-input-inline">
          <input type="tel" name="description" lay-verify="required" placeholder="请输入描述" autocomplete="off" class="layui-input">
        </div>
      </div>
	  <div class="layui-inline">
        <button class="layui-btn layui-btn-sm layui-btn-normal" lay-submit lay-filter="formDemo" type="button">保存</button>
        <button type="reset" class="layui-btn layui-btn-primary layui-btn-sm">重置</button>
      </div>
      </div>
  </blockquote>
  
  <table id="rstab" lay-filter="rstab"></table>
</form>
<script language="javascript">
	function setRole(id) {
		window.open("tree.do?action=getUserChild2&id=" + id, "", "width=500,height=250;");
	}

	function send() {
		var target = "addnew" ;
		if (checkNull(document.postForm.rolename)) {
			if (document.postForm.ID.value == "") {
				target = "addnew";
			} else {
				target = "modify";
			}
			document.postForm.action = "post.do?action=" + target;
			document.postForm.submit();
			this.clrpage();
		}
	}
	function resetRole(id, rolename, username) {
		if (confirm("你确定要撤销'" + username + "'的'" + rolename + "'职位?")) {
			document.postForm.ID.value = id;
			document.postForm.action = "post.do?action=resetrole";
			document.postForm.submit();
		}
	}
	function cdelete(id) {
		document.postForm.ID.value = id;
		document.postForm.action = "post.do?action=delete&id=" + id;
		document.postForm.submit();
		this.clrpage();
	}
	function checkNull(obj) {
		if (obj.value == "") {
			alert("请将*号的都输入信息.");
			return false;
		}
		return true;
	}
	function clrpage() {
		document.postForm.ID.value = "";
		document.postForm.rolename.value = "";
		document.postForm.description.value = "";
	}
</script>
<script type="text/html" id="barDemo">
  <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
  <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
</script>
<script type="text/html" id="gxcz">
  {{# if(d.ownername == null || d.ownername == "") { }}
  {{# } else { }}
  <a class="layui-btn layui-btn-xs layui-bg-orange" lay-event="cx">撤销职位</a> 
  {{# } }}
</script>
<script type="text/javascript" src="<%=request.getContextPath() %>/resources/template/cn/layui/layui.js"></script>
<script type="text/javascript">
	layui.use(['table','form','layer','jquery'], function() {
		var table = layui.table
		,form = layui.form
		,$ = layui.jquery
		,layer = layui.layer;
		
		 //渲染tab
		var tab = table.render({
		  elem: '#rstab'
		  ,height: 'full-130'
		  ,url: "postAction.jsp"
		  ,cellMinWidth: 200
		  ,id: 'rstab'
		  ,where: {action: 'list', parentid: '<%=owner.getId()%>'}
		  ,cols: [[ //表头
		    {field: 'rolename', title: '职位名称', edit: 'text'}
		    ,{field: 'ownername', title: '对应人员'}
		    ,{field: 'description', title: '描述', edit: 'text'}
		    ,{field: 'mobile', title: '职位操作', align: 'center', toolbar: '#barDemo'} 
		    ,{field: 'UUMType', title: '关系操作', align: 'center', toolbar: '#gxcz', width: 150}
		  ]]
		});
		 
		form.on('submit(formDemo)', function(data){
			$.ajax({
				url: 'postAction.jsp',
				data: {
					action: 'save',
					rolename: $('[name=rolename]').val(),
					description: $('[name=description]').val(),
					parentid: '<%=owner.getId()%>'
				},
				success: function(){
					tab.reload();
				}
				
			});
			
		}); 
		
		table.on('tool(rstab)', function(obj){ //注：tool是工具条事件名，test是table原始容器的属性 lay-filter="对应的值"
			  var data = obj.data; //获得当前行数据
			  var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
			  var tr = obj.tr; //获得当前行 tr 的DOM对象
			  if(layEvent === 'del'){ //删除
			    layer.confirm('真的删除行么', function(index){
					$.ajax({
						url: 'postAction.jsp',
						data: {
							action: 'del',
							id: data.id,
						},
						success: function(){
							obj.del();
						 	layer.close(index);
							layer.msg("删除成功", {icon:'6'});
						}
					});
				});
			  } else if(layEvent === 'edit'){ 
				  
			    $.ajax({
			    	url: 'postAction.jsp',
			    	data: {
			    		action: 'update',
			    		id: data.id,
						rolename: data.rolename,
						desc: data.description,
						parentid: data.parentid
			    	},
			    	success: function(){
			    		layer.msg("编辑成功", {icon:'6'});
			    	}
			    });
			    //同步更新缓存对应的值
			    obj.update({
			    	rolename: data.rolename,
			        desc: data.description
			    });
			  } else if(layEvent === 'cx'){
				  layer.confirm("你确定要撤销'" + data.ownername + "'的'" + data.rolename + "'职位?", {icon: '2', title: '提示'}, function(index){
					  $.ajax({
					    	url: 'postAction.jsp',
					    	data: {
					    		action: 'resetRole',
					    		id: data.id,
					    	},
					    	success: function(){
					    		layer.msg("撤销成功", {icon:'6'});
					    		tab.reload();
					    	}
					  });
				     
				});
				  
			  }
		});
		
	})
</script>

<% } catch (Exception ex) {
	ex.printStackTrace();
}%>
</template:put>
</template:insert><!--索思奇智版权所有-->