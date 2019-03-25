<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.commons.config.SystemConfig" %>
<%@page import="com.kizsoft.commons.commons.db.ConnectionProvider"%>
<%@page import="java.sql.*"%>

<%!
		public String getPDFPathByAttrId(String Attrid){
					Connection db=null;
					PreparedStatement stat = null;
					ResultSet rs=null;
					String sql="";
					String filepath="";
					try{
						db = ConnectionProvider.getConnection();//建立数据库连接
						sql="select attachmentpath from common_attachment where attachmentid=?";
						stat = db.prepareStatement(sql);
						stat.setString(1,Attrid);
						rs=stat.executeQuery();
						if(rs.next()){
							filepath=rs.getString("attachmentpath");
						}
						return filepath;
					}catch(Exception e){
					
					}finally{
						ConnectionProvider.close(db,stat,rs);
					}
					return filepath;
		}
		
%>
<%
		String pdfid=request.getParameter("uuid");
		
		//out.print("pdfid:"+pdfid);
		
		String filePath=getPDFPathByAttrId(pdfid);
		
		//out.print("filePath:"+filePath);
		filePath=request.getContextPath()+"/"+filePath;
%>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>PDF WEB 查看器</title>
	<script src="<%=request.getContextPath()%>/resources/js/jquery/jquery-1.7.2.js"></script>
	<script src="<%=request.getContextPath()%>/resources/js/jquery/jquery.media.js"></script>
	
	
	
	<SCRIPT LANGUAGE="JavaScript">
		$(function(){
			
			$('a.media').media({ width: '100%', height: 800 }); 
		});
    </script>
	
	
	
</head>
<body>
		<a class="media" id="PDFFile" href="<%=filePath%>"></a>

</body>
</html>
