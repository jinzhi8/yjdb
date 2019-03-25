<%@page contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.acl.ACLManager" %>
<%@page import="com.kizsoft.commons.acl.ACLManagerFactory" %>
<%@page import="com.kizsoft.commons.commons.db.ConnectionProvider" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="java.sql.Connection" %>
<%@page import="java.sql.ResultSet" %>
<%@page import="java.sql.Statement" %>
<html>
<body topmargin="0" leftmargin="0">
<link href="<%="/".equals(request.getContextPath())?"":request.getContextPath()%>/resources/css/css.css" type="text/css" rel="stylesheet"/>
<marquee behavior=scroll direction=up width=180 height="150" scrollamount=1 scrolldelay=1 onmouseover='this.stop()' onmouseout='this.start()'>
	<table id="viewtable" width="100%" border="0" cellpadding="4" cellspacing="1" align="center">
		<%if (session.getAttribute("userInfo") == null) {
			response.sendRedirect(request.getContextPath() + "/login.jsp");
		} else {

			User userInfo = (User) session.getAttribute("userInfo");
			String userID = userInfo.getUserId();

			String sql = "select title,unid from bulletin where docsign='1' and issueflag='1' and issuetime+effectdays>sysdate order by issuetime desc";
			ACLManager acl = ACLManagerFactory.getACLManager();
			sql = acl.getACLSql(sql, "unid", userID);

			Connection conn = null;
			Statement stmt = null;
			ResultSet rs = null;

			int ii = 0;

			try {
				conn = ConnectionProvider.getConnection();
				//stmt=conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
				stmt = conn.createStatement();
				rs = stmt.executeQuery(sql);
				while (rs.next() && ii < 10) {
					ii++;%>
		<tr>
			<td>◇
				<a href="<%=request.getContextPath()%>/view?xmlName=sharebulletin&appId=<%=rs.getString(2)%>" target="_parent"><%=rs.getString(1)%>
				</a></td>
		</tr>

		<%}
		} catch (Exception e) {
		} finally {
			ConnectionProvider.close(conn, stmt, rs);
		}
			if (ii > 0) {%>
		<tr>
			<td align="right"><a href="<%=request.getContextPath()%>/sharebulletin/" target="_parent">更多...</a></td>
		</tr>
		<%}

		%>
	</table>
</marquee>
</body>
</html>
<%}%>
<!--索思奇智版权所有-->