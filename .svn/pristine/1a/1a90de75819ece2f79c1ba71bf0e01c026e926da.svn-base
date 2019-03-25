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
<%@page import="com.kizsoft.commons.commons.orm.SimpleORMUtils"%>
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
<template:insert template="<%=userTemplateStr%>">
	<template:put name='title' content='会议件督办' direct='true'/>
	<%String str = "<a class=\"menucur\" href=\"\">会议件督办</a>"; %>
	<template:put name='moduleNav' content='<%=str%>' direct='true'/>
	<template:put name='content'>
<%
	String sendtime_first = (String) request.getParameter("sendtime_first")==null?"":(String) request.getParameter("sendtime_first");
	String sendtime_last = (String) request.getParameter("sendtime_last")==null?"":(String) request.getParameter("sendtime_last");
	String statue = (String) request.getParameter("statue")==null?"":(String) request.getParameter("statue");
	int maxRow = 0;
	ACLManager aclManager = ACLManagerFactory.getACLManager();
	
					Connection con = null;
					PreparedStatement stmt = null;
					ResultSet rs = null;

					StringBuffer bufferdep = new StringBuffer();
					StringBuffer buffer = new StringBuffer();
	
			        String sql ="select * from ZWDBHY where isjs='2'";
					 
					if(!"".equals(sendtime_first) && !"".equals(sendtime_last)){	
                        sql+="and issuetime between to_date('"+sendtime_first+"','YYYY-MM-DD') and to_date('"+sendtime_last+" ','YYYY-MM-DD')  ";
                    } 
             

                    sql+="order by issuetime desc";
                     

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
				            headerStr.append("<th align=center width=\"8%\">部署县长</th><th align=center width=\"20%\">会议名称</th><th align=center width=\"8%\">会议时间</th><th align=center width=\"8%\">会议类型</th><th align=center width=\"8%\">督办情况</th><th align=center width=\"8%\">各单位反馈情况</th>");
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
						   
					       buffer.append("<tr class=\"" + (i % 2 != 0 ? "yuan" : "wang") + "\" onmouseover=\"MM_over(this)\" onmouseout=\"MM_out(this)\">" );
					       //加入数据链接-开始

					       String unid = rs.getString("unid") == null ? "&nbsp" : rs.getString("unid");
						   String year = rs.getString("year") == null ? "&nbsp" : rs.getString("year");
					       String num = rs.getString("num") == null ? "&nbsp" : rs.getString("num");
					       String title = rs.getString("title") == null ? "&nbsp" : rs.getString("title");
					   	   String leadername = rs.getString("leadername") == null ? "&nbsp" : rs.getString("leadername");
						   Date qftime = rs.getDate("qftime");
						   String source = rs.getString("source") == null ? "&nbsp" : rs.getString("source");
						  

							SimpleORMUtils instance=SimpleORMUtils.getInstance();
						    List<Map<String,Object>> countlist=instance.queryForMap("select count(*) as count from zwdb zpg where zpg.docunid=? ",unid);
						    Object count="";
						    if(countlist.size()!=0){
						   		Map<String,Object> map =countlist.get(0);
						   		count=map.get("count")==null?"0":map.get("count");
						   	}
						   	List<Map<String,Object>> tjlist=instance.queryForMap("select qfman from zwdb zpg where zpg.docunid=? ",unid);
						    int bj=0;
						    int fbj=0;
						    if(tjlist.size()!=0){
						        Object qfman="";
						    	for(int j=0;j<tjlist.size();j++){
							   		Map<String,Object> map=tjlist.get(j);
							   		qfman=map.get("qfman")==null?"0":map.get("qfman");
							   		if(qfman.equals("办结")){
							   			bj++;
							   		}else{
							   			fbj++;
							   		}
						   		}
						   	}

							String dbk="";
							if (aclManager.isOwnerRole(userId, "dbk")||aclManager.isOwnerRole(userId,"msk")){
									dbk="<div style=\"display:none;\" class=\"MM_over_psj\"><a href=\""+request.getContextPath()+"/edit?xmlName=zwdbhyfk&appId="+unid+"&lf=1\">编辑</a></div>";
							}

					       buffer.append("<td align=center width=\"8%\">"+leadername+"</td><td align=center width=\"20%\">"+title+""+dbk+"</td><td align=center width=\"8%\">"+qftime+"</td><td align=center width=\"8%\">"+source+"</td><td align=center width=\"8%\">督办件数:"+count+"<br/><br/>已办结数:"+bj+"<br/><br/>未办结数:"+fbj+"</td><td  align=center width=\"8%\"><input type=\"button\" class=\"viewlistZ_h_button\" onmousemove=\"this.className='viewlistZ_h_buttons'\" onmouseout=\"this.className='viewlistZ_h_button'\"  value=\"单位反馈情况\" onclick=\"javascript:window.location.href='"+request.getContextPath()+"/view?xmlName=zwdbhyfk&appId="+unid+"&lf=1';\"><br/><br/><input type=\"button\" class=\"viewlistZ_h_button\" onmousemove=\"this.className='viewlistZ_h_buttons'\" onmouseout=\"this.className='viewlistZ_h_button'\"  value=\"查看明细\" onclick=\"javascript:window.location.href='"+request.getContextPath()+"/zwdbfk/hyindex.jsp?&appId="+unid+"';\"></td>");

					       //加入数据链接-结束
					       buffer.append("</tr>");
					       rs.next();
				           }
			               }
						   if (maxRow - rowIdx < rowsPerPage) {
				           for (int m = maxRow - rowIdx; m < rowsPerPage; m++) {
					       buffer.append("<tr class=\"" + (m % 2 != 0 ? "yuan" : "wang") + "\">");
					       //加入补足空行-开始
					       buffer.append("<td align=center width=\"8%\">&nbsp;</td><td align=center width=\"8%\">&nbsp;</td><td align=center width=\"8%\">&nbsp;</td><td align=center width=\"8%\">&nbsp;</td><td align=center width=\"8%\">&nbsp;</td><td align=center width=\"8%\">&nbsp;</td>");
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
		</script>
 		<script src="../zwdbfk/js/jquery-1.8.2.min.js" type="text/javascript"></script>
		<script src="../zwdbfk/js/tabScript.js" type="text/javascript"></script>
		<script>
			$(function(){
				loadTab();
			});
		</script>
		<style type="text/css">
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
		.searchview_gai{
			position: absolute;
			right: 4px;
			/* margin-top: 15px; */
			font-size: 13px;
		}
		.searchview_gai form{
			margin: 0px;
		}
		.wcoa_dcb_tabs_content{
			width: 100%;
			display: block;
			clear: both;
			padding-top: 30px;
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
		.tjhbutton {
			font-family: "tahoma", "宋体";
			font-size: 12px; 
			color: #3D9CDE;
			border: 1px #93bee2 solid;
			border-bottom: #93bee2 1px solid;
			border-left: #93bee2 1px solid;
			border-right: #93bee2 1px solid;
			border-top: #93bee2 1px solid;
			background-image:url(../images/index_button_3.jpg);
			background-color: #ffffff;
			cursor: pointer;
			font-style: normal ;
			height:25px;
			width:60px;
		}
		</style>
		<script>
			function exportxls(statue){
        		window.location.href ="<%=request.getContextPath()%>/zwdbfk/index.jsp?statue="+statue;
    		}
    		function daochu(statue){
    			window.location.href ="<%=request.getContextPath()%>/zwdbfk/searchtongji.jsp?statue=<%=statue%>&sendtime_first=<%=sendtime_first%>&sendtime_last=<%=sendtime_last%>";
    		}
		</script>
		<table border="0" align="center" cellpadding="0" cellspacing="0" class="round">
			<tr>
			<td align="center">
				<table class="searchview">
				<form id='form1' onsubmit="this.action=window.location.href.substring(0,window.location.href.indexOf('?'));" action="" method="post">
				<tr bgcolor="#ffffff">
					<td width=250px align=center >
						<html:text name="sendtime_first" readonly="true" style="width:100px;" value="<%=sendtime_first%>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'});"/>至
                        <html:text name="sendtime_last" readonly="true" style="width:100px;" value="<%=sendtime_last%>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'});"/>	
                    </td>   						
				</tr>
				<tr bgcolor="#ffffff">
					<td colspan=5 align=center>
						<input type="submit" class="searchbutton" value="查询" />
						<input type="reset" class="searchbutton" value="重置" />
					</td>
				</tr>
				</form>
			  </table>
			  </br></br>
			  <%=buffer.toString()%> 
		    </td>
			</tr>
		</table>
	</template:put>
</template:insert><!--索思奇智版权所有-->