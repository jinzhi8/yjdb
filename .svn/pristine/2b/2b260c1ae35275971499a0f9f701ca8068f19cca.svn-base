package com.kizsoft.commons.uum.dao.hibernate;

import com.kizsoft.commons.commons.db.ConnectionProvider;
import com.kizsoft.commons.uum.dao.IOwnerDAO;
import com.kizsoft.commons.uum.pojo.Managerdept;
import com.kizsoft.commons.uum.pojo.Owner;
import com.kizsoft.commons.uum.pojo.Ownerrelation;
import com.kizsoft.commons.uum.service.IUUMService;
import com.kizsoft.commons.uum.utils.UUMContend;
import java.io.PrintStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import net.sf.hibernate.Session;
import org.apache.log4j.Logger;
import org.springframework.orm.hibernate.HibernateTemplate;

public class OwnerDAO extends BaseDAO
  implements IOwnerDAO
{
  Logger LOG;
  Owner owner;

  public OwnerDAO()
  {
    this.LOG = Logger.getLogger(OwnerDAO.class);
    this.owner = new Owner();
  }

  public List getTopLevel() {
    List list = new ArrayList();
    try {
      list = getHibernateTemplate().findByNamedQuery("findTopTree");
    } catch (Exception ex) {
      ex.printStackTrace();
    }
    return list;
  }

  public List getTopTreeByUserId(String userid) {
    Owner owner = getByOwnerid(userid);
    List list = new ArrayList();
    if (UUMContend.SYSTEM_MANAGER.equals(owner.getType())) {
      try {
        list = getHibernateTemplate().findByNamedQuery("findTopTree");
      } catch (Exception ex) {
        ex.printStackTrace();
      }
      return list;
    }
    if (owner.getType().equals(UUMContend.DEPT_MANAGER)) {
      try {
        list = getHibernateTemplate().findByNamedQueryAndNamedParam("findManagedDept", "userid", userid);
      } catch (Exception ex) {
        ex.printStackTrace();
      }
      return list;
    }
    this.LOG.warn("SYSTEMEXCEPTION:" + owner.getOwnername() + "对不起，你没有访问用户管理的权限，请与系统管理员联系!");
    try {
      throw new Exception("SystemExcption: 你没有访问该模块的权限，请与系统管理员联系");
    } catch (Exception e) {
      e.printStackTrace();
    }
    return null;
  }

  public Owner getByOwnerid(String id) {
    List list = new ArrayList();
    try {
      list = getHibernateTemplate().findByNamedQueryAndNamedParam("findOwnerByOwnerid", "id", id);
    } catch (Exception e) {
      e.printStackTrace();
    }
    if ((list != null) && (list.size() > 0)) {
      return (Owner)list.get(0);
    }
    return null;
  }

  public boolean isExistOwner(String ownername, String flag) {
    List list = getHibernateTemplate().findByNamedQueryAndNamedParam("isExistOwner", new String[] { "ownercode", "flag" }, new Object[] { ownername, flag });
    return (list != null) && (list.size() > 0);
  }

  public Owner getByOwnercode(String ownercode) {
    List list = getHibernateTemplate().findByNamedQueryAndNamedParam("findOwnerByOwnercode", "ownercode", ownercode);
    if ((list != null) && (list.size() > 0)) {
      return (Owner)list.get(0);
    }
    return null;
  }

  public Owner getByOwnername(String ownername) {
    List list = getHibernateTemplate().findByNamedQueryAndNamedParam("findOwnerByOwnername", "ownername", ownername);
    if ((list != null) && (list.size() > 0)) {
      return (Owner)list.get(0);
    }
    return null;
  }

  public Owner getByUserNameAndPass(String username, String pass) {
    List list = new ArrayList();
    try {
      list = getHibernateTemplate().findByNamedQueryAndNamedParam("findOwnerByOwnercodeAndPass", new String[] { "ownercode", "password" }, new Object[] { username, pass });
    } catch (Exception ex) {
      ex.printStackTrace();
    }
    if ((list != null) && (list.size() > 0)) {
      Owner owner = (Owner)list.get(0);
      return owner;
    }
    return null;
  }

  public List getChildByOwnerId(String ownerid)
  {
    List list = new ArrayList();
    try {
      list = getHibernateTemplate().findByNamedQueryAndNamedParam("findChildByOwner", "id", ownerid);
    } catch (Exception ex) {
      ex.printStackTrace();
    }
    return list;
  }

  public List getDeptChildByOwnerId(String ownerid) {
    List list = new ArrayList();
    try {
      list = getHibernateTemplate().findByNamedQueryAndNamedParam("findDeptChildByOwner", "id", ownerid);
    } catch (Exception ex) {
      ex.printStackTrace();
    }
    return list;
  }

  public List getUserChildByDeptId(String deptid) {
    List list = new ArrayList();
    try {
      list = getHibernateTemplate().findByNamedQueryAndNamedParam("findUserChildByDeptId", "id", deptid);
    } catch (Exception ex) {
      ex.printStackTrace();
    }
    return list;
  }

  public List getUserChildByDeptId(String deptid, int rows, int pageno) {
    List list = getUserChildByDeptId(deptid);
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

  public List getNoDeptUser() {
    List list = new ArrayList();
    try {
      list = getHibernateTemplate().findByNamedQuery("getNoDeptUser");
    } catch (Exception ex) {
      ex.printStackTrace();
    }
    return list;
  }

  public List getAllChildUserByOwnerId(String deptid) {
    List userlist = new ArrayList();
    userlist = getChild(deptid, userlist);
    return userlist;
  }

  public List getAllChildDeptByOwnerId(String ownerId) {
    List userlist = new ArrayList();
    String sql = "select level,t.ownerid,t.orderid,o.ownername,o.flag  from ownerrelation t left join owner o on t.ownerid=o.id where o.flag >1 start with t.ownerid = ? CONNECT BY PRIOR t.ownerid = t.parentid  ";
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    IUUMService uumService = UUMContend.getUUMService();
    Owner owner = null;
    try
    {
      conn = ConnectionProvider.getConnection();
      pstmt = conn.prepareStatement(sql);
      pstmt.setString(1, ownerId);
      rs = pstmt.executeQuery();
      while (rs.next())
      {
        owner = uumService.getOwnerByOwnerid(rs.getString("ownerid"));
        userlist.add(owner);
      }
    }
    catch (Exception e)
    {
      e.printStackTrace();
      Object localObject1 = null;
     } finally { ConnectionProvider.close(conn, pstmt, rs);
    }
    return userlist;
  }

  public List getAllChildByOwnerId(String ownerId) {
    List userlist = new ArrayList();
    String sql = "select t.ownerid from ownerrelation t start with t.ownerid = ? CONNECT BY PRIOR t.ownerid = t.parentid ";
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    IUUMService uumService = UUMContend.getUUMService();
    Owner owner = null;
    try
    {
      conn = ConnectionProvider.getConnection();
      pstmt = conn.prepareStatement(sql);
      pstmt.setString(1, ownerId);
      rs = pstmt.executeQuery();
      while (rs.next())
      {
        owner = uumService.getOwnerByOwnerid(rs.getString("ownerid"));
        userlist.add(owner);
      }
    }
    catch (Exception e)
    {
      e.printStackTrace();
      Object localObject1 = null;
     } finally { ConnectionProvider.close(conn, pstmt, rs);
    }
    return userlist;
  }

  private List getChild(String parentId, List userlist) {
    List childlist = getHibernateTemplate().findByNamedQueryAndNamedParam("findChildByOwner", "id", parentId);
    Owner childowner = null;
    for (int i = 0; i < childlist.size(); i++) {
      childowner = null;
      childowner = (Owner)childlist.get(i);
      if (childowner.getFlag().equals(UUMContend.USER_FLAG))
        userlist.add(childowner);
      else {
        getChild(childowner.getId(), userlist);
      }
    }

    return userlist;
  }

  public boolean removeUserManagedDept(String userid) {
    try {
      List list = getHibernateTemplate().findByNamedQueryAndNamedParam("getDeptListByUserId", "userid", userid);
      getHibernateTemplate().deleteAll(list);
    } catch (Exception ex) {
      ex.printStackTrace();
      return false;
    }
    return true;
  }

  public boolean updateUserManagedDept(List deptids, String userid) {
    removeUserManagedDept(userid);
    for (int i = 0; i < deptids.size(); i++) {
      Managerdept managerdept = new Managerdept();
      managerdept.setDeptid((String)deptids.get(i));
      managerdept.setUserid(userid);
      try {
        getHibernateTemplate().save(managerdept);
      } catch (Exception ex) {
        ex.printStackTrace();
      }
    }

    return true;
  }

  public List getParentsByOwnerId(String userid) {
    List deptlist = new ArrayList();
    deptlist = getParent(userid, deptlist);
    return deptlist;
  }

  private List getParent(String childId, List deptlist) {
    List parentlist = getHibernateTemplate().findByNamedQueryAndNamedParam("findParentByUserId", "id", childId);
    for (int i = 0; i < parentlist.size(); i++) {
      Owner parentowner = (Owner)parentlist.get(i);
      deptlist.add(parentowner);
      getParent(parentowner.getId(), deptlist);
    }

    return deptlist;
  }

  public boolean deleteOwnerByIds(List idlist) {
    for (int i = 0; i < idlist.size(); i++) {
      Owner owner = getByOwnerid((String)idlist.get(i));
      if (owner.getFlag().toString().equals(UUMContend.ORGANIZE_FLAG.toString()))
        updateDeptSort(owner);
      deleteAllRelationByOwner(owner.getId());
      deleteAllRoleRelationByOwner(owner.getId());
      getHibernateTemplate().delete(owner);
    }

    return true;
  }

  private void updateDeptSort(Owner owner) {
    Session session = null;
    Connection conn = null;
    session = getSession();
    try {
      conn = session.connection();
      updateSQL(" update owner o set o.order_num= order_num-1 where order_num >? and o.flag='" + UUMContend.ORGANIZE_FLAG + "'", owner.getOrdernum(), conn);
    } catch (Exception ex) {
      ex.printStackTrace();
    }
  }

  public List getAllUser() {
    return getHibernateTemplate().findByNamedQueryAndNamedParam("getAllUser", "flag", "1");
  }

  public List getManagedDept(String userid) {
    List list = new ArrayList();
    try {
      list = getHibernateTemplate().findByNamedQueryAndNamedParam("findManagedDept", "userid", userid);
    } catch (Exception ex) {
      ex.printStackTrace();
    }
    return list;
  }

  public boolean newOwner(Owner owner) {
    if (owner.getFlag().toString().equals(UUMContend.ORGANIZE_FLAG.toString())) {
      Integer maxOrder = new Integer(0);
      try {
        maxOrder = (Integer)findByNamedQueryAndNamedParam("findOrderByDeptid", "flag", UUMContend.ORGANIZE_FLAG).get(0);
      } catch (Exception exception) {
      }
      if (maxOrder == null)
        maxOrder = new Integer(0);
      owner.setOrdernum(new Integer(maxOrder.intValue() + 1));
    }
    getHibernateTemplate().save(owner);
    this.LOG.debug("添加用户：" + owner.getOwnername());
    return true;
  }

  public boolean updateOwner(Owner owner) {
    getHibernateTemplate().update(owner);
    this.LOG.debug("修改用户信息：" + owner.getOwnername());
    return false;
  }

  public boolean newRelation(String parentid, String childid) {
    Ownerrelation relation = new Ownerrelation();
    Integer maxOrder = new Integer(0);
    try {
      maxOrder = (Integer)findByNamedQueryAndNamedParam("getMaxOrderByParentId", "parentid", parentid).get(0);
    } catch (Exception exception) {
    }
    if (maxOrder == null)
      maxOrder = new Integer(0);
    relation.setParentid(parentid);
    relation.setOwnerid(childid);
    relation.setRelation("1");
    relation.setOrderid(new Integer(maxOrder.intValue() + 1));
    getHibernateTemplate().save(relation);
    return true;
  }

  public void initUserPassword(List useridlist, String password) {
    for (int i = 0; i < useridlist.size(); i++) {
      Owner owner = getByOwnerid(useridlist.get(i).toString());
      owner.setPassword(password);
      getHibernateTemplate().save(owner);
      this.LOG.debug("初始化用户密码：" + owner.getOwnername());
    }
  }

  public boolean swapOwner(String childid, String parentid)
  {
    List list = findByNamedQueryAndNamedParam("findRelationByOwnerParent", new String[] { "ownerid", "parentid" }, new Object[] { childid, parentid });
    deleteAll(list);
    deleteAllRoleRelationByOwner(childid);
    return true;
  }

  public boolean invokeOwner(String childid, String parentid) {
    int orderid = ((Integer)findByNamedQueryAndNamedParam("findRelationOrderByParentid", "parentid", parentid).get(0)).intValue();
    Ownerrelation relation = new Ownerrelation();
    relation.setOwnerid(childid);
    relation.setParentid(parentid);
    relation.setRelation("1");
    relation.setOrderid(new Integer(orderid + 1));
    getHibernateTemplate().save(relation);
    return true;
  }

  private void deleteAllRelationByOwner(String ownerid) {
    try {
      List list = findByNamedQueryAndNamedParam("findOwnerRelationByOwner", new String[] { "ownerid", "parentid" }, new Object[] { ownerid, ownerid });
      if ((list != null) && (list.size() > 0))
        deleteAll(list);
    } catch (Exception ex) {
      System.out.println("delete success===deleteAllRelationByOwner");
    }
  }

  private void deleteAllRoleRelationByOwner(String ownerid) {
    try {
      List list = findByNamedQueryAndNamedParam("findRoleRelationByOwner", "ownerid", ownerid);
      if ((list != null) && (list.size() > 0))
        deleteAll(list);
    } catch (Exception ex) {
      System.out.println("delte success===deleteAllRoleRelationByOwner");
    }
  }

  public String getReferenceClass() {
    return null;
  }

  public Integer getChildUserRowCount(String deptid) {
    List list = getUserChildByDeptId(deptid);
    return new Integer(list.size());
  }

  public List getChildUserByPage(String parentId, Integer begin, Integer rowperpage) {
    return null;
  }

  public Owner getUserGroupName(String ownercode) {
    getParentOwner(ownercode);
    if (this.owner.getOwnername() == null) {
      this.owner.setOwnercode("others");
      this.owner.setOwnername("其他");
    }
    return this.owner;
  }

  private void getParentOwner(String ownercode) {
    List parentlist = getHibernateTemplate().findByNamedQueryAndNamedParam("findParentByUserName", "ownercode", ownercode);
    if (parentlist.size() > 0) {
      Owner parentowner = (Owner)parentlist.get(0);
      this.owner = parentowner;
      getParentOwner(parentowner.getOwnercode());
    }
  }

  public Owner getUserParentDept(String username) {
    List parentlist = getHibernateTemplate().findByNamedQueryAndNamedParam("findParentByUserName", "ownercode", username);
    Owner owner = new Owner();
    if (parentlist.size() > 0) {
      return (Owner)parentlist.get(0);
    }
    owner.setOwnername("无所属部门");
    return owner;
  }

  public List getNoDeptUser(int rows, int pageno)
  {
    List list = getNoDeptUser();
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

  public boolean upNode(String id, String parentid) {
    Owner owner = getByOwnerid(id);
    if (owner.getFlag().toString().equals(UUMContend.ORGANIZE_FLAG.toString()))
      try {
        List preownerlist = getHibernateTemplate().findByNamedQueryAndNamedParam("findPreOrderNum", "ordernum", owner.getOrdernum());
        if ((preownerlist != null) && (preownerlist.size() > 0)) {
          Owner preowner = (Owner)preownerlist.get(0);
          Integer preordernum = preowner.getOrdernum();
          preowner.setOrdernum(owner.getOrdernum());
          owner.setOrdernum(preordernum);
          getHibernateTemplate().update(owner);
          getHibernateTemplate().update(preowner);
        }
        return true;
      } catch (Exception ex) {
        ex.printStackTrace();
      }
    else
      try {
        Ownerrelation ownerrelation = (Ownerrelation)getHibernateTemplate().findByNamedQueryAndNamedParam("findRelationByIDAndParentId", new String[] { "id", "parentid" }, new Object[] { id, parentid }).get(0);
        List preownerlist = getHibernateTemplate().findByNamedQueryAndNamedParam("findPreOrderNumByParent", new String[] { "ordernum", "parentid", "parentid" }, new Object[] { ownerrelation.getOrderid(), parentid, parentid });
        if ((preownerlist != null) && (preownerlist.size() > 0)) {
          Ownerrelation prerelation = (Ownerrelation)preownerlist.get(0);
          Integer preordernum = prerelation.getOrderid();
          prerelation.setOrderid(ownerrelation.getOrderid());
          ownerrelation.setOrderid(preordernum);
          getHibernateTemplate().update(prerelation);
          getHibernateTemplate().update(ownerrelation);
        }
        return true;
      } catch (Exception ex) {
        ex.printStackTrace();
      }
    return false;
  }

  public boolean downNode(String id, String parentid) {
    Owner owner = getByOwnerid(id);
    if (owner.getFlag().toString().equals(UUMContend.ORGANIZE_FLAG.toString()))
      try {
        List nextownerlist = getHibernateTemplate().findByNamedQueryAndNamedParam("findNextOrderNum", "ordernum", owner.getOrdernum());
        if ((nextownerlist != null) && (nextownerlist.size() > 0)) {
          Owner nextowner = (Owner)nextownerlist.get(0);
          Integer nexordernum = nextowner.getOrdernum();
          nextowner.setOrdernum(owner.getOrdernum());
          owner.setOrdernum(nexordernum);
          getHibernateTemplate().update(owner);
          getHibernateTemplate().update(nextowner);
        }
        return true;
      } catch (Exception ex) {
        ex.printStackTrace();
      }
    else
      try {
        Ownerrelation ownerrelation = (Ownerrelation)getHibernateTemplate().findByNamedQueryAndNamedParam("findRelationByIDAndParentId", new String[] { "id", "parentid" }, new Object[] { id, parentid }).get(0);
        List preownerlist = getHibernateTemplate().findByNamedQueryAndNamedParam("findNextOrderNumByParent", new String[] { "ordernum", "parentid", "parentid" }, new Object[] { ownerrelation.getOrderid(), parentid, parentid });
        if ((preownerlist != null) && (preownerlist.size() > 0)) {
          Ownerrelation prerelation = (Ownerrelation)preownerlist.get(0);
          Integer preordernum = prerelation.getOrderid();
          prerelation.setOrderid(ownerrelation.getOrderid());
          ownerrelation.setOrderid(preordernum);
          getHibernateTemplate().update(prerelation);
          getHibernateTemplate().update(ownerrelation);
        }
        return true;
      } catch (Exception ex) {
        ex.printStackTrace();
      }
    return false;
  }
}