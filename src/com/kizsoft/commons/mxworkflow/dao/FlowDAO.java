package com.kizsoft.commons.mxworkflow.dao;

import com.kizsoft.commons.Constant;
import com.kizsoft.commons.acl.ACLManager;
import com.kizsoft.commons.acl.ACLManagerFactory;
import com.kizsoft.commons.acl.pojo.Aclrole;
import com.kizsoft.commons.acl.service.IACLService;
import com.kizsoft.commons.acl.utils.ACLContend;
import com.kizsoft.commons.commons.db.ConnectionProvider;
import com.kizsoft.commons.commons.util.UnidHelper;
import com.kizsoft.commons.mxworkflow.bean.FlowAttribute;
import com.kizsoft.commons.util.UUIDGenerator;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collection;

public class FlowDAO {
	public FlowAttribute getFlow(String flowID) {
		FlowAttribute flow = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = ConnectionProvider.getConnection();
			String sql = "SELECT * FROM flow_info WHERE flow_id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, flowID);

			rs = pstmt.executeQuery();
			if (rs.next()) {
				flow = new FlowAttribute();
				flow.setFlowId(flowID);
				flow.setFlowName(rs.getString("FLOW_NAME"));
				flow.setModuleId(rs.getString("MODULE_ID"));
				flow.setApplicationId(rs.getString("APPLICATION_ID"));
				flow.setAdministrator(rs.getString("ADMINISTRATOR"));
				flow.setDescription(rs.getString("DESCRIPTION"));
				flow.setCreator(rs.getString("CREATOR"));
				flow.setCreateTime(rs.getDate("CREATE_TIME"));
				flow.setFlowActor(rs.getString("FLOW_ACTOR"));
				flow.setFlowType(rs.getString("FLOW_TYPE"));
				flow.setFlowOrder(new Long(rs.getLong("FLOW_ORDER")));
				flow.setFlowStatus(rs.getString("FLOW_STATUS"));
				flow.setFlowRangeName(rs.getString("FLOWRANGENAME"));
				flow.setFlowRange(rs.getString("FLOWRANGE"));
			}
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
			ConnectionProvider.close(conn, pstmt, rs);
		}
		return flow;
	}

	public FlowAttribute getFlowByMemo(String memo) {
		FlowAttribute flow = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = ConnectionProvider.getConnection();
			String sql = "SELECT * FROM flow_info WHERE description = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, memo);

			rs = pstmt.executeQuery();
			if (rs.next()) {
				flow = new FlowAttribute();

				flow.setFlowId(rs.getString("FLOW_ID"));
				flow.setFlowName(rs.getString("FLOW_NAME"));
				flow.setModuleId(rs.getString("MODULE_ID"));
				flow.setApplicationId(rs.getString("APPLICATION_ID"));
				flow.setAdministrator(rs.getString("ADMINISTRATOR"));
				flow.setDescription(rs.getString("DESCRIPTION"));
				flow.setCreator(rs.getString("CREATOR"));
				flow.setCreateTime(rs.getDate("CREATE_TIME"));
				flow.setFlowActor(rs.getString("FLOW_ACTOR"));
				flow.setFlowType(rs.getString("FLOW_TYPE"));
				flow.setFlowOrder(new Long(rs.getLong("FLOW_ORDER")));
				flow.setFlowStatus(rs.getString("FLOW_STATUS"));
				flow.setFlowRangeName(rs.getString("FLOWRANGENAME"));
				flow.setFlowRange(rs.getString("FLOWRANGE"));
			}
		} catch (SQLException ex) {
			
		} finally {
			ConnectionProvider.close(conn, pstmt, rs);
		}
		return flow;
	}

	public Collection getFlowList(String userID) {
		ArrayList flowList = new ArrayList();
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		String sql = "SELECT flow_id,flow_name FROM flow_info order by flow_order";
		ACLManager aclManager = ACLManagerFactory.getACLManager();
		sql = aclManager.getACLSql(sql, "flow_id", userID);
		try {
			conn = ConnectionProvider.getConnection();

			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			while (rs.next()) {
				FlowAttribute flow = new FlowAttribute();

				flow.setFlowId(rs.getString("flow_id"));
				flow.setFlowName(rs.getString("flow_name"));
				flowList.add(flow);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			ConnectionProvider.close(conn, stmt, rs);
		}
		return flowList;
	}

	public Collection getFlowList(String userID, String moduleId){
		ArrayList flowList = new ArrayList();
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;

		String sql = "SELECT * FROM flow_info WHERE module_id = '" + moduleId
				+ "' order by flow_order";
		ACLManager aclManager = ACLManagerFactory.getACLManager();
		sql = aclManager.getACLSql(sql, "flow_id", userID);
		try {
			conn = ConnectionProvider.getConnection();
			stmt = conn.createStatement();

			rs = stmt.executeQuery(sql);
			while (rs.next()) {
				FlowAttribute flow = new FlowAttribute();

				flow.setFlowId(rs.getString("FLOW_ID"));
				flow.setFlowName(rs.getString("FLOW_NAME"));
				flow.setModuleId(rs.getString("MODULE_ID"));
				flow.setApplicationId(rs.getString("APPLICATION_ID"));
				flow.setAdministrator(rs.getString("ADMINISTRATOR"));
				flow.setDescription(rs.getString("DESCRIPTION"));
				flow.setCreator(rs.getString("CREATOR"));
				flow.setCreateTime(rs.getDate("CREATE_TIME"));
				flow.setFlowActor(rs.getString("FLOW_ACTOR"));
				flow.setFlowType(rs.getString("FLOW_TYPE"));
				flow.setFlowOrder(new Long(rs.getLong("FLOW_ORDER")));
				flow.setFlowStatus(rs.getString("FLOW_STATUS"));
				flow.setFlowRangeName(rs.getString("FLOWRANGENAME"));
				flow.setFlowRange(rs.getString("FLOWRANGE"));

				flowList.add(flow);
			}
		} catch (Exception ex) {
			
		} finally {
			ConnectionProvider.close(conn, stmt, rs);
		}
		return flowList;
	}

	public Collection getSubFlowList(String userID, String moduleId) {
		ArrayList flowList = new ArrayList();
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;

		String sql = "SELECT * FROM flow_info WHERE module_id = '" + moduleId
				+ "' AND flow_type='subflow'";
		ACLManager aclManager = ACLManagerFactory.getACLManager();
		sql = aclManager.getACLSql(sql, "flow_id", userID);
		try {
			conn = ConnectionProvider.getConnection();
			stmt = conn.createStatement();

			rs = stmt.executeQuery(sql);
			while (rs.next()) {
				FlowAttribute flow = new FlowAttribute();

				flow.setFlowId(rs.getString("FLOW_ID"));
				flow.setFlowName(rs.getString("FLOW_NAME"));
				flow.setModuleId(rs.getString("MODULE_ID"));
				flow.setApplicationId(rs.getString("APPLICATION_ID"));
				flow.setAdministrator(rs.getString("ADMINISTRATOR"));
				flow.setDescription(rs.getString("DESCRIPTION"));
				flow.setCreator(rs.getString("CREATOR"));
				flow.setCreateTime(rs.getDate("CREATE_TIME"));
				flow.setFlowActor(rs.getString("FLOW_ACTOR"));
				flow.setFlowType(rs.getString("FLOW_TYPE"));
				flow.setFlowOrder(new Long(rs.getLong("FLOW_ORDER")));
				flow.setFlowStatus(rs.getString("FLOW_STATUS"));
				flow.setFlowRangeName(rs.getString("FLOWRANGENAME"));
				flow.setFlowRange(rs.getString("FLOWRANGE"));

				flowList.add(flow);
			}
		} catch (Exception ex) {
			
		} finally {
			ConnectionProvider.close(conn, stmt, rs);
		}
		return flowList;
	}

	public boolean isUserFlow(String userID, String flowId) {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;

		boolean flag = false;

		String sql = "SELECT * FROM flow_info WHERE flow_id = '" + flowId + "'";
		ACLManager aclManager = ACLManagerFactory.getACLManager();
		sql = aclManager.getACLSql(sql, "flow_id", userID);
		try {
			conn = ConnectionProvider.getConnection();
			stmt = conn.createStatement();

			rs = stmt.executeQuery(sql);

			if (rs.next()) {
				flag = true;
			}
		} catch (Exception ex) {
			
		} finally {
			ConnectionProvider.close(conn, stmt, rs);
		}
		return flag;
	}

	public boolean hasActor(String flowID, String actorName) {
		boolean flag = false;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		if ((flowID != null) && (!"".equals(flowID)) && (actorName != null)
				&& (!"".equals(actorName))) {
			String sql = "SELECT flow_id FROM flow_define WHERE flow_id = ? AND flow_actor like ? ";
			try {
				con = ConnectionProvider.getConnection();
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, flowID);
				pstmt.setString(2, "%[" + actorName + "]%");
				rs = pstmt.executeQuery();
				if (!rs.next()) {
					flag = true;
				}
			} catch (Exception ex) {
				ex.printStackTrace();
			} finally {
				ConnectionProvider.close(con, pstmt, rs);
			}
		}
		return flag;
	}

	public String addFlowInfo(FlowAttribute flowInfo) {
		if (flowInfo == null) {
			return null;
		}
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;

		boolean flag = false;

		String flowID = null;
		try {
			con = ConnectionProvider.getConnection();
			con.setAutoCommit(false);

			sql = "insert into flow_info(FLOW_ID,FLOW_NAME,MODULE_ID,APPLICATION_ID,ADMINISTRATOR,DESCRIPTION,CREATOR,CREATE_TIME,FLOW_ACTOR,FLOW_TYPE,FLOW_ORDER,FLOW_STATUS,FLOWRANGENAME,FLOWRANGE)  values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

			flowID = Constant.WORKFLOW_FLOWID_PRIFIX
					+ String.valueOf(UnidHelper.getUnid("SEQ_FLOW_ID") + 100000000L);
			flowInfo.setFlowId(flowID);

			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, flowInfo.getFlowId());
			pstmt.setString(2, flowInfo.getFlowName());
			pstmt.setString(3, flowInfo.getModuleId());
			pstmt.setString(4, flowInfo.getApplicationId());
			pstmt.setString(5, flowInfo.getAdministrator());
			pstmt.setString(6, flowInfo.getDescription());
			pstmt.setString(7, flowInfo.getCreator());

			if (flowInfo.getCreateTime() == null)
				pstmt.setString(8, null);
			else {
				pstmt.setTimestamp(8, new Timestamp(flowInfo.getCreateTime()
						.getTime()));
			}
			pstmt.setString(9, flowInfo.getFlowActor());
			pstmt.setString(10, flowInfo.getFlowType());
			pstmt.setLong(11, flowInfo.getFlowOrder().longValue());
			pstmt.setString(12, flowInfo.getFlowStatus());
			pstmt.setString(13, flowInfo.getFlowRangeName());
			pstmt.setString(14, flowInfo.getFlowRange());

			if (pstmt.executeUpdate() == 1) {
//				ACLManager aclManager = ACLManagerFactory.getACLManager();
//				if (aclManager.addACLRange(flowInfo.getFlowId(),
//						flowInfo.getFlowRange())) {
				if(addACL(flowInfo.getFlowId(),flowInfo.getFlowRange())){
					con.commit();
					String str1 = flowID;
					return str1;
				}
				con.rollback();
				return null;
			}

			con.rollback();
			return null;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		} finally {
			ConnectionProvider.close(con, pstmt, null);
		}
	}

	public String updateFlowInfo(FlowAttribute flowInfo) {
		if (flowInfo == null) {
			return null;
		}
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;

		boolean flag = false;

		String flowID = null;
		try {
			con = ConnectionProvider.getConnection();

			sql = "update flow_info set FLOW_NAME=?,MODULE_ID=?,APPLICATION_ID=?,ADMINISTRATOR=?,DESCRIPTION=?,CREATOR=?,CREATE_TIME=?,FLOW_ACTOR=?,FLOW_TYPE=?,FLOW_ORDER=?,FLOW_STATUS=?,FLOWRANGENAME=?,FLOWRANGE=?  where FLOW_ID=?";

			flowID = flowInfo.getFlowId();

			pstmt = con.prepareStatement(sql);

			pstmt.setString(1, flowInfo.getFlowName());
			pstmt.setString(2, flowInfo.getModuleId());
			pstmt.setString(3, flowInfo.getApplicationId());
			pstmt.setString(4, flowInfo.getAdministrator());
			pstmt.setString(5, flowInfo.getDescription());
			pstmt.setString(6, flowInfo.getCreator());

			if (flowInfo.getCreateTime() == null)
				pstmt.setString(7, null);
			else {
				pstmt.setTimestamp(7, new Timestamp(flowInfo.getCreateTime()
						.getTime()));
			}
			pstmt.setString(8, flowInfo.getFlowActor());
			pstmt.setString(9, flowInfo.getFlowType());
			pstmt.setLong(10, flowInfo.getFlowOrder().longValue());
			pstmt.setString(11, flowInfo.getFlowStatus());
			pstmt.setString(12, flowInfo.getFlowRangeName());
			pstmt.setString(13, flowInfo.getFlowRange());
			pstmt.setString(14, flowInfo.getFlowId());
			System.out.println("update    "+System.currentTimeMillis());
			if (pstmt.executeUpdate() == 1) {
				System.out.println("ACL    "+System.currentTimeMillis());
//				ACLManager aclManager = ACLManagerFactory.getACLManager();
//				if (aclManager.addACLRange(flowInfo.getFlowId(),
//						flowInfo.getFlowRange())) {
				if(addACL(flowInfo.getFlowId(),flowInfo.getFlowRange())){
					con.commit();
					String str1 = flowID;
					return str1;
				}
				con.rollback();
				return null;
			}

			con.rollback();
			return null;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			System.out.println("ACL end    "+System.currentTimeMillis());
			ConnectionProvider.close(con, pstmt, null);
		}
		return null;
	}

	public void deleteFlowInfo(String flowID) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		try {
			con = ConnectionProvider.getConnection();
			sql = "DELETE FROM flow_info WHERE FLOW_ID=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, flowID);

			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			ConnectionProvider.close(con, pstmt, null);
		}
	}
	
	public boolean addACL(String flowID,String flowRange) {
		boolean flag=deleteACL(flowID);
		if(flowRange==null||"".equals(flowRange)){
			flag=flag&&insertACL(flowID,"*");
		}else{
			String[] ids=flowRange.split(",");
			for(String id:ids){
				flag=flag&&insertACL(flowID,id);
			}
			
		}
		System.out.println("2222  "+System.currentTimeMillis());
		 IACLService aclService = ACLContend.getACLService();
         Aclrole adminRole = aclService.getRoleByRolecode("sysadmin");
         flag=flag&&insertACL(flowID,adminRole.getRoleid());
         System.out.println("3333  "+System.currentTimeMillis());
		return flag;
	}
	
	
	public boolean insertACL(String flowID,String ownerid) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		try {
			con = ConnectionProvider.getConnection();
			sql = "insert into ACLPRIVILELIST(confid,workid,ownerid) values(?,?,?)";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, UUIDGenerator.getUUID());
			pstmt.setString(2, flowID);
			pstmt.setString(3, ownerid);
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		} finally {
			ConnectionProvider.close(con, pstmt, null);
		}
		return true;
	}
	
	
	
	public boolean deleteACL(String flowID) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		try {
			con = ConnectionProvider.getConnection();
			sql = "DELETE FROM ACLPRIVILELIST WHERE workid=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, flowID);
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		} finally {
			ConnectionProvider.close(con, pstmt, null);
		}
		return true;
	}
	
	
}