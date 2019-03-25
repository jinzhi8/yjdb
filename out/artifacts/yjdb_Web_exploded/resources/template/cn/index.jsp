<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.commons.user.UserException" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="com.kizsoft.commons.commons.config.SystemConfig" %>
<%@page import="java.util.ArrayList" %>
<%@page import="com.kizsoft.commons.acl.ACLManager" %>
<%@page import="com.kizsoft.commons.acl.ACLManagerFactory" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleManager" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleMenu" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleView" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleViewManager" %>
<%@page import="com.kizsoft.commons.commons.orm.MyDBUtils" %>
<%@ page import="java.util.*"%>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>

<% User userInfo = (User) session.getAttribute("userInfo");
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
	String userPoition = userInfo.getPosition();
	String[] userConfig = userInfo.getUserConfig();
	Group groupInfo = (Group) userInfo.getGroup();
	String udepartment = groupInfo.getGroupname();
	
	String userflag = (String) session.getAttribute("userFlag");
	session.setAttribute("templatename","cn");
	ACLManager aclManager = ACLManagerFactory.getACLManager();
	String desktop="desktop";
	int count = MyDBUtils.queryForInt("select count(*) from bulletin t where t.issueflag='1' and not exists(select 1 from readinfo r where r.id=t.unid and r.readmanid=?) order by t.issuetime desc" ,userId);

%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title><%=SystemConfig.getFieldValue("//systemconfig/system/name")%></title>
	<meta name="renderer" content="webkit">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta http-equiv="Access-Control-Allow-Origin" content="*">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
	<meta name="apple-mobile-web-app-status-bar-style" content="black">
	<meta name="apple-mobile-web-app-capable" content="yes">
	<meta name="format-detection" content="telephone=no">
	<link rel="icon" href="favicon.ico">
	<link rel="stylesheet" href="<%=contextPath%>/resources/template/cn/layui/css/layui.css"+Math.random() media="all" />
	<link rel="stylesheet" href="<%=contextPath%>/resources/template/cn/css/index.css" media="all" />
	<style>
		.user-photobox{
		    width: 40px;
		    float: left;
		    margin-top: 5px;
		}
		.user-photobox img{
		    display: block;
		    border: none;
		    width: 100%;
		    height: 100%;
		    border-radius: 50%;
		    -webkit-border-radius: 50%;
		    -moz-border-radius: 50%;
		    border: 2px solid #f6faff;
		    box-sizing: border-box;
		}
		#userInfo cite.adminName {
		    max-width: 190px;
		    overflow: hidden;
		    display: block;
		    text-indent: 6px;
		    text-overflow: ellipsis;
		}
	</style>
