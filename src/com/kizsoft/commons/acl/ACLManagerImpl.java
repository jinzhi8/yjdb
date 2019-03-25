package com.kizsoft.commons.acl;

import com.kizsoft.commons.acl.pojo.Aclrole;
import com.kizsoft.commons.acl.pojo.PrivilegeVO;
import com.kizsoft.commons.acl.service.IACLService;
import com.kizsoft.commons.acl.utils.ACLContend;
import com.kizsoft.commons.commons.user.Group;
import com.kizsoft.commons.commons.user.User;
import com.kizsoft.commons.commons.user.UserException;
import com.kizsoft.commons.commons.user.UserManager;
import com.kizsoft.commons.commons.user.UserManagerFactory;
import com.kizsoft.commons.commons.util.StringHelper;
import java.util.List;
import java.util.Vector;
import org.apache.log4j.Logger;

public class ACLManagerImpl
  implements ACLManager
{
  final Logger log;

  public ACLManagerImpl()
  {
    this.log = Logger.getLogger(super.getClass().getName());
  }
  public Vector getAclEntryList(String userID) {
    Vector aclEntryList = new Vector();
    aclEntryList.add(userID);
    UserManager userManager = UserManagerFactory.getUserManager();
    try {
      User userInfo = userManager.findUser(userID);
      String unitID = userInfo.getGroup().getGroupId();
      aclEntryList.add(unitID);
    } catch (UserException ex) {
      ex.printStackTrace();
    }

    return aclEntryList;
  }

  public Vector getAclEntryListRole(String userID) {
    Vector aclEntryList = new Vector();
    aclEntryList.add(userID);
    UserManager userManager = UserManagerFactory.getUserManager();
    try {
      User userInfo = userManager.findUser(userID);
      String unitID = userInfo.getGroup().getGroupId();
      aclEntryList.add(unitID);
    } catch (UserException ex) {
      ex.printStackTrace();
    }

    return aclEntryList;
  }

  public Vector getAclEntryListByModule(String userID, String moduleID) {
    Vector aclEntryList = new Vector();
    aclEntryList.add(userID);
    UserManager userManager = UserManagerFactory.getUserManager();
    try {
      User userInfo = userManager.findUser(userID);
      String unitID = userInfo.getGroup().getGroupId();
      aclEntryList.add(unitID);
    } catch (UserException ex) {
      ex.printStackTrace();
    }
    return aclEntryList;
  }

  public boolean addACLRange(String sourceID, String range) {
    return addACLRange(sourceID, range, true);
  }

  public boolean addACLRange(String sourceID, String range, boolean addAdmin)
  {
    if (StringHelper.isNull(range))
      return true;
    try
    {
      PrivilegeVO privilegeVO = new PrivilegeVO(sourceID, "", "");
      List ownerList;
      if ("".equals(range)) {
        ownerList = StringHelper.split2List("*", ",");
      }
      else {
        ownerList = StringHelper.split2List(range, ",");
      }

      ACLContend.getACLService().deleteSourcePrivilge(sourceID);
      if (ACLContend.getACLService().setPrivilege2Owners(privilegeVO, ownerList)) {
        if ((!"*".equals(range)) && (!"".equals(range)) && (addAdmin)) {
          IACLService aclService = ACLContend.getACLService();
          Aclrole adminRole = aclService.getRoleByRolecode("sysadmin");
          appendACLRange(sourceID, adminRole.getRoleid());
        }
        if (this.log.isDebugEnabled()) {
          this.log.debug("资源" + sourceID + "权限" + range + "添加成功！");
        }
        return true;
      }
      if (this.log.isDebugEnabled()) {
        this.log.debug("资源" + sourceID + "权限" + range + "添加失败！");
      }
      return false;
    }
    catch (Exception e) {
      e.printStackTrace();
    }return false;
  }

  public boolean appendACLRange(String sourceID, String range)
  {
    if ((range == null) || ("".equals(range))) {
      return true;
    }
    try
    {
      PrivilegeVO privilegeVO = new PrivilegeVO(sourceID, "", "");
      List ownerList = StringHelper.split2List(range, ",");

      return ACLContend.getACLService().addPrivilege2Owners(privilegeVO, ownerList);
    }
    catch (Exception e)
    {
      e.printStackTrace();
    }return false;
  }

  public String getACLSql(String sql, String idName, String userID)
  {
    String aclSql = "";
    aclSql = ACLContend.getACLService().getSQLByUserType(sql, idName, userID);
    if (this.log.isDebugEnabled()) {
      this.log.debug("获取权限：\nsql:" + sql + "\nidname:" + idName + "\nuserID:" + userID + "\naclsql:" + aclSql);
    }
    return aclSql;
  }

  public String getAclRoleStrById(String ownerId) {
    if (ownerId == null) {
      return null;
    }
    String aclRoleStr = "";
    List ownerRoleList = ACLContend.getACLService().getRoleByOwnerId(ownerId);

    if ((ownerRoleList != null) && (ownerRoleList.size() > 0)) {
      for (int i = 0; i < ownerRoleList.size(); ++i) {
        Aclrole aclRole = (Aclrole)ownerRoleList.get(i);
        if (aclRole != null) {
          if (StringHelper.isNull(aclRoleStr))
            aclRoleStr = aclRole.getRolecode();
          else {
            aclRoleStr = aclRoleStr + "," + aclRole.getRolecode();
          }
        }
      }
    }

    return aclRoleStr;
  }

  public boolean isOwnerRole(String ownerId, String roleCode) {
    if ((roleCode == null) || (ownerId == null)) {
      return false;
    }

    List ownerRoleList = ACLContend.getACLService().getRoleByOwnerId(ownerId);

    if ((ownerRoleList != null) && (ownerRoleList.size() > 0)) {
      for (int i = 0; i < ownerRoleList.size(); ++i) {
        Aclrole aclRole = (Aclrole)ownerRoleList.get(i);
        if ((aclRole != null) && 
          (roleCode.equals(aclRole.getRolecode()))) {
          return true;
        }
      }

    }

    return false;
  }
}