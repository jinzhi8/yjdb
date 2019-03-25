<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.oa.wskzm.util.DocConverter" %>

<%
	String uuid=request.getParameter("uuid");
	String path=request.getParameter("path");
	String dest=path.substring(0,path.lastIndexOf("."))+".pdf";
	
	String srcpath=request.getSession().getServletContext().getRealPath(path);
	String destpath=request.getSession().getServletContext().getRealPath(dest);
	boolean flag=DocConverter.doc2pdf(srcpath,destpath);
	if(flag){
		out.println(dest);
	}else{
		out.println("1");
	}
	
	
%>
