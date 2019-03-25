<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>

<%@page import="com.kizsoft.commons.module.beans.ModuleApplication"%>
<%@page import="com.kizsoft.commons.module.beans.ModuleApplicationManager"%>
<%@page import="java.util.ArrayList"%>


<%
	if(session.getAttribute("userInfo")==null){
		response.sendRedirect(request.getContextPath()+"/login.jsp");
	}
	User userInfo=(User)session.getAttribute("userInfo");
	String userID=userInfo.getUserId();
	String moduleID=request.getParameter("moduleId");
	ModuleApplicationManager appManager=new ModuleApplicationManager();
	ArrayList appList=(ArrayList)appManager.getApplicationList(moduleID,userID);
	StringBuffer sb=new StringBuffer();
	for(int i=0;i<appList.size();i++){
		ModuleApplication app=(ModuleApplication) appList.get(i);
		
		sb.append("<option value=\""+app.getApplicationId()+"\">"+app.getApplicationName()+"</option>");
	}
	out.print(sb.toString());

%>