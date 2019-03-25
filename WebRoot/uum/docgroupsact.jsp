<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.commons.db.ConnectionProvider" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.commons.util.StringHelper" %>
<%@page import="com.kizsoft.commons.commons.util.UnidHelper" %>
<%@page import="java.io.StringReader" %>
<%@page import="java.sql.Connection" %>
<%@page import="java.sql.PreparedStatement" %>
<%@page import="java.sql.ResultSet" %>
<% request.setCharacterEncoding("UTF-8");
	//用户登陆验证
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
		//request.getRequestDispatcher("/login.jsp").forward(request,response);
	}
	User userInfo = (User) session.getAttribute("userInfo");
	String moduleID = null;
	String userID = userInfo.getUserId();
	Group groupInfo = userInfo.getGroup();
	String departmentID = groupInfo.getGroupId();%>
<%String action = StringHelper.isNull(request.getParameter("action")) ? "" : request.getParameter("action");
	String groupType = StringHelper.isNull(request.getParameter("grouptype")) ? "" : request.getParameter("grouptype");
	String groupTypeID = StringHelper.isNull(request.getParameter("grouptypeid")) ? "" : request.getParameter("grouptypeid");
	String groupUserID = StringHelper.isNull(request.getParameter("groupuserid")) ? "" : request.getParameter("groupuserid");
	String groupID = StringHelper.isNull(request.getParameter("groupid")) ? "" : request.getParameter("groupid");
	if (!StringHelper.isNull(action)) {
		if ("list".equals(action)) {
			if (!StringHelper.isNull(groupID)) {
				Connection conn = null;
				PreparedStatement stat = null;
				ResultSet rs = null;
				String sql = "select grouptype,grouptypeid from docgroup where creatorid='" + userID + "' and groupid='" + groupID + "' order by to_number(nvl(grouporder,'0')) desc,grouptypeid desc";
				String groupListStr = "";
				try {
					conn = ConnectionProvider.getConnection();
					stat = conn.prepareStatement(sql);
					rs = stat.executeQuery();
					while (rs.next()) {
						String rsGroupTypeID = rs.getString("grouptypeid");
						String rsGroupType = rs.getString("grouptype");
						groupListStr += "<a style=\"color:black;\" href=\"#\" onclick=\"select_group('" + rsGroupTypeID + "');\">" + rsGroupType + "</a>&nbsp;<b><font size=-2><a style=\"color:red;text-decoration:none\" href=\"#\" onclick=\"up_group('" + rsGroupTypeID + "');\">∧</a><a style=\"color:red;text-decoration:none\" href=\"#\" onclick=\"down_group('" + rsGroupTypeID + "');\">∨</a><a style=\"color:red;text-decoration:none\" href=\"#\" onclick=\"delete_group('" + rsGroupTypeID + "');\">×</a></font></b><br>";
					}
				} catch (Exception ex) {
					try {
						conn.rollback();
					} catch (Exception e) {}
				} finally {
					ConnectionProvider.close(conn, stat, rs);
				}
				out.print(groupListStr);
			}
		} else if ("select".equals(action)) {
			if (!StringHelper.isNull(groupTypeID)) {
				Connection conn = null;
				PreparedStatement stat = null;
				ResultSet rs = null;
				String sql = "select * from docgroup where grouptypeid='" + groupTypeID + "' and creatorid='" + userID + "' order by grouptypeid desc";
				try {
					conn = ConnectionProvider.getConnection();
					stat = conn.prepareStatement(sql);
					rs = stat.executeQuery();
					if (rs.next()) {
						out.print(rs.getString("groupuserid"));
					}
				} catch (Exception ex) {
					try {
						conn.rollback();
					} catch (Exception e) {}
				} finally {
					ConnectionProvider.close(conn, stat, rs);
				}
			}
		} else if ("insert".equals(action)) {
			if (!StringHelper.isNull(groupType) && !StringHelper.isNull(groupID)) {
				Connection conn = null;
				PreparedStatement stat = null;
				ResultSet rs = null;
				String sql = "insert into docgroup(grouptypeid,grouptype,groupuserid,creatorid,groupid,grouporder) values(?,?,?,?,?,?)";
				try {
					conn = ConnectionProvider.getConnection();
					stat = conn.prepareStatement(sql);
					stat.setString(1, "docgroup" + String.valueOf(UnidHelper.getUnid("SEQ_DOCGROUP") + 100000000L));
					stat.setString(2, groupType);
					StringReader rd = new StringReader(groupUserID);
					stat.setCharacterStream(3, rd, groupUserID.length());
					stat.setString(4, userID);
					stat.setString(5, groupID);
					stat.setString(6, "0");
					stat.executeUpdate();
					conn.commit();
					out.print("success");
				} catch (Exception ex) {
					System.out.println(ex);
					try {
						conn.rollback();
					} catch (Exception e) {System.out.println(e);}
				} finally {
					ConnectionProvider.close(conn, stat);
				}
			}
		} else if ("update".equals(action)) {
			if (!StringHelper.isNull(groupTypeID) && !StringHelper.isNull(groupType)) {
				Connection conn = null;
				PreparedStatement stat = null;
				ResultSet rs = null;
				String sql = "update docgroup set grouptype='" + groupType + "',groupuserid='" + groupUserID + "' where grouptypeid='" + groupTypeID + "'";
				try {
					conn = ConnectionProvider.getConnection();
					stat = conn.prepareStatement(sql);
					stat.executeUpdate();
					conn.commit();
					out.print("success");
				} catch (Exception ex) {
					try {
						conn.rollback();
					} catch (Exception e) {}
				} finally {
					ConnectionProvider.close(conn, stat);
				}
			}
		} else if ("delete".equals(action)) {
			if (!StringHelper.isNull(groupTypeID)) {
				Connection conn = null;
				PreparedStatement stat = null;
				String sql = "delete  from docgroup where grouptypeid='" + groupTypeID + "'";
				try {
					conn = ConnectionProvider.getConnection();
					stat = conn.prepareStatement(sql);
					stat.executeUpdate();
					conn.commit();
					out.print("success");
				} catch (Exception ex) {
					try {
						conn.rollback();
					} catch (Exception e) {}
				} finally {
					ConnectionProvider.close(conn, stat);
				}
			}
		} else if ("up".equals(action)) {
			if (!StringHelper.isNull(groupTypeID)) {
				Connection conn = null;
				PreparedStatement stat = null;
				ResultSet rs = null;
				String sql = "update docgroup set grouporder = nvl(grouporder,'0') + '1' where grouptypeid='" + groupTypeID + "'";
				try {
					conn = ConnectionProvider.getConnection();
					stat = conn.prepareStatement(sql);
					stat.executeUpdate();
					conn.commit();
					out.print("success");
				} catch (Exception ex) {
					try {
						conn.rollback();
					} catch (Exception e) {}
				} finally {
					ConnectionProvider.close(conn, stat);
				}
			}
		} else if ("down".equals(action)) {
			if (!StringHelper.isNull(groupTypeID)) {
				Connection conn = null;
				PreparedStatement stat = null;
				ResultSet rs = null;
				String sql = "update docgroup set grouporder = nvl(grouporder,'0') - '1' where grouptypeid='" + groupTypeID + "'";
				try {
					conn = ConnectionProvider.getConnection();
					stat = conn.prepareStatement(sql);
					stat.executeUpdate();
					conn.commit();
					out.print("success");
				} catch (Exception ex) {
					try {
						conn.rollback();
					} catch (Exception e) {}
				} finally {
					ConnectionProvider.close(conn, stat);
				}
			}
		}
	}%>
<!--索思奇智版权所有-->