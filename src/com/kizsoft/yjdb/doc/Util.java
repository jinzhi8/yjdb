package com.kizsoft.yjdb.doc;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.kizsoft.commons.commons.orm.MyDBUtils;
import com.kizsoft.yjdb.utils.CommonUtil;
import com.kizsoft.yjdb.utils.GsonHelp;

public class Util {
	//林万乐县长督办件再批示部署专题督办情况汇总表----会议类、再批示、未办结、部署领导（林县长)
	public static String hy_zc_wbj_bsl(String start,String end){
		String sql="select  to_char(to_date(time1,'yyyy-mm-dd'),'yyyy\"年\"mm\"月\"dd\"日\"') time,c.*  from(select a.title as hybt,a.status as hystatus,a.createtime time1,b.*,decode(b.state,'2','办结','继续督办')dbzt,decode((to_char(to_date(a.createtime, 'YYYY-MM-DD'), 'MM')),'01','1月督办','02','2月督办','03','3月督办','04','4月督办', '05','5月督办','06','6月督办', '07','7月督办','08','8月督办', '09','9月督办','10','10月督办', '11','11月督办','12','12月督办') bz from yj_hy a left join yj_lr b on a.unid=b.docunid where exists(select p.dbid from yj_lr_ps p where p.dbid=b.unid)  and to_date(a.createtime,'yyyy-MM-dd')  between  to_date('"+start+"', 'yyyy-MM-dd') and to_date('"+end+"', 'yyyy-MM-dd')   )c where state='1' and psperson='林万乐' order by hystatus,to_number(regexp_replace(bh,'[^0-9]')) desc,hybt,sort ";
		List<Map<String,Object>> txdList=MyDBUtils.queryForMapToUC(sql);
	    for(Map<String,Object> map:txdList ) {
	    	String dbunid=(String)map.get("unid");
	    	Map fkqkMaP=new HashMap();
			String ld=getld((String)map.get("qtperson"),(String)map.get("phperson"));
		    String dw=getdw((String)map.get("qtdepname"),(String)map.get("phdepname"),(String)map.get("zrdepname"));
	    	List<Map<String,Object>> fkqkLsit=getFk(dbunid);
	    	List<Map<String,Object>> getPs=getPs(dbunid);
	    	map.put("ps",getPs);
	    	map.put("fk",fkqkLsit);
	    	map.put("ld",ld);
	    	map.put("dw",dw);
	    }
		return getZy(GsonHelp.toJson(txdList));
		
	}
	
	
	//X月份“四会”、调研活动等重点交办事项继续跟踪督办件汇总表  -----会议类、未办结、部署领导（林县长）
	public static String hy_wbj_bsl(String start,String end){
		String sql="select to_char(to_date(time1,'yyyy-mm-dd'),'yyyy\"年\"mm\"月\"dd\"日\"') time,c.*  from(select a.title as hybt,a.status as hystatus,a.createtime time1,b.*,decode(b.state,'2','办结','继续督办')dbzt,decode((to_char(to_date(a.createtime, 'YYYY-MM-DD'), 'MM')),'01','1月督办','02','2月督办','03','3月督办','04','4月督办', '05','5月督办','06','6月督办', '07','7月督办','08','8月督办', '09','9月督办','10','10月督办', '11','11月督办','12','12月督办') bz from yj_hy a left join yj_lr b on a.unid=b.docunid where to_date(b.createtime,'yyyy-MM-dd')  between  to_date('"+start+"', 'yyyy-MM-dd') and to_date('"+end+"', 'yyyy-MM-dd')  )c where state='1' and psperson='林万乐'  order by hystatus,to_number(regexp_replace(bh,'[^0-9]')) desc,hybt,sort ";
		List<Map<String,Object>> txdList=MyDBUtils.queryForMapToUC(sql);
	    for(Map<String,Object> map:txdList ) {
	    	String dbunid=(String)map.get("unid");
	    	Map fkqkMaP=new HashMap();
			String ld=getld((String)map.get("qtperson"),(String)map.get("phperson"));
		    String dw=getdw((String)map.get("qtdepname"),(String)map.get("phdepname"),(String)map.get("zrdepname"));
	    	List<Map<String,Object>> fkqkLsit=getFk(dbunid);
	    	List<Map<String,Object>> getPs=getPs(dbunid);
	    	map.put("ps",getPs);
	    	map.put("fk",fkqkLsit);
	    	map.put("ld",ld);
	    	map.put("dw",dw);
	    }
		return getZy(GsonHelp.toJson(txdList));
		
	}
	
	
	
