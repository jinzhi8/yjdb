<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.oreilly.servlet.MultipartRequest" %>
<%@page import="com.oreilly.servlet.UploadedFile" %>
<%@page import="com.oreilly.servlet.multipart.RandomFileRenamePolicy" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.List" %>
<%@page import="com.kizsoft.oa.wskzm.util.SimpleORMUtils"%>
<%@page import="java.util.Date" %>
<%@page import="java.util.Enumeration" %>
<%@page import="com.kizsoft.oa.wskzm.util.DocConverter" %>
<%
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
		return;
	}
	MultipartRequest req = null;
    SimpleDateFormat sdfym = new SimpleDateFormat("yyyyMM");
    SimpleDateFormat sdfd = new SimpleDateFormat("dd");
    String attachmentDir = "/attachment/" + sdfym.format(new Date()) + "/" + sdfd.format(new Date()) + "/";
    String attachmentBaseDir = request.getSession().getServletContext().getRealPath(attachmentDir);
    int attachmentMaxSize = 1073741824;
	
	RandomFileRenamePolicy rfrp = new RandomFileRenamePolicy();
    req = new MultipartRequest(request, attachmentBaseDir, attachmentMaxSize, "UTF-8", rfrp);
	
	Enumeration files = req.getFileListNames();
	if (files.hasMoreElements()) {
	  String name = (String)files.nextElement();
	  List fileList = req.getFileList(name);
	  for (int i = 0; i < fileList.size(); ++i) {
		UploadedFile uf = (UploadedFile)fileList.get(i);
		System.out.println("path: "+attachmentDir + uf.getFilesystemName());
		String src=attachmentDir + uf.getFilesystemName();
		String dest=src.substring(0,src.lastIndexOf("."))+".pdf";
		boolean flag=DocConverter.doc2pdf(session.getServletContext().getRealPath(src),session.getServletContext().getRealPath(dest));
		if(flag){
			out.println(dest);
			return;
		}
	  }
	  out.println("0");
	}
	
%>
