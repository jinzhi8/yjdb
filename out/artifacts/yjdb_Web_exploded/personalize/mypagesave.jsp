<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" errorPage="/error.jsp" %>

<%@page import="com.kizsoft.commons.commons.db.ConnectionProvider" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="java.sql.Connection" %>
<%@page import="java.sql.PreparedStatement" %>
<%@page import="java.sql.ResultSet" %>
<%//用户登陆验证
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
		//response.sendRedirect(request.getContextPath() + "/login.jsp");
	}
	User userInfo = (User) session.getAttribute("userInfo");
	String userID = userInfo.getUserId();

	String action = request.getParameter("action");

	Connection db = null;
	PreparedStatement tempstat = null;
	ResultSet temprs = null;
	try {
		db = ConnectionProvider.getConnection();

		//需要保存新位置
		if (request.getMethod().equalsIgnoreCase("post")) if ("drag".equalsIgnoreCase(action)) {
			String dragdivid = request.getParameter("dragdivid");
			String layouttype = request.getParameter("layoutype");
			String layoutorder = request.getParameter("layouorder");
			String oldlayouttype = request.getParameter("oldlayoutype");
			String oldlayoutorder = request.getParameter("oldlayoutorder");
			//debug
			System.err.println("dragdivid=" + dragdivid + " layouttype=" + layouttype + "  layoutorder:" + layoutorder + " oldlayouttype:" + oldlayouttype + " oldlayoutorder:" + oldlayoutorder);
			if (dragdivid != null && dragdivid.length() > 0) {
				//如果在同一栏上，并且旧位置<新位置，则需要把新位置-1.
				if (layouttype.equals(oldlayouttype)) {
					int order, oldorder;
					order = Integer.parseInt(layoutorder);
					oldorder = Integer.parseInt(oldlayoutorder);
					if (oldorder < order && order > 0) {
						//新位置-1
						layoutorder = String.valueOf(order - 1);
					}
				}
				//提交保存新位置，先删除旧位置，再插入新位置。需要调整顺序。
				//删除旧位置，找到旧位置
				db.setAutoCommit(false);
				try {
					String SelectOldLayout = "SELECT P_ID FROM PERSONLAYOUT WHERE P_ID=? AND P_CONTENT=? AND P_ORDER=? AND P_LAYOUT_TYPE=?";
					String DeleteOldLayout = "DELETE PERSONLAYOUT WHERE P_ID=? AND P_CONTENT=?";
					String UpdateOldLayout = "UPDATE PERSONLAYOUT SET P_ORDER=P_ORDER-1 WHERE P_ID=? AND P_LAYOUT_TYPE=? AND P_ORDER>=?";
					String UpdateNewLayout = "UPDATE PERSONLAYOUT SET P_ORDER=P_ORDER+1 WHERE P_ID=? AND P_LAYOUT_TYPE=? AND P_ORDER>=?";
					String InsertNewLayout = "INSERT INTO PERSONLAYOUT(P_ID,P_CONTENT,P_LAYOUT_TYPE,P_ORDER)  VALUES(?,?,?,?)";

					//需要先检查是否栏目在老位置上
					tempstat = db.prepareStatement(SelectOldLayout);
					tempstat.setString(1, userID);
					tempstat.setString(2, dragdivid);
					tempstat.setString(3, oldlayoutorder);
					tempstat.setString(4, oldlayouttype);
					//debug
					//System.err.println("userid:"+userid+" usertype:"+usertype+" dragdivid:"+dragdivid+" oldlayoutorder:"+oldlayoutorder+" oldlayouttype:"+oldlayouttype);
					temprs = tempstat.executeQuery();
					//如果不在旧位置上则不需要保存位置
					if (temprs.next()) {
						temprs.close();
						tempstat.close();
						//删除旧位置P_ID=? AND P_TYPE=? AND P_CONTENT=?
						tempstat = db.prepareStatement(DeleteOldLayout);
						tempstat.setString(1, userID);
						tempstat.setString(2, dragdivid);
						tempstat.execute();
						tempstat.close();
						//调整旧位置P_ID=? AND P_LAYOUT_TYPE=? AND P_ORDER>?
						tempstat = db.prepareStatement(UpdateOldLayout);
						tempstat.setString(1, userID);
						tempstat.setString(2, oldlayouttype);
						tempstat.setInt(3, Integer.parseInt(oldlayoutorder));
						tempstat.execute();
						tempstat.close();
						//空出新位置P_ID=? AND P_LAYOUT_TYPE=? AND P_ORDER>?
						tempstat = db.prepareStatement(UpdateNewLayout);
						tempstat.setString(1, userID);
						tempstat.setString(2, layouttype);
						tempstat.setInt(3, Integer.parseInt(layoutorder));
						tempstat.execute();
						tempstat.close();
						//插入新位置P_ID,P_CONTENT,P_LAYOUT_TYPE,P_ORDER,P_MAXART,P_TYPE
						tempstat = db.prepareStatement(InsertNewLayout);
						tempstat.setString(1, userID);
						tempstat.setString(2, dragdivid);
						tempstat.setString(3, layouttype);
						tempstat.setInt(4, Integer.parseInt(layoutorder));
						tempstat.execute();
						tempstat.close();
						db.commit();
					}
				} catch (Exception e) {
					try {db.rollback();} catch (Exception e2) {e2.printStackTrace();}
					e.printStackTrace();
				} finally {
					try {
						if (tempstat != null) {
							tempstat.close();
							tempstat = null;
						}
					} catch (Exception e) {e.printStackTrace();}
				}
				db.setAutoCommit(true);
			}
		} else if ("delete".equalsIgnoreCase(action)) {
			//如果是删除
			String DeleteLAYOUT = "delete from PERSONLAYOUT where P_ID=? and P_CONTENT=?";
			String dragdivid = request.getParameter("dragdivid");
			//debug
			System.err.println("dragdivid=" + dragdivid);
			if (dragdivid != null && dragdivid.length() > 0) {
				db.setAutoCommit(false);
				try {
					//删除这条栏目P_ID=? and P_TYPE=? and P_CONTENT=?
					tempstat = db.prepareStatement(DeleteLAYOUT);
					tempstat.setString(1, userID);
					tempstat.setString(2, dragdivid);
					tempstat.execute();
					tempstat.close();
					db.commit();
				} catch (Exception e) {
					try {db.rollback();} catch (Exception e2) {e2.printStackTrace();}
					e.printStackTrace();
				} finally {
					try {
						if (tempstat != null) {
							tempstat.close();
							tempstat = null;
						}
					} catch (Exception e) {e.printStackTrace();}
				}
				db.setAutoCommit(true);
			}
		}
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		ConnectionProvider.close(db);
	}%>
<html>
<body>
<form name="divform" method="post" class="nomargin">
	<input type="hidden" name="action" value="drag">
	<input type="hidden" name="dragdivid">
	<input type="hidden" name="showp">
	<input type="hidden" name="layoutype">
	<input type="hidden" name="layouorder">
	<input type="hidden" name="oldlayoutype">
	<input type="hidden" name="oldlayoutorder">
</form>
<%

	if (request.getMethod().equalsIgnoreCase("post")) {
		//String action=request.getParameter("action");
		if ("drag".equalsIgnoreCase(action) || "delete".equalsIgnoreCase(action)) {
			//刷新父页面%>
<script language="JavaScript">
	window.parent.location.reload();
</script>
<%}
}%>
</body>
</html><!--索思奇智版权所有-->