	//X月份“一批”继续督办情况汇总表---批示类、未办结、部署领导（林县长）
	public static String ps_wbj_bsl(String start,String end){
		String sql="select to_char(to_date(createtime,'yyyy-mm-dd'),'yyyy\"年\"mm\"月\"dd\"日\"') time,c.*  from(select b.*,decode(b.state,'2','办结','继续督办')dbzt,decode((to_char(to_date(b.createtime, 'YYYY-MM-DD'), 'MM')),'01','1月督办','02','2月督办','03','3月督办','04','4月督办', '05','5月督办','06','6月督办', '07','7月督办','08','8月督办', '09','9月督办','10','10月督办', '11','11月督办','12','12月督办') bz from  yj_lr b  where to_date(b.createtime,'yyyy-MM-dd')  between  to_date('"+start+"', 'yyyy-MM-dd') and to_date('"+end+"', 'yyyy-MM-dd')   )c where c.state='1' and c.psperson='林万乐' and c.ishy='0' and c.dtype='1' order by  to_number(regexp_replace(bh,'[^0-9]')) desc ";
		List<Map<String,Object>> txdList=MyDBUtils.queryForMapToUC(sql);
	    for(Map<String,Object> map:txdList ) {
	    	String dbunid=(String)map.get("unid");
	    	Map fkqkMaP=new HashMap();
			String ld=getld((String)map.get("qtperson"),(String)map.get("phperson"));
		    String dw=getdw((String)map.get("qtdepname"),(String)map.get("phdepname"),(String)map.get("zrdepname"));
	    	List<Map<String,Object>> fkqkLsit=getFk(dbunid);
	    	List<Map<String,Object>> getPs=getPs(dbunid);
	    	map.put("ps",getPs);
	    	map.put("fk",fkqkLsit);
	    	map.put("ld",ld);
	    	map.put("dw",dw);
	    }
		return getZy(GsonHelp.toJson(txdList));
		
	}
	//X月份“四会”、调研活动等重点交办事项办结件汇总表----会议类、该月办结、部署领导（林县长）
	public static String hy_bj_bsl(String end){
		String sql="select to_char(to_date(time1,'yyyy-mm-dd'),'yyyy\"年\"mm\"月\"dd\"日\"') time,c.*  from(select a.title as hybt,a.status as hystatus,a.createtime time1,b.*,decode(b.state,'2','办结','继续督办')dbzt,decode((to_char(to_date(a.createtime, 'YYYY-MM-DD'), 'MM')),'01','1月督办','02','2月督办','03','3月督办','04','4月督办', '05','5月督办','06','6月督办', '07','7月督办','08','8月督办', '09','9月督办','10','10月督办', '11','11月督办','12','12月督办') bz from yj_hy a left join yj_lr b on a.unid=b.docunid where (to_date(b.jbsx,'yyyy-MM-dd')  between  trunc(to_date('"+end+"', 'yyyy-MM')) and last_day(to_date(('"+end+"'), 'yyyy-MM')))  or (to_date(b.jbsx, 'yyyy-MM-dd')>sysdate)  )c where state in('2','3') and psperson='林万乐'   order by hystatus,to_number(regexp_replace(bh,'[^0-9]')) desc,hybt,sort";
		List<Map<String,Object>> txdList=MyDBUtils.queryForMapToUC(sql);
	    for(Map<String,Object> map:txdList ) {
	    	String dbunid=(String)map.get("unid");
	    	String docunid=(String)map.get("docunid");
			String bj=getHybj(docunid,dbunid);
	    	Map fkqkMaP=new HashMap();
			String ld=getld((String)map.get("qtperson"),(String)map.get("phperson"));
		    String dw=getdw((String)map.get("qtdepname"),(String)map.get("phdepname"),(String)map.get("zrdepname"));
	    	List<Map<String,Object>> fkqkLsit=getFk(dbunid);
	    	List<Map<String,Object>> getPs=getPs(dbunid);
	    	map.put("ps",getPs);
	    	map.put("fk",fkqkLsit);
	    	map.put("ld",ld);
	    	map.put("dw",dw);
			map.put("bj",bj);
	    }
		return getZy(GsonHelp.toJson(txdList));
	}
	
