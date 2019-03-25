package com.kizsoft.commons.uum.actions;

import com.kizsoft.commons.uum.Visit;
import com.kizsoft.commons.uum.pojo.Owner;
import com.kizsoft.commons.uum.service.IUUMService;
import com.kizsoft.commons.uum.utils.UUMConf;
import com.kizsoft.commons.uum.utils.UUMContend;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.XMLWriter;

public class TreeAction extends BaseAction
{
  public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)
    throws IOException, ServletException
  {
    String action = request.getParameter("action");
    if (action == null) {
      Document doc = getTree(request, response);
      OutputFormat format = OutputFormat.createPrettyPrint();
      format.setEncoding("UTF-8");
      format.setSuppressDeclaration(true);
      response.setContentType("text/xml");
      response.setCharacterEncoding("UTF-8");
      try {
        XMLWriter xmlWriter = new XMLWriter(response.getOutputStream(), format);
        xmlWriter.write(doc);
        xmlWriter.close();
      } catch (Exception e) {
        e.printStackTrace();
      }
      return null;
    }
    if (action.equals("newdept")) {
      List list = getUUMService().getWholeRole();
      request.setAttribute("list", list);
      return mapping.findForward("newdept");
    }
    if (action.equals("rmnode")) {
      if (deleteNode(request, response)) {
        return mapping.findForward("tree");
      }
      return mapping.findForward("failure");
    }if (action.equals("getUserChild")) {
      getUserChild(request);
      return mapping.findForward("child");
    }
    if (action.equals("upnode")) {
      String id = request.getParameter("id");
      String parentid = request.getParameter("parentid");
      upnode(id, parentid);
      return null;
    }
    if (action.equals("downnode")) {
      String id = request.getParameter("id");
      String parentid = request.getParameter("parentid");
      downnode(id, parentid);
      return null;
    }
    return null;
  }

  private boolean deleteNode(HttpServletRequest request, HttpServletResponse response)
  {
    String ids = request.getParameter("ids");
    List list = new ArrayList();
    String id;
    for (StringTokenizer deptToken = new StringTokenizer(ids, ","); deptToken.hasMoreElements(); list.add(id)) {
      id = (String)deptToken.nextElement();
    }
    return getUUMService().deleteOwnerByIds(list);
  }

  private Document getTree(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException
  {
    Document doc = DocumentHelper.createDocument();
    Visit visit = (Visit)request.getSession().getAttribute("visit");
    String userid = visit.getOwner().getId();
    String parentid = request.getParameter("id");
    List list = new ArrayList();
    if ((parentid == null) || (parentid.equals("")))
      list = getUUMService().getTopTreeByUserId(userid);
    else
      list = getUUMService().getDeptChildByOwnerId(parentid);
    if (list == null) {
      try {
        throw new Exception("系统错误：请与系统管理员联系！");
      } catch (Exception exception) {
        exception.printStackTrace();
      }
    }
    Element e = doc.addElement("TreeNode");
    for (int i = 0; i < list.size(); i++) {
      Owner owner = (Owner)list.get(i);
      Element childelement = e.addElement("TreeNode");
      childelement.addAttribute("text", owner.getOwnername());
      childelement.addAttribute("checkbox", "true");
      childelement.addAttribute("value", owner.getId());
      childelement.addAttribute("action", "javascript:showNode('" + owner.getId() + "')");
      if (!owner.getFlag().equals(UUMContend.USER_FLAG)) {
        childelement.addAttribute("src", "tree.do?id=" + owner.getId());
      }

    }

    return doc;
  }

  public void getUserChild(HttpServletRequest request) {
    String strpageno = request.getParameter("currentpage");
    if (strpageno == null)
      strpageno = "1";
    Pagination pagination = new Pagination();
    int rowperpage = UUMConf.getInt("uum.rowperpage", 10);
    pagination.setCurrentpage(strpageno);
    pagination.setRows(rowperpage);
    String deptid = request.getParameter("id");
    Owner currentowner = getUUMService().getOwnerByOwnerid(deptid);
    pagination.setList(getUUMService().getUserChildByDeptId(deptid, pagination.getRows(), pagination.getCurrentpage()));
    Integer Intsumpage = getUUMService().getChildUserRowCount(deptid);
    pagination.setSumrecords(getUUMService().getChildUserRowCount(deptid).intValue());
    request.setAttribute("pagination", pagination);
    request.setAttribute("currentowner", currentowner);
  }

  public void upnode(String id, String parentid) {
    getUUMService().upNode(id, parentid);
  }

  public void downnode(String id, String parentid) {
    getUUMService().downNode(id, parentid);
  }
}