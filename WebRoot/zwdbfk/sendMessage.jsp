<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.mobile.MoveSend" %>
<%@page import="com.kizsoft.commons.commons.orm.SimpleORMUtils"%>
<%@page import="com.kizsoft.commons.util.UUIDGenerator" %>
<%@page import="com.kizsoft.commons.commons.util.UnidHelper" %>
<%@page import="com.kizsoft.commons.commons.util.StringHelper" %>
<%
	User userInfo = (User) session.getAttribute("userInfo");
    if (userInfo == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    String userID = userInfo.getUserId();
    String userName = userInfo.getUsername();

    String lxdh=request.getParameter("lxdh");
	String require=request.getParameter("require");
	String lxr=request.getParameter("lxr");
	long smID = UnidHelper.getUnid("SEQ_SMID");
	String mobileList2[] = StringHelper.split(lxdh, ",");
	MoveSend moveSend = new MoveSend();
    moveSend.sendSM(mobileList2, require,smID);
	
	
%>
