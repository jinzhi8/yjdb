<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.common.bean.WebResult"%>
<%@page import="com.kizsoft.oa.personal.PersonalForm"%>
<%@page import="java.util.UUID"%>
<%@page import="com.kizsoft.yjdb.utils.GsonHelp"%>
<%@page import="com.kizsoft.commons.commons.orm.MyDBUtils"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.kizsoft.oa.personal.Messengerdata"%>

<%

	String action = request.getParameter("action");
	String userId = request.getParameter("userId");
	PersonalForm person = new PersonalForm();
	Messengerdata messengerManager = new Messengerdata();
	boolean b = false ;
	//获取
	if("lists".equals(action)){
		ArrayList list = (ArrayList) messengerManager.selMdata(userId);
		String json ="{\"code\":0,\"msg\":\"\",\"count\":"+list.size()+",\"data\":"+GsonHelp.toJson(list)+"}";
		response.getWriter().write(json);
	}
	//删除
	if("delete".equals(action)){
		String messId = request.getParameter("messId");
		b = messengerManager.delMdata(messId);
		if(b){
			response.getWriter().write("success");
		}else{
			response.getWriter().write("false");
		}
	}
	//编辑   修改
	if("save".equals(action)){
		String messId = request.getParameter("messId");
		String messenger = request.getParameter("messenger");
		String orderId = request.getParameter("orderId");
		if(messId != null){
			person.setUserId(userId);
			person.setMessenger(messenger);
			person.setOrderId(orderId);
			person.setMessId(messId);
			//System.out.println(messId+"-"+messenger+"-"+orderId+"-"+userId);
			b = messengerManager.upMdata(person);
		}else{
			person.setUserId(userId);
			person.setMessenger(messenger);
			b = messengerManager.insertMdata(person);
		}
		if(b){
			response.getWriter().write("success");
		}else{
			response.getWriter().write("false");
		}

	}
	
%>