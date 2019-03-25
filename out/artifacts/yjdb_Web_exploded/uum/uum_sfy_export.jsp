<%@ page import="com.kizsoft.commons.commons.user.Group" %>
<%@ page import="com.kizsoft.commons.commons.user.User" %>
<%@ page import="com.kizsoft.commons.commons.user.UserException" %>
<%@ page import="com.kizsoft.oa.meeting.MeetingAgenda" %>
<%@ page import="com.kizsoft.oa.meeting.MeetingAgendaManager" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFCell" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFRow" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFSheet" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFWorkbook" %>
<%@ page import="java.io.OutputStream" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.kizsoft.commons.commons.util.StringHelper" %>
<%@ page import="com.kizsoft.commons.commons.util.Sql_Execute_Helper" %>
<%@ page import="org.apache.poi.hssf.util.Region" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFCellStyle" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFFont" %>
<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="java.sql.Connection" %>
<%@page import="java.sql.PreparedStatement" %>
<%@page import="java.sql.ResultSet" %>
<%@page import="com.kizsoft.commons.commons.db.ConnectionProvider" %>
<%@page import="com.kizsoft.commons.uum.pojo.Owner" %>
<%@page import="com.kizsoft.commons.uum.service.IUUMService" %>
<%@page import="com.kizsoft.commons.uum.utils.UUMContend" %>


<%--
  ~ Copyright (C) 2011-2012.索思奇智版权所有
  ~ @author 温政权
  ~ @version 1.0, 2012.
  --%>
  <%!
    
	   public  String  getDeptName (String ownerCode,String ownerID )
	   {
	   IUUMService uumService = UUMContend.getUUMService();
	    Group group = new Group();
        Owner groupUUM = uumService.getUserParentDept(ownerCode);
        group.setOfficeId(groupUUM.getId());
        group.setOfficeName(groupUUM.getOwnername());
        Owner subdepOwner = getParentByOwnerId(ownerID, "3");
        group.setSubDepartmentId(subdepOwner == null ? null : subdepOwner.getId());
        group.setSubDepartmentName(subdepOwner == null ? null : subdepOwner.getOwnername());
        Owner depOwner = getParentByOwnerId(ownerID, "4");
        group.setDepartmentId(depOwner == null ? null : depOwner.getId());
        group.setDepartmentName(depOwner == null ? null : depOwner.getOwnername());
        Owner orgOwner = getParentByOwnerId(ownerID, "5");
        group.setOrganizationId(orgOwner == null ? null : orgOwner.getId());
        group.setOrganizationName(orgOwner == null ? null : orgOwner.getOwnername());
        group.setGroupId(group.getSubDepartmentId() == null ? group.getDepartmentId() : group.getDepartmentId() == null ? group.getOfficeId() : group.getSubDepartmentId());
        group.setGroupname(group.getSubDepartmentName() == null ? group.getDepartmentName() : group.getDepartmentName() == null ? group.getOfficeName() : group.getDepartmentName());
		
		return group.getGroupname();
	 }
	 
	  public  String  getRoleName (String roleCode )
	   {
	     String roleName="";
	     
	     if("oa_document_rece_unit".equals(roleCode))
		    {roleName="单位接收员";}
		else {
		  roleName="单位发送员";
		}	
		
		return roleName;
	 }
     
  
    public Owner getParentByOwnerId(String ownerId, String level) {
    String sql = "select t1.* from (select level lv,t.ownerid from ownerrelation t start with t.ownerid = ? CONNECT BY PRIOR t.parentid = t.ownerid) t1,owner t2 where t1.ownerid=t2.id and t2.flag=?";
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    IUUMService uumService = UUMContend.getUUMService();
    Owner owner = null;
    try
    {
      conn = ConnectionProvider.getConnection();
      pstmt = conn.prepareStatement(sql);
      pstmt.setString(1, ownerId);
      pstmt.setString(2, level);
      rs = pstmt.executeQuery();
      if (rs.next())
      {
        owner = uumService.getOwnerByOwnerid(rs.getString("ownerid"));
      }
    }
    catch (Exception e)
    {
      e.printStackTrace();
      return null;
    }
    finally
    {
      ConnectionProvider.close(conn, pstmt, rs);
    }
    return owner;
  }
  
  
  %>

