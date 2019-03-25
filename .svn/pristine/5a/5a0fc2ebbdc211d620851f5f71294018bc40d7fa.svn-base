<!-- saved from url=(0014)about:internet -->
<%@page import="com.kizsoft.commons.acl.ACLManager" %>
<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.acl.ACLManagerFactory" %>
<%@page import="com.kizsoft.commons.commons.db.ConnectionProvider" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleManager" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleMenu" %>
<%@page import="java.sql.Connection" %>
<%@page import="java.sql.PreparedStatement" %>
<%@page import="java.sql.ResultSet" %>
<%@page import="java.util.ArrayList" %>
<%@page import="java.util.Vector" %>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<% //用户登陆验证
	if (session.getAttribute("userInfo") == null) {
		//response.sendRedirect(request.getContextPath()+"/login.jsp");
		response.sendRedirect(request.getContextPath() + "/login.jsp");
	}
	User userInfo = (User) session.getAttribute("userInfo");
	String userID = userInfo.getUserId();
	String usernameen = userInfo.getAccount();
	Group groupInfo = userInfo.getGroup();
	String userName = userInfo.getUsername();
	String udepartment = groupInfo.getGroupname();

	String userflag = "";
	if (session.getAttribute("userFlag") != null) {
		userflag = (String) session.getAttribute("userFlag");
	}
	String contextPath = request.getContextPath();%>

<LINK REL="stylesheet" TYPE="text/css" HREF="<%=request.getContextPath()%>/resources/css/iaddress.css"/>

<LINK href="<%=request.getContextPath()%>/resources/css/css.css" rel=stylesheet type=text/css>
<LINK href="<%=request.getContextPath()%>/resources/css/cssstyle.css" rel=stylesheet type=text/css>
<link href="<%=request.getContextPath()%>/resources/theme/script/css.css" rel="stylesheet" type="text/css">

<style>
	body {

		background-color: ffffff;
		scrollbar-face-color: #D4D0C8;
		scrollbar-3dlight-color: #f7f7f7;
		scrollbar-highlight-color: #D4D0C8;
		scrollbar-shadow-color: #D4D0C8;
		scrollbar-darkshadow-color: #393939;
		scrollbar-arrow-color: #444444;
		scrollbar-track-color: #F7F7F7
	}

	td {
		font-size: 9pt;
		color: 000000;
	}

	.zong, a.zong:visited, a.zong:link, a.zong:active {
		COLOR: #A18553;
		TEXT-DECORATION: none
	}

	A.zong:hover {
		COLOR: #ADB306;
		TEXT-DECORATION: none
	}

	.hui, A.hui:visited, a.hui:link, a.hui:active {
		COLOR: #666666;
		TEXT-DECORATION: none
	}

	A.hui:hover {
		COLOR: #0033cc;
		TEXT-DECORATION: none
	}

	.hei, A.hei:visited, a.hei:link, a.hei:active {
		COLOR: #000000;
		TEXT-DECORATION: none
	}

	A.hei:hover {
		COLOR: #ff0000;
		TEXT-DECORATION: none
	}

	.lan, A.lan:visited, a.lan:link, a.lan:active {
		COLOR: #0077CC;
		TEXT-DECORATION: none
	}

	A.lan:hover {
		COLOR: #ff0000;
	}

	.org, A.org:visited, a.org:link, a.org:active {
		COLOR: #81750F;
		TEXT-DECORATION: none
	}

	A.org:hover {
		COLOR: #AE0000;
	}

	.bai, A.bai:visited, a.bai:link, a.bai:active {
		COLOR: #ffffff;
		TEXT-DECORATION: none
	}

	A.bai:hover {
		COLOR: #ffff00;
	}

	.menu {
		width: 16pt;
		font-size: 9pt;
		color: 000000;
		line-height: 12pt;
		cursor: hand;
		background-image: url(images/menubg.gif);
	}

	.menuout {
		width: 16pt;
		align: center;
		font-size: 9pt;
		color: 333333;
		line-height: 12pt;
		cursor: hand;
		background-image: url(images/menubg_out.gif);
	}

	.menuarea_over {
		BORDER: #F2B957 1px solid;
		line-height: 15pt;
		cursor: hand;
		background-color: #F5FEA3
	}

	.menuarea {
		BORDER: #ffffff 1px solid;
		line-height: 15pt;
		cursor: hand;
	}

	.tool {
		BORDER-top: #B9B9B9 1px solid;
		BORDER-left: #B9B9B9 1px solid;
		BORDER-right: #B9B9B9 1px solid;
		line-height: 15pt;
		cursor: hand;
		background-color: #ffffff
	}

	.input {
		FONT-WEIGHT: bold;
		height: 20px;
		width: 88px;
		background-image: url(images/input.gif);
		BORDER: #344C9D 0px solid;
		font-size: 9pt;
		color: 000000;
	}

	.input_s {
		FONT-WEIGHT: bold;
		height: 20px;
		width: 55px;
		background-image: url(images/input_s.gif);
		BORDER: #344C9D 0px solid;
		font-size: 9pt;
		color: 000000;
	}
