<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.commons.orm.MyDBUtils"%>
<%@page import="java.util.*"%>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="com.kizsoft.yjdb.utils.GsonHelp"%>
<%@page import="com.kizsoft.yjdb.utils.CommonUtil"%>
<%
	String status=request.getParameter("status");

	String state=CommonUtil.doStr(request.getParameter("state"));
	String unid=request.getParameter("unid");
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
    
    //是否办结
	if(status.equals("upkg")){
	    String nowtime="";
	    Map<String,Object>  map=MyDBUtils.queryForUniqueMapToUC("select * from yj_lr where unid=?", unid);
	    if("2".equals(state)){
	    	nowtime=(String)map.get("createtime");
	    }
	    if("3".equals(state)){
	        Date date =sdf.parse((String)map.get("jbsx"));// 新建此时的的系统时间
	    	Calendar calendar = Calendar.getInstance();
	        calendar.setTime(date);
	        calendar.add(Calendar.DAY_OF_MONTH, +1);//+1今天的时间加一天
	        date = calendar.getTime();
	    	nowtime=sdf.format(date);
	    }		
		String dwstate="";
		if(state.equals("1")){
			dwstate="2";
			MyDBUtils.executeUpdate("update yj_dbstate set state=?,bjtime=?,iscs='0' where unid=?",dwstate,nowtime,unid);
		}else if(state.equals("2")){
			dwstate="3";
			MyDBUtils.executeUpdate("update yj_dbstate set state=?,bjtime=?,iscs='0' where unid=?",dwstate,nowtime,unid);
		}else if(state.equals("3")){
			dwstate="3";
			MyDBUtils.executeUpdate("update yj_dbstate set state=?,bjtime=?,iscs='1' where unid=?",dwstate,nowtime,unid);
		}
		if("3".equals(state)){
			MyDBUtils.executeUpdate("update yj_lr set state='2',statetime=? where unid=?",nowtime,unid);
		}else{
			MyDBUtils.executeUpdate("update yj_lr set state=?,statetime=? where unid=?",state,nowtime,unid);
		}

		//会议是否办结还是取消
		Map<String,Object>  ddmap=MyDBUtils.queryForUniqueMapToUC("select * from yj_lr where unid=? ",unid);
		if(ddmap!=null){
			String docunid=(String)ddmap.get("docunid");
			int dcount = MyDBUtils.queryForInt("select count(1) from yj_lr t where t.docunid=? and t.state='1' ", docunid);
			if(dcount==0){
				MyDBUtils.executeUpdate("update yj_hy set state='2' where unid=?", docunid);
			}else{
				MyDBUtils.executeUpdate("update yj_hy set state='1' where unid=?", docunid);
			}
		}

	}
	
	//是否挂起
	String gqstate=CommonUtil.doStr(request.getParameter("gqstate"));
	if(status.equals("upgq")){
		MyDBUtils.executeUpdate("update yj_lr set gqstate=? where unid=?",gqstate,unid);
	}
	
	GsonHelp gson = new GsonHelp();
    if("getPsinfo".equals(status)){
		List<Map<String,Object>> list = MyDBUtils.queryForMapToUC("select * from yj_lr_ps t where t.dbid=?",unid);
		String json = "{\"res\":true,\"data\":"+gson.toJson(list)+"}";
		response.getWriter().write(json);
	}
    
    //设置蜗牛还是红旗
	if(status.equals("whstatus")){
		String whstatus=CommonUtil.doStr(request.getParameter("whstatus"));
		if((state.equals("1")&&whstatus.equals("1"))||(state.equals("2")&&whstatus.equals("2"))){
			MyDBUtils.executeUpdate("update yj_lr set whstatus='0' where unid=?",unid);
		}else{
			MyDBUtils.executeUpdate("update yj_lr set whstatus=?  where unid=?",state,unid);
		}
	}
    
	//给具体单位设置设置蜗牛还是红旗
	if(status.equals("newwhstatus")){
		String deptid=CommonUtil.doStr(request.getParameter("deptid"));
		String whstatus=CommonUtil.doStr(request.getParameter("whstatus"));
		if((state.equals("1")&&whstatus.equals("1"))||(state.equals("2")&&whstatus.equals("2"))){
			MyDBUtils.executeUpdate("update yj_dbstate set whstatus='0' where unid=? and deptid=?",unid,deptid);
		}else{
			MyDBUtils.executeUpdate("update yj_dbstate set whstatus=?  where unid=? and deptid=?",state,unid,deptid);
		}
	}
%>	
