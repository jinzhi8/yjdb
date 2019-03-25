package com.kizsoft.commons.mxworkflow.dao;

import com.kizsoft.commons.Constant;

import com.kizsoft.commons.commons.db.ConnectionProvider;
import com.kizsoft.commons.commons.util.UnidHelper;
import com.kizsoft.commons.mxworkflow.bean.NodeAppAttribute;
import com.kizsoft.commons.mxworkflow.bean.NodeAttribute;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;


public class NodeDAO {

	public List<NodeAttribute> getNodeListByFlow(String flowID) {
		List<NodeAttribute> nodeList = new ArrayList<NodeAttribute>();
		NodeAttribute node = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = ConnectionProvider.getConnection();
			pstmt = conn.prepareStatement("SELECT * FROM flow_activities WHERE flow_id = ?");
			pstmt.setString(1, flowID);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				node = new NodeAttribute();
				node.setFlowId(flowID);
				node.setActivId(rs.getString("activ_id"));
				node.setActivName(rs.getString("activ_name"));
				node.setActivType(rs.getString("activ_type"));
				node.setStartflag(rs.getString("startflag"));
				node.setDeadline(rs.getString("deadline"));
				node.setPerformer(rs.getString("performer"));
				node.setDescription(rs.getString("description"));
				node.setJoinMode(rs.getString("join_mode"));
				node.setSplitMode(rs.getString("split_mode"));
				node.setPerformerMode(rs.getString("performer_mode"));
				node.setPerformOrder(rs.getString("perform_order"));
				node.setPerformerPurview(rs.getString("performer_purview"));
				node.setPerformerChoiceFlag(rs.getString("performer_choice_flag"));
				node.setActor(rs.getString("actor"));
				node.setReadFlag(rs.getString("read_flag"));
				node.setActivOrder(new Long(rs.getString("activ_order")));
				node.setPositionX(new Long(rs.getString("position_x")));
				node.setPositionY(new Long(rs.getString("position_y")));
				node.setPerformerName(rs.getString("performername"));
				node.setPerformerPurviewName(rs.getString("performer_purviewname"));
				node.setNodeAppAtt(getNodeAppAtt(rs.getString("activ_id")));
				nodeList.add(node);
			}
		} catch (SQLException ex) {
		} finally {
			ConnectionProvider.close(conn, pstmt, rs);
		}
		return nodeList;
	}

	public List<NodeAppAttribute> getNodeAppAtt(String activID) {
		List<NodeAppAttribute> nodeAppList = new ArrayList<NodeAppAttribute>();
		NodeAppAttribute nodeApp = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = ConnectionProvider.getConnection();
			pstmt = conn.prepareStatement("SELECT * FROM flow_activity_appbinding WHERE activ_id = ?");
			pstmt.setString(1, activID);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				nodeApp = new NodeAppAttribute();
				nodeApp.setActivId(activID);
				nodeApp.setItemId(rs.getString("item_id"));
				nodeApp.setItemName(rs.getString("item_name"));
				nodeApp.setStatus(rs.getString("status"));
				nodeApp.setNullable(rs.getString("nullable"));
				nodeApp.setDataType(rs.getString("data_type"));
				nodeApp.setDataPattern(rs.getString("data_pattern"));
				nodeAppList.add(nodeApp);
			}
		} catch (SQLException ex) {
			ex.printStackTrace();
		} finally {
			ConnectionProvider.close(conn, pstmt, rs);
		}
		return nodeAppList;
	}

	 public String addNode(NodeAttribute node)
	  {
	    if (node == null) {
	      return null;
	    }
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    String sql = null;

	    boolean bindingFlag = false;
	    boolean roleFlag = false;

	    String activID = null;
	    try
	    {
	      con = ConnectionProvider.getConnection();
	      con.setAutoCommit(false);

	      sql = "insert into flow_activities(ACTIV_ID,FLOW_ID,ACTIV_NAME,ACTIV_TYPE,STARTFLAG,PERFORMER,DESCRIPTION,STARTMODE,FINISHMODE,JOIN_MODE,SPLIT_MODE,PERFORMER_MODE,MULTI_RESTRICTION,PERFORM_ORDER,PERFORMER_PURVIEW,PERFORMER_CHOICE_FLAG,PRIORITY,ALERTTIME,DEADLINE,ACTOR,SHOWPUBLIC_FLAG,READ_FLAG,ACTIV_ORDER,SHOWMESSAGE_FLAG,AFFIX_NUMBER,POSITION_X,POSITION_Y,PERFORMERName,PERFORMER_PURVIEWNAME)values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

	      activID = Constant.WORKFLOW_ACTIVITYID_PRIFIX + 
	        String.valueOf(UnidHelper.getUnid("SEQ_FLOW_ACTIVITY_ID") + 100000000L);

	      node.setActivId(activID);
	      pstmt = con.prepareStatement(sql);

	      pstmt.setString(1, node.getActivId());
	      pstmt.setString(2, node.getFlowId());
	      pstmt.setString(3, node.getActivName());
	      pstmt.setString(4, node.getActivType());
	      pstmt.setString(5, node.getStartflag());
	      pstmt.setString(6, node.getPerformer());
	      pstmt.setString(7, node.getDescription());
	      pstmt.setString(8, node.getStartmode());
	      pstmt.setString(9, node.getFinishmode());
	      pstmt.setString(10, node.getJoinMode());
	      pstmt.setString(11, node.getSplitMode());
	      pstmt.setString(12, node.getPerformerMode());
	      pstmt.setString(13, node.getMultiRestriction());
	      pstmt.setString(14, node.getPerformOrder());
	      pstmt.setString(15, node.getPerformerPurview());
	      pstmt.setString(16, node.getPerformerChoiceFlag());
	      pstmt.setString(17, node.getPriority());
	      pstmt.setString(18, node.getAlerttime());
	      pstmt.setString(19, node.getDeadline());
	      pstmt.setString(20, node.getActor());
	      pstmt.setString(21, node.getShowpublicFlag());
	      pstmt.setString(22, node.getReadFlag());

	      if (node.getActivOrder() != null)
	        pstmt.setLong(23, node.getActivOrder().longValue());
	      else {
	        pstmt.setLong(23, 99L);
	      }
	      pstmt.setString(24, node.getShowmessageFlag());
	      pstmt.setInt(25, node.getAffixNumber().intValue());

	      if (node.getPositionX() == null)
	        pstmt.setLong(26, 0L);
	      else {
	        pstmt.setLong(26, node.getPositionX().longValue());
	      }
	      if (node.getPositionY() == null)
	        pstmt.setLong(27, 0L);
	      else {
	        pstmt.setLong(27, node.getPositionY().longValue());
	      }
	      pstmt.setString(28, node.getPerformerName());
	      pstmt.setString(29, node.getPerformerPurviewName());

	      if ((pstmt.executeUpdate() == 1) && 
	        (deleteAppBindingInfos(activID, con)) && 
	        (addAppBindingInfos(activID, node.getNodeAppAtt(), con))) {
	        con.commit();
	        String str1 = activID;
	        return str1;
	      }

	      con.rollback();
	      return null;
	    }
	    catch (Exception e) {
	      e.printStackTrace();
	    }
	    finally {
	      ConnectionProvider.close(con, pstmt, null);
	    }
	    return null;
	  }

	  public String updateNodeInfo(NodeAttribute node)
	  {
	    if (node == null) {
	      return null;
	    }
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    String sql = null;
	    String activID = null;

	    boolean bindingFlag = false;
	    boolean roleFlag = false;
	    try
	    {
	      con = ConnectionProvider.getConnection();
	      con.setAutoCommit(false);

	      sql = "update flow_activities set FLOW_ID=?,ACTIV_NAME=?,ACTIV_TYPE=?,STARTFLAG=?,PERFORMER=?,DESCRIPTION=?,STARTMODE=?,FINISHMODE=?,JOIN_MODE=?,SPLIT_MODE=?,PERFORMER_MODE=?,MULTI_RESTRICTION=?,PERFORM_ORDER=?,PERFORMER_PURVIEW=?,PERFORMER_CHOICE_FLAG=?,PRIORITY=?,ALERTTIME=?,DEADLINE=?,ACTOR=?,SHOWPUBLIC_FLAG=?,READ_FLAG=?,ACTIV_ORDER=?,SHOWMESSAGE_FLAG=?,AFFIX_NUMBER=?,POSITION_X=?,POSITION_Y=?,PERFORMERName=?,PERFORMER_PURVIEWNAME=?where ACTIV_ID=?";

	      activID = node.getActivId();

	      pstmt = con.prepareStatement(sql);
	      pstmt.setString(1, node.getFlowId());
	      pstmt.setString(2, node.getActivName());
	      pstmt.setString(3, node.getActivType());
	      pstmt.setString(4, node.getStartflag());
	      pstmt.setString(5, node.getPerformer());
	      pstmt.setString(6, node.getDescription());
	      pstmt.setString(7, node.getStartmode());
	      pstmt.setString(8, node.getFinishmode());
	      pstmt.setString(9, node.getJoinMode());
	      pstmt.setString(10, node.getSplitMode());
	      pstmt.setString(11, node.getPerformerMode());
	      pstmt.setString(12, node.getMultiRestriction());
	      pstmt.setString(13, node.getPerformOrder());
	      pstmt.setString(14, node.getPerformerPurview());
	      pstmt.setString(15, node.getPerformerChoiceFlag());
	      pstmt.setString(16, node.getPriority());
	      pstmt.setString(17, node.getAlerttime());
	      pstmt.setString(18, node.getDeadline());
	      pstmt.setString(19, node.getActor());
	      pstmt.setString(20, node.getShowpublicFlag());
	      pstmt.setString(21, node.getReadFlag());

	      if (node.getActivOrder() != null)
	        pstmt.setLong(22, node.getActivOrder().longValue());
	      else {
	        pstmt.setLong(22, 99L);
	      }
	      pstmt.setString(23, node.getShowmessageFlag());
	      pstmt.setInt(24, node.getAffixNumber().intValue());
	      if (node.getPositionX() == null)
	        pstmt.setLong(25, 0L);
	      else {
	        pstmt.setLong(25, node.getPositionX().longValue());
	      }
	      if (node.getPositionY() == null)
	        pstmt.setLong(26, 0L);
	      else {
	        pstmt.setLong(26, node.getPositionY().longValue());
	      }
	      pstmt.setString(27, node.getPerformerName());
	      pstmt.setString(28, node.getPerformerPurviewName());
	      pstmt.setString(29, node.getActivId());

	      if ((pstmt.executeUpdate() == 1) && 
	        (deleteAppBindingInfos(activID, con)) && 
	        (addAppBindingInfos(activID, node.getNodeAppAtt(), con))) {
	        con.commit();
	        String str1 = activID;
	        return str1;
	      }

	      con.rollback();
	      return null;
	    }
	    catch (Exception e) {
	      e.printStackTrace();
	      return null;
	    }
	    finally {
	      ConnectionProvider.close(con, pstmt, null);
	    }
	  }

	  private boolean addAppBindingInfos(String activId, List<NodeAppAttribute> appBindingInfos, Connection con)
	  {
	    if ((activId == null) || ("".equals(activId)) || (appBindingInfos == null) || (appBindingInfos.isEmpty()))
	      return true;
	    Statement st = null;
	    String sql = null;
	    StringBuffer sqlbuffer = null;
	    try {
	      sql = "insert into flow_activity_appbinding (ACTIV_ID,ITEM_ID,ITEM_NAME,STATUS,NULLABLE,DATA_TYPE,DATA_PATTERN,DESCRIPTION) values(";
	      st = con.createStatement();
	      for (Iterator itr = appBindingInfos.iterator(); itr.hasNext(); ) {
	    	  NodeAppAttribute appBinding = (NodeAppAttribute)itr.next();
	        if (appBinding != null) {
	          sqlbuffer = new StringBuffer(sql);
	          sqlbuffer.append("'" + activId + "',");
	          sqlbuffer.append("'" + appBinding.getItemId() + "',");
	          sqlbuffer.append("'" + appBinding.getItemName() + "',");
	          sqlbuffer.append("'" + appBinding.getStatus() + "',");
	          sqlbuffer.append("'" + appBinding.getNullable() + "',");
	          sqlbuffer.append("'" + appBinding.getDataType() + "',");
	          sqlbuffer.append("'" + appBinding.getDataPattern() + "',");
	          sqlbuffer.append("'" + appBinding.getAppdescription() + "')");
	          st.addBatch(sqlbuffer.toString());
	        }
	      }

	      st.executeBatch();
	    }
	    catch (Exception e) {
	      //this.log.info("add app=======" + e);
	      e.printStackTrace();
	      return false;
	    }
	    finally {
	      ConnectionProvider.close(null, st, null);
	    }
	    return true;
	  }

	  private boolean deleteAppBindingInfos(String activId, Connection con) {
	    PreparedStatement pstmt = null;
	    String sql = null;
	    try
	    {
	      sql = "delete flow_activity_appbinding where activ_id=?";
	      pstmt = con.prepareStatement(sql);

	      pstmt.setString(1, activId);

	      pstmt.executeUpdate();
	      return true;
	    }
	    catch (Exception e)
	    {
	      e.printStackTrace();
	      return false;
	    }
	    finally {
	      ConnectionProvider.close(null, pstmt, null);
	    }
	  }
	
	  
	  public void deleteNode(String activID)
	  {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    String sql = null;
	    try
	    {
	      con = ConnectionProvider.getConnection();
	      sql = "DELETE FROM flow_activities WHERE activ_ID=?";
	      pstmt = con.prepareStatement(sql);
	      pstmt.setString(1, activID);
	      if (deleteAppBindingInfos(activID, con))
	        pstmt.executeUpdate();
	    }
	    catch (Exception e)
	    {
	      e.printStackTrace();
	    }
	    finally {
	      ConnectionProvider.close(con, pstmt, null);
	    }
	  }

	  public void deleteNodes(String flowID) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String sql = null;
	    try
	    {
	      con = ConnectionProvider.getConnection();
	      sql = "SELECT activ_id FROM flow_activities WHERE flow_ID=?";
	      pstmt = con.prepareStatement(sql);
	      pstmt.setString(1, flowID);
	      rs = pstmt.executeQuery();
	      while (rs.next()) {
	        deleteAppBindingInfos(rs.getString("activ_id"), con);
	      }
	      sql = "DELETE FROM flow_activities WHERE flow_ID=?";
	      pstmt = con.prepareStatement(sql);
	      pstmt.setString(1, flowID);
	      pstmt.executeUpdate();
	    }
	    catch (Exception e) {
	      e.printStackTrace();
	    }
	    finally {
	      ConnectionProvider.close(con, pstmt, null);
	    }
	  }

	public void deleteNodes(String[] ids, String flowid) {
		Connection con = null;
	    PreparedStatement pstmt = null;
	    String sql = null;
	    for(String activID:ids){
		    try
		    {
		      con = ConnectionProvider.getConnection();
		      sql = "DELETE FROM flow_activities WHERE activ_ID=? and flow_id=?";
		      pstmt = con.prepareStatement(sql);
		      pstmt.setString(1, activID);
		      pstmt.setString(2, flowid);
		      if (deleteAppBindingInfos(activID, con))
		        pstmt.executeUpdate();
		    }
		    catch (Exception e)
		    {
		      e.printStackTrace();
		    }
		    finally {
		      ConnectionProvider.close(con, pstmt, null);
		    }
	    }
	}
	  
}