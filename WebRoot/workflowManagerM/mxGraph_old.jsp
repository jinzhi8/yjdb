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
	String flowId=request.getParameter("flowid");
	//System.out.println(flowId);
	FlowManager manager=new FlowManager();
	FlowAttribute flow=manager.getFlow(flowId);
	if(flow==null){
		flow=new FlowAttribute();
		flow.setFlowType("normal");
		flow.setFlowStatus("0");
	}
	String xml=manager.getFlowInfoXml(flowId);
	
	ModuleManager moduleManager = new ModuleManager();
	ArrayList arrList = (ArrayList) moduleManager.getModuleListWithFlow(userID);
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
	<script type="text/javascript" src="<%=contextPath%>/workflowManagerM/js/jquery.js"></script>
	<script language="javascript" type="text/javascript" charset="utf-8" src="<%=request.getContextPath()%>/resources/js/layer/layerFunction.js"></script>
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
	<script type="text/javascript" src="<%=contextPath%>/workflowManagerM/mxgraph-master/3.7.4/src/js/mxClient.js"></script>

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
					editor.graph.setEnabled(true);
					editor.graph.setTooltips(true);
			
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
			function cellAttr(cell)
			{
			var a=editor.graph.getSelectionCell();
			var label=a.getAttribute('label');

			
			
			if(!editor.graph.getModel().isEdge(a)){
				var node=a;
				$("#node_activname").val(node.getAttribute('node_activname'));
				$("#node_activid").val(node.getAttribute('node_activid'));
				$("#node_positionx").val(node.getAttribute('node_positionx'));
				$("#node_positiony").val(node.getAttribute('node_positiony'));
				$("#node_startflag").val(node.getAttribute('node_startflag'));
				$("#node_splitmode").val(node.getAttribute('node_splitmode'));
				$("#node_joinmode").val(node.getAttribute('node_joinmode'));
				$("#node_readflag").val(node.getAttribute('node_readflag'));
				$("#node_activorder").val(node.getAttribute('node_activorder'));
				$("#node_performermode").val(node.getAttribute('node_performermode'));
				$("#node_performermode").change();
				$("#node_performorder").val(node.getAttribute('node_performorder'));
				$("#node_performerchoiceflag").val(node.getAttribute('node_performerchoiceflag'));
				$("#node_performername").val(node.getAttribute('node_performername'));
				$("#node_performer").val(node.getAttribute('node_performer'));
				$("#node_deadline").val(node.getAttribute('node_deadline'));
				$("#node_performerpurviewname").val(node.getAttribute('node_performerpurviewname'));
				$("#node_performerpurview").val(node.getAttribute('node_performerpurview'));
				$("#node_description").val(node.getAttribute('node_description'));
				var node_appjson=node.getAttribute('node_appjson');
				showApp(node_appjson);
				 if(!winCell)
					{
						winCell = new Ext.Window(
						{
							el:'winCell-win',
							layout:'fit',
							width:600,
							height:430,
							closeAction:'hide',
							plain: true,
							resizable:false,
							items: new Ext.TabPanel(
							{
								el: 'winCell-tabs',
								autoTabs:true,
								activeTab:0,
								deferredRender:false,
								border:false
							}),

							buttons: [
							{
								text:'保存',
								handler: function()
								{
									node=editor.graph.getSelectionCell();
									//alert($("#node_activname").val());
									var node_activname=$("#node_activname").val()
									if(node_activname==""){
										alert("节点名称不能为空！");
										return;
									}
									node.setAttribute('node_activname',node_activname);
									//alert(node.getAttribute('node_activname'));
									node.setAttribute("label",$("#node_activname").val());
									//alert(node.getAttribute("label"));
									$("#node_activname").val("");
									
									node.setAttribute('node_activid',$("#node_activid").val());
									$("#node_activid").val("");
									node.setAttribute('node_positionx',$("#node_positionx").val());
									$("#node_positionx").val("");
									node.setAttribute('node_positiony',$("#node_positiony").val());
									$("#node_positiony").val("");
									node.setAttribute('node_startflag',$("#node_startflag").val());
									$("#node_startflag").val("");
									node.setAttribute('node_splitmode',$("#node_splitmode").val());
									$("#node_splitmode").val("");
									node.setAttribute('node_joinmode',$("#node_joinmode").val());
									$("#node_joinmode").val("");
									node.setAttribute('node_readflag',$("#node_readflag").val());
									$("#node_readflag").val("");
									node.setAttribute('node_activorder',$("#node_activorder").val());
									$("#node_activorder").val("");
									node.setAttribute('node_performermode',$("#node_performermode").val());
									$("#node_performermode").val("");
									node.setAttribute('node_performorder',$("#node_performorder").val());
									$("#node_performorder").val("");
									node.setAttribute('node_performerchoiceflag',$("#node_performerchoiceflag").val());
									$("#node_performerchoiceflag").val("");
									node.setAttribute('node_performername',$("#node_performername").val());
									$("#node_performername").val("");
									node.setAttribute('node_performer',$("#node_performer").val());
									$("#node_performer").val("");
									node.setAttribute('node_deadline',$("#node_deadline").val());
									$("#node_deadline").val("");
									node.setAttribute('node_performerpurviewname',$("#node_performerpurviewname").val());
									$("#node_performerpurviewname").val("");
									node.setAttribute('node_performerpurview',$("#node_performerpurview").val());
									$("#node_performerpurview").val("");
									node.setAttribute('node_description',$("#node_description").val());
									$("#node_description").val("");
									node.setAttribute('node_appjson',getAppjson());
									editor.graph.refresh(node);
									winCell.hide();
								}
							},
							{
								text: '取消',
								handler: function()
								{
									winCell.hide();
								}
							}]
						});
						// Fits the SVG container into the window
						winCell.on('resize', function()
						{
						   editor.graph.sizeDidChange();
						});
					}
					winCell.show();
				}else{
					var line=a;
					$("#transName").val(line.getAttribute('transName'));
					$("#transTransId").val(line.getAttribute('transTransId'));
					$("#transFlag").val(line.getAttribute('transFlag'));
					$("#transType").val(line.getAttribute('transType'));
					$("#transDescription").val(line.getAttribute('transDescription'));
					if(!winLine)
					{
						winLine = new Ext.Window(
						{
							el:'winLine',
							layout:'fit',
							width:436,
							height:230,
							closeAction:'hide',
							plain: true,
							resizable:false,
							items: new Ext.TabPanel(
							{
								el: 'winLine-tabs',
								autoTabs:true,
								activeTab:0,
								deferredRender:false,
								border:false
							}),

							buttons: [
							{
								text:'保存',
								handler: function()
								{	
									line=editor.graph.getSelectionCell();
									
									var transName=$("#transName").val();
									if(transName==""){
										alert("流向名称不能为空！");
										return;
									}
									line.setAttribute('transName',transName);
									//alert(line.getAttribute('transName'));
									line.setAttribute("label",$("#transName").val());
									//alert(line.getAttribute("label"));
									$("#transName").val("");
									line.setAttribute('transTransId',$("#transTransId").val());
									$("#transTransId").val("");
									line.setAttribute('transFlag',$("#transFlag").val());
									$("#transFlag").val("");
									line.setAttribute('transType',$("#transType").val());
									$("#transType").val("");
									line.setAttribute('transDescription',$("#transDescription").val());
									$("#transDescription").val("");
									editor.graph.refresh(line);
									winLine.hide();
								}
							},
							{
								text: '取消',
								handler: function()
								{
									winLine.hide();
								}
							}]
						});
						// Fits the SVG container into the window
						winLine.on('resize', function()
						{
						   editor.graph.sizeDidChange();
						});
					}
					winLine.show();
				}
			
			}
		
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
			function flowSet(editor)
			{
				$("#flow_flowid").val(flowAttr.flow_id);
				$("#flow_flowname").val(flowAttr.flow_flowname);
				$("#flow_flowtype").val(flowAttr.flow_flowtype);
				$("#flow_administrator").val(flowAttr.flow_administrator);
				$("#flow_creator").val(flowAttr.flow_creator);
				$("#flow_floworder").val(flowAttr.flow_floworder);
				$("#flow_moduleid").val(flowAttr.flow_moduleid);
				$("#flow_flowstatus").val(flowAttr.flow_flowstatus);
				$("#flow_applicationid").val(flowAttr.flow_applicationid);
				$("#flow_flowactor").val(flowAttr.flow_flowactor);
				$("#flow_flowrangename").val(flowAttr.flow_flowrangename);
				$("#flow_flowrange").val(flowAttr.flow_flowrange);
				$("#flow_description").val(flowAttr.flow_description);
				 if(!flowset)
					{
						flowset = new Ext.Window(
						{
							el:"flowset",
							//renderTo:'ss1',
							layout:'fit',
							width:600,
							height:400,
							closeAction:'hide',
							y:50,
							plain: true,
							resizable:false,
							items: new Ext.TabPanel(
							{
								el: 'flowset-tabs',
								autoTabs:true,
								activeTab:0,
								deferredRender:false,
								border:false
							}),
							buttons: [
							{
								text:'保存',
								handler: function()
								{	
									var flow_flowname=$("#flow_flowname").val();
									if(flow_flowname==""){
										alert("流程名称不能为空！");
										return;
									}
									flowAttr.flow_id=$("#flow_flowid").val();
									flowAttr.flow_flowname=flow_flowname;
									flowAttr.flow_flowtype=$("#flow_flowtype").val();
									flowAttr.flow_administrator=$("#flow_administrator").val();
									flowAttr.flow_creator=$("#flow_creator").val();
									flowAttr.flow_floworder=$("#flow_floworder").val();
									flowAttr.flow_moduleid=$("#flow_moduleid").val();
									flowAttr.flow_flowstatus=$("#flow_flowstatus").val();
									flowAttr.flow_applicationid=$("#flow_applicationid").val();
									flowAttr.flow_flowactor=$("#flow_flowactor").val();
									flowAttr.flow_flowrangename=$("#flow_flowrangename").val();
									flowAttr.flow_flowrange=$("#flow_flowrange").val();
									flowAttr.flow_description=$("#flow_description").val();
									
									$("#flow_flowid").val("");
									$("#flow_flowname").val("");
									$("#flow_flowtype").val("");
									$("#flow_administrator").val("");
									$("#flow_creator").val("");
									$("#flow_floworder").val("");
									$("#flow_moduleid").val("");
									$("#flow_flowstatus").val("");
									$("#flow_applicationid").val("");
									$("#flow_flowactor").val("");
									$("#flow_flowrangename").val("");
									$("#flow_flowrange").val("");
									$("#flow_description").val("");
									flowset.hide();
								}
							},
							{
								text: '取消',
								handler: function()
								{	
									$("#flow_flowid").val("");
									$("#flow_flowname").val("");
									$("#flow_flowtype").val("");
									$("#flow_administrator").val("");
									$("#flow_creator").val("");
									$("#flow_floworder").val("");
									$("#flow_moduleid").val("");
									$("#flow_flowstatus").val("");
									$("#flow_applicationid").val("");
									$("#flow_flowactor").val("");
									$("#flow_flowrangename").val("");
									$("#flow_flowrange").val("");
									$("#flow_description").val("");
									flowset.hide();
								}
							}]
						});

						// Fits the SVG container into the window
						flowset.on('resize', function()
						{
						   editor.graph.sizeDidChange();
						});
					}
					//flowset.render("flowset1");
					flowset.show();
			}
			
			
			
	</script>
	
	<script language="javascript" type="text/javascript"> 
		$(document).ready(function(){ 
			$('#node_performermode').change(function(){
				var mode=$(this).val();
				if(mode=='single'){
					$("#node_performorder").attr("disabled",true);
				}else{
					$("#node_performorder").attr("disabled",false);
				}
				
			});
		});
	</script> 
	
	
	<script>
		var count=1;
		function showApp(appJson){
			//alert(appJson)
		    var html="<table class='table' id=node_table>";
			if(appJson==undefined||appJson==""){
				html+=getHtml(0,'','','','','');
				$("#node_app").html(html+"</table>");
				count=1;
				return;
			}
			var apps=eval('('+appJson+')');
			count=apps.count;
			if(count==0){
				html+=getHtml(0,'','','','','');
				$("#node_app").html(html+"</table>");
				count=1;
				return;
			}
			for(var i=0;i<count;i++){
				var app=apps.root[i];
				html+=getHtml(i,app.itemId,app.itemName,app.itemStatus,app.nullable,app.dataType);
			}
			$("#node_app").html(html+"</table>");
		}
		
		function getAppjson(){
			var json="{count:"+count+",root:[";
			for(var i=0;i<count;i++){
				var itemId=$("[name=itemId_"+i+"]").val();
				var itemName=$("[name=itemName_"+i+"]").val();
				var itemStatus=$("[name=itemStatus_"+i+"]").val();
				var nullable=$("[name=nullable_"+i+"]").val();
				var dataType=$("[name=dataType_"+i+"]").val();
				if(i!=0){
					json+=",";
				}
				//json+="{itemId:&apos;"+itemId+"&apos;,itemName:&apos;"+itemName+"&apos;,itemStatus:&apos;"
				//+itemStatus+"&apos;,nullable:&apos;"+nullable+"&apos;,dataType:&apos;"+dataType+"&apos;}";
				json+="{itemId:'"+itemId+"',itemName:'"+itemName+"',itemStatus:'"
				+itemStatus+"',nullable:'"+nullable+"',dataType:'"+dataType+"'}";
			}
			json+="]}";
			return json;
		}
		
		function addApp(){
			var html="<table class='table' id=node_table>";
			if(count==0){
				html+=getHtml(0,'','','','','');
				$("#node_app").html(html+"</table>");
				count=1;
				return;
			}
			for(var i=0;i<count;i++){
				html+=getHtml(i,$("[name=itemId_"+i+"]").val(),$("[name=itemName_"+i+"]").val(),$("[name=itemStatus_"+i+"]").val(),$("[name=nullable_"+i+"]").val(),$("[name=dataType_"+i+"]").val());
			}
			html+=getHtml(count,'','','','','');
			count++;
			$("#node_app").html(html+"</table>");
		}
		
		function getHtml(index,itemId,itemName,itemStatus,nullable,dataType){
		
			var html="";
			html+="	<tr>";
			html+="		<td class='deeptd'>元素标识</td>";
			html+="		<td class='tinttd'><input type='text' name='itemId_"+index+"' value='"+itemId+"' style='width:100px'></td>";
			html+="		<td class='deeptd'>元素名称</td>";
			html+="		<td class='tinttd'><input type='text' name='itemName_"+index+"' value='"+itemName+"' style='width:100px'></td>";
			html+="		<td class='deeptd'>元素状态</td>";
			html+="		<td class='tinttd'>";
			html+="			<select name='itemStatus_"+index+"' value='"+itemStatus+"' style='width:100px;'>";
			html+="				<option value='1' "+(itemStatus=='1'?"selected":"")+">可编辑</option>";
			html+="				<option value='0' "+(itemStatus=='0'?"selected":"")+">隐藏</option>";
			html+="				<option value='2' "+(itemStatus=='2'?"selected":"")+">只读</option>";
			html+="				<option value='3' "+(itemStatus=='3'?"selected":"")+">禁用</option>";
			html+="			</select>";
			html+="		</td>";
			html+="	</tr>";
			html+="	<tr>";
			html+="		<td class='deeptd'>空值校验</td>";
			html+="		<td class='tinttd'>";
			html+="			<select name='nullable_"+index+"' value='"+nullable+"' style='width:100px;'>";
			html+="				<option value='1' "+(nullable=='1'?"selected":"")+">是</option>";
			html+="				<option value='0' "+(nullable=='0'?"selected":"")+">否</option>";
			html+="			</select>";
			html+="		</td>";
			html+="		<td class='deeptd'>值类型</td>";
			html+="		<td class='tinttd'>";
			html+="			<select name='dataType_"+index+"' value='"+dataType+"' style='width:100px;'>";
			html+="				<option value='text'  "+(dataType=='text'?"selected":"")+">文本</option>";
			html+="				<option value='number' "+(dataType=='number'?"selected":"")+">数字</option>";
			html+="			</select>";
			html+="		</td>";
			html+="		<td class='deeptd'></td><td class='tinttd'></td>";
			html+="	</tr>";
			return html;
		}
		
		
		
		
	</script>
	
	<script>
		function changeApp(moduleId){
			$.ajax({
				url:"<%=request.getContextPath()%>/workflowManagerM/application.jsp",
				data:"moduleId="+moduleId+"&timestamp="+new Date().getTime()+"",
				async:false,
				success:function(data){
					//alert(data);
					$("#flow_applicationid").html(trim(data));
				}
			});
		}
		
		function trim(str){
			if(str==''){
				return'';
			}
			return str.replace(/(^\s*)|(\s*$)/g,"");
		}
	</script>
	
	<script>
		function newFlow(editor){
			if(!confirm("请确认保存了当前流程信息！")){
				return;
			}
			var url=window.location.href;
			if(url.indexOf("?")>0){
				url=url.substring(0,url.indexOf("?"));
			}
			window.location.href=url;
		}
		function save(editor,isNew){
			if(isNew==1){
				if(!confirm("是否另存流程？")){
					return ;
				}
			}else{
				if(!confirm("是否保存流程？")){
					return;
				}
			}
			
			var encoder = new mxCodec();
			var node = encoder.encode(editor.graph.getModel());
			var xml=mxUtils.getPrettyXml(node);
			
			$.ajax({
				type:"post",
				url:"<%=request.getContextPath()%>/MXAddAction.do",
				data:"xml="+encodeURIComponent(xml)
				+"&flow_flowid="+encodeURIComponent(flowAttr.flow_id)
				+"&flow_flowname="+encodeURIComponent(flowAttr.flow_flowname)
				+"&flow_flowtype="+encodeURIComponent(flowAttr.flow_flowtype)
				+"&flow_administrator="+encodeURIComponent(flowAttr.flow_administrator)
				+"&flow_creator="+encodeURIComponent(flowAttr.flow_creator)
				+"&flow_floworder="+encodeURIComponent(flowAttr.flow_floworder)
				+"&flow_moduleid="+encodeURIComponent(flowAttr.flow_moduleid)
				+"&flow_flowstatus="+encodeURIComponent(flowAttr.flow_flowstatus)
				+"&flow_applicationid="+encodeURIComponent(flowAttr.flow_applicationid) 
				+"&flow_flowactor="+encodeURIComponent(flowAttr.flow_flowactor)
				+"&flow_flowrangename="+encodeURIComponent(flowAttr.flow_flowrangename) 
				+"&flow_flowrange="+encodeURIComponent(flowAttr.flow_flowrange)
				+"&flow_description="+encodeURIComponent(flowAttr.flow_description)
				+"&dtranceIDs="+encodeURIComponent(dtranceIDs)
				+"&dactivIDs="+encodeURIComponent(dactivIDs)
				+"&isNew="+encodeURIComponent(isNew)
				+"&timestamp="+new Date().getTime()+"",
				async:false,
				success:function(data){
					var result=trim(data);
					if(result=='success'){
						alert("保存成功！");
						
					}else if(result=='flowname'){
						alert("流程名称不能为空！");
					}else{
						alert("系统异常，请重试！");
					}
					
					//$("#flow_applicationid").html(trim(data));
				}
			});
			
		}
		
		
		
		function trim(str){ //删除左右两端的空格
			if(str==''){
				return '';
			}
	　　     return str.replace(/(^\s*)|(\s*$)/g, "");
	　　 }
		
	</script>
	
