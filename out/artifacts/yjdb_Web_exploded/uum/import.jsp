<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@page import="java.util.ArrayList"%>
<%@page import="com.kizsoft.oa.wzbwsq.util.GsonHelp"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="com.kizsoft.commons.acl.ACLManager" %>
<%@page import="com.kizsoft.commons.acl.ACLManagerFactory" %>
<%@page import="com.kizsoft.commons.commons.db.ConnectionProvider" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.uum.actions.Pagination" %>
<%@page import="com.kizsoft.commons.uum.pojo.Owner" %>
<%@page import="java.sql.Connection" %>
<%@page import="java.sql.PreparedStatement" %>
<%@page import="java.sql.ResultSet" %>
<%@page import="java.util.List" %>
<%@ page import="com.kizsoft.commons.commons.user.UserManager" %>
<%@ page import="com.kizsoft.commons.commons.user.UserManagerFactory" %>
<%@ page import="com.kizsoft.commons.util.MD5" %>
<%@ page import="com.kizsoft.commons.commons.user.UserException" %>
<% 
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
	}

	Owner currentowner = (Owner) request.getAttribute("currentowner");
	String ut = (String) request.getAttribute("ut");
	String getSelFlag = request.getParameter("selflag");
	String getLoginName = request.getParameter("loginname");
	if (getLoginName == null) getLoginName = "";
	String getUserName = request.getParameter("username");
	if (getUserName == null) getUserName = "";
	/*
		 if (getUserName!=null) {
			 getUserName = new String(getUserName.getBytes("iso-8859-1"),"gbk");
		 }else {getUserName = "";}
		 */

%>
<html>
<head>
	<title>人事调入</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<link rel="stylesheet" href="<%=request.getContextPath() %>/resources/template/cn/layui/css/layui.css" media="all" />
</head>
<script language=Javascript>
	function loadData() {
		document.form2.submit();
	}
</script>
<style>
	.he .layui-form-item label {
		width: 57px
	}
	.he .layui-input-inline{
		width: 130px
	}
</style>
<body style="background:#FFFFFF;padding:5px">
<form name="form1" method="post" class="layui-form" action="user.do">
  <input type=hidden name="parentid" value="<%=currentowner.getId()%>">
  <div class="he" style="padding:5px;background-color:#f2f2f2">
  <div class="layui-form-item" style="margin:0px">
    <div class="input-inline">
	  <label class="layui-form-label">用户类别</label>
	  <div class="layui-input-inline">
	     <select name="selusertype" lay-filter="yhlb">
	      <option value="0" <% if (ut.equals("0")) out.print("selected");%>>无部门</option>
	      <option value="1" <% if (ut.equals("1")) out.print("selected");%>>本部门</option>
	    </select>
	  </div>
	</div>
	<% User userInfo = (User) session.getAttribute("userInfo");
		String userID = userInfo.getUserId();
		ACLManager aclManager = ACLManagerFactory.getACLManager();
		if (aclManager.isOwnerRole(userID, "sysadmin")) { %>
	<div class="inline">
	  <label class="layui-form-label">登入名</label>
      <div class="layui-input-inline">
      	<input type="text" name="loginname" lay-verify="dd" value="<%=getLoginName%>" autocomplete="off" class="layui-input">
      </div>
	</div>
	<div class="inline">
	  <label class="layui-form-label">姓名</label>
      <div class="layui-input-inline">
      	<input type="text" name="username" lay-verify="dd" value="<%=getUserName%>" autocomplete="off" class="layui-input">
      </div>
	</div>
	<input type=hidden name="selflag" value="0">
	<div class="inline">
	  <button class="layui-btn" type="button" lay-submit="subtn" lay-filter="subtn" name="seluser">查询</button>
	</div>
	<% } %>
  </div>	
  </div>
  <table id="rstab" lay-filter="rstab"></table>


</form>
<button name="Submit" id="Submit" type="button" class="layui-btn layui-btn-normal" style="position: absolute;right: 28px;bottom: 19px;">保存</button>

<script language="javascript">
	//确认调入
	function saveimport() {
		document.form1.action = "user.do?action=saveimport";
		document.form1.submit();
	}
	function refresh() {
		var usertype = document.form1.selusertype.value;
		document.form1.action = "user.do?action=import&usertype=" + usertype;
		document.form1.submit();
	}


	//alter on 2006-06-16 用户查询功能
	function doselect() {
		var loginname = document.form1.loginname.value;
		var username = document.form1.username.value;
		if ((loginname == null || loginname == "") && (username == null || username == "")) {
			alert("请输入查询条件！");
			return false;
		}
		document.form1.selflag.value = "1";
		var url = "user.do?action=import&usertype=0&parentid=" + document.form1.parentid.value + "&loginname=" + loginname + "&username=" + encodeURIComponent(username) + "&selflag=" + document.form1.selflag.value;
		window.location = url;
	}		//alter end
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
		  ,height: 'full-80'
		  ,page: true //开启分页
		  ,url: "userAction.jsp"
		  ,id: 'rstab'
		  ,where: {action: 'importList'}
		  ,cols: [[ //表头
			 {type:'checkbox'}
		    ,{field: 'OWNERCODE', title: '登陆名'}
		    ,{field: 'OWNERNAME', title: '姓名'}
		    ,{field: 'dw', title: '单位'}
		    ,{field: 'mobile', title: '手机'} 
		    ,{field: 'UUMType', title: '类别', templet: '#lb'}
		  ]]
		});
		 
		//监听工具条
		table.on('tool(userTab)', function(obj){ //注：tool是工具条事件名，test是table原始容器的属性 lay-filter="对应的值"
		  var data = obj.data; //获得当前行数据
		  var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
		  var tr = obj.tr; //获得当前行 tr 的DOM对象
		 
		  if(layEvent === 'detail'){ //查看
		    //do somehing
		  } else if(layEvent === 'check'){ //删除
				if(data.status == '1') {
					disableUser(data.id);
				}else{
					ableUser(data.id);
				}
		  } else if(layEvent === 'edit'){ //编辑
			    editUser(data.id);
		  }
		});

		//搜索
		form.on('submit(subtn)', function(data){
			  tab.reload({
					where: {
						ownercode: $('[name=loginname]').val()
						,ownername: $('[name=username]').val()
						,action: "importSelect"
					}
			  });
		});
		
		//确认调入
		$('#Submit').click(function(){
			var checkStatus = table.checkStatus('rstab'); //获取选中行
			if(checkStatus.data.length) {
				var chkid = "";
				for (var i = 0; i < checkStatus.data.length; i++) {
					if(i < checkStatus.data.length-1){
						chkid += checkStatus.data[i].ID + ",";
					} else {
						chkid += checkStatus.data[i].ID;
					}
				}
				$.ajax({
					url: "userAction.jsp",
					data: {
						action: 'importSave',
						parentid: '<%=currentowner.getId()%>',
						chkid: chkid
					},
					success: function() {
						tab.reload();
					}
				});
			} else {
				layer.msg("请选择调入用户");
			}
			
			
		});
		
	/**	查询验证是否都是空
	form.verify({
			  dd: function(value, item){ //value：表单的值、item：表单的DOM对象
			    if($('[name=loginname]').val() == "" && $('[name=username]').val() == "") {
			    	return "请输入查询条件！";
			    }
			  }
		});    */
		
	})
</script>
<script type="text/html" id="lb">
	{{# if(d.type == 1) { }}
		系统管理员
	{{# } else if(d.type == 2) { }}
		部门管理员
	{{# } else { }}
		普通用户
	{{# } }}
</script>
</body>
</html>