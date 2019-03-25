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
    String unid=request.getParameter("unid");
    String docunid=request.getParameter("docunid");
    SimpleORMUtils instance=SimpleORMUtils.getInstance();
    instance.executeUpdate("update ZWDB set docunid=?,hy='会议' where issueflag=?",unid,docunid);  
    instance.executeUpdate("update zwdb set isjs='2' where docunid=?",unid);
    ACLPRIVILELIST(unid);
	  out.print("ok");
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

