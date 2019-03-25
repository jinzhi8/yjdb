package com.kizsoft.commons.mobile.smsapi;

import com.kizsoft.commons.commons.config.SystemConfig;
import com.kizsoft.commons.commons.db.ConnectionProvider;

import java.io.IOException;
import java.io.PrintStream;
import java.io.StringReader;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.xml.rpc.ParameterMode;

import org.apache.axis.client.Call;
import org.apache.axis.client.Service;
import org.apache.axis.encoding.XMLType;
import org.apache.log4j.Logger;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;
import org.xml.sax.InputSource;

public class APIClient
{
  public static final int IMAPI_SUCC = 0;
  public static final int IMAPI_CONN_ERR = -1;
  public static final int IMAPI_CONN_CLOSE_ERR = -2;
  public static final int IMAPI_INS_ERR = -3;
  public static final int IMAPI_DEL_ERR = -4;
  public static final int IMAPI_QUERY_ERR = -5;
  public static final int IMAPI_DATA_ERR = -6;
  public static final int IMAPI_API_ERR = -7;
  public static final int IMAPI_DATA_TOOLONG = -8;
  public static final int IMAPI_INIT_ERR = -9;
  public static final int IMAPI_IFSTATUS_INVALID = -10;
  public static final int IMAPI_GATEWAY_CONN_ERR = -11;
  private String dbUser = null;

  private String dbPwd = null;

  private String apiCode_ = null;

  private String dbUrl = null;

  private Connection conn = null;
  
  final Logger log = Logger.getLogger(super.getClass().getName());
  
  public int init(String dbIP, String dbUser, String dbPwd, String apiCode)
  {
    return testConnect();
  }

  public int init(String dbIP, String dbUser, String dbPwd, String apiCode, String dbName)
  {
    return testConnect();
  }

  public int sendSM(String mobile, String content, long smID) {
    return sendSM(new String[] { mobile }, content, smID, smID);
  }

  public int sendSM(String[] mobiles, String content, long smID) {
    return sendSM(mobiles, content, smID, smID);
  }

  public int sendSM(String[] mobiles, String content, long smID, long srcID) {
    return sendSM(mobiles, content, smID, srcID, "");
  }

  public int sendSM(String[] mobiles, String content, String sendTime, long smID, long srcID)
  {
    return sendSM(mobiles, content, smID, srcID, "", sendTime);
  }

  public int sendSM(String mobile, String content, long smID, String url) {
    return sendSM(new String[] { mobile }, content, smID, url);
  }

  public int sendSM(String[] mobiles, String content, long smID, String url) {
    return sendSM(mobiles, content, smID, smID, url);
  }

  public int sendSM(String[] mobiles, String content, long smID, long srcID, String url)
  {
    return sendSM(mobiles, content, smID, smID, url, "");
  }

