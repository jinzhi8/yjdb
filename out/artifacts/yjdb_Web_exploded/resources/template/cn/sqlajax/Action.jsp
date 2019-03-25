<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Map"%>
<%@page import="com.kizsoft.commons.commons.orm.SimpleORMUtils" %>
<%@page import="com.kizsoft.oa.wzbwsq.util.CommonUtil" %>
<%@page import="com.kizsoft.oa.wzbwsq.util.GsonHelp" %>
<%@page import="com.kizsoft.oa.wzbwsq.bean.SsoUser" %>

<%@page import="java.util.*"%>
<%@page import="java.util.Date"%>


<%
	SsoUser suser=(SsoUser)session.getAttribute("suser");

	String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();	
	SimpleORMUtils instance =SimpleORMUtils.getInstance();
	GsonHelp gson = new GsonHelp();
	String action = request.getParameter("action");
	if("getAllnum".equals(action)){
		int count = instance.queryForInt(" select  count(*) from  zmview  where flag = '1' and zm_status is not null ");
	    List<Map<String,Object>> listjoint=instance.queryForMap("select  a.counts , a.moduleid ,b.name  from  (select count(moduleid) as counts, moduleid  from zmview  where flag = '1'  and zm_status is not null  group by moduleid )  a left join kzm_zmtype b on a.moduleid = b.moduleid order by counts desc ");       				 
		String json = "{\"res\":true,\"succ\":"+gson.toJson(listjoint)+",\"cnum\":"+count+"}";
		response.getWriter().write(json);	
	}else if("columnaraction".equals(action)){
		String conjson = "" ;
		for (int i = 6; i >=0; i--) {  
			String nowdate = getPastDate(i); 
			int count = instance.queryForInt("select  count(*)  from  zmview  where  flag = '1' and TO_CHAR(CREATETIME,'YYYY-MM-DD')='"+nowdate+"'");
	 		conjson += "{\"time\":\""+nowdate+"\",\"value\":"+count+"},";
	 	}
	 	conjson = "["+conjson.substring(0, conjson.length()-1)+"]";
	  	String json= "{\"res\":true,\"data\":"+conjson+"}";
	 	System.out.print(json);
	 	 response.getWriter().write(json);
	 }		
	
%>
<%!
	public static String getPastDate(int past) {
		Calendar calendar = Calendar.getInstance();
		calendar.set(Calendar.DAY_OF_YEAR, calendar.get(Calendar.DAY_OF_YEAR) - past);
		Date today = calendar.getTime();
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		String result = format.format(today);
		return result;
	}
	
	
%>
