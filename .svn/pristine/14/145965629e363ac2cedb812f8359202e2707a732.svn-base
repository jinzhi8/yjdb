package com.kizsoft.commons.mobile;

import com.kizsoft.commons.commons.config.SystemConfig;
import com.kizsoft.commons.commons.db.ConnectionProvider;
import com.kizsoft.commons.commons.util.StringHelper;
import com.kizsoft.commons.mobile.smsapi.APIClient;
import com.kizsoft.commons.mobile.smsapi.RPTItem;
import com.kizsoft.commons.uum.pojo.Owner;
import com.kizsoft.commons.uum.service.IUUMService;
import com.kizsoft.commons.uum.utils.UUMContend;
import java.io.IOException;
import java.io.PrintStream;
import java.io.StringReader;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Random;
import javax.xml.rpc.ParameterMode;
import org.apache.axis.client.Call;
import org.apache.axis.client.Service;
import org.apache.axis.encoding.XMLType;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;
import org.xml.sax.InputSource;

public class MoveSend
{
  private APIClient apic = null;
  private Random random = null;
  private String serverIp = null;
  private String apiCode = null;
  private String dbUser = null;
  private String dbPwd = null;
  private String dbName = null;

  public MoveSend() {
    this.apic = new APIClient();
    this.random = new Random();
    this.serverIp = SystemConfig.getFieldValue("/config/systemconfig.xml", "//systemconfig/smsapi/serverip");
    this.apiCode = SystemConfig.getFieldValue("/config/systemconfig.xml", "//systemconfig/smsapi/apicode");
    this.dbUser = SystemConfig.getFieldValue("/config/systemconfig.xml", "//systemconfig/smsapi/username");
    this.dbPwd = SystemConfig.getFieldValue("/config/systemconfig.xml", "//systemconfig/smsapi/password");
    this.dbName = SystemConfig.getFieldValue("/config/systemconfig.xml", "//systemconfig/smsapi/dbname");
  }

  private int init() {
    int i = 99;
    try {
      i = this.apic.init(this.serverIp, this.dbUser, this.dbPwd, this.apiCode, this.dbName);
    }
    catch (Exception ex) {
      ex.printStackTrace();
    }
    return i;
  }

  public int sendSM(String mobile, String content) {
    APIClient apic = new APIClient();
    int k = apic.init(this.serverIp, this.dbUser, this.dbPwd, this.apiCode, this.dbName);
    if (k == 0)
      apic.sendSM(mobile, content, this.random.nextLong());
    else if (k == -1)
      System.out.println("即时发消息时连接错误!!");
    else if (k == -2)
      System.out.println("即时发消息时链接关闭错误!!");
    else if (k == -3)
      System.out.println("即时发消息时插入错误!!");
    else if (k == -4)
      System.out.println("即时发消息时删除错误!!");
    else if (k == -5)
      System.out.println("即时发消息时查询错误!!");
    else if (k == -6)
      System.out.println("即时发消息时时间错误!!");
    else if (k == -7)
      System.out.println("即时发消息时API错误!!");
    else if (k == -8)
      System.out.println("即时发消息时时间太长错误!!");
    else if (k == -9)
      System.out.println("即时发消息时初始化错误!!");
    else
      System.out.println("即时发消息时未知错误！！");
    return k;
  }

  public int sendSM(String[] mobile, String content) {
    APIClient apic = new APIClient();
    int k = apic.init(this.serverIp, this.dbUser, this.dbPwd, this.apiCode, this.dbName);
    if (k == 0)
      apic.sendSM(mobile, content, this.random.nextLong());
    else if (k == -1)
      System.out.println("即时群发消息时连接错误!!");
    else if (k == -2)
      System.out.println("即时群发消息时链接关闭错误!!");
    else if (k == -3)
      System.out.println("即时群发消息时插入错误!!");
    else if (k == -4)
      System.out.println("即时群发消息时删除错误!!");
    else if (k == -5)
      System.out.println("即时群发消息时查询错误!!");
    else if (k == -6)
      System.out.println("即时群发消息时时间错误!!");
    else if (k == -7)
      System.out.println("即时群发消息时API错误!!");
    else if (k == -8)
      System.out.println("即时群发消息时时间太长错误!!");
    else if (k == -9)
      System.out.println("即时群发消息时初始化错误!!");
    else
      System.out.println("即时群发消息时未知错误！！");
    apic.release();
    return k;
  }

