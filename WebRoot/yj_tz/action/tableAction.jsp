<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.commons.orm.MyDBUtils"%>
<%@page import="java.util.*"%>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="com.kizsoft.yjdb.utils.CommonUtil"%>
<%@page import="com.kizsoft.yjdb.utils.GsonHelp"%>
<%
	String status=request.getParameter("status");
	String state=CommonUtil.doStr(request.getParameter("state"));
	String newsName=CommonUtil.doStr(request.getParameter("newsName"));
	String content=CommonUtil.doStr(request.getParameter("content"));
	String newsStatus=CommonUtil.doStr(request.getParameter("newsStatus"));
	System.out.println("newsStatus:"+newsStatus);
    System.out.println("content:"+content);
    if(status.equals("images")){
    	String path="/attachment/201805/25/5c9f039375b94bde9c097d9001e8f4fd.png";
    	String serverPath = request.getSession().getServletContext().getRealPath(path);
    	String to="{\"code\": 0,\"msg\": \"成功\",\"data\": {\"src\":\"/yjdb/yj_wz/upload/aa.png\"}}";  
    	System.out.println("serverPath:"+to);
    	out.print(to);
    }
%>	
