package com.kizsoft.yjdb.sy;

import java.io.File;
import java.text.DecimalFormat;
import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.kizsoft.commons.commons.attachment.CommonAttachment;
import com.kizsoft.commons.commons.orm.MyDBUtils;
import com.kizsoft.commons.util.UUIDGenerator;
import com.kizsoft.yjdb.doc.Util;
import com.kizsoft.yjdb.utils.CommonUtil;
import com.kizsoft.yjdb.utils.GsonHelp;
import com.kizsoft.yjdb.utils.JsoupUtil;
import com.kizsoft.yjdb.utils.KpTj;
import com.kizsoft.yjdb.utils.PropertiesUtil;

public class DocUtil {
	public String getWord(Object[] obj) throws Exception{
		Map<String,Object> Map =(Map<String,Object>)obj[0];
		HttpServletRequest request=(HttpServletRequest) Map.get("request");
		HttpServletResponse response=(HttpServletResponse) Map.get("response");
		String time=CommonUtil.doStr((String) Map.get("time")).replaceAll(" ", "");//2018-08-11 - 2018-09-12
		String[] timeStr=time.split("-");
		String startYear="";
		String endYear="";
		String startMonth=timeStr[1];
		String startDay=timeStr[2];
		String endMonth=timeStr[4];
		String endDay=timeStr[5];
		try{
			startYear=timeStr[0];
			endYear=timeStr[3];
			if(!startMonth.equals("10"))
				startMonth=startMonth.replace("0","");
			if(!endMonth.equals("10"))
				endMonth=endMonth.replace("0","");
		}catch(Exception e){
			e.printStackTrace();
		}
		String bcPath = request.getSession().getServletContext().getRealPath("/attachment/zwdblwl/");
		bcPath=bcPath+"/";
		String attachmentDir ="/attachment/zwdblwl/";
		File file = new File(bcPath);
		if  (!file .exists()&& !file .isDirectory()){
		     file.mkdirs();
		}
		String attachmentid=UUIDGenerator.getUUID();
		
		String newpathname=attachmentid+".docx";
		String newfile=attachmentDir+newpathname;
	    String filePath="";
		Map dataMap=new HashMap();
		dataMap.put("qs",CommonUtil.doStr((String) Map.get("qs"))); //期数 
	    dataMap.put("createtime",CommonUtil.getDateYMR()); //2018年7月16日 
	    dataMap.put("year", endYear); //年
	    dataMap.put("startmonth",startMonth);//1-6
	    dataMap.put("month",endMonth);//1-6
	    dataMap.put("day",timeStr[5]);//1-6

	    //季度报表
	    String start=startYear+"-"+startMonth;
	    String end=endYear+"-"+endMonth;
	    String tjxz=CommonUtil.doStr((String) Map.get("tjxz"));//类型
	    String attachmentName="";

	    if(tjxz.equals("1")){
	    	attachmentName="关于"+endYear+"年"+endMonth+"月份县政府重点交办事项督办落实情况的报告（呈林万乐县长）.docx";
		    filePath="zwdb-lwl.docx";
		    String time1=startYear+"-"+timeStr[1]+"-"+timeStr[2];
		    String time2=endYear+"-"+timeStr[4]+"-"+timeStr[5];
		    //年1-8月份督办“四会一批”、调研活动等重点交办事项X项
		    String count1=Util.getHyCount(time1, time2,"1")+"";
		    dataMap.put("count1",count1);
		    //8月份新增督办事项X项
		    String count2=Util.getHyGyCount(endYear+"-"+timeStr[4],"1")+"";
		    dataMap.put("count2",count2);
		    //截至8月底，办结X项
		    String count3=Util.getHyGyJzCount(time1,time2,"1")+"";
		    dataMap.put("count3",count3);
		    //未办结X项
		    String count4=Util.getHyGyJzWbjCount(time1,time2,"1")+"";
		    dataMap.put("count4",count4);
		    //办结率
		    DecimalFormat df = new DecimalFormat("#.00");
		    float num = ((float) Util.getHyGyJzCount(time1,time2,"1") / (Util.getHyGyJzWbjCount(time1,time2,"1")+Util.getHyGyJzCount(time1,time2,"1"))) * 100;
		    String count5="";
		    if(count4.equals("0")){
		    	count5="0";
	    	}else{
		    	count5=df.format(num)+"";
	    	}
		    dataMap.put("count5",count5);
		    
		    //各线上政务提醒排名
		    List<Map<String,Object>> lddfList=KpTj.getDataList("1", time1, time2);
		    dataMap.put("lddfList",GsonHelp.toJson(lddfList));
		    
		    //功能区、乡镇（街道）政务督办排名
		    List<Map<String,Object>> jddfList=KpTj.getDataList("3", time1, time2);
		    dataMap.put("jddfList",GsonHelp.toJson(jddfList));
		    
		    //县直属有关单位政务督办排名
		    List<Map<String,Object>> zsdfList=KpTj.getDataList("2", time1, time2);
			ListIterator<Map<String, Object>> it = zsdfList.listIterator();
			//要求去除信访局，时间2018-12-10日
			while(it.hasNext()) {
				Map<String, Object> map = it.next();
				if("100096449".equals(map.get("id"))) {
					it.remove();
				};
			}
		    dataMap.put("zsdfList",GsonHelp.toJson(zsdfList));
		    
		    //县属国有企业政务督办排名
		    List<Map<String,Object>> gyqyList=KpTj.getDataList("4", time1, time2);
		    dataMap.put("gyqyList",GsonHelp.toJson(gyqyList));
		    
		    //县重点工程建设单位政务
		    List<Map<String,Object>> zddwList=KpTj.getDataList("5", time1, time2);
		    dataMap.put("zddwList",GsonHelp.toJson(zddwList));
		    
	    	//林万乐县长督办件再批示部署专题督办情况汇总表----会议类、再批示、未办结、部署领导（林县长)
		    String hy_zc_wbj_bsl=Util.hy_zc_wbj_bsl(time1,time2);
		    dataMap.put("hy_zc_wbj_bsl",hy_zc_wbj_bsl);
		    
			//X月份“四会”、调研活动等重点交办事项继续跟踪督办件汇总表  -----会议类、未办结、部署领导（林县长）
		    String hy_wbj_bsl=Util.hy_wbj_bsl(time1,time2);
		    dataMap.put("hy_wbj_bsl",hy_wbj_bsl);
		    
		    //X月份“一批”继续督办情况汇总表---批示类、未办结、部署领导（林县长）
		    String ps_wbj_bsl=Util.ps_wbj_bsl(time1,time2);
		    dataMap.put("ps_wbj_bsl",ps_wbj_bsl);
		    
		    //X月份“四会”、调研活动等重点交办事项办结件汇总表----会议类、该月办结、部署领导（林县长）
		    String hy_bj_bsl=Util.hy_bj_bsl(endYear+"-"+timeStr[4]);
		    dataMap.put("hy_bj_bsl",hy_bj_bsl);

		    //X月份“一批”办结件汇总表----批示类、办结、该月（林县长）、部署领导（林县长）
		    String ps_bj_bsl=Util.ps_bj_bsl(endYear+"-"+timeStr[4]);
		    dataMap.put("ps_bj_bsl",ps_bj_bsl);
	    }else if(tjxz.equals("3")){
	    	attachmentName=endMonth+"月份县政府督办件落实情况的通报.docx";
		    filePath="zwdb-bmdw.docx";
		    String time1=startYear+"-"+timeStr[1]+"-"+timeStr[2];
		    String time2=endYear+"-"+timeStr[4]+"-"+timeStr[5];
		    //年1-8月份督办“四会一批”、调研活动等重点交办事项X项
		    String count1=Util.getHyCount(time1, time2,"0")+"";
		    dataMap.put("count1",count1);
		    //8月份新增督办事项X项
		    String count2=Util.getHyGyCount(endYear+"-"+timeStr[4],"0")+"";
		    dataMap.put("count2",count2);
		    //截至8月底，办结X项
		    String count3=Util.getHyGyJzCount(time1,time2,"0")+"";
		    dataMap.put("count3",count3);
		    //未办结X项
		    String count4=Util.getHyGyJzWbjCount(time1,time2,"0")+"";
		    dataMap.put("count4",count4);
		    //办结率
		    DecimalFormat df = new DecimalFormat("#.00");
		    float num = ((float) Util.getHyGyJzCount(time1,time2,"0") / (Util.getHyGyJzWbjCount(time1,time2,"0")+Util.getHyGyJzCount(time1,time2,"0"))) * 100;
		    String count5="";
		    if(count4.equals("0")){
		    	count5="0";
	    	}else{
		    	count5=df.format(num)+"";
	    	}
		    dataMap.put("count5",count5);
		    		    
			//功能区、乡镇（街道）政务督办排名
		    List<Map<String,Object>> jddfList=KpTj.getDataList("3", time1, time2);
		    dataMap.put("jddfList",GsonHelp.toJson(jddfList));

			//县直属有关单位政务督办排名
			List<Map<String,Object>> zsdfList=KpTj.getDataList("2", time1, time2);
			ListIterator<Map<String, Object>> it = zsdfList.listIterator();
			while(it.hasNext()) {
				//要求去除信访局，时间2018-12-10日
				Map<String, Object> map = it.next();
				if("100096449".equals(map.get("id"))) {
					it.remove();
				};
			}
		    dataMap.put("zsdfList",GsonHelp.toJson(zsdfList));
		    
		    //县属国有企业政务督办排名
		    List<Map<String,Object>> gyqyList=KpTj.getDataList("4", time1, time2);
		    
		    dataMap.put("gyqyList",GsonHelp.toJson(gyqyList));
		    
		    //县重点工程建设单位政务
		    List<Map<String,Object>> zddwList=KpTj.getDataList("5", time1, time2);
		    dataMap.put("zddwList",GsonHelp.toJson(zddwList));
		    
	    	//林万乐县长督办件再批示部署专题督办情况汇总表----会议类、再批示、未办结、部署领导（林县长)
		    String hy_zc_wbj_bsl=Util.hy_zc_wbj_bsl(time1,time2);
		    dataMap.put("hy_zc_wbj_bsl",hy_zc_wbj_bsl);
		    
		    //X月份“四会”、调研活动等重点交办事项继续跟踪督办件汇总表  -----会议类、未办结、部署领导（林县长）
		    String hy_wbj_bsl=Util.hy_wbj_bsl(time1,time2);
		    dataMap.put("hy_wbj_bsl",hy_wbj_bsl);
	    }else if(tjxz.equals("2")){
	    	attachmentName=endYear+"年"+endMonth+"月份县政府督办件落实情况（线上通报）.docx";
		    filePath="zwdb-xstb.docx";
		    String time1=startYear+"-"+timeStr[1]+"-"+timeStr[2];
		    String time2=endYear+"-"+timeStr[4]+"-"+timeStr[5];
		    //年1-8月份督办“四会一批”、调研活动等重点交办事项X项
		    String count1=Util.getHyCount(time1, time2,"0")+"";
		    dataMap.put("count1",count1);
		    //8月份新增督办事项X项
		    String count2=Util.getHyGyCount(endYear+"-"+timeStr[4],"0")+"";
		    dataMap.put("count2",count2);
		    //截至8月底，办结X项
		    String count3=Util.getHyGyJzCount(time1,time2,"0")+"";
		    dataMap.put("count3",count3);
		    //未办结X项
		    String count4=Util.getHyGyJzWbjCount(time1,time2,"0")+"";
		    dataMap.put("count4",count4);
		    //办结率
		    DecimalFormat df = new DecimalFormat("#.00");
		    float num = ((float) Util.getHyGyJzCount(time1,time2,"0") /(Util.getHyGyJzWbjCount(time1,time2,"0")+Util.getHyGyJzCount(time1,time2,"0"))) * 100;
		    String count5="";
		    if(count4.equals("0")){
		    	count5="0";
	    	}else{
		    	count5=df.format(num)+"";
	    	}
		    dataMap.put("count5",count5);
		    //${month}月到期未办结的XX项
		    String getCjkCount=Util.getCjkCount()+"";
		    dataMap.put("getCjkCount",getCjkCount);
		    
		    String zhk=Util.getCjk("综合口")+"";
		    dataMap.put("zhk",zhk);
		    String cjk=Util.getCjk("城建口")+"";
		    dataMap.put("cjk",cjk);
		    String fzk=Util.getCjk("法制口")+"";
		    dataMap.put("fzk",fzk);
		    String jrk=Util.getCjk("金融口")+"";
		    dataMap.put("jrk",jrk);
		    String nk=Util.getCjk("农口")+"";
		    dataMap.put("nk",nk);
		    String mzsjk=Util.getCjk("民政市监口")+"";
		    dataMap.put("mzsjk",mzsjk);
		    String wjwk=Util.getCjk("文教卫口")+"";
		    dataMap.put("wjwk",wjwk);
		    String nlk=Util.getCjk("农旅口")+"";
		    dataMap.put("nlk",nlk);
		    String gyk=Util.getCjk("工业口")+"";
		    dataMap.put("gyk",gyk);
		    String zsrsk=Util.getCjk("招商人社口")+"";
		    dataMap.put("zsrsk",zsrsk);
		    
		    //各线上政务提醒排名
		    List<Map<String,Object>> lddfList=KpTj.getDataList("1", time1, time2);
		    dataMap.put("lddfList",GsonHelp.toJson(lddfList));
		    
	    	//X月份各线上政务继续提醒汇总表（会议类）----会议类、未办结、部署领导（所有）
		    String hy_wbj_bssy=Util.hy_wbj_bssy(time1,time2);
		    dataMap.put("hy_wbj_bssy",hy_wbj_bssy);
		    
		    //X月份“四会”、调研活动等重点交办事项继续跟踪督办件汇总表  -----批示类、未办结、部署领导（所有）
		    String ps_wbj_bssy=Util.ps_wbj_bssy(time1,time2);
		    dataMap.put("ps_wbj_bssy",ps_wbj_bssy);
	    }	    
	    String url=new PropertiesUtil().getDlValueByKey("toDoc");
	    //生成doc文档的路径
	    dataMap.put("wordAddress",bcPath+newpathname);
	    /*DocUtil doc=new DocUtil();*/
	    //模板路径
	    String confXmlName = File.separator + "configprop"+File.separator;
		String basePath = new File(UtilsServiceInfoImpl.class.getResource("/").getPath())+confXmlName;   
		dataMap.put("basePath",basePath);
		//doc模板名字
		dataMap.put("filePath",filePath);
		//生成配置文件路径
		dataMap.put("mbFilePath",bcPath);
		try{
			JsoupUtil.sendPost(url,dataMap,"UTF-8");
		}catch(Exception e){
			e.printStackTrace();
		}
		CommonAttachment bean=new CommonAttachment();
		bean.setAttachmentid(attachmentid);
		bean.setDocunid("zwdblwl");
		bean.setAttachmentname(attachmentName);
		bean.setAttachmentpath(newfile);
		MyDBUtils.insert(bean);
		return "{\"unid\":\""+attachmentid+"\"}";
	}
}