</style>
<script type="text/javascript">
	var iframeids = ["func_docExchange","func_depinfo2","func_file_no","func_file_end","func_sendfile_end","func_getfile_end","func_supernotice","func_handleslist","func_file","func_affair","func_dyfile","func_bulletin","func_adlink","func_sendfile","func_sendfile_dy","func_jyta","func_filebase","datalink","func_sharebase"];//如果用户的浏览器不支持iframe是否将iframe隐藏 yes 表示隐藏，no表示不隐藏
	var iframehide = "yes"

	function dyniframesize() {
		var dyniframe = new Array()
		for (i = 0; i < iframeids.length; i++) {
			if (document.getElementById) {
				//自动调整iframe高度
				dyniframe[dyniframe.length] = document.getElementById(iframeids[i]);
				if (dyniframe[i] && !window.opera) {
					dyniframe[i].style.display = "block"
					if (dyniframe[i].contentDocument && dyniframe[i].contentDocument.body.offsetHeight) //如果用户的浏览器是NetScape
						dyniframe[i].height = dyniframe[i].contentDocument.body.offsetHeight; else if (dyniframe[i].Document && dyniframe[i].Document.body.scrollHeight) //如果用户的浏览器是IE
						dyniframe[i].height = dyniframe[i].Document.body.scrollHeight;
				}
			}
			//根据设定的参数来处理不支持iframe的浏览器的显示问题
			if ((document.all || document.getElementById) && iframehide == "no") {
				var tempobj = document.all ? document.all[iframeids[i]] : document.getElementById(iframeids[i])
				tempobj.style.display = "block"
			}
		}
	}

	if (window.addEventListener)
		window.addEventListener("load", dyniframesize, false) else if (window.attachEvent)
		window.attachEvent("onload", dyniframesize) else
		window.onload = dyniframesize
</script>
<script type="text/JavaScript">
	<!--

	function MM_preloadImages() { //v3.0
		var d = document;
		if (d.images) {
			if (!d.MM_p) d.MM_p = new Array();
			var i,j = d.MM_p.length,a = MM_preloadImages.arguments;
			for (i = 0; i < a.length; i++)
				if (a[i].indexOf("#") != 0) {
					d.MM_p[j] = new Image;
					d.MM_p[j++].src = a[i];
				}
		}
	}//-->
</script>
<style type="text/css">
	<!--
	a:link {
		text-decoration: none;
	}

	a:visited {
		text-decoration: none;
	}

	a:hover {
		text-decoration: none;
	}

	a:active {
		text-decoration: none;
	}

	-->
</style>
<head>
	<title>
		<template:get name='title'/>
	</title>

</head>

<%String SESSION_TEMPLATENAME = "templatename";
	String templatename = (String) session.getAttribute(SESSION_TEMPLATENAME);%>
