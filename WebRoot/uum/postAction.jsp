<%@page import="com.kizsoft.commons.uum.pojo.Role"%>
<%@page import="com.kizsoft.commons.uum.pojo.Ownerrelation"%>
<%@page import="com.kizsoft.commons.commons.util.StringHelper"%>
<%@page import="com.kizsoft.commons.commons.user.UserManagerFactory"%>
<%@page import="com.kizsoft.commons.commons.user.UserManager"%>
<%@page import="com.kizsoft.oa.supervise.servlets.formAction"%>
<%@page import="com.kizsoft.commons.uum.actions.Pagination"%>
<%@page import="com.kizsoft.commons.uum.pojo.Owner"%>
<%@page import="com.kizsoft.commons.uum.utils.UUMConf"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.kizsoft.oa.wzbwsq.util.GsonHelp"%>
<%@page import="java.util.Map"%>
<%@page import="com.kizsoft.commons.commons.orm.MyDBUtils"%>
<%@page import="java.util.List"%>
<%@page import="com.kizsoft.commons.uum.service.IUUMService"%>
<%@page import="com.kizsoft.commons.uum.utils.UUMContend"%>
<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@ page import="com.kizsoft.commons.commons.user.User" %>
<%	
	String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
	User userInfo = (User) session.getAttribute("userInfo");
	if (userInfo == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
		return;
	}
	String action = request.getParameter("action");
	MyDBUtils db = new MyDBUtils();
	IUUMService uumService = UUMContend.getUUMService();
	UserManager userManager = UserManagerFactory.getUserManager();
	//System.out.println(action);
	//人事调入界面
	if("init".equals(action)) {
		String parentid = request.getParameter("deptid");
		Owner owner = uumService.getOwnerByOwnerid(parentid);
		request.setAttribute("owner", owner);
		request.getRequestDispatcher("post.jsp").forward(request,response);
		return;
	}
	//新增
	if("save".equals(action)) {
        Role role = new Role();
        role.setParentid(request.getParameter("parentid"));
        role.setRolename(request.getParameter("rolename"));
        role.setDescription(request.getParameter("description"));
        uumService.newRole(role);
	}
	//列表
	if("list".equals(action)) {
		List list = uumService.getRoleListByDeptId(request.getParameter("parentid"));
		Role role;
		List ownerlist;
		for(int i = 0; i < list.size(); i++) {
            role = (Role)list.get(i);
            ownerlist = uumService.getOwnerListByRoleId(role.getId());
            if (ownerlist.size() > 0) {
                role.setOwnerid(((Owner)ownerlist.get(0)).getId());
                role.setOwnername(((Owner)ownerlist.get(0)).getOwnername());
            }
        }
		String json ="{\"code\":0,\"msg\":\"\",\"count\":"+list.size()+",\"data\":"+GsonHelp.toJson(list)+"}";
		//System.out.println(json);
		response.getWriter().write(json);
	}
	//更改
	if("update".equals(action)) {
		 Role role = new Role();
	     role.setId(request.getParameter("id"));
	     role.setParentid(request.getParameter("parentid"));
	     role.setRolename(request.getParameter("rolename"));
	     role.setDescription(request.getParameter("desc"));
	     uumService.updateRole(role);
	}
	//删除
	if("del".equals(action)) {
		List list = new ArrayList();
		list.add(request.getParameter("id"));
		uumService.deleteRole(list);
	}
	//撤销之位
	if("resetRole".equals(action)) {
		String id = request.getParameter("id");
		uumService.deleteRoleRelationByRoleId(id);
	}
%>

