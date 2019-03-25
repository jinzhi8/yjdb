package com.kizsoft.commons.util.view;

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

public class ViewTag extends TagSupport
{
  final Logger log = Logger.getLogger(super.getClass().getName());
  private String page;
  private String format;
  private String desktop;

  public String getDesktop()
  {
    return this.desktop;
  }

  public void setDesktop(String desktop) {
    this.desktop = desktop;
  }

  public ViewTag() {
    this.page = "1";
    this.desktop = "0";
  }

  public void setFormat(String format) {
    this.format = format;
  }

  public String getFormat() {
    return this.format;
  }

  public void setPage(String page) {
    this.page = page;
  }

  public String getPage() {
    return this.page;
  }

  public int doEndTag() {
    try {
      HttpServletRequest req = (HttpServletRequest)this.pageContext
        .getRequest();
      User curuser = (User)this.pageContext.getSession().getAttribute(
        "userInfo");
      if (curuser == null)
        throw new Exception("没有登陆");
      if (this.format == null)
        throw new Exception("没有指定视图的定义");
      this.format = ((String)argFormat(this.format));
      String path = this.pageContext.getServletContext().getRealPath(
        "/WEB-INF/config/view/" + this.format + ".view.xml");
      InputStream xmlstream = new FileInputStream(path);
      ViewDefine define = new ViewDefine(xmlstream);
      xmlstream.close();
      String url = req.getRequestURI().toString();

      int start = 1;
      Object pagevar = argFormat(this.page);
      if ((req.getParameter("page") != null) && (!"".equals(req.getParameter("page")))) {
        start = Integer.parseInt(req.getParameter("page"));
      }
      else if (pagevar != null) {
        start = Integer.parseInt(pagevar.toString());
      }

      String isdesktop = "0";
      Object desktopvar = argFormat(this.desktop);
      if ((req.getParameter("desktop") != null) && (!"".equals(req.getParameter("desktop")))) {
        isdesktop = req.getParameter("desktop").toString();
      }
      else if (desktopvar != null) {
        isdesktop = desktopvar.toString();
      }

      CommonViewGenerator generator = new CommonViewGenerator(curuser, 
        define, start, url, isdesktop, req.getParameterMap(), this.pageContext);
      if (generator != null)
        this.pageContext.getOut().print(generator.generatorCode());
      else
        this.pageContext.getOut().print("无法显示该视图。");
    }
    catch (Exception e) {
      e.printStackTrace();
      this.log.info("====view tag false!====");
    }
    return 6;
  }

  private Object argFormat(String arg) throws Exception {
    Object obj = null;
    HttpServletRequest req = (HttpServletRequest)this.pageContext.getRequest();
    if (arg == null)
      throw new Exception("参数错误！");
    if ((arg.indexOf("{") >= 0) && (arg.indexOf(".") >= 0) && 
      (arg.indexOf("}") >= 0)) {
      String exp = arg.substring(arg.indexOf("{") + 1, arg.indexOf("}"));
      exp = exp.replace('.', ',');
      String[] args = StringHelper.split(exp, ",");
      if (args.length == 2)
        if (args[0].equalsIgnoreCase("request"))
          obj = req.getAttribute(args[1]);
        else if (args[0].equalsIgnoreCase("pageContext"))
          obj = this.pageContext.getAttribute(args[1]);
        else if (args[0].equalsIgnoreCase("session"))
          obj = req.getSession().getAttribute(args[1]);
    }
    else {
      obj = arg;
    }
    if (obj == null) {
      throw new Exception("参数异常!");
    }
    return obj;
  }
}