  public int sendSM(String[] mobile, String content, long smID) {
    APIClient apic = new APIClient();
    int k = apic.init(this.serverIp, this.dbUser, this.dbPwd, this.apiCode, this.dbName);
    if (k == 0) {
      apic.sendSM(mobile, content, smID);
    }
    else if (k == -1)
      System.out.println("即时群发消息时连接错误!!");
    else if (k == -2)
      System.out.println("即时群发消息时链接关闭错误!!");
    else if (k == -3)
      System.out.println("即时群发消息时插入错误!!");
    else if (k == -4)
      System.out.println("即时群发消息时删除错误!!");
    else if (k == -5)
      System.out.println("即时群发消息时查询错误!!");
    else if (k == -6)
      System.out.println("即时群发消息时时间错误!!");
    else if (k == -7)
      System.out.println("即时群发消息时API错误!!");
    else if (k == -8)
      System.out.println("即时群发消息时时间太长错误!!");
    else if (k == -9)
      System.out.println("即时群发消息时初始化错误!!");
    else
      System.out.println("即时群发消息时未知错误！！");
    apic.release();
    return k;
  }

  public int sendSM_TIME(String mobile, String content, String time) {
    APIClient apic = new APIClient();
    int k = apic.init(this.serverIp, this.dbUser, this.dbPwd, this.apiCode, this.dbName);
    String[] mobiles = { 
      mobile };

    if (k == 0)
      apic.sendSM(mobiles, content, time, 0L, 0L);
    else if (k == -1)
      System.out.println("定时发消息时连接错误!!");
    else if (k == -2)
      System.out.println("定时发消息时链接关闭错误!!");
    else if (k == -3)
      System.out.println("定时发消息时插入错误!!");
    else if (k == -4)
      System.out.println("定时发消息时删除错误!!");
    else if (k == -5)
      System.out.println("定时发消息时查询错误!!");
    else if (k == -6)
      System.out.println("定时发消息时时间错误!!");
    else if (k == -7)
      System.out.println("定时发消息时API错误!!");
    else if (k == -8)
      System.out.println("定时发消息时时间太长错误!!");
    else if (k == -9)
      System.out.println("定时发消息时初始化错误!!");
    else
      System.out.println("定时发消息时未知错误！！");
    apic.release();
    return k;
  }

  public int sendSM_TIME(String[] mobile, String content, String time) {
    APIClient apic = new APIClient();
    int k = apic.init(this.serverIp, this.dbUser, this.dbPwd, this.apiCode, this.dbName);
    if (k == 0)
      apic.sendSM(mobile, content, time, 0L, 0L);
    else if (k == -1)
      System.out.println("定时群发消息时连接错误!!");
    else if (k == -2)
      System.out.println("定时群发消息时链接关闭错误!!");
    else if (k == -3)
      System.out.println("定时群发消息时插入错误!!");
    else if (k == -4)
      System.out.println("定时群发消息时删除错误!!");
    else if (k == -5)
      System.out.println("定时群发消息时查询错误!!");
    else if (k == -6)
      System.out.println("定时群发消息时时间错误!!");
    else if (k == -7)
      System.out.println("定时群发消息时API错误!!");
    else if (k == -8)
      System.out.println("定时群发消息时时间太长错误!!");
    else if (k == -9)
      System.out.println("定时群发消息时初始化错误!!");
    else
      System.out.println("定时群发消息时未知错误！！");
    apic.release();
    return k;
  }

  public void close() {
    this.apic.release();
    System.gc();
  }

