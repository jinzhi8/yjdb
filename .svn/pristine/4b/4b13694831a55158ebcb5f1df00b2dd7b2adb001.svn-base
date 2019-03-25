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
	//列表
	if("list".equals(action)) {
		//分页
		int pagea = Integer.valueOf(request.getParameter("page"));
		int limit = Integer.valueOf(request.getParameter("limit"));
		int start = (pagea-1)*limit+1;
		int end = pagea*limit;
		
		String sizeSql = "select count(o.id) from owner o, ownerrelation oo where o.id = oo.ownerid and oo.parentid = ? and o.flag = '1'";
		String sql = "select * from (select o.id,o.status,o.ownercode,o.ownername,o.position,o.phoneshort,o.mobile,o.phone, rownum rn, (select to_char(wm_concat(rolename)) from aclrole where roleid in (select a.roleid from ACLUSERROLE a where a.userid = o.id)) roles ";
		sql += "from owner o, ownerrelation oo where o.id = oo.ownerid and oo.parentid = ? and o.flag = '1' order by oo.orderid) where rn between " + start + " and " + end;
		
		String parentid = request.getParameter("parentid");
		List list = db.queryForMap(sql, new Object[]{parentid});
		int size = db.queryForInt(sizeSql, new Object[]{parentid});
		
		//System.out.println(GsonHelp.toJson(list));
		String json ="{\"code\":0,\"msg\":\"\",\"count\":"+size+",\"data\":"+GsonHelp.toJson(list)+"}";
		response.getWriter().write(json);
	}
	//查询
	if("select".equals(action)) {
		//分页
		int pagea = Integer.valueOf(request.getParameter("page"));
		int limit = Integer.valueOf(request.getParameter("limit"));
		int start = (pagea-1)*limit+1;
		int end = pagea*limit;
		
		String sizeSql = "select count(o.id) from owner o, ownerrelation oo where o.id = oo.ownerid and oo.parentid = ? and o.ownername like ? and o.ownercode like ? and o.flag = '1'";
		String sql = "select * from (select o.id,o.status,o.ownercode,o.ownername,o.position,o.phoneshort,o.mobile,o.phone, rownum rn, (select to_char(wm_concat(rolename)) from aclrole where roleid in (select a.roleid from ACLUSERROLE a where a.userid = o.id)) roles ";
		sql += "from owner o, ownerrelation oo where o.id = oo.ownerid and oo.parentid = ? and o.flag = '1' and o.ownername like ? and o.ownercode like ? order by oo.orderid) where rn between " + start + " and " + end;
		
		String parentid = request.getParameter("parentid");
		String ownername = "%" + request.getParameter("ownername") + "%";
		String ownercode = "%" + request.getParameter("ownercode") + "%";
		//System.out.println(ownername+"_"+ownercode+"_"+parentid);
		List list = db.queryForMap(sql, new Object[]{parentid, ownername, ownercode});
		int size = db.queryForInt(sizeSql, new Object[]{parentid, ownername, ownercode});
		
		//System.out.println(GsonHelp.toJson(list));
		String json ="{\"code\":0,\"msg\":\"\",\"count\":"+size+",\"data\":"+GsonHelp.toJson(list)+"}";
		response.getWriter().write(json);
	}
	
	
%>

