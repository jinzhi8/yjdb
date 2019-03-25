<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML xmlns:vml="urn:schemas-microsoft-com:vml">
<%@ page language="java" contentType="text/html;charset=utf-8"%>
<%@page import="org.dom4j.Document"%>
<%@page import="org.dom4j.DocumentHelper"%>
<%@page import="org.dom4j.Element"%>
<%@page import="org.dom4j.io.XMLWriter"%>
<%@page import="org.dom4j.io.OutputFormat"%>
<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.kizsoft.commons.workflow.Activity"%>
<%@page import="com.kizsoft.commons.workflow.ActivityAppbinding"%>
<%@page import="com.kizsoft.commons.workflow.Flow"%>
<%@page import="com.kizsoft.commons.workflow.Transition"%>
<%@page import="com.kizsoft.commons.workflow.vml.FlowAttribute"%>
<%@page import="com.kizsoft.commons.workflow.vml.NodeAppAttribute"%>
<%@page import="com.kizsoft.commons.workflow.vml.NodeAttribute"%>
<%@page import="com.kizsoft.commons.workflow.vml.TranceAttribute"%>
<%@page import="com.kizsoft.commons.workflow.vml.WorkFlowManagerServlet"%>
<%!
String getStr(String str){
	return str==null?"":str;
}
Long getStr(Long str){
	return str==null?0:str;
}
%>
<%
	String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
	StringBuffer workFlowsb = new StringBuffer();
	String getFlowName = "";
		String flowId = request.getParameter("flowid");
		String activid = request.getParameter("activid");
		if (flowId != null && !"".equals(flowId)) {
			FlowAttribute flowAtt = null;

			Vector nodeAttVector = null;

			Vector tranceAttVector = null;

			Vector flowInfo = null;

			String flowID = null;

			Vector nodeIDList = null;
			WorkFlowManagerServlet workFlowManagerServlet = new WorkFlowManagerServlet();
			flowAtt = workFlowManagerServlet.getFlowAtt(flowId);
			nodeAttVector = workFlowManagerServlet.getActiveAtt(flowId);
			tranceAttVector = workFlowManagerServlet.getTranceAttribute(flowId);
			flowInfo = new Vector();
			flowInfo.add(flowAtt);
			flowInfo.add(nodeAttVector);
			flowInfo.add(tranceAttVector);
			workFlowsb.append("<input id=\"workflowinfo\" type=\"hidden\"");
			workFlowsb.append(" administrator=\""+getStr(flowAtt.getAdministrator())+"\"");
			workFlowsb.append(" applicationid=\""+getStr(flowAtt.getApplicationId())+"\"");
			workFlowsb.append(" creator=\""+getStr(flowAtt.getCreator())+"\"");
			workFlowsb.append(" delete_flag=\""+getStr(flowAtt.getDelete_flag())+"\"");
			workFlowsb.append(" description=\""+getStr(flowAtt.getDescription())+"\"");
			workFlowsb.append(" flowactor=\""+getStr(flowAtt.getFlowActor())+"\"");
			workFlowsb.append(" flowid=\""+getStr(flowAtt.getFlowId())+"\"");
			workFlowsb.append(" flowname=\""+getStr(flowAtt.getFlowName())+"\"");
			workFlowsb.append(" flowrange=\""+getStr(flowAtt.getFlowRange())+"\"");
			workFlowsb.append(" flowrangename=\""+getStr(flowAtt.getFlowRangeName())+"\"");
			workFlowsb.append(" flowstatus=\""+getStr(flowAtt.getFlowStatus())+"\"");
			workFlowsb.append(" flowtype=\""+getStr(flowAtt.getFlowType())+"\"");
			workFlowsb.append(" moduleid=\""+getStr(flowAtt.getModuleId())+"\"");
			SimpleDateFormat sdformat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			workFlowsb.append(" createtime=\""+sdformat.format(flowAtt.getCreateTime())+"\"");
			workFlowsb.append(" floworder=\""+flowAtt.getFlowOrder().toString()+"\"/>");

			Document doc = DocumentHelper.createDocument();
			Element workflow = doc.addElement("workflow");
			Element flowattElement = workflow.addElement("flowatt");
			flowattElement.addAttribute("administrator", getStr(flowAtt.getAdministrator()));
			flowattElement.addAttribute("applicationid", getStr(flowAtt.getApplicationId()));
			flowattElement.addAttribute("creator", getStr(flowAtt.getCreator()));
			flowattElement.addAttribute("delete_flag", getStr(flowAtt.getDelete_flag()));
			flowattElement.addAttribute("description", getStr(flowAtt.getDescription()));
			flowattElement.addAttribute("flowactor", getStr(flowAtt.getFlowActor()));
			flowattElement.addAttribute("flowid", getStr(flowAtt.getFlowId()));
			flowattElement.addAttribute("flowname", getStr(flowAtt.getFlowName()));
			getFlowName = getStr(flowAtt.getFlowName());
			flowattElement.addAttribute("flowrange", getStr(flowAtt.getFlowRange()));
			flowattElement.addAttribute("flowrangename", getStr(flowAtt.getFlowRangeName()));
			flowattElement.addAttribute("flowstatus", getStr(flowAtt.getFlowStatus()));
			flowattElement.addAttribute("flowtype", getStr(flowAtt.getFlowType()));
			flowattElement.addAttribute("moduleid", getStr(flowAtt.getModuleId()));
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			flowattElement.addAttribute("createtime", sdf.format(flowAtt.getCreateTime()));
			flowattElement.addAttribute("floworder", flowAtt.getFlowOrder().toString());
			NodeAttribute nodeAttribute = new NodeAttribute();
			for (Iterator iterator = nodeAttVector.iterator(); iterator.hasNext();) {
				nodeAttribute = (NodeAttribute) iterator.next();
				if("1".equals(nodeAttribute.getStartflag())){
					workFlowsb.append("<vml:roundrect id=\""+getStr(nodeAttribute.getActivId())+"\" title=\""+getStr(nodeAttribute.getActivName())+"\"");
					workFlowsb.append(" activid=\""+getStr(nodeAttribute.getActivId())+"\"");
					workFlowsb.append(" activname=\""+getStr(nodeAttribute.getActivName())+"\"");
					workFlowsb.append(" activtype=\""+getStr(nodeAttribute.getActivType())+"\"");
					workFlowsb.append(" actor=\""+getStr(nodeAttribute.getActor())+"\"");
					workFlowsb.append(" alerttime=\""+getStr(nodeAttribute.getAlerttime())+"\"");
					workFlowsb.append(" deadline=\""+getStr(nodeAttribute.getDeadline())+"\"");
					workFlowsb.append(" delete_flag=\""+getStr(nodeAttribute.getDelete_flag())+"\"");
					workFlowsb.append(" description=\""+getStr(nodeAttribute.getDescription())+"\"");
					workFlowsb.append(" finishmode=\""+getStr(nodeAttribute.getFinishmode())+"\"");
					workFlowsb.append(" flowid=\""+getStr(nodeAttribute.getFlowId())+"\"");
					workFlowsb.append(" joinmode=\""+getStr(nodeAttribute.getJoinMode())+"\"");
					workFlowsb.append(" multirestriction=\""+getStr(nodeAttribute.getMultiRestriction())+"\"");
					workFlowsb.append(" performer=\""+getStr(nodeAttribute.getPerformer())+"\"");
					workFlowsb.append(" performerchoiceflag=\""+getStr(nodeAttribute.getPerformerChoiceFlag())+"\"");
					workFlowsb.append(" performermode=\""+getStr(nodeAttribute.getPerformerMode())+"\"");
					workFlowsb.append(" performername=\""+getStr(nodeAttribute.getPerformerName())+"\"");
					workFlowsb.append(" performerpurview=\""+getStr(nodeAttribute.getPerformerPurview())+"\"");
					workFlowsb.append(" performerpurviewname=\""+getStr(nodeAttribute.getPerformerPurviewName())+"\"");
					workFlowsb.append(" performorder=\""+getStr(nodeAttribute.getPerformOrder())+"\"");
					workFlowsb.append(" priority=\""+getStr(nodeAttribute.getPriority())+"\"");
					workFlowsb.append(" readflag=\""+getStr(nodeAttribute.getReadFlag())+"\"");
					workFlowsb.append(" showmessageflag=\""+getStr(nodeAttribute.getShowmessageFlag())+"\"");
					workFlowsb.append(" showpublicflag=\""+getStr(nodeAttribute.getShowpublicFlag())+"\"");
					workFlowsb.append(" splitmode=\""+getStr(nodeAttribute.getSplitMode())+"\"");
					workFlowsb.append(" startflag=\""+getStr(nodeAttribute.getStartflag())+"\"");
					workFlowsb.append(" startmode=\""+getStr(nodeAttribute.getStartmode())+"\"");
					workFlowsb.append(" activorder=\""+nodeAttribute.getActivOrder().toString()+"\"");
					workFlowsb.append(" affixnumber=\""+nodeAttribute.getAffixNumber().toString()+"\"");
					workFlowsb.append(" positionx=\""+nodeAttribute.getPositionX().toString()+"\"");
					workFlowsb.append(" positiony=\""+nodeAttribute.getPositionY().toString()+"\"");
					workFlowsb.append(" fillcolor=\"#00EE00\" style=\"Z-INDEX: 1; TOP: "+nodeAttribute.getPositionY().toString()+"px; LEFT: "+nodeAttribute.getPositionX().toString()+"px; VERTICAL-ALIGN: middle; WIDTH: 100px; HEIGHT: 50px; CURSOR: hand; POSITION: absolute;   TEXT-ALIGN: center\">");
					workFlowsb.append("<vml:shadow offset=\"3px,3px\" color=\"#b3b3b3\" type=\"single\" on=\"T\"></vml:shadow>");
					workFlowsb.append("<vml:textbox onselectstart=\"return false;\" inset=\"1pt,2pt,1pt,1pt\">");
					workFlowsb.append("<br/>"+getStr(nodeAttribute.getActivName()));
					workFlowsb.append("</vml:textbox>");
					workFlowsb.append("</vml:roundrect>");
				}else{
					if(nodeAttribute.getActivId().equals(activid)){
						workFlowsb.append("<vml:roundrect id=\""+getStr(nodeAttribute.getActivId())+"\" title=\"\"");
						workFlowsb.append(" activid=\""+getStr(nodeAttribute.getActivId())+"\"");
						workFlowsb.append(" activname=\""+getStr(nodeAttribute.getActivName())+"\"");
						workFlowsb.append(" activtype=\""+getStr(nodeAttribute.getActivType())+"\"");
						workFlowsb.append(" actor=\""+getStr(nodeAttribute.getActor())+"\"");
						workFlowsb.append(" alerttime=\""+getStr(nodeAttribute.getAlerttime())+"\"");
						workFlowsb.append(" deadline=\""+getStr(nodeAttribute.getDeadline())+"\"");
						workFlowsb.append(" delete_flag=\""+getStr(nodeAttribute.getDelete_flag())+"\"");
						workFlowsb.append(" description=\""+getStr(nodeAttribute.getDescription())+"\"");
						workFlowsb.append(" finishmode=\""+getStr(nodeAttribute.getFinishmode())+"\"");
						workFlowsb.append(" flowid=\""+getStr(nodeAttribute.getFlowId())+"\"");
						workFlowsb.append(" joinmode=\""+getStr(nodeAttribute.getJoinMode())+"\"");
						workFlowsb.append(" multirestriction=\""+getStr(nodeAttribute.getMultiRestriction())+"\"");
						workFlowsb.append(" performer=\""+getStr(nodeAttribute.getPerformer())+"\"");
						workFlowsb.append(" performerchoiceflag=\""+getStr(nodeAttribute.getPerformerChoiceFlag())+"\"");
						workFlowsb.append(" performermode=\""+getStr(nodeAttribute.getPerformerMode())+"\"");
						workFlowsb.append(" performername=\""+getStr(nodeAttribute.getPerformerName())+"\"");
						workFlowsb.append(" performerpurview=\""+getStr(nodeAttribute.getPerformerPurview())+"\"");
						workFlowsb.append(" performerpurviewname=\""+getStr(nodeAttribute.getPerformerPurviewName())+"\"");
						workFlowsb.append(" performorder=\""+getStr(nodeAttribute.getPerformOrder())+"\"");
						workFlowsb.append(" priority=\""+getStr(nodeAttribute.getPriority())+"\"");
						workFlowsb.append(" readflag=\""+getStr(nodeAttribute.getReadFlag())+"\"");
						workFlowsb.append(" showmessageflag=\""+getStr(nodeAttribute.getShowmessageFlag())+"\"");
						workFlowsb.append(" showpublicflag=\""+getStr(nodeAttribute.getShowpublicFlag())+"\"");
						workFlowsb.append(" splitmode=\""+getStr(nodeAttribute.getSplitMode())+"\"");
						workFlowsb.append(" startflag=\""+getStr(nodeAttribute.getStartflag())+"\"");
						workFlowsb.append(" startmode=\""+getStr(nodeAttribute.getStartmode())+"\"");
						workFlowsb.append(" activorder=\""+nodeAttribute.getActivOrder().toString()+"\"");
						workFlowsb.append(" affixnumber=\""+nodeAttribute.getAffixNumber().toString()+"\"");
						workFlowsb.append(" positionx=\""+nodeAttribute.getPositionX().toString()+"\"");
						workFlowsb.append(" positiony=\""+nodeAttribute.getPositionY().toString()+"\"");
						workFlowsb.append(" fillcolor=\"#EE0000\" style=\"Z-INDEX: 1; TOP: "+nodeAttribute.getPositionY().toString()+"px; LEFT: "+nodeAttribute.getPositionX().toString()+"px; VERTICAL-ALIGN: middle; WIDTH: 100px; HEIGHT: 50px; CURSOR: hand; POSITION: absolute;   TEXT-ALIGN: center\">");
						workFlowsb.append("<vml:shadow offset=\"3px,3px\" color=\"#b3b3b3\" type=\"single\" on=\"T\"></vml:shadow>");
						workFlowsb.append("<vml:textbox onclick=\"alert('aaa');\" onselectstart=\"return false;\" inset=\"1pt,2pt,1pt,1pt\" style=\"Z-INDEX: 1; TOP: "+nodeAttribute.getPositionY().toString()+"px; LEFT: "+nodeAttribute.getPositionX().toString()+"px; VERTICAL-ALIGN: middle; WIDTH: 100px; HEIGHT: 50px; CURSOR: hand; POSITION: absolute;   TEXT-ALIGN: center\">");
						workFlowsb.append("<br/>"+getStr(nodeAttribute.getActivName()));
						workFlowsb.append("</vml:textbox>");
						workFlowsb.append("</vml:roundrect>");
					}else{
						workFlowsb.append("<vml:roundrect id=\""+getStr(nodeAttribute.getActivId())+"\" title=\"\"");
						workFlowsb.append(" activid=\""+getStr(nodeAttribute.getActivId())+"\"");
						workFlowsb.append(" activname=\""+getStr(nodeAttribute.getActivName())+"\"");
						workFlowsb.append(" activtype=\""+getStr(nodeAttribute.getActivType())+"\"");
						workFlowsb.append(" actor=\""+getStr(nodeAttribute.getActor())+"\"");
						workFlowsb.append(" alerttime=\""+getStr(nodeAttribute.getAlerttime())+"\"");
						workFlowsb.append(" deadline=\""+getStr(nodeAttribute.getDeadline())+"\"");
						workFlowsb.append(" delete_flag=\""+getStr(nodeAttribute.getDelete_flag())+"\"");
						workFlowsb.append(" description=\""+getStr(nodeAttribute.getDescription())+"\"");
						workFlowsb.append(" finishmode=\""+getStr(nodeAttribute.getFinishmode())+"\"");
						workFlowsb.append(" flowid=\""+getStr(nodeAttribute.getFlowId())+"\"");
						workFlowsb.append(" joinmode=\""+getStr(nodeAttribute.getJoinMode())+"\"");
						workFlowsb.append(" multirestriction=\""+getStr(nodeAttribute.getMultiRestriction())+"\"");
						workFlowsb.append(" performer=\""+getStr(nodeAttribute.getPerformer())+"\"");
						workFlowsb.append(" performerchoiceflag=\""+getStr(nodeAttribute.getPerformerChoiceFlag())+"\"");
						workFlowsb.append(" performermode=\""+getStr(nodeAttribute.getPerformerMode())+"\"");
						workFlowsb.append(" performername=\""+getStr(nodeAttribute.getPerformerName())+"\"");
						workFlowsb.append(" performerpurview=\""+getStr(nodeAttribute.getPerformerPurview())+"\"");
						workFlowsb.append(" performerpurviewname=\""+getStr(nodeAttribute.getPerformerPurviewName())+"\"");
						workFlowsb.append(" performorder=\""+getStr(nodeAttribute.getPerformOrder())+"\"");
						workFlowsb.append(" priority=\""+getStr(nodeAttribute.getPriority())+"\"");
						workFlowsb.append(" readflag=\""+getStr(nodeAttribute.getReadFlag())+"\"");
						workFlowsb.append(" showmessageflag=\""+getStr(nodeAttribute.getShowmessageFlag())+"\"");
						workFlowsb.append(" showpublicflag=\""+getStr(nodeAttribute.getShowpublicFlag())+"\"");
						workFlowsb.append(" splitmode=\""+getStr(nodeAttribute.getSplitMode())+"\"");
						workFlowsb.append(" startflag=\""+getStr(nodeAttribute.getStartflag())+"\"");
						workFlowsb.append(" startmode=\""+getStr(nodeAttribute.getStartmode())+"\"");
						workFlowsb.append(" activorder=\""+nodeAttribute.getActivOrder().toString()+"\"");
						workFlowsb.append(" affixnumber=\""+nodeAttribute.getAffixNumber().toString()+"\"");
						workFlowsb.append(" positionx=\""+nodeAttribute.getPositionX().toString()+"\"");
						workFlowsb.append(" positiony=\""+nodeAttribute.getPositionY().toString()+"\"");
						workFlowsb.append("fillcolor=\"#EEEEEE\" style=\"Z-INDEX: 1; TOP: "+nodeAttribute.getPositionY().toString()+"px; LEFT: "+nodeAttribute.getPositionX().toString()+"px; VERTICAL-ALIGN: middle; WIDTH: 100px; HEIGHT: 50px; CURSOR: hand; POSITION: absolute;   TEXT-ALIGN: center\">");
						workFlowsb.append("<vml:shadow offset=\"3px,3px\" color=\"#b3b3b3\" type=\"single\" on=\"T\"></vml:shadow>");
						workFlowsb.append("<vml:textbox onselectstart=\"return false;\" inset=\"1pt,2pt,1pt,1pt\" style=\"Z-INDEX: 1; TOP: "+nodeAttribute.getPositionY().toString()+"px; LEFT: "+nodeAttribute.getPositionX().toString()+"px; VERTICAL-ALIGN: middle; WIDTH: 100px; HEIGHT: 50px; CURSOR: hand; POSITION: absolute;   TEXT-ALIGN: center\">");
						workFlowsb.append("<br/>"+getStr(nodeAttribute.getActivName()));
						workFlowsb.append("</vml:textbox>");
						workFlowsb.append("</vml:roundrect>");
					}
				}
				Element nodeattElement = workflow.addElement("nodeatt");
				nodeattElement.addAttribute("activid", getStr(nodeAttribute.getActivId()));
				nodeattElement.addAttribute("activname", getStr(nodeAttribute.getActivName()));
				nodeattElement.addAttribute("activtype", getStr(nodeAttribute.getActivType()));
				nodeattElement.addAttribute("actor", getStr(nodeAttribute.getActor()));
				nodeattElement.addAttribute("alerttime", getStr(nodeAttribute.getAlerttime()));
				nodeattElement.addAttribute("deadline", getStr(nodeAttribute.getDeadline()));
				nodeattElement.addAttribute("delete_flag", getStr(nodeAttribute.getDelete_flag()));
				nodeattElement.addAttribute("description", getStr(nodeAttribute.getDescription()));
				nodeattElement.addAttribute("finishmode", getStr(nodeAttribute.getFinishmode()));
				nodeattElement.addAttribute("flowid", getStr(nodeAttribute.getFlowId()));
				nodeattElement.addAttribute("joinmode", getStr(nodeAttribute.getJoinMode()));
				nodeattElement.addAttribute("multirestriction", getStr(nodeAttribute.getMultiRestriction()));
				nodeattElement.addAttribute("performer", getStr(nodeAttribute.getPerformer()));
				nodeattElement.addAttribute("performerchoiceflag", getStr(nodeAttribute.getPerformerChoiceFlag()));
				nodeattElement.addAttribute("performermode", getStr(nodeAttribute.getPerformerMode()));
				nodeattElement.addAttribute("performername", getStr(nodeAttribute.getPerformerName()));
				nodeattElement.addAttribute("performerpurview", getStr(nodeAttribute.getPerformerPurview()));
				nodeattElement.addAttribute("performerpurviewname", getStr(nodeAttribute.getPerformerPurviewName()));
				nodeattElement.addAttribute("performorder", getStr(nodeAttribute.getPerformOrder()));
				nodeattElement.addAttribute("priority", getStr(nodeAttribute.getPriority()));
				nodeattElement.addAttribute("readflag", getStr(nodeAttribute.getReadFlag()));
				nodeattElement.addAttribute("showmessageflag", getStr(nodeAttribute.getShowmessageFlag()));
				nodeattElement.addAttribute("showpublicflag", getStr(nodeAttribute.getShowpublicFlag()));
				nodeattElement.addAttribute("splitmode", getStr(nodeAttribute.getSplitMode()));
				nodeattElement.addAttribute("startflag", getStr(nodeAttribute.getStartflag()));
				nodeattElement.addAttribute("startmode", getStr(nodeAttribute.getStartmode()));
				nodeattElement.addAttribute("activorder", nodeAttribute.getActivOrder().toString());
				nodeattElement.addAttribute("affixnumber", nodeAttribute.getAffixNumber().toString());
				nodeattElement.addAttribute("positionx", nodeAttribute.getPositionX().toString());
				nodeattElement.addAttribute("positiony", nodeAttribute.getPositionY().toString());
				nodeattElement.addAttribute("nodeappatt", nodeAttribute.getNodeAppAtt().toString());
				
			}
			TranceAttribute tranceAttribute = new TranceAttribute();
			for (Iterator tranceIterator = tranceAttVector.iterator(); tranceIterator.hasNext();) {
				tranceAttribute = (TranceAttribute) tranceIterator.next();
				workFlowsb.append("<vml:line id=\""+getStr(tranceAttribute.getTransId())+"\" title=\""+getStr(tranceAttribute.getTransName())+"\"");
				workFlowsb.append(" transId=\""+getStr(tranceAttribute.getTransId())+"\"");
				workFlowsb.append(" flowId=\""+getStr(tranceAttribute.getFlowId())+"\"");
				workFlowsb.append(" transName=\""+getStr(tranceAttribute.getTransName())+"\"");
				workFlowsb.append(" transFlag=\""+getStr(tranceAttribute.getTransFlag())+"\"");
				workFlowsb.append(" transType=\""+getStr(tranceAttribute.getTransType())+"\"");
				workFlowsb.append(" startX=\""+tranceAttribute.getStartX().toString()+"\"");
				workFlowsb.append(" startY=\""+tranceAttribute.getStartY().toString()+"\"");
				workFlowsb.append(" endX=\""+tranceAttribute.getEndX().toString()+"\"");
				workFlowsb.append(" endY=\""+tranceAttribute.getEndY().toString()+"\"");
				workFlowsb.append(" delete_flag=\""+getStr(tranceAttribute.getDelete_flag())+"\"");
				workFlowsb.append(" double_flag=\""+getStr(tranceAttribute.getDouble_flag())+"\"");
				workFlowsb.append(" description=\""+getStr(tranceAttribute.getDescription())+"\"");
				workFlowsb.append(" source=\""+getStr(tranceAttribute.getFromActivId())+"\" object=\""+getStr(tranceAttribute.getToActivId())+"\"");
				workFlowsb.append(" style=\"DISPLAY: none;CURSOR: hand; Z-INDEX: 2; POSITION: absolute\">");
				workFlowsb.append("<vml:stroke endarrow=\"block\"></vml:stroke>");
				workFlowsb.append("<vml:shadow offset=\"1px,1px\" color=\"#b3b3b3\" type=\"single\" on=\"T\"></vml:shadow>");
				//workFlowsb.append("<vml:textbox onselectstart=\"return false;\" inset=\"1pt,2pt,1pt,1pt\">"+tranceAttribute.getTransName()+"</vml:textbox>");
				workFlowsb.append("</vml:line>");
				Element tranceattElement = workflow.addElement("tranceatt");
				tranceattElement.addAttribute("transId", getStr(tranceAttribute.getTransId()));
				tranceattElement.addAttribute("flowId", getStr(tranceAttribute.getFlowId()));
				tranceattElement.addAttribute("fromActivId", getStr(tranceAttribute.getFromActivId()));
				tranceattElement.addAttribute("toActivId", getStr(tranceAttribute.getToActivId()));
				tranceattElement.addAttribute("transName", getStr(tranceAttribute.getTransName()));
				tranceattElement.addAttribute("transFlag", getStr(tranceAttribute.getTransFlag()));
				tranceattElement.addAttribute("transType", getStr(tranceAttribute.getTransType()));
				tranceattElement.addAttribute("description", getStr(tranceAttribute.getDescription()));
				tranceattElement.addAttribute("startX", tranceAttribute.getStartX().toString());
				tranceattElement.addAttribute("startY",tranceAttribute.getStartY().toString());
				tranceattElement.addAttribute("endX", tranceAttribute.getEndX().toString());
				tranceattElement.addAttribute("endY", tranceAttribute.getEndY().toString());
				tranceattElement.addAttribute("delete_flag", getStr(tranceAttribute.getDelete_flag()));
				tranceattElement.addAttribute("double_flag", getStr(tranceAttribute.getDouble_flag()));			
			}
			OutputFormat format = OutputFormat.createPrettyPrint();
			format.setEncoding("UTF-8");
			format.setNewLineAfterDeclaration(false);
			format.setExpandEmptyElements(true);
			format.setSuppressDeclaration(false);
			//response.setContentType("text/xml");
			//response.setCharacterEncoding("UTF-8");
			try {
				//XMLWriter xmlWriter = new XMLWriter(out, format);
				//xmlWriter.write(doc);
				//System.out.println(doc.toString());
				//xmlWriter.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	%>
<HEAD>
<TITLE><%=getFlowName%></TITLE>
<META http-equiv=Content-Type content="text/html; charset=utf-8">
<STYLE>
vml\: * {
	FONT-SIZE: 12px;
	BEHAVIOR: url(#default#VML)
}
vml {behavior: url(#default#VML);position:absolute}
.viewbutton{
  height:25px;
  padding: 3px 5px;
  border: 1px solid #1e90ff;
  border-radius: 2px;
  color: #ffffff;
  background-color:#1e90ff;
  font-weight: bold;
  text-align: center;
  text-decoration: none;
  font-size: 1em;
  font-family: Helvetica, Tahoma, Verdana, sans-serif;
  -webkit-box-shadow: 1px 1px 1px rgba(0, 0, 0, 0.5);
  -moz-box-shadow: 1px 1px 1px rgba(0, 0, 0, 0.5);
  box-shadow: 1px 1px 1px rgba(0, 0, 0, 0.5);
  /*IE6,IE7语法*/
  /*filter:progid:DXImageTransform.Microsoft.dropshadow(OffX=1, OffY=1, Color='#1e90ff');*/
  /*IE8语法,可恶的IE，不同的版本还要写的不一样*/
  /*-ms-filter:"progid:DXImageTransform.Microsoft.dropshadow(OffX=1, OffY=1, Color='#1e90ff')";*/
} 
/**
.viewbutton:hover {
  background-color: #ff9000;
  border: 1px solid #ff9000;
  color: #ffffff;
}
**/
.menu
{
	list-style-type: none;
	list-style-image: none;
	border-bottom: 0px;
	border-left: 0px;
	padding-bottom: 0px;
	font-style: inherit;
	margin: 0px;
	outline-style: none;
	outline-color: invert;
	padding-left: 0px;
	outline-width: 0px;
	padding-right: 0px;
	font-family: inherit;
	font-size: 100%;
	border-top: 0px;
	font-weight: inherit;
	border-right: 0px;
	padding-top: 0px;
}

.clear:after
{
	display: block;
	height: 0px;
	visibility: hidden;
	clear: both;
	content: ".";
}
.clear
{
	display: inline-block;
}
.clear
{
	display: block;
}

.poptab
{
	border-bottom: #c69e8d 1px solid;
	border-left: #c69e8d 1px solid;
	background-color: #ffffff;
	margin: 0px 2px 4px;
	border-top: #c69e8d 1px solid;
	border-right: #c69e8d 1px solid;
}
.poptab .tabtitle
{
	background-image: url(gtab1.gif); DISPLAY: block;
	background-repeat: repeat-x;
	background-position: 0px 0px;
	height: 34px;
}
.poptab H1
{
	padding-bottom: 0px;
	line-height: 30px;
	text-indent: 10px;
	margin: 0px;
	padding-left: 0px;
	padding-right: 0px;
	float: left;
	color: #bf3900;
	font-size: 14px;
	font-weight: bold;
	padding-top: 0px;
}
.poptab H1 A
{
	color: #bf3900;
	text-decoration: none;
}
.poptab UL.menu
{
	line-height: 30px;
	height: 34px;
}
.poptab .tabbt
{
	background-image: url(gtab3.gif); BACKGROUND-REPEAT: no-repeat;
	float: right;
	height: 34px;
}
.poptab .tabbt A
{
	padding-bottom: 0px;
	padding-left: 12px;
	padding-right: 12px;
	display: block;
	float: left;
	height: 34px;
	padding-top: 0px;
	color: #123c5a;
	font-weight:bold;
	text-decoration: none;
}
.poptab .tabbt-on
{
	background-image: url(gtab4.gif); BACKGROUND-REPEAT: no-repeat;
	float: right;
	height: 34px;
}
.poptab .tabbt-on A
{
	background-image: url(gtab2.gif); PADDING-BOTTOM: 0px;
	padding-left: 12px;
	padding-right: 12px;
	display: block;
	background-repeat: no-repeat;
	background-position: center 50%;
	float: left;
	height: 34px;
	text-decoration: none;
	padding-top: 0px;
	color: #bf3900;
	font-weight:bold;
	text-decoration: none;
}
.poptab .tabpad
{
	padding-bottom: 5px;
	padding-left: 5px;
	padding-right: 5px;
	display: none;
	clear: both;
	padding-top: 2px;
}


.table {
	table-layout:automatic;
	border:0;
	padding: 2px 6px;
	border-collapse:collapse;
	width:95%;
	border-left:1px solid #a5cdf0;
	border-top:1px solid #a5cdf0;
}

.toptd {
	FONT-FAMILY: "宋体";
	font-size: 9pt;
	color: ffffff;
	border-color: white #1454B1 #1454B1 white;
	background-color: #3878DB;
	padding-top: 3px;
	padding-right: 6px;
	padding-bottom: 2px;
	padding-left: 6px;
	letter-spacing: 1px;
	background-position: center top;
	text-align: left;
	vertical-align: top;
	border-style: solid;
	border-top-width: 1px;
	border-right-width: 1px;
	border-bottom-width: 1px;
	border-left-width: 1px;
	font-weight: bold
}

.deeptd {
	/**table-layout:fixed;**/
	vertical-align: middle;
	FONT-FAMILY: "宋体";
	font-size: 9pt;
	color: #000000;
	border-right:1px solid #a5cdf0;
	border-bottom:1px solid #a5cdf0;
	background-color: #eef7ff;
	margin:0px 0px 0px 0px;
	padding-top: 1px;
	padding-bottom: 3px;
	padding-left: 6px;
	padding-right: 6px;
	letter-spacing: 0px;
	background-position: center top;
	text-align: left;
	height: 25px;
	line-height:25px;
	word-wrap:break-word;
	word-break:normal;
	word-break:break-all;
}

.tinttd {
	vertical-align: middle;
	FONT-FAMILY: "宋体";
	font-size: 9pt;
	color: #000000;
	border-right:1px solid #a5cdf0;
	border-bottom:1px solid #a5cdf0;
	background-color: #ffffff;
	margin:0px 0px 0px 0px;
	padding-top: 1px;
	padding-bottom: 3px;
	padding-left: 6px;
	padding-right: 6px;
	letter-spacing: 0px;
	background-position: center top;
	text-align: left;
	height: 25px;
	line-height:25px;
	word-wrap:break-word;
	word-break:normal;
	word-break:break-all;
}
.formbutton{
	height:24px;
	padding:0 5px;
	color:#fff;
	font-family:"微软雅黑","宋体","仿宋_gb2312","楷体_gb2312";
	font-weight:bold;
	cursor:hand;
	background:#158fee;
	border:#0181e4 1px solid;
	-webkit-box-flex:1;
	-moz-border-radius:2px;
	-webkit-border-radius:2px;
	border-radius:2px;
	-moz-box-shadow:0 1px 3px #999;
	-webkit-box-shadow:0 1px 3px #999;
	box-shadow:0 1px 3px #999;
}
.altbtn{
	background:#158fee;
	border:#0181e4 1px solid;
}
.defaultbtn{
	background:#f37703;
	border:#e45d01 1px solid;
}
</STYLE>
<script language="javascript" type="text/javascript" charset="utf-8" src="<%=contextPath%>/resources/js/jquery/jquery.js"></script>
<script language="javascript" type="text/javascript" charset="utf-8" src="<%=contextPath%>/resources/js/jquery/jquery.divbox.js"></script>

<SCRIPT>
	//--- 图形化设计 ---
	var dragapproved = false;
	var eventsource, x, y;
	var popeventsource = "";
	var temp1 = 0;
	var temp2 = 0;

	function nocontextmenu() {
		event.cancelBubble = true
		event.returnValue = false;

		return false;
	}

	//-- 初始化移动参数 --
	function nodrags() {
		dragapproved = false;
	}

	function move() {
		if (event.button == 1 && dragapproved) {
			var newleft = temp1 + event.clientX - x;
			var newtop = temp2 + event.clientY - y;
			if(newleft<0){
				newleft = 0;
			}
			if(newtop<0){
				newtop = 0;
			}
			eventsource.style.pixelLeft = newleft;
			eventsource.style.pixelTop = newtop;

			drawLine();
			return false;
		}
	}

	function drags() {
		if (event.button != 1)
			return;

		var objRect = event.srcElement;
		if (event.srcElement.tagName.toLowerCase() == 'textbox')
			objRect = event.srcElement.parentElement;

		if ((objRect.tagName == 'roundrect') && (!event.ctrlKey)) {
			dragapproved = true;
			eventsource = objRect;
			temp1 = eventsource.style.pixelLeft;
			temp2 = eventsource.style.pixelTop;
			x = event.clientX;
			y = event.clientY;
			document.onmousemove = move;
		}
	}

	//-- 画线 --
	function drawLine() {
		var source;
		var object;
		var sourceObj;
		var objectObj;
		var x0, y0, x1, y1;
		var p0, p1;
		var a = document.getElementsByTagName('line');
		for ( var i = 0; i < a.length; i++) {
			source = a[i].getAttribute('source');
			object = a[i].getAttribute('object');
			if ((source != null) && (object != null)) {
				sourceObj = document.getElementById(source);
				objectObj = document.getElementById(object);

				if ((sourceObj == null) || (objectObj == null))
					continue;

				if (sourceObj.style.pixelLeft > objectObj.style.pixelLeft) {
					if ((sourceObj.style.pixelLeft - objectObj.style.pixelLeft) <= objectObj.style.pixelWidth) {
						x0 = sourceObj.style.pixelLeft + sourceObj.style.pixelWidth / 4;
						x1 = objectObj.style.pixelLeft + objectObj.style.pixelWidth * 3 / 4;
						if (sourceObj.style.pixelTop > objectObj.style.pixelTop) {
							y0 = sourceObj.style.pixelTop;
							y1 = objectObj.style.pixelTop + objectObj.style.pixelHeight;
						} else {
							y0 = sourceObj.style.pixelTop + sourceObj.style.pixelHeight;
							y1 = objectObj.style.pixelTop;
						}
					} else {
						x0 = sourceObj.style.pixelLeft;
						x1 = objectObj.style.pixelLeft + objectObj.style.pixelWidth;
						y0 = sourceObj.style.pixelTop + sourceObj.style.pixelHeight / 4;
						y1 = objectObj.style.pixelTop + objectObj.style.pixelHeight * 3 / 4;
					}
				} else {
					if ((objectObj.style.pixelLeft - sourceObj.style.pixelLeft) <= objectObj.style.pixelWidth) {
						x0 = sourceObj.style.pixelLeft + sourceObj.style.pixelWidth / 4;
						x1 = objectObj.style.pixelLeft + objectObj.style.pixelWidth * 3 / 4;
						if (sourceObj.style.pixelTop > objectObj.style.pixelTop) {
							y0 = sourceObj.style.pixelTop;
							y1 = objectObj.style.pixelTop + objectObj.style.pixelHeight;
						} else {
							y0 = sourceObj.style.pixelTop + sourceObj.style.pixelHeight;
							y1 = objectObj.style.pixelTop;
						}
					} else {
						x0 = sourceObj.style.pixelLeft + sourceObj.style.pixelWidth;
						x1 = objectObj.style.pixelLeft;
						y0 = sourceObj.style.pixelTop + sourceObj.style.pixelHeight / 4;
						y1 = objectObj.style.pixelTop + objectObj.style.pixelHeight * 3 / 4;
					}
				}

				a[i].from = String(x0) + ',' + String(y0);
				a[i].to = String(x1) + ',' + String(y1);

				a[i].style.pixelLeft = x0 + 'px';
				a[i].style.pixelTop = y0 + 'px';

				//条件
				strIF = a[i].getAttribute('title');
				if ((strIF != null) && (strIF != '')) {
					var id = 'if_' + source + '_' + object;
					var obj = document.getElementById(id);

					var left = (x0 + (x1 - x0) / 2 - 30);
					var top = (y0 + (y1 - y0) / 2 - 15);

					if (obj != null) {
						obj.style.pixelLeft = left + 'px';
						obj.style.pixelTop = top + 'px';

						obj.style.left = left + 'px';
						obj.style.top = top + 'px';

						obj.style.display = '';
					}
				}

				a[i].style.display = '';
			}
		}
	}

	//表单加载完成
	document.onreadystatechange = function() {
		if (document.readyState == 'complete') {
			drawLine();
			document.onmousedown = drags; //开始移动
			document.onmouseup = nodrags; //结束移动
		}
	}

	// 形成菜单行
	function getMenuRow(s_Event, s_Html) {
		var s_MenuRow = "";
		s_MenuRow = "<tr><td align=center valign=middle nowrap><TABLE border=0 cellpadding=0 cellspacing=0 width=132><tr><td nowrap valign=middle height=20 class=MouseOut onMouseOver=this.className='MouseOver'; onMouseOut=this.className='MouseOut';";
		s_MenuRow += " onclick=\"parent." + s_Event
				+ ";parent.oPopupMenu.hide();\"";
		s_MenuRow += ">&nbsp;";
		s_MenuRow += s_Html + "<\/td><\/tr><\/TABLE><\/td><\/tr>";
		return s_MenuRow;
	}

	//-- 右键菜单 --
	var sMenuHr = "<tr><td align=center valign=middle height=2><TABLE border=0 cellpadding=0 cellspacing=0 width=128 height=2><tr><td height=1 class=HrShadow><\/td><\/tr><tr><td height=1 class=HrHighLight><\/td><\/tr><\/TABLE><\/td><\/tr>";
	var sMenu1 = "<TABLE onmousedown='if (event.button==1) return true; else return false;' border=0 cellpadding=0 cellspacing=0 class=Menu width=150><tr><td width=18 valign=bottom align=center style='background:url(/images/bg_left.gif.gif);background-position:bottom;'><\/td><td width=132 class=RightBg><TABLE border=0 cellpadding=0 cellspacing=0>";
	var sMenu2 = "<\/TABLE><\/td><\/tr><\/TABLE>";
	var oPopupMenu = null;
	oPopupMenu = window.createPopup();


	function showContextMenu(event, type) {
		var style = "";
		style = "BODY {margin:0px;border:0px}";
		style += " TD {font-size:9pt;font-family:宋体,Verdana,Arial}";
		style += " TABLE.Menu {border-top:window 1px solid;border-left:window 1px solid;border-bottom:buttonshadow 1px solid;border-right:buttonshadow 1px solid;background-color:#0072BC}";
		style += "TD.RightBg {background-color:buttonface}";
		style += "TD.MouseOver {background-color:highlight;color:highlighttext;cursor:default;}";
		style += "TD.MouseOut {background-color:buttonface;color:buttontext;cursor:default;}";
		style += "TD.HrShadow {background-color:buttonshadow;}";
		style += "TD.HrHighLight {background-color:buttonhighlight;}";
		style = "<style>" + style + "</style>";

		var width = 150;
		var height = 0;
		var lefter = event.clientX;
		var topper = event.clientY;

		var oPopDocument = oPopupMenu.document;
		var oPopBody = oPopupMenu.document.body;

		//object
		var objRect = event.srcElement;
		if (event.srcElement.tagName.toLowerCase() == 'textbox')
			objRect = event.srcElement.parentElement;

		var Process_ID = objRect.getAttribute('id');

		var sMenu = style;

		switch (type) {
		case 1:

			sMenu += getMenuRow("EditFlowActiv('"+Process_ID+"')", "节点属性");
			height += 20;

			sMenu += sMenuHr;
			height += 2;

			sMenu += getMenuRow("DelFlowActiv('"+Process_ID+"')", "删除节点");
			height += 20;

			break;

		case 2:

			sMenu += getMenuRow("Add_Process()", "新建步骤");
			height += 20;

			sMenu += sMenuHr;
			height += 2;

			sMenu += getMenuRow("SavePosition()", "保存布局");
			height += 20;

			sMenu += getMenuRow("Refresh()", "刷新视图");
			height += 20;

			break;
		
		 case 3:
			sMenu += getMenuRow("EditFlowTrans('"+Process_ID+"')", "流向属性");
			height += 20;

			sMenu += sMenuHr;
			height += 2;

			sMenu += getMenuRow("DelFlowTrans('"+Process_ID+"')", "删除流向");
			height += 20;
		 break;
		 
		}

		sMenu = sMenu1 + sMenu + sMenu2;

		height += 2;
		if (lefter + width > document.body.clientWidth)
			lefter = lefter - width + 2;
		if (topper + height > document.body.clientHeight)
			topper = topper - height + 2;

		oPopupMenu.document.body.innerHTML = sMenu;
		oPopupMenu.show(lefter, topper, width, height, document.body);

		return false;
	}	
	//添加流向编辑状态
	var isTransAdd = false;
	var temp_TransSource;
	function AddFlowTrans(obj){
		if(!isTransAdd){
			isTransAdd = true;
			$(obj).addClass("defaultbtn");
		}else{
			isTransAdd = false;
			$(obj).removeClass("defaultbtn");
		}
	}
	function DelFlowTrans(fid) {
		if ((fid == null) || (fid == ''))
			return;
		$("#"+fid+"").remove();
	}
	function DelFlowActiv(fid) {
		if ((fid == null) || (fid == ''))
			return;
		$("line[object='"+fid+"']").each(function(){
			$(this).remove()
		});
		$("line[source='"+fid+"']").each(function(){
			$(this).remove()
		});
		$("#"+fid+"").remove();
	}
	function getFlowXML(){
		//创建xml
		var xmldoc=new ActiveXObject("Microsoft.XMLDOM");

		//创建一个根节点，并添加到xml
		var workflow=xmldoc.createElement("workflow");
		xmldoc.appendChild(workflow);

		var flowatt=xmldoc.createElement("flowatt");
		workflow.appendChild(flowatt);
		flowatt.setAttribute("administrator",$("#workflowinfo").attr("administrator"));
		flowatt.setAttribute("applicationid",$("#workflowinfo").attr("applicationid"));
		flowatt.setAttribute("creator",$("#workflowinfo").attr("creator"));
		flowatt.setAttribute("delete_flag",$("#workflowinfo").attr("delete_flag"));
		flowatt.setAttribute("description",$("#workflowinfo").attr("description"));
		flowatt.setAttribute("flowactor",$("#workflowinfo").attr("flowactor"));
		flowatt.setAttribute("flowid",$("#workflowinfo").attr("flowid"));
		flowatt.setAttribute("flowname",$("#workflowinfo").attr("flowname"));
		flowatt.setAttribute("flowrange",$("#workflowinfo").attr("flowrange"));
		flowatt.setAttribute("flowrangename",$("#workflowinfo").attr("flowrangename"));
		flowatt.setAttribute("flowstatus",$("#workflowinfo").attr("flowstatus"));
		flowatt.setAttribute("flowtype",$("#workflowinfo").attr("flowtype"));
		flowatt.setAttribute("moduleid",$("#workflowinfo").attr("moduleid"));
		flowatt.setAttribute("createtime",$("#workflowinfo").attr("createtime"));
		flowatt.setAttribute("floworder",$("#workflowinfo").attr("floworder"));


		$("roundrect").each(function(){
			var nodeatt=xmldoc.createElement("nodeatt");
			workflow.appendChild(nodeatt);
			nodeatt.setAttribute("activid", $(this).attr("activid"));
			nodeatt.setAttribute("activname", $(this).attr("activname"));
			nodeatt.setAttribute("activtype", $(this).attr("activtype"));
			nodeatt.setAttribute("actor", $(this).attr("actor"));
			nodeatt.setAttribute("alerttime", $(this).attr("alerttime"));
			nodeatt.setAttribute("deadline", $(this).attr("deadline"));
			nodeatt.setAttribute("delete_flag", $(this).attr("delete_flag"));
			nodeatt.setAttribute("description", $(this).attr("description"));
			nodeatt.setAttribute("finishmode", $(this).attr("finishmode"));
			nodeatt.setAttribute("flowid", $(this).attr("flowid"));
			nodeatt.setAttribute("joinmode", $(this).attr("joinmode"));
			nodeatt.setAttribute("multirestriction", $(this).attr("multirestriction"));
			nodeatt.setAttribute("performer", $(this).attr("performer"));
			nodeatt.setAttribute("performerchoiceflag", $(this).attr("performerchoiceflag"));
			nodeatt.setAttribute("performermode", $(this).attr("performermode"));
			nodeatt.setAttribute("performername", $(this).attr("performername"));
			nodeatt.setAttribute("performerpurview", $(this).attr("performerpurview"));
			nodeatt.setAttribute("performerpurviewname", $(this).attr("performerpurviewname"));
			nodeatt.setAttribute("performorder", $(this).attr("performorder"));
			nodeatt.setAttribute("priority", $(this).attr("priority"));
			nodeatt.setAttribute("readflag", $(this).attr("readflag"));
			nodeatt.setAttribute("showmessageflag", $(this).attr("showmessageflag"));
			nodeatt.setAttribute("showpublicflag", $(this).attr("showpublicflag"));
			nodeatt.setAttribute("splitmode", $(this).attr("splitmode"));
			nodeatt.setAttribute("startflag", $(this).attr("startflag"));
			nodeatt.setAttribute("startmode", $(this).attr("startmode"));
			nodeatt.setAttribute("activorder", $(this).attr("activorder"));
			nodeatt.setAttribute("affixnumber", $(this).attr("affixnumber"));
			nodeatt.setAttribute("positionx", $(this).attr("positionx"));
			nodeatt.setAttribute("positiony", $(this).attr("positiony"));
		});
		$("line").each(function(){
			var tranceatt=xmldoc.createElement("tranceatt");
			workflow.appendChild(tranceatt);
			tranceatt.setAttribute("transId",$(this).attr("transId"));
			tranceatt.setAttribute("flowId",$(this).attr("flowId"));
			tranceatt.setAttribute("fromActivId",$(this).attr("source"));
			tranceatt.setAttribute("toActivId",$(this).attr("object"));
			tranceatt.setAttribute("transName",$(this).attr("transName"));
			tranceatt.setAttribute("transFlag",$(this).attr("transFlag"));
			tranceatt.setAttribute("transType",$(this).attr("transType"));
			tranceatt.setAttribute("description",$(this).attr("description"));
			tranceatt.setAttribute("startX",$(this).attr("startX"));
			tranceatt.setAttribute("startY",$(this).attr("startY"));
			tranceatt.setAttribute("endX",$(this).attr("endX"));
			tranceatt.setAttribute("endY",$(this).attr("endY"));
			tranceatt.setAttribute("delete_flag",$(this).attr("delete_flag"));
			tranceatt.setAttribute("double_flag",$(this).attr("double_flag"));
		});
		alert(xmldoc.xml);
	}
	
	
	function EditFlowAtt(){
		$("#flow_administrator").val($("#workflowinfo").attr("administrator"));
		$("#flow_applicationid").val($("#workflowinfo").attr("applicationid"));
		$("#flow_creator").val($("#workflowinfo").attr("creator"));
		//$("#flow_delete_flag").val($("#workflowinfo").attr("delete_flag"));
		$("#flow_description").val($("#workflowinfo").attr("description"));
		$("#flow_flowactor").val($("#workflowinfo").attr("flowactor"));
		$("#flow_flowid").val($("#workflowinfo").attr("flowid"));
		$("#flow_flowname").val($("#workflowinfo").attr("flowname"));
		$("#flow_flowrange").val($("#workflowinfo").attr("flowrange"));
		$("#flow_flowrangename").val($("#workflowinfo").attr("flowrangename"));
		$("#flow_flowstatus").val($("#workflowinfo").attr("flowstatus"));
		$("#flow_flowtype").val($("#workflowinfo").attr("flowtype"));
		$("#flow_moduleid").val($("#workflowinfo").attr("moduleid"));
		//$("#flow_createtime").val($("#workflowinfo").attr("createtime"));
		$("#flow_floworder").val($("#workflowinfo").attr("floworder"));
		$("#flowattdiv").OpenDiv();
	}
	function SaveFlowAtt(){
		$("#workflowinfo").attr("administrator",$("#flow_administrator").val());
		$("#workflowinfo").attr("applicationid",$("#flow_applicationid").val());
		$("#workflowinfo").attr("creator",$("#flow_creator").val());
		//$("#workflowinfo").attr("delete_flag",$("#flow_delete_flag").val());
		$("#workflowinfo").attr("description",$("#flow_description").val());
		$("#workflowinfo").attr("flowactor",$("#flow_flowactor").val());
		$("#workflowinfo").attr("flowid",$("#flow_flowid").val());
		$("#workflowinfo").attr("flowname",$("#flow_flowname").val());
		$("#workflowinfo").attr("flowrange",$("#flow_flowrange").val());
		$("#workflowinfo").attr("flowrangename",$("#flow_flowrangename").val());
		$("#workflowinfo").attr("flowstatus",$("#flow_flowstatus").val());
		$("#workflowinfo").attr("flowtype",$("#flow_flowtype").val());
		$("#workflowinfo").attr("moduleid",$("#flow_moduleid").val());
		//$("#workflowinfo").attr("createtime",$("#flow_createtime").val());
		$("#workflowinfo").attr("floworder",$("#flow_floworder").val());
		$("#flowattdiv").CloseDiv();
	}
	function EditFlowActiv(activid){
		$("#node_activid").val($("#"+activid).attr("activid"));
		$("#node_activname").val($("#"+activid).attr("activname"));
		//$("#node_activtype").val($("#"+activid).attr("activtype"));
		//$("#node_actor").val($("#"+activid).attr("actor"));
		//$("#node_alerttime").val($("#"+activid).attr("alerttime"));
		$("#node_deadline").val($("#"+activid).attr("deadline"));
		//$("#node_delete_flag").val($("#"+activid).attr("delete_flag"));
		$("#node_description").val($("#"+activid).attr("description"));
		//$("#node_finishmode").val($("#"+activid).attr("finishmode"));
		//$("#node_flowid").val($("#"+activid).attr("flowid"));
		$("#node_joinmode").val($("#"+activid).attr("joinmode"));
		//$("#node_multirestriction").val($("#"+activid).attr("multirestriction"));
		$("#node_performer").val($("#"+activid).attr("performer"));
		$("#node_performerchoiceflag").val($("#"+activid).attr("performerchoiceflag"));
		$("#node_performermode").val($("#"+activid).attr("performermode"));
		$("#node_performername").val($("#"+activid).attr("performername"));
		$("#node_performerpurview").val($("#"+activid).attr("performerpurview"));
		$("#node_performerpurviewname").val($("#"+activid).attr("performerpurviewname"));
		$("#node_performorder").val($("#"+activid).attr("performorder"));
		//$("#node_priority").val($("#"+activid).attr("priority"));
		$("#node_readflag").val($("#"+activid).attr("readflag"));
		//$("#node_showmessageflag").val($("#"+activid).attr("showmessageflag"));
		//$("#node_showpublicflag").val($("#"+activid).attr("showpublicflag"));
		$("#node_splitmode").val($("#"+activid).attr("splitmode"));
		$("#node_startflag").val($("#"+activid).attr("startflag"));
		//$("#node_startmode").val($("#"+activid).attr("startmode"));
		$("#node_activorder").val($("#"+activid).attr("activorder"));
		//$("#node_affixnumber").val($("#"+activid).attr("affixnumber"));
		$("#node_positionx").val($("#"+activid).attr("positionx"));
		$("#node_positiony").val($("#"+activid).attr("positiony"));
		$("#nodeattdiv").OpenDiv();
	}
	function SaveFlowActiv(activid){
		$("#"+activid).attr("transName",$("#transName").val());
		$("#"+activid).attr("activid",$("#node_activid").val());
		$("#"+activid).attr("activname",$("#node_activname").val());
		//$("#node_activtype").val($("#"+activid).attr("activtype"));
		//$("#node_actor").val($("#"+activid).attr("actor"));
		//$("#node_alerttime").val($("#"+activid).attr("alerttime"));
		$("#"+activid).attr("deadline",$("#node_deadline").val());
		//$("#node_delete_flag").val($("#"+activid).attr("delete_flag"));
		$("#"+activid).attr("description",$("#node_description").val());
		//$("#node_finishmode").val($("#"+activid).attr("finishmode"));
		//$("#node_flowid").val($("#"+activid).attr("flowid"));
		$("#"+activid).attr("joinmode",$("#node_joinmode").val());
		//$("#node_multirestriction").val($("#"+activid).attr("multirestriction"));
		$("#"+activid).attr("performer",$("#node_performer").val());
		$("#"+activid).attr("performerchoiceflag",$("#node_performerchoiceflag").val());
		$("#"+activid).attr("performermode",$("#node_performermode").val());
		$("#"+activid).attr("performername",$("#node_performername").val());
		$("#"+activid).attr("performerpurview",$("#node_performerpurview").val());
		$("#"+activid).attr("performerpurviewname",$("#node_performerpurviewname").val());
		$("#"+activid).attr("performorder",$("#node_performorder").val());
		//$("#node_priority").val($("#"+activid).attr("priority"));
		$("#"+activid).attr("readflag",$("#node_readflag").val());
		//$("#node_showmessageflag").val($("#"+activid).attr("showmessageflag"));
		//$("#node_showpublicflag").val($("#"+activid).attr("showpublicflag"));
		$("#"+activid).attr("splitmode",$("#node_splitmode").val());
		$("#"+activid).attr("startflag",$("#node_startflag").val());
		//$("#node_startmode").val($("#"+activid).attr("startmode"));
		$("#"+activid).attr("activorder",$("#node_activorder").val());
		//$("#node_affixnumber").val($("#"+activid).attr("affixnumber"));
		$("#"+activid).attr("positionx",$("#node_positionx").val());
		$("#"+activid).attr("positiony",$("#node_positiony").val());
		$("#nodeattdiv").CloseDiv();
	}
	function EditFlowTrans(transId){
		$("#transTransId").val($("#"+transId).attr("transId"));
		$("#transName").val($("#"+transId).attr("transName"));
		$("#transFlag").val($("#"+transId).attr("transFlag"));
		$("#transType").val($("#"+transId).attr("transType"));
		$("#transDescription").val($("#"+transId).attr("description"));
		$("#tranceattdiv").OpenDiv();
	}
	function SaveFlowTrans(transId){
		$("#"+transId).attr("transName",$("#transName").val());
		$("#"+transId).attr("transFlag",$("#transFlag").val());
		$("#"+transId).attr("transType",$("#transType").val());
		$("#"+transId).attr("description",$("#transDescription").val());
		$("#tranceattdiv").CloseDiv();
	}
	//-- 鼠标右击 --
	function DoRightClick() {
		pub_x = event.clientX;
		pub_y = event.clientY;

		SetSel();
	}

	//-- 选择步骤 --
	function SetSel() {
		var flowType = '';
		var flowID = 0;
		var passCount = 0;
		var flowColor = '';
		var strStart = "#00EE00";
		var strEnd = "#F4A8BD";
		var strOut = "#EEEEEE";
		var strSelect = "#8E83F5";

		var vml = document.getElementsByTagName('roundrect');
		for ( var i = 0; i < vml.length; i++) {
			flowType = vml[i].getAttribute('flowType');
			if (flowType == 'start') {
				flowColor = strStart;
			} else if (flowType == 'end') {
				flowColor = strEnd;
			} else {
				flowColor = strOut;
			}
			vml[i].fillcolor = flowColor;
		}

		var objRect = event.srcElement;
		if (event.srcElement.tagName.toLowerCase() == 'textbox')
			objRect = event.srcElement.parentElement;

		//步骤类型
		//flowType = objRect.getAttribute('flowType');
		try {
			if (objRect.tagName == 'roundrect')
				objRect.fillcolor = strSelect;
		} catch (e) {
		}
	}

	//-- 删除流程线 --
	function SetSqlDelFlow(fid) {
		var strSql = '';
		strSql = "delete from office_missive_flow_run where office_missive_flow_run_id='"
				+ fid + "' ";
		document.all('tbSQL').value += strSql;
	}

	//-- 保存布局 --
	function SavePosition() {
		var id = 0;
		var strSql = '';
		var mf_pixel_left = 0;
		var mf_pixel_top = 0;

		a = document.getElementsByTagName('roundrect');
		for ( var i = 0; i < a.length; i++) {
			table_id = eval(a[i].getAttribute('table_id'));
			mf_pixel_left = a[i].style.pixelLeft;
			mf_pixel_top = a[i].style.pixelTop;

			if (table_id > 0) {
				strSql += "SET_LEFT=" + mf_pixel_left + ",SET_TOP="
						+ mf_pixel_top + " where ID=" + table_id + ";";
			}
		}

		document.form1.SET_SQL.value += strSql;
		document.form1.submit();
	}

	//-- 删除流程线 --
	function DelFlowRun(fid) {
		if ((fid == null) || (fid == 0))
			return;

		SavePosition();
		SetSqlDelFlow(fid);

		document.all('btnSave').click();
	}

	//-- 刷新 --
	function Refresh() {
		location.href = location.href;
	}

	function LoadWindow(URL) {
		loc_x = (screen.availWidth - 600) / 2;
		loc_y = (screen.availHeight - 500) / 2;
		URL += "&GRAPH=1";
		window
				.open(
						URL,
						"set_process",
						"height=500,width=600,status=1,toolbar=no,menubar=no,location=no,scrollbars=yes,top="
								+ loc_y + ",left=" + loc_x + ",resizable=yes");
	}

	//新建步骤
	function Add_Process() {
		LoadWindow("../view_list/edit.php?FLOW_ID=" + flow_id);
	}

	//编辑步骤属性
	function Edit_Process(Process_ID) {
		LoadWindow("../view_list/edit.php?FLOW_ID=" + flow_id + "&ID="
				+ Process_ID);
	}

	function set_item(Process_ID) {
		LoadWindow("../view_list/set_item.php?FLOW_ID=" + flow_id + "&ID="
				+ Process_ID);
	}

	function set_user(Process_ID) {
		LoadWindow("../view_list/set_user.php?FLOW_ID=" + flow_id + "&ID="
				+ Process_ID);
	}

	function set_dept(Process_ID) {
		LoadWindow("../view_list/set_dept.php?FLOW_ID=" + flow_id + "&ID="
				+ Process_ID);
	}

	function set_priv(Process_ID) {
		LoadWindow("../view_list/set_priv.php?FLOW_ID=" + flow_id + "&ID="
				+ Process_ID);
	}

	//删除步骤
	function Del_Process(Process_ID) {
		msg = '确认要删除该步骤么？';
		if (window.confirm(msg))
			window.location = "../view_list/delete.php?GRAPH=1&FLOW_ID="
					+ flow_id + "&ID=" + Process_ID;
	}

	//================================================
	var userAgent = navigator.userAgent.toLowerCase();
	var is_opera = userAgent.indexOf('opera') != -1 && opera.version();
	var is_ie = (userAgent.indexOf('msie') != -1 && !is_opera)
			&& userAgent.substr(userAgent.indexOf('msie') + 5, 3);
	function MouseOverBtn() {
		event.srcElement.className += "Hover";
	}
	function MouseOutBtn() {
		event.srcElement.className = event.srcElement.className.substr(0,
				event.srcElement.className.indexOf("Hover"));
	}
	function CorrectButton() {
		var inputs = document.getElementsByTagName("INPUT");
		for ( var i = 0; i < inputs.length; i++) {
			var el = inputs[i];
			var elType = el.type.toLowerCase();
			var elClass = el.className.toLowerCase();
			var elLength = el.value.length;
			if (elType != "button" && elType != "submit" && elType != "reset"
					|| elClass != "bigbutton" && elClass != "smallbutton")
				continue;

			if (elLength <= 3)
				el.className += "A";
			else if (elLength == 4)
				el.className += "B";
			else if (elLength >= 5 && elLength <= 7)
				el.className += "C";
			else if (elLength >= 8 && elLength <= 11)
				el.className += "D";
			else
				el.className += "E";

			if (is_ie) {
				el.attachEvent("onmouseover", MouseOverBtn);
				el.attachEvent("onmouseout", MouseOutBtn);
			}
		}
	}
	if (is_ie)
		window.attachEvent("onload", CorrectButton);
	else
		window.addEventListener("load", CorrectButton, false);
</SCRIPT>
<script>
$(function(){
    $('roundrect').mousedown(function(e){
        if(e.which==3){ // 1 = 鼠标左键 left; 2 = 鼠标中键; 3 = 鼠标右键
            showContextMenu(event,1);
        }
		if(e.which==1){ // 1 = 鼠标左键 left; 2 = 鼠标中键; 3 = 鼠标右键
            if(isTransAdd){
				var objRect = event.srcElement;
				if (event.srcElement.tagName.toLowerCase() == 'textbox'){
					objRect = event.srcElement.parentElement;
				}
				
				if(temp_TransSource!=null){
					var objRect2 = event.srcElement;
					if (event.srcElement.tagName.toLowerCase() == 'textbox'){
						objRect2 = event.srcElement.parentElement;
					}
					var hasLine = $("line[source='"+temp_TransSource+"'][object='"+objRect2.getAttribute('id')+"']");
					if(temp_TransSource!=objRect2.getAttribute('id')){
						$("body").append("<vml:line id='"+((new Date()).getTime())+"' title='' transId='' flowId='"+$("#workflowinfo").attr("flowid")+"' transName='' transFlag='0' transType='half' startX='472' startY='115' endX='328' endY='468' delete_flag='0' double_flag='1' description='' source='"+temp_TransSource+"' object='"+objRect2.getAttribute('id')+"' style='DISPLAY: none;CURSOR: hand; Z-INDEX: 2; POSITION: absolute'><vml:stroke endarrow='block'></vml:stroke><vml:shadow offset='1px,1px' color='#b3b3b3' type='single' on='T'></vml:shadow></vml:line>");
						temp_TransSource = null;
						isTransAdd = false;
						$("#addtranslink").removeClass("defaultbtn");
						$('line').mousedown(function(e){
							if(e.which==3){ // 1 = 鼠标左键 left; 2 = 鼠标中键; 3 = 鼠标右键
								showContextMenu(event,3);
							}
						});
						drawLine();
					}
				}else{
					temp_TransSource = objRect.getAttribute('id');
				}
			}
        }
    });
    $('line').mousedown(function(e){
        if(e.which==3){ // 1 = 鼠标左键 left; 2 = 鼠标中键; 3 = 鼠标右键
            showContextMenu(event,3);
        }
    });
	/**
	$('roundrect').dbclick(function(){
        var objRect = event.srcElement;
		if (event.srcElement.tagName.toLowerCase() == 'textbox'){
			objRect = event.srcElement.parentElement;
		}
		var Process_ID = objRect.getAttribute('id');
		EditFlowAtt(Process_ID);
    });
	**/
});
$(document).bind("contextmenu", function() { return false; }); 
</script>
</HEAD>
<BODY leftMargin=2 topMargin=2>
	<table>
		<tr>
			<td>
				<a id="addtranslink" class="viewbutton" href="javascript:void(0);" onclick="AddFlowTrans(this);">添加流向</a>
				<a class="viewbutton" href="javascript:EditFlowAtt();void(0);">流程属性</a>
				<a class="viewbutton" href="javascript:getFlowXML();void(0);">保存流程</a>
				<a class="viewbutton" href="javascript:AddFlowTrans();void(0);">复制流程</a>
				<a class="viewbutton" href="javascript:AddFlowTrans();void(0);">粘贴流程</a>
				<a class="viewbutton" href="javascript:DelFlow();void(0);">删除流程</a>
			</td>
			<tr>
				<td id="workflowdiv">
					<%=workFlowsb.toString()%>
				</td>
			</tr>
	</table>
	<DIV id="flowattdiv" class="poptab" style="display:none;width:640px;height:320px;text-align:center;">
		<SPAN class="tabtitle">
			<H1>
				<A title="" href="#">编辑流程属性</A>
			</H1>
			<UL class="menu">
				<LI class="tabbt">
					<A href="javascript:$('#flowattdiv').CloseDiv();" style="color:red;font-weight:bold;">关闭窗口</A>
				</LI>
				<LI class="tabbt-on">
					<A href="#">流程属性</A>
				</LI>
			</UL>
		</SPAN>
		<DIV id="flowatt_flowdiv" style="DISPLAY: block" class="tabpad">
			<input type="hidden" id="flow_flowid" />
			<table class="table">
				<tr>
					<td class="deeptd" style="width:60px;">流程名称</td>
					<td class="tinttd">
						<input type="text" id="flow_flowname">
					</td>
					<td class="deeptd">流程类型</td>
					<td class="tinttd">
						<select id="flow_flowtype" style="width:155px;">
							<option value="normal">普通流程</option>
							<option value="soft">柔性流程</option>
							<option value="subflow">子流程</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="deeptd">流程管理员</td>
					<td class="tinttd">
						<input type="text" id="flow_administrator">
					</td>
					<td class="deeptd">流程创建者</td>
					<td class="tinttd">
						<input type="text" id="flow_creator">
					</td>
				</tr>
				<tr>
					<td class="deeptd">流程排序</td>
					<td class="tinttd">
						<input type="text" id="flow_floworder">
					</td>
					<td class="deeptd">流程状态</td>
					<td class="tinttd">
						<select id="flow_flowstatus" style="width:155px;">
							<option value="0">可用</option>
							<option value="1">禁用</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="deeptd">所属模块</td>
					<td class="tinttd">
						<select id="flow_moduleid" style="width:155px;">
						</select>
					</td>
					<td class="deeptd">所属应用</td>
					<td class="tinttd">
						<select id="flow_applicationid" style="width:155px;">
						</select>
					</td>
				</tr>
				<tr>
					<td class="deeptd">流程参与人</td>
					<td class="tinttd" colspan="3">
						<input type="text" id="flow_flowactor">
					</td>
				</tr>
				<tr>
					<td class="deeptd">流程访问范围</td>
					<td class="tinttd" colspan="3">
						<textarea id="flow_flowrangename" rows="3" style="width:90%" readonly=true></textarea>
						<input type="hidden" id="flow_flowrange" />
						<input type=button value="选择" class="formbutton"  onclick="window.showModalDialog('<%=request.getContextPath()%>/address/tree.jsp?utype=3&sflag=0&count=0&ptype=0&fields=flow_flowrangename,flow_flowrange',window,'status:no;dialogWidth:300px;dialogHeight:380px;scroll:no;help:no;')" >
					</td>
				</tr>
				<tr>
					<td class="deeptd">流程描述</td>
					<td class="tinttd" colspan="3">
						<textarea id="flow_description" rows="3" style="width:90%"></textarea>
					</td>
				</tr>
			</table>
			<br/>
			<input type=button value="保存" class="formbutton defaultbtn" onclick="SaveFlowAtt();">
			&nbsp;&nbsp;
			<input type=button value="取消" class="formbutton" onclick="$('#flowattdiv').CloseDiv();">
		</DIV>
	</DIV>
	<DIV id="nodeattdiv" class="poptab" style="display:none;width:640px;height:320px;text-align:center;">
		<SPAN class="tabtitle">
			<H1>
				<A title="" href="#">编辑节点属性</A>
			</H1>
			<UL class="menu">
				<LI class="tabbt">
					<A href="javascript:$('#nodeattdiv').CloseDiv();" hidefocus style="color:red;font-weight:bold;">关闭窗口</A>
				</LI>
				<LI id="nodeatt_menu1" class="tabbt" onclick="$(this).attr('class','tabbt-on');$('#nodeatt_menu2').attr('class','tabbt');$('#nodeatt_noddiv').hide();$('#nodeatt_appdiv').show();">
					<A href="#" hidefocus>应用控制</a>
				</LI>
				<LI id="nodeatt_menu2" class="tabbt-on" onclick="$(this).attr('class','tabbt-on');$('#nodeatt_menu1').attr('class','tabbt');$('#nodeatt_appdiv').hide();$('#nodeatt_noddiv').show();">
					<A href="#" hidefocus>节点属性</a>
				</LI>
			</UL>
		</SPAN>
		<DIV id="nodeatt_appdiv" style="DISPLAY: none" class="tabpad">
			asdfasd3333333333333333333333
		</DIV>
		<DIV id="nodeatt_noddiv" style="DISPLAY: block" class="tabpad">
			<input type="hidden" id="node_activid" />
			<input type="hidden" id="node_positionx" />
			<input type="hidden" id="node_positiony" />
			<table class="table">
				<tr>
					<td class="deeptd" style="width:60px;">节点名称</td>
					<td class="tinttd">
						<input type="text" id="node_activname">
					</td>
					<td class="deeptd">开始节点</td>
					<td class="tinttd">
						<select id="node_startflag" style="width:155px;">
							<option value="1">是</option>
							<option value="0">否</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="deeptd">发散方式</td>
					<td class="tinttd">
						<select id="node_splitmode" style="width:155px;">
							<option value="AND">并行</option>
							<option value="OR">选择</option>
							<option value="XOR">独占</option>
						</select>
					</td>
					<td class="deeptd">聚合方式</td>
					<td class="tinttd">
						<select id="node_joinmode" style="width:155px;">
							<option value="XOR">简单</option>
							<option value="AND">同步</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="deeptd">结束后可读</td>
					<td class="tinttd">
						<select id="node_readflag" style="width:155px;">
							<option value="1">是</option>
							<option value="0">否</option>
						</select>
					</td>
					<td class="deeptd">节点序号</td>
					<td class="tinttd">
						<input type="text" id="node_activorder">
					</td>
				</tr>
				<tr>
					<td class="deeptd">处理人模式</td>
					<td class="tinttd" colspan="3">
						<select id="node_performermode" style="width:60px;">
							<option value="single">单人</option>
							<option value="multi">多人</option>
						</select>
						多处理人方式
						<select id="node_performorder" style="width:60px;">
							<option value="serial">顺序</option>
							<option value="parallel">并序</option>
						</select>
						处理人选择
						<select id="node_performerchoiceflag" style="width:60px;">
							<option value="0">是</option>
							<option value="1">否</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="deeptd">默认处理人</td>
					<td class="tinttd">
						<input type="text" id="node_performername" readonly=true><input type=button value="选择" class="formbutton"  src="<%=request.getContextPath()%>/resources/images/actn133.gif" onclick="window.showModalDialog('<%=request.getContextPath()%>/address/tree.jsp?utype=3&sflag=0&count=0&ptype=0&fields=node_performername,node_performer',window,'status:no;dialogWidth:300px;dialogHeight:380px;scroll:no;help:no;')">
						<input type="hidden" id="node_performer">
					</td>
					<td class="deeptd">处理时限</td>
					<td class="tinttd">
						<input type="text" id="node_deadline">小时
					</td>
				</tr>
				<tr>
					<td class="deeptd">流程参与人</td>
					<td class="tinttd" colspan="3">
						<select style="width:100%">
						</select>
					</td>
				</tr>
				<tr>
					<td class="deeptd">处理人范围</td>
					<td class="tinttd" colspan="3">
						<textarea id="node_performerpurviewname" rows="3" style="width:90%" readonly=true></textarea>
						<input type="hidden" id="node_performerpurview" />
						<input type=button value="选择" class="formbutton"  onclick="window.showModalDialog('<%=request.getContextPath()%>/address/tree.jsp?utype=3&sflag=0&count=0&ptype=0&fields=node_performerpurviewname,node_performerpurview',window,'status:no;dialogWidth:300px;dialogHeight:380px;scroll:no;help:no;')" >
					</td>
				</tr>
				<tr>
					<td class="deeptd">流向描述</td>
					<td class="tinttd" colspan="3">
						<textarea id="node_description" rows="3" style="width:90%"></textarea>
					</td>
				</tr>
			</table>
			<br/>
			<input type=button value="保存" class="formbutton defaultbtn" onclick="SaveFlowActiv($('#node_activid').val());">
			&nbsp;&nbsp;
			<input type=button value="取消" class="formbutton" onclick="$('#nodeattdiv').CloseDiv();">
		</DIV>
	</DIV>
	<DIV id="tranceattdiv" class="poptab" style="display:none;width:320px;height:320px;text-align:center;">
		<SPAN class="tabtitle">
			<H1>
				<A title="" href="#">编辑流向属性</A>
			</H1>
			<UL class="menu">
				<LI class="tabbt">
					<A href="javascript:$('#tranceattdiv').CloseDiv();" hidefocus style="color:red;font-weight:bold;">关闭窗口</A>
				</LI>
				<LI class="tabbt-on">
					<A href="#" hidefocus>流向属性</A>
				</LI>
			</UL>
		</SPAN>
		<DIV id="tranceatt_trancediv" style="DISPLAY: block" class="tabpad">
			<input type="hidden" id="transTransId" />
			<table class="table">
				<tr>
					<td class="deeptd" style="width:60px;">流向名称</td>
					<td class="tinttd">
						<input type="text" id="transName">
					</td>
				</tr>
				<tr>
					<td class="deeptd">选择方式</td>
					<td class="tinttd">
						<select id="transFlag">
							<option value="0">不选中</option>
							<option value="1">默认选中</option>
							<option value="2">固定选中</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="deeptd">操作类型</td>
					<td class="tinttd">
						<select id="transType">
							<option value="half">虚操作</option>
							<option value="open">实操作</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="deeptd">流向描述</td>
					<td class="tinttd">
						<textarea id="transDescription" rows="5"></textarea>
					</td>
				</tr>
			</table>
			<br/>
			<input type=button value="保存" class="formbutton defaultbtn" onclick="SaveFlowTrans($('#transTransId').val());">
			&nbsp;&nbsp;
			<input type=button value="取消" class="formbutton" onclick="$('#tranceattdiv').CloseDiv();">
		</DIV>
	</DIV>
</BODY>
</HTML>
