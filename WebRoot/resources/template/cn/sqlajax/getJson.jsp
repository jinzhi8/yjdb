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
        List<Szd> szds=instance.queryForList(Szd.class,"select * from KZM_SZD t where t.type='1' and  t.pid=? order by to_number(ordernum)","330300");
		int size=szds.size();
	    String json="";
	    List<Map<String,String>> list=new ArrayList();
	    for(int z=0;z<size;z++){
		String name=szds.get(z).getName();
		String id =szds.get(z).getId();	 
		String data=getLjTodo(id);
		//json=json+ "{\"label\":\""+name+"\",\"value\":\""+data+"\"},";
		Map<String,String> map=new HashMap<String,String>();
	    map.put("label",name);
	    map.put("value",data);
	      //zmJson=zmJson+"{\"label\":\""+name+"\",\"value\":\""+count+"\"},";
	    list.add(map);
	    } 
	    //json="["+json.substring(0,json.length()-1)+"]";
        JSONArray jsStr = JSONArray.fromObject(list);
	    out.print(jsStr);
	    //System.out.println("json:"+json);
%>
<%!
    public static String getLjTodo(String parentid){
      Connection conn=null;
		PreparedStatement ps=null;
		ResultSet rs=null;
		String total = "";
		int len = parentid.length();
        String sql="";
		try{
		if(len<10)
		{
			 sql="select count(*) as total from FLOW_INSTANCES t,zmview a where a.unid=t.app_id and a.szdid='"+parentid+"'  ";
		}else{
		     sql="select count(*) as total from FLOW_INSTANCES t,zmview a where a.unid=t.app_id "; 
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

