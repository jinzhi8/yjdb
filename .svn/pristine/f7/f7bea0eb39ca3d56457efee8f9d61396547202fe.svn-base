<%@page language="java" contentType="text/html;charset=utf-8" %><%@page import="java.io.*" %><%@page import="java.util.*" %><%@page import="com.oreilly.servlet.MultipartRequest" %><%@page import="com.oreilly.servlet.multipart.RandomFileRenamePolicy" %><%@page import="com.oreilly.servlet.ServletUtils" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.commons.util.StringHelper" %>
<%@page import="com.kizsoft.commons.commons.util.UnidHelper" %>
<%@page import="java.sql.*"%>
<%@page import="org.dom4j.*"%>
<%@page import="org.dom4j.io.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.kizsoft.commons.acl.ACLManager"%>
<%@page import="com.kizsoft.commons.acl.ACLManagerFactory"%>
<%@page import="com.kizsoft.commons.commons.db.ConnectionProvider"%>
<%@page import="com.kizsoft.commons.commons.attachment.AttachmentManager"%>
<%@page import="com.kizsoft.commons.commons.attachment.AttachmentEntity"%>
<%@page import="com.kizsoft.commons.commons.attachment.FileUploadHelper"%><%
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
		return;
	}
	//request.setCharacterEncoding("UTF-8");
	//设置上传文件的大小，超过这个大小 将抛出IOException异常，默认大小是100M。
	String tmpfilepath = request.getSession().getServletContext().getRealPath("/attachment") ;
	int inmaxPostSize = 100 * 1024 * 1024;
	MultipartRequest multirequest = null;
	try {
		RandomFileRenamePolicy rfrp = new RandomFileRenamePolicy();
		multirequest = new MultipartRequest(request, tmpfilepath, inmaxPostSize,"UTF-8",rfrp); //GBK中文编码模式上传文件
	}catch (Exception e) {
		e.printStackTrace();
	}
	String action = request.getParameter("action")==null?multirequest.getParameter("action"):request.getParameter("action");
	String getFilePath = request.getParameter("filepath")==null?multirequest.getParameter("filepath"):request.getParameter("filepath");
	String getFileName = request.getParameter("filename")==null?multirequest.getParameter("filename"):request.getParameter("filename");
	String getDocTitle = request.getParameter("doctitle")==null?multirequest.getParameter("doctitle"):request.getParameter("doctitle");
	String getModuleID = request.getParameter("moduleID")==null?multirequest.getParameter("moduleID"):request.getParameter("moduleID");
	String getDocID = request.getParameter("docid")==null?multirequest.getParameter("docid"):request.getParameter("docid");
	String getDocType = request.getParameter("doctype")==null?multirequest.getParameter("doctype"):request.getParameter("doctype");
	getDocTitle = java.net.URLDecoder.decode(getDocTitle, "utf-8");
	java.util.Date currentTime = new java.util.Date();  
	SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");  
	String dateString = formatter.format(currentTime);  
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat sdfym = new SimpleDateFormat("yyyyMM");
	SimpleDateFormat sdfd = new SimpleDateFormat("dd");
	//System.out.println(action+"_"+getFilePath+"_"+getFileName+"_"+tmpfilepath);
	if(action!=null&&"upload".equals(action)){
		String uploadAttachmentFileName = java.util.UUID.randomUUID().toString().replaceAll("-", "")+".ceb";
		String uploadAttachmentDir = "/attachment/" + sdfym.format(df.parse(dateString).getTime()) + "/" + sdfd.format(df.parse(dateString).getTime()) + "/";
		String uploadAttachmentFullFileName = uploadAttachmentDir+uploadAttachmentFileName;
		//filepath文件要上传的路径
		String filepath = request.getSession().getServletContext().getRealPath(uploadAttachmentDir) ;
		//定义判断上传路径存不存在，不存在就创建。
		File file = new File(filepath);
		if (!file.exists()) {
			file.mkdirs();
		}
		//System.out.println(filepath);
		//注意：此时获得一般的非文件的请求要用MultipartRequest对象。即是用multirequest而不能用request获得。
		//因为用cos,form表单要使用enctype="multipart/form-data"编码,所以取得页面的请求也要用MultipartRequest对象
		//String name = multirequest.getParameter("name");
		//System.out.println("上传人是：" + name);

		//获得所有的文件名,返回的是Enumeration
		Enumeration fileNames = multirequest.getFileNames();
		//System.out.println(fileNames);
		//循环遍历
		String elementName= "CEBFILE";
		while (fileNames.hasMoreElements()) {
			//System.out.println("有附件");
			//通过文件名获得文件（enum.nextElement()获得在服务器上的文件名）。
			elementName=(String)fileNames.nextElement(); 
			//此时获得是一个文件标识，但不是实际文件名，通过这个文件标识通过getFile(name)方法可以返回上传的后的在服务器端的文件，如下。
			File tmpfile=multirequest.getFile(elementName);   
			//System.out.println("老名：" + tmpfile.getName());
			// tmpfile.getName（）返回的是一个带后缀名的文件名
			//newfilename = "new" + tmpfile.getName();
			//System.out.println("新名字:" + newfilename);
			//tmpfile.renameTo(new File(getFileName));
			File f = new File(request.getSession().getServletContext().getRealPath(uploadAttachmentFullFileName));
			if("jsp,do,class,jspx,jar".indexOf(f.getName().substring(f.getName().lastIndexOf(".")+1,f.getName().length()))==-1){
				if(f.exists()) {
					f.delete();
				}
				tmpfile.renameTo(f);
			}
			if(tmpfile.exists()) {
				tmpfile.delete();
			}
			AttachmentManager attachmentManager = new AttachmentManager();
			AttachmentEntity attachmentEntity;
			attachmentEntity = attachmentManager.getAttachmentByUNID(getModuleID,getDocID,getDocType);
			if(attachmentEntity!=null){
				attachmentManager.deleteAttach(getModuleID,getDocID);
			}else{
				attachmentEntity = new AttachmentEntity();
			}
			attachmentEntity.setDocunid(getDocID);
			attachmentEntity.setAttachmentPath(uploadAttachmentFullFileName);
			attachmentEntity.setAttachmentName(getDocTitle+".ceb");
			attachmentEntity.setType(getDocType);
			attachmentEntity.setModuleId(getModuleID);
			attachmentManager.saveAttach(attachmentEntity);
			out.println("success");
		}
		//此时最后一般需要将文件名插入数据库中
		//省略。。。。
	}else if(action!=null&&"download".equals(action)){
		//使用cos下载文件（学要使用cos的ServletUtils类）
		//注意这里的中文显示的要用ISO8859-1,如果用UTF-8的话中文字段长度不能超过17个
		//原因可能是因为ie在处理 Response Header 的时候，对header的长度限制在150字节左右。
		//而一个汉字编码成UTF-8是9个字节，那么17个字便是153个字节，所以便会报错
		//步骤：
		
		//String filePath="";//获得文件路径不带文件名
		//String filename="";//获得单个文件名
		String guessCharset="UTF-8";
		try { 
			String filepath = request.getSession().getServletContext().getRealPath(getFilePath) ;
			response.reset();
			//使用iso8559_1编码方式
			String isofilename = new String(getFilePath.substring(getFilePath.lastIndexOf("/")+1,getFilePath.length()).getBytes(guessCharset),"ISO-8859-1");
			if(getFileName!=null&&!"".equals(getFileName)){
				isofilename = new String(getFileName.getBytes(),"ISO-8859-1");
			}
			response.setContentType("application/octet-stream");
			response.setHeader("Content-Disposition","attachment; filename=" + isofilename);
			ServletOutputStream sos = null;
			sos = response.getOutputStream();
			ServletUtils.returnFile(filepath,sos);//下载文件
		}catch (UnsupportedEncodingException ex) {
			//iso8559_1编码异常
			ex.printStackTrace();
		}catch(IOException e){
			//getOutputStream()异常。
			e.printStackTrace();
		}
		//ServletOutputStream比较PrintWriter：使用PrintWriter会占用一些系统开销，
		//因为它是为处理字符流的输出输出功能。因此PrintWriter应该使用在确保有字符集转换的环境中。
		//换句话说，在你知道servlet返回的仅仅是二进制数据时候，应该使用ServletOutputStream，
		//这样你可以消除字符转换开销，当servlet容器不用处理字符集转换的时候。	
	}
%>