<%@page contentType="text/html;charset=UTF-8" %>
<%@page language="java" import="com.kizsoft.commons.commons.attachment.FileUploadHelper" %>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload"/>
<% String filename = "__$$DocumentFileInJMW$$__.doc";
	String title;
	int filesize;
	String contenttype;
	// Initialization
	mySmartUpload.initialize(pageContext);
	String realPath = config.getServletContext().getRealPath("") + java.io.File.separator;
	// Upload
	mySmartUpload.upload();
	String filepath = mySmartUpload.getRequest().getParameter("attach_path");
	filepath = realPath + filepath;
	com.jspsmart.upload.File myFile = null;

	for (int i = 0; i < mySmartUpload.getFiles().getCount(); i++) {
		myFile = mySmartUpload.getFiles().getFile(i);
		//处理数据及文件
		if (!myFile.isMissing()) {
			filesize = myFile.getSize();
			if (myFile.getFieldName().equalsIgnoreCase("File1"))
			//说明是正文文件，因为default.jsp中，调用SaveToURL函数时，第2个参数为"FILE1"
			{
				contenttype = myFile.getContentType();

				try {

					byte bin[] = new byte[filesize];
					for (int j = 0; j < filesize; j++)
						bin[j] = myFile.getBinaryData(j);
					FileUploadHelper.uploadFileAttach(bin, filepath, myFile.getFileName());
				} catch (Exception e) {
					out.println("发生错误: " + e.toString());
				}
			} else //附件文件
			{
				try {
					byte bin[] = new byte[filesize];
					for (int j = 0; j < filesize; j++)
						bin[j] = myFile.getBinaryData(j);
					System.out.println("ntkoocx upload file path is " + FileUploadHelper.uploadFileAttach(bin, filepath, myFile.getFileName()));
				} catch (Exception e) {
					out.println("发生错误: " + e.toString());
				}
			}
		} else {
			System.out.println("the file is missing! ");
		}
	}// end for 	%>

		
<!--索思奇智版权所有-->