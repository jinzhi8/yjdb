package com.kizsoft.oa.wcoa.util;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class test {
	public static void main(String[] args) {
		Object a="20170215";
		Object b="20170216";
		Integer tempa=Integer.valueOf(a.toString()); 
		System.out.println(tempa);
		Integer tempb=Integer.valueOf(b.toString()); 
		System.out.println(tempb);
		System.out.println(tempa+"\r"+tempb);
		System.out.println(tempa+"\n"+tempb);
	}
	public void  aa(){
		SimpleORMUtils instance=SimpleORMUtils.getInstance();
	}
	
	public static String plusDay(int num,String newDate) {
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        Date currdate = null;
		try {
			currdate = format.parse(newDate);
		} catch (ParseException e) {
			e.printStackTrace();
		}
        Calendar ca = Calendar.getInstance();
        ca.add(Calendar.DATE, num);// num为增加的天数，可以改变的
        currdate = ca.getTime();
        String enddate = format.format(currdate);
        return enddate;
    }
}