  public String[] getMobileListByUserList(String userList)
  {
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String[] userListArray = StringHelper.split(userList, ",");
    ArrayList userArrayList = new ArrayList();
    List list = new ArrayList();
    Owner owner = null;
    IUUMService iuumService = UUMContend.getUUMService();
    for (int i = 0; i < userListArray.length; ++i) {
      list = iuumService.getAllChildUserByOwnerId(userListArray[i]);
      if (list.isEmpty()) {
        owner = iuumService.getOwnerByOwnerid(userListArray[i]);
        if ((owner != null) && (!userArrayList.contains(owner.getId())))
          userArrayList.add(owner.getId());
      } else {
        for (int j = 0; j < list.size(); ++j) {
          owner = (Owner)list.get(j);
          if ((owner != null) && (!userArrayList.contains(owner.getId()))) {
            userArrayList.add(owner.getId());
          }
        }
      }
    }

    HashSet hs = new HashSet(userArrayList);
    userArrayList.clear();
    userArrayList.addAll(hs);
    String mobileList = new String();
    String[] phoneList = (String[])null;
    try {
      conn = ConnectionProvider.getConnection();
      for (int userNum = 0; userNum < userArrayList.size(); ++userNum) {
        String sql = "select mobile from owner where ID = '" + (String)userArrayList.get(userNum) + "'";
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();
        if (rs.next()) {
          String getMobile = rs.getString("mobile");
          if ((getMobile != null) && (!getMobile.equals(""))) {
            if (mobileList.equals(""))
              mobileList = getMobile;
            else {
              mobileList = mobileList + "," + getMobile;
            }
          }
        }
      }
      System.out.println("!!!!!!!!!!!!!!!@@@@@@@@@@@@@@@@:::  " + mobileList);
      String[] mobileListArray = StringHelper.split(mobileList, ",");
      phoneList = mobileListArray;
    } catch (Exception e) {
      System.out.println("MoveSend[getMobileListByUserList] " + e.toString());
    } finally {
      try {
        if (rs != null) {
          rs.close();
        }
        if (pstmt != null) {
          pstmt.close();
        }
        if (conn != null)
          conn.close();
      } catch (Exception e) {
        e.printStackTrace();
      }
    }
    return phoneList;
  }

  public String getMobileUserListString(String userList) {
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String[] rangeIDList = userList.split(",");

    ArrayList userIdList = new ArrayList();
    ArrayList userNameList = new ArrayList();
    List list = new ArrayList();
    Owner owner = null;
    IUUMService iuumService = UUMContend.getUUMService();
    for (int i = 0; i < rangeIDList.length; ++i) {
      list = iuumService.getAllChildUserByOwnerId(rangeIDList[i]);
      if (list.isEmpty()) {
        owner = iuumService.getOwnerByOwnerid(rangeIDList[i]);
        if (owner == null) continue; if (userIdList.contains(owner.getId()))
          continue;
        userIdList.add(owner.getId());
        userNameList.add(owner.getOwnername());
      }
      else {
        for (int j = 0; j < list.size(); ++j) {
          owner = (Owner)list.get(j);
          if (owner == null) continue; if (userIdList.contains(owner.getId()))
            continue;
          userIdList.add(owner.getId());
          userNameList.add(owner.getOwnername());
        }
      }

    }

    String IDList = "";
    for (int k = 0; k < userIdList.size(); ++k) {
      if (k == 0)
        IDList = ((String)userIdList.get(k)).toString();
      else {
        IDList = IDList + "," + ((String)userIdList.get(k)).toString();
      }
    }
    String[] userListArray = StringHelper.split(IDList, ",");
    String mobileList = new String();
    String phoneList = null;
    try {
      conn = ConnectionProvider.getConnection();
      for (int userNum = 0; userNum < userListArray.length; ++userNum) {
        String sql = "select mobile from owner where ID = '" + userListArray[userNum] + "'";
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();
        boolean havedate = rs.next();
        if (havedate) {
          String getMobile = rs.getString("mobile");
          if ((getMobile != null) && (!getMobile.equals(""))) {
            if (mobileList.equals(""))
              mobileList = getMobile;
            else
              mobileList = mobileList + "," + getMobile;
          }
        }
      }
      phoneList = mobileList;
    } catch (Exception e) {
      System.out.println("MoveSend[getMobileListByUserList] " + e.toString());
    } finally {
      try {
        if (rs != null) {
          rs.close();
        }
        if (pstmt != null) {
          pstmt.close();
        }
        if (conn != null)
          conn.close();
      } catch (Exception e) {
        e.printStackTrace();
      }
    }
    return phoneList;
  }

