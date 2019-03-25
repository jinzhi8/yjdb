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


	String dbid=request.getParameter("unid");
	String status=request.getParameter("status");
	System.out.println("status:"+status);
	SimpleORMUtils instance=SimpleORMUtils.getInstance();
	if(status.equals("0")){
		instance.executeUpdate("update getshou  set rangeidlist='已转督办' where requestid=?",dbid);
		System.out.println("更新已转督办");
	}else if(status.equals("1")){
		instance.executeUpdate("update getshou  set rangeidlist='已下发',xftime=sysdate where requestid=?",dbid);
		System.out.println("更新已下发");
	}
	out.print("ok");
%>
