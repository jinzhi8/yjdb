<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.oreilly.servlet.MultipartRequest" %>
<%@page import="com.oreilly.servlet.UploadedFile" %>
<%@page import="com.oreilly.servlet.multipart.RandomFileRenamePolicy" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.List" %>
<%@page import="com.kizsoft.commons.commons.orm.SimpleORMUtils"%>
<%@page import="java.util.Date" %>
<%@page import="java.util.Enumeration" %>
<%@page import="com.kizsoft.commons.commons.attachment.AttachmentManager" %>
<%@page import="com.kizsoft.commons.commons.attachment.AttachmentEntity" %>
<%@page import="com.kizsoft.commons.util.UUIDGenerator" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%
	User userInfo = (User) session.getAttribute("userInfo");
    if (userInfo == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    String userID = userInfo.getUserId();
    Group groupInfo = userInfo.getGroup();
    String groupID = groupInfo.getGroupId();
    String userName = userInfo.getUsername();
    String depName = groupInfo.getGroupname();
		

	String dbid=request.getParameter("unid");
	String fkid=UUIDGenerator.getUUID();
	String fkattachname="";
	String fkattachpath="";
	String fklsqk="";
	String fkczwt="";
	String fkxbsl="";
	String begintime="";
	String finishtime="";
	String sfbj="";
	//String contextType=request.getContentType();
	//System.out.println(contextType);
	if(dbid!=null&&!"".equals(dbid)){  
		dbid=request.getParameter("unid");
		fklsqk=request.getParameter("fklsqk");
		fkczwt=request.getParameter("fkczwt");
		fkxbsl=request.getParameter("fkxbsl");
		begintime=request.getParameter("begintime");
		finishtime=request.getParameter("finishtime");
		sfbj=request.getParameter("sfbj");

	}
	SimpleORMUtils instance=SimpleORMUtils.getInstance();
		
	instance.executeUpdate("insert into zwdbhyfkpg(unid,dbid,fklsqk,fkczwt,fkxbsl,begintime,finishtime,sfbj,fkr,fkrid,fkuser,fkuserid,fksj) values(?,?,?,?,?,to_date ('" + begintime + "','yyyy-mm-dd'),to_date ('" + finishtime + "','yyyy-mm-dd hh24:mi:ss'),?,?,?,?,?,sysdate)",fkid,dbid,fklsqk,fkczwt,fkxbsl,sfbj,depName,groupID,userName,userID);

	System.out.println("dbid:"+dbid);
	System.out.println("groupID:"+groupID);
	instance.executeUpdate("update zwdbhyacl a set a.nextsj=get_nextsjhy(?,a.nextsj),a.endsj=get_nextsjhy(?,a.endsj),a.fkyqtz=(select max(decode(z.fklx,'定期',a.fkyqtz,'1')) from ZWDBHYMIN z where z.unid=?),a.fktxtx=(select max(decode(z.fklx,'定期',a.fktxtx,'0')) from ZWDBHYMIN z where z.unid=?),a.isfk=(select max(decode(z.fklx,'定期','1','0')) from ZWDBHYMIN z where z.unid=?) where a.dbid=? and a.fkrid=?",dbid,dbid,dbid,dbid,dbid,dbid,groupID);
	System.out.println("更新反馈时间");
	out.print("ok");
%>
