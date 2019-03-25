<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="java.io.BufferedReader" %>
<%@page import="java.io.IOException" %>
<%@page import="java.io.InputStreamReader" %>
<%@page import="java.io.UnsupportedEncodingException" %>
<%@page import="java.net.URL" %>
<%@page import="java.util.Map" %>
<%@page import="java.util.HashMap" %>
<%@page import="java.net.URLConnection" %>
<%@page import="com.kizsoft.yjdb.utils.JsoupUtil" %>
<%@page import="java.net.URLEncoder" %>
<%@page import="com.kizsoft.yjdb.utils.GsonHelp" %>
<%@page import="com.kizsoft.commons.commons.orm.SimpleORMUtils"%>
<%@page import="com.kizsoft.commons.util.UUIDGenerator" %>

<%
	String mobileStr= request.getParameter("phone");
	String nr = request.getParameter("nr");
	String unid = request.getParameter("unid");
	String name = request.getParameter("name");
	String[] mobiles=mobileStr.split(",");
	Map map=new HashMap();
	String show="";
	for(int i=0;i<mobiles.length;i++){
		String mobile=mobiles[i];
		String url="http://117.149.225.121:3000/dingding/ddService?function=sendDdMessage&JsonStr={\"mobile\":\""+mobile+"\",\"textContent\":\""+URLEncoder.encode(nr,"UTF-8")+"\"}";
		String getzxl=JsoupUtil.sendGet(url,map,"UTF-8");
		Map<String,Object> mapm=GsonHelp.fromJson(getzxl);
		String message=(String)mapm.get("message");
		show=mobile+":"+message+"   "+show;
	}

	SimpleORMUtils instance=SimpleORMUtils.getInstance();	
	instance.executeUpdate("insert into ZWDB_DDMESSAGE(unid,docunid,DBLXR,DBLXDH,DBMESSAGE,time,username) values(?,?,?,?,?,sysdate,?)",UUIDGenerator.getUUID(),unid,name,mobileStr,show,nr);
	out.print("ok");	
%>
