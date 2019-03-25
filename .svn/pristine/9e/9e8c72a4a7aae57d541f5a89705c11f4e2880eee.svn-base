<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.yjdb.xwfx.Impl" %>
<%@page import="com.kizsoft.yjdb.utils.PropertiesUtil" %>

<%
	String sign=Impl.sign();
	String appid = new PropertiesUtil().getDdValueByKey("appid");
	String url="http://www.zjsos.net:19001/navigation_open?appid="+appid+"&sign="+sign;
	response.sendRedirect(url);
%>
