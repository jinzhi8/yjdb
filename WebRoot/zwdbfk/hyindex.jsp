<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="java.util.Date" %>
<%@page import="java.util.ArrayList" %>
<%@page import="java.util.Calendar" %>
<%@page import="com.kizsoft.commons.commons.sql.SQLHelper"%>
<%@page import="com.kizsoft.commons.commons.db.ConnectionProvider"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection" %>
<%@page import="java.sql.ResultSet" %>
<%@page import="java.sql.Statement" %>
<%@page import="java.sql.PreparedStatement" %>
<%@page import="com.kizsoft.commons.util.Pageination" %>
<%@page import="com.kizsoft.commons.commons.util.StringHelper" %> 
<%@page import="java.text.*"%>
<%@page import="java.util.*"%>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.acl.ACLManager" %>
<%@page import="com.kizsoft.commons.acl.ACLManagerFactory" %>
<%@page import="com.kizsoft.oa.wcoa.util.SimpleORMUtils"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<%@taglib prefix="html" uri="/WEB-INF/oa-html.tld" %>
<%@taglib prefix="oa" uri="/WEB-INF/oa.tld" %>


<%User userInfo = (User) session.getAttribute("userInfo");
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

String userTemplateName = (String) session.getAttribute("templatename");
String userTemplateStr = "/resources/template/" + userTemplateName + "/stattemplate.jsp";
if(userTemplateName==null||"".equals(userTemplateName)){
	userTemplateStr = "/resources/jsp/template.jsp";
}	
    int curPage = 1;
	int rowsPerPage = 30;
	if (request.getParameter("page") != null && !request.getParameter("page").equals("")) {
		curPage = Integer.parseInt(request.getParameter("page"));
	} else {
		curPage = 1;
	}
	pageContext.setAttribute("curPage", String.valueOf(curPage));
