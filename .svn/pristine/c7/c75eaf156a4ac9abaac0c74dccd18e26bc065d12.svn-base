package com.kizsoft.commons.mxworkflow.action;

import java.io.IOException;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;
import org.xml.sax.InputSource;

import com.kizsoft.commons.commons.user.User;
import com.kizsoft.commons.mxworkflow.bean.FlowAttribute;
import com.kizsoft.commons.mxworkflow.bean.NodeAppAttribute;
import com.kizsoft.commons.mxworkflow.bean.NodeAttribute;
import com.kizsoft.commons.mxworkflow.bean.Point;
import com.kizsoft.commons.mxworkflow.bean.TranceAttribute;
import com.kizsoft.commons.mxworkflow.manager.FlowManager;
import com.kizsoft.commons.mxworkflow.manager.NodeManager;
import com.kizsoft.commons.mxworkflow.manager.TranceManager;

public class AddAction extends Action {
	
	@Override
	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws IOException, ServletException {
		//System.out.println("333333333333333333333333333333333333333333");
		
		HttpSession session = request.getSession();
		User userInfo = (User) session.getAttribute("userInfo");
		if (userInfo == null) {
			return null;
		}
		String flow_flowname=request.getParameter("flow_flowname");
		if(isNull(flow_flowname)){
			response.getWriter().write("flowname");
			return null;
		}
		
		
		//System.out.println("111111111111111111111111111111111111111111");
		String xml=request.getParameter("xml");
		String flowid=request.getParameter("flow_flowid");
		String flow_flowtype=request.getParameter("flow_flowtype");
		String flow_administrator=request.getParameter("flow_administrator");
		String flow_creator=request.getParameter("flow_creator");
		String flow_floworder=request.getParameter("flow_floworder");
		String flow_moduleid=request.getParameter("flow_moduleid");
		String flow_flowstatus=request.getParameter("flow_flowstatus");
		String flow_applicationid=request.getParameter("flow_applicationid");
		String flow_flowactor=request.getParameter("flow_flowactor");
		String flow_flowrangename=request.getParameter("flow_flowrangename");
		String flow_flowrange=request.getParameter("flow_flowrange");
		String flow_description=request.getParameter("flow_description");
		//isNew：1 复制粘贴，0:保存 
		String isNew=request.getParameter("isNew");
		
		if("1".equals(isNew)){
			flowid="";
		}
		
		String dtranceIDs=request.getParameter("dtranceIDs");
		String dactivIDs=request.getParameter("dactivIDs");
		FlowManager manager=new FlowManager();
		//flow.setFlowId(flowid);
		FlowAttribute flow=manager.getFlow(flowid);
		if(flow==null){
			flow=new FlowAttribute();
			flow.setFlowId(flowid);
			flow.setCreateTime(new Date());
		}
		flow.setFlowName(flow_flowname);
		flow.setFlowType(flow_flowtype);
		flow.setAdministrator(flow_administrator);
		flow.setCreator(flow_creator);
		flow_floworder=(flow_floworder==null||"".equals(flow_floworder))?"0":flow_floworder;
		flow.setFlowOrder(Long.parseLong(flow_floworder));
		flow.setModuleId(flow_moduleid);
		flow.setFlowStatus(flow_flowstatus);
		flow.setApplicationId(flow_applicationid);
		flow.setFlowActor(flow_flowactor);
		flow.setFlowRangeName(flow_flowrangename);
		flow.setFlowRange(flow_flowrange);
		flow.setDescription(flow_description);
		if(flowid!=null&&!"".equals(flowid)){
			flowid=manager.updateFlowInfo(flow);
			dactivIDs=dactivIDs.startsWith(",")?dactivIDs.substring(1):dactivIDs;
			dtranceIDs=dtranceIDs.startsWith(",")?dtranceIDs.substring(1):dtranceIDs;
			manager.deleteInfo(flowid,dactivIDs,dtranceIDs);
		}else{
			flowid=manager.addFlowInfo(flow);
		}
		
		if(flowid==null||"".equals(flowid)){
			response.getWriter().write("flowid");
			return null;
		}
		
		
		parseXML(xml,flowid,isNew);
//		System.out.println("222222222222222222222222222222222222222222222");
//		System.out.println(xml);
//		System.out.println(flow_flowname);
//		System.out.println(flow_flowtype);
//		System.out.println(flow_administrator);
		response.getWriter().write("success");
		return null;
	}

