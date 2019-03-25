package com.kizsoft.yjdb.utils;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
public class PropertiesUtil {
	
	/**
	 * 测试方法
	 * @throws IOException 
	 */
	public static void main(String[] args) throws IOException {
		System.out.println(new PropertiesUtil().getDdValueByKey("pubKeyDir"));
	}
	
	/**
	 * 获取WzsjwsService.properties文件Key对应的Value
	 */
	public static String getDdValueByKey(String key){
		String result = null;
		try {
			result = getValueByKeyAndFilePath(key,"/configprop/XwfxConfig.properties");
		} catch (IOException e) {
			e.printStackTrace();
		}
		return result;
	}	
	
	public static String getDlValueByKey(String key){
		String result = null;
		try {
			result = getValueByKeyAndFilePath(key,"/configprop/DingDing.properties");
		} catch (IOException e) {
			e.printStackTrace();
		}
		return result;
	}	
	
	
	/**根据key读取value。Properties文件
	 * @throws IOException 
	 */
	private static String getValueByKeyAndFilePath(String key,String filePath) throws IOException  {
		Properties props = new Properties();
		InputStream in = PropertiesUtil.class.getResourceAsStream(filePath);
		props.load(in);
		return props.getProperty(key);
	}
	
	

}
