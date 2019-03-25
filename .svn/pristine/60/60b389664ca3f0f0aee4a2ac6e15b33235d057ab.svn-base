package com.kizsoft.yjdb.manager;

import java.sql.SQLException;
import com.kizsoft.commons.commons.orm.MyDBUtils;
import com.kizsoft.commons.component.inter.BaseBusiness;
import com.kizsoft.commons.util.UUIDGenerator;
import com.oreilly.servlet.MultipartRequest;

import javax.servlet.http.HttpServletRequest;

public class PsInfoManager  implements BaseBusiness{
		
  public void perform(HttpServletRequest request){
    String unid = (request.getParameter("appId") == null) ? "" : request.getParameter("appId");
    if ("".equals(unid))
      return;
    deleteSB(unid);
    insterSB(request, unid);
  }

  public void perform(MultipartRequest request){
    String unid = (request.getParameter("appId") == null) ? "" : request.getParameter("appId");
    if ("".equals(unid))
      return;
    deleteSB(unid);
    insterSB(request, unid);
  }

  public void deleteSB(String dbid){
    try {
		MyDBUtils.executeUpdate("delete from yj_lr_ps where dbid=? ", dbid);
	} catch (SQLException e) {
		e.printStackTrace();
	}
  }

  public void insterSB(HttpServletRequest request, String unid) {
    String trnum = (request.getParameter("trnum") == null) ? "0" : request.getParameter("trnum");
    int num = 0;
    try {
      num = Integer.parseInt(trnum);
    } catch (Exception e) {
      e.printStackTrace();
    }
    for (int i = 0; i < num; ++i) {
      String psnr = request.getParameter("psnr" + i);
      String time = request.getParameter("time" + i);
      String sort = request.getParameter("sort" + i);
      try {
		MyDBUtils.executeUpdate("insert into  yj_lr_ps(unid,dbid,psnr,sort,time) values(?,?,?,?,?)",UUIDGenerator.getUUID(),unid,psnr,sort,time);
      } catch (SQLException e) {
		e.printStackTrace();
      }
    }
  }

  public void insterSB(MultipartRequest request, String unid) {
	  String trnum = (request.getParameter("trnum") == null) ? "0" : request.getParameter("trnum");
	  int num = 0;
	  try {
	    num = Integer.parseInt(trnum);
	  } catch (Exception e) {
	      e.printStackTrace();
	  }
	  for (int i = 0; i < num; ++i) {
	    String psnr = request.getParameter("psnr" + i);
	    String time = request.getParameter("time" + i);
	    String sort = request.getParameter("sort" + i);
	    try {
	    	MyDBUtils.executeUpdate("insert into  yj_lr_ps(unid,dbid,psnr,sort,time) values(?,?,?,?,?)",UUIDGenerator.getUUID(),unid,psnr,sort,time);
	    } catch (SQLException e) {
	    	e.printStackTrace();
	    }
	 }
  }
}