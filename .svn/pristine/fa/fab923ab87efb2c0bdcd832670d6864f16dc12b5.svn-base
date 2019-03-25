<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.commons.db.ConnectionProvider" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>

<%@page import="java.sql.Connection" %>
<%@page import="java.sql.PreparedStatement" %>
<%@page import="java.sql.ResultSet" %>
<%//用户登陆验证
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
	}
	User userInfo = (User) session.getAttribute("userInfo");
	String userID = userInfo.getUserId();


	Connection db = null;
	PreparedStatement stat = null;
	ResultSet rs = null;

	String sql = "select * from emailsystem where id = '" + userID + "'";
	try {
		db = ConnectionProvider.getConnection();
		stat = db.prepareStatement(sql);
		rs = stat.executeQuery();
		if (rs.next()) //查到数据
		{
			String email_user = rs.getString("EMAIL_USER");
			String email_psd = rs.getString("EMAIL_PSD");
			if (email_user == null || email_user.equals("")) {
				out.println("<SCRIPT LANGUAGE='JavaScript'>alert('请在个人资料修改中输入邮件系统用户名!');window.location.href='" + request.getContextPath() + "/personalize/person_modify.jsp';</SCRIPT>");
			} else if (email_psd == null || email_psd.equals("")) {
				out.println("<SCRIPT LANGUAGE='JavaScript'>alert('请在个人资料修改中输入邮件系统密码!');window.location.href='" + request.getContextPath() + "/personalize/person_modify.jsp';</SCRIPT>");
			} else { %>

<SCRIPT LANGUAGE="JavaScript">
	function sendData() {
		document.thisform.submit();
	}
</SCRIPT>
<BODY onload="sendData()">
<FORM METHOD=POST ACTION="http://wenzhou.gov.cn/login.msc" name="thisform">
	<INPUT TYPE="hidden" name="user" value="<%=email_user%>@wenzhou.gov.cn">
	<INPUT TYPE="hidden" name="password" value="<%=email_psd%>">
</FORM>
</BODY>
<%}
} else {
	out.println("<SCRIPT LANGUAGE='JavaScript'>alert('请更新个人资料修改中的邮件系统信息!');window.location.href='" + request.getContextPath() + "/personalize/person_modify.jsp';</SCRIPT>");
}
} catch (Exception e) {
} finally {
	ConnectionProvider.close(db, stat, rs);
}

%>
<!--索思奇智版权所有-->