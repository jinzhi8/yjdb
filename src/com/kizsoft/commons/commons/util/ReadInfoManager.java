package com.kizsoft.commons.commons.util;

import com.kizsoft.commons.commons.db.ConnectionProvider;
import com.kizsoft.commons.commons.user.User;
import com.kizsoft.commons.commons.user.UserManager;
import com.kizsoft.commons.commons.user.UserManagerFactory;
import com.kizsoft.commons.error.ErrorMessage;
import com.kizsoft.commons.util.UUIDGenerator;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import org.apache.log4j.Logger;

public class ReadInfoManager
{
  final Logger log = Logger.getLogger(super.getClass().getName());

  public String addReadInfo(ReadInfo readInfo)
    throws ErrorMessage
  {
    try
    {
      return insertReadInfo(readInfo);
    } catch (Exception ex) {
      String err = "远程异常错误:当调用往数据库中添加公告回复信息的方法时发生了远程异常错误";
      this.log.error(err);
      this.log.error(ex);
      throw new ErrorMessage(err);
    }
  }

  public Collection getAllReadInfoByUnid(String id) throws ErrorMessage
  {
    try {
      return selectAllReadInfoByUnid(id, "asc");
    } catch (Exception ex) {
      String err = "远程异常错误:当调用根据公告编号取的所有公告阅读的方法时发生了远程异常错误";
      this.log.error(err);
      this.log.error(ex);
      throw new ErrorMessage(err);
    }
  }

  public Collection getAllReadInfoByUnid(String id, String order) throws ErrorMessage
  {
    try {
      return selectAllReadInfoByUnid(id, order);
    } catch (Exception ex) {
      String err = "远程异常错误:当调用根据公告编号取的所有公告阅读的方法时发生了远程异常错误";
      this.log.error(err);
      this.log.error(ex);
      throw new ErrorMessage(err);
    }
  }

  public ReadInfo getMeetingReadByReadUnid(String readUnid) throws ErrorMessage
  {
    try {
      return selectMeetingReadByReadUnid(readUnid);
    } catch (Exception ex) {
      String err = "远程异常错误:当调用根据公告编号取的所有公告阅读的方法时发生了远程异常错误";
      this.log.error(err);
      this.log.error(ex);
      throw new ErrorMessage(err);
    }
  }

  public boolean getReadInfoFlag(String id, String userID, String groupID)
    throws ErrorMessage
  {
    try
    {
      return checkReadFlag(id, userID, groupID);
    } catch (Exception ex) {
      String err = "远程异常错误:当调用核查公告阅读标志时发生了远程异常错误";
      ex.printStackTrace();
      throw new ErrorMessage(err);
    }
  }

  public boolean getReadInfoFlag_User(String id, String userID, String groupID)
    throws ErrorMessage
  {
    try
    {
      return checkReadFlag_User(id, userID, groupID);
    } catch (Exception ex) {
      String err = "远程异常错误:当调用核查公告阅读标志时发生了远程异常错误";
      this.log.error(err);
      this.log.error(ex);
      throw new ErrorMessage(err);
    }
  }

  private String insertReadInfo(ReadInfo readInfo)
    throws ErrorMessage
  {
    Connection con = null;
    PreparedStatement pts = null;
    int ret = 0;

    String readunid = null;

    String sql = " INSERT INTO readinfo(id,readunid,readdepartmentid,readdepartmentname,readmanid,readmanname,readtime,replycontent)  VALUES(?,?,?,?,?,?,?,?) ";
    try
    {
      con = ConnectionProvider.getConnection();
      readunid = UUIDGenerator.getUUID();
      pts = con.prepareStatement(sql);
      pts.setString(1, readInfo.getId());
      pts.setString(2, readunid);
      pts.setString(3, readInfo.getReadDepartmentID());
      pts.setString(4, readInfo.getReadDepartmentName());
      pts.setString(5, readInfo.getReadManID());
      pts.setString(6, readInfo.getReadManName());
      pts.setTimestamp(7, new Timestamp(readInfo.getReadTime().getTime()));
      pts.setString(8, readInfo.getReplyContent());
      ret = pts.executeUpdate();

      if (ret == 1) {
        con.commit();
        String str1 = readInfo.getReadUnid();
        return str1;
      }
      con.rollback();
      String err = "数据库操作错误:插入新的公告阅读情况信息不成功";

      throw new ErrorMessage(err);
    }
    catch (SQLException e) {
      try {
        con.rollback();
      } catch (SQLException ex) {
        String err = "数据库操作出错:数据库回滚时出现错误";
        this.log.error(err);
        this.log.error(ex);
        throw new ErrorMessage(err);
      }
      String err = "数据库操作出错:插入新的公告阅读情况信息时出现错误";
      this.log.error(err);

      throw new ErrorMessage(err);
    } catch (Exception e) {
      String err = "生成阅读标识时出错";
      this.log.error(err);

      throw new ErrorMessage(err);
    } finally {
      ConnectionProvider.close(con, pts);
    }
  }

