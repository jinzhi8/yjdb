package com.kizsoft.commons.common.util;
import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.Logger;


public class RequestUtil {
	public static Logger log = Logger.getLogger(RequestUtil.class);
	 
	/**
	 * ������ͨ������õ��������
	 * @author ����
	 * @return �������Map
	 */
	@SuppressWarnings("unchecked")
	public static Map<String, String> getAllParam(HttpServletRequest request) {
		return parseParameterMap(request.getParameterMap());
	}



	/**
	 * ����:ͨ������õ��ͻ���IP
	 * @param request
	 * @return �ͻ���IP
	 */
	public static String getIpAddress(HttpServletRequest request)
	{
		if(request!=null)
		{
			String ipAddress = request.getHeader("X-Forwarded-For");
		    if(ipAddress == null || ipAddress.length() == 0 || "unknown".equalsIgnoreCase(ipAddress)) {
		    	ipAddress = request.getHeader("Proxy-Client-IP");
		    }
		    if(ipAddress == null || ipAddress.length() == 0 || "unknown".equalsIgnoreCase(ipAddress)) {
		    	ipAddress = request.getHeader("WL-Proxy-Client-IP");
		    }
		    if(ipAddress == null || ipAddress.length() == 0 || "unknown".equalsIgnoreCase(ipAddress)) {
		    	ipAddress = request.getHeader("X-Real-IP");
		    }
		    if(ipAddress == null || ipAddress.length() == 0 || "unknown".equalsIgnoreCase(ipAddress)) {
		    	ipAddress = request.getRemoteAddr();
		    }
		    return ipAddress;
		}
		else
		{
			return "";
		}
	}
	
	/**
	 * ����:ͨ������õ��ͻ���IP�ǲ�������
	 * @param request
	 * @return true ����  false ����
	 */
	public static boolean isIntranet(HttpServletRequest request)
	{
		String ipAddress = getIpAddress(request);
		if (ipAddress!=null && !ipAddress.equals("") && ( ipAddress.indexOf("10.")==0 || ipAddress.indexOf("192.")==0 || ipAddress.indexOf("172.")==0 ))
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	
	
	/**
	 * ������������ѯ����
	 * @author ����
	 * @param paramMap
	 * @return
	 */
	@SuppressWarnings({ "rawtypes" })
	private static Map<String, String> parseParameterMap(
			Map<String, String[]> paramMap) {
		Map<String, String> returnMap = new HashMap<String, String>();
		if (paramMap == null)
			paramMap = new HashMap<String, String[]>();
		for (Iterator it = paramMap.entrySet().iterator(); it.hasNext();) {
			Map.Entry entry = (Map.Entry) it.next();
			String key = (String) entry.getKey();
			String[] value = (String[]) entry.getValue();
			String newValue = "";
			if (value == null) {
				newValue = null;
			} else if (value.length == 0) {
				newValue = "";
			} else if (value.length == 1) {
				newValue = value[0];
			} else {
				for (int i = 0; i < value.length; i++) {
					if (i == 0)
						newValue += value[0];
					else
						newValue += "," + value[i];
				}
			}
			returnMap.put(key, newValue);
		}
		return returnMap;
	}

	/**
	 * ����������cookie, ͨ�������cookie��õ�Cookie����
	 * @author 
	 * @param request
	 * @param cookieName
	 * @return
	 */
	public static Cookie parseCookie(HttpServletRequest request,
			String cookieName) {
		Cookie[] cookie = request.getCookies();
		for (int i = 0; cookie != null && i < cookie.length; i++) {
			if (cookie[i].getName().equals(cookieName))
				return cookie[i];
		}
		return null;
	}
	
	/**
	 * 
	 * ������get��ʽ��������
	 * @author ������
	 * @date  2015-3-9
	 */
	public static String getRequest(String strUrl,String encode){
		HttpURLConnection urlCon = null;
		try
		{
			URL url = new URL(strUrl);
			urlCon = (HttpURLConnection) url.openConnection();

			urlCon.setRequestMethod("GET");
			urlCon.setRequestProperty("content-type", "text/html");
			urlCon.setDoOutput(true);

			urlCon.getOutputStream().flush();
			urlCon.getOutputStream().close();
	        
			BufferedReader in = new BufferedReader(new InputStreamReader(urlCon.getInputStream(), encode));

			String line;
			String respXML = "";
			while ((line = in.readLine()) != null)
			{
				respXML += line;
			}
			in.close();

			return respXML;
		}
		catch (Exception e)
		{
			e.printStackTrace();
			return null;
		}
		finally
		{
			if (urlCon != null)
			{
				urlCon.disconnect();
			}
		}
	}
	
	/**
	 * �ύ����(д���������ʽ�ύ)
	 * @param strUrl �����ַ
	 * @param content ��������
	 * @param encode ����
	 * @return XML�ַ�
	 */
	public static String postRequest(String strUrl, String content, String encode) 
	{
		HttpURLConnection urlCon = null;
		try
		{
			URL url = new URL(strUrl);
			urlCon = (HttpURLConnection) url.openConnection();

			urlCon.setRequestMethod("POST");
			urlCon.setRequestProperty("content-type", "text/html");
			urlCon.setDoOutput(true);
			urlCon.setConnectTimeout(30000);
			urlCon.setReadTimeout(30000);
			
			urlCon.getOutputStream().write(content.getBytes(encode));
			urlCon.getOutputStream().flush();
			urlCon.getOutputStream().close();
	        
			BufferedReader in = new BufferedReader(new InputStreamReader(urlCon.getInputStream(), encode));

			String line;
			String respXML = "";
			while ((line = in.readLine()) != null)
			{
				respXML += line;
			}
			in.close();

			return respXML;
		}
		catch (Exception e)
		{
			e.printStackTrace();
			return null;
		}
		finally
		{
			if (urlCon != null)
			{
				urlCon.disconnect();
			}
		}
    }
	

	
	/**
	 * ����: �� InputStream ������л�ȡ�ַ���Ϣ
	 * @auther ������
	 * @date 2013-8-23 
	 * @param request
	 * @return
	 * @throws Exception
	 */
	public static String getStringFromStream(InputStream inputStream,String encode) {
		String requestXML = "";
		try
		{
			if(inputStream!=null){
				InputStreamReader inStreamRead = new InputStreamReader(inputStream,encode);
				BufferedReader buffRead = new BufferedReader(inStreamRead);
				String line;
				while((line = buffRead.readLine()) != null)
				{
					requestXML += line;
				}
			}
		}
		catch(Exception er){
			er.printStackTrace();
		}
		return requestXML;
	}
	
	
}
