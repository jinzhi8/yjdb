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
	    String jsonName="";
	    String statusA="待受理";
	    String statusB="审核通过";
	    String statusC="不予审核";
	    String jsonDSL="";
	    String jsonSHTG="";
	    String jsonBYSH="";
	    String countSHTG="";
	    String countDSL="";
	    String countBYSH="";
	    for(int y=0;y<zmsize;y++){
		    String name=info.get(y).getZmname();
		    String id =info.get(y).getId();
		    String szdid=info.get(y).getSzdid();
        if(len<10){  
		    countSHTG=getCount(id,szdid,statusB);
		    countDSL=getCount(id,szdid,statusA); 
		    countBYSH=getCount(id,szdid,statusC);
		}else{
		    countSHTG=getNewCount(name,statusB);
		    countDSL=getNewCount(name,statusA); 
		    countBYSH=getNewCount(name,statusC);
		}    

		    jsonName=jsonName+ "{\"label\":\""+name+"\"},";  
		    jsonDSL=jsonDSL+"{\"value\":\""+countDSL+"\"},";
		    jsonBYSH=jsonBYSH+"{\"value\":\""+countBYSH+"\"},";  		    
		    jsonSHTG=jsonSHTG+"{\"value\":\""+countSHTG+"\"},";     
	    } 
        jsonBYSH="["+jsonBYSH.substring(0,jsonBYSH.length()-1)+"]";
        //System.out.println("jsonBYSH:"+jsonBYSH);
	    jsonDSL="["+jsonDSL.substring(0,jsonDSL.length()-1)+"]";
	    //System.out.println("jsonDSL:"+jsonDSL);
	    jsonSHTG="["+jsonSHTG.substring(0,jsonSHTG.length()-1)+"]";
	    
	    jsonName="["+jsonName.substring(0,jsonName.length()-1)+"]";
	    //System.out.println("list:"+list);
	    //JSONArray jsname = JSONArray.fromObject(jsonName);
	    //JSONArray jsdsl = JSONArray.fromObject(jsonDSL);
	    //JSONArray jsshtg = JSONArray.fromObject(jsonSHTG);
	    //JSONArray jsbysh = JSONArray.fromObject(jsonBYSH);
        //String[] obj={jsonDSL,jsonBYSH,jsonSHTG,jsonName};
        //Object[] obj1 = new Object[]{jsStr,jsonBYSH,jsonSHTG,jsonName};
        String dJson= "{\"categories\":[{\"category\": "+jsonName+"}],\"dataset\":[{\"seriesname\":\"待受理\",\"data\": "+jsonDSL+"},{\"seriesname\":\"审核通过\",\"data\": "+jsonSHTG+"},{\"seriesname\":\"不予审核\",\"data\": "+jsonBYSH+"}]}";
        //System.out.println("dJson:"+dJson);
        String json="{\"data\":"+dJson+"}";
	    out.print(json);
%>
<%!
    public static String getCount(String id,String szdid,String status){
        Connection conn=null;
		PreparedStatement ps=null;
		ResultSet rs=null;
		String total = "";
		String sql="";
		try{
            sql="select count(*) as total from ZMVIEW t  where szdid='"+szdid+"' and infoid='"+id+"' and zm_status='"+status+"'";
			conn=ConnectionProvider.getConnection();
			ps=conn.prepareStatement(sql);
			//System.out.println("sql:"+sql);
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
    public static String getNewCount(String name,String status){
        Connection conn=null;
		PreparedStatement ps=null;
		ResultSet rs=null;
		String total = "";
		String sql="";
		try{
            sql="select count(*) as total from ZMVIEW t  where  zmname='"+name+"' and zm_status='"+status+"'";
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

