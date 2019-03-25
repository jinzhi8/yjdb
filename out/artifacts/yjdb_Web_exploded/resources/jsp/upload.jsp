<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.oreilly.servlet.MultipartRequest" %>
<%@page import="com.oreilly.servlet.multipart.RandomFileRenamePolicy" %>
<%@page import="java.io.File" %>
<%@page import="java.util.Enumeration" %>
<%
	if (session.getAttribute("userInfo") == null) {
		return;
	}
	
		String filepath = request.getSession().getServleString tmpfilepath = request.getSession().getServletContext().getRealPath("/attachment");
	int inmaxPostSize = 100 * 1024 * 1024;
	MultipartRequest multirequest = null;
	try {
		RandomFileRenamePolicy rfrp = new RandomFileRenamePolicy();
		multirequest = new MultipartRequest(request, tmpfilepath, inmaxPostSize, "UTF-8", rfrp);
	} catch (Exception e) {
		e.printStackTrace();
	}
	String action = request.getParameter("action") == null ? multirequest.getParameter("action") : request.getParameter("action");
	String getFilePath = request.getParameter("filepath") == null ? multirequest.getParameter("filepath") : request.getParameter("filepath");
	String getFileName = request.getParameter("filename") == null ? multirequest.getParameter("filename") : request.getParameter("filename");
	if (action != null && "upload".equals(action)) {tContext().getRealPath(getFilePath);
		File file = new File(filepath);
		if (!file.exists()) {
			file.mkdirs();
		}
		Enumeration fileNames = multirequest.getFileNames();
		String elementName = "";
		while (fileNames.hasMoreElements()) {
			elementName = (String) fileNames.nextElement();
			File tmpfile = multirequest.getFile(elementName);
			File f = new File(filepath, getFileName);
			if ("jsp,do,class,jspx,jar".indexOf(f.getName().substring(f.getName().lastIndexOf(".") + 1, f.getName().length())) == -1) {
				if (f.exists()) {
					f.delete();
				}
				tmpfile.renameTo(f);
			}
			if (tmpfile.exists()) {
				tmpfile.delete();
			}
			out.print("true");
		}
	}
%>