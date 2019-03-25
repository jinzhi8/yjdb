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
	SimpleORMUtils instance=SimpleORMUtils.getInstance();
	instance.executeUpdate("delete from documents where documentsid=?",dbid);
	instance.executeUpdate("update getshou  set rangeidlist='未下发',xftime=sysdate where requestid=?",dbid);
	out.print("ok");
%>
