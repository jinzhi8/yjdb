package com.kizsoft.commons.uum.service;

import com.kizsoft.commons.uum.pojo.Owner;
import com.kizsoft.commons.uum.pojo.Role;
import java.util.List;

public abstract interface IUUMService
{
  public abstract List getTopLevel();

  public abstract List getTopTreeByUserId(String paramString);

  public abstract Owner getOwnerByOwnerid(String paramString);

  public abstract boolean isExistOwner(String paramString1, String paramString2);

  public abstract Owner getOwnerByOwnercode(String paramString);

  public abstract Owner getOwnerByOwnername(String paramString);

  public abstract Owner getOwnerByUserNameAndPass(String paramString1, String paramString2);

  public abstract List getChildByOwnerId(String paramString);

  public abstract List getDeptChildByOwnerId(String paramString);

  public abstract List getUserChildByDeptId(String paramString);

  public abstract List getUserChildByDeptId(String paramString, int paramInt1, int paramInt2);

  public abstract List getAllChildUserByOwnerId(String paramString);

  public abstract List getAllChildDeptByOwnerId(String paramString);

  public abstract List getAllChildByOwnerId(String paramString);

  public abstract List getNoDeptUser();

  public abstract List getManageUserExceptCurrDept(String paramString1, String paramString2);

  public abstract void removeUserManagedDept(String paramString);

  public abstract boolean updateUserManagedDept(List paramList, String paramString);

  public abstract List getParentsByOwnerId(String paramString);

  public abstract boolean deleteOwnerByIds(List paramList);

  public abstract boolean newOwner(Owner paramOwner);

  public abstract boolean newRelation(String paramString1, String paramString2);

  public abstract boolean updateOwner(Owner paramOwner);

  public abstract void initUserPassword(List paramList, String paramString);

  public abstract boolean swapOwner(String paramString1, String paramString2);

  public abstract boolean invokeOwner(String paramString1, String paramString2);

  public abstract List getManagedDept(String paramString);

  public abstract List getWholeRole();

  public abstract List getRoleListByOwnerId(String paramString);

  public abstract boolean updateDeptOrUserRole(List paramList, String paramString);

  public abstract boolean deleteRoleRelationByOwnerId(String paramString);

  public abstract boolean newRole(Role paramRole);

  public abstract boolean updateRole(Role paramRole);

  public abstract boolean deleteRole(List paramList);

  public abstract Role getRoleById(String paramString);

  public abstract List getAllUser();

  public abstract Owner getUserGroupName(String paramString);

  public abstract Owner getUserParentDept(String paramString);

  public abstract Integer getChildUserRowCount(String paramString);

  public abstract List getNoDeptUser(int paramInt1, int paramInt2);

  public abstract List getManageUserExceptCurrDept(String paramString1, String paramString2, int paramInt1, int paramInt2);

  public abstract int getNoDeptUserCounter();

  public abstract int getManageUserExceptCurrDeptCounter(String paramString1, String paramString2);

  public abstract boolean upNode(String paramString1, String paramString2);

  public abstract boolean downNode(String paramString1, String paramString2);

  public abstract List getRoleListByDeptId(String paramString);

  public abstract List getOtherRoleListByDeptId(String paramString);

  public abstract List getOwnerListByRoleId(String paramString);

  public abstract boolean deleteRoleRelationByRoleId(String paramString);
}