	private String parseXML(String xml,String flowid,String isNew) {
		StringReader read = new StringReader(xml);
		InputSource source = new InputSource(read);
		SAXBuilder sb = new SAXBuilder();
		try {
			Document doc = sb.build(source);
			Element root = doc.getRootElement();
			List<Element> jiedian =((Element)root.getChildren().get(0)).getChildren();
			parseElement(jiedian,flowid,isNew);
		} catch (JDOMException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}

	private void parseElement(List<Element> jiedian,String flowid,String isNew) {
		List<NodeAttribute> nodes = new ArrayList<NodeAttribute>();
		List<TranceAttribute> lines = new ArrayList<TranceAttribute>();
		Map<String,Point> points=new HashMap<String,Point>();
		for(int i=0,length=jiedian.size();i<length;i++){
			Element et=jiedian.get(i);
//			System.out.println(et.getName()+"         ----------"+i);
			if(et.getName().equals("Node")){
				NodeAttribute node=new NodeAttribute();
//				System.out.println(et.getAttributeValue("node_activname"));
				node.setActivName(et.getAttributeValue("node_activname"));
				if("1".equals(isNew)){
					node.setActivId("");
				}else{
					node.setActivId(et.getAttributeValue("node_activid"));
				}
				String id=et.getAttributeValue("id");
				node.setId(id);
				node.setStartflag(et.getAttributeValue("node_startflag"));
				node.setSplitMode(et.getAttributeValue("node_splitmode"));
				node.setJoinMode(et.getAttributeValue("node_joinmode"));
				node.setReadFlag(et.getAttributeValue("node_readflag"));
				String activorder=et.getAttributeValue("node_activorder");
				node.setActivOrder(Long.parseLong(activorder==null?"0":activorder));
				node.setPerformerMode(et.getAttributeValue("node_performermode"));
				node.setPerformOrder(et.getAttributeValue("node_performorder"));
				node.setPerformerChoiceFlag(et.getAttributeValue("node_performerchoiceflag"));
				node.setPerformerName(et.getAttributeValue("node_performername"));
				node.setPerformer(et.getAttributeValue("node_performer"));
				node.setDeadline(et.getAttributeValue("node_deadline"));
				node.setPerformerPurviewName(et.getAttributeValue("node_performerpurviewname"));
				node.setPerformerPurview(et.getAttributeValue("node_performerpurview"));
				node.setDescription(et.getAttributeValue("node_description"));
				String appJson=et.getAttributeValue("node_appjson");
				node.setNodeAppAtt(parseAppJson(appJson));
				node.setFlowId(flowid);
				node.setActivType("normal");
				Element el=et.getChild("mxCell");
				if(el!=null){
					el=el.getChild("mxGeometry");
				}
				if(el!=null){
					Long x=Long.parseLong(el.getAttributeValue("x"));
					Long y=Long.parseLong(el.getAttributeValue("y"));
					node.setPositionX(x);
					node.setPositionY(y);
					Point p=new Point(x,y);
					points.put(id, p);
				}
				
				nodes.add(node);
			}
			
			if(et.getName().equals("Line")){
				TranceAttribute line=new TranceAttribute();
				System.out.println(et.getAttributeValue("transName"));
				line.setTransName(et.getAttributeValue("transName"));
				line.setTransId(et.getAttributeValue("transTransId"));
				if("1".equals(isNew)){
					line.setTransId("");
				}else{
					line.setTransId(et.getAttributeValue("transTransId"));
				}
				line.setTransFlag(et.getAttributeValue("transFlag"));
				line.setTransType(et.getAttributeValue("transType"));
				line.setDescription(et.getAttributeValue("transDescription"));
				line.setFlowId(flowid);
				List<Element> es=et.getChildren();
				for(Element e:es){
					if(e.getName().equals("mxCell")){
						line.setFromActivId(e.getAttributeValue("source"));
						line.setToActivId(e.getAttributeValue("target"));
						Element mx=e.getChild("mxGeometry");
						if(mx!=null){
							mx=mx.getChild("Array");
							if(mx!=null){
								mx=mx.getChild("mxPoint");
								if(mx!=null){
									line.setMxEdgeX(Long.parseLong(mx.getAttributeValue("x")));
									line.setMxEdgeY(Long.parseLong(mx.getAttributeValue("y")));
								}
							}
						}
						
						break;
					}
				}
				lines.add(line);
			}
		}
		NodeManager nManager=new NodeManager();
		Map<String,String> map=nManager.addNodes(nodes);
		TranceManager tManager=new TranceManager();
		tManager.addTrances(lines,map,points);
		
	}

	private List<NodeAppAttribute> parseAppJson(String appJson) {
		// TODO Auto-generated method stub
		List<NodeAppAttribute> apps=new ArrayList<NodeAppAttribute>();
		//System.out.println("############################");
		//System.out.println(appJson);
		
		JSONObject json=JSONObject.fromObject(appJson);
		JSONArray array=(JSONArray) json.get("root");
		int size=array.size();
		for(int i=0;i<size;i++){
			JSONObject o=(JSONObject)array.get(i);
			NodeAppAttribute app=new NodeAppAttribute();
			String itemId=(String)o.get("itemId");
			String itemName=(String)o.get("itemName");
			if(isNull(itemId)&&isNull(itemName)){
				continue;
			}
			app.setItemId(itemId);
			app.setItemName(itemName);
			app.setStatus((String)o.get("itemStatus"));
			app.setNullable((String)o.get("nullable"));
			app.setDataType((String)o.get("dataType"));
			apps.add(app);
		}
//		System.out.println(((JSONObject)array.get(0)).get("itemId"));
		return apps;
	}
	
	public boolean isNull(String str){
		if(str==null||"".equals(str)){
			return true;
		}
		return false;
	}

}
