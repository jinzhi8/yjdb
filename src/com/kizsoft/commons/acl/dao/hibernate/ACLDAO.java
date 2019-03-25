package com.kizsoft.commons.acl.dao.hibernate;

import com.kizsoft.commons.acl.dao.IACLDAO;
import com.kizsoft.commons.acl.pojo.Aclapp;
import com.kizsoft.commons.acl.pojo.Aclprivilelist;
import com.kizsoft.commons.acl.pojo.Aclprivileresource;
import com.kizsoft.commons.acl.pojo.Aclprivileresourcetype;
import com.kizsoft.commons.acl.pojo.Aclprivleattribute;
import com.kizsoft.commons.acl.pojo.Aclrole;
import com.kizsoft.commons.acl.pojo.Acluserrole;
import com.kizsoft.commons.acl.pojo.PrivilegeVO;
import com.kizsoft.commons.acl.utils.ACLContend;
import com.kizsoft.commons.uum.dao.hibernate.OwnerDAO;
import com.kizsoft.commons.uum.pojo.Owner;
import com.kizsoft.commons.uum.service.IUUMService;
import com.kizsoft.commons.uum.utils.UUMContend;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.util.List;
import net.sf.hibernate.Session;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.orm.hibernate.HibernateTemplate;

public class ACLDAO extends BaseDAO
  implements IACLDAO
{
  Logger LOG;

  public ACLDAO()
  {
    this.LOG = Logger.getLogger(OwnerDAO.class);
  }

  public List getRoleByAppId(String appid) {
    try {
      List list = getHibernateTemplate().findByNamedQueryAndNamedParam("queryRoleByAppid", "appid", appid);
      return list;
    } catch (Exception ex) {
      ex.printStackTrace();
    }
    return null;
  }

  public List getWholeRole() {
    List list = getHibernateTemplate().loadAll(Aclrole.class);
    return list;
  }

  public List getRoleByOwnerId(String ownerid) {
    try {
      List list = getHibernateTemplate().findByNamedQueryAndNamedParam("queryAllUserRole", "userid", ownerid);
      return list;
    } catch (Exception ex) {
      ex.printStackTrace();
    }
    return null;
  }

  public List getRoleByPage(int nFirst, int nPageSize, String sortColumn, boolean flag) {
    return null;
  }

  public Integer getRowCountByUserTypePrivile(String ownerid, String sourcetype, String privileid) {
    return (Integer)findByNamedQueryAndNamedParam("queryCountPrivileByUserTypePrivile", new String[] { "ownerid", "worktype", "purview" }, new Object[] { ownerid, sourcetype, privileid }).get(0);
  }

  public String getSQLByUserTypePrivile(String sql, String idname, String ownerid, String sourcetype, String privileid) {
    sql = StringUtils.replace(sql, "from", "from " + getDBConnectionUsername() + ".ACLPRIVILELIST ");
    if (sql.indexOf("where") > 0)
      sql = StringUtils.replace(sql, "where", "where " + idname + "=" + "ACLPRIVILELIST.WORKID and ACLPRIVILELIST.OWNERID= " + ownerid + " and ACLPRIVILELIST.WORKTYPE='" + sourcetype + "'" + " and ACLPRIVILELIST.PURVIEW='" + privileid + "' and ");
    else {
      sql = sql + "where " + idname + "=" + "ACLPRIVILELIST.WORKID and ACLPRIVILELIST.OWNERID= '" + ownerid + "'" + " and ACLPRIVILELIST.WORKTYPE='" + sourcetype + "'" + " and ACLPRIVILELIST.PURVIEW='" + privileid + "'";
    }
    return sql;
  }

  public Integer getRowCountByUserType(String ownerid, String sourcetype) {
    return (Integer)findByNamedQueryAndNamedParam("queryPrivileByUserType", new String[] { "ownerid", "worktype" }, new Object[] { ownerid, sourcetype }).get(0);
  }

  public String getSQLByUserType(String sql, String idname, String ownerid) {
    List ownerlist = UUMContend.getUUMService().getParentsByOwnerId(ownerid);
    List rolelist = getRoleByOwnerId(ownerid);
    StringBuffer ids = new StringBuffer("");
    if (ownerlist.size() > 0) {
      for (int i = 0; i < ownerlist.size(); ++i) {
        Owner owner = (Owner)ownerlist.get(i);
        ids.append("'" + owner.getId() + "',");
      }
    }

    if (rolelist.size() > 0) {
      for (int i = 0; i < rolelist.size(); ++i) {
        Aclrole role = (Aclrole)rolelist.get(i);
        ids.append("'" + role.getRoleid() + "',");
      }
    }

    ids.append("'" + ownerid + "'");

    String rpstring = "  exists ( select 1 from ACLPRIVILELIST where " + idname + "=ACLPRIVILELIST.WORKID and (OWNERID='*' or  ACLPRIVILELIST.OWNERID in (" + ids.toString() + " ))) ";

    if ((sql.indexOf("WHERE") > 0) || (sql.indexOf("where") > 0)) {
      sql = StringUtils.replace(sql, "WHERE", " where " + rpstring + "  and ");
      sql = StringUtils.replace(sql, "where", " where " + rpstring + "  and ");
    } else if ((sql.indexOf("ORDER BY") > 0) || (sql.indexOf("order by") > 0)) {
      sql = StringUtils.replace(sql, "ORDER BY", "where " + rpstring + " order by ");
      sql = StringUtils.replace(sql, "order by", "where " + rpstring + " order by ");
    } else {
      sql = sql + " where " + rpstring;
    }

    return sql;
  }

  public boolean hasPrivilege(String userid, String workid, String worktype, String privilegeid) {
    List list = getHibernateTemplate().findByNamedQueryAndNamedParam("queryHasPrivile", new String[] { "workid", "worktype", "ownerid", "purview" }, new Object[] { workid, worktype, userid, privilegeid });
    return (list != null) && (list.size() > 0);
  }

  public boolean hasPrivilege(String userid, String sourceid) {
    boolean haspri = false;
    List parentowner = UUMContend.getUUMService().getParentsByOwnerId(userid);
    List list = null;
    for (int i = 0; i < parentowner.size(); ++i) {
      Owner owner = (Owner)parentowner.get(i);
      list = getHibernateTemplate().findByNamedQueryAndNamedParam("queryHasPrivileByUserAndSource", new String[] { "workid", "ownerid" }, new Object[] { sourceid, owner.getId() });
      if ((list != null) && (list.size() > 0)) {
        haspri = true;
      }
    }

    list = getHibernateTemplate().findByNamedQueryAndNamedParam("queryHasPrivileByUserAndSource", new String[] { "workid", "ownerid" }, new Object[] { sourceid, userid });
    if ((list != null) && (list.size() > 0)) {
      haspri = true;
    }
    List rolelist = getRoleByOwnerId(userid);
    for (int i = 0; i < rolelist.size(); ++i) {
      Aclrole role = (Aclrole)rolelist.get(i);
      list = getHibernateTemplate().findByNamedQueryAndNamedParam("queryHasPrivileByUserAndSource", new String[] { "workid", "ownerid" }, new Object[] { sourceid, role.getRoleid() });
      if ((list != null) && (list.size() > 0)) {
        haspri = true;
      }
    }

    return haspri;
  }

  public boolean setPrivilege2Owners(PrivilegeVO vo, List idlist) {
    deleteSourcePrivilge(vo);
    for (int i = 0; i < idlist.size(); ++i) {
      Aclprivilelist privile = new Aclprivilelist();
      String ownerid = (String)idlist.get(i);
      privile.setOwnerid(ownerid);
      if ((vo.getPrivilegecode() != null) && (!vo.getPrivilegecode().equals(""))) {
        privile.setPurview(vo.getPrivilegecode());
      }
      privile.setWorkid(vo.getSourceid());
      if ((vo.getSourcetype() != null) && (!vo.getSourcetype().equals("")))
        privile.setWorktype(vo.getSourcetype());
      try
      {
        getHibernateTemplate().save(privile);
        this.LOG.debug("添加资源权限成功！");
      } catch (Exception ex) {
        ex.printStackTrace();
        this.LOG.error("添加资源权限失败！");
      }
    }

    return true;
  }

  private boolean deleteSourcePrivilge(PrivilegeVO vo) {
    try {
      List list = getHibernateTemplate().findByNamedQueryAndNamedParam("queryPrivileByWorkId", "workid", vo.getSourceid());
      getHibernateTemplate().deleteAll(list);
      return true; } catch (Exception exception) {
    }
    return false;
  }

  public boolean deleteSourcePrivilge(String sourceid)
  {
    try {
      List list = getHibernateTemplate().findByNamedQueryAndNamedParam("queryPrivileByWorkId", "workid", sourceid);
      getHibernateTemplate().deleteAll(list);
      return true; } catch (Exception exception) {
    }
    return false;
  }

  public boolean setPrivilege2Roles(PrivilegeVO vo, List rolelist)
  {
    deleteSourcePrivilge(vo);
    for (int i = 0; i < rolelist.size(); ++i) {
      Aclprivilelist privile = new Aclprivilelist();
      Aclrole role = (Aclrole)rolelist.get(i);
      privile.setOwnerid(role.getRoleid());
      privile.setOwnertype(new Long(ACLContend.ROLE_FLAG.intValue()));
      privile.setPurview(vo.getPrivilegecode());
      privile.setWorkid(vo.getSourceid());
      privile.setWorktype(vo.getSourcetype());
      try {
        getHibernateTemplate().save(privile);
        this.LOG.debug("添加资源权限成功！角色ID：" + role.getRoleid() + "  资源ID：" + vo.getSourceid() + "  权限ID：" + vo.getPrivilegecode());
      } catch (Exception ex) {
        this.LOG.error("添加资源权限失败！主体ID：" + role.getRoleid() + "  资源ID：" + vo.getSourceid() + "  权限ID：" + vo.getPrivilegecode() + "\t  错误原因：" + ex.getMessage());
      }
    }

    return true;
  }

  public boolean setPrileges2Owner(List volist, Owner owner) {
    for (int i = 0; i < volist.size(); ++i) {
      Aclprivilelist privile = new Aclprivilelist();
      PrivilegeVO vo = (PrivilegeVO)volist.get(i);
      privile.setOwnerid(owner.getId());
      privile.setOwnertype(new Long(owner.getFlag().intValue()));
      privile.setPurview(vo.getPrivilegecode());
      privile.setWorkid(vo.getSourceid());
      privile.setWorktype(vo.getSourcetype());
      try {
        getHibernateTemplate().save(privile);
        this.LOG.debug("添加资源权限成功！主体ID：" + owner.getId() + "  资源ID：" + vo.getSourceid() + "  权限ID：" + vo.getPrivilegecode());
      } catch (Exception ex) {
        ex.printStackTrace();
        this.LOG.error("添加资源权限失败！主体ID：" + owner.getId() + "  资源ID：" + vo.getSourceid() + "  权限ID：" + vo.getPrivilegecode() + "\t  错误原因：" + ex.getMessage());
        return false;
      }
    }

    return true;
  }

  public boolean setPrileges2Role(List volist, String roleid) {
    for (int i = 0; i < volist.size(); ++i) {
      Aclprivilelist privile = new Aclprivilelist();
      PrivilegeVO vo = (PrivilegeVO)volist.get(i);
      privile.setOwnerid(roleid);
      privile.setOwnertype(new Long(ACLContend.ROLE_FLAG.intValue()));
      privile.setPurview(vo.getPrivilegecode());
      privile.setWorkid(vo.getSourceid());
      privile.setWorktype(vo.getSourcetype());
      if ((vo.getSourcecode() != null) && (!vo.getSourcecode().equals("")))
        privile.setWorkcode(vo.getSourcecode());
      try
      {
        getHibernateTemplate().save(privile);
      } catch (Exception ex) {
        return false;
      }
    }

    return true;
  }

  public boolean newPrivilege(List list) {
    for (int i = 0; i < list.size(); ++i) {
      Aclprivilelist privilege = (Aclprivilelist)list.get(i);
      try {
        getHibernateTemplate().save(privilege);
        this.LOG.debug("添加访问权限成功：主体ID-->" + privilege.getOwnerid() + " 资源ID-->" + privilege.getWorkid() + " 权限ID-->" + privilege.getPurview() + " 资源类型-->" + privilege.getWorktype());
      } catch (Exception ex) {
        this.LOG.error("添加访问权限失败：主体ID-->" + privilege.getOwnerid() + " 资源ID-->" + privilege.getWorkid() + " 权限ID-->" + privilege.getPurview() + " 资源类型-->" + privilege.getWorktype());
      }
    }

    return true;
  }

  public boolean addResource(Aclprivileresource source) {
    try {
      getHibernateTemplate().save(source);
      this.LOG.debug("添加资源成功：" + source.getWorkname());
      return true;
    } catch (Exception ex) {
      this.LOG.error("添加资源" + source.getWorkname() + "失败,原因：" + ex.getMessage());
    }
    return false;
  }

  public boolean updateResource(Aclprivileresource source) {
    try {
      getHibernateTemplate().update(source);
      this.LOG.debug("更新资源成功：" + source.getWorkname());
      return true;
    } catch (Exception ex) {
      ex.printStackTrace();
      this.LOG.error("更新资源" + source.getWorkname() + "失败,原因：" + ex.getMessage());
    }return false;
  }

  public boolean deleteResource(Aclprivileresource source)
  {
    try {
      getHibernateTemplate().delete(source);
      this.LOG.debug("删除资源成功：" + source.getWorkname());
      return true;
    } catch (Exception ex) {
      this.LOG.error("删除资源" + source.getWorkname() + "失败,原因：" + ex.getMessage());
    }
    return false;
  }

  public boolean addResourceType(Aclprivileresourcetype sourcetype) {
    try {
      getHibernateTemplate().save(sourcetype);
      this.LOG.debug("添加资源类型成功 ：" + sourcetype.getWorkname());
      return true;
    } catch (Exception ex) {
      this.LOG.error("添加资源类型" + sourcetype.getWorkname() + "失败 ," + "  /n 原因：" + ex.getMessage());
    }
    return false;
  }

  public boolean updateResourceType(Aclprivileresourcetype sourcetype) {
    try {
      getHibernateTemplate().update(sourcetype);
      this.LOG.debug("更新资源成功 ：" + sourcetype.getWorkname());
      return true;
    } catch (Exception ex) {
      this.LOG.error("更新资源类型" + sourcetype.getWorkname() + "失败 ," + "  /n 原因：" + ex.getMessage());
    }
    return false;
  }

  public boolean deleteResourceType(Aclprivileresourcetype sourcetype) {
    try {
      getHibernateTemplate().delete(sourcetype);
      this.LOG.debug("删除资源类型成功 ：" + sourcetype.getWorkname());
      return true;
    } catch (Exception ex) {
      this.LOG.error("删除资源类型" + sourcetype.getWorkname() + "失败 ," + "  /n 原因：" + ex.getMessage());
    }
    return false;
  }

  public List getResourceTypeAttrByType(String categoryid) {
    try {
      List list = getHibernateTemplate().findByNamedQueryAndNamedParam("findAttrByType", "categoryid", categoryid);
      return list;
    } catch (Exception ex) {
      ex.printStackTrace();
    }
    return null;
  }

  public boolean addResourceTypeAttr(Aclprivleattribute attribute) {
    try {
      getHibernateTemplate().save(attribute);
      this.LOG.debug("添加资源类型属性成功 ：" + attribute.getArrname());
      return true;
    } catch (Exception ex) {
      this.LOG.error("添加资源类型属性" + attribute.getArrname() + "失败 ," + "  /n 原因：" + ex.getMessage());
    }
    return false;
  }

  public boolean updateResourceTypeAttr(Aclprivleattribute attribute) {
    try {
      getHibernateTemplate().update(attribute);
      this.LOG.debug("更新资源类型属性成功 ：" + attribute.getArrname());
      return true;
    } catch (Exception ex) {
      this.LOG.error("更新资源类型属性" + attribute.getArrname() + "失败 ," + "  /n 原因：" + ex.getMessage());
    }
    return false;
  }

  public boolean deleteResourceTypeAttr(Aclprivleattribute attribute) {
    try {
      getHibernateTemplate().delete(attribute);
      this.LOG.debug("删除资源类型属性成功 ：" + attribute.getArrname());
      return true;
    } catch (Exception ex) {
      this.LOG.error("删除资源类型属性" + attribute.getArrname() + "失败 ," + "  /n 原因：" + ex.getMessage());
    }
    return false;
  }

  public boolean addRole(Aclrole role) {
    try {
      getHibernateTemplate().save(role);
      this.LOG.debug("添加角色!" + role.getRolename());
      return true;
    } catch (Exception ex) {
      this.LOG.debug("添加角色" + role.getRolename() + "出错,原因：" + ex.getMessage());
    }
    return false;
  }

  public boolean updateRole(Aclrole role) {
    try {
      getHibernateTemplate().update(role);
      this.LOG.debug("更新" + role.getRolename() + "角色!" + role.getRolename());
      return true;
    } catch (Exception ex) {
      this.LOG.error("更新角色" + role.getRolename() + "失败，原因：" + ex.getStackTrace());
    }
    return false;
  }

  public boolean deleteRole(Aclrole role) {
    try {
      getHibernateTemplate().delete(role);
      this.LOG.debug("删除角色!" + role.getRolename());
      return true;
    } catch (Exception ex) {
      this.LOG.error("删除角色" + role.getRolename() + "失败，原因：" + ex.getStackTrace());
    }
    return false;
  }

  public Aclrole getRole(String roleid) {
    return (Aclrole)getHibernateTemplate().load(Aclrole.class, roleid);
  }

  public Aclapp getAppSysByAppID(String appid) {
    return (Aclapp)getHibernateTemplate().load(Aclapp.class, appid);
  }

  public boolean newAppSys(Aclapp app) {
    try {
      getHibernateTemplate().save(app);
      this.LOG.debug("添加应用系统：" + app.getAppname());
      return true;
    } catch (Exception ex) {
      this.LOG.error("添加应用系统" + app.getAppname() + "出错，原因：" + ex.getMessage());
    }
    return false;
  }

  public boolean updateAppSys(Aclapp app) {
    try {
      getHibernateTemplate().update(app);
      this.LOG.debug("更行应用系统：" + app.getAppname());
      return true;
    } catch (Exception ex) {
      this.LOG.error("更新应用系统" + app.getAppname() + "出错，原因：" + ex.getMessage());
    }
    return false;
  }

  public boolean deleteAppSys(Aclapp app) {
    try {
      getHibernateTemplate().delete(app);
      this.LOG.debug("删除应用系统：" + app.getAppname());
      return true;
    } catch (Exception ex) {
      this.LOG.error("删除应用系统" + app.getAppname() + "出错，原因：" + ex.getMessage());
    }
    return false;
  }

  public boolean newUsersRoleRelation(List ownerlist, Aclrole role) {
    for (int i = 0; i < ownerlist.size(); ++i) {
      Owner owner = (Owner)ownerlist.get(i);
      Acluserrole userrole = new Acluserrole();
      userrole.setRoleid(role.getRoleid());
      userrole.setUserid(owner.getId());
      try {
        getHibernateTemplate().save(userrole);
        this.LOG.debug("添加用户角色关系：" + owner.getOwnername() + "-->" + role.getRolename());
      } catch (Exception ex) {
        this.LOG.error("添加用户角色关系失败：" + owner.getOwnername() + "-->" + role.getRolename() + "原因：" + ex.getMessage());
        return false;
      }
    }

    return false;
  }

  public boolean newRolesUserRelation(List rolelist, Owner owner) {
    deleteUserRole(owner);
    for (int i = 0; i < rolelist.size(); ++i) {
      Acluserrole userrole = new Acluserrole();
      userrole.setRoleid(rolelist.get(i).toString());
      userrole.setUserid(owner.getId());
      try {
        getHibernateTemplate().save(userrole);
        this.LOG.debug("添加用户角色关系：" + owner.getOwnername() + "-->");
      } catch (Exception ex) {
        this.LOG.error("添加用户角色关系" + owner.getOwnername() + "-->" + "失败,原因：" + ex.getMessage());
        return false;
      }
    }

    return false;
  }

  public boolean deleteUserRole(Owner owner) {
    try {
      List list = getHibernateTemplate().findByNamedQueryAndNamedParam("queryRoleByUserid", "userid", owner.getId());
      getHibernateTemplate().deleteAll(list);
      return true;
    } catch (Exception ex) {
      this.LOG.debug("删除用户的角色关系" + owner.getOwnername() + "时出错， 原因：" + ex.getMessage());
    }
    return false;
  }

  public String getReferenceClass() {
    return null;
  }

  public String getDBConnectionUsername() {
    Session session = getSession();
    try {
      String dbname = session.connection().getMetaData().getUserName();
      return dbname;
    } catch (Exception ex) {
      ex.printStackTrace();
    }
    return null;
  }

  public String getNameBySourceId(String sourceid) {
    try {
      List list = getHibernateTemplate().findByNamedQueryAndNamedParam("queryOwnerBySourceId", "workid", sourceid);
      StringBuffer sb = new StringBuffer("");
      for (int i = 0; i < list.size(); ++i) {
        if (i == 0)
          sb.append(list.get(i));
        else {
          sb.append("," + list.get(i));
        }
      }

      List list2 = getHibernateTemplate().findByNamedQueryAndNamedParam("queryRoleBySourceId", "workid", sourceid);
      if (list.size() > 0) {
        for (int i = 0; i < list2.size(); ++i) {
          sb.append("," + list2.get(i));
        }
      }
      else {
        for (int i = 0; i < list.size(); ++i) {
          if (i == 0)
            sb.append(list2.get(i));
          else {
            sb.append("," + list2.get(i));
          }
        }
      }

      return sb.toString();
    } catch (Exception ex) {
      ex.printStackTrace();
    }
    return "";
  }

  public List getAppSysList() {
    List list = getHibernateTemplate().loadAll(Aclapp.class);
    return list;
  }

  public boolean addPrivilege2Owners(PrivilegeVO vo, List owneridlist) {
    for (int i = 0; i < owneridlist.size(); ++i) {
      Aclprivilelist privile = new Aclprivilelist();
      String ownerid = (String)owneridlist.get(i);
      privile.setOwnerid(ownerid);
      if ((vo.getPrivilegecode() != null) && (!vo.getPrivilegecode().equals(""))) {
        privile.setPurview(vo.getPrivilegecode());
      }
      privile.setWorkid(vo.getSourceid());
      if ((vo.getSourcetype() != null) && (!vo.getSourcetype().equals("")))
        privile.setWorktype(vo.getSourcetype());
      try
      {
        getHibernateTemplate().save(privile);
        this.LOG.debug("添加资源权限成功！");
      } catch (Exception ex) {
        ex.printStackTrace();
        this.LOG.error("添加资源权限失败！");
      }
    }

    return true;
  }

  public boolean addPrivilege2Roles(PrivilegeVO vo, List roleidlist) {
    for (int i = 0; i < roleidlist.size(); ++i) {
      Aclprivilelist privile = new Aclprivilelist();
      Aclrole role = (Aclrole)roleidlist.get(i);
      privile.setOwnerid(role.getRoleid());
      privile.setOwnertype(new Long(ACLContend.ROLE_FLAG.intValue()));
      privile.setPurview(vo.getPrivilegecode());
      privile.setWorkid(vo.getSourceid());
      privile.setWorktype(vo.getSourcetype());
      try {
        getHibernateTemplate().save(privile);
        this.LOG.debug("添加资源权限成功！角色ID：" + role.getRoleid() + "  资源ID：" + vo.getSourceid() + "  权限ID：" + vo.getPrivilegecode());
      } catch (Exception ex) {
        this.LOG.error("添加资源权限失败！主体ID：" + role.getRoleid() + "  资源ID：" + vo.getSourceid() + "  权限ID：" + vo.getPrivilegecode() + "\t  错误原因：" + ex.getMessage());
      }
    }

    return true;
  }

  public Aclapp getAppSysByAppcode(String appcode) {
    try {
      List list = getHibernateTemplate().findByNamedQueryAndNamedParam("queryAclappByAppcode", "appcode", appcode);
      if ((list != null) && (list.size() > 0))
        return (Aclapp)list.get(0);
    }
    catch (Exception exception) {
    }
    return null;
  }

  public List getAllResourceType() {
    try {
      return getHibernateTemplate().loadAll(Aclprivileresourcetype.class);
    } catch (Exception ex) {
      ex.printStackTrace();
    }
    return null;
  }

  public List getSourceListByType(String categoryid) {
    try {
      List list = getHibernateTemplate().findByNamedQueryAndNamedParam("querySourceByCategoryId", "categoryid", categoryid);
      return list;
    } catch (Exception ex) {
      ex.printStackTrace();
    }
    return null;
  }

  public void deleteCategoryPrivilege(String categoryid, String roleid) {
    try {
      List list = getHibernateTemplate().findByNamedQueryAndNamedParam("queryPrivilegeByCategoryId", new String[] { "categoryid", "ownerid" }, new Object[] { categoryid, roleid });
      getHibernateTemplate().deleteAll(list);
    } catch (Exception ex) {
      ex.printStackTrace();
    }
  }

  public List getCategoryPrivilege(String categoryid, String roleid) {
    try {
      List list = getHibernateTemplate().findByNamedQueryAndNamedParam("queryPrivilegeByCategoryId", new String[] { "categoryid", "ownerid" }, new Object[] { categoryid, roleid });
      return list;
    } catch (Exception ex) {
      ex.printStackTrace();
    }
    return null;
  }

  public List getSourceListByCategoryAndAppid(String categoryid, String appid) {
    try {
      List list = getHibernateTemplate().findByNamedQueryAndNamedParam("querySourceByCategoryAndAppid", new String[] { "categoryid", "appid" }, new Object[] { categoryid, appid });
      return list;
    } catch (Exception ex) {
      ex.printStackTrace();
    }
    return null;
  }

  public Aclprivileresourcetype getSourceTypeByTypecode(String typecode) {
    try {
      List list = getHibernateTemplate().findByNamedQueryAndNamedParam("querySourceTypeByTypecode", "workcode", typecode);
      if (list.size() > 0)
        return (Aclprivileresourcetype)list.get(0);
    }
    catch (Exception ex) {
      ex.printStackTrace();
    }
    return null;
  }

  public List getOwnerByRoleid(String roleid) {
    try {
      List list = getHibernateTemplate().findByNamedQueryAndNamedParam("queryUserByRoleid", "roleid", roleid);
      return list;
    } catch (Exception ex) {
      ex.printStackTrace();
    }
    return null;
  }

  public boolean deleteUserRoleRelation(String userid, String roleid) {
    try {
      List list = getHibernateTemplate().findByNamedQueryAndNamedParam("queryRelatonByUseridAndRoleid", new String[] { "userid", "roleid" }, new Object[] { userid, roleid });
      getHibernateTemplate().deleteAll(list);
    } catch (Exception ex) {
      ex.printStackTrace();
      return false;
    }
    return false;
  }

  public Aclprivileresource getResourceBySourceid(String sourceid) {
    try {
      Aclprivileresource source = (Aclprivileresource)getHibernateTemplate().load(Aclprivileresource.class, sourceid);
      return source;
    } catch (Exception ex) {
      ex.printStackTrace();
    }
    return null;
  }

  public Aclprivileresource getResourceBySourcecode(String sourcecode) {
    try {
      List list = getHibernateTemplate().findByNamedQueryAndNamedParam("querySourceByRegname", "regname", sourcecode);
      if (list.size() > 0)
        return (Aclprivileresource)list.get(0);
    }
    catch (Exception ex) {
      ex.printStackTrace();
      return null;
    }
    return null;
  }

  public Aclprivleattribute getAttributeByAttributeid(String attributeid) {
    try {
      Aclprivleattribute attribute = (Aclprivleattribute)getHibernateTemplate().load(Aclprivleattribute.class, attributeid);
      return attribute;
    } catch (Exception ex) {
      ex.printStackTrace();
    }
    return null;
  }

  public Aclprivileresourcetype getResourceTypeByTypeid(String typeid) {
    try {
      Aclprivileresourcetype type = (Aclprivileresourcetype)getHibernateTemplate().load(Aclprivileresourcetype.class, typeid);
      return type;
    } catch (Exception ex) {
      ex.printStackTrace();
    }
    return null;
  }

  public Aclprivileresourcetype getResourceTypeByTypecode(String typecode) {
    return null;
  }

  public List getPrivilegeByUserIdAndSourcecode(String userid, String sourcecode) {
    try {
      List list = getHibernateTemplate().findByNamedQueryAndNamedParam("queryPrivileByUseridAndSourcecode", new String[] { "userid", "workid" }, new Object[] { userid, sourcecode });
      return list;
    } catch (Exception ex) {
      ex.printStackTrace();
    }
    return null;
  }

  public List getPrivilegeByLoginnameAndSourcecode(String loginname, String sourcecode) {
    try {
      List list = getHibernateTemplate().findByNamedQueryAndNamedParam("queryPrivileByLoginnameAndSourcecode", new String[] { "loginname", "workid" }, new Object[] { loginname, sourcecode });
      return list;
    } catch (Exception ex) {
      ex.printStackTrace();
    }
    return null;
  }

  public Aclrole getRoleByRolecode(String rolecode) {
    try {
      List list = getHibernateTemplate().findByNamedQueryAndNamedParam("queryRoleByRolecode", "rolecode", rolecode);
      if ((list != null) && (list.size() > 0))
        return (Aclrole)list.get(0);
    }
    catch (Exception ex) {
      ex.printStackTrace();
      return null;
    }
    return null;
  }

  public Integer getUserRowCountExceptRole(String roleid, String nameen, String namecn) {
    try {
      return (Integer)getHibernateTemplate().findByNamedQueryAndNamedParam("queryCountUserExceptRoleid", new String[] { "roleid", "nameen", "namecn" }, new Object[] { roleid, nameen, namecn }).get(0);
    } catch (Exception ex) {
      ex.printStackTrace();
    }
    return new Integer("0");
  }

  public List getUserByPageExceptRole(int nFirst, int nPageSize, String roleid, String nameen, String namecn) {
    try {
      List list = findPageByNamedQueryAndNamedParam("queryUserExceptRoleid", new String[] { "roleid", "nameen", "namecn" }, new Object[] { roleid, nameen, namecn }, nFirst, nPageSize);
      return list;
    } catch (Exception ex) {
      ex.printStackTrace();
    }
    return null;
  }

  public boolean newUseridsRoleRelation(List owneridlist, String roleid) {
    for (int i = 0; i < owneridlist.size(); ++i) {
      Acluserrole userrole = new Acluserrole();
      userrole.setRoleid(roleid);
      userrole.setUserid((String)owneridlist.get(i));
      try {
        getHibernateTemplate().save(userrole);
      } catch (Exception ex) {
        ex.printStackTrace();
        return false;
      }
    }

    return true;
  }

  public Aclprivleattribute getAttributeByAttrcodeAndCategoryid(String attrcode, String categoryid) {
    try {
      List list = findByNamedQueryAndNamedParam("findAttrByAttrcodeAndCategoryid", new String[] { "categoryid", "attrcode" }, new Object[] { categoryid, attrcode });
      if (list.size() > 0)
        return (Aclprivleattribute)list.get(0);
    }
    catch (Exception ex) {
      ex.printStackTrace();
      return null;
    }
    return null;
  }
}