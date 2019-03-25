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
	if("tree".equals(action)) {
		List<Map<String, Object>> lista = db.queryForMap("select b.ownerid \"value\",(select ownername from owner o where o.id = b.ownerid) \"title\" from ownerrelation b where parentid is null", null);
		/*for(int i = 0; i < lista.size(); i++) {
			Map<String, Object> map = lista.get(i);
			Map<String, Object> mapChild = new HashMap<String, Object>();
			List<Map<String, Object>> listChild = db.queryForMap("select a.id \"value\",a.ownername \"title\" from owner a where a.id in (select o.ownerid from ownerrelation o where o.parentid = ? and a.flag <> 1)", map.get("value"));
			for(int j = 0; j< listChild.size(); j++) {
				Map<String, Object> mapChildd = listChild.get(j);
				List<Map<String, Object>> listChildd = db.queryForMap("select a.id \"value\",a.ownername \"title\" from owner a where a.id in (select o.ownerid from ownerrelation o where o.parentid = ? and a.flag <> 1)", map.get("value"));
				mapChildd.put("data", listChildd);
			}
			map.put("data", listChild);
		}*/
		List<Map<String, Object>> listb = new ArrayList<Map<String, Object>>();
		for(int i = 0; i < lista.size(); i++) {
			Map<String, Object> map = lista.get(i);
			List<Map<String, Object>> listChild = db.queryForMap("select a.id \"value\",a.ownername \"title\" from owner a where a.id in (select o.ownerid from ownerrelation o where o.parentid = ? and a.flag <> 1)", map.get("value"));
			for(int j = 0; j < listChild.size(); j++) {
				Map<String, Object> mapChildd = listChild.get(j);
				mapChildd.put("data", listb);
			}
			map.put("data", listChild);
		}
		System.out.println(GsonHelp.toJson(lista));
		response.getWriter().write(GsonHelp.toJson(lista));
	}
	if("getUserChild".equals(action)) {
		String id = request.getParameter("id");
		Owner currentowner = UUMContend.getUUMService().getOwnerByOwnerid(id);
		String sql = "select a.ownercode,a.id,a.ownername,(select parentid from ownerrelation where ownerid = a.id) parentid,a.status,a.position,a.mobile,a.phone,a.password,a.phoneshort,(select to_char(wm_concat(rolename)) from ACLROLE where ROLEID in(select roleid from ACLUSERROLE t where t.USERID=a.id)) as roles from owner a where a.id in (select ownerid from ownerrelation where parentid = ?) and a.flag = '1'";
		List<Map<String, Object>> ll = db.queryForMap(sql, id);
		request.setAttribute("currentowner", currentowner);
		request.setAttribute("ll", ll);
		request.getRequestDispatcher("childowner.jsp").forward(request,response);
		return;
	}
	
%>

