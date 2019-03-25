package com.kizsoft.yjdb.ding;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.kizsoft.commons.commons.orm.MyDBUtils;
import com.kizsoft.commons.commons.user.Group;
import com.kizsoft.commons.commons.user.User;
import com.kizsoft.commons.commons.user.UserException;
import com.kizsoft.commons.util.UUIDGenerator;
import com.kizsoft.commons.uum.service.IUUMService;
import com.kizsoft.commons.uum.utils.UUMContend;
import com.kizsoft.yjdb.utils.CommonUtil;
import com.kizsoft.yjdb.utils.GsonHelp;
import com.kizsoft.yjdb.utils.JsoupUtil;
import com.kizsoft.yjdb.xwfx.Impl;

public class DingSendMessage {
	public static void snedMessage(String unid,String useridStr,String content,String status,HttpServletRequest request){
		User userInfo = (User)request.getSession().getAttribute("userInfo");
		String userid = userInfo.getUserId();
		String username = userInfo.getUsername();
		Group groupInfo = null;
		try {
			groupInfo = userInfo.getGroup();
		} catch (UserException e) {
			e.printStackTrace();
		}
		String depid = groupInfo.getGroupId();
		String depname=groupInfo.getGroupname();
		List<Map<String,Object>>  listM=null;
		if("1".equals(status)){
			listM=MyDBUtils.queryForMap("select * from owner where id in('"+useridStr+"')");
		}else if("2".equals(status)){
			//督办管理员
			listM=MyDBUtils.queryForMapToUC("select o.ownername,o.mobile from acluserrole a, owner o where a.userid = o.id and a.roleid in(select roleid from aclrole t  where rolecode='send') ");
		}else if("3".equals(status)){
			//通过名称查询用户信息
			listM=MyDBUtils.queryForMapToUC("select ownername,mobile from owner where ownername in('"+ useridStr +"')");
		}else{
			listM=MyDBUtils.queryForMap("select o.* from owner o  where o.id in (select ownerid from ownerrelation ol  start with ol.parentid in ('"+useridStr+"') connect by prior ol.ownerid = ol.parentid) and o.flag = 1 and o.id in(select a.userid  from ACLUSERROLE a  where a.roleid in  (select r.roleid  from ACLROLE r  where r.rolecode in ('dby')))");
		}
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
		String nowtime=sdf.format(new Date());
		for(Map<String,Object> map:listM){
			String name=(String)map.get("ownername");
			String mobile=CommonUtil.doStr((String)map.get("mobile"));
			String result="";
			try {
				if("".equals(mobile)){
					result="该账号未绑定手机号";
					MyDBUtils.executeUpdate("insert into yj_lr_message(unid,docunid,dcontent,name,mobile,time,result,userid,username,depid,depname,status) values(?,?,?,?,?,?,?,?,?,?,?,'1')",UUIDGenerator.getUUID(),unid,content,name,mobile,nowtime,result,userid,username,depid,depname);
				}else{
					/*result=send(mobile,content,userInfo.getUserId());*/
					result="还未执行";
					MyDBUtils.executeUpdate("insert into yj_lr_message(unid,docunid,dcontent,name,mobile,time,result,userid,username,depid,depname,status) values(?,?,?,?,?,?,?,?,?,?,?,'0')",UUIDGenerator.getUUID(),unid,content,name,mobile,nowtime,result,userid,username,depid,depname);
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}

		}
		
	}
	//线程到期前一天自动发送短息提醒
	public static void snedMessage(String unid,String useridStr,String content,String status){
		List<Map<String,Object>>  listM=null;
		if("1".equals(status)){
			listM=MyDBUtils.queryForMap("select * from owner where id in('"+useridStr+"')");
		}else if("2".equals(status)){
			//督办管理员
			listM=MyDBUtils.queryForMapToUC("select o.ownername,o.mobile from acluserrole a, owner o where a.userid = o.id and a.roleid in(select roleid from aclrole t  where rolecode='send') ");
		}else if("3".equals(status)){
			//通过名称查询用户信息
			listM=MyDBUtils.queryForMapToUC("select ownername,mobile from owner where ownername in('"+ useridStr +"')");
		}else if("4".equals(status)){
			//通过名称查出部门下所有的用户信息
			listM=MyDBUtils.queryForMapToUC("select ownername,mobile from owner where id in (select oo.ownerid from owner o,ownerrelation oo where o.id = oo.parentid and o.ownername = '" + useridStr + "')");
		}else{
			listM=MyDBUtils.queryForMap("select o.* from owner o  where o.id in (select ownerid from ownerrelation ol  start with ol.parentid in ('"+useridStr+"') connect by prior ol.ownerid = ol.parentid) and o.flag = 1 and o.id in(select a.userid  from ACLUSERROLE a  where a.roleid in  (select r.roleid  from ACLROLE r  where r.rolecode in ('dby')))");
		}
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
		String nowtime=sdf.format(new Date());
		for(Map<String,Object> map:listM){
			String name=(String)map.get("ownername");
			String mobile=CommonUtil.doStr((String)map.get("mobile"));
			String result="";
			try {
				if("".equals(mobile)){
					result="该账号未绑定手机号";
					MyDBUtils.executeUpdate("insert into yj_lr_message(unid,docunid,dcontent,name,mobile,time,result,username,status) values(?,?,?,?,?,?,?,?,'1')",UUIDGenerator.getUUID(),unid,content,name,mobile,nowtime,result,"线程");
				}else{
					/*result=send(mobile,content,"线程");*/
					result="还未执行";
					MyDBUtils.executeUpdate("insert into yj_lr_message(unid,docunid,dcontent,name,mobile,time,result,username,status) values(?,?,?,?,?,?,?,?,0)",UUIDGenerator.getUUID(),unid,content,name,mobile,nowtime,result,"线程");
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}

		}
	}
	
	
	//给其它两类角色发送消息
	public static void snedMessage(String unid,String useridStr,String content,HttpServletRequest request,int type){
		User userInfo = (User)request.getSession().getAttribute("userInfo");
		String userid = userInfo.getUserId();
		String username = userInfo.getUsername();
		Group groupInfo = null;
		try {
			groupInfo = userInfo.getGroup();
		} catch (UserException e) {
			e.printStackTrace();
		}
		String depid = groupInfo.getGroupId();
		String depname=groupInfo.getGroupname();
		List<Map<String,Object>>  listM=null;
		String rolecode="";
		if(type==3) {
			rolecode="dbk2";
		}else if(type==2) {
			rolecode="dbk1";
		}
		listM=MyDBUtils.queryForMapToUC("select o.ownername,o.mobile from acluserrole a, owner o where a.userid = o.id and a.roleid in(select roleid from aclrole t  where rolecode='"+rolecode+"') ");
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
		String nowtime=sdf.format(new Date());
		for(Map<String,Object> map:listM){
			String name=(String)map.get("ownername");
			String mobile=CommonUtil.doStr((String)map.get("mobile"));
			String result="";
			try {
				if("".equals(mobile)){
					result="该账号未绑定手机号";
					MyDBUtils.executeUpdate("insert into yj_lr_message(unid,docunid,dcontent,name,mobile,time,result,userid,username,depid,depname,status) values(?,?,?,?,?,?,?,?,?,?,?,'1')",UUIDGenerator.getUUID(),unid,content,name,mobile,nowtime,result,userid,username,depid,depname);
				}else{
					/*result=send(mobile,content,userInfo.getUserId());*/
					result="还未执行";
					MyDBUtils.executeUpdate("insert into yj_lr_message(unid,docunid,dcontent,name,mobile,time,result,userid,username,depid,depname,status) values(?,?,?,?,?,?,?,?,?,?,?,'0')",UUIDGenerator.getUUID(),unid,content,name,mobile,nowtime,result,userid,username,depid,depname);
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}

		}
		
	}
	
}
