package com.kizsoft.yjdb.utils;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;
import org.jsoup.Connection.Method;
import org.jsoup.Connection.Response;
import org.jsoup.Jsoup;

public class JsoupUtil {
	public static Logger log = Logger.getLogger(JsoupUtil.class);

	
	public static String sendPost(String url,Map<String,String> params,String encode){
		String res;
		try {
	        log.info(url);
			Response response=Jsoup.connect(url).data(params).ignoreContentType(true).postDataCharset(encode).timeout(200000).method(Method.POST).execute();
			res = new String(response.bodyAsBytes(),encode);
		} catch (IOException e) {
			e.printStackTrace();
			return null;
		}
		return res;
	}
	

	public static String sendGet(String url,Map<String,String> params,String encode){
		String res;
		try {
	        log.info(url);
			Response response=Jsoup.connect(url).data(params).ignoreContentType(true).postDataCharset(encode).timeout(200000).method(Method.GET).execute();
			res = new String(response.bodyAsBytes(),encode);
		} catch (IOException e) {
			e.printStackTrace();
			return null;
		}
		return res;
	}
}
