<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.oreilly.servlet.MultipartRequest" %>
<%@page import="com.oreilly.servlet.UploadedFile" %>
<%@page import="com.oreilly.servlet.multipart.RandomFileRenamePolicy" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.List" %>
<%@page import="com.kizsoft.commons.commons.orm.SimpleORMUtils"%>
<%@page import="java.util.Date" %>
<%@page import="java.util.Enumeration" %>
<%@page import="java.sql.Connection" %>
<%@page import="java.sql.PreparedStatement" %>
<%@page import="java.sql.ResultSet" %>
<%@page import="java.text.ParseException" %>
<%@page import="com.kizsoft.commons.commons.db.ConnectionProvider" %>
<%@page import="com.kizsoft.commons.util.UUIDGenerator" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="net.sf.json.JSONArray" %>
<%@page import="net.sf.json.JSONObject" %>
<%
	User userInfo = (User) session.getAttribute("userInfo");
    if (userInfo == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    String userID = userInfo.getUserId();
    Group groupInfo = userInfo.getGroup();
    String groupID = groupInfo.getGroupId();
    String userName = userInfo.getUsername();
    String depName = groupInfo.getGroupname();
    String require=request.getParameter("require");
    String status=request.getParameter("status");
    String check=request.getParameter("check");
    String unid=request.getParameter("unid");
    String lxr=request.getParameter("lxr");
    String lxdh=request.getParameter("lxdh");
    
    if(status.equals("1")){
	        Connection conn=null;
			PreparedStatement ps=null;
			ResultSet rs=null;
			try{
				String sql="insert into ZWDB_MESSAGE(unid,userid,username,dbmessage,time) values(?,?,?,?,sysdate)";
				conn=ConnectionProvider.getConnection();
				ps=conn.prepareStatement(sql);
				ps.setString(1,UUIDGenerator.getUUID());
				ps.setString(2,userID);
				ps.setString(3,userName);
				ps.setString(4,require);
       			ps.executeUpdate();
			}catch(Exception e){
				e.printStackTrace();
			}finally{
				ConnectionProvider.close(conn,ps,rs);
			}
		}
	else if(status.equals("2")){
		Connection conn=null;
		PreparedStatement ps=null;
		ResultSet rs=null;
		try{
			String sql="insert into zwdb_dxyy(unid,dbid,name,phone,content,time,userid,username,state) values(?,?,?,?,?,sysdate,?,?,?)";
			conn=ConnectionProvider.getConnection();
			ps=conn.prepareStatement(sql);
			ps.setString(1,UUIDGenerator.getUUID());
			ps.setString(2,unid);
			ps.setString(3,lxr);
			ps.setString(4,lxdh);
			ps.setString(5,require);
			ps.setString(6,userID);
			ps.setString(7,userName);
			ps.setString(8,check);
       		ps.executeUpdate();
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			ConnectionProvider.close(conn,ps,rs);
		}
	}		
	out.print("ok");
%>
