<%@page language="java" contentType="text/html;charset=UTF-8" %>

<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.oa.personal.PersonalAddressEntity" %>
<%@page import="com.kizsoft.oa.personal.PersonalAddressManager" %>
<%@page import="java.util.ArrayList" %>
<%if (session.getAttribute("userInfo") == null) {
	response.sendRedirect(request.getContextPath() + "/login.jsp");
} else {%>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>

<%
String userTemplateName = (String) session.getAttribute("templatename");
String userTemplateStr = "/resources/template/" + userTemplateName + "/template.jsp";
if(userTemplateName==null||"".equals(userTemplateName)){
	userTemplateStr = "/resources/jsp/template.jsp";
}
%>
<template:insert template="<%=userTemplateStr%>">
<template:put name='title' content='个人设置::常用地址本' direct='true'/>
<%String str = "<a class=\"menucur\" href=\"\">常用地址本</a>";%>
<template:put name='moduleNav' content='<%=str%>' direct='true'/>
<template:put name='content'>
<%//用户登陆验证
	User userInfo = (User) session.getAttribute("userInfo");
	String userID = userInfo.getUserId();
	Group groupInfo = userInfo.getGroup();
	String groupID = groupInfo.getGroupId();
	String idsStr = userID + "," + groupID;
	String contextPath = request.getContextPath();
%>
<form class="layui-form" style="padding:10px">
	<blockquote class="layui-elem-quote">
		<a class="layui-btn layui-btn-sm addmk">新增模块</a>
	</blockquote>
	<table id="mktab" lay-filter="mkfilter"></table>
	<script type="text/html" id="mkbar">
		<a class="layui-btn layui-btn layui-btn-xs" lay-event="save">保存</a>
		<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
	</script>
</form>

<script type="text/html" id="userNames">
  <input type="text" id="usernames" readonly style="border:0px;background:none;width:293px;height:28px" name="usernames_{{ d.LAY_INDEX }}" value="{{ d.userNames }}"/><input type="text" style="display:none" id="userids" name="userids_{{ d.LAY_INDEX }}" value="{{ d.userIDs }}">
  <img style="position:absolute;right:10px;top:6px" src="<%=request.getContextPath()%>/resources/images/actn133.gif" onclick="openSelWin('<%=request.getContextPath()%>/address/tree.jsp?utype=3&rtype=0&ptype=0&sflag=0&count=0&fields=usernames_{{ d.LAY_INDEX }},userids_{{ d.LAY_INDEX }}');"/>
</script>
 
<script type="text/html" id="titleTpl">
  {{#  if(d.id < 100){ }}
    <a href="/detail/{{d.id}}" class="layui-table-link">{{d.title}}</a>
  {{#  } else { }}
    {{d.title}}(普通用户)
  {{#  } }}
</script>
<script type="text/javascript">
layui.use(['form','layer','laydate','table','laytpl','jquery'], function(){
	  var form = layui.form,
      layer =layui.layer,
      $ = layui.jquery,
      laydate = layui.laydate,
      laytpl = layui.laytpl,
      table = layui.table;
	  
	  var boo = true;
	
	  
	//table渲染
	var mktab = table.render({
	   elem: '#mktab'
	   ,id: 'mkfilter'
	   ,url: '<%=contextPath%>/personal/addressAction.jsp' //数据接口
	   ,page: false //开启分页
	   ,where: {'action':'lists','userID':'<%=userID%>'}
	    ,cols: [[ //表头
	      {type: 'numbers', title: '编号', width: '10%'}
	      ,{field: 'groupName', title: '组名称', width: '30%', edit: 'text'}
	      ,{title: '组用户', width: '30%', templet: '#userNames'}
	      ,{field: 'orderNum', title: '排序号', width: '20%', edit: 'text'}
	      ,{title: '操作', width: '10%',align: 'center', toolbar: '#mkbar'}
	    ]]
	});
	
	//新增模块
	$(".addmk").click(function(){
		if(boo){
			var $tr = $(".layui-table-body.layui-table-main tbody tr:last");
			var index = $tr.data("index") == null ? -1 : $tr.data("index");
			var url = "<%=request.getContextPath()%>/address/tree.jsp?utype=3&rtype=0&ptype=0&sflag=0&count=0&fields=usernames_"+(index + 2)+",userids_"+(index + 2);
			var userNames = $(".layui-table-body.layui-table-main tbody tr:last td:eq(2) div").text();
			var ninput = '<input style="display:none" name="usernames_'+(index + 2)+'">';
			var iinput= '<input style="display:none" name="userids_'+(index + 2)+'">';
			var newHtml = '<tr data-index="' + (index + 1) + '">' +
			    '<td data-field="0"><div class="layui-table-cell laytable-cell-1-0 laytable-cell-numbers">' + (index + 2) + '</div></td>' +
			    '<td data-field="groupName" data-edit="text"><div class="layui-table-cell laytable-cell-1-groupName"></div></td>' +
			    '<td data-field="userNames"><div class="layui-table-cell laytable-cell-1-userNames"> ' +
			    '<input type="text" readonly style="border:0px;background:none;width:293px;height:28px" name="usernames_0" value=""/><input type="text" style="display:none" name="userids_0" value=""><img style="position:absolute;right:10px;top:6px" id="iimg" lay-event="iimg" src="<%=request.getContextPath()%>/resources/images/actn133.gif"/></div></td>' + 
			    '<td data-field="orderNum" data-edit="text"><div class="layui-table-cell laytable-cell-1-orderNum"></div></td>' +
			    '<td data-field="4" align="center" data-off="true"><div class="layui-table-cell laytable-cell-1-4"><a class="layui-btn layui-btn layui-btn-xs" lay-event="add">保存</a><a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a></div></td></tr>';
			$(".layui-table-body.layui-table-main tbody").append(newHtml);
			//$(".layui-table-fixed.layui-table-fixed-l tbody").append('<tr data-index="' + ($tr.data("index") + 1) + '"><td data-field="0"><div class="layui-table-cell laytable-cell-1-0 laytable-cell-numbers">' + ($tr.data("index") + 2) +'</div></td></tr>');
			boo = false;
		}else{
			layer.msg("请先保存上一条数据");
		}
		
	});
	
	//监听工具栏
	table.on('tool(mkfilter)',function(obj){
		var groupName = $(".layui-table-body.layui-table-main tbody tr:last td:eq(1) div").text();
		var userNames = $(".layui-table-body.layui-table-main tbody tr:last td:eq(2) div [name=usernames_0]").val();
		var userids = $(".layui-table-body.layui-table-main tbody tr:last td:eq(2) div [name=userids_0]").val();
		var orderNum = $(".layui-table-body.layui-table-main tbody tr:last td:eq(3) div").text();
		var layEvent = obj.event;
		var data = obj.data;
		if(layEvent === "save"){
			userNames = $(obj.tr).find('#usernames').val();
			userids = $(obj.tr).find('#userids').val();
			if(data.groupName == "" || userNames == "" || data.orderNum == ""){
				layer.msg("不能有空值");
			}else{
				if(isNaN(data.orderNum)){
					layer.msg("提醒：序号必须数字！");
				}else{
					$.ajax({
						type:"post",
						url:"<%=contextPath%>/personal/addressAction.jsp",
						data:{
							action: 'save',
							groupName: data.groupName,
							userNames: userNames,
							userids: userids,
							orderNum: data.orderNum,
							groupID: data.groupID,
							userID: '<%=userID%>'
						},
						success:function(){
							layer.msg('修改成功', {icon: '6'});
							mktab.reload();
						},
				   });
					
				}
			}
		}
		if(layEvent === "del"){
			if(obj.data.orderNum == null){
				boo = true;
				obj.del(); //删除对应行（tr）的DOM结构，并更新缓存
			    layer.close(index);
			}else{
				layer.confirm('真的删除行么', function(index){
				      //向服务端发送删除指令
				      $.ajax({
							type:"post",
							url:"<%=contextPath%>/personal/addressAction.jsp",
							data:{
								action: "delete",
								groupid: data.groupID
							},
							success:function(data){
								data = eval('(' + data + ')');
								layer.msg(data.msg, {icon: '6'});
							    obj.del();
							    layer.close(index);
							},
							error: function(data){
								layer.msg('操作失败', {icon: '5'});
							}
					   });
				  });
			}
		}
		if(layEvent === "iimg"){
			openSelWin('<%=request.getContextPath()%>/address/tree.jsp?utype=3&rtype=0&ptype=0&sflag=0&count=0&fields=usernames_0,userids_0');
		}
		if(layEvent === "add"){
			if(groupName == "" || userNames == "" || orderNum == ""){
				layer.msg("不能有空值");
			}else{
				if(isNaN(orderNum)){
					layer.msg("提醒：序号必须数字！");
				}else{
					$.ajax({
						type:"post",
						url:"<%=contextPath%>/personal/addressAction.jsp",
						data:{
							action: 'save',
							groupName: groupName,
							userNames: userNames,
							userids: userids,
							orderNum: orderNum,
							userID: '<%=userID%>'
						},
						success:function(data){
							layer.msg("新增成功");
							mktab.reload();
							boo = true;
						}
				   });
				}
			}
		}
	});
	

	
});

	function qwer(str){
		return str.replace(/(^\s*)|(\s*$)/g, "");
	}
	
</script>

</template:put>
</template:insert>
<%}%><!--索思奇智版权所有-->