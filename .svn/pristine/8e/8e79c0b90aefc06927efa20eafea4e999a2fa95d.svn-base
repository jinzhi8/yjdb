<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.commons.orm.SimpleORMUtils"%>
<%@page import="java.util.HashMap" %>
<%@page import="java.util.List" %>
<%@page import="java.util.Map" %>
<%@page import="java.util.Date" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="net.sf.json.JSONArray" %>
<%@page import="net.sf.json.JSONObject" %>
<%@page import="com.kizsoft.commons.acl.ACLManager" %>
<%@page import="com.kizsoft.commons.acl.ACLManagerFactory" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<%@taglib prefix="html" uri="/WEB-INF/oa-html.tld" %>
<%@taglib prefix="oa" uri="/WEB-INF/oa.tld" %>

<%
	User userInfo = (User) session.getAttribute("userInfo");
	String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
	if (userInfo == null) {
		try {
			request.getRequestDispatcher("/login.jsp").forward(request, response);
			return;
		} catch (Exception e) {
			response.sendRedirect(contextPath + "/login.jsp");
			return;
		}
	}
	String userName = userInfo.getUsername();
	String userId = userInfo.getUserId();
	Group groupInfo = userInfo.getGroup();
    String groupID = groupInfo.getGroupId();
    String depName = groupInfo.getGroupname();
    String sendtime_first = (String) request.getParameter("sendtime_first")==null?"":(String) request.getParameter("sendtime_first");
	String sendtime_last = (String) request.getParameter("sendtime_last")==null?"":(String) request.getParameter("sendtime_last");
	String statue = (String) request.getParameter("statue")==null?"":(String) request.getParameter("statue");
	String banjie = (String) request.getParameter("banjie")==null?"":(String) request.getParameter("banjie");	
	String year = (String) request.getParameter("year")==null?"":(String) request.getParameter("year");
	String  num= (String) request.getParameter("num")==null?"":(String) request.getParameter("num");
	int maxRow = 0;
	int indexPage = request.getParameter("indexPage")==null?1:Integer.parseInt(request.getParameter("indexPage"));
    int pageSize = request.getParameter("pageSize")==null?0:Integer.parseInt(request.getParameter("pageSize"));
	ACLManager aclManager = ACLManagerFactory.getACLManager();
	String role="";
	if (aclManager.isOwnerRole(userId,"dbk")){
        role="";
	}else if(aclManager.isOwnerRole(userId,"msk")){
		role=" and userid like'%"+userId+"%' ";
	}
    else{
		role=" and (managedepid like'%"+groupID+"%' or copytoid like '%"+groupID+"%') ";
	}
	System.out.println("role:"+role);
    SimpleORMUtils instance=SimpleORMUtils.getInstance();
    String sql="select t.*,to_char(issuetime,'yyyy-mm-dd') as qftimel,to_char(jbsx,'yyyy-mm-dd') as jbsxl from zwdb t where isjs='2' "+role+" and hy is  null ";
    if("5".equals(statue)){
		sql+=" and  num is null ";
    }
    else if("1".equals(statue)){
	
	}else if("".equals(statue)){
    if(!"".equals(sendtime_first) && !"".equals(sendtime_last)){	
        sql+="and issuetime between to_date('"+sendtime_first+"','YYYY-MM-DD') and to_date('"+sendtime_last+" ','YYYY-MM-DD')";
    }
    if("已办结".equals(banjie)){
		sql+="and  qfman='办结' ";
    }
    if("未办结".equals(banjie)){
		sql+="and  qfman='未办结' ";
    }
    if(!"".equals(year)){
		sql+="and year='"+year+"' ";
    }
    if(!"".equals(num)){
		sql+="and num='"+num+"' ";
    }
    sql+=" order by issuetime desc ";
	}
    int rownum = indexPage*pageSize;		
	int rn = (indexPage-1)*pageSize+1;
	String sxsql = "SELECT * FROM ( SELECT b.*, ROWNUM RN FROM ("+sql+") b WHERE ROWNUM <='"+rownum+"' ) WHERE RN >='"+rn+"'";
    List<Map<String,Object>> list=instance.queryForMap(sxsql);
    for(int i=0;i<list.size();i++){  
    	Map<String,Object> mapList =list.get(i);
		String unid=(String) mapList.get("unid"); 
		String qfman=(String) mapList.get("qfman");
		String dbk="";
		if (aclManager.isOwnerRole(userId, "dbk")){
			dbk="<div  class=\"MM_over_psj\"><a href=\""+request.getContextPath()+"/edit?xmlName=zwdbfk&appId="+unid+"&lf=1\">编辑</a><a href=\"javascript:dxcb('"+unid+"');\">短信催办</a><a href=\"javascript:ddcb('"+unid+"');\">钉钉督促催办</a></div>";
		}else if(aclManager.isOwnerRole(userId, "msk")){
			dbk="<div  class=\"MM_over_psj\"><a href=\""+request.getContextPath()+"/edit?xmlName=zwdbfk&appId="+unid+"&lf=1\">编辑</a><a href=\"javascript:dxcb('"+unid+"');\">短信催办</a></div>";
		}
	    List<Map<String,Object>> sflist=instance.queryForMap("select * from(select zpg.*,to_char(finishtime,'yyyy-mm-dd') as finishtimel,to_char(begintime,'yyyy-mm-dd') as begintimel,to_char(fksj,'yyyy-mm-dd') as fksjl from ZWDBFKPG zpg where zpg.dbid=? order by fksj desc)where rownum=1",unid);
		Object newbtime="";
		Object fksj="";	
		if(sflist.size()!=0){
			Map<String,Object> map=sflist.get(0);
			fksj=map.get("fksjl");
			newbtime=map.get("begintimel")+"至<br/>"+map.get("finishtimel");
		}else{
			fksj="无";
			newbtime="无";
		}
		String color="";
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date=new Date();
		Date jbsx = sdf.parse(mapList.get("jbsx").toString());
		long day = (jbsx.getTime() - date.getTime());
		long nd = 1000 * 24 * 60 * 60;
		if(!qfman.equals("办结")&&day<(1*nd)){
			color="#f4dddd";
		}else if(!qfman.equals("办结")&&day<(3*nd)){
			color="#F2F0D2";
		}else if(!qfman.equals("办结")&&day<(7*nd)){
			color="#ddf4ef";
		}else{
			color="white";
		}	
		mapList.put("fksj", fksj);
		mapList.put("newbtime", newbtime);
		mapList.put("color",color);
		mapList.put("dbk",dbk);
	}
	JSONArray arr = JSONArray.fromObject(list);
	String jssql = "select count(*) from ("+sql+") tab";
	int count = instance.queryForInt(jssql);
	//String result=arr.toString();
	String result = "{\"count\":"+count+",\"data\":"+arr+"}";
	response.getWriter().write(result);

%>
