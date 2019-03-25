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
	<template:put name='title' content='批示件督办' direct='true'/>
	<%String str = "<a class=\"menucur\" href=\"\">批示件督办</a>"; %>
	<template:put name='moduleNav' content='<%=str%>' direct='true'/>
	<template:put name='content'>
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/layer/layer.js" ></script>
		<script>
		function MM_over(mmObj) {
			var mSubObj = mmObj.getElementsByTagName("div")[0];
			mSubObj.style.display = "block";
		}
		function MM_out(mmObj) {
			var mSubObj = mmObj.getElementsByTagName("div")[0];
			mSubObj.style.display = "none";
			
		}
		<%-- function dxcb(unid){
            var ret_val;//接受返回值
		    //var strReturn;//返回值处理后存的变量
		    var url="<%=request.getContextPath()%>/zwdbfk/dxcb.jsp?unid="+unid;
		    var sFeatures = "dialogHeight: 450px; dialogWidth: 700px; center: Yes; help: No; resizable: No; status: No;toolbar: No;menubar:No;";
		    ret_val = window.showModalDialog (url,"",sFeatures);
		} --%>
		function dxcb(unid){
			layer.open({
				type: 2,
				title: '',
				fix: true,
				maxmin: false,
				area: ['772px', '420px'],
				content: '<%=request.getContextPath()%>/zwdbfk/dxcb.jsp?unid='+unid,
				offset: '100px'
			});
		}
		function ddcb(unid){
			layer.open({
				type: 2,
				title: '',
				fix: true,
				maxmin: false,
				area: ['772px', '420px'],
				content: '<%=request.getContextPath()%>/zwdbfk/ddcb.jsp?unid='+unid,
				offset: '100px'
			});
		}
		function fwh(unid) {	
		    var ret_val;//接受返回值
		    //var strReturn;//返回值处理后存的变量
		    var url="<%=request.getContextPath()%>/zwdbfk/fwh.jsp?unid="+unid;
		    var sFeatures = "dialogHeight: 250px; dialogWidth: 450px; center: Yes; help: No; resizable: No; status: No;toolbar: No;menubar:No;";
		    ret_val = window.showModalDialog (url,"",sFeatures);
		    if(ret_val==1){
		        window.location.href=window.location.href;
		    }
		}
		function daochu(statue){
    		window.location.href ="<%=request.getContextPath()%>/zwdbfk/searchtongji.jsp?";
		}

		</script>
 		<script src="../zwdbfk/js/jquery-1.8.2.min.js" type="text/javascript"></script>
		<script src="../zwdbfk/js/tabScript.js" type="text/javascript"></script>
		<script src="../zwdbfk/js/zwdb.js" type="text/javascript"></script>
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
		.viewlist th{
			font-size: 13px !important;
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
		.next_sxy{
			margin: 17px 0px;
			float: right;
		}
		.next_sxy a {
			background-color: #E6E6E6;
			padding: 5px;
			margin-right: 5px;
		}
		.next_sxy a:hover{
			background-color: #DEDADA;
		}
		.but_a {
			background-color: #038EDF !important;
			color: white;
			padding: 5px 10px !important;
			border: none;
			cursor: pointer;
			margin-left: 10px;
			outline: none;
		}
		.but_a:hover{
			background-color: #036FDF !important;
			color: white;
		}
		a {
		    cursor: pointer;
		    color: #999;
		    text-decoration: none;
		    background: transparent;
		    outline: none;
		    blr: expression(this.onFocus=this.blur());
		    text-decoration: none !important;
    		outline: none !important;
		}
		</style>
			<div class="round_twos">
				<form id='form1' onsubmit="this.action=window.location.href.substring(0,window.location.href.indexOf('?'));" action="" method="post">
					<div class="the_query_deriveddivboxs">
					<div class="the_query_deriveddiv">
							部署时间:
							<html:text name="sendtime_first" readonly="true" style="width:80px;" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'});"/>至
							<html:text name="sendtime_last" readonly="true" style="width:80px;"  onclick="WdatePicker({dateFmt:'yyyy-MM-dd'});"/>&nbsp;
							办件状态:
	                        <html:select name = "banjie"   style="width:70px">
	                        	<html:option value = "">请选择</html:option>
	                            <html:option value = "已办结">已办结</html:option>
	                            <html:option value = "未办结">未办结</html:option>
	                   		</html:select>&nbsp;&nbsp;
	                   		永批督（
							<html:text name="year"  style="width:40px;" />）
							<html:text name="num" style="width:40px;" />号
					</div>
					<div class="searchview_gai">
						<input type="button" class="tjhbutton" onclick="loadSXData('1');javascript:void(0)" value="所有督办件">
						<input type="button"  onclick="loadSXData('5');javascript:void(0)" value="未赋号件">
						<input type="button"  onclick="loadSXData('');javascript:void(0)" class="tjhbutton" value="查询" />
						<input type="button" class="tjhbutton" onclick="daochu();" value="导出" />
			 		</div>
					</div>
			 	</form>	
				<div class="wcoa_dcb_tabs_content">
					<table  id="sxlist" class="viewlist viewlistZ_h">
					</table>	
					<div class="next_sxy"><a href="javascript:void(0);" onclick="loadSXData('first');" class="but_a">首页</a> <a href="javascript:void(0);" onclick="loadSXData('up');" style="color:black;">上一页</a> <a href="javascript:void(0);" onclick="loadSXData('next');" style="color:black;" >下一页</a> 共<span id="allRecord"></span>条记录<span id="allPage"></span>页 转到<select id="jumpPage" style="width:50px" ></select>页<input type="button" class="but_a" value="跳转"  onclick="loadSXData('jump');" /></div>
				</div>
			</div>
	</template:put>
</template:insert><!--索思奇智版权所有-->