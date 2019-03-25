<%@page language="java" contentType="text/html;charset=UTF-8" %>

<%@page import="com.kizsoft.commons.acl.ACLManager" %>
<%@page import="com.kizsoft.commons.acl.ACLManagerFactory" %>
<%@page import="com.kizsoft.commons.commons.db.ConnectionProvider" %>
<%@page import="com.kizsoft.commons.commons.config.SystemConfig" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.commons.orm.SimpleORMUtils" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.sql.Timestamp" %>
<%@page import="java.util.*" %>
<%@page import="java.lang.*" %>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>

<% User userInfo = (User) session.getAttribute("userInfo");
	String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
	if (userInfo == null) {
		try {
			response.sendRedirect(contextPath + "/login.jsp");
			return;
		} catch (Exception e) {
			response.sendRedirect(contextPath + "/login.jsp");
			return;
		}
	}
	String userName = userInfo.getUsername();
	String userID = userInfo.getUserId();
	String udepartment = userInfo.getGroup().getGroupname();
	String[] userConfig = userInfo.getUserConfig();
	Group groupInfo = (Group) userInfo.getGroup();
	String usernameen = userInfo.getAccount();
	String idsStr = userInfo.getUserId();
	String groupID = groupInfo.getGroupId(); 
	String userflag = (String) session.getAttribute("userFlag");
	String templatename = (String) session.getAttribute("templatename");
	if (templatename == null) {
		templatename = "cn";
	}
	ACLManager aclManager = ACLManagerFactory.getACLManager();
	String aclrole="";
	String zmcategoryid="";//事项范围
	if(aclManager.isOwnerRole(userID, "sysadmin")||aclManager.isOwnerRole(userID, "sadmin")){ 
		aclrole="sysadmin";
	}else if(aclManager.isOwnerRole(userID, "xjman")){
		aclrole="xjman";	
	}else if(aclManager.isOwnerRole(userID, "1001")||aclManager.isOwnerRole(userID, "1002")||aclManager.isOwnerRole(userID, "1003")
	||aclManager.isOwnerRole(userID, "1004")||aclManager.isOwnerRole(userID, "1007")||aclManager.isOwnerRole(userID, "1009")
	||aclManager.isOwnerRole(userID, "1006")){ 
		aclrole="sService";
		if(aclManager.isOwnerRole(userID, "1001")){
			zmcategoryid="'1001'";
		}else if(aclManager.isOwnerRole(userID, "1002")){
			zmcategoryid="'1002'";
		}else if(aclManager.isOwnerRole(userID, "1003")){
			zmcategoryid="'1003'";
		}else if(aclManager.isOwnerRole(userID, "1004")){
			zmcategoryid="'1004'";
		}else if(aclManager.isOwnerRole(userID, "1006")){
			zmcategoryid="'1006'";
		}else if(aclManager.isOwnerRole(userID, "1007")){
			zmcategoryid="'1007'";
		}else if(aclManager.isOwnerRole(userID, "1009")){
			zmcategoryid="'1009'";
		}
	}else if(aclManager.isOwnerRole(userID, "xj_1001")||aclManager.isOwnerRole(userID, "xj_1002")||aclManager.isOwnerRole(userID, "xj_1003")
	||aclManager.isOwnerRole(userID, "xj_1004")||aclManager.isOwnerRole(userID, "xj_1007")||aclManager.isOwnerRole(userID, "xj_1009")
	||aclManager.isOwnerRole(userID, "xj_1006")){ 
		aclrole="xService";
		if(aclManager.isOwnerRole(userID, "xj_1001")){
			zmcategoryid="'1001'";
		}else if(aclManager.isOwnerRole(userID, "xj_1002")){
			zmcategoryid="'1002'";
		}else if(aclManager.isOwnerRole(userID, "xj_1003")){
			zmcategoryid="'1003'";
		}else if(aclManager.isOwnerRole(userID, "xj_1004")){
			zmcategoryid="'1004'";
		}else if(aclManager.isOwnerRole(userID, "xj_1006")){
			zmcategoryid="'1006'";
		}else if(aclManager.isOwnerRole(userID, "xj_1007")){
			zmcategoryid="'1007'";
		}else if(aclManager.isOwnerRole(userID, "xj_1009")){
			zmcategoryid="'1009'";
		}
	}
	String sqbjStr = getsqbj(userID,groupID,aclrole,zmcategoryid);
	String ysdsStr = getysds(userID,groupID,aclrole,zmcategoryid);
	String yydsStr = getyyds(userID,groupID,aclrole,zmcategoryid);
	String zzdhfStr = getzzdhf(userID,groupID,aclrole,zmcategoryid);
