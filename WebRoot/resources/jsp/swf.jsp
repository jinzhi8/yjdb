<%@page language="java" contentType="text/html;charset=UTF-8" %>

<%@page import="com.kizsoft.commons.Constant" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<% String[] userConfig;
	String userName = "";
	String udepartment = "";
	//用户登陆验证
	if (session.getAttribute("userInfo") != null) {
		User userInfo = (User) session.getAttribute("userInfo");
		Group groupInfo = userInfo.getGroup();
		userName = userInfo.getUsername();
		udepartment = groupInfo.getGroupname();
		userConfig = userInfo.getUserConfig();
	} else {
		userConfig = new String[3];
		userConfig[0] = Constant.HEADER_IMG;
		userConfig[1] = Constant.FOOTER_IMG;
		userConfig[2] = Constant.STYLE_CSS;
	}%>
<html>
<body topmargin='0' leftmargin='0'>
<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,29,0" width="770" height="127">
	<param name="movie" value="<%=request.getContextPath()%>/resources/images/<%=userConfig[0]%>">
	<param name="quality" value="high">
	<embed src="<%=request.getContextPath()%>/resources/images/<%=userConfig[0]%>" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="770" height="137"></embed>
</body>
</html>
<!--索思奇智版权所有-->