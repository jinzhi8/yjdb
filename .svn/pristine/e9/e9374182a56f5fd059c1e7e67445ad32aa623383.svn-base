package com.kizsoft.webThread;

import java.lang.Thread.UncaughtExceptionHandler;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ExecutorService;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;

import com.kizsoft.commons.commons.orm.MyDBUtils;
import com.kizsoft.yjdb.ding.DingSendMessage;
import com.kizsoft.yjdb.utils.CommonUtil;
import com.kizsoft.yjdb.utils.GsonHelp;
import com.kizsoft.yjdb.utils.JsoupUtil;
import com.kizsoft.yjdb.utils.PropertiesUtil;
import com.kizsoft.yjdb.xwfx.Impl;


public class dingThread implements Runnable{
	private String path;
	private ExecutorService service; 
	 
	public dingThread(String path){
		super();
		this.path = path;
	}
		
	public void run() {
		 while(true) {
			 doWork();
		 }
	 }
		
	private synchronized void doWork(){
		try {
			List<Map<String,Object>> list=MyDBUtils.queryForMapToUC("select * from yj_lr_message t  where status='0' order by time desc ");
			for(Map<String,Object> map:list){
				String unid=(String)map.get("unid");
				String userid=CommonUtil.doStr((String)map.get("userid"));
				String dcontent=CommonUtil.doStr((String)map.get("dcontent"));
				String mobile=CommonUtil.doStr((String)map.get("mobile"));
				if("".equals(mobile)||"".equals(dcontent)){
					MyDBUtils.executeUpdate("update yj_lr_message set status='1' where unid=?",unid);
					continue;
				}else{
					String result=send(mobile,dcontent,userid);
					if(result==null){
						MyDBUtils.executeUpdate("update yj_lr_message set status='0',result=? where unid=?","发送异常",unid);
						System.out.println("接口异常");
					}else{
						MyDBUtils.executeUpdate("update yj_lr_message set status='1',result=? where unid=?",result,unid);
					}
				}
				
			}
			Thread.sleep(10*1000);
		} catch (Exception e) {
			e.printStackTrace();
		}//休眠1天
	}
	
	//发送顶消息提醒
	public static String send(String mobile,String content,String userid){
		String url="";
		try {
			url = PropertiesUtil.getDlValueByKey("dingUrl");
			Impl.save("message",userid,"");
			Map map=new HashMap();
			map.put("mobile", mobile);
			map.put("textContent", content);
			String getzxl=JsoupUtil.sendPost(url,map,"UTF-8");
			Map<String,Object> mapm=GsonHelp.fromJson(getzxl);
			Map<String,Object> data=GsonHelp.fromJson((String)mapm.get("data"));
			String message=(String)data.get("message");
			return message;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	 
		/**
		 * 内部类   
		 * 线程异常重启
		 * @author Administrator
		 *
		 */
		class MyUncaughtExceptionHandler implements UncaughtExceptionHandler{
			public void uncaughtException(Thread ts, Throwable e) {
				service.execute(new dingThread(path));
			}
		}
}
