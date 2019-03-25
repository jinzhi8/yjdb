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
<%@page import="com.kizsoft.commons.commons.orm.SimpleORMUtils"%>
<%@page import="java.util.Date" %>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Map" %>
<%@page import="java.util.List"%>
<%@page import="net.sf.json.JSONArray" %>
<%@page import="net.sf.json.JSONObject" %>
<%@page import="com.kizsoft.commons.util.UUIDGenerator" %>
<%@page import="com.kizsoft.commons.uum.pojo.Owner" %>
<%@page import="com.kizsoft.commons.uum.utils.UUMContend" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.UserException" %>
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
    System.out.println(jbsx);
    String leaderid=request.getParameter("leaderid");
    String sourceid=request.getParameter("sourceid");
    String fkzq=request.getParameter("fkzq");

    String fklx=request.getParameter("fklx");
    String issuetime=request.getParameter("issuetime");
    System.out.println(issuetime);
    String qftime=request.getParameter("qftime");
    System.out.println(qftime);
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

    String draftmanid=request.getParameter("draftmanid");
    userID=userID+","+draftmanid;
    System.out.println("11111111111111111111111");
    
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
         System.out.println("222222222222222222");
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
         System.out.println("333333333333333333");
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
      String message="";
      SimpleORMUtils instance = SimpleORMUtils.getInstance();
      //instance.executeUpdate("update FLOW_INSTANCES set instance_status='2' where app_id=?",docunid);
      instance.executeUpdate("update GETSHOUZWDB set rangeidlist='同意督办' where requestid=?",docunid);
      System.out.println("执行一次");
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
          System.out.println("插入成功");
      }
    }
%>
<%!
    public static void insertRequest(HttpServletRequest request,String message,String docunid){
      User userInfo = (User)request.getSession().getAttribute("userInfo");
      String userId = userInfo.getUserId();
      String username = userInfo.getUsername();
      Group groupInfo = null;
      SimpleORMUtils instance = SimpleORMUtils.getInstance();
      try {
        groupInfo = userInfo.getGroup();
      } catch (UserException e) {
        e.printStackTrace();
      }
      String unid=UUIDGenerator.getUUID();
      String groupid = groupInfo.getGroupId();
      String groupname=groupInfo.getGroupname();
      String sql="select * from FLOW_TASKS t where t.instance_id=(select instance_id from " +
          "FLOW_INSTANCES where app_id='"+docunid+"') and task_status='0'";
      List<Map<String,Object>> list=instance.queryForMap(sql);
      if(list.size()!=0){
        Object task_id=list.get(0).get("task_id");
        instance.executeUpdate("insert into FLOW_REQUESTS(req_id,task_id,participant,req_time,req_status,message,participant_cn," +
            "DEPARTMENTNAME,DEPARTMENTID) values(?,?,?,sysdate,'1',?,?,?,?)",unid,task_id,userId,message,username,groupname,groupid );
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