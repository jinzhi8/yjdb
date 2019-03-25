<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.commons.orm.MyDBUtils"%>
<%@page import="java.util.*"%>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="com.kizsoft.yjdb.utils.GsonHelp"%>
<%@page import="com.kizsoft.yjdb.utils.CommonUtil"%>
<%
	String status=request.getParameter("status");
	String unid=request.getParameter("unid");
	GsonHelp gson = new GsonHelp();
    if("getPsinfo".equals(status)){
		List<Map<String,Object>> list = MyDBUtils.queryForMapToUC("select * from yj_lr_message t where t.docunid=? order by time desc  ",unid);
		String json = "{\"res\":true,\"data\":"+gson.toJson(list)+"}";
		response.getWriter().write(json);
	}
%>	
