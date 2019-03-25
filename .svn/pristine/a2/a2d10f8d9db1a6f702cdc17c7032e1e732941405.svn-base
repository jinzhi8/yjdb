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


public class wnThread implements Runnable{
	private String path;
	private ExecutorService service; 
	 
	public wnThread(String path){
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
			System.out.println("插入蜗牛!");
			List<Map<String,Object>> list=MyDBUtils.queryForMapToUC("select * from yj_lr where to_char(to_date(jbsx,'yyyy-MM-dd'),'yyyymmdd')=to_char(sysdate-10,'yyyymmdd')  and state='1' ");
			for(Map<String,Object> map:list){
				String unid=(String)map.get("unid");
				MyDBUtils.executeUpdate("update yj_lr set whstatus='1' where unid=?",unid);
			}
			List<Map<String,Object>> zxList=MyDBUtils.queryForMapToUC("select unid,count(unid) from yj_dbstate_child t where to_char(to_date(substr(jbsx,14,10),'yyyy-MM-dd'),'yyyymmdd')<to_char(sysdate-10,'yyyymmdd')  group by unid having count(unid)>=2");
			for(Map<String,Object> map:zxList){
				String unid=(String)map.get("unid");
				MyDBUtils.executeUpdate("update yj_lr set whstatus='1' where unid=?",unid);
			}	
			Thread.sleep(60*1000*60*24);
		} catch (Exception e) {
			e.printStackTrace();
		}//休眠1天
	}		 
		/**
		 * 内部类   
		 * 线程异常重启
		 * @author Administrator
		 *
		 */
		class MyUncaughtExceptionHandler implements UncaughtExceptionHandler{
			public void uncaughtException(Thread ts, Throwable e) {
				service.execute(new wnThread(path));
			}
		}
}
