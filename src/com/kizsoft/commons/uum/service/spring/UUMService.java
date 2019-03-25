package com.kizsoft.commons.uum.service.spring;

import com.kizsoft.commons.uum.dao.IOwnerDAO;
import com.kizsoft.commons.uum.dao.IRoleDAO;
import com.kizsoft.commons.uum.pojo.Owner;
import com.kizsoft.commons.uum.pojo.Role;
import com.kizsoft.commons.uum.service.IUUMService;
import com.kizsoft.commons.uum.utils.UUMContend;
import java.util.ArrayList;
import java.util.List;

public class UUMService
  implements IUUMService
{
  private IOwnerDAO ownerDAO;
  private IRoleDAO roleDAO;

  public List getTopLevel()
  {
    return getOwnerDAO().getTopLevel();
  }

  public List getTopTreeByUserId(String userid) {
    return getOwnerDAO().getTopTreeByUserId(userid);
  }

  public Owner getOwnerByOwnerid(String id) {
    return getOwnerDAO().getByOwnerid(id);
  }

  public boolean isExistOwner(String ownercode, String flag) {
    return getOwnerDAO().isExistOwner(ownercode, flag);
  }

  public Owner getOwnerByOwnercode(String ownercode) {
    return getOwnerDAO().getByOwnercode(ownercode);
  }

  public Owner getOwnerByOwnername(String ownername) {
    return getOwnerDAO().getByOwnername(ownername);
  }

  public Owner getOwnerByUserNameAndPass(String username, String pass) {
    return getOwnerDAO().getByUserNameAndPass(username, pass);
  }

  public List getChildByOwnerId(String ownerid) {
    return getOwnerDAO().getChildByOwnerId(ownerid);
  }

  public List getDeptChildByOwnerId(String ownerid) {
    return getOwnerDAO().getDeptChildByOwnerId(ownerid);
  }

  public List getUserChildByDeptId(String deptId) {
    return getOwnerDAO().getUserChildByDeptId(deptId);
  }

  public List getAllChildUserByOwnerId(String ownerid) {
    return getOwnerDAO().getAllChildUserByOwnerId(ownerid);
  }

  public List getAllChildDeptByOwnerId(String ownerId) {
    return getOwnerDAO().getAllChildDeptByOwnerId(ownerId);
  }

  public List getAllChildByOwnerId(String ownerId) {
    return getOwnerDAO().getAllChildByOwnerId(ownerId);
  }

  public List getNoDeptUser() {
    return getOwnerDAO().getNoDeptUser();
  }

  public List getManageUserExceptCurrDept(String userid, String deptid) {
    Owner owner = getOwnerDAO().getByOwnerid(userid);
    List list = new ArrayList();
    if (owner.getType().toString().equals(UUMContend.SYSTEM_MANAGER.toString())) {
      List alluserlist = getOwnerDAO().getAllUser();
      List deptuserlist = getOwnerDAO().getUserChildByDeptId(deptid);
      List nodeptuser = getOwnerDAO().getNoDeptUser();
      alluserlist.removeAll(nodeptuser);
      alluserlist.removeAll(deptuserlist);
      list = alluserlist;
    } else {
      List manageddeptuser = getOwnerDAO().getManagedDept(userid);
      List alluserlist = new ArrayList();
      for (int i = 0; i < manageddeptuser.size(); i++) {
        List deptuser = getOwnerDAO().getAllChildUserByOwnerId(((Owner)manageddeptuser.get(i)).getId());
        alluserlist.addAll(deptuser);
      }

      alluserlist.removeAll(getOwnerDAO().getAllChildUserByOwnerId(deptid));
      list = alluserlist;
    }
    return list;
  }

  public boolean updateUserManagedDept(List deptids, String userid) {
    getOwnerDAO().removeUserManagedDept(userid);
    return getOwnerDAO().updateUserManagedDept(deptids, userid);
  }

  public void removeUserManagedDept(String userid) {
    getOwnerDAO().removeUserManagedDept(userid);
  }

  public List getParentsByOwnerId(String ownerid) {
    return getOwnerDAO().getParentsByOwnerId(ownerid);
  }

  public boolean updateOwner(Owner owner) {
    return getOwnerDAO().updateOwner(owner);
  }

  public boolean deleteOwnerByIds(List idlist) {
    return getOwnerDAO().deleteOwnerByIds(idlist);
  }

  public boolean newOwner(Owner owner) {
    return getOwnerDAO().newOwner(owner);
  }

  public boolean newRelation(String parentid, String ownerid) {
    return getOwnerDAO().newRelation(parentid, ownerid);
  }

  public void initUserPassword(List useridlist, String password) {
    getOwnerDAO().initUserPassword(useridlist, password);
  }

  public boolean swapOwner(String userid, String parentid) {
    return getOwnerDAO().swapOwner(userid, parentid);
  }

  public boolean invokeOwner(String userid, String parentid) {
    return getOwnerDAO().invokeOwner(userid, parentid);
  }

  public List getWholeRole() {
    return getRoleDAO().getWholeRole();
  }

  public List getRoleListByOwnerId(String ownerid) {
    return getRoleDAO().getRoleListByOwnerId(ownerid);
  }

  public boolean updateDeptOrUserRole(List idlist, String ownerid) {
    return getRoleDAO().updateDeptOrUserRole(idlist, ownerid);
  }

  public boolean deleteRoleRelationByOwnerId(String ownerid) {
    return getRoleDAO().deleteRoleRelationByOwnerId(ownerid);
  }

  public boolean newRole(Role role) {
    return getRoleDAO().newRole(role);
  }

  public boolean updateRole(Role role) {
    return getRoleDAO().updateRole(role);
  }

  public boolean deleteRole(List roleidlist) {
    return getRoleDAO().deleteRole(roleidlist);
  }

  public Role getRoleById(String id) {
    return getRoleDAO().getRoleById(id);
  }

  public void setRoleDAO(IRoleDAO roleDAO) {
    this.roleDAO = roleDAO;
  }

  public IRoleDAO getRoleDAO() {
    return this.roleDAO;
  }

  public void setOwnerDAO(IOwnerDAO ownerDAO) {
    this.ownerDAO = ownerDAO;
  }

  public IOwnerDAO getOwnerDAO() {
    return this.ownerDAO;
  }

  public List getManagedDept(String userid) {
    return getOwnerDAO().getManagedDept(userid);
  }

  public List getChildUserByPage(String parentId, Integer begin, Integer rowperpage) {
    return null;
  }

  public List getUserChildByDeptId(String deptId, int rows, int pageno) {
    return getOwnerDAO().getUserChildByDeptId(deptId, rows, pageno);
  }

  public Integer getChildUserRowCount(String deptid) {
    return getOwnerDAO().getChildUserRowCount(deptid);
  }

  public List getAllUser() {
    return getOwnerDAO().getAllUser();
  }

  public Owner getUserGroupName(String username) {
    return getOwnerDAO().getUserGroupName(username);
  }

  public Owner getUserParentDept(String username) {
    return getOwnerDAO().getUserParentDept(username);
  }

  public List getManageUserExceptCurrDept(String userid, String deptid, int rows, int pageno) {
    List list = getManageUserExceptCurrDept(userid, deptid);
    List tlist = new ArrayList();
    int begin = rows * (pageno - 1);
    if (begin > list.size())
      return null;
    if (rows > list.size() - begin)
      rows = list.size() - begin;
    for (int i = 0; i < rows; i++) {
      tlist.add(list.get(begin + i));
    }
    return tlist;
  }

  public List getNoDeptUser(int rows, int currentpage) {
    return getOwnerDAO().getNoDeptUser(rows, currentpage);
  }

  public int getNoDeptUserCounter() {
    return getNoDeptUser().size();
  }

  public int getManageUserExceptCurrDeptCounter(String userid, String deptid) {
    return getManageUserExceptCurrDept(userid, deptid).size();
  }

  public boolean upNode(String id, String parentid) {
    getOwnerDAO().upNode(id, parentid);
    return false;
  }

  public boolean downNode(String id, String parentid) {
    getOwnerDAO().downNode(id, parentid);
    return false;
  }

  public List getRoleListByDeptId(String deptid) {
    return getRoleDAO().getRoleListByDeptId(deptid);
  }

  public List getOtherRoleListByDeptId(String deptid) {
    return getRoleDAO().getOtherRoleListByDeptId(deptid);
  }

  public List getOwnerListByRoleId(String roleid) {
    return getRoleDAO().getOwnerListByRoleId(roleid);
  }

  public boolean deleteRoleRelationByRoleId(String roleid) {
    return getRoleDAO().deleteRoleRelationByRoleId(roleid);
  }
}