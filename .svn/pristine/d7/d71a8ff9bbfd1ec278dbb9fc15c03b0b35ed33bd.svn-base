<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Map"%>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.commons.user.UserException" %>
<%@page import="com.kizsoft.commons.commons.orm.SimpleORMUtils" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleManager" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleMenu" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleView" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleViewManager" %>
<%@page import="com.kizsoft.commons.commons.orm.MyDBUtils" %>
<%@page import="java.util.*"%>

<%
	User userInfo = (User) session.getAttribute("userInfo");
	String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
	String userName = userInfo.getUsername();
	String userId = userInfo.getUserId();

	SimpleORMUtils instance =SimpleORMUtils.getInstance();
    String action = request.getParameter("action");
	//System.out.println("action:"+action);
	String[] strDate={"&#xe62a;","&#xe638;","&#xe634;","&#xe630;","&#xe632;","&#xe60d;","&#xe64c;","&#xe628;","&#xe63c;","&#xe857;","&#xe604;","&#xe606;","&#xe705;","&#xe653;","&#xe630;","&#xe632;","&#xe60d;","&#xe62a;","&#xe638;","&#xe634;","&#xe630;","&#xe632;","&#xe60d;","&#xe64c;","&#xe628;","&#xe63c;","&#xe857;","&#xe604;","&#xe606;","&#xe705;","&#xe653;","&#xe630;","&#xe632;","&#xe60d;"};
	String[] diDate={"&#xe61c;","&#xe857;","&#xe635;","&#xe629;","&#xe606;","&#xe857;","&#xe64c;","&#xe628;","&#xe63c;","&#xe61c;","&#xe857;","&#xe635;","&#xe629;","&#xe606;","&#xe857;","&#xe64c;","&#xe628;","&#xe63c;"};
    if("getMdoule".equals(action)){
		String jsonM1 ="";
    	ModuleManager moduleManager = new ModuleManager();	
		ArrayList menuList = (ArrayList) moduleManager.getUserMenuInfoList(userId);
		for (int menuTypeIndex = 0; menuTypeIndex < menuList.size(); menuTypeIndex++) {
			ModuleMenu moduleMenu = (ModuleMenu) menuList.get(menuTypeIndex);
			String menuName = moduleMenu.getMenuName();
			String menuLink = moduleMenu.getMenuLink();
			ArrayList submenuList = (ArrayList) moduleMenu.getSubMenuList();
			String jsonM2 ="";
			if(submenuList.size()==1){
				for (int j = 0; j < submenuList.size(); j++) {
					ModuleMenu subModuleMenu = (ModuleMenu) submenuList.get(j);
					String submenuName = subModuleMenu.getMenuName();
					String submenuLink = subModuleMenu.getMenuLink();
					String submenuId = subModuleMenu.getModuleId();
					jsonM1 += "{\"title\": \""+menuName+"\",\"icon\": \""+strDate[menuTypeIndex]+"\",\"href\":\""+contextPath+submenuLink+"\",\"spread\": false},";
				}
			}else{
				for (int j = 0; j < submenuList.size(); j++) {
					ModuleMenu subModuleMenu = (ModuleMenu) submenuList.get(j);
					String submenuName = subModuleMenu.getMenuName();
					String submenuLink = subModuleMenu.getMenuLink();
					String submenuId = subModuleMenu.getModuleId();
					jsonM2 += "{\"title\": \""+submenuName+"\",\"icon\": \""+diDate[j]+"\",\"href\": \""+contextPath+submenuLink+"\",\"spread\": false},";
				}
				if(jsonM2.length()>0){
					jsonM2 = jsonM2.substring(0,jsonM2.length()-1);
				}
				jsonM1 += "{\"title\": \""+menuName+"\",\"icon\": \""+strDate[menuTypeIndex]+"\",\"href\": \"\",\"spread\": false,\"children\":["+jsonM2+"]},";
			}
		}
		if(jsonM1.length()>0){
			jsonM1 = jsonM1.substring(0,jsonM1.length()-1);
		}
		String dataJson ="{\"contentManagement\": ["+jsonM1+"]}";
		response.getWriter().write(dataJson);
	}
	
%>
