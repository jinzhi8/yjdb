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
	String unid="";
	String fklsqk="";
	String fkattachname="";
	String fkattachpath="";
	String dbid=request.getParameter("unid");
	if(dbid!=null&&!"".equals(dbid)){  
		unid=request.getParameter("unid");
		fklsqk=request.getParameter("fklsqk");
	}else{
		MultipartRequest req = null;
		SimpleDateFormat sdfym = new SimpleDateFormat("yyyyMM");
		SimpleDateFormat sdfd = new SimpleDateFormat("dd");
		String attachmentDir = "/attachment/" + sdfym.format(new Date()) + "/" + sdfd.format(new Date()) + "/";
		String attachmentBaseDir = request.getSession().getServletContext().getRealPath(attachmentDir);
		int attachmentMaxSize = 1073741824;
		RandomFileRenamePolicy rfrp = new RandomFileRenamePolicy();
		req = new MultipartRequest(request, attachmentBaseDir, attachmentMaxSize, "UTF-8", rfrp);
		unid=req.getParameter("unid");
		fklsqk=req.getParameter("fklsqk");
		List fileList = req.getFileList("fkattach");
		if(fileList!=null)
		for (int i = 0; i < fileList.size(); ++i) {
			UploadedFile uf = (UploadedFile)fileList.get(i);
			System.out.println("path: "+attachmentDir + uf.getFilesystemName());
			System.out.println(uf.getOriginalFileName());
			fkattachname=uf.getOriginalFileName();
			fkattachpath=attachmentDir + uf.getFilesystemName();
			break;
		}
	}
	String fkid=UUIDGenerator.getUUID();	
	SimpleORMUtils instance=SimpleORMUtils.getInstance();
	if(fkattachpath!=null&&!"".equals(fkattachpath)){
			instance.executeUpdate("update ZWDBFKPG t set t.fklsqk=?,t.fkattachname=?,t.fkattachpath=?,isfk='1' where t.unid=?",fklsqk,fkattachname,fkattachpath,unid);

			instance.executeUpdate("insert into ZWDB_FKXG(unid,dbid,userid,username,time) values(?,?,?,?,sysdate)",fkid,unid,userID,userName);
	}else{
			instance.executeUpdate("update ZWDBFKPG t set t.fklsqk=?,isfk='1' where t.unid=?",fklsqk,unid);
			instance.executeUpdate("insert into ZWDB_FKXG(unid,dbid,userid,username,time) values(?,?,?,?,sysdate)",fkid,unid,userID,userName);
		}
	out.println("ok");
	
%>
