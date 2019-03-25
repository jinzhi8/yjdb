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
	String moduleStr = getModuleStr(contextPath,userId);
	
	ACLManager aclManager = ACLManagerFactory.getACLManager();
	String desktop="desktop";
	if(aclManager.isOwnerRole(userId, "sadmin")||aclManager.isOwnerRole(userId, "sysadmin")
		||aclManager.isOwnerRole(userId, "xjman")
		||aclManager.isOwnerRole(userId, "1001")||aclManager.isOwnerRole(userId, "1002")||aclManager.isOwnerRole(userId, "1003")
		||aclManager.isOwnerRole(userId, "1004")||aclManager.isOwnerRole(userId, "1007")||aclManager.isOwnerRole(userId, "1009")
		||aclManager.isOwnerRole(userId, "1006")
		||aclManager.isOwnerRole(userId, "xj_1001")||aclManager.isOwnerRole(userId, "xj_1002")||aclManager.isOwnerRole(userId, "xj_1003")
		||aclManager.isOwnerRole(userId, "xj_1004")||aclManager.isOwnerRole(userId, "xj_1007")||aclManager.isOwnerRole(userId, "xj_1009")
		||aclManager.isOwnerRole(userId, "xj_1006")){
		desktop="desktop_gly";
	}
	boolean admin =  aclManager.isOwnerRole(userId, "sysadmin");//判断是否为系统管理员	
	int count = MyDBUtils.queryForInt("select count(*) from bulletin t where t.issueflag='1' and not exists(select 1 from readinfo r where r.id=t.unid and r.readmanid=?) order by t.issuetime desc" ,userId);
	/*String sql="select ownername from owner t where id in (select parentid from ownerrelation where ownerid='"+userId+"')";
	List<Map<String,Object>> ownername=MyDBUtils.queryForMap(sql);
	String DwOwner=(String)ownername.get(0).get("ownername");*/
	
%>
<%!
	public String getModuleStr(String contextPath,String userId){
		StringBuffer sb = new StringBuffer();
		int menuIndex = 0;	
		ModuleManager moduleManager = new ModuleManager();
		ACLManager aclManager = ACLManagerFactory.getACLManager();
		ArrayList menuList = (ArrayList) moduleManager.getUserMenuInfoList(userId);
		int menuParentNodeId = 0;
		int viewParentNodeId = 0;
		for (int menuTypeIndex = 0; menuTypeIndex < menuList.size(); menuTypeIndex++) {
			ModuleMenu moduleMenu = (ModuleMenu) menuList.get(menuTypeIndex);
			String menuName = moduleMenu.getMenuName();
			String menuLink = moduleMenu.getMenuLink();
			if(menuIndex==0){
				sb.append("<p class=\"menu_head current\">"+menuName+"</p>");
			}else{
				sb.append("<p class=\"menu_head\">"+menuName+"</p>");
			}
			menuIndex++;
			menuParentNodeId = menuIndex;
			ArrayList submenuList = (ArrayList) moduleMenu.getSubMenuList();
			sb.append("<div class=menu_body >");
			for (int j = 0; j < submenuList.size(); j++) {
				ModuleMenu subModuleMenu = (ModuleMenu) submenuList.get(j);
				String submenuName = subModuleMenu.getMenuName();
				String submenuLink = subModuleMenu.getMenuLink();
				String submenuId = subModuleMenu.getModuleId();
				sb.append("<a href=\""+contextPath+submenuLink+"\" target=\"content\" title=\""+submenuName+"\">"+submenuName+"</a>");
				menuIndex++;
				viewParentNodeId = menuIndex;
				/*ModuleViewManager moduleViewManager = new ModuleViewManager();
				ArrayList viewList = (ArrayList) moduleViewManager.getUserViewCollection(submenuId, userId);
				int viewCount = viewList.size();
				ModuleView moduleView = null;
				for (int ii = 0; ii < viewCount; ii++) {

				}*/
			}
			sb.append("</div>");
		}
		return sb.toString();
	}
%>	

<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<title><%=SystemConfig.getFieldValue("//systemconfig/system/name")%></title>
	<link href="<%=contextPath%>/resources/template/cn/css/style.css" rel="stylesheet" type="text/css">
	<link href="<%=contextPath%>/resources/js/layui/css/layui.css" rel="stylesheet" rel="stylesheet"  type="text/css">
	<script language="javascript" type="text/javascript" charset="utf-8" src="<%=contextPath%>/resources/js/jquery/jquery-1.11.0.min.js"></script>
	
	
	<style type="text/css">
	
		
	</style>
	
	<style type="text/css">
		.pyga_zdpyci_users_name_dsjjkpt{
			background-color: #1575bd;
			padding: 0px 14px;
			margin-right: 12px;
		}
		.tzgaxx_i{
		    background-color: red;
    		width: 20px;
   			height: 20px;
    		color: #ffffff;
    		display: inline-block;
    		border-radius: 99px;
    		text-align: center;
    		line-height: 20px;
   		 	font-size: 8px;
   		 	font-style: normal;
   		 }
	</style>
