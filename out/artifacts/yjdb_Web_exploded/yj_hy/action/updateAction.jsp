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
    String nowtime="";
    if(!"1".equals(state)){
    	nowtime=sdf.format(new Date());
    }
    
    //是否办结
	if(status.equals("upkg")){
		MyDBUtils.executeUpdate("update yj_hy set state=?,statetime=? where unid=?",state,nowtime,unid);

			
		List<Map<String,Object>>  mapList=MyDBUtils.queryForMapToUC("select * from yj_lr where docunid=?", unid);
		for(Map<String,Object> map:mapList){
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
			String uuid=(String)map.get("unid");
			String dwstate="";
			if(state.equals("1")){
				dwstate="2";
				MyDBUtils.executeUpdate("update yj_dbstate set state=?,bjtime=?,iscs='0' where unid=?",dwstate,nowtime,uuid);
			}else if(state.equals("2")){
				dwstate="3";
				MyDBUtils.executeUpdate("update yj_dbstate set state=?,bjtime=?,iscs='0' where unid=?",dwstate,nowtime,uuid);
			}else if(state.equals("3")){
				dwstate="3";
				MyDBUtils.executeUpdate("update yj_dbstate set state=?,bjtime=?,iscs='1' where unid=?",dwstate,nowtime,uuid);
			}
			if("3".equals(state)){
				MyDBUtils.executeUpdate("update yj_lr set state='2',statetime=? where unid=?",nowtime,uuid);
			}else{
				MyDBUtils.executeUpdate("update yj_lr set state=?,statetime=? where unid=?",state,nowtime,uuid);
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
		String type=request.getParameter("type");
		String tableName="";
		if(type.equals("4")) {
			tableName="yj_hy_msss";
		}else{
			tableName="yj_hy_yc";
		}
		List<Map<String, Object>> list = MyDBUtils.queryForMapToUC("select * from "+tableName+" t where t.dbid=? order by sort", unid);
		String json = "{\"res\":true,\"data\":"+gson.toJson(list)+"}";
		response.getWriter().write(json);
	}
%>	
