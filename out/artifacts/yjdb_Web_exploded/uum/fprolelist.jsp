<%@page import="com.kizsoft.oa.wzbwsq.util.GsonHelp"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="java.util.List" %>
<%@page import="java.util.Map" %>
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
<%String str = "<a class=\"menucur\" href=\"\">统一用户管理</a>→角色分配";%>
<template:put name='moduleNav' content='<%=str%>' direct='true'/>
<template:put name='content'>
<link rel="stylesheet" href="<%=request.getContextPath() %>/resources/template/cn/layui/css/layui.css" media="all" />
<% String contextPath = request.getContextPath();

	List<Map<String, Object>> list = (List<Map<String, Object>>) request.getAttribute("list");
	int itemNum = list.size();
	String json = GsonHelp.toJson(list);
	String message = (String) request.getAttribute("message");
	//System.out.println("角色分配："+json);%>
	
<html>
<head>
	<title>统一用户管理</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
</head>

<body style="padding:10px" class="border-index">
<table id="actab" lay-filter="actab"></table>
<form name="fproleForm" action="/uum/fproleAction.do" method="post">
</form>
<script language="Javascript">
	function init() {
		document.fproleForm.action = "fproleAction.do?action=init";
		document.fproleForm.method = "post";
		document.fproleForm.submit();
	}
</script>
<script type="text/html" id="kfpjs">
  <textarea name="fprole_{{ d.id }}" style="width:94%;border:0px;background:none;position:absolute;" class="layui-input" readonly value="{{ d.fprole }}">{{ d.fprole }}</textarea>
  <input type="hidden" name="fproleid_{{ d.id }}" value="{{ d.fproleid }}">
  <img style="position:absolute;right:7px" src="<%=contextPath%>/resources/images/actn133.gif" onclick="openSelWin('<%=contextPath%>/address/roletree.jsp?utype=0&count=0&ptype=0&fields=fprole_{{ d.id }},fproleid_{{ d.id }}');"/>
</script>
<script type="text/javascript" src="<%=request.getContextPath() %>/resources/template/cn/layui/layui.js"></script>
<script type="text/javascript">
	layui.use(['layer','laytpl','jquery','table'], function() {
		var layer = layui.layer
		,$ = layui.jquery
		,table = layui.table
		,laytpl = layui.laytpl;
		
		table.render({
		    elem: '#actab'
		    ,data: <%=json%>
			,limit: 1000
			,size: 'lg'
		    ,cols: [[ //表头
		      {type: 'numbers', title: '序号', width: 50}
		      ,{field: 'ownername', title: '用户', width: 100}
		      ,{title: '可分配角色', toolbar: '#kfpjs', width: '80%'}
		      ,{title: '操作',align: 'center', templet: '<div><a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="update">更新</a><div>'}
		    ]]
		 });
		
		//监听工具条
		table.on('tool(actab)', function(obj){ //注：tool是工具条事件名，test是table原始容器的属性 lay-filter="对应的值"
		  var data = obj.data; //获得当前行数据
		  var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
		  var tr = obj.tr; //获得当前行 tr 的DOM对象
		 
		  if(layEvent === 'update'){ //编辑
			//alert(data.id+"-"+data.unitman+"-"+data.unitmanid);
		    //do something
			$.ajax({
				url: 'fproleAction.do',
				data: {
					action:"edit",
					gxNum: "0",
					unitroleid_0: data.unitroleid,
					unitman_0: data.unitman,
					unitmanid_0: data.id,
					fprole_0: $('[name=fprole_' + data.id).val(),
					fproleid_0: $('[name=fproleid_' + data.id).val()
				},
				success: function(){
					init();
				}
				
			});
		    //同步更新缓存对应的值
		    obj.update({
		      username: '123'
		      ,title: 'xxx'
		    });
		  }
		});
	});
</script>
</body>
</html>

</template:put>
</template:insert>
<div style="display:none"><!--索思奇智版权所有-->