<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.oa.personal.Messengerdata" %>
<%@page import="com.kizsoft.oa.personal.PersonalForm" %>
<%@page import="java.util.ArrayList" %>
<%

	String userId = request.getParameter("userId");
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
<div id="bodyDiv"></div>

<script>
layui.use(['form','layer','laydate','table','laytpl'], function(){
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
	   ,url: '<%=contextPath%>/personal/action.jsp' //数据接口
	   ,page: false //开启分页
	   ,where: {'action':'lists','userId':'<%=userId%>'}
	    ,cols: [[ //表头
	      {type: 'numbers', title: '编号', width: '12%'}
	      ,{field: 'messenger', title: '批示内容', width: '48%', edit: 'text'}
	      ,{field: 'orderId', title: '排序号', width: '25%', edit: 'text'}
	      ,{title: '操作', width: '15%',align: 'center', toolbar: '#mkbar'}
	    ]]
	});
	
	//新增模块
	$(".addmk").click(function(){
		if(boo){
			var $tr = $(".layui-table-body.layui-table-main tbody tr:last");
			var aa = $(".layui-table-body.layui-table-main tbody tr:last td:eq(2) div").text();
			var newHtml = '<tr data-index="' + ($tr.data("index") + 1) + '">' +
			    '<td data-field="0"><div class="layui-table-cell laytable-cell-1-0 laytable-cell-numbers">' + ($tr.data("index") + 2) + '</div></td>' +
			    '<td data-field="messenger" data-edit="text"><div class="layui-table-cell laytable-cell-1-MODULEID"></div></td>' +
			    '<td data-field="orderId"><div class="layui-table-cell laytable-cell-1-orderId">'+(Number(aa)+1)+'</div></td>' +
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
		var messenger = $(".layui-table-body.layui-table-main tbody tr:last td:eq(1) div").text();
		var orderId = $(".layui-table-body.layui-table-main tbody tr:last td:eq(2) div").text();
		var layEvent = obj.event;
		if(layEvent === "save"){
			if(obj.data.messenger == "" || obj.data.orderId == ""){
				layer.msg("不能有空值");
			}else{
				if(isNaN(obj.data.orderId)){
					layer.msg("提醒：序号必须数字！");
				}else{
					$.ajax({
						type:"post",
						url:"<%=contextPath%>/personal/action.jsp",
						data:{
							action: 'save',
							messId: obj.data.messId,
							messenger: obj.data.messenger,
							orderId: obj.data.orderId,
							userId: '<%=userId%>'
						},
						success:function(data){
							if(qwer(data) == "success"){
								layer.msg('修改成功');
							}else{
								layer.msg('修改失败');
							}
							mktab.reload();
						},
				   });
					
				}
			}
		}
		if(layEvent === "del"){
			if(obj.data.orderId == null){
				boo = true;
				obj.del(); //删除对应行（tr）的DOM结构，并更新缓存
			    layer.close(index);
			}else{
				layer.confirm('真的删除行么', function(index){
				      //向服务端发送删除指令
				      $.ajax({
							type:"post",
							url:"<%=contextPath%>/personal/action.jsp",
							data:{
								action: "delete",
								messId: obj.data.messId,
								userId: '<%=userId%>'
							},
							success:function(data){
								if(qwer(data) == "success"){
									layer.msg('删除成功');
								    obj.del(); //删除对应行（tr）的DOM结构，并更新缓存
								    layer.close(index);
								}else{
									layer.msg('删除失败');
								}
							}
					   });
				    });
			}
		}
		if(layEvent === "add"){
			if(messenger == ""){
				layer.msg("内容不能为空");
			}else{
				if(orderId != "" && isNaN(orderId)){
					layer.msg("提醒：序号必须数字！");
				}else{
					$.ajax({
						type:"post",
						url:"<%=contextPath%>/personal/action.jsp",
						data:{
							action: 'save',
							messenger: messenger,
							userId: '<%=userId%>'
						},
						success:function(data){
							if(qwer(data) == "success"){
								layer.msg("新增成功");
							}else{
								layer.msg("新增失败");
							}
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
		 <!--索思奇智版权所有-->