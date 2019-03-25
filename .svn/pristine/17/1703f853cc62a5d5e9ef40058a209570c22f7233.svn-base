<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.workflow.WorkflowFactory" %>
<%@page import="com.kizsoft.commons.workflow.Activity" %>
<%@page import="com.kizsoft.commons.commons.util.StringHelper" %>
<%@page import="java.sql.Connection" %>
<%@page import="java.sql.PreparedStatement" %>
<%@page import="java.sql.ResultSet" %>
<%@page import="java.util.*" %>
<%@page import="com.kizsoft.commons.Constant" %>
<%@page import="com.kizsoft.commons.commons.db.ConnectionProvider" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleManager" %>
<%@page import="com.kizsoft.commons.uum.pojo.Owner" %>
<%@page import="com.kizsoft.commons.uum.service.IUUMService" %>
<%@page import="com.kizsoft.commons.uum.utils.UUMContend" %>
<%@page import="com.kizsoft.commons.commons.orm.MyDBUtils" %>
<html>
<head>
	<title>监管事项</title>
	<script type="text/javascript" src="js/xtree.js"></script>
	<script type="text/javascript" src="js/treecheck.js"></script>	
	<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/jquery-1.11.0.min.js"></script>
	<script language="javascript" type="text/javascript" charset="utf-8" src="<%=request.getContextPath()%>/resources/js/layer/layer.js"></script>
	<link type="text/css" rel="stylesheet" href="css/xtree.css"/>
</head>

<%
if (session.getAttribute("userInfo") == null) {
	response.sendRedirect(request.getContextPath() + "/login.jsp");
	return;
}
User userInfo = (User) session.getAttribute("userInfo");
String userID = userInfo.getUserId();
Group groupInfo = userInfo.getGroup();
String groupID = groupInfo.getDepartmentId();
String userName = userInfo.getUsername();
String depName = groupInfo.getDepartmentName();

%>
<body style="font-size:9pt">
<table width="100%" border="0">
	<tr>
		<td>
			<div style="width:100%;height:360px;overflow:auto">
				<script type="text/javascript">
					document.write(new WebFXLoadTree("所有监管事项","JianguanTree.do?utype=2"));
					loadWeb();
				</script>
			</div>
		</td>
		<td style="width:150px;border-left:#808080 2px solid;" valign="top">
			<div id="jgsxdiv" style="width:100%;height:360px;overflow:auto">已选择<span style="color:red">0</span>个监管事项<hr/>&nbsp;</div>
		</td>
	</tr>
</table>
<hr/>
<script type="text/javascript">
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