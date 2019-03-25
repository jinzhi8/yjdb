<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.commons.db.ConnectionProvider" %>
<%@page import="com.kizsoft.commons.commons.config.SystemConfig" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="java.sql.Connection" %>
<%@page import="java.sql.PreparedStatement" %>
<%@page import="java.sql.ResultSet" %>
<%@page import="java.util.Vector" %>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>

<jsp:useBean id="ManageTemplateBean" class="com.kizsoft.oa.personal.ManageTemplate"></jsp:useBean>
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
	String userflag = (String) session.getAttribute("userFlag");
	String templatename = (String) session.getAttribute("templatename");
	if (templatename == null) {
		templatename = "cn";
	}
	%>
	<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title></title>
	<link href="<%=contextPath%>/resources/template/<%=templatename%>/css/css.css" rel="stylesheet" type="text/css">
	<script language="javascript" type="text/javascript" charset="utf-8" src="<%=contextPath%>/resources/js/jquery/jquery.js"></script>
	<style type="text/css">
		<!--
		html {
			overflow-x: hidden;
			scrollbar-base-color: #d6e4ef;
		}

		-->
	</style>
	<script type="text/javascript" language="javascript"> 
		function doIframe(){
			o = document.getElementsByTagName('iframe');
			for(i=0;i<o.length;i++){
				if (/\bautoHeight\b/.test(o[i].className)){
					setHeight(o[i]);
					addEvent(o[i],'load', doIframe);
				}
			}
		}

		function setHeight(e){
			if(e.contentDocument){
				$(e).animate({
					height:e.contentDocument.body.offsetHeight + 35
				});
				//e.height = e.contentDocument.body.offsetHeight + 35;
			} else {
				$(e).animate({
					height:e.contentWindow.document.body.scrollHeight 
				});
				//e.height = e.contentWindow.document.body.scrollHeight;
			}
		}

		function addEvent(obj, evType, fn){
			if(obj.addEventListener)
			{
				obj.addEventListener(evType, fn,false);
				return true;
			} else if (obj.attachEvent){
				var r = obj.attachEvent("on"+evType, fn);
				return r;
			} else {
				return false;
			}
		}

		if (document.getElementById && document.createTextNode){
			addEvent(window,'load', doIframe);	
		}
	</script>
	<style type="text/css">
		.titlestyle{
			color: #153e50;
			font-family: "microsoft yahei";
			font-size: 17px;
			padding-right: 0px !important;
			padding-left: 6px;
			border-left: 6px solid #037cda;
			font-weight: normal;
		}
	</style> 