%>
<%!
	public String getzzdhf(String userID,String groupID,String aclrole,String zmcategoryid){
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleORMUtils instance=new SimpleORMUtils();
		StringBuffer sb = new StringBuffer();
		String sql ="select * from (select unid,zixuntitle,username,createtime,row_number() over(order by createtime desc) pagerownumber FROM ywb_zixunrecord z";
		if("sysadmin".equals(aclrole)){
		}else if("xjman".equals(aclrole)){
			sql += " where zx_type='0' and acceptarea is not null and acceptareaid is not null and acceptdept is not null and acceptdeptid is not null "
			+" and acceptareaid in (select ownercode from owner where id in "
			+" (select parentid from ownerrelation m start with m.ownerid='"+userID+"' connect by prior m.parentid=m.ownerid) and ownercode !='331000000000')"
			+" and acceptdeptid in (select code from kzm_pcsconfig  where areaid=z.acceptareaid)";
		}else if("sService".equals(aclrole)){
			sql += " where ((zx_type='0' and acceptarea is not null and acceptareaid is not null and acceptdept is not null and acceptdept is not null "
			+" and serviceid in (select k.id from KZM_ZMINFO k where k.zmcategoryid in ("+zmcategoryid+"))) or (zx_type='1' and zx_zmcategoryid ="+zmcategoryid+"))";
		}else if("xService".equals(aclrole)){
			sql += " where zx_type='0' and acceptarea is not null and acceptareaid is not null and acceptdept is not null and acceptdept is not null "
			+" and serviceid in (select k.id from KZM_ZMINFO k where k.zmcategoryid in ("+zmcategoryid+"))"
			+" and acceptareaid in (select ownercode from owner where id in "
			+" (select parentid from ownerrelation m start with m.ownerid='"+userID+"' connect by prior m.parentid=m.ownerid)"
			+" and (ownercode in (select areaid from kzm_pcsconfig) or  ownercode in (select acceptareaid from ywb_zixunrecord)))";
		}
		sql += " ) where rownum<5 order by pagerownumber";
		sb.append("<table class=\"public_table\">");
		sb.append("<tr><th style='width:140px'>标题</th><th style='width:110px'>咨询时间</th><th style='width:50px'>操作</th></tr>");
		//System.out.println(sql);
		if(!"".equals(sql)){
			List<Map<String,Object>> list = instance.queryForMap(sql);
			for(Map<String,Object> map : list){
				String zixuntitle = (String)map.get("zixuntitle");
				String createtime = sdf.format((Timestamp)map.get("createtime"));
				String unid = (String)map.get("unid");
				sb.append("<tr>");
				sb.append("<td><span>"+zixuntitle+"</span><span></span></td>");
				sb.append("<td>"+createtime+"</td>");
				sb.append("<td><input type=\"button\" value=\"查看详情\"  onclick=\"goZxdhfcontent('"+unid+"');\"></td>");
				sb.append("</tr>");
			}
		}
		sb.append("</table>");
		
		return sb.toString();
	}
