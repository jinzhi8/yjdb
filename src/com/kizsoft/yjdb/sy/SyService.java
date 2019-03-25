package com.kizsoft.yjdb.sy;

import java.io.File;
import java.io.IOException;
import java.lang.reflect.Method;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.kizsoft.yjdb.utils.CommonUtil;


public class SyService extends HttpServlet{
	SyServiceInfoImpl impl=new SyServiceInfoImpl();
	UtilsServiceInfoImpl util=new UtilsServiceInfoImpl();
	DocUtil doc=new DocUtil();
	public void doGet(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException{
		   doPost(request, response);
	}  
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		  response.setContentType("text/html; charset=UTF-8");
	      response.setCharacterEncoding("utf-8");
	      request.setCharacterEncoding("utf-8");
	      response.setHeader("Access-Control-Allow-Origin", "*");  
	  	  response.setHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS, DELETE");  
	      response.setHeader("Access-Control-Max-Age", "3600");  
	  	  response.setHeader("Access-Control-Allow-Headers", "x-requested-with");
	      Map properties = request.getParameterMap(); 
	      Map map=getMap(request,response,properties);
	      String fname=CommonUtil.doStr((String) map.get("fname"));
	      String type=CommonUtil.doStr((String) map.get("type"));
		  String result ="";
	      Object[] obj = new Object[] {map};
	      try {
	    	  if("qt".equals(type)){
	    		  Method method = util.getClass().getMethod(fname, Object[].class);	    		   
	    		  result=(String) method.invoke(util,(Object)obj);
	    	  }else if("doc".equals(type)){
	    		  Method method = doc.getClass().getMethod(fname, Object[].class);	    		   
	    		  result=(String) method.invoke(doc,(Object)obj);
	    	  }else{
	    		  Method method = impl.getClass().getMethod(fname, Object[].class);	    		   
	    		  result=(String) method.invoke(impl,(Object)obj);
	    	  }
	      } catch (Exception e) {
	    	  e.printStackTrace();
			  result = "{\"reuslt\":\"0\",\"message\":\"方法调用错误\"}";
		  } 
	      response.getWriter().println(result);
	}
	
	public static Map getMap(HttpServletRequest request, HttpServletResponse response ,Map properties){
		Map returnMap = new HashMap(); 
		Iterator entries = properties.entrySet().iterator();  
	    Map.Entry entry;  
		String name = "";  
		String value = "";  
		while (entries.hasNext()) {  
		    entry = (Map.Entry) entries.next();  
		    name = (String) entry.getKey();  
		    Object valueObj = entry.getValue();  
		    if(null == valueObj){  
		        value = "";  
		    }else if(valueObj instanceof String[]){  
		        String[] values = (String[])valueObj;  
			    for(int i=0;i<values.length;i++){  
			         value = values[i] + ",";  
			    }  
			    value = value.substring(0, value.length()-1);  
		    }else{  
		        value = valueObj.toString();  
		    }  
		    returnMap.put(name, value);  
		}
		returnMap.put("request",request);
		returnMap.put("response",response);
		return returnMap;
	}
}
