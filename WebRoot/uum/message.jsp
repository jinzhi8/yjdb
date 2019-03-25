<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% String reloadParent = (String) request.getAttribute("reloadParentNode");
	String closeflag = (String) request.getAttribute("closeflag");%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="<%=request.getContextPath() %>/resources/template/cn/layui/css/layui.css" media="all" />

	<script language="javascript1.2">
		<%if (reloadParent !=null && reloadParent.equals("true")){%>
		<%}%>
		<%if (closeflag !=null && closeflag.equals("true")){%>
		window.close();
		<%}%>
		window.focus();
	</script>
</head>
<body>
<div style="width: 50%;height: 48%;position: absolute;top: 28%;left: 26%;border:1px solid #0000002e">
	<p style="background-color:#0000002e;height: 29px;background-color: #0000002e;padding-top: 9px;padding-left: 14px;font-size: 14px;">系统信息</p>
	<span style="position: absolute;font-size: 20px;top: 81px;left: 141px;">保存成功!</span>
	<p><button type="button" class="layui-btn layui-btn-normal layui-btn-sm" id="close" style="position:absolute;right:5px;bottom:5px">关闭</button></p>
</div>
<script type="text/javascript" src="<%=request.getContextPath() %>/resources/template/cn/layui/layui.js"></script>
<script type="text/javascript">
	layui.use(['layer','jquery'], function() {
		var layer = layui.layer
		,$ = layui.jquery;
		$('#close').click(function(){
			var index = top.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
			top.layer.close(index);
		});
	})
</script>
</body>
</html>
<!--索思奇智版权所有-->