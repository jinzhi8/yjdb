package com.kizsoft.oa.wcoa.util;

import com.kizsoft.commons.commons.db.ConnectionProvider;
import com.kizsoft.commons.component.inter.BaseBusiness;
import com.oreilly.servlet.MultipartRequest;
import java.io.PrintStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.UUID;
import javax.servlet.http.HttpServletRequest;

public class GetDocunid
  implements BaseBusiness
{
  public GetDocunid()
  {
    System.out.println("build getcgsqunid ");
  }

  public String getUnid() {
    return UUID.randomUUID().toString().replace("-", "");
  }

  public void perform(HttpServletRequest request) {
    System.out.println("workingxxxxxxx!!!!!");
    String issueflag = request.getParameter("issueflag");
    System.out.println("issueflag:" + issueflag);
    String zwdbid = request.getParameter("appId");
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      String sql = "update ZWDB set docunid=?,hy='会议' where issueflag=?";
      conn = ConnectionProvider.getConnection();
      ps = conn.prepareStatement(sql);
      ps.setString(1, zwdbid);
      ps.setString(2, issueflag);
      ps.executeUpdate();
    } catch (Exception e) {
      e.printStackTrace();
      return;
    } finally {
      ConnectionProvider.close(conn, ps, rs);
    }
  }

  public void perform(MultipartRequest request)
  {
    System.out.println("workingzzzzzz!!!!!");
    String issueflag = request.getParameter("issueflag");
    System.out.println("issueflag:" + issueflag);
    String zwdbid = request.getParameter("appId");
    System.out.println("zwdbid:" + zwdbid);
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      String sql = "update ZWDB set docunid=?,hy='会议' where issueflag=?";
      conn = ConnectionProvider.getConnection();
      ps = conn.prepareStatement(sql);
      ps.setString(1, zwdbid);
      ps.setString(2, issueflag);
      ps.executeUpdate();
    } catch (Exception e) {
      e.printStackTrace();
      return;
    } finally {
      ConnectionProvider.close(conn, ps, rs);
    }
  }
}