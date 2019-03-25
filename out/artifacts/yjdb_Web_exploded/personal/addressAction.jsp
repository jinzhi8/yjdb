<%@page import="java.util.List"%>
<%@page import="java.util.Date"%>
<%@page import="com.kizsoft.oa.personal.PersonalAddressEntity"%>
<%@page import="com.kizsoft.oa.personal.PersonalAddressManager"%>
<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.common.bean.WebResult"%>
<%@page import="java.util.UUID"%>
<%@page import="com.kizsoft.oa.wzbwsq.util.GsonHelp"%>
<%@page import="com.kizsoft.commons.commons.orm.MyDBUtils"%>
<%@page import="java.util.ArrayList"%>

<%
	PersonalAddressManager messengerManager = new PersonalAddressManager();
	String action = request.getParameter("action");
	String userID = request.getParameter("userID");
	MyDBUtils db = new MyDBUtils();
	PersonalAddressEntity person = new PersonalAddressEntity();
	boolean b = false ;
	//获取
	if("lists".equals(action)){
		List list = (List) messengerManager.getUserPersonalAddressList(userID);
		String json ="{\"code\":0,\"msg\":\"\",\"count\":"+list.size()+",\"data\":"+GsonHelp.toJson(list)+"}";
		//System.out.println(json);
		response.getWriter().write(json);
	}
	//删除
	if("delete".equals(action)){
		String groupid = request.getParameter("groupid");
		int i = db.executeUpdate("delete from PERSONAL_ADDRESS where groupid = ?", new Object[]{groupid});
		if(i < 1) {
			out.println("{\"msg\": \"删除失败\"}");
		} else {
			out.println("{\"msg\": \"删除成功\"}");
		}
	}
	//编辑   修改
	if("save".equals(action)){
		String groupID = request.getParameter("groupID");
		String groupName = request.getParameter("groupName");
		String userNames = request.getParameter("userNames");
		String orderNum = request.getParameter("orderNum");
		String userids = request.getParameter("userids");
		
		//System.out.println(userids);
		
		person.setGroupID(groupID);
		person.setGroupName(groupName);
		person.setUserIDs(userids);
		person.setUserNames(userNames);
		person.setOrderNum(orderNum);
		person.setCreatorID(userID);
		person.setCreateTime(new Date());
		if(groupID != null){
			//修改
			messengerManager.updateUserPersonalAddress(person);
			//System.out.println(messId+"-"+messenger+"-"+orderId+"-"+userId);
		}else{
			//新增
			//System.out.println(GsonHelp.toJson(person));
			messengerManager.addUserPersonalAddress(person);
		}

	}
	
%>