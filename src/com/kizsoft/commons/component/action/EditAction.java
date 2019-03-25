package com.kizsoft.commons.component.action;

import com.kizsoft.commons.acl.service.IACLService;
import com.kizsoft.commons.acl.utils.ACLContend;
import com.kizsoft.commons.commons.user.User;
import com.kizsoft.commons.component.dao.BaseDAO;
import com.kizsoft.commons.component.entity.ConfigEntity;
import com.kizsoft.commons.component.entity.FieldEntity;
import com.kizsoft.commons.component.entity.SelectEntity;
import com.kizsoft.commons.util.UUIDGenerator;
import com.kizsoft.commons.workflow.FlowTransmitInfo;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.xml.parsers.ParserConfigurationException;
import org.apache.log4j.Logger;
import org.xml.sax.SAXException;

public class EditAction extends HttpServlet
{
  private static final long serialVersionUID = 1L;
  private ServletConfig config;
  final Logger log = Logger.getLogger(getClass().getName());

  public final void init(ServletConfig config)
    throws ServletException
  {
    this.config = config;
    super.init(config);
  }

  public final ServletConfig getServletConfig()
  {
    return this.config;
  }

  public void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException
  {
    doPost(request, response);
  }

  protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException
  {
    User userInfo = (User)request.getSession().getAttribute("userInfo");
    if (userInfo == null) {
      response.sendRedirect(request.getContextPath() + "/login.jsp");
      return;
    }
    String xmlName;
    if ((String)request.getAttribute("xmlName") != null)
      xmlName = (String)request.getAttribute("xmlName");
    else {
      xmlName = request.getParameter("xmlName");
    }

    String path = this.config.getServletContext().getRealPath("/WEB-INF/config/component/" + xmlName + ".xml");
    InputStream xmlstream = null;
    ConfigEntity configEntity = null;
    try
    {
      xmlstream = new FileInputStream(path);
      String forwardType = getForwardType(request);
      configEntity = new ConfigEntity(xmlstream, forwardType);
    } catch (FileNotFoundException e) {
      this.log.error("模块XML配置文件不存在！");
      this.log.error(e);
    } catch (IOException e) {
      this.log.error(e);
    } catch (SAXException e) {
      this.log.error(e);
    } catch (ParserConfigurationException e) {
      this.log.error(e);
    } finally {
      if (xmlstream != null)
        xmlstream.close();
    }
    String unid;
    if ((String)request.getAttribute(configEntity.getPrimaryKey()) != null) {
      unid = (String)request.getAttribute(configEntity.getPrimaryKey());
    }
    else
    {
      if (request.getParameter(configEntity.getPrimaryKey()) != null) {
        unid = request.getParameter(configEntity.getPrimaryKey());
      }
      else
      {
        if ((String)request.getAttribute("appId") != null)
          unid = (String)request.getAttribute("appId");
        else
          unid = request.getParameter("appId");
      }
    }
    request.setAttribute("uuid", unid);
    request.setAttribute("appId", unid);

    if ((request.getAttribute("flowTransmitInfo") == null) && 
      (unid != null) && 
      (!ACLContend.getACLService().hasPrivilege(userInfo.getUserId(), unid))) {
      response.sendRedirect(request.getContextPath() + "/forbid.jsp");
      return;
    }

    ArrayList arrList = new ArrayList();
    ArrayList selects = new ArrayList();
    BaseDAO dao = new BaseDAO();
    if (unid == null) {
      arrList = configEntity.getFieldEntities();
      request.setAttribute("xmlType", "insert");
    } else {
      arrList = dao.getAppByUnid(configEntity, unid);
      if ("receive".equals(request.getParameter("type")))
        request.setAttribute("xmlType", "insert");
      else if ((arrList != null) && (arrList.size() > 0))
        request.setAttribute("xmlType", "update");
      else {
        request.setAttribute("xmlType", "insert");
      }
    }
    if (arrList != null) {
      for (int i = 0; i < arrList.size(); i++) {
        FieldEntity fieldEntity = new FieldEntity();
        fieldEntity = (FieldEntity)arrList.get(i);
        request.setAttribute(fieldEntity.getFormField(), fieldEntity);
      }

    }

    selects = dao.selectOptions(configEntity, userInfo.getUserId());
    if (selects != null) {
      for (int i = 0; i < selects.size(); i++) {
        SelectEntity selectEntity = new SelectEntity();
        selectEntity = (SelectEntity)selects.get(i);
        request.setAttribute(selectEntity.getName(), selectEntity.getValueLabelEntities());
      }
    }

    request.getSession().setAttribute("org.apache.struts.action.TOKEN", UUIDGenerator.getUUID());

    ServletContext sc = getServletContext();
    RequestDispatcher rd = null;
    rd = sc.getRequestDispatcher(configEntity.getJspName());
    rd.forward(request, response);
  }

  private String getForwardType(HttpServletRequest request) {
    String type = null;
    if ("receive".equals(request.getParameter("type"))) {
      type = "receive";
    } else {
      type = "edit";

      FlowTransmitInfo flowTransmitInfo = (FlowTransmitInfo)request.getAttribute("flowTransmitInfo");
      if (flowTransmitInfo != null)
      {
        if ((flowTransmitInfo.getInstanceID() != null) && (!"".equals(flowTransmitInfo.getInstanceID())))
          type = "view";
        else {
          type = "edit";
        }
      }
    }
    return type;
  }
}