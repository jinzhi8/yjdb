package com.kizsoft.yjdb.utils;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;

import com.alibaba.fastjson.JSONObject;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonArray;
import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParseException;
import com.google.gson.reflect.TypeToken;

public class GsonHelp {
	
	public static void main(String[] args) {
		String json = "{\"a\":3.0,\"b\":2,\"s\":null,\"aa\":[{\"cc\":13}],\"bb\":{\"aaa\":1}}";
		Map<String ,Object> m = fromJsonFieldStr(json);
		
		System.out.println(toJson(m));
	}
	private static Gson gson=new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();
	private static Gson gson2=new GsonBuilder().registerTypeAdapter(
			new TypeToken<TreeMap<String, Object>>(){}.getType(), 
			new JsonDeserializer<TreeMap<String, Object>>() {
				
				public void cursorMap(JsonElement json,Map<String,Object> m){
					JsonObject jsonObject = json.getAsJsonObject();
					Set<Map.Entry<String, JsonElement>> entrySet = jsonObject.entrySet();
					for (Map.Entry<String, JsonElement> entry : entrySet) {
						Object value = entry.getValue();
						if(value != null ){                		
							if(value.toString().matches("^\\d+(\\.\\d+)?$")){
								m.put(entry.getKey(), value.toString());
								
								continue;
							}else if(value instanceof JsonArray){
								List<Object> mm = new ArrayList< Object>();
								cursorList(((JsonArray)value),mm);
								m.put(entry.getKey(),mm);
								continue;
							}else if(value instanceof JsonObject){
								TreeMap<String,Object> mm = new TreeMap<String, Object>();
								cursorMap((JsonObject)value,mm);
								m.put(entry.getKey(),mm);
								
								continue;
							}
						}
						m.put(entry.getKey(), value);
						
					}
				}
				
				public void cursorList(JsonArray list ,List<Object> list2){
					Iterator<JsonElement> it = list.iterator();
					while(it.hasNext()){
						TreeMap<String,Object> mm = new TreeMap<String, Object>();
						list2.add(mm);
						cursorMap(it.next(),mm);
					}
//					it.
//					while){
//						
//					}
				}
				@SuppressWarnings("unchecked")
				@Override
				public TreeMap<String, Object> deserialize(
						JsonElement json, Type typeOfT, 
						JsonDeserializationContext context) throws JsonParseException {
					
					TreeMap<String, Object> Map = new TreeMap<>();
					JsonObject jsonObject = json.getAsJsonObject();
					cursorMap(jsonObject,Map);
					return Map;
				}
			}).setDateFormat("yyyy-MM-dd HH:mm:ss").create();

	
    /**
     * object --> String
     * @param obj
     * @return
     */
    public static String toJson(Object obj){
        return gson.toJson(obj);
    }

    /**
     * object(json) --> map
     * @param dto
     * @return
     */
    public static Map<String,Object> fromObject(Object dto){
       return gson.fromJson(toJson(dto),Map.class);
    }
    
    /**
     * String(json) --> map
     * @param json
     * @return
     */
    public static Map<String,Object> fromJson(String json){
       return gson.fromJson(json,Map.class);
    }
    
    /**
     * String(json) --> map
     * @param json
     * @return
     */
    public static Map<String,Object> fromJsonFieldStr(String json){
    	return gson2.fromJson(json,new TypeToken<TreeMap<String, Object>>(){}.getType());
    }
    
    /**
     * String(json) --> T
     * @param json
     * @return
     */
    public static <T> T fastJson(String json) {
    	return (T) JSONObject.parse(json);
    }
    
    /** 把JSON字符转换为对�?*/
    public static <T> T formObjectFieldStr(Type type, String json) {
    	return gson2.fromJson(json, type);
    }
    /** 把JSON字符转换为对�?*/
	public static <T> T formObject(Type type, String json) {
		return gson.fromJson(json, type);
	}
	
	public static <T> T formObject(Class clazz, String json){
		return (T) gson.fromJson(json, clazz);
	}
            
}
