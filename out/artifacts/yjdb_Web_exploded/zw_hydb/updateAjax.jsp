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
<%@page import="net.sf.json.JSONArray" %>
<%@page import="net.sf.json.JSONObject" %>
<%@page import="com.kizsoft.commons.util.UUIDGenerator" %>
<%@page import="com.kizsoft.oa.wcoa.util.SimpleORMUtils" %>
<%@page import="com.kizsoft.commons.uum.pojo.Owner" %>
<%@page import="com.kizsoft.commons.uum.utils.UUMContend" %>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<%@taglib prefix="html" uri="/WEB-INF/oa-html.tld" %>
<%@taglib prefix="oa" uri="/WEB-INF/oa.tld" %>
<%
    String docunid=request.getParameter("docunid");
    String qfman=request.getParameter("qfman");
    String userID=request.getParameter("userID");
    String groupID=request.getParameter("groupID");
    String userName=request.getParameter("userName");
    String depName=request.getParameter("depName");
    String title=request.getParameter("title");
    //System.out.println("title"+title);
    String require=request.getParameter("require");
    String leadername=request.getParameter("leadername");
    String source=request.getParameter("source");
    String jbsx=request.getParameter("jbsx");
    String leaderid=request.getParameter("leaderid");
    String sourceid=request.getParameter("sourceid");
    String fkzq=request.getParameter("fkzq");

    String fklx=request.getParameter("fklx");
    String issuetime=request.getParameter("issuetime");
    String qftime=request.getParameter("qftime");
    String managedepname=request.getParameter("managedepname");
    String managedepid=request.getParameter("managedepid");
    String copyto=request.getParameter("copyto");
    String copytoid=request.getParameter("copytoid");
    String lxr=request.getParameter("lxr");
    String lxdh=request.getParameter("lxdh");
    String czhm=request.getParameter("czhm");
    String unid=request.getParameter("unid");
    String year=request.getParameter("year");
    String num=request.getParameter("num");
    String qfmanid=request.getParameter("qfmanid");

        if(!title.equals("")){
	        Connection conn=null;
			PreparedStatement ps=null;
			ResultSet rs=null;
			try{
				String sql="update ZWDB set depid=?,depname=?,userid=?,username=?,title=?,require=?,leadername=?,source=?,jbsx=to_date ('" + jbsx + "','yyyy-mm-dd hh24:mi:ss'),fklx=?,issuetime=to_date ('" + issuetime + "','yyyy-mm-dd hh24:mi:ss'),qftime=to_date ('" + qftime + "','yyyy-mm-dd hh24:mi:ss'),managedepname=?,managedepid=?,copyto=?,copytoid=?,lxr=?,lxdh=?,czhm=?,issueflag=?,qfman=?,leaderid=?,sourceid=?,fkzq=?,year=?,num=?,qfmanid=? where unid=?";
				conn=ConnectionProvider.getConnection();
				ps=conn.prepareStatement(sql);			
				ps.setString(1,groupID);
				ps.setString(2,depName);
				ps.setString(3,userID);
				ps.setString(4,userName);
				ps.setString(5,title);
				ps.setString(6,require);
				ps.setString(7,leadername);
				ps.setString(8,source);
				ps.setString(9,fklx);
				ps.setString(10,managedepname);
				ps.setString(11,managedepid);
				ps.setString(12,copyto);
				ps.setString(13,copytoid);
				ps.setString(14,lxr);
				ps.setString(15,lxdh);
				ps.setString(16,czhm);
				ps.setString(17,docunid);
				ps.setString(18,qfman);
				ps.setString(19,leaderid);
				ps.setString(20,sourceid);
				ps.setString(21,fkzq);
				ps.setString(22,year);
				ps.setString(23,num);
				ps.setString(24,qfmanid);
                ps.setString(25,unid);
                System.out.println("更新unid"+unid);
       			ps.executeUpdate();
			}catch(Exception e){
				e.printStackTrace();
				return;
			}finally{
				ConnectionProvider.close(conn,ps,rs);
			}
		}
			String dJson= "[{\"unid\":\""+unid+"\",\"leadername\":\""+leadername+"\",\"title\":\""+title+"\",\"jbsx\":\""+jbsx+"\",\"qftime\":\""+qftime+"\",\"require\":\""+require+"\",\"qfman\":\""+qfman+"\"}]";
			JSONArray jsStr = JSONArray.fromObject(dJson);
            //System.out.println("jsStr"+jsStr);	
			SimpleORMUtils instance = SimpleORMUtils.getInstance();
			instance.executeUpdate("update zwdbacl set fkr=?,fkrid=? where dbid=?",managedepname,managedepid,unid);
			System.out.println("更新zwdbacl");
	        out.print(jsStr);
%>


