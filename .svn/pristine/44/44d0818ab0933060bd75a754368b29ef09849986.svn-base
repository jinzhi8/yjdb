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
        String btzmname=request.getParameter("btzmname");
        System.out.println("btzmname:"+btzmname);
        List<ZmInfo> info=new ArrayList();
        int len=parentid.length();
	    String jsonName="";
	    String statusA="待受理";
	    String statusB="审核通过";
	    String statusC="不予审核";
	    String countSHTG="";
	    String countDSL="";
	    String countBYSH="";

        if(len<10){  
		    countSHTG=getCount(btzmname,statusB);
		    countDSL=getCount(btzmname,statusA); 
		    countBYSH=getCount(btzmname,statusC);
		}else{
		    countSHTG=getNewCount(btzmname,statusB);
		    countDSL=getNewCount(btzmname,statusA); 
		    countBYSH=getNewCount(btzmname,statusC);
		}    

	    //System.out.println("list:"+list);
	    //JSONArray jsname = JSONArray.fromObject(jsonName);
	    //JSONArray jsdsl = JSONArray.fromObject(jsonDSL);
	    //JSONArray jsshtg = JSONArray.fromObject(jsonSHTG);
	    //JSONArray jsbysh = JSONArray.fromObject(jsonBYSH);
        //String[] obj={jsonDSL,jsonBYSH,jsonSHTG,jsonName};
        //Object[] obj1 = new Object[]{jsStr,jsonBYSH,jsonSHTG,jsonName};
        String dJson= "[{\"label\":\"待受理\",\"color\":\"#9a7d99\",\"value\":"+countDSL+",\"tooltext\":\"待受理, $percentValue\"},{\"label\":\"审核通过\",\"color\":\"#577da2\",\"value\":"+countSHTG+",\"tooltext\":\"审核通过, $percentValue\"},{\"label\":\"不予审核\",\"color\":\"#008ee4\",\"value\": "+countBYSH+",\"tooltext\":\"不予审核, $percentValue\"}]";
        //System.out.println("dJson:"+dJson);
        /*String json="{\"data\":"+dJson+"}";*/
	    out.print(dJson);
%>
<%!
    public static String getCount(String id,String status){
        Connection conn=null;
		PreparedStatement ps=null;
		ResultSet rs=null;
		String total = "";
		String sql="";
		try{
            sql="select count(*) as total from hzcxview t  where  infoid='"+id+"' and zm_status='"+status+"'";
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
            sql="select count(*) as total from hzcxview t  where  zmname='"+name+"' and zm_status='"+status+"'";
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

