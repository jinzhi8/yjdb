<%@page import="com.kizsoft.commons.commons.orm.MyDBUtils"%>
<%@page import="java.util.List"%>
<%@page import="com.kizsoft.oa.wzbwsq.util.GsonHelp"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="com.kizsoft.commons.acl.ACLManager" %>
<%@page import="com.kizsoft.commons.acl.ACLManagerFactory" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.uum.utils.UUMConf" %>
<%@ page import="com.kizsoft.commons.uum.service.IUUMService" %>
<%@ page import="com.kizsoft.commons.uum.utils.UUMContend" %>

<%//用户登陆验证
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
	}
	User userInfo = (User) session.getAttribute("userInfo");
	String userID = userInfo.getUserId();
	ACLManager aclManager = ACLManagerFactory.getACLManager();
	//HttpSession session = request.getSession();
	IUUMService uumService = UUMContend.getUUMService();
    com.kizsoft.commons.commons.user.User user = (com.kizsoft.commons.commons.user.User) session.getAttribute("userInfo");
    String account = user.getAccount();
	com.kizsoft.commons.uum.pojo.Owner owner = uumService.getOwnerByOwnercode(account);
	if (owner != null) {
		com.kizsoft.commons.uum.Visit visit = new com.kizsoft.commons.uum.Visit();
		visit.setOwner(owner);
		java.util.List parentlist = uumService.getParentsByOwnerId(owner.getId());
		visit.setDeptlist(parentlist);
		java.util.List rolelist = com.kizsoft.commons.acl.utils.ACLContend.getACLService().getRoleByOwnerId(owner.getId());
		visit.setRolelist(rolelist);
		session.setAttribute("visit", visit);
		
		//System.out.println(GsonHelp.toJson(rolelist));
		//System.out.println(GsonHelp.toJson(parentlist));
	}		
%>

<html>
<head>
	<title>用户</title>
	<script type="text/javascript" src="js/xtree.js"></script>
  	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<link type="text/css" rel="stylesheet" href="css/xtree.css"/>
	<link rel="stylesheet" href="<%=request.getContextPath() %>/resources/template/cn/layui/css/layui.css" media="all" />
	<style type="text/css">
		.layui-form-checkbox span {
			height:18px
		}
	</style>
	<%
		String treename = (String) UUMConf.get("tree.rootvalue");
	%>
	<script language="javascript">
		var tmp ;
		function reload() {
			if (tmp == "") {
				atree.reload();
			} else {
				refreshNode(tmp);

			}
		}

		function upnode(id, parentid, divid) {
			if (!parentid) {
				tmp = "";
			} else {
				tmp = divid;
			}
			var xmlHttp1 = XmlHttp.create();
			var aa = "tree.do?action=upnode&id=" + id + "&parentid=" + parentid ;
			xmlHttp1.open("POST", aa, false);	// async
			xmlHttp1.send(null);
			this.reload();
		}
		function downnode(id, parentid, divid) {
			if (!parentid) {
				tmp = "";
			} else {
				tmp = divid;
			}
			var xmlHttp2 = XmlHttp.create();
			var aa = "tree.do?action=downnode&id=" + id + "&parentid=" + parentid ;
			xmlHttp2.open("POST", aa, false);	// async
			xmlHttp2.send(null);
			this.reload();
		}

		function newsubchild(id, divid) {
			tmp = divid;
			newopen = window.open("subowner.do?action=addnewsub&id=" + id, "", "width=500,height=250");
		}
		/**
		 *edit the nodes
		 * ◎parm the node is
		 */
		function editNode(id, divid, parentvalue) {
			tmp = divid;
			if (!parentvalue) {
				tmp = "";
			}
			newopen = window.open("owner.do?action=edit&id=" + id, "", "width=500,height=250");
		}

		function rmchild() {
			if (confirm("执行此操作！请再仔细核对一下，确实要删除该部门嘛？")) {
				tmp = "";
				document.form1.ids.value = atree.getSelectIds();
				document.form1.submit();
			} else {
				return false;
			}
		}

		function newdept() {
			tmp = "";
			newopen = window.open("tree.do?action=newdept", "", "width=500,height=250");
		}
		function showNode(id) {
			parent.toc1.form2.id.value = id;
			parent.toc1.loadData();
		}
	</script>
</head>
<body style="padding:10px;border-right: 2px solid #eeeeee;">

<blockquote class="layui-elem-quote quoteBox" style="padding:13px">
	<%if (aclManager.isOwnerRole(userID, "sysadmin")) {%>
	<button class="layui-btn layui-btn-normal layui-btn-sm" id="newdept">添加</button>
	<%}%>
 	<button class="layui-btn layui-btn-danger layui-btn-sm" id="rmchild">删除</button>
</blockquote>
<!-- 
<form class="layui-form">
	<div id="ztree1" style="padding: 10px 0 25px 5px;"></div>
</form>

-->
<form action="tree.do?action=rmnode" name="form1" method="post">
	<input type="hidden" name="ids"/>
</form>
<br>
<table width="100%" border="0">
	<tr>
		<td>
			<div style="background:#ffffff;width:100%;height:100%;overflow:true">
				<script type="text/javascript">
					var atree = new WebFXLoadTree("<%=treename%>", "tree.do");
					document.write(atree);
				</script>
			</div>
		</td>
	</tr>
	<!--
   <tr valign="top">
	 <td>
	   <table width="200" border="0">
		 <tr>
		   <td colspan="2"><strong>快捷键定义: </strong></td>
		 </tr>
		 <tr>
		   <td width="96" align="right"><strong><u>e</u>(edit)</strong></td>
		   <td width="94"><strong>编辑节点</strong></td>
		 </tr>
		 <tr>
		   <td align="right"><strong><u>n</u>(new)</strong></td>
		   <td><strong>添加子部门</strong></td>
		 </tr>
		 <tr>
		   <td align="center"><strong><u><</u></strong>：上移</td>
		   <td align="center"><strong><strong><u>></u></strong>：下移</strong></td>
		 </tr>
	   </table>
	 </td>
   </tr>
 -->
</table>
<script type="text/javascript" src="<%=request.getContextPath() %>/resources/template/cn/layui/layui.js"></script>
<script type="text/javascript">
	layui.use(['layer','jquery','form'], function() {
		var form = layui.form
		,layer = layui.layer
		,$ = layui.jquery;
		
		$('#newdept').click(function(){
			top.layer.open({
				  type: 2,
				  title:'部门管理--增加',
				  area: ['700px', '400px'],
				  content: '<%=request.getContextPath()%>/uum/tree.do?action=newdept',	 
				  end: function(){
						location.reload();
				  }
			}); 
		});

		$('#rmchild').click(function(){
			top.layer.confirm('执行此操作！请再仔细核对一下，确实要删除该部门嘛？',function(index) {
				tmp = "";
				document.form1.ids.value = atree.getSelectIds();
				document.form1.submit();
				top.layer.close(index);
			});
		});
		//左侧tree
	//	$.ajax({
	//		url: '<%=request.getContextPath()%>/uum/Action.jsp'
	//		data: {'action':'tree'},
	//		dataType: 'json',
	//		success: function(data){
	//			var xtree = new layuiXtree({
	//			      elem: 'ztree1'   
	//			      , form: form
	//			      , data: data
	//			      , click: function (data) {  //节点选中状态改变事件监听，全选框有自己的监听事件
	//			    	  showNode(data.value);
	//			       	}
	//			});
	//		}
	//	});
		
		
		
		
		
	});
</script>

</body>
</html>
<!--索思奇智版权所有-->