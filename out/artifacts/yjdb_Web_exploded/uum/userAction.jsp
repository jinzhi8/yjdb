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
	if("import".equals(action)) {
		String deptid = request.getParameter("parentid");
		String usertype = request.getParameter("usertype");
		Owner currentowner = uumService.getOwnerByOwnerid(deptid);
		request.setAttribute("currentowner", currentowner);
		request.setAttribute("ut", usertype);
		request.getRequestDispatcher("import.jsp").forward(request,response);
		return;
	}
	//人事调入表格数据
	if("importList".equals(action)) {
		int pagea = Integer.valueOf(request.getParameter("page"));
		int limit = Integer.valueOf(request.getParameter("limit"));
		int start = (pagea-1) * limit + 1;
		int end = pagea * limit;
		int size = db.queryForInt("select count(u.ID) from owner u where  u.flag='1'");
		
		List<Map<String, Object>> list = db.queryForMap("select * from (select u.*,rownum rn from owner u where  u.flag='1') where rn between " + start + " and " +end, null);
		for(int i = 0; i < list.size(); i++) {
			Map<String, Object> map = list.get(i);
			String id = map.get("ID").toString();
			User user = userManager.findUser(id);
			String dw = user.getGroup().getOfficeName()+"（"+user.getGroup().getGroupname()+"）";
			map.put("dw", dw);
		}
		String json ="{\"code\":0,\"msg\":\"\",\"count\":"+ size +",\"data\":"+GsonHelp.toJson(list)+"}";
		//System.out.println(json);
		response.getWriter().write(json);
	}
	//人事调入查询
	if("importSelect".equals(action)) {
		String ownercode = "%"+request.getParameter("ownercode")+"%";
		String ownername = "%"+request.getParameter("ownername")+"%";
		
		int pagea = Integer.valueOf(request.getParameter("page"));
		int limit = Integer.valueOf(request.getParameter("limit"));
		int start = (pagea-1) * limit + 1;
		int end = pagea * limit;
		int size = db.queryForInt("select count(u.ID) from owner u where  u.flag='1' and u.ownercode like ? and u.ownername like ?", new Object[]{ownercode, ownername});
		
		//System.out.println(ownercode);
		List<Map<String, Object>> list = db.queryForMap("select * from (select u.*,rownum rn from owner u where  u.flag='1' and u.ownercode like ? and u.ownername like ?) where rn between " + start + " and "+ end, new Object[]{ownercode, ownername});
		for(int i = 0; i < list.size(); i++) {
			Map<String, Object> map = list.get(i);
			String id = map.get("ID").toString();
			User user = userManager.findUser(id);
			String dw = user.getGroup().getOfficeName()+"（"+user.getGroup().getGroupname()+"）";
			map.put("dw", dw);
		}
		String json ="{\"code\":0,\"msg\":\"\",\"count\":"+size+",\"data\":"+GsonHelp.toJson(list)+"}";
		//System.out.println(json);
		response.getWriter().write(json);
	}
	//人事调入保存
	if("importSave".equals(action)) {
	    String parentid = request.getParameter("parentid");
	    String chkid = request.getParameter("chkid");
		String[] uid = chkid.split(",");
	    int num = 0;
	    if (uid != null) {
	    	num = uid.length;
	    } else {
	      	return;
	    }
	    for (int i = 0; i < num; ++i) {
			//System.out.println(uid[i]);
	    	uumService.newRelation(parentid, uid[i]);
	    }
  	}
	//用户排序列表
	if("category".equals(action)) {
		String parentID = StringHelper.isNull(request.getParameter("pid")) ? "" : request.getParameter("pid");
		List<Map<String, Object>> list = null;
		if (!StringHelper.isNull(parentID)) {
			StringBuffer userList = new StringBuffer();

			String sql = "select t.ownerid,t1.ownercode,t1.ownername,t.orderid,decode(t1.type,'1','系统管理员','0','普通用户','2','部门管理员','部门') type from ownerrelation t,owner t1 where t.ownerid=t1.id";
			sql += " and t.parentid = ? ";
			sql += " order by t.orderid";
			
			list = db.queryForMap(sql, new Object[]{parentID});
		} else {
			StringBuffer userList = new StringBuffer();

			String sql = "select t.id,t.ownercode,t.ownername,t.order_num,decode(t.type,'1','系统管理员','0','普通用户','2','部门管理员','部门') type from owner t where t.flag='4'  order by t.order_num";
			
			list = db.queryForMap(sql, new Object[]{parentID});
		}
		
		String json ="{\"code\":0,\"msg\":\"\",\"count\":"+list.size()+",\"data\":"+GsonHelp.toJson(list)+"}";
		//System.out.println(json);
		response.getWriter().write(json);
  	}
	//用户排序
	if("categorySort".equals(action)) {
		int index = Integer.valueOf(request.getParameter("index"));
		String parentID = StringHelper.isNull(request.getParameter("pid")) ? "" : request.getParameter("pid");
		String dd = request.getParameter("dd");
		List<Map<String, Object>> list = null;
		if (!StringHelper.isNull(parentID)) {
			StringBuffer userList = new StringBuffer();

			String sql = "select t.ownerid,t1.ownercode,t1.ownername,t.orderid,decode(t1.type,'1','系统管理员','0','普通用户','2','部门管理员','部门') type from ownerrelation t,owner t1 where t.ownerid=t1.id";
			sql += " and t.parentid = ? ";
			sql += " order by t.orderid";
			
			list = db.queryForMap(sql, new Object[]{parentID});
		} else {
			StringBuffer userList = new StringBuffer();

			String sql = "select t.id,t.ownercode,t.ownername,t.order_num,decode(t.type,'1','系统管理员','0','普通用户','2','部门管理员','部门') type from owner t where t.flag='4'  order by t.order_num";
			
			list = db.queryForMap(sql, new Object[]{parentID});
		}
		//当前行ID,排序号
		Map<String, Object> map = list.get(index);
		String ownerid = map.get("OWNERID").toString();
		String orderid = map.get("ORDERID").toString();
		
		//判断上移或者下移
		Map<String, Object> mapDd = null;
		if("up".equals(dd)) {
			mapDd = list.get(index-1);
		}
		if("down".equals(dd)) {
			mapDd = list.get(index+1);
		}
		String ddOwnerid = mapDd.get("OWNERID").toString();
		String ddOrderid = mapDd.get("ORDERID").toString();
		String sql = "update ownerrelation set orderid = ? where ownerid = ?";
		
		//获得对象,更改
		db.executeUpdate(sql, new Object[]{ddOrderid, ownerid});
		
		//修改另一个对象
		db.executeUpdate(sql, new Object[]{orderid, ddOwnerid});
		//String json ="{\"code\":0,\"msg\":\"\",\"count\":"+list.size()+",\"data\":"+GsonHelp.toJson(list)+"}";
		//System.out.println(json);
		//response.getWriter().write(json);
  	}
	//单元格编辑保存
	if("categoryEdit".equals(action)){
		String ownerid = request.getParameter("ownerid");
		String orderid = request.getParameter("orderid");
		
		db.executeUpdate("update ownerrelation set orderid = ? where ownerid = ?", new Object[]{orderid, ownerid});
	}
	//用户排序编号操作
	if("categoryBh".equals(action)) {
		String parentid = request.getParameter("pid");
		String sql = "select t.ownerid,t1.ownercode,t1.ownername,t.orderid,decode(t1.type,'1','系统管理员','0','普通用户','2','部门管理员','部门') type from ownerrelation t,owner t1 where t.ownerid=t1.id";
		sql += " and t.parentid = ? ";
		sql += " order by t.orderid";
		List<Map<String, Object>> list = db.queryForMap(sql, new Object[]{parentid});
		Map<String, Object> map = null;
		for(int i = 0; i < list.size(); i++ ) {
			map = list.get(i);
			db.executeUpdate("update ownerrelation set orderid = ? where ownerid = ?", new Object[]{i+1, map.get("OWNERID").toString()});
		}
	}
	//删除
	if("deleteUser".equals(action)) {
	    String chkid = request.getParameter("chkid");
		String[] ids = chkid.split(",");
	    List list = new ArrayList();
	    for (int i = 0; i < ids.length; ++i) {
	      list.add(ids[i]);
	    }
	    boolean b = uumService.deleteOwnerByIds(list);
		out.print(b);
	}
	//人事调出
	if("swap".equals(action)) {
		String parentid = request.getParameter("pid");
		String chkid = request.getParameter("chkid");
		String[] ids = chkid.split(",");
	    for (int i = 0; i < ids.length; ++i) {
	        uumService.swapOwner(ids[i], parentid);
	    }
	}
	//获得角色
	if("getRoles".equals(action)){
//		List<Map<String, Object>> list = MyDBUtils.queryForMapToUC("select roleid code,rolename value from aclrole where rolecode <> 'sysadmin'");
		List<Map<String, Object>> list = MyDBUtils.queryForMapToUC("select roleid code,rolename value from aclrole");

		response.getWriter().print("{\"code\":0,\"data\":"+ GsonHelp.toJson(list) +"}");
		return;
	}
	
%>

