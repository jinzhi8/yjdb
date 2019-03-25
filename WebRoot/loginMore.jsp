<%@page import="com.kizsoft.yjdb.utils.CommonUtil"%>
<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Map"%>
<%@page import="com.kizsoft.yjdb.ding.UserServlet"%>
<%@page import="com.kizsoft.commons.commons.orm.MyDBUtils"%>
<%@page import="com.kizsoft.yjdb.utils.GsonHelp"%>

<%
	String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
	String mobile=CommonUtil.doStr((String)session.getAttribute("mobile"));
	List<Map<String,Object>> list=UserServlet.getUserInfo(mobile);
	
%>
<head>
	<title>单位选择</title>
	<meta name="renderer" content="webkit">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
	<meta name="apple-mobile-web-app-status-bar-style" content="black">
	<meta name="apple-mobile-web-app-capable" content="yes">
	<meta name="format-detection" content="telephone=no">
	<link rel="stylesheet" href="js/layui/css/layui.css" media="all" />
	<link rel="stylesheet" href="css/public.css" media="all" />
	<script type="text/javascript" src="js/layui/layui.js"></script>
	<script type="text/javascript" src="js/jquery-1.11.0.min.js"></script>
	<script type="text/javascript">
	layui.use(['form', 'layer', 'laydate', 'table', 'laytpl'], function () {
	    var form = layui.form,
	        layer = layui.layer,
	        laydate = layui.laydate,
	        laytpl = layui.laytpl;
	    
	  //复选框多选变单选
	  form.on('checkbox', function (data) {
	        var name = data.elem.getAttribute("name");
	        if (data.elem.getAttribute("lay-check-type") === "radio" && name) {
	            var domArr = document.getElementsByName(name);
	            var checked = false;
	            for (var i = 0; i < domArr.length; i++) {
	                if (domArr[i] !== data.elem && domArr[i].getAttribute("lay-check-type") === "radio") {
	                    if (data.elem.checked) {
	                        domArr[i].checked = false;
	                    } else if (domArr[i].checked) {
	                        checked = true;
	                    }
	                }
	            }
	            data.elem.checked = !checked ? true : data.elem.checked;
	            form.render('checkbox');
	        }
	    });
	  
	  form.on('submit(button)', function (data) {
	   		if(data.field.depname==undefined){
	   			layer.msg("请选择部门！");
	   			return ;
	   		}
          if(data.field.user==undefined){
              layer.msg("请选择用户！");
              return ;
          }
	   		$.ajax({
	   			type:"post",
	   			url:"success.jsp",
	   			data:{
	   				depid:data.field.depname,
                    userid:data.field.user,
	   				status:"4"
	   			},
	   			dataType:'html',
	   			success:function(data){
				  	var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
				  	window.parent.layer.close(index);
	   			}
	   		});
	    });
	  
	});
	</script>
</head>
<body class="childrenBody">
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
  <legend>请选择您所在部门:</legend>
</fieldset>
<div class="layui-form layui-form-pane">
	<div class="layui-form-item">
		<label class="layui-form-label"><i class="hongdian">*</i>用户</label>
		<div class="layui-input-block">
			<%for(Map<String,Object> map:list){
				String ownername=(String)map.get("ownername");
				String id=(String)map.get("id");
				String position=CommonUtil.doStr((String) map.get("position"));
			%>
				<input type="checkbox" name="user" value="<%=id%>" title="<%=ownername+'('+position+')'%>"   lay-check-type="radio">
			<%}%>
		</div>
		<label class="layui-form-label"><i class="hongdian">*</i>部门</label>
		<div class="layui-input-block">
			 <%for(Map<String,Object> map:list){
				 String id=(String)map.get("id");
				 List<Map<String,Object>> depList=UserServlet.getDepidInfo(id);
				 for (Map<String,Object> dmap:depList){
					 String depid=(String)dmap.get("ownerid");
					 String dep=(String)dmap.get("ownername");
			 %>
				 <input type="checkbox" name="depname" value="<%=depid%>"  title="<%=dep%> "  lay-check-type="radio">
			<%	}
			 }
			%>
		</div>
		</br/>
		<div class="layui-form-item bottom-btn-wrap">
			<submit class="layui-btn" lay-submit="" lay-filter="button" >确定</submit>
		</div>
	</div>
</div>
</body>