<%
	String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
	User userInfo = (User) session.getAttribute("userInfo");
	if (userInfo == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
		return;
	}
	String userID = userInfo.getUserId();
	String userName = userInfo.getUsername();
	Group groupInfo = null;
	try {
		groupInfo = userInfo.getGroup();
	} catch (UserException e) {
		e.printStackTrace();
	}
	String groupID = groupInfo != null ? groupInfo.getGroupId() : "";
	String groupName = groupInfo != null ? groupInfo.getGroupname() : "";
	//String type = request.getParameter("type");
	//String unid = request.getParameter("id");
	Connection db = null;
    PreparedStatement stat = null;
    ResultSet rs = null;
	db = ConnectionProvider.getConnection();
	HSSFWorkbook workbook = new HSSFWorkbook();
	HSSFSheet sheet = workbook.createSheet();
	HSSFRow row;
	HSSFCell cell;
	int count=1;
	String sql="";
	 try {
                sql = "select t.*,b.rolecode from owner t, acluroleuser b where t.id=b.userid and ( b.rolecode like 'oa_document_rece_unit' or b.rolecode like 'oa_document_send_unit') ";
                stat = db.prepareStatement(sql);
                rs = stat.executeQuery();
				
		row = sheet.createRow(0);
		//合并4个单元格
		sheet.addMergedRegion(new Region(0,(short)0,0,(short)4));

		HSSFRow rowT = sheet.createRow(0);
		HSSFCell cellT = rowT.createCell((short)0);
		HSSFCellStyle cellStyle = workbook.createCellStyle();
		//cellStyle.setBorderBottom((short) 1);
		//cellStyle.setBorderLeft((short) 1);
		//cellStyle.setBorderRight((short) 1);
		//cellStyle.setBorderTop((short) 1);
		//cellStyle.setBottomBorderColor((short) 64);
		cellStyle.setAlignment((short) 2);
		cellStyle.setVerticalAlignment((short) 2);
		HSSFFont font = workbook.createFont();
		font.setFontName("黑体");
		font.setFontName("仿宋_GB2312");
		font.setFontHeightInPoints((short) 18);//设置字体大小
		font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		font.setFontHeightInPoints((short) 18);
		cellStyle.setFont(font);//选择需要用到的字体格式
		cellT.setCellStyle(cellStyle);
		cellT.setCellValue("龙湾单位接收员");
		row = sheet.createRow(1);
		cell = row.createCell((short) 0);
		cell.setCellType(HSSFCell.CELL_TYPE_STRING);
		cell.setCellValue("单位");
		sheet.setColumnWidth(0, 6000);
		cell = row.createCell((short) 1);
		cell.setCellType(HSSFCell.CELL_TYPE_STRING);
		cell.setCellValue("姓名");
		sheet.setColumnWidth(1, 3000);
		cell = row.createCell((short) 2);
		cell.setCellType(HSSFCell.CELL_TYPE_STRING);
		cell.setCellValue("职务");
		sheet.setColumnWidth(2, 7000);
		cell = row.createCell((short) 3);
		cell.setCellType(HSSFCell.CELL_TYPE_STRING);
		cell.setCellValue("联系方式");
		sheet.setColumnWidth(3, 3000);
		cell = row.createCell((short) 4);
		cell.setCellType(HSSFCell.CELL_TYPE_STRING);
		cell.setCellValue("角色");
		sheet.setColumnWidth(4, 5000);
		/*cell = row.createCell((short) 5);
		cell.setCellType(HSSFCell.CELL_TYPE_STRING);
		cell.setCellValue("序号");*/
		
		while (rs.next()) {
			row = sheet.createRow(count+1);
			cell = row.createCell((short) 0);
			cell.setCellType(HSSFCell.CELL_TYPE_STRING);
			cell.setCellValue(StringHelper.trim(getDeptName(rs.getString("ownercode"),rs.getString("id"))));
			cell = row.createCell((short) 1);
			cell.setCellType(HSSFCell.CELL_TYPE_STRING);
			cell.setCellValue(StringHelper.trim(rs.getString("ownername")));
			cell = row.createCell((short) 2);
			cell.setCellType(HSSFCell.CELL_TYPE_STRING);
			cell.setCellValue(StringHelper.trim(rs.getString("position")));
			cell = row.createCell((short) 3);
			cell.setCellType(HSSFCell.CELL_TYPE_STRING);
			cell.setCellValue(StringHelper.trim(rs.getString("phone")));
			cell = row.createCell((short) 4);
			cell.setCellType(HSSFCell.CELL_TYPE_STRING);
			cell.setCellValue(StringHelper.trim( getRoleName(rs.getString("rolecode"))));	
            count++;			
				 }
				 
				 
				 
				 
		    } catch (Exception e) {
                e.printStackTrace();
            } finally {
                ConnectionProvider.close(null, stat, rs);
            }
			

			
	out.print("</table>");
	response.reset();
	response.setContentType("octets/stream");
	response.addHeader("Content-Disposition", "attachment;filename=test.xls");
	try {
		OutputStream os = response.getOutputStream();
		response.setHeader("Content-disposition", "attachment;filename=" + URLEncoder.encode("龙湾发送员.xls", "UTF-8"));
		response.setContentType("application/msexcel;charset=UTF-8");
		workbook.write(os);
		os.close();
	} catch (Exception e) {

	}

%>
<!--索思奇智版权所有-->