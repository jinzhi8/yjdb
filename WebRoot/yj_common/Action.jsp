<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.commons.orm.MyDBUtils"%>
<%@page import="java.util.*"%>
<%@page import="com.kizsoft.yjdb.utils.CommonUtil"%>
<%

	String status=CommonUtil.doStr(request.getParameter("status"));
	System.out.println(status);

	if(status.equals("scfj")){
		String unid=CommonUtil.doStr(request.getParameter("unid"));
		MyDBUtils.executeUpdate("delete from common_attachment where attachmentid=?",unid);
		String json = "{\"success\":true}";
		out.println(json);
	}
	if(status.equals("remove")){
		String fkid=CommonUtil.doStr(request.getParameter("fkid"));
		String unid=CommonUtil.doStr(request.getParameter("unid"));
		String moduleid=CommonUtil.doStr(request.getParameter("moduleid"));
		int i = 0;
		String json = "";		
		if("yj_hy".equals(moduleid)||"yj_lr".equals(moduleid)){
			try {
				MyDBUtils.executeUpdate("insert into yj_lr_hsz (select a.* from yj_lr a where a.unid=? or a.docunid=?)",unid,unid);
			}catch(Exception e){
			    e.printStackTrace();
			}
		}
		if(unid != "") {
			i = MyDBUtils.executeUpdate("delete from "+moduleid+" where unid = ?",unid); 			
		} else if(fkid != "") {
			i = MyDBUtils.executeUpdate("delete from "+moduleid+" where fkid = ?",fkid); 
		}
		if("yj_hy".equals(moduleid)){
			MyDBUtils.executeUpdate("delete from yj_lr where docunid = ?",unid); 
		}
		if(i > 0) {
			json = "{\"success\":true}";
		} else {
			json = "{\"success\":false}";
		}
		out.println(json);
	}
%>
