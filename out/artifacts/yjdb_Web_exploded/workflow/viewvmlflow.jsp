<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="com.kizsoft.commons.commons.orm.MyDBUtils"%>
<%@page import="com.kizsoft.oa.wzbwsq.util.GsonHelp"%>
<%@page language="java" contentType="text/html;charset=UTF-8" %>

<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleManager" %>
<%@page import="com.kizsoft.commons.mxworkflow.bean.FlowAttribute"%>
<%@page import="com.kizsoft.commons.mxworkflow.manager.FlowManager"%>

<%@page import="com.kizsoft.commons.module.beans.ModuleApplication"%>
<%@page import="com.kizsoft.commons.module.beans.ModuleApplicationManager"%>

<%@page import="java.util.ArrayList"%>

<%@taglib prefix="html" uri="/WEB-INF/struts-html.tld" %>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<%@taglib prefix="bean" uri="/WEB-INF/struts-bean.tld" %>

<%--

  ~ @author Specter
  --%>

<%if (session.getAttribute("userInfo") == null) {
	response.sendRedirect(request.getContextPath() + "/login.jsp");
  }
	User userInfo = (User) session.getAttribute("userInfo");
	String userID = userInfo.getUserId();
	Group groupInfo = userInfo.getGroup();
	String groupID = groupInfo.getGroupId();
	String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
	String flowId = request.getParameter("flowid");
	String activid = request.getParameter("activid");
	
	FlowManager manager=new FlowManager();
	FlowAttribute flow=manager.getFlow(flowId);
	//System.out.println(GsonHelp.toJson(flow));
	if(flow==null){
		flow=new FlowAttribute();
		flow.setFlowType("normal");
		flow.setFlowStatus("0");
	}
	String xml=manager.getFlowInfoXml(flowId);
	//System.out.println(GsonHelp.toJson(xml));
	ModuleManager moduleManager = new ModuleManager();
	ArrayList arrList = (ArrayList) moduleManager.getModuleListWithFlow(userID);
	//System.out.println(GsonHelp.toJson(arrList));
	String moduleID= "";
	if(arrList!=null&&arrList.size()>0){
		moduleID=((String[])arrList.get(0))[0];
	}
	moduleID=flow.getModuleId()==null||"".equals(flow.getModuleId())?moduleID:flow.getModuleId();
	
	ModuleApplicationManager appManager=new ModuleApplicationManager();
	
	ArrayList appList=(ArrayList)appManager.getApplicationList(moduleID,userID);
	