</head>
<body class="main_body">
	<div class="layui-layout layui-layout-admin">
		<!-- 顶部 -->
		<div class="layui-header headers">
			<div class="layui-main mag0">
				<a href="#" class="logo"><!-- <img src="/yjdb/resources/template/cn/images/index-logo.png" width="100%"> --></a>
				<!-- <a href="#" class="logo"><%=SystemConfig.getFieldValue("/config/systemconfig.xml", "//systemconfig/system/name")%></a> -->
				<!-- 显示/隐藏菜单 -->
				<a href="javascript:;" class="seraph hideMenu icon-caidan"></a>
				<div class="newclass-logotitle">
					<img src="/yjdb/resources/template/cn/images/index-logo.png">
					<span>事事有着落、件件有回音  事项未落实、督办不停止</span>
				</div>
				<!-- 顶级菜单 -->
				<!-- <div class="weather" pc>
			    	<div id="tp-weather-widget"></div>
					<script>(function(T,h,i,n,k,P,a,g,e){g=function(){P=h.createElement(i);a=h.getElementsByTagName(i)[0];P.src=k;P.charset="utf-8";P.async=1;a.parentNode.insertBefore(P,a)};T["ThinkPageWeatherWidgetObject"]=n;T[n]||(T[n]=function(){(T[n].q=T[n].q||[]).push(arguments)});T[n].l=+new Date();if(T.attachEvent){T.attachEvent("onload",g)}else{T.addEventListener("load",g,false)}}(window,document,"script","tpwidget","//widget.seniverse.com/widget/chameleon.js"))</script>
					<script>tpwidget("init", {
					    "flavor": "slim",
					    "location": "WX4FBXXFKE4F",
					    "geolocation": "enabled",
					    "language": "zh-chs",
					    "unit": "c",
					    "theme": "chameleon",
					    "container": "tp-weather-widget",
					    "bubble": "disabled",
					    "alarmType": "badge",
					    "color": "#FFFFFF",
					    "uid": "U9EC08A15F",
					    "hash": "039da28f5581f4bcb5c799fb4cdfb673"
					});
					tpwidget("show");</script>
			    </div> -->
			    <!-- 顶部右侧菜单 -->
			    <ul class="layui-nav top_menu">
			    	<!-- <li class="layui-nav-item" pc>
						<a href="javascript:;" data-url="yj_tz/index.jsp"><i class="layui-icon">&#xe645;</i><cite>通知公告</cite></a>
					</li> -->
					<!-- <li class="layui-nav-item" pc>
						<a href="javascript:;" class="clearCache"><i class="layui-icon" data-icon="&#xe640;">&#xe640;</i><cite>清除缓存</cite><span class="layui-badge-dot"></span></a>
					</li> -->
					<%--<li class="layui-nav-item" pc>
						<a href="javascript:;" class="zhqh"><i class="layui-icon" data-icon="&#xe640;">&#xe640;</i><cite>账号切换</cite><span class="layui-badge-dot"></span></a>
					</li>--%>
					<li class="layui-nav-item" pc>
						<a href="javascript:;"><i class="layui-icon">&#xe770;</i><cite><%=udepartment%></cite></a>
					</li>
					
					<li class="layui-nav-item" id="userInfo">
						<a href="javascript:;">
							<div class="user-photobox">
								<img src="<%=contextPath%>/resources/template/cn/images/Galogo.png" class="userAvatar">
							</div>
							<cite class="adminName"><%=userName%></cite>
						</a>
						<dl class="layui-nav-child">
							<dd><a href="javascript:;" data-url="personalize/person_modify.jsp"><i class="seraph icon-ziliao" data-icon="icon-ziliao"></i><cite>个人资料</cite></a></dd>
							<dd><a href="javascript:;" data-url="personal/modifyPassword.jsp"><i class="seraph icon-xiugai" data-icon="icon-xiugai"></i><cite>修改密码</cite></a></dd>
							<!-- <dd><a href="javascript:;" data-url="yj_tz/index.jsp"><i class="layui-icon">&#xe645;</i><cite>通知公告</cite></a></dd> -->
							<!--<dd><a href="javascript:;" class="showNotice"><i class="layui-icon">&#xe645;</i><cite>系统公告</cite><span class="layui-badge-dot"></span></a></dd>
							<dd pc><a href="javascript:;" class="functionSetting"><i class="layui-icon">&#xe620;</i><cite>功能设定</cite><span class="layui-badge-dot"></span></a></dd>
							<dd pc><a href="javascript:;" class="changeSkin"><i class="layui-icon">&#xe61b;</i><cite>更换皮肤</cite></a></dd>-->
							<dd><a href="logout.jsp" class="signOut"><i class="seraph icon-tuichu"></i><cite>退出</cite></a></dd>
						</dl>
					</li>
				</ul>
			</div>
		</div>
		<!-- 左侧导航 -->
		<div class="layui-side layui-bg-black menu-left-box">
			<!-- <div class="user-photo">
				<a class="img" title="永嘉督办" ><img src="<%=contextPath%>/resources/template/cn/images/Galogo.png" class="userAvatar"></a>
				<p>你好！<span class="userName"><%=userName%></span>, 欢迎登录</p>
			</div> -->
			<!-- 搜索 -->
			<!--<div class="layui-form component">
				<select name="search" id="search" lay-search lay-filter="searchPage">
					<option value="">搜索页面或功能</option>
					<option value="1">layer</option>
					<option value="2">form</option>
				</select>
				<i class="layui-icon">&#xe615;</i>
			</div>-->
			<div class="navBar layui-side-scroll" id="navBar">
				<ul class="layui-nav layui-nav-tree">
					<li class="layui-nav-item layui-this">
						<a href="javascript:;" data-url=""><i class="layui-icon" data-icon=""></i><cite>首页</cite></a>
					</li>
				</ul>
			</div>
		</div>
		<!-- 右侧内容 -->
		<div class="layui-body layui-form">
			<div class="layui-tab mag0" lay-filter="bodyTab" id="top_tabs_box">
				<ul class="layui-tab-title top_tab" id="top_tabs">
					<li class="layui-this" lay-id=""><i class="layui-icon">&#xe68e;</i> <cite>首页</cite></li>
				</ul>
				<ul class="layui-nav closeBox">
				  <li class="layui-nav-item">
				    <a href="javascript:;"><i class="layui-icon caozuo">&#xe643;</i> 页面操作</a>
				    <dl class="layui-nav-child">
					  <dd><a href="javascript:;" class="refresh refreshThis"><i class="layui-icon">&#x1002;</i> 刷新当前</a></dd>
				      <dd><a href="javascript:;" class="closePageOther"><i class="seraph icon-prohibit"></i> 关闭其他</a></dd>
				      <dd><a href="javascript:;" class="closePageAll"><i class="seraph icon-guanbi"></i> 关闭全部</a></dd>
				    </dl>
				  </li>
				</ul>
				<div class="layui-tab-content clildFrame">
					<div class="layui-tab-item layui-show">
						<iframe src="yj_sy/index.jsp"></iframe>
					</div>
				</div>
			</div>
		</div>
		<%-- <!-- 底部 -->
		<div class="layui-footer footer">
			<p><span><%=SystemConfig.getFieldValue("//systemconfig/system/logincopyright")%></span></p>
		</div> --%>
	</div>

	<!-- 移动导航 -->
	<div class="site-tree-mobile"><i class="layui-icon">&#xe602;</i></div>
	<div class="site-mobile-shade"></div>

	<script type="text/javascript" src="<%=contextPath%>/resources/template/cn/layui/layui.js"+Math.random()></script>
	<script type="text/javascript" src="<%=contextPath%>/resources/template/cn/js/index.js?"+Math.random()></script>
	<script type="text/javascript" src="<%=contextPath%>/resources/template/cn/js/cache.js?"+Math.random()></script>
</body>
</html>
