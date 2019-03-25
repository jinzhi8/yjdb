package com.kizsoft.yjdb.ding;
import java.io.IOException;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.dingtalk.api.DefaultDingTalkClient;
import com.dingtalk.api.DingTalkClient;
import com.dingtalk.api.request.OapiSnsGetPersistentCodeRequest;
import com.dingtalk.api.request.OapiSnsGetSnsTokenRequest;
import com.dingtalk.api.request.OapiSnsGetuserinfoRequest;
import com.dingtalk.api.response.OapiSnsGetPersistentCodeResponse;
import com.dingtalk.api.response.OapiSnsGetSnsTokenResponse;
import com.dingtalk.api.response.OapiSnsGetuserinfoResponse;
import com.dingtalk.api.response.OapiSnsGetuserinfoResponse.UserInfo;
import com.kizsoft.commons.commons.config.SystemConfig;
import com.kizsoft.commons.commons.orm.MyDBUtils;
import com.kizsoft.commons.commons.user.Group;
import com.kizsoft.commons.commons.user.User;
import com.kizsoft.commons.commons.user.UserException;
import com.kizsoft.commons.commons.user.UserManager;
import com.kizsoft.commons.commons.user.UserManagerFactory;
import com.kizsoft.commons.login.LoginEncrypt;
import com.kizsoft.commons.login.UserFlagManage;
import com.kizsoft.commons.util.MD5;
import com.kizsoft.yjdb.utils.CommonUtil;
import com.kizsoft.yjdb.utils.GsonHelp;
import com.kizsoft.yjdb.utils.JsoupUtil;
import com.kizsoft.yjdb.utils.PropertiesUtil;
import com.taobao.api.ApiException;


