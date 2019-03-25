<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<script language="javascript1.2">
		function backFunc() {
			window.history.go(-1);
		}
	</script>
</head>
<body>
<table width="500" border="0" align="center" cellpadding="0" cellspacing="0" height="100%">
	<tr>
		<td>
			<div class="sidebox" height="100%">
				<div class="boxhead">
					<h2>系统信息</h2>
				</div>
				<div class="boxbody">
					<%String mes = (String) request.getAttribute("message");%>
					<%=mes%>
					<p>
						<input type=button name=btnok class="btn" id="close" value="关闭">
						<a href=# onclick="backFunc()">重新输入</a>
					</p>
				</div>
			</div>
		</td>
	</tr>
</table>
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