<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page contentType="text/html; charset=utf-8"%>
 <%
 String saveDirectory ="C:\\workspace\\webapps\\oa\\oa\\attachment\\approval";
 int maxPostSize =3 * 5 * 1024 * 1024 ;
 MultipartRequest multi =new MultipartRequest(request, saveDirectory, maxPostSize,"utf-8");
 
 Enumeration files = multi.getFileNames();
      while (files.hasMoreElements()) {
         System.err.println("ccc");
        String name = (String)files.nextElement();
        File f = multi.getFile(name);
        if(f!=null){
          String fileName = multi.getFilesystemName(name);
          String lastFileName= saveDirectory+"\\" + fileName;
          out.println("上传的文件:"+lastFileName);
          out.println("<hr>");
 
       }
      }
 
%>
 