  public String getMobileUserInfo(String userList) {
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String[] userListArray = StringHelper.split(userList, ",");
    String failureInfo = "";
    String successfulInfo = "";
    String returnfailureInfo = "";
    String returnsuccessfulInfo = "";
    String getMobile = null;
    String ownerName = null;
    int NN = 0;
    int MM = 0;
    try {
      conn = ConnectionProvider.getConnection();
      for (int userNum = 0; userNum < userListArray.length; ++userNum) {
        String sql = "select mobile,ownername from owner where ID = '" + userListArray[userNum] + "'";
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();
        boolean havedate = rs.next();
        if (havedate) {
          getMobile = rs.getString("mobile");
          ownerName = rs.getString("ownername");
          if ((getMobile != null) && (!getMobile.equals(""))) {
            ++NN;
            if (NN == 1)
              successfulInfo = ownerName;
            else
              successfulInfo = successfulInfo + "," + ownerName;
          } else {
            ++MM;
            if (MM == 1)
              failureInfo = ownerName;
            else
              failureInfo = failureInfo + "," + ownerName;
          }
        }
      }
      if (!successfulInfo.equals(""))
        returnsuccessfulInfo = "已成功发送用户：" + successfulInfo;
      if (failureInfo.equals(""))
    	  returnfailureInfo = "\\n\\r无用户手机号：" + failureInfo;
    } catch (Exception e) {
      System.out.println("MoveSend[getMobileListByUserList] " + e.toString());
    } finally {
      try {
        if (rs != null) {
          rs.close();
        }
        if (pstmt != null) {
          pstmt.close();
        }
        if (conn != null)
          conn.close();
      } catch (Exception e) {
        e.printStackTrace();
      }
    }
    return returnsuccessfulInfo + returnfailureInfo;
  }

  public RPTItemInfo[] getRPTItemArrayFromAPI_bak() {
    RPTItem[] selRPTItem = (RPTItem[])null;
    RPTItemInfo[] rptitemArr = (RPTItemInfo[])null;
    try {
      APIClient apic = new APIClient();
      int k = apic.init(this.serverIp, this.dbUser, this.dbPwd, this.apiCode, this.dbName);
      if (k == 0) {
        selRPTItem = apic.receiveRPT();
        rptitemArr = new RPTItemInfo[selRPTItem.length];
        for (int j = 0; j < selRPTItem.length; ++j) {
          RPTItemInfo rptitemInfo = new RPTItemInfo();
          rptitemInfo.setSmID(String.valueOf(selRPTItem[j].getSmID()));
          rptitemInfo.setMobile(selRPTItem[j].getMobile());
          rptitemInfo.setCode(String.valueOf(selRPTItem[j].getCode()));
          rptitemInfo.setDescribe(selRPTItem[j].getDesc());
          rptitemArr[j] = rptitemInfo;
        }
      }
      else if (k == -1) {
        System.out.println("连接错误!!");
      } else if (k == -2) {
        System.out.println("连接关闭错误!!");
      } else if (k == -3) {
        System.out.println("插入错误!!");
      } else if (k == -4) {
        System.out.println("删除错误!!");
      } else if (k == -5) {
        System.out.println("查询错误!!");
      } else if (k == -6) {
        System.out.println("时间错误!!");
      } else if (k == -7) {
        System.out.println("API错误!!");
      } else if (k == -8) {
        System.out.println("时间太长错误!!");
      } else if (k == -9) {
        System.out.println("初始化错误!!");
      } else {
        System.out.println("未知错误！！");
      }apic.release();
    }
    catch (Exception e) {
      System.out.println("MoveSend[getRPTItemArrayFromAPI]" + e.toString());
    }
    return rptitemArr;
  }
  public static void main(String[] args) {
    MoveSend move = new MoveSend();
    move.getRPTItemArrayFromAPI();
  }

