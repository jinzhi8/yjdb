<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@page import="com.kizsoft.yjdb.utils.CommonUtil"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="com.kizsoft.commons.commons.orm.MyDBUtils"%>
<%@page import="com.kizsoft.oa.wzbwsq.util.GsonHelp"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="com.kizsoft.commons.acl.ACLManager" %>
<%@page import="com.kizsoft.commons.acl.ACLManagerFactory" %>
<%@page import="com.kizsoft.commons.acl.pojo.Aclrole" %>

<%@page import="com.kizsoft.commons.acl.utils.ACLContend" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.commons.util.StringHelper" %>
<%@ page import="com.kizsoft.commons.uum.actions.Pagination" %>
<%@ page import="com.kizsoft.commons.uum.pojo.Owner" %>
<%@ page import="java.util.List" %>
<%@ page import="com.kizsoft.yjdb.utils.PropertiesUtil" %>

<%
	//用户登陆验证
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
	}
	User userInfo = (User) session.getAttribute("userInfo");
	String userID = userInfo.getUserId();
	ACLManager aclManager = ACLManagerFactory.getACLManager();
	
	Owner currentowner = (Owner) request.getAttribute("currentowner");
	Pagination pagination = (Pagination) request.getAttribute("pagination");
	List userlist = null;
	if (pagination != null) {
		userlist = pagination.getList();
	} else userlist = (List) request.getAttribute("userlist");
	
	//List alist = ACLContend.getACLService().getRoleByOwnerId(owner.getId());
	//for (int aclroleidx = 0; aclroleidx < alist.size(); aclroleidx++) {
	//	Aclrole role = (Aclrole) alist.get(aclroleidx);
	//	out.print(role.getRolename() + "<br>");
	//}
	//List<Map<String, Object>> ll = (List<Map<String, Object>>)request.getAttribute("ll");
	Map<String, Object> map = new HashMap<String, Object>();
	List<Map<String, Object>> ll = null;
	StringBuffer sb = new StringBuffer();
	if (userlist != null) {
		ll = mapListJson(GsonHelp.toJson(userlist));
		for (int i = 0; i < userlist.size(); i++) {
			map.clear();
			Owner owner = (Owner) userlist.get(i);
			Map<String, Object> lll = ll.get(i);			
			List alist = ACLContend.getACLService().getRoleByOwnerId(owner.getId());
			for (int aclroleidx = 0; aclroleidx < alist.size(); aclroleidx++) {
				Aclrole role = (Aclrole) alist.get(aclroleidx);
				sb.append(role.getRolename());
				if(aclroleidx < alist.size()-1){
					sb.append(",");
				}
			}
			lll.put("roles",sb.toString());
			sb.delete(0, sb.length());
		}
	}
	String json = GsonHelp.toJson(ll);
	String url = PropertiesUtil.getDlValueByKey("dingOaUrl");
	String depid="";
	if(currentowner!=null){
		depid=CommonUtil.doStr(currentowner.getId());
	}
%>

<%!
	public List<Map<String, Object>> mapListJson(String str) {
	    JSONArray jsonArray = JSONArray.fromObject(str);
	    
	    List<Map<String,Object>> mapListJson = (List)jsonArray;
	    for (int i = 0; i < mapListJson.size(); i++) {
	        Map<String,Object> obj=mapListJson.get(i);
	         
	        for(Entry<String,Object> entry : obj.entrySet()){
	            String strkey1 = entry.getKey();
	            Object strval1 = entry.getValue();
	        }
	    }
	    return mapListJson;
	}
%>
<html>
<head>
	<title>统一用户管理</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<script type="text/javascript" src="js/xtree.js"></script>
	<script type="text/javascript" src="js/comm.js"></script>
	<link rel="stylesheet" href="<%=request.getContextPath() %>/resources/template/cn/layui/css/layui.css" media="all" />
	<style type="text/css">
		.current {
			background-color: #f2f2f2
		}
		.layui-form-item .layui-inline label{
			width: 50px
		}
	</style>
