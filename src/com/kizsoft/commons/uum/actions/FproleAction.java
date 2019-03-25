package com.kizsoft.commons.uum.actions;
import com.kizsoft.commons.acl.pojo.Aclrole;
import com.kizsoft.commons.acl.pojo.PrivilegeVO;
import com.kizsoft.commons.acl.service.IACLService;
import com.kizsoft.commons.acl.utils.ACLContend;
import com.kizsoft.commons.commons.orm.SimpleORMUtils;
import com.kizsoft.commons.util.UUIDGenerator;
import com.kizsoft.commons.uum.actions.AclroleFormBean;
import com.kizsoft.commons.uum.actions.BaseAction;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

public class FproleAction extends BaseAction
{
  public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)
    throws IOException, ServletException
  {
    String action = request.getParameter("action");
    if ((action == null) || (action.equals("init"))) {
      init(request, form);
      return mapping.findForward("list");
    }
    if (action.equals("edit")) {
      editFpRole(request);
      init(request, form);
      return mapping.findForward("list");
    }
    return mapping.findForward("error");
  }

  SimpleORMUtils instance=SimpleORMUtils.getInstance();
  private void init(HttpServletRequest request, ActionForm form)
  {
    String sql="select roleid FROM Aclrole r where r.rolecode =?";
    sql="select userid FROM Acluserrole where roleid=("+sql+")";
    sql="select o.id,o.ownername,u.* from owner o left join aclunitrole u on o.id=u.unitmanid where o.id in ("+sql+")";
    List<Map<String, Object>> list = instance.queryForMap(sql, "unitadmin");
    request.setAttribute("list", list);
  }
  private void editFpRole(HttpServletRequest request)
  {
	  String gxNumStr = request.getParameter("gxNum");//第几条数据更新
	  String unitroleid = request.getParameter("unitroleid_" + gxNumStr)==null?"":request.getParameter("unitroleid_" + gxNumStr);
	  String unitman = request.getParameter("unitman_" + gxNumStr)==null?"":request.getParameter("unitman_" + gxNumStr);
	  String unitmanid = request.getParameter("unitmanid_" + gxNumStr)==null?"":request.getParameter("unitmanid_" + gxNumStr);
	  String fprole = request.getParameter("fprole_" + gxNumStr)==null?"":request.getParameter("fprole_" + gxNumStr);
	  String fproleid = request.getParameter("fproleid_" + gxNumStr)==null?"":request.getParameter("fproleid_" + gxNumStr);
	  String sql="";
	  if ("".equals(unitroleid))
      {
		  unitroleid=UUIDGenerator.getUUID();
         sql="insert into aclunitrole(unitroleid,unitman,unitmanid,fprole,fproleid) values(?,?,?,?,?)";
         instance.executeUpdate(sql, unitroleid,unitman,unitmanid,fprole,fproleid);
      }
      else {
    	 sql="update aclunitrole set unitman=?,unitmanid=?,fprole=?,fproleid=? where unitroleid=?";
         instance.executeUpdate(sql, unitman,unitmanid,fprole,fproleid,unitroleid);
      }
	  System.out.println(sql);
  }
}