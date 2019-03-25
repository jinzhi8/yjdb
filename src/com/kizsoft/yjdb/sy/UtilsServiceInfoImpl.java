package com.kizsoft.yjdb.sy;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.kizsoft.commons.commons.attachment.CommonAttachment;
import com.kizsoft.commons.commons.orm.MyDBUtils;
import com.kizsoft.commons.util.UUIDGenerator;
import com.kizsoft.yjdb.doc.Util;
import com.kizsoft.yjdb.utils.CommonUtil;
import com.kizsoft.yjdb.utils.DocUtil;
import com.kizsoft.yjdb.utils.ExcelUtils;
import com.kizsoft.yjdb.utils.GsonHelp;
import com.kizsoft.yjdb.utils.JsoupUtil;
import com.kizsoft.yjdb.utils.PropertiesUtil;

public class UtilsServiceInfoImpl {
		//生成word文档
		public String getWord(Object[] obj) throws Exception{
			Map<String,Object> Map =(Map<String,Object>)obj[0];
			HttpServletRequest request=(HttpServletRequest) Map.get("request");
			HttpServletResponse response=(HttpServletResponse) Map.get("response");
			String chkid=CommonUtil.doStr((String) Map.get("unid"));
			Object[] chkids = (Object[]) chkid.split(",");
			String unids = "";
			for (int i = 0; i < chkids.length; i++) {
				if (i == chkids.length - 1) {
					unids += "'" + chkids[i] + "'";
					continue;
				}
				unids += "'" + chkids[i] + "',";
			}
			String type=CommonUtil.doStr((String) Map.get("status"));
			Map<String,Object> map=MyDBUtils.queryForUniqueMapToUC("select t.*,h.title hymc,h.createtime hytime from yj_lr t left join yj_hy h on t.docunid=h.unid  where t.unid=?",chkids[0]);
			String bcPath = request.getSession().getServletContext().getRealPath("/attachment/tzd/");
			/*bcPath=bcPath+"/";*/
			String attachmentDir ="/attachment/tzd/";
			File file = new File(bcPath);
			if  (!file .exists()&& !file .isDirectory()){
			     file.mkdirs();
			}
			//是否会议
			String ishy=CommonUtil.doStr((String) map.get("ishy"));
			String attachmentid=UUIDGenerator.getUUID();
			String dtype=(String) map.get("dtype");
			String attachmentName="";
			String wzbt="";
			String filePath="";
			String docunid=CommonUtil.doStr((String) map.get("docunid"));
			String show=CommonUtil.getJtsx(request,docunid,unids,chkids[0]);
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月dd日");
			SimpleDateFormat sdfs = new SimpleDateFormat("yyyy-MM-dd");
			SimpleDateFormat sdfss = new SimpleDateFormat("MM月dd日");
			String fklx=(String) map.get("fklx");
			String jbsx=(String) map.get("jbsx");
	        String date = sdf.format(sdfs.parse((String) map.get("createtime")));
			String qjtime="";
			if("1".equals(fklx)) {
				String jbsxtime=sdfss.format(sdfs.parse((String) map.get("jbsx")));
				qjtime="截止日期为"+jbsxtime;
			}else {
				List zqtime=GsonHelp.fastJson(GsonHelp.toJson(CommonUtil.zqtime((String)chkids[0])));
				String[] qjStr=((String)zqtime.get(zqtime.size()-1)).split(" - ");
				String time1=sdfss.format(sdfs.parse(qjStr[0]));
				String time2=sdfss.format(sdfs.parse(qjStr[1]));
				qjtime="本区间截止日期为"+time2;
			}
			Map dataMap=new HashMap();
			if(type.equals("tzd")){
				if("2".equals(dtype)&&!ishy.equals("1")){
					attachmentName=map.get("title")+"-督办通知单(信访局)"+".doc";
					wzbt="永嘉县信访工作联席会议办公室";
					filePath="tzd-xzrx.docx";
				}else if("3".equals(dtype)&&!ishy.equals("1")){ 
					attachmentName=map.get("title")+"-督办通知单(两个责任)"+".doc";
					wzbt="永嘉县委主体办";
					filePath="tzd.docx";
				}else if("1".equals(dtype)&&!ishy.equals("1")){
					//批示
					attachmentName=map.get("title")+"-县领导批示办理单"+".doc";
					filePath="xzf-tzd.docx";
				}else if(ishy.equals("1")&&("2".equals(dtype)||"3".equals(dtype))){
					filePath="hytzd.docx";
				}else{
					//会议
					attachmentName=map.get("title")+"-县政府重要决策事项办理单"+".doc";
					filePath="xzfhy-tzd.docx";
					dataMap.put("qjtime",qjtime); 
				}
			    dataMap.put("cbdw",CommonUtil.doStr((String)map.get("qtdepname"))+" "+CommonUtil.doStr((String)map.get("zrdepname"))); 
			    dataMap.put("phdw",CommonUtil.doStr((String)map.get("phdepname")));
			}else{
				if("2".equals(dtype)&&!ishy.equals("1")){
					attachmentName=map.get("title")+"-督办提醒单（县领导）"+".doc";
					wzbt="永嘉县信访工作联席会议办公室";
					filePath="txd.docx";
				}else if("3".equals(dtype)&&!ishy.equals("1")){ 
					attachmentName=map.get("title")+"-督办提醒单（县领导）"+".doc";
					wzbt="永嘉县委主体办";
					filePath="txd.docx";
				}else if("1".equals(dtype)&&!ishy.equals("1")){
					//批示
					attachmentName=map.get("title")+"-林万乐县长批示办理提醒单"+".doc";
					filePath="xzf-txd.docx";
				}else if(ishy.equals("1")&&("2".equals(dtype)||"3".equals(dtype))){
					filePath="hytzd.docx";
				}else{
					attachmentName=map.get("title")+"-县政府重要决策事项办理提醒单"+".doc";
					filePath="xzfhy-txd.docx";
				}
			    dataMap.put("cbdw", CommonUtil.doStr((String)map.get("qtperson"))); 
			    dataMap.put("phdw",CommonUtil.doStr((String)map.get("phperson")));

			}
			String newpathname=attachmentid+".doc";
			String newfile=attachmentDir+newpathname;
			CommonAttachment bean=new CommonAttachment();
			bean.setAttachmentid(attachmentid);
			bean.setDocunid("tzd");
			bean.setAttachmentname(attachmentName);
			bean.setAttachmentpath(newfile);
			MyDBUtils.insert(bean);
			String ljPath=bcPath+newpathname;
			String fklxshow="";
			String fkzq=(String) map.get("fkzq");
			if("1".equals(fklx)){
				fklxshow="一次性反馈";
			}else if("2".equals(fklx)){
				switch(fkzq){
					case "1":
						fklxshow="每7天一个报送周期";
						break;
					case "2":
						fklxshow="每15天一个报送周期";
						break;
					case "3":
						fklxshow="每30天一个报送周期";
						break;
					case "4":
						fklxshow="每半年一个报送周期";
						break;
					default:
						fklxshow="每7天一个报送周期";
				}
			}else if("3".equals(fklx)){
				fklxshow="每月"+fkzq+"号前反馈";
			}else{
				fklxshow="每周"+ (fkzq == "七"? "日":fkzq) +"前反馈";
			}	
			dataMap.put("wzbt", CommonUtil.doStr(wzbt)); 
			dataMap.put("hymc", CommonUtil.doStr((String)map.get("hymc"))); 
			dataMap.put("hytime", CommonUtil.doStr((String)map.get("hytime"))); 
			dataMap.put("bh", CommonUtil.doStr((String)map.get("bh")));  
		    dataMap.put("qfr", CommonUtil.doStr((String)map.get("psperson"))); 
		    dataMap.put("dbsx",CommonUtil.doStr((String)map.get("title"))); 
		    dataMap.put("fklx", fklxshow);  
		    dataMap.put("jzsj",CommonUtil.doStr((String)map.get("jbsx"))); 
		    dataMap.put("dbnr",CommonUtil.doStr((String)map.get("details")));  
		    dataMap.put("createtime",CommonUtil.doStr((String)map.get("createtime")));  		   
		    dataMap.put("title", CommonUtil.doStr(wzbt));
		    dataMap.put("lwdw", CommonUtil.doStr((String)map.get("lwdepname")));
		    dataMap.put("psld", CommonUtil.doStr((String)map.get("psperson")));
		    dataMap.put("lxr", CommonUtil.doStr((String)map.get("lxrname")));
		    dataMap.put("mobile", CommonUtil.doStr((String)map.get("lxrmobile")));
		    dataMap.put("short", CommonUtil.doStr((String)map.get("lxrshort")));
		    dataMap.put("date",date); 
		    dataMap.put("show", show);
		    //再批示
			dataMap.put("zps",Util.getPsl((String) chkids[0]));
		    dataMap.put("psperson", CommonUtil.doStr((String)map.get("psperson")));
		    String dw=(CommonUtil.getName(CommonUtil.doStr((String)map.get("qtdepname")))+CommonUtil.doStr((String)map.get("phdepname"))+CommonUtil.doStr((String)map.get("zrdepname"))).replace(","," ");
			dataMap.put("dw",dw); 
			String ld=(CommonUtil.getName(CommonUtil.doStr((String)map.get("qtperson")))+CommonUtil.doStr((String)map.get("phperson"))).replace(","," ");
			dataMap.put("ld",ld); 
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
			JsoupUtil.sendPost(url,dataMap,"UTF-8");
			//doc.createDoc(ljPath, dataMap,tzdlj);
			return "{\"unid\":\""+attachmentid+"\"}";
		}
}
