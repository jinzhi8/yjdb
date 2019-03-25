<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.commons.db.ConnectionProvider" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="java.sql.Connection" %>
<%@page import="java.sql.PreparedStatement" %>
<%@page import="java.sql.ResultSet" %>
<%@page import="java.util.Vector" %>

<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<jsp:useBean id="ManageTemplateBean" class="com.kizsoft.oa.personal.ManageTemplate"></jsp:useBean>
<head>
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
</head>
<%//用户登陆验证
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
		//response.sendRedirect(request.getContextPath() + "/login.jsp");
	}
	User userInfo = (User) session.getAttribute("userInfo");
	String userID = userInfo.getUserId();
	String usernameen = userInfo.getAccount();

	String userflag = "";
	if (session.getAttribute("userFlag") != null) {
		userflag = (String) session.getAttribute("userFlag");
	}
	String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();%>
<%String SESSION_TEMPLATENAME = "templatename";
	String templatename = (String) session.getAttribute(SESSION_TEMPLATENAME);
	try {%>
<%!String getFuncHTML(String contextPath, String id, String wid, String templatename, String layouttype, String username, String topicname, String topicurl, String align, String userflag) {
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
			return "<table width=\'170\'  border=\'0\'><tr><td height=\'22\' width=\'35\' align=\'right\'><img src=\'resources/images_wz/index_38.gif\' width=\'32\' height=\'25\'></td><td height=\'22\' background=\'resources/images_wz/index_49.gif\'  width=\'135\'>&nbsp;" + topicname + "</td></tr></table><iframe id=\'datalink\' height=\"10\" src=\"" + contextPath + topicurl + "\" width=\"100%\" frameBorder=\"0\" scrolling=\"no\"></iframe>";
		} else {
			return "<table width=\'170\'  border=\'0\'><tr><td height=\'22\' width=\'35\' align=\'right\'><img src=\'resources/images_wz/index_38.gif\' width=\'32\' height=\'25\'></td><td height=\'22\' background=\'resources/images_wz/index_49.gif\'  width=\'135\'>&nbsp;<a href=\'" + contextPath + topicurl + "\' " + newWindow + ">" + topicname + "</a></td></tr></table>";
		}
	} else {
		return " <div id=div_" + id + " class=\"drag\">\n" + " <table id=table_" + id + " width=\"100%\" border=0 align=center cellpadding=0 cellspacing=0 class=\"my_cont\">\n" + " <tr><td height=22 ><table width=\"100%\" border=0 cellspacing=0 cellpadding=0  background=\"personalize/theme/" + templatename + "/" + titlepic + "\">" + " <tr><td width=\"400\" height=22 class=my_contTitle >&nbsp;" + topicname + "</td>" + " <td height=22 align=right valign=middle >&nbsp;</td>" + " </tr></table></td></tr>" + " <tr><td valign=\"top\" height=\"" + hid + "\" align=left style=\"border: 1pt solid ;\">\n" + "<iframe id=\"" + id + "\" height=\"" + ihid + "\" src=\"" + contextPath + topicurl + "\" width=\"100%\" frameBorder=\"0\" scrolling=\"no\"></iframe>" + " </td></tr></table><br></div>\n";
		// <a href=\"javascript:deletelayout('"+id+"');\"><img src=\"personalize/theme/"+templatename+"/icon_03.gif\" width=17 height=17 hspace=2 border=0  TITLE=\"不显示栏目\"></a> //删除按钮
	}
}%>
<%!boolean isFunc(String id) {
	if (id.length() > 4) {
		return id.substring(0, 4).equalsIgnoreCase("func");
	} else {
		return false;
	}
}%>
<%if (templatename == null || templatename.length() <= 0) {
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
<link href="<%=request.getContextPath()%>/personalize/theme/<%=templatename%>/template.css" rel="stylesheet" type="text/css">
<style>
	<!--
	.drag {
		position: relative
	}

	.hand {
		cursor: hand
	}

	-->
</style>

<script language="JavaScript">
<
!--
var ie = document.all;
var ns6 = document.getElementById && !document.all;

var dragapproved = false;
var z,x,y;

function move(e) {
	if (dragapproved) {
		z.style.left = ns6 ? temp1 + e.clientX - x : temp1 + event.clientX - x;
		z.style.top = ns6 ? temp2 + e.clientY - y : temp2 + event.clientY - y;
		return false;
	}
}

function drags(e) {
	if (!ie && !ns6)
		return;
	var firedobj = ns6 ? e.target : event.srcElement;
	//debug
	//alert(firedobj.className);
	var topelement = ns6 ? "HTML" : "BODY";
	//debug
	//alert(firedobj.className);

	var oldobj = firedobj;
	while (firedobj.tagName != topelement && firedobj.className != "drag") {
		firedobj = ns6 ? firedobj.parentNode : firedobj.parentElement;
	}
	//debug
	//alert(firedobj.className);
	if (firedobj.className == "drag") {
		var ev = ns6 ? e : event;
		dragapproved = true;
		z = firedobj;
		z.style.zIndex = 99;
		eval("document.all.table_" + z.id.substring(4) + ".style.filter='Alpha(Opacity=50)'");

		temp1 = parseInt(z.style.left + 0);
		temp2 = parseInt(z.style.top + 0);
		x = ns6 ? e.clientX : event.clientX;
		y = ns6 ? e.clientY : event.clientY;
		document.onmousemove = move;
		return false;
	}
}
function dragend(e) {
	if (!ie && !ns6)
		return;
	var firedobj = ns6 ? e.target : event.srcElement;
	var topelement = ns6 ? "HTML" : "BODY";

	while (firedobj.tagName != topelement && firedobj.className != "drag") {
		firedobj = ns6 ? firedobj.parentNode : firedobj.parentElement;
	}

	if (firedobj.className == "drag") {
		dragapproved = false;
		z = firedobj;
		//如果是层则要恢复不透明
		//z.style.filter="Alpha(Opacity=100)";
		z.style.zIndex = 0;
		eval("document.all.table_" + z.id.substring(4) + ".style.filter=''");
		//提交刷新页面
		arrangediv(z);
		return false;
	}
}//modify bu huaguol 2005-07-19 为了去除拖动功能！//document.onmousedown=drags;//document.onmouseup=dragend;//--end modify
var leftdivs;
var middivs;
var rightdivs;

var leftorderdivs;
var midorderdivs;
var rightorderdivs;

function showpic(colid, showp) {
	var sh = "显示";
	if (showp == "1") {
		sh = "不显示";
	}
	if (colid > "" && confirm("确定要" + sh + "图片吗？")) {
		//提交删除
		//alert(delid);
		if (showp == "1") {
			showp = "0";
		} else {
			showp = "1";
		}
		frames["mypagesave"].document.all.dragdivid.value = colid;
		frames["mypagesave"].document.all.showp.value = showp;
		frames["mypagesave"].document.all.action.value = "showpic";
		frames["mypagesave"].document.all.divform.submit();
	}
}

function deletelayout(delid) {
	if (delid > "" && confirm("不显示这个栏目吗？")) {
		//提交删除
		//alert(delid);
		//eval('document.all.div_'+delid+'.style.visibility="hidden"');
		frames["mypagesave"].document.all.dragdivid.value = delid;
		frames["mypagesave"].document.all.action.value = "delete";
		frames["mypagesave"].document.all.divform.submit();
	}
}

//重排层将当前拖动对象选择放在哪里
function arrangediv(dragobj) {
	//先找老位置，再找新位置，如果两个位置一样则复位，如果不一样则提交。
	var targetdivs;
	var targetorderdivs;
	var laytype;
	var layorder;
	var oldlaytype,oldlayorder = -1;
	//找出该拖动层的老位置，从三个数组中找。
	if (oldlayorder < 0) {
		for (i = 0; i < leftdivs.length; i++) {
			//如果id相同表示老位置
			if (dragobj.id == leftdivs[i].id) {
				oldlaytype = "0";
				oldlayorder = leftorderdivs[i];//i;
				break;
			}
		}
	}
	if (oldlayorder < 0) {
		for (i = 0; i < middivs.length; i++) {
			//如果id相同表示老位置
			if (dragobj.id == middivs[i].id) {
				oldlaytype = "1";
				oldlayorder = midorderdivs[i];//i;
				break;
			}
		}
	}
	if (oldlayorder < 0) {
		for (i = 0; i < rightdivs.length; i++) {
			//如果id相同表示老位置
			if (dragobj.id == rightdivs[i].id) {
				oldlaytype = "2";
				oldlayorder = rightorderdivs[i];//i;
				break;
			}
		}
	}
	oldlayorder = parseInt(oldlayorder);
	//找到新位置
	//整个表格的偏移量
	var tableleft = document.all.alltable.offsetLeft;
	//计算左栏的范围
	var leftmin = document.all.lefttd.offsetLeft,leftmax = document.all.lefttd.offsetLeft + document.all.lefttd.offsetWidth;
	//计算中栏的范围
	var midmin = document.all.midtd.offsetLeft,midmax = document.all.midtd.offsetLeft + document.all.midtd.offsetWidth;
	//计算右栏的范围
	var rightmin = document.all.righttd.offsetLeft,rightmax = document.all.righttd.offsetLeft + document.all.righttd.offsetWidth;
	//转成相对表格的偏移量
	var objmiddle = dragobj.offsetLeft - tableleft + dragobj.offsetWidth / 2;

	//debug
	//alert("leftmin:"+leftmin+" leftmax:"+leftmax+" midmin:"+midmin+" midmax:"+midmax+" objmiddle:"+objmiddle+" dragobj:"+(dragobj.offsetLeft+dragobj.offsetWidth/2));

	//左栏范围内则加入左栏
	if (objmiddle <= leftmax)//dragobj.offsetLeft>=leftmin&&
	{
		targetdivs = leftdivs;
		targetorderdivs = leftorderdivs;
		laytype = "0";
	}
	//中栏范围内则加入中栏
	else if (objmiddle >= midmin && objmiddle <= midmax) {
		targetdivs = middivs;
		targetorderdivs = midorderdivs;
		laytype = "1";
	}
	//右栏范围内则加入右栏
	else if (objmiddle >= rightmin)//&&dragobj.offsetLeft<=rightmax
		{
			targetdivs = rightdivs;
			targetorderdivs = rightorderdivs;
			laytype = "2";
		}
	layorder = -1;
	for (i = 0; i < targetdivs.length; i++) {
		//debug
		//alert("dragobj.offsetTop="+dragobj.offsetTop+",targetdivs[i].id:"+targetdivs[i].id+",targetdivs[i].offsetTop="+targetdivs[i].offsetTop+",i="+i);
		//如果拖动对象小于当前对象则表示要插入到当前对象，不要与自己比较。
		if (dragobj.offsetTop < targetdivs[i].offsetTop && dragobj.id != targetdivs[i].id) {
			//如果不是第一个，并且上一个是自己，那就要意味着没有动
			if (i > 0 && dragobj.id == targetdivs[i - 1].id) {
				layorder = targetorderdivs[i - 1];//i-1;
			} else //是第一个，或者上一个不是自己
			{
				layorder = targetorderdivs[i];//i;
				//layorder=oldlayorder;
			}
			break;
		}
	}
	layorder = parseInt(layorder);
	//如果没有小于的，表示是最后一个，如果本来就是最后一个则不需要变动
	if (layorder < 0) {
		if (targetdivs.length > 0) {
			//本来就不是最后一个则加添加
			if (targetdivs[targetdivs.length - 1].id != dragobj.id) {
				layorder = targetorderdivs[targetorderdivs.length - 1] + 1;//targetdivs.length;
			} else  //是最后一个则不需要变动
			{
				layorder = oldlayorder;
			}
		} else {
			//如果所移动的是空
			layorder = 0;
		}
	}
	//debug
	//alert("laytype="+laytype+",oldlaytype="+oldlaytype+",layorder="+layorder+",oldlayorder="+oldlayorder);
	//如果位置相同则把left和top置为0.
	if (laytype == oldlaytype && layorder == oldlayorder) {
		dragobj.style.left = "0";
		dragobj.style.top = "0";
	} else {
		//debug
		//alert(frames["mypagesave"].document.all.divform);
		//提交
		frames["mypagesave"].document.all.action.value = "drag";
		frames["mypagesave"].document.all.dragdivid.value = dragobj.id.substring(4);
		//新位置
		frames["mypagesave"].document.all.layoutype.value = laytype;
		frames["mypagesave"].document.all.layouorder.value = layorder;
		//老位置
		frames["mypagesave"].document.all.oldlayoutype.value = oldlaytype;
		frames["mypagesave"].document.all.oldlayoutorder.value = oldlayorder;
		frames["mypagesave"].document.all.divform.submit();
	}
}
-- >
</script>

<%//如果什么数据都没有就显示一条信息
	if (!havedata) {%>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="my_home">
	<tr>
		<td align="center" class="little_text_0">
			对不起！没有进行个性化设置，请进入
		</td>
	</tr>
</table>
<%} else {
	java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy'年'MM'月'dd'日'");
	java.util.Date d = new java.util.Date(System.currentTimeMillis());
	String dstr = df.format(d);%>
<table id="alltable" width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="my_home" class="border-index">
	<tr>
		<td id="lefttd" width="185px" valign="top" bgcolor="#ECF0F4" valign="top" align="center">
			<a href="<%=contextPath%>/filebase/search.jsp"><IMG SRC="<%=contextPath%>/resources/images_wz/index_17.gif" width="185px" height="60" border="0"></a>
			<table width="185px" border="0" align="center" cellpadding="0" cellspacing="0">
				<tr>
					<td>
						<%
							//左栏标题
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
											out.print(getFuncHTML(contextPath, topicid, "185", templatename, "0", usernameen, topicname, topicurl, "left", userflag));
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
						%>
						<!-- 动态信息 -->
						<table width="170" border="0">
							<tr>
								<td height="22" width="35" align="right">
									<img src="<%=contextPath%>/resources/images_wz/index_38.gif" width="32" height="25">
								</td>
								<td height="22" background="<%=contextPath%>/resources/images_wz/index_49.gif" width="135">动态信息</td>
							</tr>
						</table>
						<iframe height="150" src="<%=contextPath%>/sharebulletin/info.jsp" width="100%" frameBorder="0" scrolling="no"></iframe>
					</td>
				</tr>
			</table>
		</td>

		<td id="midtd" width="0" valign="top" align="center">

			<%
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
								out.print(getFuncHTML(contextPath, topicid, "375", templatename, "1", usernameen, topicname, topicurl, "middle", userflag));
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
			%>

		</td>
		<td id="righttd" valign="top" style="padding-left:4px;padding-right:4px;padding-bottom:3px" align="center">

			<%
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
								out.print(getFuncHTML(contextPath, topicid, "578", templatename, "2", usernameen, topicname, topicurl, "right", userflag));
								havedata = rs.next();
							} else {
								havedata = rs.next();
							}
						} else {
							//右栏结束了
							isFinish = true;
						}
					} while (havedata && !isFinish);
				}
			%>

		</td>
	</tr>