%>
<%!
	public String getyyds(String userID,String groupID,String aclrole,String zmcategoryid){
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleORMUtils instance=new SimpleORMUtils();
		StringBuffer sb = new StringBuffer();
		String sql ="select * from (select id,timestart,servicename,createtime,row_number() over(order by timestart desc,createtime desc) pagerownumber FROM ywb_yuyuerecord z";
		if("sysadmin".equals(aclrole)){
		}else if("xjman".equals(aclrole)){
			sql += " where qyname is not null and qyid is not null and yuyuedept is not null and yuyuedeptid is not null "
			+" and qyid in (select ownercode from owner where id in "
			+" (select parentid from ownerrelation m start with m.ownerid='"+userID+"' connect by prior m.parentid=m.ownerid) and ownercode !='331000000000')"
			+" and yuyuedeptid in (select code from kzm_pcsconfig  where areaid=z.qyid)";
		}else if("sService".equals(aclrole)){
			sql += " where qyname is not null and qyid is not null and yuyuedept is not null and yuyuedeptid is not null "
			+" and serviceid in (select k.id from KZM_ZMINFO k where k.zmcategoryid in ("+zmcategoryid+"))";
		}else if("xService".equals(aclrole)){
			sql += " where qyname is not null and qyid is not null and yuyuedept is not null and yuyuedeptid is not null "
			+" and serviceid in (select k.id from KZM_ZMINFO k where k.zmcategoryid in ("+zmcategoryid+"))"
			+" and qyid in (select ownercode from owner where id in "
			+" (select parentid from ownerrelation m start with m.ownerid='"+userID+"' connect by prior m.parentid=m.ownerid)"
			+" and (ownercode in (select areaid from kzm_pcsconfig) or  ownercode in (select qyid from ywb_yuyuerecord)))";
		}
		sql += " ) where rownum<5 order by pagerownumber";
		
		sb.append("<table class=\"public_table\">");
		sb.append("<tr><th style='width:140px'>事项名称</th><th style='width:110px'>预约开始时间</th><th style='width:50px'>操作</th></tr>");
		//System.out.println(sql);
		if(!"".equals(sql)){
			List<Map<String,Object>> list = instance.queryForMap(sql);
			for(Map<String,Object> map : list){
				String servicename = (String)map.get("servicename");
				String timestart = sdf.format((Timestamp)map.get("timestart"));
				String username = (String)map.get("username");
				String id = (String)map.get("id");
				sb.append("<tr>");
				sb.append("<td><span>"+servicename+"</span><span></span></td>");
				sb.append("<td>"+timestart+"</td>");
				sb.append("<td><input type=\"button\" value=\"查看详情\"  onclick=\"goBjyycontent('"+id+"');\"></td>");
				sb.append("</tr>");
			}
		}
		sb.append("</table>");
		
		return sb.toString();
	}
