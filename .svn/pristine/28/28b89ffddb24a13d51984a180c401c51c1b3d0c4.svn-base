package com.kizsoft.commons.common.bean;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class WebResult {

	private int code;
	private boolean success;
	private String msg;
	private Object data;
	private long timestamp;
	
	private static Properties message = new Properties();
	static {
			 InputStream in = WebResult.class.getResourceAsStream("/configprop/message_zh_CN.properties");
		 try {
			 message.load(in);
		 } catch (IOException e) {
			 e.printStackTrace();
		 }
	}
	
	public String getValueByKey(String key){		
		return message.getProperty(key);
	}
	
	public WebResult(int code) {
		super();
		this.code = code;
		this.success = code == 1;
		this.msg = getValueByKey(code + "");
		this.timestamp = System.currentTimeMillis();
	}

	public WebResult(int code, Object data) {
		super();
		this.code = code;
		this.success = code == 1;
		this.msg = getValueByKey(code + "");
		this.data = data;
		this.timestamp = System.currentTimeMillis();
	}

	public WebResult(int code, String msg, Object data) {
		super();
		this.code = code;
		this.success = code == 1;
		this.msg = (msg != null ? msg : getValueByKey(code + ""));
		this.data = data;
		this.timestamp = System.currentTimeMillis();
	}

	public WebResult newMap(int code, String msg, Object data) {
		return new WebResult(code, msg, data);
	}

	// public WebResult(int code, boolean success, String msg, Object data) {
	// super();
	// this.code = code;
	// this.success = success;
	// this.msg = msg;
	// this.data = data;
	// this.timestamp=System.currentTimeMillis();
	// }

	public int getCode() {
		return code;
	}

	public void setCode(int code) {
		this.code = code;
	}

	public boolean isSuccess() {
		return success;
	}

	public void setSuccess(boolean success) {
		this.success = success;
	}

	public String getMsg() {
		return msg;
	}

	public void setMsg(String msg) {
		this.msg = msg;
	}

	public Object getData() {
		return data;
	}

	public void setData(Object data) {
		this.data = data;
	}

	public long getTimestamp() {
		return timestamp;
	}

	public void setTimestamp(long timestamp) {
		this.timestamp = timestamp;
	}

}
