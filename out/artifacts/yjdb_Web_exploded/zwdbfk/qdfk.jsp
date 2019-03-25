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
    MultipartRequest req = null;
    String userID = userInfo.getUserId();
    Group groupInfo = userInfo.getGroup();
    String groupID = groupInfo.getGroupId();
    String userName = userInfo.getUsername();
    String depName = groupInfo.getGroupname();
		

	String unid=request.getParameter("unid");
    String czwt=request.getParameter("czwt");
    String xbsl=request.getParameter("xbsl");
	SimpleORMUtils instance=SimpleORMUtils.getInstance();
    String fkid=UUIDGenerator.getUUID();  
    if(czwt.equals("审核不通过")){
        instance.executeUpdate("update ZWDBFKPG a set a.isfk='0',a.ispg=? where a.unid=? ",czwt,unid);
    }else{
        instance.executeUpdate("update ZWDBFKPG a set a.isfk='2',a.ispg=? where a.unid=? ",czwt,unid); 
    }  	
    instance.executeUpdate("insert into ZWDB_DBK(unid,dbid,userid,username,sh,shyj,time) values(?,?,?,?,?,?,sysdate)",fkid,unid,userID,userName,czwt,xbsl);
	out.print("ok");
%>
