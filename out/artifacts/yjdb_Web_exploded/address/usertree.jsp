<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
	<title>组织机构</title>
	<script type="text/javascript" src="js/xtree.js"></script>
	<script type="text/javascript" src="js/treecheck.js"></script>
	<link type="text/css" rel="stylesheet" href="css/xtree.css"/>
</head>
<body style="font-size:9pt">
<!--
&nbsp;<input type=text name="searchstr" value="" size="20">
<input type=button value="搜索" onclick="_find(document.getElementsByName('selCheckObj'),document.all.searchstr.value,false);">
&nbsp;<span id="findnumstr"></span>
-->
<table width="100%" border="0">
	<tr>
		<td>
			<div style="width:100%;height:280px;overflow:auto">
				<script type="text/javascript">
					//var atree = new WebFXLoadTree("组织机构","tree.do");					
					//document.write(atree);					
					//document.write(new loadWebFX("组织机构","userTree.do"));					
					//document.write(new loadWebFX("角色选择","roleTree.do"));
					loadWeb();
				</script>
			</div>
		</td>
	</tr>
</table>
<hr/>
<div align="center">
	<input type="button" value="确定" onclick="confirmSelection();window.close();"/>
	<input type=button value="取消" onclick="window.close();"/>
	<input type=button value="清空" onclick="clear_All();confirmSelection();window.close();"/>
	<input type="button" value="展开" onclick="utree.expandAll();">
	<input type="button" value="收缩" onclick="utree.collapseChildren();">
</div>
<script type="text/javascript">
	//window.resizeTo(screen.availWidth, screen.availHeight);
	function _clear(obj) {
    if(obj){
      for (var i = 0; i < obj.length; i++) {
        if (obj[i].style.backgroundColor == "orangered") {
          if (obj[i].checked) {
            obj[i].style.backgroundColor = "";
          } else {
            obj[i].style.backgroundColor = "";
          }
        }
      }
		}
	}
	function _find(obj, str, check) {
		_clear(obj);
		if (str == "") {
			alert("请输入关键字!");
			return false;
		}
		var findnum = 0;
		if(obj){
      for (var i = 0; i < obj.length; i++) {
        if (obj[i].text.indexOf(str) != -1) {
          if (check) {
            obj[i].checked = true;
          }
          obj[i].style.backgroundColor = "orangered";
          obj[i].focus();
          findnum++;
        }
      }
    }
    document.getElementById('findnumstr').innerHTML = "<font color='red'>找到"+findnum+"个!</font>";
	}
</script>
</body>
</html>
<!--索思奇智版权所有-->