package com.kizsoft.commons.util.statview;

import java.io.FileInputStream;
import java.io.InputStream;

import org.apache.log4j.Logger;

import javax.servlet.http.HttpServletRequest;

import com.kizsoft.commons.commons.user.User;
import com.kizsoft.yjdb.utils.GsonHelp;

public class StatViewTag {
	private static final Logger log = Logger.getLogger(StatViewTag.class);
	private static GsonHelp gson = new GsonHelp();
	/**
	 * 获取
	 * @param viewname
	 * @param req
	 * @return
	 */
	public static String getJsonStatView(String viewname,HttpServletRequest req){
		//视图路径
		String viewpath = req.getSession().getServletContext().getRealPath("/WEB-INF/config/statview/" + viewname + ".statview.xml");
		try{
			InputStream xmlstream = new FileInputStream(viewpath);
		    Stat stat = new Stat(xmlstream);
		    xmlstream.close();
		    return gson.toJson(stat);
		}catch (Exception e)
	    {
	      e.printStackTrace();
	      log.info("====statview tag false!====");
	    }
		return null;
	}
	
	public static String getJosnStatViewSql(String viewJson,String formData){
		
		
		log.info("====viewJson===="+viewJson);
		log.info("====formData===="+formData);
		
		return "";
	}

}