</head>
<script language=Javascript>
	function loadData() {
		document.form2.submit();
	}
</script>
<script type="text/javascript" language="javascript">

	//排序
	function upnode(id) {
		document.form1.action = "user.do?action=upnode&id=" + id;
		document.form1.submit();
	}
	function wen() {
		if (newopen.closed) {
			clearTimeout(to);
			loadData();
		} else {
			to = setTimeout('wen()', 100);
		}
	}
	function downnode(id) {
		document.form1.action = "user.do?action=downnode&id=" + id;
		document.form1.submit();
	}		//

		//删除部门或分部门
	function deleteDept() {
		if (confirm("您确信要删除部门'信息中心'?")) {
			document.form1.submit();
		} else {
			return null;
		}
	}
	
	


	function newSubDept() {
		var AtWnd = window.open("subowner.do?action=addnewsub&id=" + id, "", "width=500,height=250;");
		if (!AtWnd.opener)
			AtWnd.opener = window;  //attached window
		AtWnd.focus();  //show the window

	}
	//初始化用户密码
	function initPassword() {
		if (confirm("您确信要初始化你所选的用户的密码?")) {
			document.form1.action = "user.do?action=initpassword";
			document.form1.submit();
		} else {
			return null;
		}
	}	//将用户设为无效
	function disableUser(id) {
		if (confirm("您确信要将你所选的用户设为无效,该用户将不能登陆?")) {
			document.form1.action = "user.do?action=disableaccount&id=" + id;
			document.form1.submit();
		} else {
			return null;
		}
	}	//用户帐号重新启用
	function ableUser(id) {
		if (confirm("你要启用该帐号?")) {
			document.form1.action = "user.do?action=ableaccount&id=" + id;
			document.form1.submit();
		} else {
			return null;
		}
	}
</script>
<form name="form2" method="post" action="tree.do?action=getUserChild">
	<input type="hidden" name="id"  <%if (currentowner!=null){  out.print("value="+currentowner.getId());}%>>
