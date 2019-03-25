<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.commons.db.ConnectionProvider" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.commons.util.StringHelper" %>
<%@page import="java.sql.Connection" %>
<%@page import="java.sql.ResultSet" %>
<%@page import="java.sql.Statement" %>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>

<%
String userTemplateName = (String) session.getAttribute("templatename");
String userTemplateStr = "/resources/template/" + userTemplateName + "/template.jsp";
if(userTemplateName==null||"".equals(userTemplateName)){
	userTemplateStr = "/resources/jsp/template.jsp";
}
%>
<template:insert template="<%=userTemplateStr%>">
	<template:put name='title' content='用户排序' direct='true'/>
	<%String str = "<a class=\"menucur\" href=\"category.jsp\">用户排序</a>";%>
	<template:put name='moduleNav' content='<%=str%>' direct='true'/>
	<template:put name='content'>
		<link href="<%=request.getContextPath()%>/resources/css/css.css" rel="stylesheet" type="text/css">
		<%User userInfo = (User) session.getAttribute("userInfo");
			if (userInfo == null) {
				response.sendRedirect(request.getContextPath() + "/login.jsp");
			}%>
		<% String action = StringHelper.isNull(request.getParameter("action")) ? "" : request.getParameter("action");
			if ("update".equals(action)) {
				String parentID = StringHelper.isNull(request.getParameter("parentid")) ? "" : request.getParameter("parentid");
				if (StringHelper.isNull(parentID)) {
					String itemNumStr = request.getParameter("itemnum");
					int itemNum = Integer.parseInt(itemNumStr);
					Connection conn = null;
					Statement stmt = null;
					ResultSet rs = null;

					try {
						conn = ConnectionProvider.getConnection();
						stmt = conn.createStatement();
						for (int i = 1; i <= itemNum; i++) {
							String ownerID = request.getParameter("ownerid_" + i);
							String orderID = request.getParameter("orderid_" + i);
							String sql = "update owner set order_num='" + orderID + "' WHERE id='" + ownerID + "'";
							stmt.executeUpdate(sql);
						}
					} catch (Exception e) {
					} finally {
						ConnectionProvider.close(conn, stmt, rs);
					}
					response.sendRedirect("category.jsp");
				} else {
					String itemNumStr = request.getParameter("itemnum");
					int itemNum = Integer.parseInt(itemNumStr);
					Connection conn = null;
					Statement stmt = null;
					ResultSet rs = null;

					try {
						conn = ConnectionProvider.getConnection();
						stmt = conn.createStatement();
						for (int i = 1; i <= itemNum; i++) {
							String ownerID = request.getParameter("ownerid_" + i);
							String orderID = request.getParameter("orderid_" + i);
							String sql = "update ownerrelation set orderid=" + orderID + " WHERE ownerid='" + ownerID + "' and parentid='" + parentID + "'";
							stmt.executeUpdate(sql);
						}
					} catch (Exception e) {
					} finally {
						ConnectionProvider.close(conn, stmt, rs);
					}
					response.sendRedirect("category.jsp?pid=" + parentID);
				}
			} else {
				String parentID = StringHelper.isNull(request.getParameter("pid")) ? "" : request.getParameter("pid");
				if (!StringHelper.isNull(parentID)) {
					StringBuffer userList = new StringBuffer();

					String sql = "select t.ownerid,t1.ownercode,t1.ownername,t.orderid,decode(t1.type,'1','系统管理员','0','普通用户','2','部门管理员','部门') type from ownerrelation t,owner t1 where t.ownerid=t1.id";
					sql += " and t.parentid='" + parentID + "'";
					sql += " order by t.orderid";

					int i = 0;

					Connection conn = null;
					Statement stmt = null;
					ResultSet rs = null;

					try {
						conn = ConnectionProvider.getConnection();
						stmt = conn.createStatement();
						rs = stmt.executeQuery(sql);
						userList.append("<form name=category action='category.jsp?action=update' method=post>");
						userList.append("<table border='0' align='center' cellpadding='0' cellspacing='0' class='round'><tr><td class='title'>用户排序</td></tr>");
						userList.append("<tr><td align='center'><table id=PowerTable width='90%' border='0' cellpadding='0' cellspacing='0' class='table'>");
						userList.append("<TR><TD bgcolor='#EAEAEA' class='deeptd' width='15%'>登陆名</TD><TD bgcolor='#EAEAEA' class='deeptd'  width='35%'>真实姓名</TD><TD bgcolor='#EAEAEA' class='deeptd'  width='15%'>类型</TD><TD bgcolor='#EAEAEA' class='deeptd'  width='15%'>排序号</TD><TD bgcolor='#EAEAEA' class='deeptd'  width='20%'>移动</TD></TR>");
						while (rs.next()) {
							i++;
							userList.append("<TR><TD bgcolor='#EAEAEA' class='tinttd'>" + rs.getString("ownercode") + "</TD><TD bgcolor='#EAEAEA' class='tinttd'>" + rs.getString("ownername") + "</TD><TD bgcolor='#EAEAEA' class='tinttd'>" + rs.getString("type") + "</TD><TD bgcolor='#EAEAEA' class='tinttd'><input type='text' name='orderid_" + i + "' value='" + rs.getString("orderid") + "'/></TD><TD bgcolor='#EAEAEA' class='tinttd'><input type=button id=move value='上移' class='formbutton' onclick='move_up(PowerTable)'>&nbsp<input type=button id=move value='下移' class='formbutton' onclick=move_down(PowerTable)><input type=hidden name='ownerid_" + i + "' value='" + rs.getString("ownerid") + "'</TD></TR>");
						}
					} catch (Exception e) {
					} finally {
						ConnectionProvider.close(conn, stmt, rs);
					}
					userList.append("</TABLE></td></tr>");
					userList.append("<tr><td colspan='4' class='tinttd'><div align='center'><input type='submit' class='searchbutton' value='保存'name=save onclick='infoalert(\"提交中...\");for(var i=1;i<PowerTable.rows.length;i++){if(isNaN(PowerTable.rows[i].cells[3].children[0].value)){alert(\"［\"+PowerTable.rows[i].cells[1].innerHTML+\"］的排序号必须为数字！请修改！\");PowerTable.rows[i].cells[3].style.backgroundColor=\"red\";event.srcElement.value=\"保存\";return false;}else{PowerTable.rows[i].cells[3].style.backgroundColor=\"#EAEAEA\";}}'>&nbsp<input type=button class=searchbutton value='编号' onclick='for(var i=1;i<PowerTable.rows.length;i++){PowerTable.rows[i].cells[3].children[0].value = i;}'></div></td></tr>");
					userList.append("</TABLE>");
					userList.append("<input type='hidden' name=parentid value='" + parentID + "' />");
					userList.append("<input type='hidden' name=itemnum value='" + i + "' />");
					userList.append("</form>");
					out.println(userList.toString());
				} else {
					StringBuffer userList = new StringBuffer();

					String sql = "select t.id,t.ownercode,t.ownername,t.order_num,decode(t.type,'1','系统管理员','0','普通用户','2','部门管理员','部门') type from owner t where t.flag='4'  order by t.order_num";
					int i = 0;

					Connection conn = null;
					Statement stmt = null;
					ResultSet rs = null;

					try {
						conn = ConnectionProvider.getConnection();
						stmt = conn.createStatement();
						rs = stmt.executeQuery(sql);
						userList.append("<form name=category action='category.jsp?action=update' method=post>");
						userList.append("<table border='0' align='center' cellpadding='0' cellspacing='0' class='round'><tr><td class='title'>用户排序</td></tr>");
						userList.append("<tr><td align='center'><table id=PowerTable width='90%' border='0' cellpadding='0' cellspacing='0' class='table'>");
						userList.append("<TR><TD bgcolor='#EAEAEA' class='deeptd' width='15%'>登陆名</TD><TD bgcolor='#EAEAEA' class='deeptd'  width='35%'>真实姓名</TD><TD bgcolor='#EAEAEA' class='deeptd'  width='15%'>类型</TD><TD bgcolor='#EAEAEA' class='deeptd'  width='15%'>排序号</TD><TD bgcolor='#EAEAEA' class='deeptd'  width='20%'>移动</TD></TR>");
						while (rs.next()) {
							i++;
							userList.append("<TR><TD bgcolor='#EAEAEA' class='tinttd'>" + rs.getString("ownercode") + "</TD><TD bgcolor='#EAEAEA' class='tinttd'>" + rs.getString("ownername") + "</TD><TD bgcolor='#EAEAEA' class='tinttd'>" + rs.getString("type") + "</TD><TD bgcolor='#EAEAEA' class='tinttd'><input type='text' name='orderid_" + i + "' value='" + rs.getString("order_num") + "'/></TD><TD bgcolor='#EAEAEA' class='tinttd'><input type=button id=move value='上移' class='formbutton' onclick='move_up(PowerTable)'>&nbsp<input type=button id=move value='下移' class='formbutton' onclick=move_down(PowerTable)><input type=hidden name='ownerid_" + i + "' value='" + rs.getString("id") + "'</TD></TR>");
						}
					} catch (Exception e) {
					} finally {
						ConnectionProvider.close(conn, stmt, rs);
					}
					userList.append("</TABLE></td></tr>");
					userList.append("<tr><td colspan='4' class='tinttd'><div align='center'><input type='submit' class='searchbutton' value='保存'name=save onclick='infoalert(\"提交中...\");for(var i=1;i<PowerTable.rows.length;i++){if(isNaN(PowerTable.rows[i].cells[3].children[0].value)){alert(\"［\"+PowerTable.rows[i].cells[1].innerHTML+\"］的排序号必须为数字！请修改！\");PowerTable.rows[i].cells[3].style.backgroundColor=\"red\";event.srcElement.value=\"保存\";return false;}else{PowerTable.rows[i].cells[3].style.backgroundColor=\"#EAEAEA\";}}'>&nbsp<input type=button class=searchbutton value='编号' onclick='for(var i=1;i<PowerTable.rows.length;i++){PowerTable.rows[i].cells[3].children[0].value = i;}'></div></td></tr>");
					userList.append("</TABLE>");
					userList.append("<input type='hidden' name=itemnum value='" + i + "' />");
					userList.append("</form>");
					out.println(userList.toString());
				}
			}%>
		<script language="JavaScript">
			var cur_row = null;
			function change_row(the_tab, line1, line2) {
				the_tab.rows[line1].swapNode(the_tab.rows[line2])
			}
			function infoalert(alertstr) {
				event.srcElement.value = alertstr;
				//event.srcElement.disabled=true;
			}
			function move_up(the_table) {
				cur_row = event.srcElement.parentElement.parentElement.rowIndex;
				event.cancelBubble = true;
				if (cur_row == null || cur_row <= 1)return;
				the_table.rows[cur_row].cells[3].children[0].value = the_table.rows[cur_row].cells[3].children[0].value - 1;
				the_table.rows[cur_row - 1].cells[3].children[0].value = the_table.rows[cur_row - 1].cells[3].children[0].value - -1;
				change_row(the_table, cur_row, --cur_row);
			}
			function move_down(the_table) {
				cur_row = event.srcElement.parentElement.parentElement.rowIndex;
				event.cancelBubble = true;
				if (cur_row == null || cur_row == the_table.rows.length - 1 || cur_row == 0)return;
				the_table.rows[cur_row + 1].cells[3].children[0].value = the_table.rows[cur_row + 1].cells[3].children[0].value - 1;
				the_table.rows[cur_row].cells[3].children[0].value = the_table.rows[cur_row].cells[3].children[0].value - -1;
				change_row(the_table, cur_row, ++cur_row);
			}
			function category(the_table) {
				for (var i = 1; i < PowerTable.rows.length; i++) {
					PowerTable.rows[i].cells[3].children[0].value = i;
				}
			}
		</script>
	</template:put>
</template:insert><!--索思奇智版权所有-->