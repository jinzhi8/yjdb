package com.kizsoft.commons.util.stat;

import com.kizsoft.commons.commons.user.User;
import com.kizsoft.commons.commons.util.StringHelper;
import java.io.FileInputStream;
import java.io.InputStream;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.TagSupport;
import org.apache.log4j.Logger;

public class StatTag
  extends TagSupport
{
  final Logger log = Logger.getLogger(getClass().getName());
  private String styleClass;
  private String page;
  private String name;
  private String queryFlag;
  
  public StatTag()
  {
    this.page = "1";
  }
  
  public String getName()
  {
    return this.name;
  }
  
  public void setName(String name)
  {
    this.name = name;
  }
  
  public String getStyleClass()
  {
    return this.styleClass;
  }
  
  public void setStyleClass(String styleClass)
  {
    this.styleClass = styleClass;
  }
  
  public void setPage(String page)
  {
    this.page = page;
  }
  
  public String getPage()
  {
    return this.page;
  }
  
  public int doEndTag()
  {
    try
    {
      HttpServletRequest req = (HttpServletRequest)this.pageContext.getRequest();
      User curuser = (User)this.pageContext.getSession().getAttribute("userInfo");
      if (curuser == null) {
        throw new Exception("没有登陆");
      }
      if (this.name == null) {
        throw new Exception("没有指定统计的定义");
      }
      this.name = ((String)argFormat(this.name));
      String path = this.pageContext.getServletContext().getRealPath("/WEB-INF/config/stat/" + this.name + ".stat.xml");
      InputStream xmlstream = new FileInputStream(path);
      Stat stat = new Stat(xmlstream);
      xmlstream.close();
      String url = req.getRequestURI().toString();
      
      int start = 1;
      String curPage = req.getParameter("page");
      try
      {
        start = Integer.parseInt(curPage);
      }
      catch (Exception ex)
      {
        start = 1;
      }
      StatGenerator generator = new StatGenerator(curuser, stat, start, url, req.getParameterMap(), this.pageContext);
      if (generator != null) {
        this.pageContext.getOut().print(generator.generatorCode());
      } else {
        this.pageContext.getOut().print("无法显示该视图。");
      }
    }
    catch (Exception e)
    {
      e.printStackTrace();
      this.log.info("====view tag false!====");
    }
    return 6;
  }
  
  private Object argFormat(String arg)
    throws Exception
  {
    Object obj = null;
    HttpServletRequest req = (HttpServletRequest)this.pageContext.getRequest();
    if (arg == null) {
      throw new Exception("参数错误！");
    }
    if ((arg.indexOf("{") >= 0) && (arg.indexOf(".") >= 0) && (arg.indexOf("}") >= 0))
    {
      String exp = arg.substring(arg.indexOf("{") + 1, arg.indexOf("}"));
      exp = exp.replace('.', ',');
      String[] args = StringHelper.split(exp, ",");
      if (args.length == 2) {
        if (args[0].equalsIgnoreCase("request")) {
          obj = req.getAttribute(args[1]);
        } else if (args[0].equalsIgnoreCase("pageContext")) {
          obj = this.pageContext.getAttribute(args[1]);
        } else if (args[0].equalsIgnoreCase("session")) {
          obj = req.getSession().getAttribute(args[1]);
        }
      }
    }
    else
    {
      obj = arg;
    }
    if (obj == null) {
      throw new Exception("参数异常!");
    }
    return obj;
  }
}