<%!//根据id获取模块输出
String getFuncHTML(String id, String wid, String templatename, String layouttype, String username, String topicname, String topicurl, String align, String userflag) {
	String titlepic = "title_61.gif";
	String hid = "28";
	String ihid = "1";
	String newWindow = "";
	//高度控制 ihid
	if (id.indexOf("arrange") > 0)  //个人日程安排
	{
		hid = "340";
		ihid = "400";
	}
	if (id.indexOf("kqm") > 0)  //人员考勤
	{
		hid = "28";
		ihid = "30";
	}
	if (id.indexOf("email") > 0)  //电子邮件
	{
		hid = "28";
		ihid = "30";
		newWindow = "";
	}
	if (id.indexOf("databank") > 0)  //公共资料库
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
			//return  "<table width=\'170\'  border=\'0\'><tr><td height=\'22\' width=\'35\' align=\'right\'><img src=\'resources/images_wz/index_38.gif\' width=\'32\' height=\'25\'></td><td height=\'22\' background=\'resources/images_wz/index_49.gif\'  width=\'135\'>&nbsp;"+topicname+"</td></tr></table><iframe id=\'datalink\' height=\"10\" src=\""+topicurl+"\" width=\"100%\" frameBorder=\"0\" scrolling=\"no\"></iframe>";
			return "<tr><td align=\"left\" valign=\"middle\"><a href=\"" + topicurl + "\"" + newWindow + " border=\"0\"  class=\"ziti\">" + topicname + "</a></td></tr>";
		} else {
			return "<tr><td align=\"left\" valign=\"middle\"><a href=\"" + topicurl + "\"" + newWindow + " border=\"0\"  class=\"ziti\">" + topicname + "</a></td></tr>";
		}
	} else {
		return "<tr><td valign=\"top\" height=\"1\"><table border=\"0\"  width=\"631\" height=1 cellspacing=\"0\" cellpadding=\"0\"  align=center><tr><td colspan=2 height=1 background=../resources/theme/images/pan_top.gif valign=\"top\"><table border=\"0\"  height=1 width=100% cellspacing=\"0\" cellpadding=\"0\" align=right background=img/pan_top.gif><tr><td width=1 valign=\"top\"><img src=img/pan_0.gif></td><td width=\'\'><span class=\"ziti \">" + topicname + "</span></td><td width=1 valign=\"top\"><img src=img/pan_3.gif></td></tr></table></td></tr><tr><td style=\"BORDER-left: #cccccc 1px solid;BORDER-right: #cccccc 1px solid;BORDER-bottom: #cccccc 1px solid;background-color:DDDDDD\" valign=top><table border=\"0\"  width=100% height=1 cellspacing=\"0\" cellpadding=\"0\"  align=center><tr><td height=100 style=\"BORDER-left: #cccccc 1px solid;BORDER-right: #cccccc 1px solid;BORDER-bottom: #cccccc 1px solid;background-color:#ffffff\"><table border=\"0\"  width=100% height=1 cellspacing=\"0\" cellpadding=\"0\"  align=center><tr><td height=1 valign=top><table border=\"0\"  width=100% height=1 cellspacing=\"0\" cellpadding=\"5\"  align=center><tr><td><iframe id=\"" + id + "\" height=\"" + ihid + "\" src=\"" + topicurl + "\" width=\"100%\" frameBorder=\"0\" scrolling=\"no\"></iframe></td></tr></table></td></tr></table></td></tr></table></td></tr></table></td></tr>";
		// <a href=\"javascript:deletelayout('"+id+"');\"><img src=\"personalize/theme/"+templatename+"/icon_03.gif\" width=17 height=17 hspace=2 border=0  TITLE=\"不显示栏目\"></a> //删除按钮
	}
}%>
<%!//判断是不是自定义模块
boolean isFunc(String id) {
	if (id.length() > 4) {
		return id.substring(0, 4).equalsIgnoreCase("func");
	} else {
		return false;
	}
}%>
<% if (templatename == null || templatename.length() <= 0) {
	templatename = "default";
}

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

	boolean isFinish = false;
	boolean havedata = false;

	try {
		//取出所有定制的栏目加文章，文章需要进行控制最大条数
		db = ConnectionProvider.getConnection();
		String sql1 = "select P_CONTENT,P_LAYOUT_TYPE,P_ORDER,CAPTION,INDEXPAGE,NAME from PERSONLAYOUT p,TOPICS_FUNC f  where p.P_CONTENT=f.ID and p.P_ID=? order by P_LAYOUT_TYPE,P_ORDER";
		artstat = db.prepareStatement(sql1);
		artstat.setString(1, userID);

		rs = artstat.executeQuery();
		havedata = rs.next();
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
		}%>

<body topmargin="0" leftmargin="0">
<br>
<table cellpadding="0" cellspacing="0" width="996" align="center" style="BORDER-left: #cccccc 4px solid;BORDER-right: #cccccc 4px solid;BORDER-bottom: #cccccc 4px solid;BORDER-top: #cccccc 4px solid;background-color:DDDDDD" background="<%=request.getContextPath()%>/resources/theme/images/yj.jpg">
<tr>
<td>
<table border="0" width="996" height=1 cellspacing="0" cellpadding="0" align=center>
	<tr bgcolor="#FFFFFF">
		<td align="left" valign="baseline">&nbsp;
			<script LANGUAGE="JavaScript">
				function initArray() {
					this.length = initArray.arguments.length
					for (var i = 0; i < this.length; i++)
						this[i + 1] = initArray.arguments[i]
				}
				var WeekArray = new initArray("星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六");
				var MonthArray = new initArray("1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月");
				var LastModDate = new Date(document.lastModified);
				document.write(LastModDate.getYear() + "年");
				document.write(MonthArray[(LastModDate.getMonth() + 1)]);
				document.write(LastModDate.getDate() + "日 ");
				document.write(WeekArray[(LastModDate.getDay() + 1)]);
			</script>
		</td>
		<td align="left" height="1" valign="baseline">
			<div align="left">
				<img src="<%=request.getContextPath()%>/resources/theme/images/bgpt_dqwz_icon.gif" height="12">您当前的位置：
				<script language="javascript" src="<%=request.getContextPath()%>/resources/js/homepage.js"></script>
				<a class="menucur" href="<%=request.getContextPath ()%>/desktop.jsp">首页</a> →
				<template:get name="moduleNav"/>
			</div>
		</td>
		<td align="right" valign="baseline">
			<div align="right">

				<img src="<%=request.getContextPath()%>/resources/theme/images/bgpt_menu_icon4.gif" width="20" height="22">
				<a href="<%=request.getContextPath()%>/logout.jsp"><font color="#000000">退出系统</font></a>
				　<img src="<%=request.getContextPath()%>/resources/theme/images/bgpt_menu_icon5.gif" width="27" height="22">
				<a href="<%=request.getContextPath()%>/share/index.jsp"><font color="#000000">帮助</font></a>

			</div>
		</td>
	</tr>