</head>
<body style="margin: 8px 0px 0px 0px;">
<%!
	String getFuncHTML(String contextPath, String id, String wid, String templatename, String layouttype, String username, String topicname, String topicurl, String align, String userflag) {
		String titlepic = "title_61.gif";
		String hid = "28";
		String ihid = "40";
		String newWindow = "";
		//高度控制 ihid
		if (id.indexOf("arrange") > 0) //个人日程安排
		{
			hid = "340";
			ihid = "400";
		}
		if (id.indexOf("kqm") > 0) //人员考勤
		{
			hid = "28";
			ihid = "30";
		}
		if (id.indexOf("email") > 0) //电子邮件
		{
			hid = "28";
			ihid = "30";
			newWindow = "";
		}
		if (id.indexOf("databank") > 0) //公共资料库
		{
			hid = "28";
			ihid = "180";
		}
		try {
			topicurl = org.apache.commons.lang.StringUtils.replace(topicurl, "{_username_}", username);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		if (topicurl.indexOf("?") > 0) {
			topicurl = topicurl + "&lign=" + align;
		} else {
			topicurl = topicurl + "?lign=" + align;
		}

		if (align.equals("left")) {
			if (id.indexOf("datalink") > 0) { //资料库链接 注释
				//return  "<table width=\'170\'  border=\'0\'><tr><td height=\'22\' width=\'35\' align=\'right\'><img src=\'resources/images_wz/index_38.gif\' width=\'32\' height=\'25\'></td><td height=\'22\' background=\'resources/images_wz/index_49.gif\'  width=\'135\'>&nbsp;"+topicname+"</td></tr></table><iframe id=\'datalink\' height=\"10\" src=\""+contextPath+topicurl+"\" width=\"100%\" frameBorder=\"0\" scrolling=\"no\"></iframe>";
				return "";
			} else {
				return "<tbody><tr><td>&nbsp;&nbsp;<a style=\"color:#555555;text-decoration:none;\" href=\'" + contextPath + topicurl + "\' " + newWindow + ">" + topicname + "</a></td></tr></tbody>";
			}
		} else {
			//return "<div style='width: 98%; text-align: center'><table width='100%' border=0 align='center' cellPadding=0 cellSpacing=1 bgColor=#b0d5ee><tbody><tr height=30px><td width='100%' height='30px' align='left' valign='middle' style='background:url(images/banner_bg.jpg);background-position:bottom;' class='STYLE3'>
			return "<div style='width: 98%; text-align: center'><table width='100%' border=0 align='center' cellPadding=0 cellSpacing=1><tbody><tr height=30px><td width='100%' height='30px' align='left' valign='middle' class='STYLE3' style='padding-bottom: 10px'><span class='titlestyle'>" + topicname + "</span></td></tr><tr><td><table width='100%' border=0 align=' center' cellPadding='0' cellSpacing='0' bgColor='#ffffff'><tbody><tr height=53px><td align='left' valign='middle' bgcolor='#FFFFFF'><iframe class='autoHeight' id='" + id + "' height='" + ihid + "' src='" + contextPath + topicurl + "' width='100%' frameBorder='0' scrolling='no' onload='$(this).animate({height:$(this).contents().height()+5});'></iframe></td></tr></tbody></table></td></tr></tbody></table></div><br/>";
			
			//return "<table border='0'  width=100% height='1' cellspacing='0' cellpadding='0'  align=center><tr> <td colspan=2 height=5 bgcolor='#DDDDDD'><table border='0'  height='1' width=100% cellspacing='0' cellpadding='0' align=right background='" + contextPath + "/resources/jsp/images/pan_top.gif'><tr> <td width=1><img alt='' src='" + contextPath + "/resources/jsp/images/pan_0.gif'></td> <td >&nbsp;<b><!--标题-->" + topicname + "</b></td> <td width=1><img alt='' src='" + contextPath + "/resources/jsp/images/pan_3.gif'></td></tr></table></td></tr><tr><td style='BORDER-left: #cccccc 1px solid;BORDER-right: #cccccc 1px solid;BORDER-bottom: #cccccc 1px solid;background-color:#DDDDDD' valign=top><table border='0'  width=100% height='1' cellspacing='0' cellpadding='0'  align=center><tr> <td width=3></td> <td height=1 style='BORDER-left: #cccccc 1px solid;BORDER-right: #cccccc 1px solid;BORDER-bottom: #cccccc 1px solid;background-color:#ffffff'><table border='0'  width=100% height='1' cellspacing='0' cellpadding='0'  align=center><tr> <td height='1' bgcolor='#cccccc'></td></tr><tr> <td><!--正文--><iframe onload='if(this.contentDocument&&this.contentDocument.body.offsetHeight){this.height=this.contentDocument.body.offsetHeight;}else if(this.Document&&this.Document.body.scrollHeight){this.height=this.Document.body.scrollHeight;}\" id='" + id + "' height='" + ihid + "' src='" + contextPath + topicurl + "' width='100%' frameBorder='0' scrolling='no'></iframe></td></tr></table></td> <td width=3></td></tr><tr> <td height=3 colspan=3></td></tr></table></td></tr><tr> <td height=6></td></tr></table>";
		}
	}
%>
<%!
	boolean isFunc(String id) {
		if (id.length() > 4) {
			return id.substring(0, 4).equalsIgnoreCase("func");
		} else {
			return false;
		}
	}
%>
<% 
	//如果存在previewtemplate，则需要预览
	String tmppreview = (String) request.getParameter("previewtemplate");
	if (tmppreview != null && tmppreview.length() > 0) {
		templatename = tmppreview;
	}
	//debug
	//templatename="default";
	//查询sql得到所有文章的resultset
	//使用信息发布的数据库连接
	Connection db = null;
	PreparedStatement artstat = null;
	ResultSet rs = null;
	try {
		boolean isFinish = false;

		//取出所有定制的栏目加文章，文章需要进行控制最大条数
		db = ConnectionProvider.getConnection();
		String sql1 = "select P_CONTENT,P_LAYOUT_TYPE,P_ORDER,CAPTION,INDEXPAGE,NAME from PERSONLAYOUT p,TOPICS_FUNC f  where p.P_CONTENT=f.ID and p.P_ID=? order by P_LAYOUT_TYPE,P_ORDER";
		artstat = db.prepareStatement(sql1);
		artstat.setString(1, userID);

		rs = artstat.executeQuery();
		boolean havedata = rs.next();
		if (!havedata) {
			ConnectionProvider.close(null, artstat, rs);
			if (!"0".equals(userflag)) {
				userflag = "1";
			}
			sql1 = "select P_CONTENT,P_LAYOUT_TYPE,P_ORDER,CAPTION,INDEXPAGE,NAME from PERSONDEFAULTLAYOUT p,TOPICS_FUNC f  where p.P_CONTENT=f.ID and p.P_DEPFLAG='" + userflag + "' order by P_LAYOUT_TYPE,P_ORDER";
			artstat = db.prepareStatement(sql1);
			rs = artstat.executeQuery();
			havedata = rs.next();
			if (!havedata) {
				ConnectionProvider.close(null, artstat, rs);
				sql1 = "select P_CONTENT,P_LAYOUT_TYPE,P_ORDER,CAPTION,INDEXPAGE,NAME from PERSONDEFAULTLAYOUT p,TOPICS_FUNC f  where p.P_CONTENT=f.ID and p.P_DEPFLAG is null order by P_LAYOUT_TYPE,P_ORDER";
				artstat = db.prepareStatement(sql1);
				rs = artstat.executeQuery();
				havedata = rs.next();
			}
		}
		//存放左中右三个id
		Vector leftdivs = new Vector();
		Vector middivs = new Vector();
		Vector rightdivs = new Vector();
		//序号左中右三个
		Vector leftorderdivs = new Vector();
		Vector midorderdivs = new Vector();
		Vector rightorderdivs = new Vector();%>
<% //如果什么数据都没有就显示一条信息
	if (!havedata) {%>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="my_home">
	<tr>
		<td align="center" class="little_text_0">
		<div style='width: 98%; text-align: center'><table width='100%' border=0 align='center' cellPadding=0 cellSpacing=1 bgColor=#b0d5ee><tbody><tr height=23px><td width='103px' height='30px' align='left' valign='middle' style='background:url(images/banner_bg.jpg);' class='STYLE3'><span class='titlestyle' style='color:orangered;bold-style:bold;'>◇待办事宜</span></td></tr><tr><td><table width='100%' border=0 align=' center' cellPadding='0' cellSpacing='0' bgColor='#ffffff'><tbody><tr height=53px><td align='left' valign='middle' bgcolor='#FFFFFF'><iframe class='autoHeight' id='func_affair_undo' height='40' src='<%=contextPath%>/personalize/showcontent.jsp?format=desk_affair_undo' width='100%' frameBorder='0' scrolling='no' onload='$(this).animate({height:$(this).contents().height()+5});'></iframe></td></tr></tbody></table></td></tr></tbody></table></div><br/>
		<div style='width: 98%; text-align: center'><table width='100%' border=0 align='center' cellPadding=0 cellSpacing=1 bgColor=#b0d5ee><tbody><tr height=23px><td width='103px' height='30px' align='left' valign='middle' style='background:url(images/banner_bg.jpg);' class='STYLE3'><span class='titlestyle' style='color:orangered;bold-style:bold;'>◇已办事宜</span></td></tr><tr><td><table width='100%' border=0 align=' center' cellPadding='0' cellSpacing='0' bgColor='#ffffff'><tbody><tr height=53px><td align='left' valign='middle' bgcolor='#FFFFFF'><iframe class='autoHeight' id='func_affair_doone' height='40' src='<%=contextPath%>/personalize/showcontent.jsp?format=desk_affair_done' width='100%' frameBorder='0' scrolling='no' onload='$(this).animate({height:$(this).contents().height()+5});'></iframe></td></tr></tbody></table></td></tr></tbody></table></div><br/>
		</td>
	</tr>
</table>
<% } else {
	java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy'年'MM'月'dd'日'");
	java.util.Date d = new java.util.Date(System.currentTimeMillis());
	String dstr = df.format(d);
	String leftshowstr = "";
	String middleshowstr = "";
	String rightshowstr = "";%>
<% //左栏标题
	String topicid, topicname, topicurl, p_order;
	int layouttype;
	isFinish = false;
	//如果有数据
	if (havedata) {
		do {
			//ID
			topicid = rs.getString("P_CONTENT");
			//序号
			p_order = rs.getString("P_ORDER");
			//栏目名称，用来显示
			topicname = rs.getString("NAME"); //  CAPTION
			//栏目类型，保持左栏
			layouttype = rs.getInt("P_LAYOUT_TYPE");
			//栏目首页url
			topicurl = rs.getString("INDEXPAGE");

			if (layouttype == 0) {
				//左栏并且是一栏的开始
				leftdivs.add("div_" + topicid);
				leftorderdivs.add(p_order);
				//是否功能栏目
				if (isFunc(topicid)) {
					//out.print(getFuncHTML(contextPath,topicid,"185",templatename,"0",usernameen,topicname,topicurl,"left",userflag));
					leftshowstr += getFuncHTML(contextPath, topicid, "185", templatename, "0", usernameen, topicname, topicurl, "left", userflag);
					havedata = rs.next();
				} else {
					havedata = rs.next();
				}
			} else {
				//左栏结束了
				isFinish = true;
			}
		} while (havedata && !isFinish);
	}
	//中栏标题
	isFinish = false;
	//如果有数据
	if (havedata) {
		do {
			//ID
			topicid = rs.getString("P_CONTENT");
			//序号
			p_order = rs.getString("P_ORDER");
			//栏目名称，用来显示
			topicname = rs.getString("CAPTION");
			//栏目类型，保持左栏
			layouttype = rs.getInt("P_LAYOUT_TYPE");
			//栏目首页url
			topicurl = rs.getString("INDEXPAGE");

			if (layouttype == 1) {
				//中栏
				middivs.add("div_" + topicid);
				midorderdivs.add(p_order);

				//是否功能栏目
				if (isFunc(topicid)) {
					//out.print(getFuncHTML(contextPath,topicid,"375",templatename,"1",usernameen,topicname,topicurl,"middle",userflag));
					middleshowstr += getFuncHTML(contextPath, topicid, "375", templatename, "1", usernameen, topicname, topicurl, "middle", userflag);
					havedata = rs.next();
				} else {
					havedata = rs.next();
				}
			} else {
				//中栏结束了
				isFinish = true;
			}
		} while (havedata && !isFinish);
	}
	//右栏标题
	isFinish = false;
	//如果有数据
	if (havedata) {
		do {
			//ID
			topicid = rs.getString("P_CONTENT");
			//序号
			p_order = rs.getString("P_ORDER");
			//栏目名称，用来显示
			topicname = rs.getString("NAME"); //CAPTION
			//栏目类型，保持左栏
			layouttype = rs.getInt("P_LAYOUT_TYPE");
			//栏目首页url
			topicurl = rs.getString("INDEXPAGE");

			if (layouttype == 2) {
				//右栏
				rightdivs.add("div_" + topicid);
				rightorderdivs.add(p_order);

				//是否功能栏目
				if (isFunc(topicid)) {
					//out.print(getFuncHTML(contextPath,topicid,"578",templatename,"2",usernameen,topicname,topicurl,"right",userflag));
					rightshowstr += getFuncHTML(contextPath, topicid, "578", templatename, "2", usernameen, topicname, topicurl, "right", userflag);
					havedata = rs.next();
				} else {
					havedata = rs.next();
				}
			} else {
				//右栏结束了
				isFinish = true;
			}
		} while (havedata && !isFinish);
	}%>
<table width="100%" height="100%" align="center">
<tbody>
	<tr>
		<td align="center" valign="top"><!--中间区域开始--> <%=rightshowstr%> <!--中间区域结束-->
		</td>
		<!--右侧信息开始-->
	</tr>
</tbody>
</table>
<script>
</script>
<% }
} catch (Exception ee) {
	ee.printStackTrace();
} finally {
	ConnectionProvider.close(db, artstat, rs);
}%>
</body>
</html>
<!--索思奇智版权所有-->