package com.kizsoft.commons.mxworkflow.manager;

import java.util.List;

import com.kizsoft.commons.mxworkflow.bean.FlowAttribute;
import com.kizsoft.commons.mxworkflow.bean.NodeAttribute;
import com.kizsoft.commons.mxworkflow.bean.TranceAttribute;
import com.kizsoft.commons.mxworkflow.dao.FlowDAO;
import com.kizsoft.commons.mxworkflow.dao.NodeDAO;
import com.kizsoft.commons.mxworkflow.dao.TranceDAO;

public class FlowManager {
	public String getFlowInfoXml(String flowId){
		StringBuffer sb=new StringBuffer();
		if(flowId!=null&&!"".equals(flowId)){
			sb.append("<mxGraphModel>  <root>");
			sb.append("<mxCell id=\"0\"/>    <mxCell id=\"1\" parent=\"0\"/>");
			NodeDAO nodeDao=new NodeDAO();
			List<NodeAttribute> nodeList=nodeDao.getNodeListByFlow(flowId);
			for(NodeAttribute node:nodeList){
				sb.append(node.toString());
			}
			TranceDAO tranceDao=new TranceDAO();
			List<TranceAttribute> tranceList=tranceDao.getTransListByFlow(flowId);
			for(TranceAttribute trance:tranceList){
				sb.append(trance.toString());
			}
			sb.append("</root></mxGraphModel>");
		}else{
			return "";
		}
		return sb.toString();
	}
	public FlowAttribute getFlow(String flowID) {
		FlowDAO dao=new FlowDAO();
		return dao.getFlow(flowID);
	}
	
	public String addFlowInfo(FlowAttribute flowInfo){
		FlowDAO dao=new FlowDAO();
		return dao.addFlowInfo(flowInfo);
	}
	public String updateFlowInfo(FlowAttribute flowInfo){
		FlowDAO dao=new FlowDAO();
		return dao.updateFlowInfo(flowInfo);
	}
	public void deleteFlowInfo(String flowID){
		FlowDAO dao=new FlowDAO();
		dao.deleteFlowInfo(flowID);
	}
	
	public void deleteFlowInfos(String[] flowIDs){
		if(flowIDs==null){
			return;
		}
		for(String id:flowIDs){
			deleteFlowInfo(id);
		}
	}
	public void deleteInfo(String flowid, String dactivIDs, String dtranceIDs) {
		TranceDAO tdao=new TranceDAO();
		NodeDAO ndao=new NodeDAO();
		if(dactivIDs!=null&&!"".equals(dactivIDs)){
			String[] ids= dactivIDs.split(",");
			ndao.deleteNodes(ids,flowid);
			tdao.deleteTranceByActivID(ids,flowid);
		}
		if(dtranceIDs!=null&&!"".equals(dtranceIDs)){
			tdao.deleteTransitions(dtranceIDs.split(","), flowid);
		}
	}
	
	
}