%>
<html>
<head>
	<title>流程管理</title>
	<link rel="stylesheet" type="text/css" href="<%=contextPath%>/workflowManagerM/ext/css/ext-all.css" />
	<STYLE>

	.table {
		table-layout:automatic;
		border:0;
		padding: 2px 6px;
		border-collapse:collapse;
		width:100%;
		/*height:100%;*/
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
	
	
	<script type="text/javascript" src="<%=contextPath%>/workflowManagerM/ext/js/ext-base.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/workflowManagerM/ext/js/ext-all.js"></script>
	
	<!-- 如果不在同一目录 中，则设置库的基准 -->
	<script type="text/javascript">
		mxBasePath = '<%=contextPath%>/workflowManagerM/mxgraph-master/3.7.4/src';
		window.onbeforeunload = function() { 
			return mxResources.get('changesLost'); 
		};
	</script>

	<!-- 加载和初始化库 -->
	<script type="text/javascript" charset="UTF-8" src="<%=contextPath %>/resources/js/jquery/jquery-1.11.0.min.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/workflowManagerM/mxgraph-master/3.7.4/src/js/mxClient.js"></script>
	<script language="javascript" type="text/javascript" charset="utf-8" src="<%=request.getContextPath()%>/resources/js/layer/layerFunction.js"></script>

	<!-- Example code -->
	<script type="text/javascript">

		//程序从这里开始。创建一个示例图
		// DOM节点与指定的ID。这个函数被调用
		//从文档的onLoad事件处理程序(见下文)。
		var editor;
		// 程序在此启动
		function main(configXml)
		{			
			//检查浏览器兼容性
			if (!mxClient.isBrowserSupported())
			{
				// 如果不支持浏览器，就显示一条错误消息。
				mxUtils.error('Browser is not supported!', 200, false);
			}
			else
			{
				
				
				mxObjectCodec.allowEval = true;
				var config = mxUtils.load(configXml).getDocumentElement();
				editor = new mxEditor(config);
				mxObjectCodec.allowEval = false;
				// 在图中启用新的连接
				editor.graph.setConnectable(true);
				
				editor.graph.setCellsResizable(false);
				editor.graph.setAllowDanglingEdges(false);
				editor.graph.setMultigraph(false);
				
				var apply = function(permission)
				{
					editor.graph.clearSelection();
					permission.apply(graph);
					editor.graph.setEnabled(false);
					editor.graph.setTooltips(false);
			
					editor.graph.refresh();
					currentPermission = permission;
				};
				
				apply(new Permission(false, true, false, true, false));
				//editor.graph.setCellsMovable(true);
				//editor.graph.setEdgeLabelsMovable(false);
				//editor.graph.setVertexLabelsMovable(false);

				var oldDisconnectable = editor.graph.isCellDisconnectable;
				editor.graph.isCellDisconnectable = function(cell, terminal, source)
				{
					return oldDisconnectable.apply(this, arguments) &&
						currentPermission.editEdges;
				};
				
				var oldTerminalPointMovable = editor.graph.isTerminalPointMovable;
				editor.graph.isTerminalPointMovable = function(cell)
				{
					return oldTerminalPointMovable.apply(this, arguments) &&
						currentPermission.editEdges;
				};
				
				/*var oldBendable = editor.graph.isCellBendable;
				editor.graph.isCellBendable = function(cell)
				{
					return oldBendable.apply(this, arguments) &&
						currentPermission.editEdges;
				};*/
				
				var oldLabelMovable = editor.graph.isLabelMovable;
				editor.graph.isLabelMovable = function(cell)
				{
					return oldLabelMovable.apply(this, arguments) &&
						currentPermission.editEdges;
				};
				
				var oldMovable = editor.graph.isCellMovable;
				editor.graph.isCellMovable = function(cell)
				{
					return oldMovable.apply(this, arguments) &&
						currentPermission.editVertices;
				};
				
				var oldResizable = editor.graph.isCellResizable;
				editor.graph.isCellResizable = function(cell)
				{
					return oldResizable.apply(this, arguments) &&
						currentPermission.editVertices;
				};
								
				var oldEditable = editor.graph.isCellEditable;
				editor.graph.isCellEditable = function(cell)
				{
					return oldEditable.apply(this, arguments) &&
						(this.getModel().isVertex(cell) &&
						currentPermission.editVertices) ||
						(this.getModel().isEdge(cell) &&
						currentPermission.editEdges);
				};
				
				var oldDeletable = editor.graph.isCellDeletable;
				editor.graph.isCellDeletable = function(cell)
				{
					
						
					return true;
				};
				
				var oldCloneable = editor.graph.isCellCloneable;
				editor.graph.isCellCloneable = function(cell)
				{
					return oldCloneable.apply(this, arguments) &&
						currentPermission.cloneCells;
				};
				
				parse(editor.graph);
				
				var model = new mxGraphModel();  
				
				var parent = editor.graph.getDefaultParent();  
				
				// Adds cells to the model in a single step  
				
				editor.graph.dblClick = function (evt, cell) {
					var model = editor.graph.getModel();
					if (model.isVertex(cell)) {
						return false;
					}
				};
				
			}
		}
		
		//数据加载解析
		function parse(graph){			
			var xml = '<%=xml%>';
			var xmlDocument = mxUtils.parseXml(xml);
				if (xmlDocument.documentElement != null && xmlDocument.documentElement.nodeName == 'mxGraphModel')
				{
					
					var decoder = new mxCodec(xmlDocument);
					
					var node = xmlDocument.documentElement;
					graph.border = 20;
					decoder.decode(node, graph.getModel());
				}
				<%
				MyDBUtils db = new MyDBUtils();
				List<Map<String, Object>> parentsMap = db.queryForMapToUC("select position_x,position_y from flow_activities where flow_id = ? and startflag = 1", new Object[]{flowId});
				for(int i = 0; i < parentsMap.size(); i++) {
					Map<String, Object> map = parentsMap.get(i);
					String x = map.get("position_x").toString();
					String y = map.get("position_y").toString();
				%>
				
					$("g rect[x='<%=x%>'][y='<%=y%>']:eq(0)").attr('stroke','#00FF00');
					$("g rect[x='<%=x%>'][y='<%=y%>']:eq(1)").attr('stroke','#00FF00');
				<%
				}
				if(activid != null && activid != "") {
					Map<String, Object> map = db.queryForUniqueMapToUC("select position_x,position_y from flow_activities where activ_id = ? and flow_id = ?", new Object[]{activid, flowId});
					String x = map.get("position_x").toString();
					String y = map.get("position_y").toString();
				%>
				$("g rect[x='<%=x%>'][y='<%=y%>']:eq(0)").attr('stroke','#FF6600');
				$("g rect[x='<%=x%>'][y='<%=y%>']:eq(1)").attr('stroke','#FF6600');
				$("text[x='<%=Integer.valueOf(x) + 40%>'][y='<%=Integer.valueOf(y) + 23%>']").parent().attr('fill','red');
				<% } %>
				
				
		}
			
		function Permission(locked, createEdges, editEdges, editVertices, cloneCells)
			{

				this.locked = (locked != null) ? locked : false;
				this.createEdges = (createEdges != null) ? createEdges : true;
				this.editEdges = (editEdges != null) ? editEdges : true;;
				this.editVertices = (editVertices != null) ? editVertices : true;;
				this.cloneCells = (cloneCells != null) ? cloneCells : true;;
			};
			
			Permission.prototype.apply = function(graph)
			{
				
				editor.graph.setConnectable(this.createEdges);
				editor.graph.setCellsLocked(this.locked);
			};
		
		
	</script>
	
	
	<script>
		var dactivIDs="";
		var dtranceIDs="";
		function removeNode(){
			if(flowAttr.flow_id!=""){
				var cell=editor.graph.getSelectionCell();
				if(!editor.graph.getModel().isEdge(cell)){
					dactivIDs+=","+cell.id;
				}else{
					dtranceIDs+=","+cell.id;
				}
				
			}
			var cells = new Array();  
			cells = editor.graph.getSelectionCells();  
			mxClipboard.removeCells(editor.graph,cells);  
		}
	</script>
	<script>
			var winCell;
			var winLine;
			
		
			var flowAttr={
				flow_id:"<%=flow.getFlowId()==null?"":flow.getFlowId()%>",
				flow_flowname:"<%=flow.getFlowName()==null?"":flow.getFlowName()%>",
				flow_flowtype:"<%=flow.getFlowType()%>",
				flow_administrator:"<%=flow.getAdministrator()==null?"":flow.getAdministrator()%>",
				flow_creator:"<%=flow.getCreator()==null?"":flow.getCreator()%>",
				flow_floworder:"<%=flow.getFlowOrder()==null?"":flow.getFlowOrder()%>",
				flow_moduleid:"<%=flow.getModuleId()%>",
				flow_flowstatus:"<%=flow.getFlowStatus()%>",
				flow_applicationid:"<%=flow.getApplicationId()%>",
				flow_flowactor:"<%=flow.getFlowActor()==null?"":flow.getFlowActor()%>",
				flow_flowrangename:"<%=flow.getFlowRangeName()==null?"":flow.getFlowRangeName()%>",
				flow_flowrange:"<%=flow.getFlowRange()==null?"":flow.getFlowRange()%>",
				flow_description:"<%=flow.getDescription()==null?"":flow.getDescription()%>"
			};
			
			var flowset;
	</script>


<link rel="stylesheet" href="<%=contextPath%>/resources/template/cn/layui/css/layui.css" +math.random()="" media="all">
<style type="text/css">
	.layui-elem-quote.quoteBox {
		padding: 10px;
	}
	.layui-form-label {
		width: 124px;
		padding: 9px 9px;
	}
	.layui-form-item {
		margin-bottom: 3px;
	}
	.content2 .layui-form-label {
		width: 90px;
		padding: 8px;
	}
	.content2 .layui-input-inline {
		width: 17%;
	}
	#winLine .layui-input-inline {
	}
</style>	
</head>

<!-- Page passes the container for the graph to the program -->
<body onload="main('config/uiconfig.xml');" style="margin:10px">
	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td id="toolbox" colspan="2" height="50px" class="layui-elem-quote quoteBox">
		<font color="red"><%=flow.getFlowName()==null?"":flow.getFlowName()%></font>流程示意图
		</td>
		<% if(activid != null && activid != "") { %>
		<span style="position:absolute;right: 46px; top: 20px; width: 222px;">
			流程开始<div style="position: absolute; right:118px; top: 1px;border-style:solid; border-width:1px; border-color:#00FF00; width:39px; height:20px"></div>
			<span style="margin-left:60px">当前流程</span><div style="position: absolute; right:0px; top: 1px;border-style:solid; border-width:1px; border-color:#FF6600; width:39px; height:20px"></div>
		<span>
		<% } %>
	</tr>
	<tr>
		<td width="100%" style="">
			<div id="graph" style="overflow:auto;width:100%;height:100%;background:url('images/grid.gif');cursor:default;"></div>
		</td>
	</tr>
	</table>

	</div>
<script type="text/javascript">
</script>
</body>
</html>