</head>

<!-- Page passes the container for the graph to the program -->
<body onload="main('config/uiconfig.xml');">
	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td id="toolbox" colspan="2" height="80px" style="padding:10px;">
		</td>
	</tr>
	<tr>
		<td width="100%" style="">
			<div id="graph" style="overflow:auto;width:100%;height:100%;background:url('images/grid.gif');cursor:default;"></div>
		</td>
	</tr>
	</table>
	
	<div id="winCell-win" class="x-hidden">
	    <div class="x-window-header">流程属性设置</div>
	    <div id="winCell-tabs">
			<div class="x-tab" title="节点属性">
				<input type="hidden" id="node_activid" />
				<input type="hidden" id="node_positionx" />
				<input type="hidden" id="node_positiony" />
				<table class="table">
					<tr>
						<td class="tinttd" colspan="4"><div align="center">节点属性</div></td>
					</tr>
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
							<select id="node_performermode" style="width:100px;">
								<option value="single">单人</option>
								<option value="multi">多人</option>
							</select>
							多处理人方式
							<select id="node_performorder" style="width:100px;" disabled>
								<option value="serial">顺序</option>
								<option value="parallel">并序</option>
							</select>
							处理人选择
							<select id="node_performerchoiceflag" style="width:100px;">
								<option value="0">是</option>
								<option value="1">否</option>
							</select>
						</td>
					</tr>
					<tr>
						<td class="deeptd">默认处理人</td>
						<td class="tinttd">
							<input type="text" id="node_performername"  name="node_performername" readonly=true><input type=button value="选择" class="formbutton"  src="<%=request.getContextPath()%>/resources/images/actn133.gif" onclick="openSelWin('<%=request.getContextPath()%>/address/tree.jsp?utype=3&sflag=0&count=0&ptype=0&fields=node_performername,node_performer');" />
							<input type="hidden" id="node_performer" name="node_performer"  />
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
							<textarea id="node_performerpurviewname" name="node_performerpurviewname" rows="2" style="width:90%" readonly=true></textarea>
							<input type="hidden" id="node_performerpurview" name="node_performerpurview" />
							<input type=button value="选择" class="formbutton"  onclick="openSelWin('<%=request.getContextPath()%>/address/tree.jsp?utype=3&sflag=0&count=0&ptype=0&fields=node_performerpurviewname,node_performerpurview');" />
						</td>
					</tr>
					<tr>
						<td class="deeptd">流向描述</td>
						<td class="tinttd" colspan="3">
							<textarea id="node_description" rows="2" style="width:90%"></textarea>
						</td>
					</tr>
				</table>
			</div>
			<!-- Auto create tab 2 -->
			<div class="x-tab" title="应用控制">
			<div style="width:100%; height:325; overflow-y:scroll; overflow-x:hidden;">
				<table class="table">
					<tr>
						<td colspan="6" class="tinttd" style="border-bottom:0px"><div align="center">应用控制</div></td>
					</tr>
				</table>
				<div id="node_app">
				
				
				</div>
				
				<input type="button" value="增加" onclick="addApp();">
				
				 <!--<table class="table" id="node_app">
					<tr>
						<td class="deeptd">元素标识</td>
						<td class="tinttd"><input type="text" name="itemId" value="" style="width:100px"></td>
						<td class="deeptd">元素名称</td>
						<td class="tinttd"><input type="text" name="itemName" value="" style="width:100px"></td>
						<td class="deeptd">元素状态</td>
						<td class="tinttd">
							<select id="itemStatus" style="width:100px;">
								<option value="1">可编辑</option>
								<option value="0">隐藏</option>
								<option value="2">只读</option>
								<option value="3">禁用</option>
							</select>
						</td>
					</tr>
					<tr>
						<td class="deeptd">空值校验</td>
						<td class="tinttd">
							<select id="nullable" style="width:100px;">
								<option value="1">是</option>
								<option value="0">否</option>
							</select>
						</td>
						<td class="deeptd">值类型</td>
						<td class="tinttd">
							<select id="dataType" style="width:100px;">
								<option value="text">文本</option>
								<option value="number">数字</option>
							</select>
						</td>
						<td class="deeptd"></td><td class="tinttd"></td>
					</tr>
					
				</table>-->
				</div>
			</div>
		</div>
	</div>
	<div id="flowset" class="x-hidden">
	    <div class="x-window-header">流程属性设置</div>
	    <div id="flowset-tabs">
				 <input type="hidden" id="flow_flowid" />
				<table class="table">
					<tr rowspan="2">
						<td class="tinttd" align="center" colspan="4"><div align="center">流程属性</div></td>
					</tr>
					<tr>
						<td class="deeptd" style="width:60px;">流程名称</td>
						<td class="tinttd">
							<input type="text" id="flow_flowname" value="">
						</td>
						<td class="deeptd">流程类型</td>
						<td class="tinttd">
							<select id="flow_flowtype" style="width:155px;" value="">
								<option value="normal">普通流程</option>
								<option value="soft">柔性流程</option>
								<option value="subflow">子流程</option>
							</select>
						</td>
					</tr>
					<tr>
						<td class="deeptd">流程管理员</td>
						<td class="tinttd">
							<input type="text" id="flow_administrator" value="">
						</td>
						<td class="deeptd">流程创建者</td>
						<td class="tinttd">
							<input type="text" id="flow_creator" value="">
						</td>
					</tr>
					<tr>
						<td class="deeptd">流程排序</td>
						<td class="tinttd">
							<input type="text" id="flow_floworder" value="">
						</td>
						<td class="deeptd">流程状态</td>
						<td class="tinttd">
							<select id="flow_flowstatus" style="width:155px;" value="">
								<option value="0">可用</option>
								<option value="1">禁用</option>
							</select>
						</td>
					</tr>
					<tr>
						<td class="deeptd">所属模块</td>
						<td class="tinttd">
							<select id="flow_moduleid" style="width:155px;" value=""   onchange="changeApp(this.value);">
								<%for(int i=0;i<arrList.size();i++){
									String[] moduleInfo=(String[])arrList.get(i);
								%>
									<option value="<%=moduleInfo[0]%>"><%=moduleInfo[1]%></option>
								<%
								}%>
							</select>
						</td>
						<td class="deeptd">所属应用</td>
						<td class="tinttd">
							<select id="flow_applicationid" style="width:155px;" value="">
								<%
								for(int i=0;i<appList.size();i++){
									ModuleApplication app=(ModuleApplication)appList.get(i);
								%>
									<option value="<%=app.getApplicationId()%>"><%=app.getApplicationName()%></option>
								<%	
								}
								%>
							
							
							</select>
						</td>
					</tr>
					<tr>
						<td class="deeptd">流程参与人</td>
						<td class="tinttd" colspan="3">
							<input type="text" id="flow_flowactor"  value="">
						</td>
					</tr>
					<tr>
						<td class="deeptd" width="80px">流程访问范围</td>
						<td class="tinttd" colspan="3">
							<textarea id="flow_flowrangename" name="flow_flowrangename" rows="3" style="width:90%" readonly=true></textarea>
							<input type="hidden" id="flow_flowrange" name="flow_flowrange" value=""/>
							<input type=button value="选择" class="formbutton"  onclick="openSelWin('<%=request.getContextPath()%>/address/tree.jsp?utype=3&sflag=0&count=0&ptype=0&fields=flow_flowrangename,flow_flowrange');" />
						</td>
					</tr>
					<tr>
						<td class="deeptd">流程描述</td>
						<td class="tinttd" colspan="3">
							<textarea id="flow_description" rows="3" style="width:90%" value=""></textarea>
						</td>
					</tr>
				</table>
		</div>
	</div>
	
	
	<div id="winLine" class="x-hidden">
	    <div class="x-window-header">流向属性设置</div>
	    <div id="winLine-tabs">
				<input type="hidden" id="transTransId" />
				<table class="table">
					<tr>
						<td class="tinttd" colspan="4"><div align="center">流向属性</div></td>
					</tr>
					<tr>
						<td class="deeptd" style="width:60px;">流向名称</td>
						<td class="tinttd" colspan="3">
							<input type="text" style="width:300px;" id="transName">
						</td>
					</tr>
					<tr>
						<td class="deeptd">选择方式</td>
						<td class="tinttd">
							<select id="transFlag" style="width:100px;">
								<option value="0">不选中</option>
								<option value="1">默认选中</option>
								<option value="2">固定选中</option>
							</select>
						</td>
						<td class="deeptd">操作类型</td>
						<td class="tinttd">
							<select id="transType" style="width:100px;">
								<option value="half">虚操作</option>
								<option value="open">实操作</option>
							</select>
						</td>
					</tr>
					<tr>
						<td class="deeptd">流向描述</td>
						<td class="tinttd" colspan="3">
							<textarea id="transDescription" style="width:300px;" rows="3"></textarea>
						</td>
					</tr>
				</table>
		</div>
	</div>
	
	
	</div>
</body>
</html>
