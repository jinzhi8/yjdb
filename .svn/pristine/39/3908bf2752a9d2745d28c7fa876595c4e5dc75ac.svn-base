package com.kizsoft.yjdb.xwfx;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.kizsoft.yjdb.utils.CommonUtil;
import com.kizsoft.yjdb.utils.GsonHelp;
import com.kizsoft.yjdb.utils.JsoupUtil;
import com.kizsoft.yjdb.utils.PropertiesUtil;


public class Impl {
	private static String saveUrl = new PropertiesUtil().getDdValueByKey("saveUrl");
	private static String pubKey = new PropertiesUtil().getDdValueByKey("pubKey");
	private static String appid = new PropertiesUtil().getDdValueByKey("appid");
	private static String jrtjUrl = new PropertiesUtil().getDdValueByKey("jrtjUrl");
	
	public static void save(String code,String userid,String ip){
		Map map=new HashMap();
		/*System.out.println("ip:"+ip);*/
		String data="appid="+appid+",code="+code+",timestamp="+CommonUtil.getSjcTime()+",platform=browser,ip="+ip+",serialnumber="+userid;
		String encryptedData=MyRSAUtils.encryptedDataOnJava(data,pubKey);
		map.put("data", encryptedData);
		map.put("appid", appid);
		String result=JsoupUtil.sendPost(saveUrl, map, "utf-8");
	}
	
	public static String sign(){
		Map map=new HashMap();
		map.put("appid", appid);
		String result=JsoupUtil.sendPost(jrtjUrl, map, "utf-8");
		Map<String,Object> mapJson=GsonHelp.fromJson(result);
		Map<String,Object> data=(Map<String, Object>) mapJson.get("data");
		String sign=(String)data.get("sign");
		return sign;
	}

	public static void main(String[] args) {
		System.out.println();
	}
	
	
}