%>
<%!
	public static String plusDay(int num,String newDate) throws ParseException{
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
%>
<template:insert template="<%=userTemplateStr%>">
	<template:put name='title' content='会议件督办' direct='true'/>
	<%String str = "<a class=\"menucur\" href=\"\">会议件督办</a>"; %>
	<template:put name='moduleNav' content='<%=str%>' direct='true'/>
	<template:put name='content'>
<%
	String sendtime_first = (String) request.getParameter("sendtime_first")==null?"":(String) request.getParameter("sendtime_first");
	String sendtime_last = (String) request.getParameter("sendtime_last")==null?"":(String) request.getParameter("sendtime_last");
	String statue = (String) request.getParameter("statue")==null?"":(String) request.getParameter("statue");
	String appId = (String) request.getParameter("appId")==null?"":(String) request.getParameter("appId");
	String psleader = (String) request.getParameter("psleader")==null?"":(String) request.getParameter("psleader");
	String qtleader = (String) request.getParameter("qtleader")==null?"":(String) request.getParameter("qtleader");
	String zhouqi = (String) request.getParameter("zhouqi")==null?"":(String) request.getParameter("zhouqi");
	String banjie = (String) request.getParameter("banjie")==null?"":(String) request.getParameter("banjie");
	String fkStatus = (String) request.getParameter("fkStatus")==null?"":(String) request.getParameter("fkStatus");
	String fkYear = (String) request.getParameter("fkYear")==null?"":(String) request.getParameter("fkYear");
	String fkMonth = (String) request.getParameter("fkMonth")==null?"":(String) request.getParameter("fkMonth");
	String px = (String) request.getParameter("px")==null?"":(String) request.getParameter("px");
	String yearl = (String) request.getParameter("yearl")==null?"":(String) request.getParameter("yearl");
	String  numl= (String) request.getParameter("numl")==null?"":(String) request.getParameter("numl");
	String  jsl= (String) request.getParameter("jsl")==null?"":(String) request.getParameter("jsl");
	int maxRow = 0;
	ACLManager aclManager = ACLManagerFactory.getACLManager();
	String role="";
	if (aclManager.isOwnerRole(userId,"dbk")){
        role="";
	}else if(aclManager.isOwnerRole(userId,"msk")){
		role=" and userid like'%"+userId+"%' ";
	}else if(aclManager.isOwnerRole(userId,"dbkld")){
		role=" and (qfmanid like'%"+userName+"%' or leadername like '%"+userName+"%') ";
	}
    else{
		role=" and (managedepid like'%"+groupID+"%' or copytoid like '%"+groupID+"%') ";
	}
					Connection con = null;
					PreparedStatement stmt = null;
					ResultSet rs = null;

					StringBuffer bufferdep = new StringBuffer();
					StringBuffer buffer = new StringBuffer();
	
			        String sql ="select min(fkstatus) as fkstatus,min(js) as js,min(hy) as hy,min(nextsj) as nextsj,min(qftime) as qftime,min(fkcs) as fkcs,min(qfmanid) as qfmanid,min(fkzq) as fkzq,min(fklx) as fklx,min(unid) as unid,min(year) as year,min(num) as num,min(title) as title,min(require) as require,min(leadername) as leadername,min(managedepname) as managedepname,min(source) as source,min(lxr) as lxr,min(issuetime) as issuetime,min(jbsx) as jbsx,min(qfman) as qfman,dbid,min(copyto) as copyto,min(endsj) as endsj,min(isfk) as isfk from (select z.*,za.nextsj,za.dbid,za.endsj,za.fkrid,decode(sign((select count(1) from ZWDBFKPG zpg where zpg.dbid=z.unid and Extract(year from zpg.fksj)='"+fkYear+"' and Extract(month from zpg.fksj)='"+fkMonth+"')),1,'已反馈','待反馈') as fkstatus,decode(z.fklx,'周期反馈',decode(z.fkzq,'每周',ceil((z.jbsx-z.qftime)/7),'半月',ceil((z.jbsx-z.qftime)/15),'每月',ceil((z.jbsx-z.qftime)/30),'半年',ceil((z.jbsx-z.qftime)/180)),1) as fkcs from zwdb z,ZWDBACL za where z.unid=za.dbid) where isjs='2' and  hy is not null  "+role+" ";
					 
					if(!"".equals(sendtime_first) && !"".equals(sendtime_last)){	
                        sql+="and issuetime between to_date('"+sendtime_first+"','YYYY-MM-DD') and to_date('"+sendtime_last+" ','YYYY-MM-DD')";
                    }
                    if(!"".equals(appId)){
						sql+="and  docunid='"+appId+"'";
                	}
                    if("0".equals(statue)){
						sql+="and  qftime= trunc(sysdate)";
                	}
                	if("已办结".equals(banjie)){
						sql+="and  qfman='办结' ";
                	}
                	if("未办结".equals(banjie)){
						sql+="and  qfman='未办结' ";
                	}
                	if(!"".equals(fkStatus)){
						sql+="and fkstatus='"+fkStatus+"'  ";
                	}
                	if("5".equals(statue)){
						sql+="and  num is null ";
                	}
                	if(!"".equals(psleader)){
						sql+="and qfmanid='"+psleader+"' ";
                	}
                	if(!"".equals(qtleader)){
						sql+="and leadername='"+qtleader+"' ";
                	}
                	if("一次性反馈".equals(zhouqi)){
						sql+="and fklx='"+zhouqi+"' ";
                	}
                	if("周期反馈".equals(zhouqi)){
						sql+="and fklx='"+zhouqi+"' ";
                	}
                	if(!"".equals(yearl)){
						sql+="and year='"+yearl+"' ";
                	}
                	if(!"".equals(numl)){
						sql+="and num='"+numl+"' ";
                	}
                	if(!"".equals(jsl)){
						sql+="and js='"+jsl+"' ";
                	}
                	if("立项编号".equals(px)){
					    sql+=" group by dbid,year,num,issuetime order by year desc,num desc,issuetime desc";
                	}
                	if("牵头单位".equals(px)){
					    sql+=" group by dbid,year,num,issuetime order by managedepname desc";
                	}
                	if("批示领导".equals(px)){
					    sql+=" group by dbid,year,num,issuetime order by qfmanid desc";
                	}
                	if("".equals(px)){
					     sql+=" group by dbid,year,num,issuetime order by year desc,num desc,issuetime desc";
                	}	
					Statement dstmt = null;
	                try {
					        con= ConnectionProvider.getConnection();
			                dstmt = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			                rs = dstmt.executeQuery(sql);
			                //数据分页-开始  
						    rs.last();
			                maxRow = rs.getRow();
			                Pageination pageObj;
			                HttpServletRequest req = (HttpServletRequest) pageContext.getRequest();
			                String url = req.getRequestURL().toString();
			                url += "?sendtime_first="+sendtime_first+"&sendtime_last="+sendtime_last+"&page=";
			                String toolbar="";
			                if (-1 != curPage) {
				            pageObj = new Pageination(rowsPerPage, curPage, maxRow);
				            StringBuffer headerStr = new StringBuffer();
				            toolbar = "<div align=right id=\"viewtoolbar\" class=viewtoolbar>共" + pageObj.getMaxRowCount() + "条 共" + pageObj.getMaxPage() + "页 当前第" + pageObj.curPage + "页 |" + (pageObj.getFirstPageFlag() ? " <font style=\"color:#a0a0a0\">第一页</font> |" : " <a href=\"" + url + "1\" >第一页</a> |") + (pageObj.getFirstPageFlag() ? " <font style=\"color:#a0a0a0\">上一页</font> |" : " <a href=\"" + url + (pageObj.curPage - 1) + "\" >上一页</a> |") + (pageObj.getLastPageFlag() ? " <font style=\"color:#a0a0a0\">下一页</font> |" : " <a href=\"" + url + (pageObj.curPage + 1) + "\" >下一页</a> |") + (pageObj.getLastPageFlag() ? " <font style=\"color:#a0a0a0\">最后一页</font> |</div>" : " <a href=\"" + url + pageObj.getMaxPage() + "\" >最后一页</a> |</div>");
				            //headerStr.append(toolbar);
				            headerStr.append("<table id=\"viewtable\" class=\"viewlist viewlistZ_h\"><tr class=\"head viewlistZ_htr\">");
				            //加入表格头-开始
				           headerStr.append("<th align=center width=\"8%\">立项编号</th><th align=center width=\"22%\">批示件名称（来源）<br/>[具体内容]</th><th align=center width=\"8%\">批示领导</th><th align=center width=\"8%\">牵头领导<br/>[牵头单位]</th><th align=center width=\"8%\">配合领导<br/>[配合单位]</th><th align=center width=\"8%\">督办机构<br/>联系人</th><th align=center width=\"8%\">反馈时间要求</th><th align=center width=\"8%\">反馈情况</th><th align=center width=\"8%\">最近反馈情况</th><th align=center width=\"6%\">是否办结</th><th align=center width=\"8%\">发布时间</th><th align=center width=\"8%\">操作</th></th>");
				           //加入表格头-结束
				           headerStr.append("</tr>");
			               buffer.append(headerStr.toString());   
			               }else {
			               pageObj = new Pageination(rowsPerPage, 1, maxRow);
				           StringBuffer headerStr = new StringBuffer();
				           headerStr.append("<table id=\"view_content_table\" class=\"my_cont\" width=\"100%\" border=\"0\" cellpadding=\"4\" cellspacing=\"1\">");
				           buffer.append(headerStr.toString());
			               } 
			               int rowIdx = ((pageObj.getCurPage() == 0 ? 1 : pageObj.getCurPage()) - 1) * rowsPerPage;
						   					   
			               if (maxRow > 0 && rowIdx < maxRow) {
			               rs.absolute(rowIdx + 1);
						   
				           for (int i = 0; i < rowsPerPage && !rs.isAfterLast(); i++) {
						   
					       
					       //加入数据链接-开始
					       String unid = rs.getString("unid") == null ? "&nbsp" : rs.getString("unid");
						   String year = rs.getString("year") == null ? "&nbsp" : rs.getString("year");
					       String num = rs.getString("num") == null ? "&nbsp" : rs.getString("num");
					       String js = rs.getString("js") == null ? "&nbsp" : rs.getString("js");
					       String title = rs.getString("title") == null ? "&nbsp" : rs.getString("title");
					   	   String require = rs.getString("require") == null ? "&nbsp" : rs.getString("require");
					   	   String leadername = rs.getString("leadername") == null ? "&nbsp" : rs.getString("leadername");
					       String managedepname = rs.getString("managedepname") == null ? "&nbsp" : rs.getString("managedepname");
					       String source = rs.getString("source") == null ? "&nbsp" : rs.getString("source");
					       String fklx = rs.getString("fklx");
					       String fkzq = rs.getString("fkzq")==null?"":rs.getString("fkzq");
					   	   String lxr = rs.getString("lxr") == null ? "&nbsp" : rs.getString("lxr");
					       Date qftime = rs.getDate("qftime");
					       Date jbsx = rs.getDate("jbsx");
					       String qfman = rs.getString("qfman") == null ? "&nbsp" : rs.getString("qfman");	
						   String copyto = rs.getString("copyto") == null ? "&nbsp" : rs.getString("copyto");
						   String qfmanid = rs.getString("qfmanid") == null ? "&nbsp" : rs.getString("qfmanid");
						   String fkcs = rs.getString("fkcs") == null ? "&nbsp" : rs.getString("fkcs");
						   String hy = rs.getString("hy") == null ? "&nbsp" : rs.getString("hy");
						   String endsj = rs.getString("endsj") == null ? "&nbsp" : rs.getString("endsj");
						   String isfk = rs.getString("isfk") == null ? "&nbsp" : rs.getString("isfk");
						   String color="";
						   SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
						   Date date=new Date();
						   Date endtime = sdf.parse(endsj);
						   long day = (endtime.getTime() - date.getTime());
						   long nd = 1000 * 24 * 60 * 60;
						   if(!qfman.equals("办结")&&!isfk.equals("1")&&day<(1*nd)){
						   	 	color="#f4dddd";
						   }else if(!qfman.equals("办结")&&!isfk.equals("1")&&day<(3*nd)){
						   	  	color="#F2F0D2";
						   }else if(!qfman.equals("办结")&&!isfk.equals("1")&&day<(7*nd)){
						   	  	color="#ddf4ef";
						   }else{
						   		color="white";
						   }
						   System.out.println("color:"+color);
						   if(hy.equals("会议")){
									hy="（会议件督办）";
						   }else{
						   		hy="";
						   }
						   Object nextsjl="";
						   Object endsjl="";
						   Object fksj="";	
						   Object yfkcount="";	
						   Object jsfk="";
						   Object fjsfk="";
 						   SimpleORMUtils instance=SimpleORMUtils.getInstance();
						   List<Map<String,Object>> list=instance.queryForMap("select t.*,to_char(nextsj,'yyyy-mm-dd') as nextsjl,to_char(endsj,'yyyy-mm-dd') as endsjl from ZWDBACL t where t.dbid=?",unid);

						   List<Map<String,Object>> sflist=instance.queryForMap("select * from(select zpg.*,to_char(finishtime,'yyyy-mm-dd') as finishtimel,to_char(begintime,'yyyy-mm-dd') as begintimel,to_char(fksj,'yyyy-mm-dd') as fksjl from ZWDBFKPG zpg where zpg.dbid=? order by fksj desc)where rownum=1",unid);


						   List<Map<String,Object>> listyfk=instance.queryForMap("select count(*) as count from ZWDBFKPG zpg where zpg.dbid=? ",unid);
						   List<Map<String,Object>> jslist=instance.queryForMap("select count(*) as count from ZWDBFKPG zpg where zpg.dbid=? and fksj>= trunc(begintime)-1 and fksj < trunc(finishtime)+1  ",unid);

						   List<Map<String,Object>> fjslist=instance.queryForMap("select count(*) as count from ZWDBFKPG zpg where zpg.dbid=? and (fksj > trunc(finishtime)+1 or fksj < trunc(begintime)-1)",unid);

						   if(fjslist.size()!=0){
						   		Map<String,Object> map =fjslist.get(0);
						   		fjsfk=map.get("count")==null?"0":map.get("count");
						   }

						   if(jslist.size()!=0){
						   		Map<String,Object> map =jslist.get(0);
						   		jsfk=map.get("count")==null?"0":map.get("count");
						   }
						   
						   if(listyfk.size()!=0){
						   		Map<String,Object> map =listyfk.get(0);
						   		yfkcount=map.get("count")==null?"0":map.get("count");
						   }

						   if(list.size()!=0){
						   		Map<String,Object> map =list.get(0);
						   		nextsjl=map.get("nextsjl");
						   		endsjl=map.get("endsjl"); 
						   	}
						   	Object newbtime="";
						   	if(sflist.size()!=0){
						   		Map<String,Object> map =sflist.get(0);
						   		fksj=map.get("fksjl");
						   		newbtime=map.get("begintimel")+"至<br/>"+map.get("finishtimel");

						   	}else{
						   		fksj="无";
						   		newbtime="无";
						   	}
							String dbk="";
							if (aclManager.isOwnerRole(userId, "dbk")){
									dbk="<div style=\"display:none;\" class=\"MM_over_psj\"><a href=\""+request.getContextPath()+"/edit?xmlName=zwdbfk&appId="+unid+"&lf=1\">编辑</a><a href=\"javascript:fwh('"+unid+"');\">赋文号</a><a href=\"javascript:dxcb('"+unid+"');\">短信催办</a></div>";
							}else if(aclManager.isOwnerRole(userId, "msk")){
								dbk="<div style=\"display:none;\" class=\"MM_over_psj\"><a href=\""+request.getContextPath()+"/edit?xmlName=zwdbfk&appId="+unid+"&lf=1\">编辑</a><a href=\"javascript:dxcb('"+unid+"');\">短信催办</a></div>";
							}
							SimpleDateFormat sdfp=new SimpleDateFormat("yyyy-MM-dd");
							String firsttime=sdfp.format(new Date());
							String lasttime="";
							String fkzql="";
							if(fklx.equals("周期反馈")){
								if(fkzq.equals("每周")){
									fkzql="7";
								}else if(fkzq.equals("半月")){
									fkzql="15";
								}else if(fkzq.equals("每月")){
									fkzql="30";
								}else if(fkzq.equals("半年")){
									fkzql="180";
								}else{
									fkzql="1";
								}
								int zq=Integer.parseInt(fkzql);
								lasttime=plusDay(zq,firsttime);
							}else{
								lasttime=sdfp.format(jbsx);
							}
							buffer.append("<tr style=\"background :"+color+"\" class=\"" + (i % 2 != 0 ? "yuan" : "wang") + "\" onmouseover=\"MM_over(this)\" onmouseout=\"MM_out(this)\">" );

					        buffer.append("<td align=center width=\"8%\">文会督〔"+year+"〕"+num+"号 "+js+"事项</td><td align=center width=\"20%\">"+title+""+hy+"<br/><br/>["+require+"]"+dbk+"</td><td align=center width=\"8%\">"+qfmanid+"</td><td align=center width=\"8%\">"+leadername+"<br/><br/>["+managedepname+"]</td><td align=center width=\"8%\">"+source+"<br/><br/>["+copyto+"]</td><td align=center width=\"8%\">"+lxr+"</td><td align=center width=\"8%\">"+fklx+"["+fkzq+"]<br/>截止日期:<br/>"+jbsx+"</td><td align=center width=\"8%\">要求反馈:"+fkcs+"次<br/>已反馈:"+yfkcount+"次<br/>及时反馈:"+jsfk+"<br/>超时反馈:"+fjsfk+"</td><td align=center width=\"8%\">最近反馈日期:<br/>"+fksj+"<br/>最近反馈区间:<br/>"+newbtime+"</td><td align=center width=\"6%\">"+qfman+"</td><td align=center width=\"8%\">"+qftime+"</td><td  align=center width=\"8%\"><input type=\"button\" class=\"viewlistZ_h_button\" onmousemove=\"this.className='viewlistZ_h_buttons'\" onmouseout=\"this.className='viewlistZ_h_button'\"  value=\"单位反馈情况\" onclick=\"javascript:window.location.href='"+request.getContextPath()+"/view?xmlName=zwdbfk&appId="+unid+"&lf=1';\"></td>");

					       //加入数据链接-结束
					       buffer.append("</tr>");
					       rs.next();
				           }
			               }
						   if (maxRow - rowIdx < rowsPerPage) {
				           for (int m = maxRow - rowIdx; m < rowsPerPage; m++) {
					       buffer.append("<tr class=\"" + (m % 2 != 0 ? "yuan" : "wang") + "\">");
					       //加入补足空行-开始
					       buffer.append("<td align=center width=\"8%\">&nbsp;</td><td align=center width=\"20%\">&nbsp;</td><td align=center width=\"8%\">&nbsp;</td><td align=center width=\"8%\">&nbsp;</td><td align=center width=\"8%\">&nbsp;</td><td align=center width=\"8%\">&nbsp;</td><td align=center width=\"8%\">&nbsp;</td><td align=center width=\"8%\">&nbsp;</td><td align=center width=\"8%\">&nbsp;</td><td align=center width=\"6%\">&nbsp;</td><td align=center width=\"8%\">&nbsp;</td><td align=center width=\"8%\">&nbsp;</td>");
					       //加入补足空行-结束
					       buffer.append("</tr>");
			              }
			              }
			              buffer.append("</table>");
			              buffer.append(toolbar);
		              } catch (Exception e) {
		                	e.printStackTrace();
		              } finally {
			                ConnectionProvider.close(con, stmt, rs);
		              }		
 					%>


		<script>
		function MM_over(mmObj) {
			var mSubObj = mmObj.getElementsByTagName("div")[0];
			mSubObj.style.display = "block";
		}
		function MM_out(mmObj) {
			var mSubObj = mmObj.getElementsByTagName("div")[0];
			mSubObj.style.display = "none";
			
		}
		function fwh(unid){
			var width = 550;
            var height = 250;
            var iTop = (window.screen.availHeight - height ) / 2;
            var iLeft = (window.screen.availWidth - width) / 2 + 90;
            var win = window.open( "<%=request.getContextPath()%>/zwdbfk/fwh.jsp?unid="+unid, "弹出窗口", "width=" + width + ", height=" + height + ",top=" + iTop + ",left=" + iLeft + ",toolbar=no, menubar=no, scrollbars=yes, resizable=no,location=no, status=no,alwaysRaised=yes,depended=yes");
		}
		function updatecallfun(){
			window.location.href ="<%=request.getContextPath()%>/zwdbfk/hyindex.jsp?statue=<%=statue%>&sendtime_first=<%=sendtime_first%>&sendtime_last=<%=sendtime_last%>&appId=<%=appId%>";
		}

		function dxcb(unid){
			var width = 600;
            var height = 350;
            var iTop = (window.screen.availHeight - height ) / 2;
            var iLeft = (window.screen.availWidth - width) / 2 + 90;
            var win = window.open( "<%=request.getContextPath()%>/zwdbfk/dxcb.jsp?unid="+unid, "弹出窗口", "width=" + width + ", height=" + height + ",top=" + iTop + ",left=" + iLeft + ",toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no,alwaysRaised=yes,depended=yes");
		}
		</script>
 		<script src="../zwdbfk/js/jquery-1.8.2.min.js" type="text/javascript"></script>
		<script src="../zwdbfk/js/tabScript.js" type="text/javascript"></script>
		<script>
			$(function(){
				loadTab();
			});
		</script>
		<style type="text/css">
		*{
			font-family: SimHei;
			font-weight: normal;
		}
		.wcoa_dcb_tabs{
			list-style:none;
			padding: 0px;
			/* display: table; */
			margin-bottom: 0px;
			margin-left: 0px;
			position: absolute;
			left: 6px;
			margin-top: 0px;
		}
		.wcoa_dcb_tabs li{
			float: left;
			margin-right: 5px;
			background-repeat: repeat-x;
			background-position: center;
		}
		.wcoa_dcb_tabs li a{
			padding: 8px 10px;
			display: block;
			font-family: 'SimHei';
		}
		.wcoa_dcb_tabs_1{
			background-image: url(../zwdbfk/images/wcoa_dcb_tabs_1.jpg);
		}
		.wcoa_dcb_tabs_2{
			background-image: url(../zwdbfk/images/wcoa_dcb_tabs_2.jpg);
		}
		.wcoa_dcb_tabs_3{
			background-image: url(../zwdbfk/images/wcoa_dcb_tabs_3.jpg);
		}
		.wcoa_dcb_tabs_4{
			background-image: url(../zwdbfk/images/wcoa_dcb_tabs_4.jpg);
		}
		.wcoa_dcb_tabs_5{
			background-image: url(../zwdbfk/images/wcoa_dcb_tabs_5.jpg);
		}
		.wcoa_dcb_tabs_6{
			background-image: url(../zwdbfk/images/wcoa_dcb_tabs_6.jpg);
		}
		.wcoa_dcb_tabscurrent{
			background-color: #5ca8e2 !important;
			color: white !important;
		}
		.wcoa_dcb_tabs_content{
			width: 100%;
			display: block;
			clear: both;
			padding-top: 10px;
		}
		.wcoa_dcb_tabs_content table{
			width: 100%;
		}
		.viewlistZ_h{
			border-top: none !important;
		}
		.viewlistZ_h th{
			border-color: transparent;
			border: none !important;
			color: white !important;
			line-height: 18px;
			padding: 8px 0px;
			background-color: transparent;
			/* background-color: #3D9CDE !important; */
			/* background: -webkit-gradient(linear, 0 0, 0 100%, from(#5ca8e2), to(#3a96dc)) !important;
			background: -moz-linear-gradient(top, #5ca8e2, #3a96dc) !important;
			background: -o-linear-gradient(top, #5ca8e2, #3a96dc) !important;
			background: -ms-linear-gradient(#5ca8e2 0%,#3a96dc 100%) !important;
			filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#5ca8e2',endColorstr='#3a96dc',grandientType=1) !important;
			-ms-filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#5ca8e2',endColorstr='#3a96dc',grandientType=1) !important; */
		}
		.viewlistZ_htr{
			background-image: url(../zwdbfk/images/viewlistZ_htrbg.jpg) !important;
		}
		.viewlistZ_h_button{
			border: none;
			color: white;
			padding: 6px 5px;
			background: -webkit-gradient(linear, 0 0, 0 100%, from(#7CC0F5), to(#3a96dc));
			background: -moz-linear-gradient(top, #7CC0F5, #3a96dc);
			background: -o-linear-gradient(top, #7CC0F5, #3a96dc);
			background: -ms-linear-gradient(#7CC0F5 0%,#3a96dc 100%);
			filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#7CC0F5',endColorstr='#3a96dc',grandientType=1);
			-ms-filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#7CC0F5',endColorstr='#3a96dc',grandientType=1);
		}
		.viewlistZ_h_buttons{
			border: none;
			color: white;
			padding: 6px 5px;
			background-color: #2172BD;
		}
		.wang:hover,.yuan:hover{
			background-color: #D8E7F5 !important;
		}
		.MM_over_psj{
			text-align: center;
			margin: 10px 0px;
		}
		.MM_over_psj a{
			background-color: #57abe3;
			border: none;
			color: white !important;
			padding: 6px 10px;
			margin: 3px;
		}
		.MM_over_psj a:hover{
			background-color: #3C97DD;
		}
		.viewlistZ_h_button_bj{
			width: 30px;
			height: 30px;
			display: block;
			background-image: url(../zwdbfk/images/viewlistZ_h_button_bj.png);
		}
		.viewlistZ_h_button_zb{
			width: 30px;
			height: 30px;
			display: block;
			background-image: url(../zwdbfk/images/viewlistZ_h_button_zb.png);
		}
		.the_query_deriveddivboxs{
			/* background-color: #F7F7F7; */
			width: 100%;
		    background-color: #D8E7F5;
		    padding-bottom: 10px;
		    border: 1px solid #A5CDF0;
		}
		.the_query_deriveddiv{
			font-size: 14px;
			font-family: SimHei;
			/* text-align: center; */
			line-height: 35px;
			padding: 10px 20px;
			margin-top: 10px;
			text-align: center;
			/* background-color: #F7F7F7; */
			table-layout: fixed;
		}
		.the_query_deriveddiv ul{
			padding: 0px;
			margin: 0 auto;
			display: inline-table;
			width: 900px;
		}
		.the_query_deriveddiv ul li{
			text-align: left;
			list-style: none;
			width: 900px;
		}
		.the_query_deriveddiv input{
			font-size: 14px;
			font-family: SimHei;
			height: 25px;
			line-height: 25px;
			padding: 0px;
			margin-bottom: 3px;
			border: 1px solid #E2E3EA;
		}
		.the_query_deriveddiv select{
			font-size: 14px;
			font-family: SimHei;
			height: 25px;
			line-height: 25px;
			padding: 0px;
			margin-bottom: 3px;
			border: 1px solid #E2E3EA;
		}
		.searchview_gai{
			/* position: absolute;
			right: 4px; */
			/* margin-top: 15px; */
			font-size: 14px;
			font-family: SimHei;
			text-align: center;
		}
		.searchview_gai input{
			/* height: 23px; */
			line-height: 23px;
			font-family: SimHei;
			color: #FFFFFF;
			border: 1px #93bee2 solid;
			border-bottom: #4099DD 1px solid;
			border-left: #4099DD 1px solid;
			border-right: #4099DD 1px solid;
			border-top: #4099DD 1px solid;
			background-color: #4099DD;
			cursor: pointer;
			outline: none;
			margin: 0px 3px !important;
			padding-left: 5px;
			padding-right: 5px;
		}
		.searchview_gai form{
			margin: 0px;
		}
		.round_twos{
			border-top-width: 0px;
			border-right-width: 0px;
			border-bottom-width: 0px;
			border-left-width: 0px;
			background-color: #ffffff;
			padding-top: 6px;
			padding-right: 6px;
			padding-bottom: 6px;
			padding-left: 6px;
			border-top-style: solid;
			border-right-style: solid;
			border-bottom-style: solid;
			border-left-style: solid;
			border-top-color: #7D7D7D;
			border-right-color: #7D7D7D;
			border-bottom-color: #7D7D7D;
			border-left-color: #7D7D7D;
			margin-top: 10px;
			margin-bottom: 10px;
			margin-left: 0px;
			margin-right: 0px;
		}/* 
		.tjhbutton {
			font-size: 14px;
			height: 23px;
			line-height: 23px;
			font-family: SimHei;
			color: #FFFFFF;
			border: 1px #93bee2 solid;
			border-bottom: #4099DD 1px solid;
			border-left: #4099DD 1px solid;
			border-right: #4099DD 1px solid;
			border-top: #4099DD 1px solid;
			background-color: #4099DD;
			cursor: pointer;
			padding: 0px 20px;
			outline: none;
			margin: 0px 5px !important;
		} */
		.tjhbutton:hover{
			background-color: #095FAF;
		}
		#form1{
			margin: 0px;
			margin-bottom: 5px !important;
		}
		.viewlist th{
			font-size: 13px !important;
		}
		</style>
		<script>
			function exportxls(statue){
        		window.location.href ="<%=request.getContextPath()%>/zwdbfk/hyindex.jsp?statue="+statue;
    		}
    		function daochu(statue){
    			window.location.href ="<%=request.getContextPath()%>/zwdbfk/searchtongjihy.jsp?statue=<%=statue%>&sendtime_first=<%=sendtime_first%>&sendtime_last=<%=sendtime_last%>&appId=<%=appId%>&psleader=<%=psleader%>&qtleader=<%=qtleader%>&zhouqi=<%=zhouqi%>&banjie=<%=banjie%>&fkStatus=<%=fkStatus%>&fkYear=<%=fkYear%>&fkMonth=<%=fkMonth%>&px=<%=px%>&yearl=<%=yearl%>&numl=<%=numl%>&jsl=<%=jsl%>";
    		}
		</script>
			<div class="round_twos">
				<form id='form1' onsubmit="this.action=window.location.href.substring(0,window.location.href.indexOf('?'));" action="" method="post">
					<div class="the_query_deriveddivboxs">
					<div class="the_query_deriveddiv">
						<ul>
						<li>
							部署时间:
							<html:text name="sendtime_first" readonly="true" style="width:80px;" value="<%=sendtime_first%>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'});"/>至
							<html:text name="sendtime_last" readonly="true" style="width:80px;" value="<%=sendtime_last%>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'});"/>&nbsp;

							批示领导:
							<input type="text" name="psleader" value="<%=psleader%>" style="width:80px;"/></td>
							<img src="<%=request.getContextPath()%>/resources/images/actn133.gif" onclick="window.showModalDialog('<%=request.getContextPath()%>/address/tree.jsp?utype=1&sflag=0&count=1&activid=2c90b371078d506501078d955ae50004&fields=psleader',window,'status:no;dialogWidth:300px;dialogHeight:380px;scroll:no;help:no;')">&nbsp;
						    
						    牵头领导:
							<input type="text" name="qtleader" value="<%=qtleader%>" style="width:80px;"/></td>
							<img src="<%=request.getContextPath()%>/resources/images/actn133.gif" onclick="window.showModalDialog('<%=request.getContextPath()%>/address/tree.jsp?utype=1&sflag=0&count=1&activid=2c90b371078d506501078d955ae50004&fields=qtleader',window,'status:no;dialogWidth:300px;dialogHeight:380px;scroll:no;help:no;')">&nbsp;

							反馈周期:
							<html:select name = "zhouqi" value="<%=zhouqi%>" style="width:90px" >
							<html:option value = "">请选择</html:option>
							<html:option value = "一次性反馈">一次性反馈</html:option>
	                        <html:option value = "周期反馈">周期反馈</html:option>
	                        </html:select>
						</li>
						<li>
							办件状态:
	                        <html:select name = "banjie"  value="<%=banjie%>" style="width:70px">
	                        	<html:option value = "">请选择</html:option>
	                            <html:option value = "已办结">已办结</html:option>
	                            <html:option value = "未办结">未办结</html:option>
	                   		</html:select>&nbsp;&nbsp;

	                   		反馈状态:
	                        <html:select name = "fkStatus" value="<%=fkStatus%>"  style="width:70px">
	                        	<html:option value = "">请选择</html:option>
	                            <html:option value = "已反馈">已反馈</html:option>
	                            <html:option value = "待反馈">待反馈</html:option>
	                   		</html:select>
							年:
	                        <html:select name = "fkYear" value="<%=fkYear%>" style="width:60px">
	                            <html:option value = "2017">2017</html:option>
	                             <html:option value = "2018">2018</html:option>
	                            <html:option value = "2019">2019</html:option>
	                   		</html:select>
	                   		月:
	                        <html:select name = "fkMonth" value="<%=fkMonth%>"  style="width:40px">
	                            <html:option value = "1">1</html:option>
	                            <html:option value = "2">2</html:option>
	                            <html:option value = "3">3</html:option>
	                            <html:option value = "4">4</html:option>
	                            <html:option value = "5">5</html:option>
	                            <html:option value = "6">6</html:option>
	                            <html:option value = "7">7</html:option>
	                            <html:option value = "8">8</html:option>
	                            <html:option value = "9">9</html:option>
	                            <html:option value = "10">10</html:option>
	                            <html:option value = "11">11</html:option>
	                            <html:option value = "12">12</html:option>
	                   		</html:select>&nbsp;&nbsp;
	                   		排序方式:
	                        <html:select name = "px" value="<%=px%>" style="width:80px">
	                        	<html:option value = "">请选择</html:option>
	                            <html:option value = "立项编号">立项编号</html:option>
	                            <html:option value = "牵头单位">牵头单位</html:option>
	                            <html:option value = "批示领导">批示领导</html:option>
	                   		</html:select>&nbsp;
	                   		 文会督（
							<html:text name="yearl"  style="width:40px;" value="<%=yearl%>"/>）
							<html:text name="numl" style="width:20px;" value="<%=numl%>"/>号
							<html:text name="jsl" style="width:20px;" value="<%=jsl%>"/>事项
						</li>
						</ul>
					</div>
					<div class="searchview_gai">
						<input type="button" class="tjhbutton" onclick="exportxls('');javascript:void(0)" value="所有督办件">
						<input type="button"  onclick="exportxls('5');javascript:void(0)" value="未赋号件">
						<input type="submit" class="tjhbutton" value="查询" />
						<input type="button" class="tjhbutton" onclick="daochu();" value="导出" />
			 		</div>
					</div>
			 	</form>	
				<!-- <ul class="wcoa_dcb_tabs">
					<li class="wcoa_dcb_tabs_1"><a href="javascript:void(0)" onclick="exportxls('')" name=".wcoa_dcb_tab1">所有督办件</a></li>
					<li class="wcoa_dcb_tabs_2"><a href="javascript:void(0)" onclick="exportxls('0')" name=".wcoa_dcb_tab2">新录入</a></li>
					<li class="wcoa_dcb_tabs_3"><a href="javascript:void(0)" onclick="exportxls('1')" name=".wcoa_dcb_tab3">已落实</a></li>
					<li class="wcoa_dcb_tabs_4"><a href="javascript:void(0)" onclick="exportxls('2')"  name=".wcoa_dcb_tab4">一个月以上未落实</a></li>
					<li class="wcoa_dcb_tabs_5"><a href="javascript:void(0)" onclick="exportxls('3')"  name=".wcoa_dcb_tab5">两个月以上未落实</a></li>
					<li class="wcoa_dcb_tabs_6"><a href="javascript:void(0)" onclick="exportxls('4')" name=".wcoa_dcb_tab6">三个月以上未落实</a></li>
					<li class="wcoa_dcb_tabs_3"><a href="javascript:void(0)" onclick="exportxls('5')" name=".wcoa_dcb_tab7">未赋号件</a></li>
				</ul> -->
				<tr>
				
			</tr>
				<div class="wcoa_dcb_tabs_content">
					<div class="wcoa_dcb_tab1"><%=buffer.toString()%></div>
					<div class="wcoa_dcb_tab2"><%=buffer.toString()%></div>
					<div class="wcoa_dcb_tab3"><%=buffer.toString()%></div>
					<div class="wcoa_dcb_tab4"><%=buffer.toString()%></div>
					<div class="wcoa_dcb_tab5"><%=buffer.toString()%></div>
					<div class="wcoa_dcb_tab6"><%=buffer.toString()%></div>
					<div class="wcoa_dcb_tab7"><%=buffer.toString()%></div>
				</div>
			</div>
	</template:put>
</template:insert><!--索思奇智版权所有-->