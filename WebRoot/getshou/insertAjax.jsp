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
<%@page import="com.kizsoft.oa.wcoa.util.SimpleORMUtils" %>
<%@page import="java.util.Date" %>
<%@page import="java.util.Calendar"%>
<%@page import="net.sf.json.JSONArray" %>
<%@page import="net.sf.json.JSONObject" %>
<%@page import="com.kizsoft.commons.util.UUIDGenerator" %>
<%@page import="com.kizsoft.commons.uum.pojo.Owner" %>
<%@page import="com.kizsoft.commons.uum.utils.UUMContend" %>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<%@taglib prefix="html" uri="/WEB-INF/oa-html.tld" %>
<%@taglib prefix="oa" uri="/WEB-INF/oa.tld" %>
<%
    String docunid=request.getParameter("docunid");
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
    String unid=UUIDGenerator.getUUID();
    String qfman=request.getParameter("qfman");
    String year=request.getParameter("year");
    String num=request.getParameter("num");
    String qfmanid=request.getParameter("qfmanid");
    
    ACLPRIVILELIST(unid);
        if(!title.equals("")){
          Connection conn=null;
      PreparedStatement ps=null;
      ResultSet rs=null;
      try{
        String sql="insert into ZWDB(unid,depid,depname,userid,username,title,require,leadername,source,jbsx,fklx,issuetime,qftime,managedepname,managedepid,copyto,copytoid,lxr,lxdh,czhm,issueflag,qfman,leaderid,sourceid,fkzq,year,num,isjs,qfmanid) values(?,?,?,?,?,?,?,?,?,to_date ('" + jbsx + "','yyyy-mm-dd hh24:mi:ss'),?,to_date ('" + issuetime + "','yyyy-mm-dd hh24:mi:ss'),to_date ('" + qftime + "','yyyy-mm-dd hh24:mi:ss'),?,?,?,?,?,?,?,?,?,?,?,?,?,?,'2',?)";
        conn=ConnectionProvider.getConnection();
        ps=conn.prepareStatement(sql);
        ps.setString(1,unid);
        ps.setString(2,groupID);
        ps.setString(3,depName);
        ps.setString(4,userID);
        ps.setString(5,userName);
        ps.setString(6,title);
        ps.setString(7,require);
        ps.setString(8,leadername);
        ps.setString(9,source);
        ps.setString(10,fklx);
        ps.setString(11,managedepname);
        ps.setString(12,managedepid);
        ps.setString(13,copyto);
        ps.setString(14,copytoid);
        ps.setString(15,lxr);
        ps.setString(16,lxdh);
        ps.setString(17,czhm);
        ps.setString(18,docunid);
        ps.setString(19,qfman);
        ps.setString(20,leaderid);
        ps.setString(21,sourceid);
        ps.setString(22,fkzq);
        ps.setString(23,year);
        ps.setString(24,num);
        ps.setString(25,qfmanid);
            ps.executeUpdate();
      }catch(Exception e){
        e.printStackTrace();
        return;
      }finally{
        ConnectionProvider.close(conn,ps,rs);
      }
    }
      insertZwdbAcl(unid,managedepid,copytoid,leaderid,sourceid,qftime);
      out.print("ok");
%>
<%!
     private void insertZwdbAcl(String unid, String managedepid,String copytoid,String leaderid,String sourceid,String qftime)
    {
        ACLManagerFactory.getACLManager().appendACLRange(unid, leaderid);
        ACLManagerFactory.getACLManager().appendACLRange(unid, managedepid);
        ACLManagerFactory.getACLManager().appendACLRange(unid, copytoid);
        ACLManagerFactory.getACLManager().appendACLRange(unid, sourceid);
        SimpleORMUtils instance = SimpleORMUtils.getInstance();
        if (managedepid == null)
          return;
        //managedepid=managedepid+","+copytoid;
        String[] depids = managedepid.split(",");
        for (String depid : depids) {
          Owner o = UUMContend.getUUMService().getOwnerByOwnerid(depid);

          if (o == null)
            continue;
          String depname = o.getOwnername();
          
          instance.executeUpdate("insert into zwdbacl(unid,dbid,fkr,fkrid,nextsj,endsj) values(?,?,?,?,to_date ('" + qftime + "','yyyy/mm/dd'),get_nextsj(?,to_date ('" + qftime + "','yyyy/mm/dd')))", new Object[] { UUIDGenerator.getUUID(), unid, depname, depid, unid });
      }
    }
%>
<%!
  public void ACLPRIVILELIST(String unid) {
    String sql = "";
    Connection conn = null;
    PreparedStatement ps = null;
    String undi = "";
    try {
      sql = "insert into ACLPRIVILELIST(confid,workid,ownerid) values('" + UUIDGenerator.getUUID() + "','" + unid + "','*')";
      conn = ConnectionProvider.getConnection();
      ps = conn.prepareStatement(sql);
      ps.executeUpdate();
    }
    catch (Exception e) {
      e.printStackTrace();
    } finally {
      ConnectionProvider.close(conn, ps);
    }
  }
%>