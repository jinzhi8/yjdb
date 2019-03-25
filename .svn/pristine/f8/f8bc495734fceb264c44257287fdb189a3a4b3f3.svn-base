<%@page language="java" contentType="text/html;charset=UTF-8" %>

<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<%if (session.getAttribute("userInfo") == null) {
	response.sendRedirect(request.getContextPath() + "/login.jsp");
} else {%>
<%
String userTemplateName = (String) session.getAttribute("templatename");
String userTemplateStr = "/resources/template/" + userTemplateName + "/template.jsp";
if(userTemplateName==null||"".equals(userTemplateName)){
	userTemplateStr = "/resources/jsp/template.jsp";
}
%>
<template:insert template="<%=userTemplateStr%>">
	<template:put name='title' content='修改密码' direct='true'/>
	<%String str = "";%>
	<template:put name='moduleNav' content='<%=str%>' direct='true'/>
	<template:put name='content'>
	<div style="margin: 0px 25px;">
		<% //用户登陆验证
			User userInfo = (User) session.getAttribute("userInfo");
			Group groupInfo = userInfo.getGroup();
			String userID = userInfo.getUserId();%>
		<FORM class="layui-form" name="form1" action="personalAction.do?action=changepassword" method="post" style="padding:10px">
			<blockquote class="layui-elem-quote">
				<span class="" style="font-size:22px">修改密码</span>
			</blockquote>
			
			<input type="hidden" name="userId" value="<%=userID%>">
			
			  <div class="layui-form-item">
			    <label class="layui-form-label">您的旧密码</label>
			    <div class="layui-input-inline">
			      <input type="password" name="oldPass" required  lay-verify="required" placeholder="请输入您的旧密码" autocomplete="off" class="layui-input">
			    </div>
			  </div>
			  <div class="layui-form-item">
			    <label class="layui-form-label">您的新密码</label>
			    <div class="layui-input-inline">
			      <input type="password" name="newPass" required  lay-verify="required" placeholder="请输入您的旧密码" autocomplete="off" class="layui-input">
			    </div>
			  </div>
			  <div class="layui-form-item">
			    <label class="layui-form-label">确认新密码</label>
			    <div class="layui-input-inline">
			      <input type="password" name="chkPass" required  lay-verify="chkPass" placeholder="请输入您的新密码" autocomplete="off" class="layui-input">
			    </div>
			  </div>
			  
			   <div class="layui-form-item">
			    <div class="layui-input-block">
			      <button class="layui-btn" lay-submit lay-filter="formDemo">确定</button>
			      <button type="reset" class="layui-btn layui-btn-primary">重置</button>
			    </div>
			  </div> 
			  </form>
			  
<script type="text/javascript">		
	layui.use(['form','jquery','layer'],function(){
		var form = layui.form
		,$ = layui.jquery
		,layer = layui.layer;
		
		form.verify({
			chkPass: function(value, item){
				var newp = $('[name = "newPass"]').val();
				if(newp != value){
					layer.msg("密码不一致");
					return "密码不一致";
				}
			}
		});
	});
</script>	  
	</template:put>
</template:insert>
<%}%><!--索思奇智版权所有-->