</form>
<body style="padding:10px">
<form class="layui-form" name="form1" method="post" action="user.do">
	<blockquote class="layui-elem-quote layui-quote-nm">
		当前部门:
		<% if (currentowner == null) {%>
		未选择部门
		<input type="hidden" name="parentid" value="">
		<%} else {%>
		<span style="color:#FF5722"><%=currentowner.getOwnername()%></span>
		<input type="hidden" name="parentid" value="<%=currentowner.getId()%>">
		<%}%>
	</blockquote>
	<div class="layui-btn-group btnTop" style="height:30px">
		<%if (currentowner != null) {%>
		<button class="layui-btn layui-btn-normal layui-btn-sm" type="button" onclick="newSubDep()">添加子部门</button>
		<button class="layui-btn layui-btn-normal layui-btn-sm" type="button" onclick="editDep()">编辑部门</button>
		<button class="layui-btn layui-btn-normal layui-btn-sm" type="button" onclick="newUser()">添加用户</button>
		<button class="layui-btn layui-btn-normal layui-btn-sm" type="button" onclick="tbUser()">同步钉钉组织架构</button>
		<%}%>
		<%if (aclManager.isOwnerRole(userID, "sysadmin")) {%>
		<button class="layui-btn layui-btn-normal layui-btn-sm" type="button" onclick="moveOwner();">移动部门</button>
		<button class="layui-btn layui-btn-normal layui-btn-sm" type="button" onclick="aclrole()">角色维护</button>
		<button class="layui-btn layui-btn-normal layui-btn-sm" type="button" onclick="fprole()">角色分配</button>
		<button class="layui-btn layui-btn-normal layui-btn-sm" type="button" onclick="query()">高级查询</button>
		<%}%>
		<%if (currentowner != null) {%>
		<button class="layui-btn layui-btn-normal layui-btn-sm" type="button" onclick="deprole()">职位维护</button>
		<%}%>
	</div>
	<div class="layui-btn-group btnTop" style="float:right">
		<button class="layui-btn layui-btn-normal layui-btn-sm" type="button" id="deleteUser">彻底删除</button>
		<button class="layui-btn layui-btn-normal layui-btn-sm" type="button" id="swap">人事调出</button>
		<button class="layui-btn layui-btn-normal layui-btn-sm" type="button" onclick="invoke()">人事调入</button>
		<%if (currentowner != null) {%>
		<button class="layui-btn layui-btn-normal layui-btn-sm" type="button" onclick="userSort()">用户排序</button>
		<%} else {%>
		<button class="layui-btn layui-btn-normal layui-btn-sm" type="button" onclick="userSort()">用户排序</button>
		<button class="layui-btn layui-btn-normal layui-btn-sm" type="button" onclick="imports()">批量导入</button>
		<% } %>
	</div>
	<div style="background-color: #f2f2f2;padding-top: 10px; height:52px; margin-top:10px">
	  <div class="layui-form-item">
	  	<div class="layui-inline">
          <label class="layui-form-label">登录名</label>
   		  <div class="layui-input-inline">
    	    <input type="text" id="ownercode" autocomplete="off" class="layui-input">
   	      </div>
   	    </div>
	  	<div class="layui-inline">
          <label class="layui-form-label">姓名</label>
   		  <div class="layui-input-inline">
    	    <input type="text" id="ownername" autocomplete="off" class="layui-input">
   	      </div>
   	    </div>
   	    <button id="submm" type="button" class="layui-btn layui-btn-normal">查询</button>
      </div>
      </div>
	<table id="userTab" lay-filter="userTab"></table>
	<script type="text/html" id="barDemo">
  		<a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>

		{{#  if(d.STATUS == '1'){ }}
    		<a class="layui-btn layui-btn-xs layui-bg-orange" lay-event="check">已启用</a>
  		{{#  }else{ }}
			<a class="layui-btn layui-btn-xs layui-bg-red" lay-event="check">已停用</a>
  		{{#  } }}
	<input style="display:none" id="ID" value="{{ d.ID }}">
	</script>
	
</form>
<a id="selectb" data-url="<%=request.getContextPath() %>/uum/user.do?action=query" style="display:none"><i class="layui-icon" data-icon=""></i><cite>高级查询</cite></a>
<script type="text/javascript" src="<%=request.getContextPath() %>/resources/template/cn/layui/layui.js"></script>
<script type="text/javascript">
var layer = "";
var $ = "";
	layui.use(['table','form','layer','jquery'], function() {
		var table = layui.table
		,form = layui.form;
		$ = layui.jquery;
		layer = layui.layer;
		
		 //渲染tab
		var tab = table.render({
		  elem: '#userTab'
		  ,cellMinWidth : 95
		  ,height: 'full-225'
		  ,limit : 10
		  ,limits : [10,15,20,25]
		  ,page: true //开启分页
		  ,url: 'treeAction.jsp'
		  ,id: 'userTab'
		  ,where: {parentid: <%=depid%>, action: 'list'}
		  ,cols: [[ //表头
			 {type:'checkbox', rowspan:2}
		    ,{field: 'OWNERCODE', title: '登陆名',rowspan:2}
		    ,{field: 'OWNERNAME', title: '真实姓名', rowspan:2}
		    ,{field: 'POSITION', title: '职务', rowspan:2}
		    ,{field: 'ROLES', title: '角色', rowspan:2, width:'20%'} 
		    ,{field: 'sign', title: '联系方式', colspan:3, align:'center'}
		    ,{field: 'experience', title: '操作',align: 'center', toolbar:'#barDemo',width: '15%', rowspan:2}
		  ],[
			{field: 'MOBILE', title: '手机',width:'14%'}
			,{field: 'PHONE', title: '电话'}
			,{field: 'PHONESHORT', title: '短号'} 
		  ]],
		  done: function(res, curr, count){
			  }
		});
		 
		//监听工具条
		table.on('tool(userTab)', function(obj){ //注：tool是工具条事件名，test是table原始容器的属性 lay-filter="对应的值"
		  var data = obj.data; //获得当前行数据
		  var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
		  var tr = obj.tr; //获得当前行 tr 的DOM对象
		 
		  if(layEvent === 'detail'){ //查看
		    //do somehing
		  } else if(layEvent === 'check'){ //删除
				if(data.STATUS == '1') {
					disableUser(data.ID);
				}else{
					ableUser(data.ID);
				}
		  } else if(layEvent === 'edit'){ //编辑
			    editUser(data.ID);
		  }
		});
	
		$('#submm').click(function(){
			tab.reload({
				where: {
					action: 'select',
					ownername: $('#ownername').val(),
					ownercode: $('#ownercode').val(),
					parentid: '<%=currentowner == null ? "" : currentowner.getId()%>'
				}
			});
		});
	
		$('.layui-table tbody').on('click','tr',function(){  
	           $(this).addClass("current").siblings().removeClass("current");  
	           $('[name=chkid]').val($(this).find('#ID').val());
	    }); 
		
		//彻底删除
		$('#deleteUser').click(function(){
			var checkStatus = table.checkStatus('userTab');
			if(checkStatus.data.length) {
				var chkid = "";
				for (var i = 0; i < checkStatus.data.length; i++) {
					if(i < checkStatus.data.length-1){
						chkid += checkStatus.data[i].ID + ",";
					} else {
						chkid += checkStatus.data[i].ID;
					}
				}
				top.layer.confirm('您确信要删除你所选的用户?', function(index){
					$.ajax({
						url: 'userAction.jsp',
						data: {action: 'deleteUser', chkid: chkid},
					    success: function(){
					    	layer.msg('删除成功', {icon: 6});
					    	tab.reload();	
					    	top.layer.close(index);
					    }
					});
				});
			} else {
				layer.msg('请选择要删除的用户', {icon: 5});
			}
		});
		
		//人事调出
		$('#swap').click(function() {
			var checkStatus = table.checkStatus('userTab');
			if(checkStatus.data.length) {
				var chkid = "";
				for (var i = 0; i < checkStatus.data.length; i++) {
					if(i < checkStatus.data.length-1){
						chkid += checkStatus.data[i].ID + ",";
					} else {
						chkid += checkStatus.data[i].ID;
					}
				}
			 <% if(currentowner != null) {%>
				top.layer.confirm('您确信要调出你所选的用户?', function(index){
					$.ajax({
						url: 'userAction.jsp',
						data: {action: 'swap', chkid: chkid, pid: '<%=currentowner.getId()%>'},
					    success: function(){
					    	layer.msg('人事调出成功', {icon: 6});
					    	tab.reload();	
					    	top.layer.close(index);
					    }
					});
				});
			<% } %>
			} else {
				layer.msg('请选择要调出的用户', {icon: 5});
			}
		});
	});
	//添加子部门
	function newSubDep() {
		<%if (currentowner!=null){%>
		top.layer.open({
			type: 2,
			area: ['700px','430px'],
			title: '分部门管理--增加',
			content: '<%=request.getContextPath()%>/uum/subowner.do?action=addnewsub&id=<%=currentowner.getId()%>',
			end: function(){
				location.reload();
			}
		});
		<%}%>
	}
	
	//编辑部门		
	function editDep() {
		<%if (currentowner!=null){%>
		top.layer.open({
			type: 2,
			area: ['700px','430px'],
			title: '分部门管理--修改',
			content: '<%=request.getContextPath()%>/uum/owner.do?action=edit&id=<%=currentowner.getId()%>',
			end: function(){
				location.reload();
			}
			
		});
		<%}%>
	}
	

	//同步组织
	function tbUser() {
		<%if (currentowner!=null){%>
		var index =layer.msg('数据同步中，请稍候',{icon: 16,time:false,shade:0.8});
		$.ajax({
   			type:"post",
   			url:"<%=url%>",
   			data:{
   				depid:<%=currentowner.getId()%>
   			},
   			dataType:'html',
   			success:function(data){
   				//window.parent.location.reload();
   				layer.close(index);
   				
   			},error:function(data){
   				layer.close(index);
   				layer.msg("同步失败，请稍后再试！");
   			}
   		});
		<%}%>
	}
	
	//添加用户
	function newUser() {
		<%if (currentowner!=null){%>
		top.layer.open({
			type: 2,
			area: ['800px','520px'],
			title: '统一用户--增加',
			content: '<%=request.getContextPath()%>/uum/user.do?action=addnew&oid=<%=currentowner.getId()%>',
			end: function(){
				location.reload();
			}
		});
		<%}%>
	}
	
	//角色分配
	function fprole() {
		var index = parent.layer.open({
			type: 2,
			title: '角色维护',
			area: ['100%','100%'],
			content: "<%=request.getContextPath()%>/uum/fproleAction.do?action=init",
			end: function(){
				location.reload();
			}
		});
	}

	
	//移动部门
	function moveOwner() {
		<%if (currentowner!=null){%>
		parent.layer.open({
			type: 2,
			area: ['100%','100%'],
			title: '移动部门',
			content: '<%=request.getContextPath()%>/uum/moveowner.jsp?ownerid=<%=currentowner.getId()%>',
			end: function(){
				location.reload();
			}
		});
		<%}%>
	}
	
	//高级查询
	function query() {
		//document.form1.method = "post";
		//document.form1.target = "_parent";
		////document.form1.action = "user.do?action=query";
		//document.form1.submit();
		top.addTab($("#selectb"));
	}

	//人事调入
	function invoke() {
		if (document.form1.parentid.value == "") {
			top.layer.msg('请选择一个部门');
		}else{
			top.layer.open({
				type: 2,
				area: ['800px','520px'],
				title: '人事调入',
				content: "<%=request.getContextPath()%>/uum/userAction.jsp?action=import&usertype=0&parentid=" + document.form1.parentid.value,
				end: function(){
					location.reload();
				}
			});
		}
	}
	//编辑用户信息
	function editUser(id) {
		<%if (currentowner!=null){%>
			top.layer.open({
				type: 2,
				area: ['800px','520px'],
				title: '用户信息编辑',
				content: "<%=request.getContextPath()%>/uum/user.do?action=edit&oid=" + id + "&parentid=<%=currentowner.getId()%>",
				end: function(){
					location.reload();
				}
			});
		<%}%>
	}
	//职位维护
	function deprole() {
		<%if (currentowner!=null){%>
		var index = parent.layer.open({
			type: 2,
			title: '职位维护',
			area: ['100%','100%'],
			content: "<%=request.getContextPath()%>/uum/postAction.jsp?action=init&deptid=<%=currentowner.getId()%>",
			end: function(){
				location.reload();
			}
		});
		<%}%>
	}
    //角色维护
	function aclrole() {
		var index = parent.layer.open({
			type: 2,
			title: '角色维护',
			area: ['100%','100%'],
			content: "<%=request.getContextPath()%>/uum/aclroleAction.do?action=init",
			end: function(){
				location.reload();
			}
		});
	}
    //用户排序
    function userSort() {
    	var index = parent.layer.open({
			type: 2,
			title: '用户排序',
			area: ['100%','100%'],
			content: "category.jsp?pid=<%=currentowner == null ? "" : currentowner.getId()%>",
			end: function(){
				location.reload();
			}
		});
    }
    //批量导入
    function imports() {
       	var index = parent.layer.open({
			type: 2,
			title: '批量导入',
			area: ['100%','100%'],
			content: "importuserfromxls.jsp",
			end: function(){
				location.reload();
			}
		});
    }
</script>
</body>
</html>
<!--索思奇智版权所有-->