</table>
<%}%>
<script language="JavaScript">
	leftdivs = new Array(<%
for(int i=0;i<leftdivs.size();i++)
{
  String divname=(String)leftdivs.get(i);
  String split=",";
  if(i==leftdivs.size()-1)//最后一个不需要加，
  {split="";}
  out.print("document.all."+divname+split);
}
%>);
	leftorderdivs = new Array(<%
for(int i=0;i<leftorderdivs.size();i++)
{
  String divname=(String)leftorderdivs.get(i);
  String split=",";
  if(i==leftorderdivs.size()-1)//最后一个不需要加，
  {split="";}
  out.print("'"+divname+"'"+split);
}
%>);
	middivs = new Array(<%
for(int i=0;i<middivs.size();i++)
{
  String divname=(String)middivs.get(i);
  String split=",";
  if(i==middivs.size()-1)//最后一个不需要加，
  {split="";}
  out.print("document.all."+divname+split);
}
%>);
	midorderdivs = new Array(<%
for(int i=0;i<midorderdivs.size();i++)
{
  String divname=(String)midorderdivs.get(i);
  String split=",";
  if(i==midorderdivs.size()-1)//最后一个不需要加，
  {split="";}
  out.print("'"+divname+"'"+split);
}
%>);
	rightdivs = new Array(<%
for(int i=0;i<rightdivs.size();i++)
{
  String divname=(String)rightdivs.get(i);
  String split=",";
  if(i==rightdivs.size()-1)//最后一个不需要加，
  {split="";}
  out.print("document.all."+divname+split);
}
%>);
	rightorderdivs = new Array(<%
for(int i=0;i<rightorderdivs.size();i++)
{
  String divname=(String)rightorderdivs.get(i);
  String split=",";
  if(i==rightorderdivs.size()-1)//最后一个不需要加，
  {split="";}
  out.print("'"+divname+"'"+split);
}
%>);
</script>
<%} catch (Exception ee) {
	ee.printStackTrace();
} finally {
	ConnectionProvider.close(db, artstat, rs);
}
} catch (Exception ex) {
	ex.printStackTrace();
}%>
<iframe id="mypagesave" height="0" width="0" src="<%=request.getContextPath()%>/personalize/mypagesave.jsp" style="visibility:hidden;" class="nomargin"></iframe><!--索思奇智版权所有-->