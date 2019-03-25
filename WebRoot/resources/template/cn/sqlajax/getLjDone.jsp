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
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<%@taglib prefix="html" uri="/WEB-INF/oa-html.tld" %>
<%@taglib prefix="oa" uri="/WEB-INF/oa.tld" %>
<%
        String parentid=request.getParameter("parentid");
        String bysl="bysl";	
        String bybj="bybj";
        String bydcl="bydcl";
        String bysh="bysh";
        String bybysh="bybysh";
        int len=parentid.length();
        if(len<10){
        String getBysl=getMonthDone(parentid,bysl);
        String getBybj=getMonthDone(parentid,bybj);
        String getBydcl=getMonthDone(parentid,bydcl);
        String getBysh=getMonthDone(parentid,bysh);
        String getBybysh=getMonthDone(parentid,bybysh);
        String json="{\"getBysl\":\""+getBysl+"\",\"getBydcl\":\""+getBydcl+"\",\"getBysh\":\""+getBysh+"\",\"getBybysh\":\""+getBybysh+"\",\"getBybj\":\""+getBybj+"\"}";
	    out.print(json);
	    }
	    else{
        String getBysl=getXtMonthDone(parentid,bysl);
        String getBybj=getXtMonthDone(parentid,bybj);
        String getBydcl=getXtMonthDone(parentid,bydcl);
        String getBysh=getXtMonthDone(parentid,bysh);
        String getBybysh=getXtMonthDone(parentid,bybysh);
        String json="{\"getBysl\":\""+getBysl+"\",\"getBydcl\":\""+getBydcl+"\",\"getBysh\":\""+getBysh+"\",\"getBybysh\":\""+getBybysh+"\",\"getBybj\":\""+getBybj+"\"}";
	    out.print(json);
		} 
%>
<%!
    public static String getMonthDone(String parentid,String status){
      Connection conn=null;
		PreparedStatement ps=null;
		ResultSet rs=null;
		String total = "";
		String sql="";
		try{
                if("bysl".equals(status)){
				    sql="select count(*) as total from FLOW_INSTANCES t,zmview a where t.app_id=a.unid and a.szdid='"+parentid+"' ";
				}else if("bybj".equals(status)){
                    sql="select count(*) as total from FLOW_INSTANCES t,zmview a where  t.app_id=a.unid and a.szdid='"+parentid+"' and t.instance_status='2'";
				}else if("bydcl".equals(status)){
                    sql="select count(*) as total from ZMVIEW t where szdid='"+parentid+"' and zm_status='待受理'";
				}else if("bysh".equals(status)){
                    sql="select count(*) as total from ZMVIEW t where szdid='"+parentid+"' and zm_status='审核通过'";
				}else if("bybysh".equals(status)){
                    sql="select count(*) as total from ZMVIEW t where szdid='"+parentid+"' and zm_status='不予审核'";
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
<%!
    public static String getXtMonthDone(String parentid,String status){
      Connection conn=null;
		PreparedStatement ps=null;
		ResultSet rs=null;
		String total = "";
		String sql="";
		try{
                if("bysl".equals(status)){
				    sql="select count(*) as total from FLOW_INSTANCES t,zmview a where  t.app_id=a.unid ";
				}else if("bybj".equals(status)){
                    sql="select count(*) as total from FLOW_INSTANCES t,zmview a where  t.app_id=a.unid and t.instance_status='2'";
				}else if("bydcl".equals(status)){
                    sql="select count(*) as total from ZMVIEW t where  zm_status='待受理'";
				}else if("bysh".equals(status)){
                    sql="select count(*) as total from ZMVIEW t where  zm_status='审核通过'";
				}else if("bybysh".equals(status)){
                    sql="select count(*) as total from ZMVIEW t where  zm_status='不予审核'";
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

