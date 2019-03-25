<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
	<title>地址本选择</title>

	<script type="text/javascript" src="js/xtree.js"></script>
	<script type="text/javascript" src="js/treecheck.js"></script>
	<script type="text/javascript">
		function setvalue() {
			window.dialogArguments.document.all.setvalue.click();
		}
	</script>

	<link type="text/css" rel="stylesheet" href="css/xtree.css"/>

</head>
<body style="font-size:9pt">

<br/>
<table width="100%" border="0">
	<tr>
		<td>
			<div style="width:100%;height:280px;overflow:auto">
				<script type="text/javascript">
					//var atree = new WebFXLoadTree("组织机构","tree.do");					//document.write(atree);					//document.write(new loadWebFX("组织机构","tree.do"));
					loadWeb();
				</script>
			</div>
		</td>
		<td style="width:150px;border-left:#808080 2px solid;" valign="top">
			<div id="userdiv" style="width:100%;height:260px;overflow:auto">已选择<span style="color:red">0</span>个用户<hr/>&nbsp;</div>
		</td>
	</tr>
</table>
<div align="center">
	<input type=button value="确定" onclick="confirmSelection();setvalue();window.close();"/>
	&nbsp;&nbsp;
	<input type=button value="取消" onclick="window.close();"/>
	&nbsp;&nbsp;
	<input type=button value="清空" onclick="clear_All();confirmSelection();setvalue();window.close();"/>
	&nbsp;&nbsp;
</div>
<br/>
<br/>
<hr/>
</body>
<script type="text/javascript">
	//window.resizeTo(screen.availWidth, screen.availHeight);
	var w = 480;
	var h = 350;
	window.dialogWidth = w + "px";
	window.dialogHeight = h + "px";
	window.dialogLeft = (screen.availWidth - w) / 2;
	window.dialogTop = (screen.availHeight - h) / 2;
</script>
</html>
<!--索思奇智版权所有-->