package com.kizsoft.commons.mxworkflow.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import com.kizsoft.commons.Constant;
import com.kizsoft.commons.commons.db.ConnectionProvider;
import com.kizsoft.commons.commons.util.UnidHelper;
import com.kizsoft.commons.mxworkflow.bean.TranceAttribute;

public class TranceDAO {
	public ArrayList<TranceAttribute> getTransListByFlow(String flowID) {
		ArrayList<TranceAttribute> transitionList = new ArrayList<TranceAttribute>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = ConnectionProvider.getConnection();
			pstmt = conn
					.prepareStatement("SELECT flow_id, trans_id, trans_name, from_activity_id, to_activity_id, trans_flag, trans_type, description, start_x, start_y, end_x, end_y, double_flag,MXEDGE_X,MXEDGE_Y FROM flow_transitions WHERE flow_id = ?");
			pstmt.setString(1, flowID);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				TranceAttribute trans = new TranceAttribute();
				trans.setFlowId(flowID);
				trans.setTransId(rs.getString("trans_id"));
				trans.setTransName(rs.getString("trans_name"));
				trans.setFromActivId(rs.getString("from_activity_id"));
				trans.setToActivId(rs.getString("to_activity_id"));
				trans.setTransFlag(rs.getString("trans_flag"));
				trans.setTransType(rs.getString("trans_type"));
				trans.setDescription(rs.getString("description"));
				trans.setStartX(new Long(rs.getString("start_x")));
				trans.setStartY(new Long(rs.getString("start_y")));
				trans.setEndX(new Long(rs.getString("end_x")));
				trans.setEndY(new Long(rs.getString("end_y")));
				trans.setDouble_flag(rs.getString("double_flag"));
				String MXEDGE_X=rs.getString("MXEDGE_X");
				String MXEDGE_Y=rs.getString("MXEDGE_Y");
				trans.setMxEdgeX(new Long((MXEDGE_X==null||"".equals(MXEDGE_X))?"0":MXEDGE_X));
				trans.setMxEdgeY(new Long((MXEDGE_Y==null||"".equals(MXEDGE_Y))?"0":MXEDGE_Y));
				transitionList.add(trans);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			ConnectionProvider.close(conn, pstmt, rs);
		}
		return transitionList;
	}

	public String addTransitionInfo(TranceAttribute transition) {
		if (transition == null) {
			return null;
		}

		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;

		String transID = null;
		try {
			con = ConnectionProvider.getConnection();
			con.setAutoCommit(false);

			sql = "insert into flow_transitions(TRANS_ID,FLOW_ID,TRANS_NAME,FROM_ACTIVITY_ID,TO_ACTIVITY_ID,TRANS_FLAG,TRANS_TYPE,DESCRIPTION,START_X,START_Y,END_X,END_Y,DOUBLE_FLAG,MXEDGE_X,MXEDGE_Y)values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

			transID = Constant.WORKFLOW_TRANSITIONID_PRIFIX
					+ String.valueOf(UnidHelper
							.getUnid("SEQ_FLOW_TRANSITION_ID") + 100000000L);
			transition.setTransId(transID);

			pstmt = con.prepareStatement(sql);

			pstmt.setString(1, transition.getTransId());
			pstmt.setString(2, transition.getFlowId());
			pstmt.setString(3, transition.getTransName());
			pstmt.setString(4, transition.getFromActivId());
			pstmt.setString(5, transition.getToActivId());
			pstmt.setString(6, transition.getTransFlag());
			pstmt.setString(7, transition.getTransType());
			pstmt.setString(8, transition.getDescription());
			if (transition.getStartX() == null)
				pstmt.setLong(9, 0L);
			else {
				pstmt.setLong(9, transition.getStartX().longValue());
			}

			if (transition.getStartY() == null)
				pstmt.setLong(10, 0L);
			else {
				pstmt.setLong(10, transition.getStartY().longValue());
			}

			if (transition.getEndX() == null)
				pstmt.setLong(11, 0L);
			else {
				pstmt.setLong(11, transition.getEndX().longValue());
			}

			if (transition.getEndY() == null)
				pstmt.setLong(12, 0L);
			else {
				pstmt.setLong(12, transition.getEndY().longValue());
			}

			pstmt.setString(13, transition.getDouble_flag());
			pstmt.setLong(14, transition.getMxEdgeX());
			pstmt.setLong(15, transition.getMxEdgeY());
			if (pstmt.executeUpdate() == 1) {
				con.commit();
				String str1 = transID;
				return str1;
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

	public String updateTransitionInfo(TranceAttribute transition) {
		if (transition == null) {
			return null;
		}

		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;

		String transID = null;
		try {
			con = ConnectionProvider.getConnection();
			con.setAutoCommit(false);

			sql = "update flow_transitions set FLOW_ID=?,TRANS_NAME=?,FROM_ACTIVITY_ID=?,TO_ACTIVITY_ID=?,TRANS_FLAG=?,TRANS_TYPE=?,DESCRIPTION=?,START_X=?,START_Y=?,END_X=?,END_Y=?,DOUBLE_FLAG=?,MXEDGE_X=?,MXEDGE_Y=?  where TRANS_ID=?";

			transID = transition.getTransId();

			pstmt = con.prepareStatement(sql);

			pstmt.setString(1, transition.getFlowId());
			pstmt.setString(2, transition.getTransName());
			pstmt.setString(3, transition.getFromActivId());
			pstmt.setString(4, transition.getToActivId());
			pstmt.setString(5, transition.getTransFlag());
			pstmt.setString(6, transition.getTransType());
			pstmt.setString(7, transition.getDescription());

			if (transition.getStartX() == null)
				pstmt.setLong(8, 0L);
			else {
				pstmt.setLong(8, transition.getStartX().longValue());
			}

			if (transition.getStartY() == null)
				pstmt.setLong(9, 0L);
			else {
				pstmt.setLong(9, transition.getStartY().longValue());
			}

			if (transition.getEndX() == null)
				pstmt.setLong(10, 0L);
			else {
				pstmt.setLong(10, transition.getEndX().longValue());
			}

			if (transition.getEndY() == null)
				pstmt.setLong(11, 0L);
			else {
				pstmt.setLong(11, transition.getEndY().longValue());
			}

			pstmt.setString(12, transition.getDouble_flag());
			pstmt.setLong(13, transition.getMxEdgeX());
			pstmt.setLong(14, transition.getMxEdgeY());
			pstmt.setString(15, transition.getTransId());

			if (pstmt.executeUpdate() == 1) {
				con.commit();
				String str1 = transID;
				return str1;
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

	public void deleteTransition(String transID) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		try {
			con = ConnectionProvider.getConnection();
			sql = "DELETE FROM flow_transitions WHERE trans_ID=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, transID);
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			ConnectionProvider.close(con, pstmt, null);
		}
	}

	public void deleteTransitions(String flowID) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		try {
			con = ConnectionProvider.getConnection();
			sql = "DELETE FROM flow_transitions WHERE flow_ID=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, flowID);
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			ConnectionProvider.close(con, pstmt, null);
		}
	}
	
	
	public void deleteTransitions(String[] transIDs,String flowID) {

		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		for(String transID:transIDs){
			try {
				con = ConnectionProvider.getConnection();
				sql = "DELETE FROM flow_transitions WHERE trans_ID=? and flow_id=? ";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, transID);
				pstmt.setString(2, flowID);
				pstmt.executeUpdate();
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				ConnectionProvider.close(con, pstmt, null);
			}
		}
	}

	public void deleteTranceByActivID(String[] ids, String flowid) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		for(String activID:ids){
			try {
				con = ConnectionProvider.getConnection();
				sql = "DELETE FROM flow_transitions WHERE (from_activity_id=? or to_activity_id=? ) and flow_id=? ";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, activID);
				pstmt.setString(2, activID);
				pstmt.setString(3, flowid);
				pstmt.executeUpdate();
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				ConnectionProvider.close(con, pstmt, null);
			}
		}
	}
}
