<%@page import="com.kizsoft.oa.wzbwsq.util.GsonHelp"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="com.kizsoft.commons.acl.pojo.Aclapp" %>
<%@page import="com.kizsoft.commons.acl.pojo.Aclprivileresourcetype" %>
<%@page import="com.kizsoft.commons.acl.pojo.Aclrole" %>
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
%>
<template:insert template="<%=userTemplateStr%>">
<template:put name='title' content='统一用户管理系统' direct='true'/>
<%String str = "<a class=\"menucur\" href=\"\">统一用户管理</a>→角色管理";%>
<template:put name='moduleNav' content='<%=str%>' direct='true'/>
<template:put name='content'>
<link rel="stylesheet" href="<%=request.getContextPath() %>/resources/template/cn/layui/css/layui.css" media="all" />
<% int typesize = 0;
	List list = (List) request.getAttribute("list");
	//应用系统列表
	List applist = (List) request.getAttribute("applist");
	//资源类型列表
	List typelist = (List) request.getAttribute("typelist");
	if (typelist != null && typelist.size() > 0) {
		typesize = typelist.size();
	}
	//编辑的角色ID
	String editroleid = (String) request.getAttribute("editroleid");
	//添加一行标志
	String addrow = (String) request.getAttribute("addrow");
	//出错信息
	String message = (String) request.getAttribute("message");
	String json = GsonHelp.toJson(list);
	//System.out.println(json);
	%>
<html>
<head>
	<title>统一用户管理</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
</head>
<body style="padding:10px">
<html:form action="/uum/aclroleAction.do" method="post">

</html:form>
<blockquote class="layui-elem-quote"><button class="layui-btn layui-btn-normal" type="button" id="addmk">添加角色</button></blockquote>
<table id="actab" lay-filter="actab"></table>