</head>
<body class="index_bodycs">
<script language="javascript" type="text/javascript" charset="utf-8" src="<%=contextPath%>/resources/js/layui/layui.js"></script>
	<div class="pyga_zdpyci_header">
		<div class="pyga_zdpyci_logo"><%=SystemConfig.getFieldValue("//systemconfig/system/name")%></div>
		<div class="pyga_zdpyci_users_name">
			<%if(admin){%>
			<a href="<%=contextPath%>/tzgadp/index.jsp" class="pyga_zdpyci_users_name_dsjjkpt" target="_blank">大数据监控平台</a>
			<%} %>
			<a href="<%=contextPath%>/sharebulletin/stat.jsp" class="pyga_zdpyci_users_name_dsjjkpt" target="content">系统公告
				<%if(count>0){%>
				<i class="tzgaxx_i"><%=count%></i>
				<%}%>
			</a>
			<a href="<%=contextPath%>/resources/template/cn/<%=desktop%>.jsp" target="content" >首页</a><span><i class="usericons" ></i><span title="<%=udepartment%>"><%=userName%></span></span>
			<input type="button" vlaue="登出" class="pyga_zdpyci_usersexit" onclick="logout();" />
		</div>
		</div>
		<div class="pyga_zdpyci_body">
			<!--左侧信息开始-->
			<div class="pyga_zdpyci_leftnav">
				<div id="firstpane" class="menu_list">
					<%=moduleStr%>
				</div>
			</div>
			<!--左侧信息结束-->
			<!--内容信息开始-->
			<div class="pyga_zdpyci_rightmian">
				<iframe id="content" name="content" src="<%=contextPath%>/resources/template/cn/<%=desktop%>.jsp" frameborder="0" scrolling="auto" width="100%" height="99%"></iframe>
				<!-- <iframe id="content" name="content" runat="server" src="<%=contextPath%>/resources/template/cn/desktop.jsp" frameborder="0" border="0" marginwidth="0" marginheight="0" scrolling="auto" allowtransparency="yes" width="100%" height="100%"></iframe> -->
			</div>
			<!--内容信息结束-->
		</div>
		<script type="text/javascript" src="<%=contextPath%>/resources/template/cn/js/divscroll.js"></script>
		<script type="text/javascript">
		$(document).ready(function(){
			$("#firstpane .menu_body:eq(0)").show();
			$("#firstpane p.menu_head").click(function(){
				$(this).addClass("current").next("div.menu_body").slideToggle(300).siblings("div.menu_body").slideUp("slow");
				$(this).siblings().removeClass("current");
			});
			$("#secondpane .menu_body:eq(0)").show();
			$("#secondpane p.menu_head").mouseover(function(){
				$(this).addClass("current").next("div.menu_body").slideDown(500).siblings("div.menu_body").slideUp("slow");
				$(this).siblings().removeClass("current");
			});
			$("#firstpane div.menu_body a").click(function(){
				$(this).addClass("currentss");
				$(this).siblings().removeClass("currentss");
			});
		});
		$(function() {
		   $('.pyga_zdpyci_leftnav').perfectScrollbar();
		});
		</script>
		
		<SCRIPT LANGUAGE="JavaScript">
		if (top.location != self.location) top.location = self.location;
	
		window.onbeforeunload = function() {
			onbeforeunload.flag = true;
		};
		window.onunload = function() {
			if (onbeforeunload.flag) {
				return;
			}
			return;
		};
		
		
		
		//系统退出
		function logout(){
			window.location.href="<%=contextPath%>/logout.jsp";
		}
	</script>
	<script>
		//一般直接写在一个js文件中
		/*layui.use(['layer', 'form'], function(){
			var layer = layui.layer
			,form = layui.form;
			
			//系统公告
		var getSystemMsg = function(){
			$.ajax({
				type: "POST",
				url: '<%=contextPath%>/resources/template/cn/Action_index.jsp',
				dataType: "json",
				data: {
					action:"systemmsg",
					userId:"<%=userId%>"
				},
				success: function (result) {
					console.info(result);
					if(result.success){
						var data = result.data;
						if(data.length>0){
							var content ="<div style='display: table;width: 100%; height: 100%;'><div style='display:table-cell;vertical-align: middle;width: 100%;text-align: center;'>";
							for(var i=0;i<data.length;i++){						
								content +="<div style=''><a href='<%=contextPath%>/view?xmlName=sharebulletin&appId="+data[i].UNID+"'  target='content'>"+data[i].TITLE+"  "+data[i].ISSUETIME+"</a></div>";
							}
							content +="</div></div>";
							layer.open({
								type: 1
								,title:'系统公告'
								,area: ['300px', '200px']
								,offset: 'rb' 
								,content: content
								,shade: 0 //不显示遮罩
							});
						}
					}
				}
	  	    }); 
		}
			 layer.ready(function(){
			 	getSystemMsg();
			 });
		});*/
		
	</script> 
</body>
</html>