  private Collection selectAllReadInfoByUnid(String id, String order) throws ErrorMessage
  {
    if (id == null) {
      return null;
    }
    if ((order == null) || ("".equals(order))) {
      order = "asc";
    }

    Connection con = null;
    PreparedStatement pts = null;
    Statement stm = null;
    ResultSet rs = null;
    int ret = 0;

    ArrayList altReadInfo = new ArrayList();
    String sql = " SELECT ID,READUNID,READDEPARTMENTID,READDEPARTMENTNAME,READMANID,READMANNAME,READTIME,REPLYCONTENT  FROM READINFO  WHERE ( ID = ? )  ORDER BY readtime ASC ";
    try
    {
      con = ConnectionProvider.getConnection();
      pts = con.prepareStatement(sql);
      pts.setString(1, id);
      rs = pts.executeQuery();

      while (rs.next())
      {
        ReadInfo readInfo = new ReadInfo();
        readInfo.setId(rs.getString("id"));
        readInfo.setReadUnid(rs.getString("readunid"));
        readInfo.setReadDepartmentID(rs.getString("readdepartmentid"));
        readInfo.setReadDepartmentName(rs.getString("readdepartmentname"));
        if (StringHelper.isNull(readInfo.getReadDepartmentName())) {
          User userInfo = null;
          try {
            userInfo = UserManagerFactory.getUserManager().findUser(readInfo.getReadDepartmentID());
          } catch (Exception localException) {
          }
          if (userInfo != null) {
            readInfo.setReadDepartmentName(userInfo.getUsername());
          }
        }
        readInfo.setReadManID(rs.getString("readmanid"));
        readInfo.setReadManName(rs.getString("readmanname"));
        if (StringHelper.isNull(readInfo.getReadManName())) {
          User userInfo = null;
          try {
            userInfo = UserManagerFactory.getUserManager().findUser(readInfo.getReadManID());
          } catch (Exception localException1) {
          }
          if (userInfo != null) {
            readInfo.setReadManName(userInfo.getUsername());
          }
        }
        readInfo.setReadTime(rs.getTimestamp("readtime"));
        readInfo.setReplyContent(rs.getString("replycontent"));
        altReadInfo.add(readInfo);
      }
      return altReadInfo;
    } catch (SQLException e) {
      String err = "数据库操作出错:根据公告编号取公告阅读信息时出现错误";
      this.log.error(err);

      throw new ErrorMessage(err);
    } finally {
      ConnectionProvider.close(con, pts, rs);
    }
  }

