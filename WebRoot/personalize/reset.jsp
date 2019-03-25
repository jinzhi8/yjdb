<%@page language="java" contentType="text/html;charset=UTF-8" %>

<%@page import="com.kizsoft.commons.commons.db.ConnectionProvider" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="java.sql.Connection" %>
<%@page import="java.sql.PreparedStatement" %>
<%//用户登陆验证
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
		//response.sendRedirect(request.getContextPath() + "/login.jsp");
	}

	Connection db = null;
	PreparedStatement stat = null;
//ResultSet rs=null;


	try {
		db = ConnectionProvider.getConnection();
		String getUserID = request.getParameter("userid");
		if (getUserID == null || getUserID == "") {
			User userInfo = (User) session.getAttribute("userInfo");
			getUserID = userInfo.getUserId();
		}
		String sql = "delete from personlayout where p_id='" + getUserID + "'";
		stat = db.prepareStatement(sql);
		stat.executeUpdate();
		db.commit();
		response.sendRedirect("changecontent.jsp");
		response.sendRedirect(request.getContextPath() + "/index.jsp");
		request.getRequestDispatcher("/index.jsp").forward(request, response);
	} catch (Exception e) {
		try {
			db.rollback();
		} catch (Exception ex) {}
	} finally {
		//ConnectionProvider.close(db,stat,rs);
		ConnectionProvider.close(db, stat);
	}%><!--索思奇智版权所有-->