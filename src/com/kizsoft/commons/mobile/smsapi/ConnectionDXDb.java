package com.kizsoft.commons.mobile.smsapi;

import java.io.PrintStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class ConnectionDXDb
{
  public static Connection getConnection()
    throws SQLException
  {
    Connection conn = null;
    try
    {
      Class.forName("org.logicalcobwebs.proxool.ProxoolDriver");
      conn = DriverManager.getConnection("proxool.dx");
      System.out.println("proxool.dx");
    }
    catch (Exception ex)
    {
      ex.printStackTrace();
    }
    return conn;
  }



  public static void close(Connection conn, Statement stmt, ResultSet rs)
  {
    try
    {
      if ((rs != null) && (!rs.isClosed())) {
        rs.close();
      }
      if ((stmt != null) && (!stmt.isClosed())) {
        stmt.close();
      }
      if ((conn != null) && (!conn.isClosed()))
        conn.close();
    }
    catch (Exception ex) {
      ex.printStackTrace();
    }
  }

  public static void close(Connection conn, PreparedStatement pstmt, ResultSet rs)
  {
    try
    {
      if ((rs != null) && (!rs.isClosed())) {
        rs.close();
      }
      if ((pstmt != null) && (!pstmt.isClosed())) {
        pstmt.close();
      }
      if ((conn != null) && (!conn.isClosed()))
        conn.close();
    }
    catch (Exception ex) {
      ex.printStackTrace();
    }
  }

  public static void close(Connection conn, Statement stmt)
  {
    close(conn, stmt, null);
  }

  public static void close(Connection conn, PreparedStatement pstmt)
  {
    close(conn, pstmt, null);
  }

  public static void close(Connection conn)
  {
    close(conn, null, null);
  }

  public static void close(Statement stmt)
  {
    close(null, stmt, null);
  }

  public static void close(PreparedStatement pstmt)
  {
    close(null, pstmt, null);
  }

  public static void close(ResultSet rs)
  {
    close(null, null, rs);
  }
}