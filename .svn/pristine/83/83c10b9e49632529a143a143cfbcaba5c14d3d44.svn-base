package com.kizsoft.commons.commons.tree;

import com.kizsoft.commons.commons.orm.MyDBUtils;
import com.kizsoft.commons.commons.user.User;
import com.kizsoft.commons.commons.util.StringHelper;
import com.kizsoft.commons.uum.pojo.Owner;
import com.kizsoft.commons.uum.service.IUUMService;
import com.kizsoft.commons.uum.utils.UUMContend;
import com.kizsoft.commons.workflow.Activity;
import com.kizsoft.commons.workflow.WorkflowFactory;
import com.kizsoft.commons.workflow.manager.ActivityManager;
import com.kizsoft.oa.personal.PersonalAddressEntity;
import com.kizsoft.oa.personal.PersonalAddressManager;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.XMLWriter;

public class NewUserTreeAction extends Action
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
    try
    {
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
    String rangeList = request.getParameter("range");
    String activId = request.getParameter("activid");
    String rolecode = request.getParameter("rolecode");
    
    HttpSession session = request.getSession();
    User userInfo = (User)session.getAttribute("userInfo");
    if (userInfo == null) {
      return null;
    }
    String userId = userInfo.getUserId();

    Document doc = null;

    if ("2".equals(treetype))
    {
      doc = getDep(parentid, rangeList, activId);
    } else if ("3".equals(treetype))
    {
      doc = getDepAndUser(parentid, rangeList, activId);
    } else if ("5".equals(treetype))
    {
      doc = getPersonalGroup(parentid, rangeList, activId, userId);
    }
    else {
      doc = getUser(parentid, rangeList, activId,userId,rolecode);
    }

    return doc;
  }

  private Document getUser(String parentid, String rangeList, String activId,String userid,String rolecode) {
    Document doc = DocumentHelper.createDocument();
    List list = new ArrayList();

    if ((parentid == null) || ("".equals(parentid)))
    {
      if (((rangeList == null) || ("".equals(rangeList))) && 
        (activId != null) && (!"".equals(activId))) {
        rangeList = getRangelistByActivId(activId);
      }

      if ((rangeList != null) && (!"".equals(rangeList)))
        list = getListByRange(rangeList);
      else
        list = UUMContend.getUUMService().getTopLevel();
    }
    else
    {
      //list = UUMContend.getUUMService().getUserChildByDeptId(parentid);
      List<Owner> listmap=MyDBUtils.queryForList(Owner.class,"select * from owner o where o.id in (select ownerid " +
      		" from ownerrelation ol start with ol.parentid in ('"+parentid+"') connect by prior ol.ownerid = ol.parentid)  " +
      				"and o.flag = 1 and exists (select 1 from ACLUSERROLE d left join aclrole a on d.roleid = a.roleid where  a.rolecode =? and d.userid=o.id) and o.id!='"+userid+"'",rolecode);
      list =listmap;
      //list.addAll(list);
    }
    if (list == null) {
      try {
        throw new Exception("系统错误：请与系统管理员联系！");
      } catch (Exception ex) {
        ex.printStackTrace();
      }
    }
    Element e = doc.addElement("TreeNode");

    for (int i = 0; i < list.size(); i++) {
      Owner owner = (Owner)list.get(i);
      if (owner != null) {
        Element childelement = e.addElement("TreeNode");
        childelement.addAttribute("text", owner.getOwnername());
        childelement.addAttribute("value", owner.getId());
        if (owner.getFlag().equals(UUMContend.USER_FLAG)) {
          childelement.addAttribute("label", owner.getPosition());
        }

        if (!owner.getFlag().equals(UUMContend.USER_FLAG)) {
          childelement.addAttribute("checkbox", "false");
          childelement.addAttribute("src", "userTreeNew.do?utype=1&id=" + owner.getId()+"&rolecode="+rolecode);
        }
        else {
          childelement.addAttribute("checkbox", "true");
        }
      }
    }

    return doc;
  }

  private Document getDep(String parentid, String rangeList, String activId) {
    Document doc = DocumentHelper.createDocument();
    List list = new ArrayList();

    if ((parentid == null) || ("".equals(parentid))) {
      if (((rangeList == null) || ("".equals(rangeList))) && 
        (activId != null) && (!"".equals(activId))) {
        rangeList = getRangelistByActivId(activId);
      }
      if ((rangeList != null) && (!"".equals(rangeList)))
        list = getListByRange(rangeList);
      else {
        list = UUMContend.getUUMService().getTopLevel();
      }
    }
    else
    {
      list = UUMContend.getUUMService().getChildByOwnerId(parentid);
    }
    if (list == null)
      try {
        throw new Exception("系统错误：请与系统管理员联系！");
      }
      catch (Exception localException) {
      }
    Element e = doc.addElement("TreeNode");

    for (int i = 0; i < list.size(); i++) {
      Owner owner = (Owner)list.get(i);
      if ((owner != null) && (!owner.getFlag().equals(UUMContend.USER_FLAG))) {
        Element childelement = e.addElement("TreeNode");
        childelement.addAttribute("text", owner.getOwnername());
        childelement.addAttribute("value", owner.getId());
        if (owner.getFlag().equals(UUMContend.USER_FLAG)) {
          childelement.addAttribute("label", owner.getPosition());
        }

        childelement.addAttribute("checkbox", "true");
        childelement.addAttribute("src", "userTree.do?utype=2&id=" + owner.getId());
      }
    }

    return doc;
  }

  private Document getDepAndUser(String parentid, String rangeList, String activId)
  {
    Document doc = DocumentHelper.createDocument();
    List list = new ArrayList();
    if ((parentid == null) || ("".equals(parentid))) {
      if (((rangeList == null) || ("".equals(rangeList))) && 
        (activId != null) && (!"".equals(activId))) {
        rangeList = getRangelistByActivId(activId);
      }
      if ((rangeList != null) && (!"".equals(rangeList)))
        list = getListByRange(rangeList);
      else {
        list = UUMContend.getUUMService().getTopLevel();
      }

    }
    else
    {
      list = UUMContend.getUUMService().getUserChildByDeptId(parentid);

      list.addAll(UUMContend.getUUMService().getDeptChildByOwnerId(parentid));
    }

    if (list == null)
      try {
        throw new Exception("系统错误：请与系统管理员联系！");
      }
      catch (Exception localException) {
      }
    Element e = doc.addElement("TreeNode");

    for (int i = 0; i < list.size(); i++) {
      Owner owner = (Owner)list.get(i);
      if (owner != null) {
        Element childelement = e.addElement("TreeNode");
        childelement.addAttribute("text", owner.getOwnername());
        childelement.addAttribute("value", owner.getId());
        if (owner.getFlag().equals(UUMContend.USER_FLAG)) {
          childelement.addAttribute("label", owner.getPosition());
        }

        childelement.addAttribute("checkbox", "true");

        if (!owner.getFlag().equals(UUMContend.USER_FLAG)) {
          childelement.addAttribute("src", "userTree.do?utype=3&id=" + owner.getId());
        }
      }

    }

    return doc;
  }

  private Collection getPersonalDeps(String userId) {
    PersonalAddressManager pam = new PersonalAddressManager();
    Collection arrList = pam.getUserPersonalAddressList(userId);

    return arrList;
  }

  private PersonalAddressEntity getPersonalPersonsWithId(String parentid) {
    PersonalAddressEntity entity = null;

    PersonalAddressManager pam = new PersonalAddressManager();
    entity = pam.getUserPersonalAddressByGroupID(parentid);

    return entity;
  }

  private Document getPersonalGroup(String parentid, String rangeList, String activId, String userId)
  {
    Document doc = DocumentHelper.createDocument();
    List list = new ArrayList();
    Element e = doc.addElement("TreeNode");
    if ((rangeList == null) || ("".equals(rangeList)))
    {
      if ((parentid == null) || ("".equals(parentid))) {
        ArrayList arrList = (ArrayList)getPersonalDeps(userId);

        for (int i = 0; i < arrList.size(); i++) {
          PersonalAddressEntity entity = (PersonalAddressEntity)arrList.get(i);
          if (entity != null) {
            Element childelement = e.addElement("TreeNode");
            childelement.addAttribute("text", entity.getGroupName());
            childelement.addAttribute("value", entity.getGroupID());

            childelement.addAttribute("src", "userTree.do?utype=5&id=" + entity.getGroupID());
          }
        }
      }
      else {
        PersonalAddressEntity entity = getPersonalPersonsWithId(parentid);
        String userIDs = entity.getUserIDs();
        String userNames = entity.getUserNames();

        if ((userIDs != null) && (userNames != null)) {
          String[] userIDsArr = userIDs.split(",");
          String[] userNamesArr = userNames.split(",");

          for (int i = 0; i < userIDsArr.length; i++) {
            Element childelement = e.addElement("TreeNode");
            childelement.addAttribute("text", userNamesArr[i]);
            childelement.addAttribute("value", userIDsArr[i]);
            childelement.addAttribute("checkbox", "true");
          }
        }
      }

    }

    return doc;
  }

  public String getRangelistByActivId(String activId)
  {
    String rangeList = null;
    try
    {
      Activity activity = WorkflowFactory.getActivityManager().getActivity(activId);

      if (activity != null) {
        rangeList = activity.getPerformerPurview();

        if ((rangeList == null) || ("".equals(rangeList)) || ("*".equals(rangeList)))
        {
          return null;
        }
        return rangeList;
      }
    }
    catch (Exception ex) {
      ex.printStackTrace();
    }

    return rangeList;
  }

  public List getListByRange(String rangeList) {
    List list = null;
    list = new ArrayList();

    String[] range = StringHelper.split(rangeList, ",");

    for (int i = 0; i < range.length; i++) {
      Owner rangeOwner = UUMContend.getUUMService().getOwnerByOwnerid(range[i]);

      list.add(rangeOwner);
    }

    return list;
  }
}