</table>


<table border="0" width=996 height="1" cellspacing="0" cellpadding="0" align=center>
	<tr>
		<td height=3></td>
	</tr>
	<tr>
		<td width="5"></td>
		<td width="156" valign=top align=center>
			<table border="0" width="156" height=1 cellspacing="0" cellpadding="0" align=center>
				<tr>
					<td height=24 background="<%=request.getContextPath()%>/img/men1.gif" align=center width="100%">
						<b><%=udepartment%>：<%=userName%>
						</b></td>
				</tr>
				<tr>
					<td height=5></td>
				</tr>
				<tr>
					<td height=5></td>
				</tr>
				<tr>
					<td height=23 background="<%=request.getContextPath()%>/img/tool_top1.gif" width="159"><b>&nbsp;应用模块导航
					</td>
				</tr>
				<tr>
					<td height=280 class=tool align=left valign="top" width="140">
						<table width="178" align="center">
							<% ModuleManager moduleManager = new ModuleManager();
								ACLManager aclManager = ACLManagerFactory.getACLManager();
								ArrayList menuList = (ArrayList) moduleManager.getUserMenuInfoList(userID);
								for (int i = 0; i < menuList.size(); i++) {
									ModuleMenu moduleMenu = (ModuleMenu) menuList.get(i);
									String menuName = moduleMenu.getMenuName();
									String menuLink = moduleMenu.getMenuLink();%>
							<tr>
								<td width="159" align="left" background="<%=request.getContextPath()%>/resources/images/ben.gif" height="26">&nbsp;&nbsp;&nbsp;<img src="<%=request.getContextPath()%>/resources/images/ss.gif">&nbsp;≡<font color="#333333">

									<a href="javascript:void(1)" onClick="display('submenu',<%=i%>);"><font color="#333333"><%=menuName%>
									</a></font> ≡
								</td>
							<tr>
							<tr>
								<td valign="top" align="left">
									<div id="submenu<%=i%>" style="display:none">
										<table>
											<% //ModuleMenu moduleMenu = (ModuleMenu)menuList.get(i);
												ArrayList submenuList = (ArrayList) moduleMenu.getSubMenuList();
												for (int j = 0; j < submenuList.size(); j++) {
													ModuleMenu subModuleMenu = (ModuleMenu) submenuList.get(j);
													String submenuName = subModuleMenu.getMenuName();
													String submenuLink = subModuleMenu.getMenuLink();%>
											<tr>
												<td align="left" valign="top">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<IMG border=0 src="<%=request.getContextPath()%>/resources/images/dian.gif" valign="middle"><a href="<%=submenuLink%>">&nbsp;<font color="#333333"><%=submenuName%>
												</font></a></td>
											</tr>
											<% }%>
										</table>
									</div>
								</td>
							</tr>
							<% }%>
						</table>
						<script>
							function GetObj(objName) {
								if (document.getElementById) {
									return eval('document.getElementById("' + objName + '")');
								} else if (document.layers) {
									return eval("document.layers['" + objName + "']");
								} else {
									return eval('document.all.' + objName);
								}
							}
							function display(preFix, idx) {
								//alert(preFix);
								//alert(idx);
								for (var i = 0; i <<%=menuList.size()%>; i++) {
									if (GetObj(preFix + i)) {
										if (idx == i) {
											if (GetObj(preFix + idx).style.display == "block") {
												GetObj(preFix + idx).style.display = "none";
											} else {
												GetObj(preFix + idx).style.display = "block";
											}
										} else {
											GetObj(preFix + i).style.display = "none";
										}
									}
								}
								//GetObj(preFix).style.display = "none";
								//if(GetObj(preFix+idx).style.display=="block"){
								//GetObj(preFix+idx).style.display = "block";
								//}else{
								//GetObj(preFix+idx).style.display = "block";
								//}
							}
						</script>

					</td>
				</tr>
				<tr>
					<td height=1><img src="<%=request.getContextPath()%>/img/tool_bot1.gif"></td>
				</tr>
				<tr>
					<td height=5 valign="top"><% //左栏标题
						String topicid, topicname, topicurl, p_order;
						int layouttype;
						isFinish = false;
						//存放左中右三个id
						Vector leftdivs = new Vector();
						Vector middivs = new Vector();
						Vector rightdivs = new Vector();
						//序号左中右三个
						Vector leftorderdivs = new Vector();
						Vector midorderdivs = new Vector();
						Vector rightorderdivs = new Vector();
						String leftdivstr = "";
						//如果有数据
						if (havedata) {
							do {
								//ID
								topicid = rs.getString("P_CONTENT");
								//序号
								p_order = rs.getString("P_ORDER");
								//栏目名称，用来显示
								topicname = rs.getString("NAME");  //  CAPTION
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
										//out.print(getFuncHTML(topicid,"185",templatename,"0",usernameen,topicname,topicurl,"left",userflag));
										leftdivstr += getFuncHTML(topicid, "185", templatename, "0", usernameen, topicname, topicurl, "left", userflag);
										havedata = rs.next();
									} else {
										havedata = rs.next();
									}
								} else {
									//左栏结束了
									isFinish = true;
								}
							} while (havedata && !isFinish);
						}%></td>
				</tr>
				<tr>
					<td height=25 background="<%=request.getContextPath()%>/img/tool_top1.gif"><b>&nbsp;最新天气情况</td>
				</tr>
				<tr>
					<td height=160 class=tool valign="top">&nbsp;

						<table border="0" class="position_table" cellSpacing=0 cellPadding=0 align="center" width="159">
							<tr class="menu">
								<td class="position_td" width="159" style="width:350px" valign="top">
									<% String weathertext = "";
										try {
											String newURLstring = "http://www.wz121.com/detail.asp";
											java.net.URL newurl = new java.net.URL(newURLstring);
											java.io.BufferedReader in = new java.io.BufferedReader(new java.io.InputStreamReader(newurl.openStream()));
											String str;
											while ((str = in.readLine()) != null) {
												weathertext += str;
											}
											//out.println(weathertext);
											in.close();
										} catch (java.net.MalformedURLException e) {
										} catch (java.io.IOException e) {
										} %>
									<marquee id="weather" behavior=scroll direction=up width=159 height="190" scrollamount=1 scrolldelay=1 onmouseover='this.stop()' onmouseout='this.start()'></marquee>
									<script language="JavaScript">
										html = '<%=weathertext%>';
										html = html.replace(/<\/?html[^>]*>/gi, "");
										html = html.replace(/<\/?meta[^>]*>/gi, "");
										html = html.replace(/<\/?body[^>]*>/gi, "");
										html = html.replace(/<\/?head[^>]*>/gi, "");
										html = html.replace(/<\/?link[^>]*>/gi, "");
										html = html.replace(/<\/?table[^>]*>/gi, "");
										html = html.replace(/<\/?tr[^>]*>/gi, "");
										html = html.replace(/<\/?td[^>]*>/gi, "");
										html = html.replace(/<\/?center[^>]*>/gi, "");
										var reg = new RegExp("(<title)([^>]*>.*?)(<\/title>)", "gi") ;
										html = html.replace(reg, "");
										document.getElementById("weather").innerHTML = html;
									</script>
								</td>


							</tr>
						</table>

					</td>
				</tr>
				<tr>
					<td height=1><img src="<%=request.getContextPath()%>/img/tool_bot1.gif"></td>
				</tr>

			</table>


		<td width=4></td>
		<td valign="top" width="800">
			<table width="800">
				<tr>
					<td valign="top" height="1" width="800"><template:get name='content'/>
						<jsp:include page="/resources/jsp/newGov_footer.jsp"/>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<table border="0" width=100% height=10 bgcolor=ffffff cellspacing="0" cellpadding="0" align=center>
	<tr>
		<td></td>
	</tr>
</table>
</td>
</tr>
</table>
<% } catch (Exception ee) {
	ee.printStackTrace();
} finally {
	ConnectionProvider.close(db, artstat, rs);
}%><!--索思奇智版权所有-->