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
<%@page import="java.util.Map" %>
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
        SimpleORMUtils instance=SimpleORMUtils.getInstance();
        List<ZmInfo> info=new ArrayList();
	    int len=parentid.length();
	    if(len<10){
	     info=instance.queryForList(ZmInfo.class,"select * from KZM_ZMINFO t where t.szdid=? and t.zmid not in('9c14f44c8e924c2fa63b15338bda998d') and t.status='1'",parentid);
	    }else{
	     info=instance.queryForList(ZmInfo.class,"select min(id) as id ,min(zmname) as zmname,min(szdid) as szdid,t.zmid from KZM_ZMINFO t  where  t.zmid not in('9c14f44c8e924c2fa63b15338bda998d') and t.status='1' group by zmid");    
	    }
	      int zmsize= info.size();
	      String zmJson="";
          List<Map<String,String>> list=new ArrayList();
	      for(int y=0;y<zmsize;y++){
	      String name=info.get(y).getZmname();
	      String id =info.get(y).getId();
	      String szdid=info.get(y).getSzdid();
	      String count="";
	      if(len<10){
	      count=getCount(id,szdid);
	      }else{
	      count=getNewCount(name); 
	      }
	      Map<String,String> map=new HashMap<String,String>();
	      map.put("label",name);
	      map.put("value",count);
	      //zmJson=zmJson+"{\"label\":\""+name+"\",\"value\":\""+count+"\"},";
	      list.add(map);
	    }  
	      //zmJson="["+zmJson.substring(0,zmJson.length()-1)+"]";
	      //System.out.println("list:"+list);
	      JSONArray jsStr = JSONArray.fromObject(list);
	      //System.out.println("jsStr:"+jsStr);
	      out.print(jsStr);
%>
<%!
    public static String getCount(String id,String szdid){
        Connection conn=null;
		PreparedStatement ps=null;
		ResultSet rs=null;
		String total = "";
		String sql="";
		try{
            sql="select count(*) as total from ZMVIEW t  where szdid='"+szdid+"' and infoid='"+id+"'";
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
    public static String getNewCount(String name){
        Connection conn=null;
		PreparedStatement ps=null;
		ResultSet rs=null;
		String total = "";
		String sql="";
		try{
            sql="select count(*) as total from ZMVIEW t  where  zmname='"+name+"'";
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

