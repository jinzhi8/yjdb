<%@page contentType="text/html;charset=UTF-8" %>

<%try {
	String filePath = request.getParameter("filePath");
	if (filePath.substring(filePath.lastIndexOf("/") + 1, filePath.length()).equals("__$$DocumentFileInJMW$$__.doc")) {
		filePath = config.getServletContext().getRealPath(filePath);
	} else {
		filePath = config.getServletContext().getRealPath(filePath) + java.io.File.separator + "__$$DocumentFileInJMW$$__.doc";
	}
	java.io.File tFile = new java.io.File(filePath);
	if (!tFile.exists()) //如果文件不存在，返回一个说明文档
	{
		out.println("<script language=\"javascript\" >alert(\"文件不存在！\")</script>");
		return;
	}
	if (!tFile.exists()) //如果错误说明文件不存在，返回一个字符串
	{
		out.println("请求的文件不存在，且错误文件error_nofile.doc不存在。");
		return;
	}
	response.reset();
	response.setContentType("application/octet-stream");
	response.setHeader("Content-Disposition", "attachment; filename=" + "__$$DocumentFileInJMW$$__.doc");
	java.io.InputStream inStream = new java.io.FileInputStream(tFile);
	byte[] buf = new byte[10240];
	int bytes = 0;
	java.io.OutputStream outStream = response.getOutputStream();
	while ((bytes = inStream.read(buf)) != -1) outStream.write(buf, 0, bytes);
	inStream.close();
	outStream.close();

	response.flushBuffer();
} catch (Throwable e) {
	System.out.println(e.toString());
	throw new ServletException(e.toString());
}%><!--索思奇智版权所有-->