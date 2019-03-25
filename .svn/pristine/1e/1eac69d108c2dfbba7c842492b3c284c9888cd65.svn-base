package com.kizsoft.commons.mxworkflow.manager;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.kizsoft.commons.mxworkflow.bean.NodeAttribute;
import com.kizsoft.commons.mxworkflow.dao.NodeDAO;

public class NodeManager {
	private static NodeDAO dao=new NodeDAO();
	public String addNode(NodeAttribute node){
		return dao.addNode(node);
	}
	public String updateNode(NodeAttribute node){
		return dao.updateNodeInfo(node);
	}
	public void deleteNode(String nodeid){
		dao.deleteNode(nodeid);
	}
	public void deleteNodes(String flowid){
		dao.deleteNodes(flowid);
	}
	public Map<String,String> addNodes(List<NodeAttribute> nodes) {
		Map<String,String> map=new HashMap<String,String>();
		for(NodeAttribute node:nodes){
			String nodeid=node.getActivId();
			if(nodeid!=null&&!"".equals(nodeid)){
				updateNode(node);
			}else{
				nodeid=addNode(node);
				System.out.println("addNode           ---------------------------");
				System.out.println(node.getId()+"     eeeeee     "+nodeid);
				map.put(node.getId(), nodeid);
			}
		}
		return map;
	}
}
