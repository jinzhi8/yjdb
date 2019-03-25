package com.kizsoft.commons.commons.attachment;

import com.kizsoft.commons.commons.util.StringHelper;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.log4j.Logger;

public class DownloadAttach extends HttpServlet
{
  private static final long serialVersionUID = 1L;
  final Logger log = Logger.getLogger(super.getClass().getName());
  private ServletConfig config;

  public final void init(ServletConfig servletconfig)
    throws ServletException
  {
  }

  public final ServletConfig getServletConfig()
  {
    return this.config;
  }

  public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
  {
    String attachmentID = request.getParameter("uuid");
    String type = request.getParameter("type");
    AttachmentEntity entity = new AttachmentEntity();
    AttachmentManager attachmentManager = new AttachmentManager();
    entity = attachmentManager.getAttachmentByUNID(attachmentID);
    if (entity != null) {
      String attachmentPath = entity.getAttachmentPath();
      String attachmentName = entity.getAttachmentName();
      if(attachmentPath!=null){
    	  attachmentPath = attachmentPath.replace("\\", "/");
      }
      String path=request.getSession().getServletContext().getRealPath(attachmentPath);
      File file=new File(path);
      System.out.println("get:"+file.exists());
      if(file.exists()){
    	  if (StringHelper.isNull(type))
	        try {
	          downFile(path, attachmentName, request, response);
	        }
	        catch (Exception e) {
	          e.printStackTrace();
	        }
	      else
	        response.sendRedirect(request.getContextPath() + attachmentPath); 
      }else{
            response.reset();
            response.setCharacterEncoding("utf-8");
            response.setContentType("text/html");
            response.getWriter().print("文件传输中，请稍候!");
      }
      
    }
    else
    {
		response.reset();
	    response.setCharacterEncoding("utf-8");
	    response.setContentType("text/html");
	    response.getWriter().print("文件不存在!");
    }
  }

  public String trimEnter(String source) {
    source = source.substring(0, source.length() - 2);
    return source;
  }

  protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException
  {
    String attachmentID = (String)request.getAttribute("uuid");
    AttachmentEntity entity = new AttachmentEntity();
    AttachmentManager attachmentManager = new AttachmentManager();
    entity = attachmentManager.getAttachmentByUNID(attachmentID);
    if (entity != null) {
      String attachmentPath = entity.getAttachmentPath();
      String attachmentName = entity.getAttachmentName();
      String path=request.getSession().getServletContext().getRealPath(attachmentPath);
      File file=new File(path);
      System.out.println("post:"+file.exists());
      if(file.exists()){
    	  try {
	        downFile(path, attachmentName, request, response);
	      }
	      catch (Exception e) {
	        e.printStackTrace();
	      }
      }else{
    	  response.reset();
          response.setCharacterEncoding("utf-8");
          response.setContentType("text/html");
          response.getWriter().print("文件传输中，请稍候!!!");
      }
    } else {
    	response.reset();
	    response.setCharacterEncoding("utf-8");
	    response.setContentType("text/html");
	    response.getWriter().print("文件不存在!!!");
    }
  }

  public void downFile(String filepath, String filename, HttpServletRequest request, HttpServletResponse res) throws Exception {
    int w = 0;
    byte[] buffer = new byte[1024];

    String regEx = "[/\\?:*\"<>|•`~!@#+=]";
    Pattern p = Pattern.compile(regEx);
    Matcher m = p.matcher(filename);
    filename = m.replaceAll("").trim();
    filename = StringHelper.replaceAll(filename, "&#8226;", "");
    if (request.getHeader("User-Agent").toUpperCase().indexOf("MSIE") > 0)
    {
      if (System.getProperty("os.name").toLowerCase().indexOf("linux") > -1)
        filename = new String(filename.getBytes("GBK"), "ISO8859-1");
      else {
        filename = new String(filename.getBytes(System.getProperty("file.encoding")), "ISO8859-1");
      }
    }
    else if (request.getHeader("User-Agent").toLowerCase().indexOf("firefox") > 0) {
      filename = new String(filename.getBytes("UTF-8"), "ISO8859-1");
    }
    else {
      filename = new String(filename.getBytes("UTF-8"), "ISO8859-1");
    }

    res.reset();
    res.setContentType("bin");
    res.setHeader("Content-disposition", "attachment;filename=\"" + filename + "\"");
    File file = new File(filepath);
    res.setHeader("Content-Length", String.valueOf(file.length()));
    ServletOutputStream sos = res.getOutputStream();
    BufferedInputStream bis = null;
    try {
      bis = new BufferedInputStream(new FileInputStream(filepath));
      while ((w = bis.read(buffer, 0, buffer.length)) != -1) {
        sos.write(buffer, 0, w);
      }
      sos.flush();
      res.flushBuffer();
    } catch (FileNotFoundException ex) {
      res.reset();
      res.setCharacterEncoding("utf-8");
      res.setContentType("text/html");
      sos.write("文件不存在!".getBytes());
    } catch (Exception ex) {
    }
    finally {
      try {
        if (bis != null) {
          bis.close();
        }
        if (sos != null)
          sos.close();
      }
      catch (Exception ex)
      {
      }
    }
  }

  public void destroy()
  {
  }
}