<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.oa.wskzm.util.SimpleORMUtils"%>
<%@page import="java.util.List"%>

<%
	String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
	String docid=request.getParameter("docid");
	String moduleId=request.getParameter("moduleId");
	String type=request.getParameter("type");
	SimpleORMUtils instance=SimpleORMUtils.getInstance();
	
	List<Object[]> list=instance.queryForList("select 1 from COMMON_ATTACHMENT t where t.docunid=? and t.moduleid=? and t.type=?",docid,moduleId,type);
	int count=list.size();
	if(count>0){
		out.println("1");
	}else{
		out.println("0");
	}
	%>