	//X月份“一批”办结件汇总表----批示类、办结、该月（林县长）、部署领导（林县长）
	public static String ps_bj_bsl(String end){
		String sql="select to_char(to_date(createtime,'yyyy-mm-dd'),'yyyy\"年\"mm\"月\"dd\"日\"') time,c.*  from(select b.*,decode(b.state,'2','办结','继续督办')dbzt,decode((to_char(to_date(b.createtime, 'YYYY-MM-DD'), 'MM')),'01','1月督办','02','2月督办','03','3月督办','04','4月督办', '05','5月督办','06','6月督办', '07','7月督办','08','8月督办', '09','9月督办','10','10月督办', '11','11月督办','12','12月督办') bz from  yj_lr b  where (to_date(b.jbsx,'yyyy-MM-dd')  between  trunc(to_date('"+end+"', 'yyyy-MM')) and last_day(to_date(('"+end+"'), 'yyyy-MM'))) or (to_date(b.jbsx, 'yyyy-MM-dd')>sysdate)   )c where  c.state in('2','3') and c.psperson='林万乐' and c.ishy='0' and c.dtype='1' order by  to_number(regexp_replace(bh,'[^0-9]')) desc ";
		List<Map<String,Object>> txdList=MyDBUtils.queryForMapToUC(sql);
	    for(Map<String,Object> map:txdList ) {
	    	String dbunid=(String)map.get("unid");
	    	Map fkqkMaP=new HashMap();
			String ld=getld((String)map.get("qtperson"),(String)map.get("phperson"));
		    String dw=getdw((String)map.get("qtdepname"),(String)map.get("phdepname"),(String)map.get("zrdepname"));
	    	List<Map<String,Object>> fkqkLsit=getFk(dbunid);
	    	List<Map<String,Object>> getPs=getPs(dbunid);
	    	map.put("ps",getPs);
	    	map.put("fk",fkqkLsit);
	    	map.put("ld",ld);
	    	map.put("dw",dw);
	    }
		return getZy(GsonHelp.toJson(txdList));
		
	}
	
	//X月份各线上政务继续提醒汇总表（会议类）----会议类、未办结、部署领导（所有）
	public static String hy_wbj_bssy(String start,String end){
		String sql="select to_char(to_date(time1,'yyyy-mm-dd'),'yyyy\"年\"mm\"月\"dd\"日\"') time,c.*  from(select a.title as hybt,a.status as hystatus,a.createtime time1,b.*,decode(b.state,'2','办结','继续督办')dbzt,decode((to_char(to_date(a.createtime, 'YYYY-MM-DD'), 'MM')),'01','1月督办','02','2月督办','03','3月督办','04','4月督办', '05','5月督办','06','6月督办', '07','7月督办','08','8月督办', '09','9月督办','10','10月督办', '11','11月督办','12','12月督办') bz from yj_hy a left join yj_lr b on a.unid=b.docunid where to_date(a.createtime,'yyyy-MM-dd')  between  to_date('"+start+"', 'yyyy-MM-dd') and to_date('"+end+"', 'yyyy-MM-dd')   )c where state='1' order by hystatus,to_number(regexp_replace(bh,'[^0-9]')) desc,hybt,sort ";
		List<Map<String,Object>> txdList=MyDBUtils.queryForMapToUC(sql);
		for(Map<String,Object> map:txdList ) {
		    String dbunid=(String)map.get("unid");
		    Map fkqkMaP=new HashMap();
			String ld=getld((String)map.get("qtperson"),(String)map.get("phperson"));
			String dw=getdw((String)map.get("qtdepname"),(String)map.get("phdepname"),(String)map.get("zrdepname"));
			List<Map<String,Object>> fkqkLsit=getFk(dbunid);
		    List<Map<String,Object>> getPs=getPs(dbunid);
		    map.put("ps",getPs);
		    map.put("fk",fkqkLsit);
		    map.put("ld",ld);
		    map.put("dw",dw);
		}
		return getZy(GsonHelp.toJson(txdList));
	}
	//X月份“一批”继续督办情况汇总表---批示类、未办结、部署领导（所有）
	public static String ps_wbj_bssy(String start,String end){
		String sql="select row_number() over(order by createtime) num,to_char(to_date(createtime,'yyyy-mm-dd'),'yyyy\"年\"mm\"月\"dd\"日\"') time,c.*  from(select b.*,decode(b.state,'2','办结','继续督办')dbzt,decode((to_char(to_date(b.createtime, 'YYYY-MM-DD'), 'MM')),'01','1月督办','02','2月督办','03','3月督办','04','4月督办', '05','5月督办','06','6月督办', '07','7月督办','08','8月督办', '09','9月督办','10','10月督办', '11','11月督办','12','12月督办') bz from  yj_lr b  where to_date(b.createtime,'yyyy-MM-dd')  between  to_date('"+start+"', 'yyyy-MM-dd') and to_date('"+end+"', 'yyyy-MM-dd')   )c where c.state='1'  and c.ishy='0' and c.dtype='1' order by  to_number(regexp_replace(bh,'[^0-9]')) desc";
		List<Map<String,Object>> txdList=MyDBUtils.queryForMapToUC(sql);
		for(Map<String,Object> map:txdList ) {
		    String dbunid=(String)map.get("unid");
		    Map fkqkMaP=new HashMap();
			String ld=getld((String)map.get("qtperson"),(String)map.get("phperson"));
			String dw=getdw((String)map.get("qtdepname"),(String)map.get("phdepname"),(String)map.get("zrdepname"));
			List<Map<String,Object>> fkqkLsit=getFk(dbunid);
		    List<Map<String,Object>> getPs=getPs(dbunid);
		    map.put("ps",getPs);
		    map.put("fk",fkqkLsit);
		    map.put("ld",ld);
		    map.put("dw",dw);
		}
		return getZy(GsonHelp.toJson(txdList));
			
	}
	// 获取该条会议件的办结部分
	public static String getHybj(String docunid,String unid){
		List<Map<String,Object>> fkqkLsit=MyDBUtils.queryForMapToUC("select * from yj_lr t where docunid=? and unid!=? and state in('2','3') order by sort",docunid,unid);
		String show="";
		for(Map<String,Object> map:fkqkLsit){
			String title=(String)map.get("title");
			show+=title+"<w:br/><\t>";
		}
		return show;
	}

