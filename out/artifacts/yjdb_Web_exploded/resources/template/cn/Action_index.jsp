<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Map"%>
<%@page import="com.kizsoft.commons.commons.orm.MyDBUtils" %>
<%@page import="com.kizsoft.oa.wzbwsq.util.CommonUtil" %>
<%@page import="com.kizsoft.oa.wzbwsq.util.GsonHelp" %>
<%@page import="com.kizsoft.oa.wzbwsq.bean.SsoUser" %>

<%@page import="java.util.*"%>
<%
	SsoUser suser=(SsoUser)session.getAttribute("suser");

	String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();	
	GsonHelp gson = new GsonHelp();
    String action = request.getParameter("action");
	System.out.println("action:"+action);
    if("systemmsg".equals(action)){
    	String userId = request.getParameter("userId");
    	List<Map<String,Object>> list = MyDBUtils.queryForMap("select t.title,t.issuetime,t.unid from bulletin t where not exists(select 1 from readinfo r where r.id=t.unid and r.readmanid=?) order by t.issuetime desc" ,userId);
		String obj="{\"success\":true,\"data\":"+gson.toJson(list)+"}";
		response.getWriter().write(obj);
	}
	
%>