  public RPTItemInfo[] getRPTItemArrayFromAPI() {
    String endpoint = SystemConfig.getFieldValue("/config/systemconfig.xml", "//systemconfig/smsapi/endpoint");
    String ownercode = SystemConfig.getFieldValue("/config/systemconfig.xml", "//systemconfig/smsapi/ownername");
    String password = SystemConfig.getFieldValue("/config/systemconfig.xml", "//systemconfig/smsapi/key");
    try {
      Service service = new Service();
      Call call = (Call)service.createCall();
      call.setTargetEndpointAddress(new URL(endpoint));
      call.setOperationName("receiveRPTXml");
      call.addParameter("ownercode", XMLType.XSD_STRING, ParameterMode.IN);
      call.addParameter("password", XMLType.XSD_STRING, ParameterMode.IN);
      call.setReturnType(XMLType.XSD_STRING);
      String result = (String)call.invoke(new Object[] { ownercode, password });

      return rptXmlElements(result);
    } catch (Exception ex) {
      ex.printStackTrace();
    }return null;
  }

  public RPTItemInfo[] rptXmlElements(String xmlDoc)
  {
    StringReader read = new StringReader(xmlDoc);
    InputSource source = new InputSource(read);
    SAXBuilder sb = new SAXBuilder();
    List rptlist = new ArrayList();
    try {
      Document doc = sb.build(source);
      Element root = doc.getRootElement();
      List jiedian = root.getChildren();
      Element et = null;
      for (int i = 0; i < jiedian.size(); ++i) {
        et = (Element)jiedian.get(i);
        if ((!et.getName().equals("sms")) || 
          (et.getChild("rpts") == null)) continue;
        List message = et.getChild("rpts").getChildren();
        Element detail = null;
        for (int j = 0; j < message.size(); ++j) {
          detail = (Element)message.get(j);
          if ("rpt".equals(detail.getName())) {
            RPTItemInfo rptitemInfo = new RPTItemInfo();
            rptitemInfo.setSmID(detail.getChild("smID").getText());
            rptitemInfo.setMobile(detail.getChild("mobile").getText());
            rptitemInfo.setCode(detail.getChild("code").getText());
            rptitemInfo.setDescribe(detail.getChild("describe").getText());
            rptlist.add(rptitemInfo);
          }
          if ("detail".equals(detail.getName())) {
            System.out.println(detail.getText());
          }

        }

      }

    }
    catch (JDOMException e)
    {
      e.printStackTrace();
    } catch (UnsupportedEncodingException e) {
      e.printStackTrace();
    } catch (IOException e) {
      e.printStackTrace();
    }

    return (RPTItemInfo[])rptlist.toArray(new RPTItemInfo[rptlist.size()]);
  }

  public String[] getMobileListByUserNameList(String userList)
  {
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String[] userListArray = StringHelper.split(userList, ",");
    String ownerName = new String();
    String[] userNameList = (String[])null;
    try {
      conn = ConnectionProvider.getConnection();
      for (int userNum = 0; userNum < userListArray.length; ++userNum) {
        String sql = "select mobile,ownername from owner where ID = '" + userListArray[userNum] + "'";
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();
        boolean havedate = rs.next();
        if (havedate) {
          String getMobile = rs.getString("mobile");
          if ((getMobile != null) && (!getMobile.equals(""))) {
            if (ownerName.equals(""))
              ownerName = rs.getString("ownername");
            else
              ownerName = ownerName + "," + rs.getString("ownername");
          }
        }
      }
      userNameList = StringHelper.split(ownerName, ",");
    }
    catch (Exception e) {
      System.out.println("MoveSend[getMobileListByUserNameList] " + e.toString());
    } finally {
      try {
        if (rs != null) {
          rs.close();
        }
        if (pstmt != null) {
          pstmt.close();
        }
        if (conn != null)
          conn.close();
      }
      catch (Exception e) {
        e.printStackTrace();
      }
    }
    return userNameList;
  }
}