%>
<%!
	public String getysds(String userID,String groupID,String aclrole,String zmcategoryid){
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleORMUtils instance=new SimpleORMUtils();
		StringBuffer sb = new StringBuffer();
		String sql ="select * from (select unid,createtime,applyman,servicename,row_number() over(order by createtime desc) pagerownumber FROM ywb_yscommontab z";
		if("sysadmin".equals(aclrole)){
		}else if("xjman".equals(aclrole)){
			sql += " where acceptareaid in (select ownercode from owner where id in "
			+" (select parentid from ownerrelation m start with m.ownerid='"+userID+"' connect by prior m.parentid=m.ownerid) and ownercode !='331000000000')"
			+" and acceptdeptid in (select code from kzm_pcsconfig  where areaid=z.acceptareaid)";
		}else if("sService".equals(aclrole)){
			sql += " where acceptarea is not null and acceptareaid is not null and acceptdept is not null and acceptdept is not null "
			+" and infoid in (select k.id from KZM_ZMINFO k where k.zmcategoryid in ("+zmcategoryid+"))";
		}else if("xService".equals(aclrole)){
			sql += " where infoid in (select k.id from KZM_ZMINFO k where k.zmcategoryid in ("+zmcategoryid+"))"
			+" and acceptareaid in (select ownercode from owner where id in "
			+" (select parentid from ownerrelation m start with m.ownerid='"+userID+"' connect by prior m.parentid=m.ownerid)"
			+" and (ownercode in (select areaid from kzm_pcsconfig) or  ownercode in (select acceptareaid from ywb_yscommontab)))";
		}
		sql += " ) where rownum<5 order by pagerownumber";
		
		sb.append("<table class=\"public_table\">");
		sb.append("<tr><th style='width:140px'>事项名称</th><th style='width:110px'>时间</th><th style='width:50px'>姓名</th><th style='width:50px'>操作</th></tr>");
		//System.out.println(sql);
		if(!"".equals(sql)){
			List<Map<String,Object>> list = instance.queryForMap(sql);
			for(Map<String,Object> map : list){
				String servicename = (String)map.get("servicename");
				String createtime = sdf.format((Timestamp)map.get("createtime"));
				String applyman = (String)map.get("applyman");
				String unid = (String)map.get("unid");
				sb.append("<tr>");
				sb.append("<td><span>"+servicename+"</span><span></span></td>");
				sb.append("<td>"+createtime+"</td>");
				sb.append("<td>"+applyman+"</td>");
				sb.append("<td><input type=\"button\" value=\"查看详情\"  onclick=\"goBjyscontent('"+unid+"');\"></td>");
				sb.append("</tr>");
			}
		}
		sb.append("</table>");
		
		return sb.toString();
	}
%>
<%!
	public String getsqbj(String userID,String groupID,String aclrole,String zmcategoryid){
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleORMUtils instance=new SimpleORMUtils();
		StringBuffer sb = new StringBuffer();
		String sql = "select * from (select row_number() over(order by createtime desc) pagerownumber, b.unid,servicename,applyman,"
			+"createtime,b.moduleid from zmview b where flag ='1' ";
		if("sysadmin".equals(aclrole)){
		}else if("xjman".equals(aclrole)){
			sql += " and acceptarea is not null and acceptareaid is not null and acceptdept is not null and acceptdeptid is not null "
			+" and acceptareaid in (select ownercode from owner where id in "
			+" (select parentid from ownerrelation m start with m.ownerid='"+userID+"' connect by prior m.parentid=m.ownerid) and ownercode !='331000000000')"
			+" and acceptdeptid in (select code from kzm_pcsconfig  where areaid=b.acceptareaid)";
		}else if("sService".equals(aclrole)){
			sql += " and acceptarea is not null and acceptareaid is not null and acceptdept is not null and acceptdept is not null and moduleid !='ywb_commontab'"
			+" and moduleid in (select k.moduleid from KZM_ZMTYPE k where k.zmcategoryid in ("+zmcategoryid+"))";
		}else if("xService".equals(aclrole)){
			sql += " and acceptarea is not null and acceptareaid is not null and acceptdept is not null and acceptdept is not null and moduleid !='ywb_commontab'"
			+" and moduleid in (select k.moduleid from KZM_ZMTYPE k where k.zmcategoryid in ("+zmcategoryid+"))"
			+" and acceptareaid in (select ownercode from owner where id in "
			+" (select parentid from ownerrelation m start with m.ownerid='"+userID+"' connect by prior m.parentid=m.ownerid)"
			+" and (ownercode in (select areaid from kzm_pcsconfig) or  ownercode in (select acceptareaid from zmview)))";
		}
		sql += " ) where rownum<5 order by pagerownumber";
		//System.out.println(sql);
		List<Map<String,Object>> list = instance.queryForMap(sql);
		sb.append("<table class=\"public_table\" id='dsl'>");
		sb.append("<tr><th style='width:140px'>事项名称</th><th style='width:110px'>时间</th><th style='width:50px'>姓名</th><th style='width:50px'>操作</th></tr>");
		for(Map<String,Object> map : list){
			String servicename = (String)map.get("servicename");
			String createtime = sdf.format((Timestamp)map.get("createtime"));
			String applyman = (String)map.get("applyman");
			String moduleid = (String)map.get("moduleid");
			String unid = (String)map.get("unid");
			sb.append("<tr>");
			sb.append("<td><span>"+servicename+"</span><span></span></td>");
			sb.append("<td>"+createtime+"</td>");
			sb.append("<td>"+applyman+"</td>");
			sb.append("<td><input type=\"button\" value=\"查看详情\" onclick=\"goBjdslcontent('"+moduleid+"','"+unid+"');\"></td>");
			sb.append("</tr>");
		}
		sb.append("</table>");
		
		return sb.toString();
	}

	
