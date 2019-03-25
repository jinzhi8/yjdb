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
	<title>组织机构</title>
	<script type="text/javascript" src="js/xtree.js"></script>
	<script type="text/javascript" src="js/treecheck.js"></script>
	<link type="text/css" rel="stylesheet" href="css/xtree.css"/>
</head>
<%!
  public String getParentByOwnerId(String ownerId, String level) {
    String sql = "select t1.* from (select level lv,t.ownerid from ownerrelation t start with t.ownerid = ? CONNECT BY PRIOR t.parentid = t.ownerid) t1,owner t2 where t1.ownerid=t2.id and t2.flag=?";
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    IUUMService uumService = UUMContend.getUUMService();
    Owner owner = null;
	String rangeList="";
    try
    {
      conn = ConnectionProvider.getConnection();
      pstmt = conn.prepareStatement(sql);
      pstmt.setString(1, ownerId);
      pstmt.setString(2, level);
      rs = pstmt.executeQuery();
	  int count =0;
      while (rs.next())
      {  
	    if("3".equals(rs.getString("lv")))
		{
	    if(count==0)
		 {
		 rangeList =rs.getString("ownerid");
		 }
		 else{
		  rangeList =rangeList+","+rs.getString("ownerid");
		 
		 }
		 count++;
		 
        System.out.println("count="+count);
		}
      }
    }
    catch (Exception e)
    {
      e.printStackTrace();
      return null;
    }
    finally
    {
      ConnectionProvider.close(conn, pstmt, rs);
    }
    return rangeList;
  }
	
%>

<%
if (session.getAttribute("userInfo") == null) {
	response.sendRedirect(request.getContextPath() + "/login.jsp");
	return;
}
User userInfo = (User) session.getAttribute("userInfo");
String userID = userInfo.getUserId();
Group groupInfo = userInfo.getGroup();
String groupID = groupInfo.getDepartmentId();

String rangeList = request.getParameter("range"); 
if("".equals(rangeList)|| rangeList== null){
	rangeList = getParentByOwnerId(userID, "4");
}

String userName = userInfo.getUsername();
String depName = groupInfo.getDepartmentName();
String utype = request.getParameter("utype");
String activid = request.getParameter("activid");
String rolecode = request.getParameter("rolecode");
//System.out.println("rolecode"+rolecode);
if(utype==null||"".equals(utype)){
	utype = "3";
}
%>
<body style="font-size:9pt">
<!--
&nbsp;<input type=text name="searchstr" value="" size="20">
<input type=button value="搜索" onclick="_find(document.getElementsByName('selCheckObj'),document.all.searchstr.value,false);">
&nbsp;<span id="findnumstr"></span>
-->
<table width="100%" border="0">
	<tr>
		<td>
			<div style="width:100%;height:360px;overflow:auto">
				<script type="text/javascript">
					//var atree = new WebFXLoadTree("组织机构","tree.do");					
					//document.write(atree);					
					//document.write(new loadWebFX("组织机构","userTree.do"));					
					//document.write(new loadWebFX("角色选择","roleTree.do"));
					document.write(new WebFXLoadTree("本单位","userTree.do?utype=<%=utype%>&range=<%=rangeList%>"));
					//document.write(new WebFXLoadTree("群组","userTree.do?utype=5"));
					loadWeb();
				</script>
			</div>
		</td>
		<td style="width:150px;border-left:#808080 2px solid;" valign="top">
			<div id="userdiv" style="width:100%;height:360px;overflow:auto">已选择<span style="color:red">0</span>个用户<hr/>&nbsp;</div>
		</td>
	</tr>
</table>
<hr/>
<!--<div align="center">
	<input type="button" value="确定" onclick="confirmSelection();window.close();"/>
	<input type=button value="取消" onclick="window.close();"/>
	<input type=button value="清空" onclick="clear_All();confirmSelection();window.close();"/>
	<input type="button" value="展开" onclick="utree.expandAll();">
	<input type="button" value="收缩" onclick="utree.collapseChildren();">
</div>-->
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