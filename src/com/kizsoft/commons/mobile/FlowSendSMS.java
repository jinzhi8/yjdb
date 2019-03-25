package com.kizsoft.commons.mobile;

import com.kizsoft.commons.commons.config.SystemConfig;
import com.kizsoft.commons.commons.db.ConnectionProvider;
import com.kizsoft.commons.commons.user.Group;
import com.kizsoft.commons.commons.user.User;
import com.kizsoft.commons.commons.user.UserException;
import com.kizsoft.commons.commons.user.UserManager;
import com.kizsoft.commons.commons.user.UserManagerFactory;
import com.kizsoft.commons.commons.util.StringHelper;
import com.kizsoft.commons.component.inter.BaseBusiness;
import com.kizsoft.commons.uum.pojo.Owner;
import com.kizsoft.commons.uum.service.IUUMService;
import com.kizsoft.commons.uum.utils.UUMContend;
import com.oreilly.servlet.MultipartRequest;
import java.io.PrintStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.http.HttpServletRequest;

public class FlowSendSMS
  implements BaseBusiness
{
  
  public void perform(MultipartRequest request)
  {
    String Title = request.getParameter("appTitle");
    String FileId = (StringHelper.isNull(request.getParameter("uuid"))) ? "" : request.getParameter("uuid");
    String ModuleID = (StringHelper.isNull(request.getParameter("moduleId"))) ? "" : request.getParameter("moduleId");
    String SendID = (StringHelper.isNull(request.getParameter("curUserId"))) ? "" : request.getParameter("curUserId");
    String recIdList = "";
    IUUMService iuumService = UUMContend.getUUMService();
    Owner owner = iuumService.getOwnerByOwnerid(SendID);

    String sendusername = owner.getOwnername();
    String senddepname = "";
    UserManager userManager = UserManagerFactory.getUserManager();
    try {
      senddepname = userManager.findUser(owner.getId()).getGroup().getGroupname();
    } catch (UserException e) {
      senddepname = "";
    }
    String senduserposition = owner.getPosition();
    String flowmessage = (StringHelper.isNull(request.getParameter("flow_message"))) ? "" : request.getParameter("flow_message");
    String flowmessagesize = SystemConfig.getFieldValue("/config/systemconfig.xml", "//systemconfig/smstemplate/cutsize");
    if ((!StringHelper.isNull(flowmessagesize)) && 
      (Integer.parseInt(flowmessagesize) > 0)) {
      flowmessage = flowmessage.substring(0, Integer.parseInt(flowmessagesize));
    }

    String msgContent = SystemConfig.getFieldValue("/config/systemconfig.xml", "//systemconfig/smstemplate/template");
    msgContent = StringHelper.replaceAll(msgContent, "${title}", Title);
    msgContent = StringHelper.replaceAll(msgContent, "${flowmessage}", flowmessage);
    msgContent = StringHelper.replaceAll(msgContent, "${sendusername}", sendusername);
    msgContent = StringHelper.replaceAll(msgContent, "${senddepname}", senddepname);
    msgContent = StringHelper.replaceAll(msgContent, "${senduserposition}", senduserposition);
    String performerIDList = (StringHelper.isNull(request.getParameter("flow_performerList"))) ? "" : request.getParameter("flow_performerList");
    String[] rangeIDList = performerIDList.split(";");
    for (int k = 0; k < rangeIDList.length; ++k) {
      if (k == 0)
        recIdList = rangeIDList[k];
      else {
        recIdList = recIdList + "," + rangeIDList[k];
      }
    }
    MoveSend moveSend = new MoveSend();
    String[] phoneList = null;
    String[] mobileList = moveSend.getMobileListByUserList(recIdList);
    String issmsleader = request.getParameter("issmsleader");
    String zyfzrsj = "";
    if ("1".equals(issmsleader)) {
      Connection con = null;
      PreparedStatement pts = null;
      ResultSet rs = null;
      String sql = "select * from notifyuser where userid='" + owner.getId() + "'";
      try
      {
        con = ConnectionProvider.getConnection();
        pts = con.prepareStatement(sql);
        rs = pts.executeQuery(sql);
        if (rs.next()) {
          zyfzrsj = rs.getString("zyfzrsj");
          if (zyfzrsj == null)
            zyfzrsj = "";
        }
      }
      catch (Exception ex) {
        ex.printStackTrace();
      } finally {
        ConnectionProvider.close(con, pts, rs);
      }
      if (!"".equals(zyfzrsj)) {
        String phoneStr = "";
        for (int i = 0; i < mobileList.length; ++i) {
          if (i == 0)
            phoneStr = mobileList[i];
          else {
            phoneStr = phoneStr + "," + mobileList[i];
          }
        }
        if (!"".equals(phoneStr))
          phoneStr = phoneStr + "," + zyfzrsj;
        else {
          phoneStr = zyfzrsj;
        }
        phoneList = StringHelper.split(phoneStr, ",");
      } else {
        phoneList = mobileList;
      }
    }
    else {
      phoneList = mobileList;
    }

    long smID = 0L;
    int resultFlag = moveSend.sendSM(phoneList, msgContent, smID);
    if (resultFlag != 0)
      System.out.println("流程处理发送短信提醒下一步处理人时候出错!返回标志:" + resultFlag);
  }

  public void perform(HttpServletRequest request)
  {
    String Title = request.getParameter("appTitle");
    String FileId = (String)(String)((StringHelper.isNull((String)request.getAttribute("uuid"))) ? "" : request.getAttribute("uuid"));
    String ModuleID = (String)(String)((StringHelper.isNull((String)request.getAttribute("moduleId"))) ? "" : request.getAttribute("moduleId"));
    String SendID = (String)(String)((StringHelper.isNull((String)request.getAttribute("curUserId"))) ? "" : request.getAttribute("curUserId"));
    String recIdList = "";
    IUUMService iuumService = UUMContend.getUUMService();
    Owner owner = iuumService.getOwnerByOwnerid(SendID);

    String sendusername = owner.getOwnername();
    String senddepname = "";
    UserManager userManager = UserManagerFactory.getUserManager();
    try {
      senddepname = userManager.findUser(owner.getId()).getGroup().getGroupname();
    } catch (UserException e) {
      senddepname = "";
    }
    String senduserposition = owner.getPosition();
    String flowmessage = (StringHelper.isNull(request.getParameter("flow_message"))) ? "" : request.getParameter("flow_message");
    String flowmessagesize = SystemConfig.getFieldValue("/config/systemconfig.xml", "//systemconfig/smstemplate/cutsize");
    if ((!StringHelper.isNull(flowmessagesize)) && 
      (Integer.parseInt(flowmessagesize) > 0)) {
      flowmessage = flowmessage.substring(0, Integer.parseInt(flowmessagesize));
    }

    String msgContent = SystemConfig.getFieldValue("/config/systemconfig.xml", "//systemconfig/smstemplate/template");
    msgContent = StringHelper.replaceAll(msgContent, "${title}", Title);
    msgContent = StringHelper.replaceAll(msgContent, "${flowmessage}", flowmessage);
    msgContent = StringHelper.replaceAll(msgContent, "${sendusername}", sendusername);
    msgContent = StringHelper.replaceAll(msgContent, "${senddepname}", senddepname);
    msgContent = StringHelper.replaceAll(msgContent, "${senduserposition}", senduserposition);
    String performerIDList = (String)(String)((StringHelper.isNull((String)request.getAttribute("flow_performerList"))) ? "" : request.getAttribute("flow_performerList"));
    String[] rangeIDList = performerIDList.split(";");
    for (int k = 0; k < rangeIDList.length; ++k) {
      if (k == 0)
        recIdList = rangeIDList[k];
      else {
        recIdList = recIdList + "," + rangeIDList[k];
      }
    }
    MoveSend moveSend = new MoveSend();
    String[] phoneList = null;
    String[] mobileList = moveSend.getMobileListByUserList(recIdList);
    String issmsleader = (String)request.getAttribute("issmsleader");
    String zyfzrsj = "";
    if ("1".equals(issmsleader)) {
      Connection con = null;
      PreparedStatement pts = null;
      ResultSet rs = null;
      String sql = "select * from notifyuser where userid='" + owner.getId() + "'";
      try
      {
        con = ConnectionProvider.getConnection();
        pts = con.prepareStatement(sql);
        rs = pts.executeQuery(sql);
        if (rs.next()) {
          zyfzrsj = rs.getString("zyfzrsj");
          if (zyfzrsj == null)
            zyfzrsj = "";
        }
      }
      catch (Exception ex) {
        ex.printStackTrace();
      } finally {
        ConnectionProvider.close(con, pts, rs);
      }
      if (!"".equals(zyfzrsj)) {
        String phoneStr = "";
        for (int i = 0; i < mobileList.length; ++i) {
          if (i == 0)
            phoneStr = mobileList[i];
          else {
            phoneStr = phoneStr + "," + mobileList[i];
          }
        }
        if (!"".equals(phoneStr))
          phoneStr = phoneStr + "," + zyfzrsj;
        else {
          phoneStr = zyfzrsj;
        }
        phoneList = StringHelper.split(phoneStr, ",");
      } else {
        phoneList = mobileList;
      }
    }
    else {
      phoneList = mobileList;
    }

    long smID = 0L;
    int resultFlag = moveSend.sendSM(phoneList, msgContent, smID);
    if (resultFlag != 0)
      System.out.println("流程处理发送短信提醒下一步处理人时候出错!返回标志:" + resultFlag);
  }
}