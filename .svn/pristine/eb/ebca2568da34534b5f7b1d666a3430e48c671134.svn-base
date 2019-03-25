<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="java.util.ArrayList" %>
<%@page import="com.kizsoft.commons.commons.db.ConnectionProvider" %>
<%@page import="com.kizsoft.commons.component.entity.FieldEntity" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.sql.Connection" %>
<%@page import="java.sql.PreparedStatement" %>
<%@page import="java.sql.ResultSet" %>
<%@page import="java.text.ParseException" %>
<%@page import="java.util.List"%>
<%@page import="net.sf.json.JSONArray" %>
<%@page import="net.sf.json.JSONObject" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.*"%>
<%@page import="java.util.HashMap" %>
<%@page import="com.kizsoft.oa.wskzm.util.SimpleORMUtils"%>
<%@page import="com.kizsoft.oa.wskzm.ZmInfo" %>
<%@page import="com.kizsoft.oa.wskzm.Szd" %>
<%@page import="com.kizsoft.commons.util.UUIDGenerator" %>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<%@taglib prefix="html" uri="/WEB-INF/oa-html.tld" %>
<%@taglib prefix="oa" uri="/WEB-INF/oa.tld" %>

<%
        String parentid=request.getParameter("parentid");
        String month=request.getParameter("month");
        String json="";
        String getMonthreceive="";
		String moreMonth;
        if(month.equals("13")){
			String year=request.getParameter("year");
			if("".equals(year)){
			Long SystemTime=System.currentTimeMillis();
			Calendar calendar2 = Calendar.getInstance();  
			calendar2.setTimeInMillis(SystemTime);  
			year=calendar2.get(Calendar.YEAR)+"";
		}
        for(int i=1;i<=12;i++){
			if(i<=9){
				moreMonth =year+"-0"+i;
			}else{
				moreMonth =year+"-"+i;
			}
            getMonthreceive=getMonthReceive(moreMonth,parentid); 
            json=json+ "{\"value\":\""+getMonthreceive+"\"},";
        }
	    json="["+json.substring(0,json.length()-1)+"]";
	   
	    out.print(json);
	    }else{
           getMonthreceive=getMonthReceive(month,parentid); 
           out.print(getMonthreceive);
	    }
%>
<%!
    public static String getMonthReceive(String month,String parentid){
        Connection conn=null;
		PreparedStatement ps=null;
		ResultSet rs=null;
		String total = "";
		String sql="";
		int len=parentid.length();
		try{
		if(len<10){ 
			sql="select count(*) as total from FLOW_INSTANCES t,zmview a where a.unid=t.app_id and to_char(t.create_time,'yyyy-MM')='"+month+"' and  a. szdid='"+parentid+"' ";
		}else{
            sql="select count(*) as total from FLOW_INSTANCES t,zmview a where a.unid=t.app_id and to_char(t.create_time,'yyyy-MM')='"+month+"'";
		}
			conn=ConnectionProvider.getConnection();
			ps=conn.prepareStatement(sql);
			rs=ps.executeQuery();
			if(rs.next()){
				total = rs.getString("total"); 
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			ConnectionProvider.close(conn,ps,rs);
		}
		return total;
	}
%>