	//获取再次批示
	public static String getPsl(String docunid){
		List<Map<String,Object>> fkqkLsit=MyDBUtils.queryForMapToUC("select * from yj_lr_ps t where dbid=? order by sort",docunid);
		String show="";
		for(Map<String,Object> map:fkqkLsit){
			String title=(String)map.get("psnr");
			show+=title+"<w:br/><\t>";
		}
		return show;
	}

	//获取该条办结的反馈列表
	public static List<Map<String,Object>> getPs(String docunid){
	    List<Map<String,Object>> fkqkLsit=MyDBUtils.queryForMapToUC("select * from yj_lr_ps t where dbid=? order by sort",docunid);
		return fkqkLsit;
	} 
	//获取该条办结的反馈列表
	public static List<Map<String,Object>> getFk(String docunid){
	    //List<Map<String,Object>> fkqkLsit=MyDBUtils.queryForMapToUC("select y.*,decode(d.deptid,y.userid,(select ownername from owner where id = y.userid),y.deptid,y.deptname) flagname  from yj_dbhf y,yj_dbstate d where y.unid=? and  d.unid = y.unid  and (d.deptid = y.userid or d.deptid = y.deptid)",docunid);
		List<Map<String,Object>> fkqkLsit=MyDBUtils.queryForMapToUC("select * from (select y.*,row_number() OVER(PARTITION BY y.deptid ORDER BY y.createtime desc) as row_flg,decode(d.deptid,y.userid,(select ownername from owner where id = y.userid),y.deptid,y.deptname) flagname,(select flag from owner where id = d.deptid) flag   from yj_dbhf y,yj_dbstate d where y.unid=? and  d.unid = y.unid  and (d.deptid = y.userid or d.deptid = y.deptid) ) where row_flg='1' ORDER BY  flag asc  ",docunid);
        for(Map<String,Object> map:fkqkLsit){
	        String lsqk=(String)map.get("lsqk");
	        String problem=CommonUtil.doStr((String)map.get("problem"));
	        if(!problem.equals("")){
                lsqk+="<w:br/><\t>存在问题："+problem;
            }
            String xbsl=CommonUtil.doStr((String)map.get("xbsl"));
            if(!problem.equals("")){
                lsqk+="<w:br/><\t>下步思路："+xbsl;
            }
            map.put("lsqk",lsqk);
        }
		return fkqkLsit;
	}
	//获取领导
	public static String getld(String qtperson,String phperson){
		return (CommonUtil.getName(CommonUtil.doStr(qtperson))+CommonUtil.doStr(phperson)).replace(",",".").replace(".","<w:br/>");
	}
	//获取单位
	public static String getdw(String qtdepname,String phdepname,String zrdepname){
		return 	(CommonUtil.getName(CommonUtil.doStr(qtdepname))+CommonUtil.doStr(phdepname)+CommonUtil.doStr(zrdepname)).replace(",",".").replace(".","<w:br/>");
	}
	//获取截止时间内的，会议内共有多少项,type=1 林乐 type=0 所有
	public static int getHyCount(String start,String end,String type){
		String show="";
		if("1".equals(type)){
			show=" and b.psperson='林万乐' ";
		}
		String sql="select count(1) from  yj_lr b  where to_date(b.createtime,'yyyy-MM-dd')  between  to_date('"+start+"', 'yyyy-MM-dd') and to_date(('"+end+"'), 'yyyy-MM-dd') and b.state in('1','2','3') "+show+" and b.dtype='1'";
		int count=MyDBUtils.queryForInt(sql);
		return count;
	}
	//该月新增会议内多少条 type=1 林乐 type=0 所有
	public static int getHyGyCount(String end,String type){
		String show="";
		if("1".equals(type)){
			show=" and b.psperson='林万乐' ";
		}
		String sql="select count(1) from  yj_lr b  where to_date(b.createtime,'yyyy-MM-dd')  between  trunc(to_date('"+end+"', 'yyyy-MM')) and last_day(to_date(('"+end+"'), 'yyyy-MM'))  and  b.state in('1','2','3') "+show+"   and b.dtype='1'";
		int count=MyDBUtils.queryForInt(sql);
		return count;
	}
	//截止该月办结   type=1 林乐 type=0 所有
	public static int getHyGyJzCount(String start,String end,String type){
		String show="";
		if("1".equals(type)){
			show=" and b.psperson='林万乐' ";
		}
		String sql="select count(1) from  yj_lr b  where to_date(b.createtime,'yyyy-MM-dd')  between  to_date('"+start+"', 'yyyy-MM-dd') and to_date(('"+end+"'), 'yyyy-MM-dd')  and b.state in('2','3')  "+show+"  and b.dtype='1'";
		int count=MyDBUtils.queryForInt(sql);
		return count;
	}
	//截止该月未办结  type=1 林乐 type=0 所有
	public static int getHyGyJzWbjCount(String start,String end,String type){
		String show="";
		if("1".equals(type)){
			show=" and b.psperson='林万乐' ";
		}
		String sql="select count(1) from  yj_lr b  where to_date(b.createtime,'yyyy-MM-dd')  between  to_date('"+start+"', 'yyyy-MM-dd') and to_date(('"+end+"'), 'yyyy-MM-dd')  and b.state='1'  "+show+"   and b.dtype='1'";
		int count=MyDBUtils.queryForInt(sql);
		return count;
	}
	
	//各专业口到期未办结数据
	public static int getCjk(String desc){
		String sql="select count(1) from yj_lr t where t.psperson=(select a.ownername from owner a where a.description='"+desc+"') and to_date(jbsx,'yyyy-MM-dd')<sysdate and state='1' and dtype='1'";
		int count=MyDBUtils.queryForInt(sql);
		return count;
	}
	//专业口到期未办结
	public static int getCjkCount(){
		String sql="select count(1) from yj_lr t where t.psperson in (select o.ownername name from owner o join ownerrelation oo on o.id = oo.ownerid where oo.parentid = '1000256375' and o.id!='1000905040' ) and to_date(jbsx,'yyyy-MM-dd')<sysdate and state='1' and dtype='1' ";
		int count=MyDBUtils.queryForInt(sql);
		return count;
	}

	/**
	 * 特殊字符处理
	 */
	public static String getZy(String str) {
		if(str!=null&&!"".equals(str)) {
			str = str.replace("\\u0026", "").replace("\\u003c", "").replace("\\u003e", "");
			str = str.replace("w:br/", "\\u003cw:br/\\u003e");
            str = str.replace("\t", "\\u003c\t\\u003e");
        }
		return str;
	}

	public static void main(String[] args) {

	}
}