%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title><%=SystemConfig.getFieldValue("//systemconfig/system/name")%></title>
	<link href="<%=contextPath%>/resources/template/cn/css/style.css" rel="stylesheet" type="text/css">
	<script language="javascript" type="text/javascript" charset="utf-8" src="<%=contextPath%>/resources/js/jquery/jquery-1.11.0.min.js"></script>
	<style type="text/css">
	
	</style>
	<script type="text/javascript" language="javascript"> 
		$(function(){
			
		});
		
		function opendsl(){
			if($('#dsl').css("display")=="none"){
				$("#dsl").show();
			}else{
				$("#dsl").hide();
			}
		}
		function opendb(){
			if($('#db').css("display")=="none"){
				$("#db").show();
			}else{
				$("#db").hide();
			}
		}
		
		function goZxdhfcontent(unid){
			window.location.href="<%=contextPath%>/view?xmlName=ywb_zixunrecord&appId="+unid+"&lf=1&status=jg";
		}
		function goBjyycontent(id){
			window.location.href="<%=contextPath%>/view?xmlName=yuyuerecord&appId="+id+"&lf=1&status=jg";
		}
		function goBjyscontent(id){
			window.location.href="<%=contextPath%>/view?xmlName=ywb_yscommontab&appId="+id+"&lf=1&status=jg";
		}
		
		function goBjdslcontent(moduleid,unid){
			window.location.href="<%=contextPath%>/view?xmlName="+moduleid+"&lf=1&status=jg&appId="+unid;
		}
	</script>
</head>
<body>
<!--<div class="pyga_zdpyci_rightmianheader">
	<input type="text" name="" class="pyga_zdpyci_rightmianheadersearch" placeholder="Search">
	<input type="button" name="" class="ggbtn" value="+ 搜索">
</div>  -->
<div class="pyga_zdpyci_rightmian_publicwidth">
	<div class="public_table_left_div">
	<div class="public_table_div">
		<div class="public_table_title" ><a href='javascript:void(0);' onclick='opendsl();'>办件管理</a>&nbsp;<a class='public_table_a' href="<%=contextPath%>/jianguan/stat.jsp">更多</a></div>
		<%=sqbjStr%>
	</div>
	<div class="public_table_div">
		<div class="public_table_title"><a href='javascript:void(0);' onclick='opendb();'>预审管理</a>&nbsp;<a class='public_table_a' href="<%=contextPath%>/ywb_yscommontab/tjstat.jsp">更多</a></div>
		<%=ysdsStr%>
	</div>
	</div>
	<div class="public_table_right_div">
		<div class="public_table_div">
		<div class="public_table_title">预约管理&nbsp;<a class='public_table_a' href="<%=contextPath%>/yuyuerecord/tjstat.jsp">更多</a></div>
		<%=yydsStr%>
		</div>
		<div class="public_table_div">
		<div class="public_table_title">咨询管理&nbsp;<a class='public_table_a' href="<%=contextPath%>/ywb_zixunrecord/tjstat.jsp">更多</a></div>
		<%=zzdhfStr%>
		</div>
	</div>
</div>


</body>
</html>
<!--索思奇智版权所有-->