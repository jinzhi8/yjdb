<%@page language="java" contentType="text/html;charset=UTF-8" %>

<%@page import="com.kizsoft.commons.commons.orm.SimpleORMUtils" %>
<%@page import="java.util.ArrayList" %>
<%@page import="java.util.List" %>
<%@page import="java.util.Map" %>
<%@page import="com.kizsoft.commons.commons.config.SystemConfig" %>
<%@page import="com.kizsoft.commons.commons.orm.SimpleORMUtils"%>

<%
	String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
	String unid= request.getParameter("unid");
	SimpleORMUtils instance=SimpleORMUtils.getInstance();	
	List<Map<String,Object>> ddmessage=instance.queryForMap("select * from zwdb_ddmessage where docunid=? order by time desc",unid);
	
%>
<html>
<head>
  <meta charset="utf-8">
  <title><%=SystemConfig.getFieldValue("//systemconfig/system/name")%></title>
  <meta name="renderer" content="webkit">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
  <script type="text/javascript" src="<%=contextPath%>/js/jquery-1.11.0.min.js"></script>
  <script type="text/javascript" src="<%=contextPath%>/js/layer/layer.js" ></script>
  <link rel="stylesheet" href="<%=request.getContextPath()%>/js/layui/css/layui.css"  media="all">
  <script type="text/javascript" src="<%=contextPath%>/js/jquery.form.js" ></script>
</head>
<body>
  <form id='fileForm' enctype='multipart/form-data' class="layui-form layui-form-pane">
  	<fieldset class="layui-elem-field layui-field-title" style="margin-top: 50px;">
	  <legend>钉钉消息推送</legend>
	</fieldset>
	<div class="layui-form-item">
	    <label class="layui-form-label">联系人姓名</label>
	    <div class="layui-input-block">
	      <input type="text" name="name" autocomplete="off" placeholder="多个姓名请用英文逗号隔开" class="layui-input">
	    </div>
    </div>
	<div class="layui-form-item">
	    <label class="layui-form-label">请输入号码</label>
	    <div class="layui-input-block">
	      <input type="text" name="phone" autocomplete="off" placeholder="多个号码请用英文逗号隔开" class="layui-input">
	    </div>
    </div>
	<div class="layui-form-item layui-form-text">
	    <label class="layui-form-label">推送内容</label>
	    <div class="layui-input-block">
	      <textarea placeholder="请输入推送内容" class="layui-textarea" name="nr"></textarea>
	    </div>
	</div>
	<div class="layui-form-item">
	    <input type="button" class="layui-btn"  onclick="fhmessage();" value="提交">
	 </div>
	 <% 
		for(int i=0;i<ddmessage.size();i++){	
			Map<String,Object> map =ddmessage.get(i); 
	 %>
		 <div class="layui-form-item">
		    <label class="layui-form-label">推送结果</label>
		    <div class="layui-input-block">
		      <input type="text" name="name" autocomplete="off"  value="<%=map.get("dbmessage")%>(<%=map.get("username") %>)"   class="layui-input">
		    </div>
	    </div>
	 <%}%>
  </form>
</body>
<script type="text/javascript">
  function fhmessage(){
		var phone=$("[name=phone]").val();
		var nr=$("[name=nr]").val();
		var name=$("[name=name]").val();
		var unid="<%=unid%>";
		if(phone==""){
			layer.alert('号码不能为空!');
			return false;
		}
		if(nr==""){
			layer.alert('推送内容!');
			return false;
		}
		$.ajax({
			type:"post",
			url:"<%=request.getContextPath()%>/zwdbfk/ddAction.jsp",
			data:{"phone":phone,"nr":nr,"unid":unid,"name":name},
			success:function(data){
				window.location.href=window.location.href;
			}
		});
	}
</script>
</html>
