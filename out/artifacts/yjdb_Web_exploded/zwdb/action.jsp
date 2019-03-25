<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.commons.user.Group,com.kizsoft.commons.commons.user.User,com.kizsoft.commons.component.entity.FieldEntity,com.kizsoft.commons.uum.pojo.Owner,com.kizsoft.commons.uum.service.IUUMService" %>
<%@page import="com.kizsoft.commons.uum.utils.UUMContend" %>
<%@page import="com.kizsoft.oa.setting.beans.SettingInfo" %>
<%@page import="com.kizsoft.oa.setting.beans.SettingTypeManager" %>
<%@page import="java.sql.Connection" %>
<%@page import="java.sql.PreparedStatement" %>
<%@page import="java.sql.ResultSet" %>
<%@page import="com.kizsoft.commons.commons.db.ConnectionProvider" %>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<%@taglib prefix="html" uri="/WEB-INF/oa-html.tld" %>
<%@taglib prefix="oa" uri="/WEB-INF/oa.tld" %>

<%
    User userInfo = (User) session.getAttribute("userInfo");
	if (userInfo == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
		return;
	}
	String ids=request.getParameter("ids");
	Connection db = null;
	PreparedStatement ps = null;
	ResultSet rs=null;
	String value="";
	String depname="";
	if (ids != null && !"".equals(ids)) {
		String idList[] = ids.split(",");
		String unidList = "";
		String[] titleList=new String[idList.length];
		for (int i = 0; i < idList.length; i++) {
			if ("".equals(unidList)) {
				unidList = "'" + idList[i] + "'";
			} else {
				unidList += "," + "'" + idList[i] + "'";
			}
		}	
		try{
			db = ConnectionProvider.getConnection();	
			String sql = "select * from owner where id in ("+unidList+")";
			System.out.println(sql);
			ps = db.prepareStatement(sql);
			rs=ps.executeQuery();	
			while(rs.next()){
				depname=rs.getString("depname");
				if(value==""){				
					if(depname==null||"".equals(depname)){
						value=rs.getString("ownername");
					}else{
						value=depname;
					}				
				}else{
					if(depname==null||"".equals(depname)){
						value+=","+rs.getString("ownername");
					}else{
						value+=","+depname;
					}	
				}			
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			ConnectionProvider.close(db,ps,rs);
		}
		out.print(value);
	}
%>
