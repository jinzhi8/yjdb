<%@page import="com.kizsoft.commons.commons.orm.MyDBUtils"%>
<%@page import="com.kizsoft.commons.commons.user.Group"%>
<%@page import="com.kizsoft.commons.commons.user.User"%>
<%@page import="com.kizsoft.yjdb.utils.CommonUtil"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.kizsoft.yjdb.utils.GsonHelp" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.UUID" %>
<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%
	//获取登录人信息
    User userInfo = (User) session.getAttribute("userInfo");
    String app= CommonUtil.doStr(request.getParameter("app"));
	String userID ="";
	String userName = "";
	String groupName ="";
	String groupID = "";
	if("app".equals(app)){
		userID = CommonUtil.doStr(request.getParameter("userID"));
	}else{
		if (session.getAttribute("userInfo") == null) {
			response.sendRedirect(request.getContextPath() + "/login.jsp");
			return;
		}
		Group groupInfo = userInfo.getGroup();
		userID = userInfo.getUserId();
		userName = userInfo.getUsername();
		groupName = groupInfo.getGroupname();
		groupID = groupInfo.getGroupId();
	}
	String status=request.getParameter("status");
    //获得table数据
	if("getList".equals(status)) {
	    String ownername = CommonUtil.doStr(request.getParameter("ownername"));
	    String sql = "select o.id,o.ownername,s.*,(select(select to_char(wm_concat(owner.ownername)) from owner where instr(yj_ms.msids,owner.id) > 0) from yj_ms where yj_ms.id = o.id) mss from owner o join ownerrelation oo on o.id = oo.ownerid left join yj_ms s on o.id = s.id where oo.parentid = '1000256375' ";
	    if(!"".equals(ownername)) {
	        sql += " and o.ownername like '%'||'"+ ownername +"'||'%' ";
        }
	    sql += " order by oo.orderid ";
        List<Map<String, Object>> list = MyDBUtils.queryForMapToUC(sql);

        out.print("{\"code\":0,\"msg\":\"\",\"count\":"+ list.size() +",\"data\":"+ GsonHelp.toJson(list) +"}");
        return;
    }
    //修改或者存入
    if("updateOrInsertMs".equals(status)) {
        String id = request.getParameter("id");
        String msids = request.getParameter("msids");
        String psjbh = CommonUtil.doStr(request.getParameter("psjbh"));
        String hyjbh = CommonUtil.doStr(request.getParameter("hyjbh"));
        String xzrxjbh = CommonUtil.doStr(request.getParameter("xzrxjbh"));
        String lgzrjbh = CommonUtil.doStr(request.getParameter("lgzrjbh"));
        String qtjbh = CommonUtil.doStr(request.getParameter("qtjbh"));
        
        String lddbnumber = CommonUtil.doStr(request.getParameter("lddbnumber"));
        String hyjnumber = CommonUtil.doStr(request.getParameter("hyjnumber"));
        String qtjnumber = CommonUtil.doStr(request.getParameter("qtjnumber"));
        String xzrxjnumber = CommonUtil.doStr(request.getParameter("xzrxjnumber"));
        String lgzrjnumber = CommonUtil.doStr(request.getParameter("lgzrjnumber"));

        int code = 1;
        try {
            code = MyDBUtils.executeUpdate("update yj_ms set msids = ?,psjbh = ?,hyjbh=?,xzrxjbh=?,lgzrjbh=?,qtjbh=?,lddbnumber=?,hyjnumber=?,qtjnumber=?,xzrxjnumber=?,lgzrjnumber=? where id = ?",msids,psjbh,hyjbh,xzrxjbh,lgzrjbh,qtjbh,lddbnumber,hyjnumber,qtjnumber,xzrxjnumber,lgzrjnumber,id);
            if(code == 0) code = MyDBUtils.executeUpdate("insert into yj_ms(id,msids,psjbh,hyjbh,xzrxjbh,lgzrjbh,qtjbh) values(?,?,?,?,?,?,?)",id,msids,psjbh,hyjbh,xzrxjbh,lgzrjbh,qtjbh);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        out.print("{\"code\":"+ code +"}");
        return;
    }
%>
