<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@page import="java.util.ArrayList"%>
<%@page import="com.kizsoft.oa.wzbwsq.util.GsonHelp"%>
<%@page import="com.kizsoft.commons.commons.orm.MyDBUtils"%>
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

<%@page import="java.sql.Statement" %>
<%@page import="com.kizsoft.commons.util.Pageination" %>
<%
String userTemplateName = (String) session.getAttribute("templatename");
String userTemplateStr = "/resources/template/" + userTemplateName + "/contenttemplate.jsp";
if(userTemplateName==null||"".equals(userTemplateName)){
	userTemplateStr = "/resources/jsp/template.jsp";
}
%>
<template:insert template="<%=userTemplateStr%>">
<template:put name='title' content='用户查询' direct='true'/>
<%String str = "<a class=\"menucur\" href=\"cost_card\">用户查询</a>";%>
<template:put name='moduleNav' content='<%=str%>' direct='true'/>
<template:put name='content'>
<% if (session.getAttribute("userInfo") == null) {
	response.sendRedirect(request.getContextPath() + "/login.jsp");
} else {
User userInfo = (User) session.getAttribute("userInfo");
String userID = userInfo.getUserId();
ACLManager aclManager = ACLManagerFactory.getACLManager();
String ownercode=request.getParameter("ownercode")==null?"":request.getParameter("ownercode");
String ownername=request.getParameter("ownername")==null?"":request.getParameter("ownername");
String depid=request.getParameter("depid")==null?"":request.getParameter("depid");
String position=request.getParameter("position")==null?"":request.getParameter("position");
String mobile=request.getParameter("mobile")==null?"":request.getParameter("mobile");
String mobileshort=request.getParameter("mobileshort")==null?"":request.getParameter("mobileshort");
String phone=request.getParameter("phone")==null?"":request.getParameter("phone");


Object[] obj = new Object[]{ownercode,ownername};


Connection db = null;
Statement ps = null;
ResultSet rs = null;


int curPage = 1;
int rowsPerPage = 30;
if (request.getParameter("page") != null && !request.getParameter("page").equals("")) {
	curPage = Integer.parseInt(request.getParameter("page"));
} else {
	 curPage = 1;
}
pageContext.setAttribute("curPage", String.valueOf(curPage));	
//取出分页数据
//根据类型ID取得相关记录信息
//加入数据SQL语句-开始

String sql = "select o.id,o.ownercode,o.ownername,o.position,o.mobile,o.mobileshort,o.phone,(select ownername from owner where owner.id = (select max(parentid) from ownerrelation a where a.ownerid = o.id)) parentname from owner o where flag='1' and status='1'";
List objList = new ArrayList();
if(""!=ownercode){
	sql +=" and o.ownercode like ?";
	objList.add("%"+ownercode+"%");
}
if(""!=ownername){
	sql +=" and o.ownername like ?";
	objList.add("%"+ownername+"%");
}
if(""!=position){
	sql +=" and o.position like ?";
	objList.add("%"+position+"%");
}
if(""!=mobile){
	sql +=" and o.mobile like ?";
	objList.add("%"+mobile+"%");
}
if(""!=mobileshort){
	sql +=" and o.mobileshort like ?";
	objList.add("%"+mobileshort+"%");
}
if(""!=phone){
	sql +=" and o.phone like ?";
	objList.add("%"+phone+"%");
}
if(""!=depid){
	sql +=" and o.id in(SELECT ownerid FROM ownerrelation START WITH parentid =? CONNECT BY PRIOR ownerid = parentid)";
	objList.add(depid);
}

MyDBUtils dbu = new MyDBUtils();
Object[] objs = new Object[objList.size()];
for(int j = 0; j < objList.size(); j++) {
	objs[j] = objList.get(j);
}
List list = dbu.queryForMap(sql, objs);
String json = GsonHelp.toJson(list);
%>
<html>
<head>
	<title></title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<link rel="stylesheet" href="<%=request.getContextPath() %>/resources/template/cn/layui/css/layui.css" media="all" />
<style>
	.layui-form-item .layui-form-label {
		width: 56px;
	}
	.layui-form-item .layui-input-inline {
		width: 181px;
	}
</style>
</head>

<body style="padding:10px">
<blockquote class="layui-elem-quote">高级查询</blockquote>
<div style="background-color:#f2f2f2;padding:10px">
  <div class="layui-form-item">
    <div class="layui-inline">
      <label class="layui-form-label">登录名</label>
      <div class="layui-input-inline">
        <input type="tel" name="ownercode" autocomplete="off" class="layui-input">
      </div>
    </div>
    <div class="layui-inline">
      <label class="layui-form-label">姓名</label>
      <div class="layui-input-inline">
        <input type="text" name="ownername" autocomplete="off" class="layui-input">
      </div>
    </div>
    <div class="layui-inline">
      <label class="layui-form-label">部门</label>
      <div class="layui-input-inline">
        <input type="text" name="depname" autocomplete="off" class="layui-input">
      </div>
      <img style="position:absolute;top:9px" id="iimg" src="<%=request.getContextPath()%>/resources/images/actn133.gif">&nbsp;
	  <input type="hidden" name="depid"/>
    </div>
    <div class="layui-inline">
      <label class="layui-form-label">职务</label>
      <div class="layui-input-inline">
        <input type="text" name="position" autocomplete="off" class="layui-input">
      </div>
    </div>
    <div class="layui-inline">
      <label class="layui-form-label">手机</label>
      <div class="layui-input-inline">
        <input type="text" name="mobile" autocomplete="off" class="layui-input">
      </div>
    </div>
    <div class="layui-inline">
      <label class="layui-form-label">短号</label>
      <div class="layui-input-inline">
        <input type="text" name="mobileshort" autocomplete="off" class="layui-input">
      </div>
    </div>
    <div class="layui-inline">
      <label class="layui-form-label">办公短号</label>
      <div class="layui-input-inline">
        <input type="text" name="phone" autocomplete="off" class="layui-input">
      </div>
    </div>
    <div class="layui-inline" style="margin-left: 42px">
       <button class="layui-btn" type="button" lay-submit="" id="sub" lay-filter="sub">查询</button>
       <button type="reset" class="layui-btn layui-btn-primary">重置</button>
    </div>
  </div>
</div>
<table id="gjcx" lay-filter="gjcx"></table>
<script type="text/javascript" src="<%=request.getContextPath() %>/resources/js/jquery/jquery-1.11.0.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath() %>/resources/template/cn/layui/layui.js"></script>
<script type="text/javascript">
var layer = "";
	layui.use(['table','form','layer'], function() {
		var table = layui.table
		,form = layui.form;
		layer = layui.layer;
		
		$('#sub').click(function(){
			
			var ownercode=$('[name=ownercode]').val();
			var ownername=$('[name=ownername]').val();
			var depid=$('[name=depid]').val();
			var position=$('[name=position]').val();
			var mobile=$('[name=mobile]').val();
			var mobileshort=$('[name=mobileshort]').val();
			var phone=$('[name=phone]').val();
			//alert(ownercode+"-"+ownername+"-"+depid+"-"+position+"-"+mobile+"-"+mobileshort+"-"+phone);
			//var url = "user.do?action=query&depid=%"+depid+"%&ownercode=%" + ownercode + "%&ownername=%" + ownername + "%&position=%" + position + "%&mobile=%" +mobile+ "%&mobileshort=%"+mobileshort+ "%&phone=%"+phone+"%";
			var url = "user.do?action=query&depid="+depid+"&ownercode=" + ownercode + "&ownername=" + ownername + "&position=" + position + "&mobile=" +mobile+ "&mobileshort="+mobileshort+ "&phone="+phone
			window.location = url;
		});;
		
		$('#iimg').click(function(){
			openSelWin('<%=request.getContextPath()%>/address/tree.jsp?utype=2&rtype=0&ptype=0&sflag=0&count=0&fields=depname,depid'); 
		});
		 //渲染tab
		table.render({
		  elem: '#gjcx'
		  ,height: 'full-135'
		  ,page: true //开启分页
		  ,data: <%=json%>
		  ,cols: [[ //表头
		    {field: 'OWNERCODE', title: '登陆名'}
		    ,{field: 'OWNERNAME', title: '姓名'}
		    ,{field: 'PARENTNAME', title: '部门'}
		    ,{field: 'POSITION', title: '职务'} 
		    ,{field: 'MOBILE', title: '手机'}
		    ,{field: 'MOBILESHORT', title: '短号'}
			,{field: 'PHONE', title: '办公室电话'}
		  ]]
	});
		
		
});
</script>
<script type="text/javascript" src="<%=request.getContextPath() %>/resources/template/cn/layui/layerFunction.js"></script>
</body>
</html>
<%}%>
</template:put>
</template:insert>			<!--索思奇智版权所有-->