<script type="text/html" id="yyxtmc">
<select name="appid" lay-ignore style="border:0px;background-color: transparent">
<% for (int j = 0; j < applist.size(); j++) {
	Aclapp app = (Aclapp) applist.get(j);%>
  {{#  if('<%=app.getAppcode()%>' == d.appid){ }}
	<option value="<%=app.getAppcode()%>" selected><%=app.getAppname()%></option>
  {{#  } else { }}	
	<option value="<%=app.getAppcode()%>"><%=app.getAppname()%></option>
  {{#  } }}	
<%
}
%>
</select>
</script>
<script type="text/html" id="dyry" lay-filter="dyry">
	<a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="detail">查看</a>
</script>
<script type="text/html" id="cz" lay-filter="cz">
	<a class="layui-btn layui-btn-xs" lay-event="edit">保存</a>
	<a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del">删除</a>
</script>
<script type="text/html" id="qxwh" lay-filter="qxhw">
	<a class="layui-btn layui-btn-xs" lay-event="edit">保存</a>
	<a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del">删除</a>
</script>
<script type="text/javascript" src="<%=request.getContextPath() %>/resources/template/cn/layui/layui.js"></script>
<script type="text/javascript">
	layui.use(['layer','jquery','form','table'], function() {
		var form = layui.form
		,layer = layui.layer
		,$ = layui.jquery
		,table = layui.table;
		
		var boo = true;
		table.render({
		    elem: '#actab'
		    ,data: <%=json%>
			,limit: 1000
			,height: 450
			,cellMinWidth: 28
			,id: 'pos'
		    ,cols: [[ //表头
		      {field: 'rolecode', title: '角色代码', sort: true}
		      ,{field: 'rolename', title: '角色名称',edit: 'text'}
		      ,{field: 'roledesc', title: '描述',edit: 'text'}
		      ,{field: 'xx', title: '应用系统名称', toolbar: '#yyxtmc'} 
		      <%//if (typesize > 0) {%>
			  //,{field: 'xx1', title: '权限维护', toolbar: '#qxwh'} 
			  <%//}%>
		      ,{field: 'xx2', title: '对应人员',align: 'center', templet: '#dyry'}
		      ,{field: 'xx3', title: '操作',align: 'center', toolbar: '#cz'}
		    ]]
		 });
		
		//监听工具条
		table.on('tool(actab)', function(obj){ //注：tool是工具条事件名，test是table原始容器的属性 lay-filter="对应的值"
		  var data = obj.data; //获得当前行数据
		  var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
		  var tr = obj.tr; //获得当前行 tr 的DOM对象
	      var rolecode = $(".layui-table-body.layui-table-main tbody tr:last td:eq(0) div").text();
		  var rolename = $(".layui-table-body.layui-table-main tbody tr:last td:eq(1) div").text();
		  var roledesc = $(".layui-table-body.layui-table-main tbody tr:last td:eq(2) div").text();
		  var appid = $(".layui-table-body.layui-table-main tbody tr:last td:eq(3) div select").val();
		 
		  if(layEvent === 'detail'){ //查看
			  top.layer.open({
					type: 2,
					area: ['900px','600px'],
					title: '统一用户管理',
					content: '<%=request.getContextPath()%>/uum/aclroleAction.do?action=showuser&roleid=' + data.roleid,
				});
		  } else if(layEvent === 'del'){ //删除
			  if(data.rolecode == null){
				  boo = true;
				  obj.del(); //删除对应行（tr）的DOM结构，并更新缓存
				  layer.close(index);
				
			  } else {
				  layer.confirm('真的删除行么', function(index){
						$.ajax({
							url: "aclroleAction.do",
							data: {action:"delete",roleid:data.roleid},
							success: function(){
								obj.del(); //删除对应行（tr）的DOM结构，并更新缓存
							    layer.close(index);
							}
						});
				   });
			  }
		  } else if(layEvent === 'edit'){ //编辑
				 $.ajax({
					 url: 'aclroleAction.do',
					 data: {
						 action: 'save',
						 roleid: data.roleid,
						 rolename: data.rolename,
						 description: data.roledesc,
						 appid: data.appid,
						 rolecode: data.rolecode
					 },
					 success: function(){
						 layer.msg('保存成功');
					 }
				 });
		    obj.update({
		      rolename: data.rolename,
		      description: data.roledesc,
		      rolecode: data.rolecode
		    });
		  } else if(layEvent === 'add'){
			  //alert(rolecode+"-"+rolename+"-"+roledesc+"-"+appid);
			  if(rolecode == "" || rolename == ""){
				  layer.msg('角色代码、角色名称为必填项', {icon: 5});
			  } else {
				  $.ajax({
						 url: 'aclroleAction.do',
						 data: {
							 action: 'new',
							 rolename: rolename,
							 description: roledesc,
							 appid: appid,
							 rolecode: rolecode
						 },
						 success: function(){
							 init(); 
						 }
				  });
			  }
			  
			  
		  }
		});
		
		//新增行
		$("#addmk").click(function(){
			if(boo){
				var $tr = $(".layui-table-body.layui-table-main tbody tr:last");
				var index = $tr.data("index") == null ? -1 : $tr.data("index");
				var newHtml = '<tr data-index="' + (index + 1) + '">' +
				    '<td data-field="rolecode" data-edit="text"><div class="layui-table-cell laytable-cell-1-rolecode"></div></td>' +
				    '<td data-field="rolename" data-edit="text"><div class="layui-table-cell laytable-cell-1-rolename"></div></td>' +
				    '<td data-field="roledesc" data-edit="text"><div class="layui-table-cell laytable-cell-1-roledesc"></div></td>' +
				    '<td data-field="xx"><div class="layui-table-cell laytable-cell-1-xx"><select lay-ignore style="border:0px;background-color: transparent">' +
				    <% for (int j = 0; j < applist.size(); j++) {
				    	Aclapp app = (Aclapp) applist.get(j);%>
				    '<option value="<%=app.getAppcode()%>"><%=app.getAppname()%></option>' +
				    <%
				    }
				    %>
				    '</select></div></td>' +
				    '<td data-field="xx2" align="center" data-off="true"><div class="layui-table-cell laytable-cell-1-xx2"></div></td>' +
				    '<td data-field="xx3" align="center" data-off="true"><div class="layui-table-cell laytable-cell-1-xx3"><a class="layui-btn layui-btn-xs" lay-event="add">保存</a><a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del">删除</a></div></td>';
				$(".layui-table-body.layui-table-main tbody").append(newHtml);
				//$(".layui-table-fixed.layui-table-fixed-l tbody").append('<tr data-index="' + ($tr.data("index") + 1) + '"><td data-field="0"><div class="layui-table-cell laytable-cell-1-0 laytable-cell-numbers">' + ($tr.data("index") + 2) +'</div></td></tr>');
				boo = false;
				$('.layui-table-body.layui-table-main').scrollTop(999999999999);//添加新的一行的同时滚动div
			}else{
				layer.msg("请先保存上一条数据");
			}
		    
		});
		
	});
</script>

<script language="Javascript">
	function init() {
		document.aclroleForm.action = "aclroleAction.do?action=init";
		document.aclroleForm.method = "post";
		document.aclroleForm.submit();
	}

	function edit(id) {
		document.aclroleForm.action = "aclroleAction.do?action=edit&editroleid=" + id;
		document.aclroleForm.method = "post";
		document.aclroleForm.submit();
	}
	function cancel() {
		document.aclroleForm.action = "aclroleAction.do?action=init";
		document.aclroleForm.method = "post";
		document.aclroleForm.submit();
	}
	function saverole() {
		document.aclroleForm.action = "aclroleAction.do?action=save";
		document.aclroleForm.method = "post";
		document.aclroleForm.submit();
	}
	function addrow() {
		document.aclroleForm.action = "aclroleAction.do?action=addrow";
		document.aclroleForm.method = "post";
		document.aclroleForm.submit();
	}
	function showUser(roleid) {
		window.open("aclroleAction.do?action=showuser&roleid=" + roleid, "", "toolbar=no, menubar=no, scrollbars=yes, resizable=no,location=no, status=no;width=480px,height=300px,left=" + (window.screen.width - 300) / 2 + ",top=" + (window.screen.height - 200) / 2 + '"');
	}
	function newrole() {
		document.aclroleForm.action = "aclroleAction.do?action=new";
		document.aclroleForm.method = "post";
		document.aclroleForm.submit();
	}
	function showCategory(categoryid, roleid) {
		window.open("aclroleAction.do?action=getcategory&categoryid=" + categoryid + "&roleid=" + roleid, "", "width=480px,height=300px,left=" + (window.screen.width - 300) / 2 + ",top=" + (window.screen.height - 200) / 2 + '"');
	}

</script>
</body>
</html>

</template:put>
</template:insert>
<div style="display:none"><!--索思奇智版权所有-->