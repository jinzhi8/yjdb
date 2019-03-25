package com.kizsoft.commons.uum.actions;

import com.kizsoft.commons.acl.actions.SelectBean;
import com.kizsoft.commons.acl.pojo.Aclrole;
import com.kizsoft.commons.acl.service.IACLService;
import com.kizsoft.commons.acl.utils.ACLContend;
import com.kizsoft.commons.uum.Visit;
import com.kizsoft.commons.uum.pojo.Owner;
import com.kizsoft.commons.uum.pojo.Role;
import com.kizsoft.commons.uum.service.IUUMService;
import com.kizsoft.commons.uum.utils.UUMConf;
import com.kizsoft.commons.uum.utils.UUMContend;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

public class userAction extends BaseAction
{
  public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)
    throws IOException, ServletException
  {
    UserFormBean userbean = (UserFormBean)form;
    String action = request.getParameter("action");
    String oid = request.getParameter("oid");
    Owner owner = null;
    if (oid != null) {
      owner = getUUMService().getOwnerByOwnerid(oid);
      request.setAttribute("ownerid", owner.getId());
      request.setAttribute("ownername", owner.getOwnername());
    }
    if (action.equals("addnew")) {
      List alist = ACLContend.getACLService().getWholeRole();
      List rlist = getUUMService().getOtherRoleListByDeptId(oid);
      request.setAttribute("alist", alist);
      request.setAttribute("rlist", rlist);
      return mapping.findForward("addnew");
    }
    if (action.equals("edit")) {
      String parentid = request.getParameter("parentid");
      List alist = ACLContend.getACLService().getWholeRole();
      List rlist = getUUMService().getOtherRoleListByDeptId(parentid);
      if (oid != null)
        userbean.load(owner);
      List alist2 = ACLContend.getACLService().getRoleByOwnerId(owner.getId());
      List rlist2 = getUUMService().getRoleListByOwnerId(owner.getId());
      List tlist = getUUMService().getManagedDept(oid);
      userbean.setSelRole(getSelect(rlist, rlist2));
      userbean.setSelAclrole(getACLSelect(alist, alist2));
      userbean.setManagedept(tlist);
      request.setAttribute("alist2", alist2);
      request.setAttribute("rlist2", rlist2);
      request.setAttribute("alist", alist);
      request.setAttribute("rlist", rlist);
      request.setAttribute("edit", "edit");
      return mapping.findForward("edit");
    }
    if (action.equals("saveuser")) {
      String msg = userbean.preValidate();
      if (msg != null) {
        request.setAttribute("message", msg);
        return mapping.findForward("error");
      }
      if (saveUser(request, form, "addnew")) {
        request.setAttribute("reloadParentNode", "true");
        return mapping.findForward("success");
      }
      request.setAttribute("message", "对不起，该登录名已经存在，请重新输入.");
      return mapping.findForward("error");
    }

    if (action.equals("moduser")) {
      String msg = userbean.preValidate();
      if (msg != null) {
        request.setAttribute("message", msg);
        return mapping.findForward("error");
      }
      Owner chkOwner = getUUMService().getOwnerByOwnercode(((UserFormBean)form).getOwnercode());
      if ((chkOwner != null) && (!((UserFormBean)form).getId().equals(chkOwner.getId()))) {
        request.setAttribute("message", "对不起，该登录名已经存在，请重新输入.");
        return mapping.findForward("error");
      }
      if (saveUser(request, form, "mod")) {
        request.setAttribute("reloadParentNode", "true");
        return mapping.findForward("success");
      }
      request.setAttribute("message", "数据修改发生意外，请检查输入的数据.");
      return mapping.findForward("error");
    }

    if (action.equals("deleteUser")) {
      deleteUser(request);
      String deptid = request.getParameter("parentid");
      Owner currentowner = getUUMService().getOwnerByOwnerid(deptid);
      Pagination pagination = getPageInfo(request);
      request.setAttribute("pagination", pagination);
      request.setAttribute("currentowner", currentowner);
      return mapping.findForward("userlist");
    }
    if (action.equals("initpassword")) {
      String deptid = request.getParameter("parentid");
      Owner currentowner = getUUMService().getOwnerByOwnerid(deptid);
      List userlist = getUUMService().getUserChildByDeptId(deptid);
      initpassword(request);
      request.setAttribute("currentowner", currentowner);
      request.setAttribute("userlist", userlist);
      return mapping.findForward("userlist");
    }
    if (action.equals("swap")) {
      String deptid = request.getParameter("parentid");
      Owner currentowner = getUUMService().getOwnerByOwnerid(deptid);
      swap(request);
      List userlist = getUUMService().getUserChildByDeptId(deptid);
      request.setAttribute("currentowner", currentowner);
      request.setAttribute("userlist", userlist);
      return mapping.findForward("userlist");
    }
    if (action.equals("query")) {
        String ownercode = (request.getParameter("ownercode") == null) ? "" : request.getParameter("ownercode");
        String ownername = (request.getParameter("ownername") == null) ? "" : request.getParameter("ownername");
        String depid = (request.getParameter("depid") == null) ? "" : request.getParameter("depid");
        String position = (request.getParameter("position") == null) ? "" : request.getParameter("position");
        String mobile = (request.getParameter("mobile") == null) ? "" : request.getParameter("mobile");
        String mobileshort = (request.getParameter("mobileshort") == null) ? "" : request.getParameter("mobileshort");
        String phone = (request.getParameter("phone") == null) ? "" : request.getParameter("phone");
        request.setAttribute("ownercode", ownercode);
        request.setAttribute("ownername", ownername);
        request.setAttribute("depid", depid);
        request.setAttribute("position", position);
        request.setAttribute("mobile", mobile);
        request.setAttribute("mobileshort", mobileshort);
        request.setAttribute("phone", phone);
        return mapping.findForward("query");
    }
    if (action.equals("import")) {
      getImport(request);
      return mapping.findForward("import");
    }
    if (action.equals("saveimport")) {
      if (saveimport(request)) {
        return mapping.findForward("success");
      }
      request.setAttribute("message", "没有调入信息被保存");
      return mapping.findForward("error");
    }
    if (action.equals("disableaccount")) {
      String userid = request.getParameter("id");
      Owner user = getUUMService().getOwnerByOwnerid(userid);
      user.setStatus(new Integer("0"));
      getUUMService().updateOwner(user);
      String deptid = request.getParameter("parentid");
      Owner currentowner = getUUMService().getOwnerByOwnerid(deptid);
      Pagination pagination = getPageInfo(request);
      request.setAttribute("currentowner", currentowner);
      request.setAttribute("pagination", pagination);
      return mapping.findForward("userlist");
    }
    if (action.equals("ableaccount")) {
      String userid = request.getParameter("id");
      Owner user = getUUMService().getOwnerByOwnerid(userid);
      user.setStatus(new Integer("１"));
      getUUMService().updateOwner(user);
      String deptid = request.getParameter("parentid");
      Owner currentowner = getUUMService().getOwnerByOwnerid(deptid);
      Pagination pagination = getPageInfo(request);
      request.setAttribute("currentowner", currentowner);
      request.setAttribute("pagination", pagination);
      return mapping.findForward("userlist");
    }
    if (action.equals("page")) {
      Pagination pagination = getPageInfo(request);
      String deptid = request.getParameter("parentid");
      Owner currentowner = getUUMService().getOwnerByOwnerid(deptid);
      request.setAttribute("pagination", pagination);
      request.setAttribute("currentowner", currentowner);
      return mapping.findForward("userlist");
    }
    if (action.equals("upnode")) {
      String id = request.getParameter("id");
      String parentid = request.getParameter("parentid");
      getUUMService().upNode(id, parentid);
      Pagination pagination = getPageInfo(request);
      String deptid = request.getParameter("parentid");
      Owner currentowner = getUUMService().getOwnerByOwnerid(deptid);
      request.setAttribute("pagination", pagination);
      request.setAttribute("currentowner", currentowner);
      return mapping.findForward("userlist");
    }
    if (action.equals("downnode")) {
      String id = request.getParameter("id");
      String parentid = request.getParameter("parentid");
      getUUMService().downNode(id, parentid);
      Pagination pagination = getPageInfo(request);
      String deptid = request.getParameter("parentid");
      Owner currentowner = getUUMService().getOwnerByOwnerid(deptid);
      request.setAttribute("pagination", pagination);
      request.setAttribute("currentowner", currentowner);
      return mapping.findForward("userlist");
    }
    request.setAttribute("message", "你没有访问权限.");
    return mapping.findForward("error");
  }

  public boolean deleteUser(HttpServletRequest request)
  {
    String[] ids = request.getParameterValues("chkid");
    List list = new ArrayList();
    for (int i = 0; i < ids.length; ++i) {
      list.add(ids[i]);
    }
    getUUMService().deleteOwnerByIds(list);
    return true;
  }

  public boolean saveUser(HttpServletRequest request, ActionForm form, String type) {
    UserFormBean userbean = (UserFormBean)form;
    String parentid = userbean.getParentid();
    if (type.equals("addnew")) {
      boolean existflag = getUUMService().isExistOwner(userbean.getOwnercode(), UUMContend.USER_FLAG.toString());
      if (existflag)
        return false;
    }
    Owner owner = new Owner();
    owner.setOwnercode(userbean.getOwnercode());
    owner.setOwnername(userbean.getOwnername());
    owner.setPassword(userbean.getPassword());
    owner.setFlag(UUMContend.USER_FLAG);
    owner.setDescription(userbean.getDescription());
    owner.setSex(new Integer(userbean.getSex()));
    SimpleDateFormat sdate = new SimpleDateFormat("yyyy-mm-dd");
    try {
      if ((userbean.getBirthday() != null) && (!"".equals(userbean.getBirthday())))
        owner.setBirthday(sdate.parse(userbean.getBirthday()));
      else
        owner.setBirthday(null);
    }
    catch (ParseException parseexception) {
      parseexception.printStackTrace();
    }
    owner.setType(new Integer(userbean.getType()));
    owner.setPhone(userbean.getPhone());
    owner.setHomephone(userbean.getHomephone());
    owner.setFaxno(userbean.getFaxno());
    owner.setEmail(userbean.getEmail());
    owner.setCardno(userbean.getCardno());
    owner.setAddress(userbean.getAddress());
    owner.setMobile(userbean.getMobile());
    owner.setMobileshort(userbean.getMobileshort());
    owner.setPhoneshort(userbean.getPhoneshort());
    owner.setHomephoneshort(userbean.getHomephoneshort());
    owner.setHomefax(userbean.getHomefax());
    owner.setHomeemail(userbean.getHomeemail());
    owner.setHomeaddress(userbean.getHomeaddress());
    owner.setMac(userbean.getMac());
    owner.setIp(userbean.getIp());
    owner.setProcessflag(userbean.getProcessflag());
    owner.setStatflag(userbean.getStatflag());
    owner.setPosition(userbean.getPosition());
    owner.setStatus(new Integer("1"));
    if (type.equals("addnew")) {
      getUUMService().newOwner(owner);
      Owner childOwner = getUUMService().getOwnerByOwnercode(userbean.getOwnercode());
      getUUMService().newRelation(parentid, childOwner.getId());
    } else if (type.equals("mod")) {
      owner.setId(userbean.getId());
      getUUMService().updateOwner(owner);
    }
    saveAclrole(request, form);
    saveRole(request, form);
    savemanageddept(request, form);
    return true;
  }

  private boolean saveAclrole(HttpServletRequest request, ActionForm form) {
    UserFormBean userbean = (UserFormBean)form;
    String[] aclrole = userbean.getFinAclrole();
    int num = 0;
    if (aclrole != null)
      num = aclrole.length;
    ArrayList list = new ArrayList();
    for (int j = 0; j < num; ++j) {
      String strTemp = aclrole[j];
      list.add(strTemp);
    }

    Owner owner = getUUMService().getOwnerByOwnercode(userbean.getOwnercode());
    ACLContend.getACLService().newRolesUserRelation(list, owner);
    return true;
  }

  private boolean saveRole(HttpServletRequest request, ActionForm form) {
    UserFormBean userbean = (UserFormBean)form;
    String[] role = userbean.getFinRole();
    int num = 0;
    if (role != null)
      num = role.length;
    ArrayList list = new ArrayList();
    for (int j = 0; j < num; ++j) {
      String strTemp = role[j];

      list.add(strTemp);
    }

    Owner owner = getUUMService().getOwnerByOwnercode(userbean.getOwnercode());
    getUUMService().updateDeptOrUserRole(list, owner.getId());
    return true;
  }

  private SelectBean[] getSelect(List org, List sel) {
    SelectBean[] sbean = new SelectBean[sel.size()];
    for (int i = 0; i < sbean.length; ++i) {
      Role role = (Role)sel.get(i);
      sbean[i] = new SelectBean();
      sbean[i].setValue(role.getId());
      sbean[i].setLabel(role.getRolename());
    }

    return sbean;
  }

  private SelectBean[] getACLSelect(List org, List sel) {
    if (sel == null)
      return null;
    SelectBean[] sbean = new SelectBean[sel.size()];
    org.removeAll(sel);
    for (int i = 0; i < sbean.length; ++i) {
      Aclrole role = (Aclrole)sel.get(i);
      sbean[i] = new SelectBean();
      sbean[i].setValue(role.getRoleid());
      sbean[i].setLabel(role.getRolename());
    }

    return sbean;
  }

  public void initpassword(HttpServletRequest request) {
    String initpass = UUMConf.get("initpassword");
    String[] ids = request.getParameterValues("chkid");
    if (ids == null)
      return;
    List list = new ArrayList();
    for (int i = 0; i < ids.length; ++i) {
      list.add(ids[i]);
    }
    getUUMService().initUserPassword(list, initpass);
  }

  public void disable(HttpServletRequest request) {
    String[] ids = request.getParameterValues("chkid");
    if (ids == null)
      return;
    int num = ids.length;
    for (int i = 0; i < num; ++i) {
      Owner owner = getUUMService().getOwnerByOwnerid(ids[i]);
      owner.setStatus(new Integer(0));
      getUUMService().updateOwner(owner);
    }
  }

  public void swap(HttpServletRequest request)
  {
    String deptid = request.getParameter("parentid");
    String[] ids = request.getParameterValues("chkid");
    if (ids == null)
      return;
    int num = ids.length;
    for (int i = 0; i < num; ++i)
      getUUMService().swapOwner(ids[i], deptid);
  }

  public boolean saveimport(HttpServletRequest request)
  {
    String parentid = request.getParameter("parentid");
    String[] uid = request.getParameterValues("chkid");
    int num = 0;
    if (uid != null)
      num = uid.length;
    else
      return false;
    for (int i = 0; i < num; ++i) {
      getUUMService().newRelation(parentid, uid[i]);
    }
    return true;
  }

  public boolean savemanageddept(HttpServletRequest request, ActionForm form) {
    UserFormBean userbean = (UserFormBean)form;
    String manageddept = userbean.getManagedept();
    if (manageddept.trim().length() < 1)
      return false;
    String[] depts = manageddept.split(",");
    List list = new ArrayList();
    for (int i = 0; i < depts.length; ++i) {
      String oname = depts[i];
      Owner owner = getUUMService().getOwnerByOwnername(oname);
      list.add(owner.getId());
    }

    if (userbean.getId().equals("")) {
      Owner owner = getUUMService().getOwnerByOwnercode(userbean.getOwnercode());
      getUUMService().updateUserManagedDept(list, owner.getId());
    } else {
      getUUMService().updateUserManagedDept(list, userbean.getId());
    }
    return false;
  }

  public Pagination getPageInfo(HttpServletRequest request) {
    int rowperpage = UUMConf.getInt("uum.rowperpage", 10);
    Pagination pagination = new Pagination();
    String strpageno = request.getParameter("currentpage");
    pagination.setCurrentpage(strpageno);
    pagination.setRows(rowperpage);
    String deptid = request.getParameter("parentid");
    Owner currentowner = getUUMService().getOwnerByOwnerid(deptid);
    pagination.setList(getUUMService().getUserChildByDeptId(deptid, pagination.getRows(), pagination.getCurrentpage()));
    Integer Intsumpage = getUUMService().getChildUserRowCount(deptid);
    pagination.setSumrecords(getUUMService().getChildUserRowCount(deptid).intValue());
    return pagination;
  }

  public void getImport(HttpServletRequest request) {
    int rowperpage = UUMConf.getInt("uum.rowperpage", 10);
    String currentpage = request.getParameter("currentpage");
    Pagination pagination = new Pagination();
    pagination.setRows(rowperpage);
    pagination.setAction("import");
    pagination.setCurrentpage(currentpage);
    pagination.setTarget("user.do");
    String deptid = request.getParameter("parentid");
    Owner currentowner = getUUMService().getOwnerByOwnerid(deptid);
    request.setAttribute("currentowner", currentowner);
    HttpSession session = request.getSession();
    Visit visit = (Visit)session.getAttribute("visit");
    String uid = visit.getOwner().getId();
    String usertype = request.getParameter("usertype");
    List userlist = null;
    if (usertype.equals("0")) {
      pagination.setSumrecords(getUUMService().getNoDeptUserCounter());
      pagination.setList(getUUMService().getNoDeptUser(pagination.getRows(), pagination.getCurrentpage()));
    } else if (usertype.equals("1")) {
      pagination.setSumrecords(getUUMService().getManageUserExceptCurrDeptCounter(uid, deptid));
      pagination.setList(getUUMService().getManageUserExceptCurrDept(uid, deptid, pagination.getRows(), pagination.getCurrentpage()));
    }
    request.setAttribute("pagination", pagination);
    request.setAttribute("currentowner", currentowner);
    request.setAttribute("ut", usertype);
  }
}