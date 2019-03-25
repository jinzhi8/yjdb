<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="com.kizsoft.commons.commons.db.ConnectionProvider" %>
<%@ page import="com.kizsoft.commons.commons.user.User" %>
<%@ page import="com.kizsoft.commons.util.UUIDGenerator" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ taglib prefix="html" uri="/WEB-INF/struts-html.tld" %>
<%
	User userInfo = (User) session.getAttribute("userInfo");
	if (userInfo == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
		return;
	}
	String userId = userInfo.getUserId();
	String userName = userInfo.getUsername();
	String action = request.getParameter("action");
	String activId = request.getParameter("activ_id");
	String getUserId = request.getParameter("userid");
	String participant = request.getParameter("participant");
	String participant_cn = request.getParameter("participant_cn");
	if ("save".equals(action)) {
		response.reset();
		response.setContentType("application/json;charset=UTF-8");
		JSONObject json = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "insert into flow_activities_default(uuid,participant,participant_cn,activ_id,userid,username) values(?,?,?,?,?,?)";
		try {
			con = ConnectionProvider.getConnection();
			pstmt = con.prepareStatement("delete from flow_activities_default where userid=? and activ_id=?");
			pstmt.setString(1, getUserId);
			pstmt.setString(2, activId);
			pstmt.executeUpdate();
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, UUIDGenerator.getUUID());
			pstmt.setString(2, participant);
			pstmt.setString(3, participant_cn);
			pstmt.setString(4, activId);
			pstmt.setString(5, userId);
			pstmt.setString(6, userName);
			pstmt.executeUpdate();
			json.put("success", true);
		} catch (SQLException e) {
			e.printStackTrace();
			json.put("success", false);
		} finally {
			ConnectionProvider.close(con, pstmt, rs);
		}
		out.print(json.toString(4));
	} else if ("get".equals(action)) {
		response.reset();
		response.setContentType("application/json;charset=UTF-8");
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "select * from flow_activities_default where userid=? and activ_id=?";
		JSONObject json = new JSONObject();
		try {
			con = ConnectionProvider.getConnection();
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, getUserId);
			pstmt.setString(2, activId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				json.put("uuid", rs.getString("uuid"));
				json.put("participant", rs.getString("participant"));
				json.put("participant_cn", rs.getString("participant_cn"));
				json.put("activ_id", rs.getString("activ_id"));
				json.put("userid", rs.getString("userid"));
				json.put("username", rs.getString("username"));
				json.put("success", true);
			} else {
				json.put("success", false);
			}
		} catch (SQLException e) {
			out.print(e);
			e.printStackTrace();
			json.put("success", false);
		} finally {
			ConnectionProvider.close(con, pstmt, rs);
		}
		out.print(json.toString(4));
	}
%>