  /*public int sendSM(String[] mobiles, String content, long smID, long srcID, String url, String sendTime)
  {
    String endpoint = SystemConfig.getFieldValue("/config/systemconfig.xml", "//systemconfig/smsapi/endpoint");
    String ownercode = SystemConfig.getFieldValue("/config/systemconfig.xml", "//systemconfig/smsapi/ownername");
    String password = SystemConfig.getFieldValue("/config/systemconfig.xml", "//systemconfig/smsapi/key");
    String appId = SystemConfig.getFieldValue("/config/systemconfig.xml", "//systemconfig/smsapi/appId");
    String isenabled = SystemConfig.getFieldValue("/config/systemconfig.xml", "//systemconfig/smsapi/isenabled");
    if (!"1".equals(isenabled)){
    	return -1;
    }
    try {
      Service service = new Service();
      Call call = (Call)service.createCall();
      call.setTargetEndpointAddress(new URL(endpoint));
      call.setOperationName("sendsmsxml");
      call.addParameter("ownername", XMLType.XSD_STRING, ParameterMode.IN);
      call.addParameter("key", XMLType.XSD_STRING, ParameterMode.IN);
      call.addParameter("mobileid", XMLType.XSD_STRING, ParameterMode.IN);
      call.addParameter("content", XMLType.XSD_STRING, ParameterMode.IN);
      call.setReturnType(XMLType.XSD_STRING);
      String result = (String)call.invoke(new Object[] { ownercode, password, arrToStr(mobiles), content });
      System.out.println("-------短信接口调用"+result);
      result = webXmlElements(result);
      if ((result == null) || ("".equals(result))){ 
    	  return 0;
      }
    }catch (Exception ex) {
    	ex.printStackTrace();
    	return -10;
    }
    return 0;
  }*/
  public int sendSM(String[] mobiles, String content, long smID, long srcID, String url, String sendTime)
  {
    String endpoint = SystemConfig.getFieldValue("/config/systemconfig.xml", "//systemconfig/smsapi/endpoint");
    String username = SystemConfig.getFieldValue("/config/systemconfig.xml", "//systemconfig/smsapi/username");
    String password = SystemConfig.getFieldValue("/config/systemconfig.xml", "//systemconfig/smsapi/password");
    String dbname = SystemConfig.getFieldValue("/config/systemconfig.xml", "//systemconfig/smsapi/dbname");
    String isenabled = SystemConfig.getFieldValue("/config/systemconfig.xml", "//systemconfig/smsapi/isenabled");
    if (!"1".equals(isenabled)){
    	return -1;
    }    
    try {
      for(int i=0;i<mobiles.length;i++){
    	  if(goSendSm(mobiles[i],content)){
    		  log.info("-------------短信发送成功"+mobiles[i]+"  内容:"+content);
    	  }else{
    		  log.info("-------------短信发送失败"+mobiles[i]);
    	  }
      }
    }catch (Exception ex) {
    	ex.printStackTrace();
    }
    return 0;
  }
  
  public boolean goSendSm(String mobile,String content){
	  	Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean bl = false;
		try {
			con = ConnectionDXDb.getConnection();
			//sql = "insert into sendsm_0160(id,srcaddr,destaddr,msg) values('222','1065730806107',?,?)";
			sql = "insert into tzsm.sendsm_0160(id,srcaddr,destaddr,msg) values(tzsm.seq_id.nextval,'1065730806107',?,?)";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, mobile);
			pstmt.setString(2, content);
			int ret = pstmt.executeUpdate();
			if(ret>0){
				bl = true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			ConnectionProvider.close(con, pstmt, null);
		}
		return bl;
  }
  
  
  
  public String arrToStr(String[] mobiles) {
    if (mobiles == null)
      return "";
    String str = "";
    for (String mobile : mobiles) {
      if ("".equals(str))
        str = mobile;
      else {
        str = str + "," + mobile;
      }
    }
    return str;
  }

  public String webXmlElements(String xmlDoc) {
    StringReader read = new StringReader(xmlDoc);
    InputSource source = new InputSource(read);
    SAXBuilder sb = new SAXBuilder();
    String messageid = "";
    try {
      Document doc = sb.build(source);
      Element root = doc.getRootElement();
      List jiedian = root.getChildren();
      Element et = null;
      for (int i = 0; i < jiedian.size(); ++i) {
        et = (Element)jiedian.get(i);
        if ((!et.getName().equals("sms")) || 
          (et.getChild("messageid") == null))
          continue;
        messageid = et.getChild("messageid").getValue();
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
    return messageid;
  }

  public MOItem[] receiveSM()
  {
    return null;
  }

  public MOItem[] receiveSM(long srcID, int amount) {
    return null;
  }

  public RPTItem[] receiveRPT() {
    return null;
  }

  public RPTItem[] receiveRPT(long smID, int amount) {
    return null;
  }

  public void release()
  {
  }

  private int testConnect()
  {
    return 0;
  }

  private int initConnect() {
    return 0;
  }

  private void getConn()
    throws ClassNotFoundException, SQLException
  {
  }

  private void releaseConn()
  {
  }

  private void closeStatment(Statement st)
  {
  }

  public static String getCurDateTime()
  {
    SimpleDateFormat nowDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    return nowDate.format(new Date());
  }

  public static String isDateTime(String str) {
    return null;
  }
}