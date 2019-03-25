package com.kizsoft.oa.wzbwsq.util;

import java.lang.reflect.Type;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

public class GsonHelp {
	public static Logger logger = LoggerFactory.getLogger(GsonHelp.class);
	public static Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").disableHtmlEscaping().create(); // 忽略html字符的转�?
	
	/**
	 * 对下转JSON
	 * @param obj
	 * @return
	 */
	public static String toJson(Object obj) {
		String str = gson.toJson(obj);
		if("".equals(str)){
			str = null;
		}
		return str;
	}
	/**
	 * Json转制定类型对下根据类型
	 * @param json
	 * @param type
	 * @return
	 */
	public <T> T fromJson(String json, Type type){
		return gson.fromJson(json, type);
	}
	/**
	 * Bean对下转Map
	 * @param dto
	 * @return
	 */
	public static Map<String,Object> fromObject(Object dto){
		return gson.fromJson(toJson(dto),Map.class);
	}
	
	/**
	 *把JSON字符转换为Map对象  
	 * @param json
	 * @return
	 */
    public static Map<String,Object> fromJson(String json){
       return gson.fromJson(json,Map.class);
    }
    /**
     * 把JSON字符转换为Bean对象
     * @param clazz
     * @param json
     * @return
     */
	public static <T> T formObject(Class clazz, String json){
		return (T) gson.fromJson(json, clazz);
	}
	
	/**
	 * 数据类型过滤：yyyy-MM-dd HH:mm:ss转yyyy-MM-dd
	 * @param source
	 * @param field
	 * @return
	 */
	public static String parseDate(String source,String field){
		
		return source.replaceAll("(\""+field+"\":\"\\d{4}-\\d{2}-\\d{2})\\s+\\d{2}?:\\d{2}?:\\d{2}?","$1" );
		
	}
	
	public static void main(String[] args) {
		logger.info(parseDate("sjkdskjds\"field\":\"2015-02-02 12:45:44\",dskjhskhds", "field"));
	}

}
