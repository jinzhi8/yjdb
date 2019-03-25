package com.kizsoft.commons.acl.service.spring;

import com.kizsoft.commons.acl.dao.IACLDAO;
import com.kizsoft.commons.acl.pojo.Aclapp;
import com.kizsoft.commons.acl.pojo.Aclprivileresource;
import com.kizsoft.commons.acl.pojo.Aclprivileresourcetype;
import com.kizsoft.commons.acl.pojo.Aclprivleattribute;
import com.kizsoft.commons.acl.pojo.Aclrole;
import com.kizsoft.commons.acl.pojo.PrivilegeVO;
import com.kizsoft.commons.acl.service.IACLService;
import com.kizsoft.commons.uum.pojo.Owner;
import java.io.PrintStream;
import java.util.List;

public class ACLService
  implements IACLService
{
  private IACLDAO aclDAO;

  public List getRoleByAppId(String appid)
  {
    return getAclDAO().getRoleByAppId(appid);
  }

  public List getWholeRole() {
    return getAclDAO().getWholeRole();
  }

  public List getRoleByOwnerId(String ownerid) {
    return getAclDAO().getRoleByOwnerId(ownerid);
  }

  public List getRoleByPage(int nFirst, int nPageSize, String sortColumn, boolean sortOrder) {
    return getAclDAO().getRoleByPage(nFirst, nPageSize, sortColumn, sortOrder);
  }

  public boolean hasPrivilege(String userid, String workid, String worktype, String privilegeid) {
    return getAclDAO().hasPrivilege(userid, workid, worktype, privilegeid);
  }

  public Integer getRowCountByUserTypePrivile(String ownerid, String sourcetype, String privileid) {
    return getAclDAO().getRowCountByUserTypePrivile(ownerid, sourcetype, privileid);
  }

  public String getSQLByUserTypePrivile(String sql, String idname, String ownerid, String sourcetype, String privileid) {
    return getAclDAO().getSQLByUserTypePrivile(sql, idname, ownerid, sourcetype, privileid);
  }

  public Integer getRowCountByUserType(String ownerid, String sourcetype) {
    return getAclDAO().getRowCountByUserType(ownerid, sourcetype);
  }

  public String getSQLByUserType(String sql, String idname, String ownerid) {
    return getAclDAO().getSQLByUserType(sql, idname, ownerid);
  }

  public boolean newPrivilege(List list) {
    return getAclDAO().newPrivilege(list);
  }

  public boolean setPrivilege2Owners(PrivilegeVO vo, List ownerlist) {
    return getAclDAO().setPrivilege2Owners(vo, ownerlist);
  }

  public boolean setPrivilege2Roles(PrivilegeVO vo, List rolelist) {
    return getAclDAO().setPrivilege2Roles(vo, rolelist);
  }

  public boolean setPrileges2Owner(List volist, Owner owner) {
    return getAclDAO().setPrileges2Owner(volist, owner);
  }

  public boolean setPrileges2Role(List volist, String roleid) {
    return getAclDAO().setPrileges2Role(volist, roleid);
  }

  public boolean addResource(Aclprivileresource source) {
    return getAclDAO().addResource(source);
  }

  public boolean updateResource(Aclprivileresource source) {
    return getAclDAO().updateResource(source);
  }

  public boolean deleteResource(Aclprivileresource source) {
    return getAclDAO().deleteResource(source);
  }

  public boolean addResourceType(Aclprivileresourcetype sourcetype) {
    return getAclDAO().addResourceType(sourcetype);
  }

  public boolean updateResourceType(Aclprivileresourcetype sourcetype) {
    return getAclDAO().updateResourceType(sourcetype);
  }

  public boolean deleteResourceType(Aclprivileresourcetype sourcetype) {
    return getAclDAO().deleteResourceType(sourcetype);
  }

  public boolean addResourceTypeAttr(Aclprivleattribute attribute) {
    return getAclDAO().addResourceTypeAttr(attribute);
  }

  public boolean updateResourceTypeAttr(Aclprivleattribute attribute) {
    return getAclDAO().updateResourceTypeAttr(attribute);
  }

  public boolean deleteResourceTypeAttr(Aclprivleattribute attribute) {
    return getAclDAO().deleteResourceTypeAttr(attribute);
  }

  public boolean addRole(Aclrole role) {
    return getAclDAO().addRole(role);
  }

  public Aclrole getRole(String roleid) {
    return getAclDAO().getRole(roleid);
  }

  public boolean updateRole(Aclrole role) {
    return getAclDAO().updateRole(role);
  }

  public boolean deleteRole(Aclrole role) {
    return getAclDAO().deleteRole(role);
  }

  public Aclapp getAppSysByAppID(String appid) {
    return getAclDAO().getAppSysByAppID(appid);
  }

  public boolean newAppSys(Aclapp app) {
    return getAclDAO().newAppSys(app);
  }

  public boolean updateAppSys(Aclapp app) {
    return getAclDAO().updateAppSys(app);
  }

  public boolean deleteAppSys(Aclapp app) {
    return getAclDAO().deleteAppSys(app);
  }

  public boolean newUsersRoleRelation(List ownerlist, Aclrole role) {
    return getAclDAO().newUsersRoleRelation(ownerlist, role);
  }

  public boolean newRolesUserRelation(List rolelist, Owner owner) {
    return getAclDAO().newRolesUserRelation(rolelist, owner);
  }

  public boolean deleteUserRole(Owner owner) {
    return getAclDAO().deleteUserRole(owner);
  }

  public IACLDAO getAclDAO() {
    return this.aclDAO;
  }

  public void setAclDAO(IACLDAO aclDAO) {
    this.aclDAO = aclDAO;
  }

  public boolean hasPrivilege(String userid, String sourceid) {
    return getAclDAO().hasPrivilege(userid, sourceid);
  }

  public String getNameBySourceId(String sourceid) {
    return getAclDAO().getNameBySourceId(sourceid);
  }

  public List getAppSysList() {
    return getAclDAO().getAppSysList();
  }

  public boolean addPrivilege2Owners(PrivilegeVO vo, List owneridlist) {
    return getAclDAO().addPrivilege2Owners(vo, owneridlist);
  }

  public boolean addPrivilege2Roles(PrivilegeVO vo, List roleidlist) {
    return getAclDAO().addPrivilege2Roles(vo, roleidlist);
  }

  public Aclapp getAppSysByAppcode(String appcode) {
    return getAclDAO().getAppSysByAppcode(appcode);
  }

  public List getAllResourceType() {
    return getAclDAO().getAllResourceType();
  }

  public List getSourceListByType(String categoryid) {
    return getAclDAO().getSourceListByType(categoryid);
  }

  public List getResourceTypeAttrByType(String categoryid) {
    return getAclDAO().getResourceTypeAttrByType(categoryid);
  }

  public List getCategoryPrivilege(String categoryid, String roleid) {
    return getAclDAO().getCategoryPrivilege(categoryid, roleid);
  }

  public void deleteCategoryPrivilege(String categoryid, String roleid) {
    getAclDAO().deleteCategoryPrivilege(categoryid, roleid);
  }

  public List getSourceListByCategoryAndAppid(String categoryid, String appid) {
    return getAclDAO().getSourceListByCategoryAndAppid(categoryid, appid);
  }

  public Aclprivileresourcetype getSourceTypeByTypecode(String typecode) {
    return getAclDAO().getSourceTypeByTypecode(typecode);
  }

  public List getOwnerByRoleid(String roleid) {
    return getAclDAO().getOwnerByRoleid(roleid);
  }

  public boolean deleteUserRoleRelation(String userid, String roleid) {
    return getAclDAO().deleteUserRoleRelation(userid, roleid);
  }

  public Aclprivileresource getResourceBySourceid(String sourceid) {
    return getAclDAO().getResourceBySourceid(sourceid);
  }

  public Aclprivileresource getResourceBySourcecode(String sourcecode) {
    return getAclDAO().getResourceBySourcecode(sourcecode);
  }

  public Aclprivleattribute getAttributeByAttributeid(String attributeid) {
    return getAclDAO().getAttributeByAttributeid(attributeid);
  }

  public Aclprivileresourcetype getResourceTypeByTypeid(String typeid) {
    return getAclDAO().getResourceTypeByTypeid(typeid);
  }

  public List getPrivilegeByUserIdAndSourcecode(String userid, String sourcecode) {
    return getAclDAO().getPrivilegeByUserIdAndSourcecode(userid, sourcecode);
  }

  public List getPrivilegeByLoginnameAndSourcecode(String loginname, String sourcecode) {
    return getAclDAO().getPrivilegeByLoginnameAndSourcecode(loginname, sourcecode);
  }

  public Aclrole getRoleByRolecode(String rolecode) {
    System.out.println("=============getRoleByrolecode====");
    return getAclDAO().getRoleByRolecode(rolecode);
  }

  public Integer getUserRowCountExceptRole(String roleid, String nameen, String namecn) {
    return getAclDAO().getUserRowCountExceptRole(roleid, nameen, namecn);
  }

  public List getUserByPageExceptRole(int nFirst, int nPageSize, String roleid, String nameen, String namecn) {
    return getAclDAO().getUserByPageExceptRole(nFirst, nPageSize, roleid, nameen, namecn);
  }

  public boolean newUseridsRoleRelation(List owneridlist, String roleid) {
    return getAclDAO().newUseridsRoleRelation(owneridlist, roleid);
  }

  public Aclprivleattribute getAttributeByAttrcodeAndCategoryid(String attrcode, String categoryid) {
    return getAclDAO().getAttributeByAttrcodeAndCategoryid(attrcode, categoryid);
  }

  public boolean deleteSourcePrivilge(String sourceid) {
    return getAclDAO().deleteSourcePrivilge(sourceid);
  }
}