  private ReadInfo selectMeetingReadByReadUnid(String readUnid) throws ErrorMessage
  {
    if (readUnid == null) {
      return null;
    }

    Connection con = null;
    PreparedStatement pts = null;
    Statement stm = null;
    ResultSet rs = null;
    int ret = 0;

    String sql = " SELECT id,readunid,readmanid,readmanname,readtime,readdepartmentid,readdepartmentname,replycontent  FROM readinfo  WHERE ( readunid = ? ) ";
    try
    {
      con = ConnectionProvider.getConnection();
      pts = con.prepareStatement(sql);
      pts.setString(1, readUnid);
      rs = pts.executeQuery();

      ReadInfo meetingReadInfo = new ReadInfo();
      if (rs.next()) {
        meetingReadInfo.setId(rs.getString("id"));
        meetingReadInfo.setReadUnid(rs.getString("readunid"));
        meetingReadInfo.setReadDepartmentID(rs.getString("readdepartmentid"));
        meetingReadInfo.setReadDepartmentName(rs.getString("readdepartmentname"));
        if (StringHelper.isNull(meetingReadInfo.getReadDepartmentName())) {
          User userInfo = null;
          try {
            userInfo = UserManagerFactory.getUserManager().findUser(meetingReadInfo.getReadDepartmentID());
          } catch (Exception localException) {
          }
          if (userInfo != null) {
            meetingReadInfo.setReadDepartmentName(userInfo.getUsername());
          }
        }
        meetingReadInfo.setReadManID(rs.getString("readmanid"));
        meetingReadInfo.setReadManName(rs.getString("readmanname"));
        if (StringHelper.isNull(meetingReadInfo.getReadManName())) {
          User userInfo = null;
          try {
            userInfo = UserManagerFactory.getUserManager().findUser(meetingReadInfo.getReadManID());
          } catch (Exception localException1) {
          }
          if (userInfo != null) {
            meetingReadInfo.setReadManName(userInfo.getUsername());
          }
        }
        meetingReadInfo.setReadTime(rs.getTimestamp("readtime"));
        meetingReadInfo.setReplyContent(rs.getString("replycontent"));
      }

      return meetingReadInfo;
    } catch (SQLException e) {
      String err = "数据库操作出错:根据公告阅读编号取公告阅读信息时出现错误";
      this.log.error(err);

      throw new ErrorMessage(err);
    } finally {
      ConnectionProvider.close(con, pts, rs);
    }
  }

  private boolean checkReadFlag(String id, String userID, String groupID)
    throws ErrorMessage
  {
    if ((id == null) || (userID == null) || (groupID == null)) {
      return false;
    }

    Connection con = null;
    PreparedStatement pts = null;
    Statement stm = null;
    ResultSet rs = null;
    int ret = 0;

    boolean flag = false;
    String sql = "SELECT count(*) FROM readinfo  WHERE ( id = ? ) AND ( ( readmanid = ? ) OR  ( readdepartmentid = ?) ) ";
    try
    {
      con = ConnectionProvider.getConnection();
      pts = con.prepareStatement(sql);
      pts.setString(1, id);
      pts.setString(2, userID);
      pts.setString(3, groupID);
      rs = pts.executeQuery();

      if (rs.next()) {
        int count = rs.getInt(1);
        if (count > 0) {
          flag = true;
        }
      }

      return flag;
    } catch (SQLException e) {
      String err = "数据库操作出错:核查公告阅读标志时出现错误";
      this.log.error(err);

      throw new ErrorMessage(err);
    } finally {
      ConnectionProvider.close(con, pts, rs);
    }
  }

  private boolean checkReadFlag_User(String id, String userID, String groupID)
    throws ErrorMessage
  {
    if ((id == null) || (userID == null) || (groupID == null)) {
      return false;
    }

    Connection con = null;
    PreparedStatement pts = null;
    Statement stm = null;
    ResultSet rs = null;
    int ret = 0;

    boolean flag = false;
    String sql = "SELECT count(*) FROM readinfo WHERE ( id = ? ) AND ( readmanid = ? ) ";
    try
    {
      con = ConnectionProvider.getConnection();
      pts = con.prepareStatement(sql);
      pts.setString(1, id);
      pts.setString(2, userID);
      rs = pts.executeQuery();

      if (rs.next()) {
        int count = rs.getInt(1);
        if (count > 0) {
          flag = true;
        }
      }

      return flag;
    } catch (SQLException e) {
      String err = "数据库操作出错:核查公告阅读标志时出现错误";
      this.log.error(err);

      throw new ErrorMessage(err);
    } finally {
      ConnectionProvider.close(con, pts, rs);
    }
  }
}