public class UserServlet extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException{
		 doPost(request, response);
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response)throws IOException{
		 response.setContentType("text/html; charset=UTF-8");//用于定义网络文件的类型和网页的编码，决定浏览器将以什么形式、什么编码读取这个文件
	     request.setCharacterEncoding("utf-8");//作用是设置对客户端请求进行重新编码的编码
	     response.setHeader("Access-Control-Allow-Origin", "*");  
         response.setHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS, DELETE");  
         response.setHeader("Access-Control-Max-Age", "3600");  
         response.setHeader("Access-Control-Allow-Headers", "x-requested-with"); 
		 response.getWriter().append("");
	}
	//判断跳转
	public static String toIndex(HttpServletRequest request, HttpServletResponse response,String mobile){
		HttpSession session = request.getSession(true);
		String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
		List<Map<String,Object>> list=UserServlet.getUserInfo(mobile);
		String show="";
		if(list.size()==1){
			String userName=(String)list.get(0).get("ownercode");
			String password=(String)list.get(0).get("password");
			String result=UserServlet.setUserInfo(request,response,userName,password);
			if(result.equals("1")){
				show="index";
				return show;
			}else{
				show="login";
				return show;
			} 
		}else if(list.size()==0){
			session.setAttribute("LogErrMsg","信息匹配失败,未查询到该用户！");
			show="login";
			return show;
		}else if(list.size()>1){
			show="loginMore";
			return show;
		}
		return show;
	}
	
	//多单位的单位选择
	public static void toDep(HttpServletRequest request, HttpServletResponse response,String depid,String userid) throws UserException{
		HttpSession session = request.getSession(true);
		Map<String,Object> owner=MyDBUtils.queryForUniqueMap("select * from owner where id=?", userid);
		String userName=(String)owner.get("ownercode");
		String password=(String)owner.get("password");
		String result=UserServlet.setUserInfo(request,response,userName,password);
		Map<String,Object> map=MyDBUtils.queryForUniqueMap("select * from owner where id=?", depid);
		String depname=(String)map.get("ownername");
		User user=(User) session.getAttribute("userInfo");
		Group groupInfo =user.getGroup();
		groupInfo.setGroupId(depid);
		groupInfo.setGroupname(depname);
		user.setGroup(groupInfo);
		session.setAttribute("userInfo", user);
	}
	
	//添加登陆信息
	public static String setUserInfo(HttpServletRequest request, HttpServletResponse response,String userName,String password){
		HttpSession session = request.getSession(true);
		String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
	    UserManager userManager = UserManagerFactory.getUserManager();  
	    String result="";
	    try {
	      MD5 md5 = new MD5();
	      String md5password = md5.getMD5ofStr(password);
	      User user = null;
	      try {
	        user = userManager.checkUser(userName, md5password);
	      } catch (UserException ex) {
	        try {
	          user = userManager.checkUser(userName, password);
	        } catch (UserException ex2) {
	          user = null;
	        }
	        if ((user != null) && (user.getPassword().length() != 32))
	          LoginEncrypt.EncryptUserPasswordById(user.getUserId(), user.getPassword());
	      }
	      if (user != null){
	    	  session.setAttribute("userInfo", user);
	          session.setAttribute("templatename", user.getTemplatename());
	          Cookie namecookie = new Cookie("username", userName);
	          namecookie.setPath(request.getContextPath());
	          namecookie.setMaxAge(31536000);
	          response.addCookie(namecookie);
	          result="1";
	          return result;
	    }else{
	    	session.setAttribute("LogErrMsg", "信息匹配失败！"); 
	    }
	    }catch (Exception ex) {
	        session.setAttribute("LogErrMsg", "登录失败！请重新登录。"); 
	    }
	    result="2";
        return result;
	}
	
	public static String getMobile(String code) throws ApiException{
		String userid=getuserId(code);
		String accessToken=getNewAccessToken();
		Map mapParam = new HashMap();
		String url="https://oapi.dingtalk.com/user/get?access_token="+accessToken+"&userid="+userid;
		String result=JsoupUtil.sendGet(url, mapParam, "utf-8");
		Map<String,Object> map=GsonHelp.fromJson(result);
		String mobile=(String)map.get("mobile");
		return mobile;
	}
	
	public static String getuserId(String code) throws ApiException{
		String accessToken=getNewAccessToken();
		Map mapParam = new HashMap();
		OapiSnsGetuserinfoResponse getXX=getUserMobile(code);
		UserInfo userInfo=getXX.getUserInfo();
		String unionid=userInfo.getUnionid();
		String mobile=userInfo.getMaskedMobile();
		String url="https://oapi.dingtalk.com/user/getUseridByUnionid?access_token="+accessToken+"&unionid="+unionid;
		String result=JsoupUtil.sendGet(url, mapParam, "utf-8");
		Map<String,Object> map=GsonHelp.fromJson(result);
		String userid=(String)map.get("userid");
		
		return userid;
	}
	
	
	public static OapiSnsGetuserinfoResponse getUserMobile(String code) throws ApiException{
		DingTalkClient client = new DefaultDingTalkClient("https://oapi.dingtalk.com/sns/getuserinfo");
		OapiSnsGetuserinfoRequest request = new OapiSnsGetuserinfoRequest();
		OapiSnsGetSnsTokenResponse getsns_token=getsns_token(code);
		request.setSnsToken(getsns_token.getSnsToken());
		request.setHttpMethod("GET");
		OapiSnsGetuserinfoResponse response = client.execute(request);
		return response;
	}
	public static OapiSnsGetSnsTokenResponse getsns_token(String code) throws ApiException{
		String accessToken=getAccessToken();
		OapiSnsGetPersistentCodeResponse getPersistent_code=getPersistent_code(code);
		DingTalkClient client = new DefaultDingTalkClient("https://oapi.dingtalk.com/sns/get_sns_token");
		OapiSnsGetSnsTokenRequest request = new OapiSnsGetSnsTokenRequest();
		request.setOpenid(getPersistent_code.getOpenid());
		request.setPersistentCode(getPersistent_code.getPersistentCode());
		OapiSnsGetSnsTokenResponse response = client.execute(request,accessToken);
		return response;
	}
	public static String getAccessToken(){
		String appid=new PropertiesUtil().getDlValueByKey("appid");
		String appsecret=new PropertiesUtil().getDlValueByKey("appsecret");
		Map mapParam = new HashMap();
		String url="https://oapi.dingtalk.com/sns/gettoken?appid="+appid+"&appsecret="+appsecret;
		String result=JsoupUtil.sendGet(url, mapParam, "utf-8");
		Map<String,Object> map=GsonHelp.fromJson(result);
		String access_token=(String)map.get("access_token");
		return access_token;
	}
	public static  OapiSnsGetPersistentCodeResponse getPersistent_code(String code) throws ApiException{
		String accessToken=getAccessToken();
		DingTalkClient client = new DefaultDingTalkClient("https://oapi.dingtalk.com/sns/get_persistent_code");
		OapiSnsGetPersistentCodeRequest request = new OapiSnsGetPersistentCodeRequest();
		request.setTmpAuthCode(code);
		OapiSnsGetPersistentCodeResponse response = client.execute(request,accessToken);
		return response;
	}
	
	public static String getNewAccessToken(){
		String corpId=new PropertiesUtil().getDlValueByKey("CorpId");
		String CorpSecret=new PropertiesUtil().getDlValueByKey("CorpSecret");
		Map mapParam = new HashMap();
		String url="https://oapi.dingtalk.com/gettoken?corpid="+corpId+"&corpsecret="+CorpSecret;
		String result=JsoupUtil.sendGet(url, mapParam, "utf-8");
		Map<String,Object> map=GsonHelp.fromJson(result);
		String access_token=(String)map.get("access_token");
		return access_token;
	}
	
	//发送验证码
	public static String sendYmz(String mobile,String yzm){
		Map mapParam = new HashMap();
		String url=new PropertiesUtil().getDlValueByKey("dingUrl");
        String content = SystemConfig.getFieldValue("//systemconfig/smstemplate/template")+yzm;
        String message="";
        mapParam.put("mobile",mobile);
        mapParam.put("textContent",content);
		String result=JsoupUtil.sendGet(url, mapParam, "utf-8");
		Map<String,Object> map=GsonHelp.fromJson(result);
		String state=(String)map.get("state");
		if("0".equals(state)){
			message="发送异常,稍后再试";
			return message;
		}
		Map<String,Object> data=GsonHelp.fastJson((String)map.get("data"));
		message=(String)data.get("message");
		return message;
	}
	
	
	public static String getNumberRandom(int length){
	    String val = "";
	    Random random = new Random();
	    for (int i = 0; i < length; i++) {
	      val = val + random.nextInt(10);
	    }
	    return val;
	}
	
	public static List<Map<String,Object>> getUserInfo(String mobile){
		String userid="";
		List<Map<String,Object>> listM=MyDBUtils.queryForMapToUC("select o.id from owner o where  o.mobile like '%"+mobile+"%'");
		for(Map<String,Object> map:listM){
			String id=(String)map.get("id");
			userid+=id+",";
			List<Map<String,Object>> listMs=MyDBUtils.queryForMapToUC("select a.id from yj_ms a where instr(a.msids,?) > 0 ",id);
			for(Map<String,Object> mapMs:listMs){
				String msid=(String)mapMs.get("id");
				userid+=msid+",";
			}
		}
		if(userid.length()>0){
			userid=userid.substring(0,userid.length()-1);
		}
		userid=userid.replace(",", "','");

		List<Map<String,Object>> list=MyDBUtils.queryForMapToUC("select t.* from owner t where id in('"+userid+"') and exists(select 1 from acluserrole t where t.userid in('"+userid+"'))");
		return list;	
	}
	
	public static List<Map<String,Object>> getDepidInfo(String userid){
		//List<Map<String,Object>> list=MyDBUtils.queryForMapToUC("select * from owner where id in (select parentid from ownerrelation t where ownerid=? )",userid);
		List<Map<String,Object>> list=MyDBUtils.queryForMapToUC("select t1.*,t2.ownername from (select level lv,t.ownerid from ownerrelation t start with t.ownerid =? CONNECT BY PRIOR t.parentid = t.ownerid) t1,owner t2 where t1.ownerid=t2.id and t2.flag='4' ",userid);
		return list;	
	}	
	
	//根据手机号获取userid
	public static String getuserIdByMobile(String mobile){
		String accessToken=getNewAccessToken();
		Map mapParam = new HashMap();
		String url="https://oapi.dingtalk.com/user/get_by_mobile?access_token="+accessToken+"&mobile="+mobile;
		String result=JsoupUtil.sendGet(url, mapParam, "utf-8");
		Map<String,Object> map=GsonHelp.fromJson(result);
		String userid=(String)map.get("userid");
		return userid;
	}
	public static void main(String[] args) {
		getuserIdByMobile("13758176027");
	}
}
