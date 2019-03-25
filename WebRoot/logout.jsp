<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="javax.servlet.http.Cookie" %>
<%String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
	//session.invalidate();
	request.getSession(false).removeAttribute("userInfo");
	Cookie cookie = new Cookie("islogout", "1"); 
	cookie.setPath(request.getContextPath()); 
	cookie.setMaxAge(-1); 
	response.addCookie(cookie); 
	response.sendRedirect(contextPath+"/login.jsp");%>
<script>
	location.href = "<%=contextPath%>/";
</script>        
<!--索思奇智版权所有-->