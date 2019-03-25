<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.workflow.Flow" %>
<%@page import="com.kizsoft.commons.workflow.dao.FlowDAO" %>
<%@page import="java.util.ArrayList" %>
<%@page import="com.kizsoft.commons.commons.db.ConnectionProvider" %>
<%@page import="com.kizsoft.commons.acl.ACLManager" %>
<%@page import="com.kizsoft.commons.acl.ACLManagerFactory" %>
<%@page import="com.kizsoft.commons.component.entity.FieldEntity" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Date" %>
<%@page import="com.kizsoft.commons.commons.db.ConnectionProvider" %>
<%@page import="java.sql.Connection" %>
<%@page import="java.sql.PreparedStatement" %>
<%@page import="java.sql.ResultSet" %>
<%@page import="java.text.ParseException" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Date" %>
<%@page import="java.util.Calendar"%>
<%@page import="com.kizsoft.commons.util.UUIDGenerator" %>

<%
        String parentid=request.getParameter("parentid");
        String year=request.getParameter("year");
        String yearReceive=getYearReceive(year,parentid);
        //System.out.println("yearReceive:"+yearReceive);	
	    out.print(yearReceive);
%>
<%!
    public static String getYearReceive(String year,String parentid){
        Connection conn=null;
		PreparedStatement ps=null;
		ResultSet rs=null;
		String total = "";
		int len=parentid.length();
		String sql="";
		try{
		if(len<10) 
		{
			 sql="select count(*) as total from FLOW_INSTANCES t,zmview a where a.unid=t.app_id and a.szdid='"+parentid+"' and to_char(t.create_time,'YYYY')='"+year+"' ";
		}
		else{
		     sql="select count(*) as total from FLOW_INSTANCES t,zmview a where a.unid=t.app_id  and to_char(t.create_time,'YYYY')='"+year+"'";  
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