<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.oreilly.servlet.MultipartRequest" %>
<%@page import="com.oreilly.servlet.UploadedFile" %>
<%@page import="com.oreilly.servlet.multipart.RandomFileRenamePolicy" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.List" %>
<%@page import="com.kizsoft.oa.wskzm.util.SimpleORMUtils"%>
<%@page import="java.util.Date" %>
<%@page import="java.util.Enumeration" %>
<%@page import="com.kizsoft.commons.commons.attachment.AttachmentManager" %>
<%@page import="com.kizsoft.commons.commons.attachment.AttachmentEntity" %>

<%
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
		return;
	}
	
	//System.out.println("1111111111111111111111111111111111111111111111111");
	
	MultipartRequest req = null;
    SimpleDateFormat sdfym = new SimpleDateFormat("yyyyMM");
    SimpleDateFormat sdfd = new SimpleDateFormat("dd");
    String attachmentDir = "/attachment/" + sdfym.format(new Date()) + "/" + sdfd.format(new Date()) + "/";
    String attachmentBaseDir = request.getSession().getServletContext().getRealPath(attachmentDir);
    int attachmentMaxSize = 1073741824;
	
	RandomFileRenamePolicy rfrp = new RandomFileRenamePolicy();
    req = new MultipartRequest(request, attachmentBaseDir, attachmentMaxSize, "UTF-8", rfrp);
	
	String uuid=req.getParameter("uuid");
	String docid=req.getParameter("docid");
	String moduleId=req.getParameter("moduleId");
	String type=req.getParameter("type");
	
	//System.out.println(uuid);
	//System.out.println(docid);
	//System.out.println(moduleId);
	//System.out.println(type);
	SimpleORMUtils instance=SimpleORMUtils.getInstance();
	String attachName="";
	if(uuid!=null&&!"".equals(uuid)){
		
		List<Object[]> list=instance.queryForList("select t.attachmentid,t.attachmentpath,t.attachmentname from COMMON_ATTACHMENT t where t.attachmentid=?",uuid);
		if(list.size()>0){
			Object[] os=list.get(0);
			String temp=(String)os[2];
			if(temp!=null&&temp.lastIndexOf(".")>0){
				attachName=temp.substring(0,temp.lastIndexOf("."))+".pdf";
			}
		}
	}
	instance.executeUpdate("delete from COMMON_ATTACHMENT where docunid=? and moduleId=? and type=?",docid,moduleId,type);
	System.out.println("attachName:"+attachName);
	AttachmentManager attachmentManager = new AttachmentManager();
	Enumeration files = req.getFileListNames();
	if (files.hasMoreElements()) {
	  String name = (String)files.nextElement();
	  List fileList = req.getFileList(name);
	  for (int i = 0; i < fileList.size(); ++i) {
		UploadedFile uf = (UploadedFile)fileList.get(i);
		String gs=uf.getFilesystemName();
		gs=gs.substring(gs.lastIndexOf("."))+"";
		AttachmentEntity attachmentEntity = new AttachmentEntity();
		attachmentEntity.setModuleId(moduleId);
		attachmentEntity.setDocunid(docid);
		attachmentEntity.setType(type);
		attachmentEntity.setAttachmentPath(attachmentDir + uf.getFilesystemName());
		if(gs.equals(".jpg")){
		attachmentEntity.setAttachmentName("".equals(attachName)?"签章证明.jpg":attachName);
		}else{
		attachmentEntity.setAttachmentName("".equals(attachName)?"签章证明.pdf":attachName);
		}
		attachmentManager.saveAttach(attachmentEntity);
		//System.out.println("path: "+attachmentDir + uf.getFilesystemName());
		//System.out.println(uf.getOriginalFileName()+"     "+attachName);
	  }
	  out.println("1");
	}
	
%>
