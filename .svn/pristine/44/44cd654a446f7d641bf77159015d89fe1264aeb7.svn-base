package com.kizsoft.commons.commons.tree;

import com.kizsoft.commons.acl.pojo.Aclrole;
import com.kizsoft.commons.acl.pojo.Acluser;
import com.kizsoft.commons.acl.service.IACLService;
import com.kizsoft.commons.acl.utils.ACLContend;
import com.kizsoft.commons.uum.pojo.Owner;
import com.kizsoft.commons.uum.service.IUUMService;
import com.kizsoft.commons.uum.utils.UUMContend;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.XMLWriter;

public class RoleTreeAction extends Action
{
  public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)
    throws IOException, ServletException
  {
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

  private Document getTree(HttpServletRequest request, HttpServletResponse response)
    throws IOException, ServletException
  {
    String parentid = request.getParameter("id");
    String treetype = request.getParameter("utype");
    List list = new ArrayList();
    if ((parentid == null) || (parentid.equals(""))) {
      list = ACLContend.getACLService().getRoleByAppId("weboa");
    }
    else
    {
      list = ACLContend.getACLService().getRoleByAppId("weboa");
    }if (list == null);
    Document doc;
    try {
      throw new Exception("系统错误：请与系统管理员联系！");
    }
    catch (Exception ex)
    {
      doc = DocumentHelper.createDocument();

      Element e = doc.addElement("TreeNode");

      for (int i = 0; i < list.size(); ++i) {
        Aclrole aclRole = (Aclrole)list.get(i);
        Element childelement = e.addElement("TreeNode");
        childelement.addAttribute("text", aclRole.getRolename());
        childelement.addAttribute("checkbox", "true");
        childelement.addAttribute("value", aclRole.getRoleid());
        childelement.addAttribute("src", "");
        if(!"0".equals(treetype)){
	        List userlist = ACLContend.getACLService().getOwnerByRoleid(aclRole.getRoleid());
	        for (int j = 0; j < userlist.size(); ++j) {
	          Acluser user = (Acluser)userlist.get(j);
	          Element childUserElement = childelement.addElement("TreeNode");
	          childUserElement.addAttribute("text", user.getTruename());
	          childUserElement.addAttribute("checkbox", "true");
	          childUserElement.addAttribute("value", user.getUserid());
	          childUserElement.addAttribute("label", UUMContend.getUUMService().getOwnerByOwnerid(user.getUserid()).getPosition());
	        }
        }
      }
    }
    return doc;
  }
}