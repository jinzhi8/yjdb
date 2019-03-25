﻿<%@page import="com.kizsoft.yjdb.utils.GsonHelp"%>
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
	
	<script>
		var count=1;
		function showApp(appJson){
			//alert(appJson)
		    var html="";
			if(appJson==undefined||appJson==""){
				html+=getHtml(0,'','','','','');
				$(".content2").html(html);
				count=1;
				return;
			}
			var apps=eval('('+appJson+')');
			count=apps.count;
			if(count==0){
				html+=getHtml(0,'','','','','');
				$(".content2").html(html);
				count=1;
				return;
			}
			for(var i=0;i<count;i++){
				var app=apps.root[i];
				html+=getHtml(i,app.itemId,app.itemName,app.itemStatus,app.nullable,app.dataType);
			}
			$(".content2").html(html);
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
			var html="";
			if(count==0){
				html+=getHtml(0,'','','','','');
				$(".content2").html(html);
				count=1;
				return;
			}
			for(var i=0;i<count;i++){
				html+=getHtml(i,$("[name=itemId_"+i+"]").val(),$("[name=itemName_"+i+"]").val(),$("[name=itemStatus_"+i+"]").val(),$("[name=nullable_"+i+"]").val(),$("[name=dataType_"+i+"]").val());
			}
			html+=getHtml(count,'','','','','');
			count++;
			$(".content2").html(html);
		}
		
		function getHtml(index,itemId,itemName,itemStatus,nullable,dataType){
			var html = "";
			html+='<div class="layui-form-item">';
			html+='	<label class="layui-form-label">元素标识</label>';
			html+='	<div class="layui-input-inline">';
			html+='		<input type="text" name="itemId_'+index+'" value="'+itemId+'" placeholder="请输入标识" autocomplete="off" class="layui-input">';
			html+=' </div>';
			html+='	<label class="layui-form-label">元素名称</label>';
			html+='	<div class="layui-input-inline">'
			html+='		<input type="text" name="itemName_'+index+'" value="'+itemName+'" placeholder="请输入名称" autocomplete="off" class="layui-input">';
			html+='	</div>';
			html+=' <label class="layui-form-label">元素状态</label>';
			html+=' <div class="layui-input-inline">';
			html+='		<select name="itemStatus_'+index+'" value="'+itemStatus+'">';
			html+='			<option value="1" '+(itemStatus=="1"?'selected':'')+'>可编辑</option>';
			html+='			<option value="0" '+(itemStatus=="0"?'selected':'')+'>隐藏</option>';
			html+='			<option value="2" '+(itemStatus=="2"?'selected':'')+'>只读</option>';
			html+='			<option value="3" '+(itemStatus=="3"?'selected':'')+'>禁用</option>';
			html+='		</select>';
			html+='	</div>';
			html+='</div>';
			html+='<div class="layui-form-item">';
			html+='	<label class="layui-form-label">空值校验</label>';
			html+='	<div class="layui-input-inline">';
			html+='		<select name="nullable_'+index+'" value="'+nullable+'">';
			html+='			<option value="1" '+(nullable=="1"?'selected':'')+'>是</option>';
			html+='			<option value="0" '+(nullable=="0"?'selected':'')+'>否</option>';
			html+='		</select>';
			html+='	</div>';
			html+='	<label class="layui-form-label">值类型</label>';
			html+='	<div class="layui-input-inline">';
			html+='		<select name="dataType_'+index+'" value="'+dataType+'">';
			html+='			<option value="text" '+(dataType=="text"?'selected':'')+'>文本</option>';
			html+='			<option value="number" '+(dataType=="number"?'selected':'')+'>数字</option>';
			html+='		</select>';
			html+='	</div>';
			html+='</div>';
			return html;
		}
		
		
		
		
	</script>
	
	<script>
	
		
		function trim(str){
			if(str ==''){
				return '';
			}
			return str.replace(/(^\s*)|(\s*$)/g,"");
		}
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
<body onload="main('config/uiconfig.xml');">
	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td id="toolbox" colspan="2" height="20px" class="layui-elem-quote quoteBox">
		</td>
	</tr>
	<tr>
		<td width="100%" style="">
			<div id="graph" style="overflow:auto;width:100%;height:100%;background:url('images/grid.gif');cursor:default;"></div>
		</td>
	</tr>
	</table>
	
	
	
	
	<!-- 节点属性设置 -->
	<form class="layui-form layui-form-pane" style="display:none;padding: 0px 7px;" lay-filter="winCell-win" id="winCell-win">
		<input type="hidden" id="node_activid" />
		<input type="hidden" id="node_positionx" />
		<input type="hidden" id="node_positiony" />
		
		<div class="layui-tab" lay-filter="jdtab">
		  <ul class="layui-tab-title">
		    <li class="layui-this">节点属性</li>
		    <li>应用控制</li>
		  </ul>
		  <div class="layui-tab-content">
		    <div class="layui-tab-item layui-show">
	    		<div class="layui-form-item">
	    			<div class="layui-form-inline">
					    <label class="layui-form-label">节点名称</label>
					    <div class="layui-input-inline">
					      <input type="text" id="node_activname" lay-verify="required" placeholder="请输入节点名称" autocomplete="off" class="layui-input">
					    </div>
				    </div>
	    			<div class="layui-form-inline">
					    <label class="layui-form-label">开始节点</label>
					    <div class="layui-input-inline">
					    	<select id="node_startflag">
								<option value="1">是</option>
								<option value="0">否</option>
							</select>
					    </div>
				    </div>
			  	</div>
			  	
	    		<div class="layui-form-item">
	    			<div class="layui-form-inline">
					    <label class="layui-form-label">发散方式</label>
					    <div class="layui-input-inline">
					    	<select id="node_splitmode">
								<option value="AND">并行</option>
								<option value="OR">选择</option>
								<option value="XOR">独占</option>
							</select>
					    </div>
				    </div>
	    			<div class="layui-form-inline">
					    <label class="layui-form-label">聚合方式</label>
					    <div class="layui-input-inline">
					    	<select id="node_joinmode">
								<option value="XOR">简单</option>
								<option value="AND">同步</option>
							</select>
					    </div>
				    </div>
			  	</div>
			  	
	    		<div class="layui-form-item">
	    			<div class="layui-form-inline">
					    <label class="layui-form-label" style="padding:8px 1px">结束后可阅读</label>
					    <div class="layui-input-inline">
					      <select id="node_readflag">
								<option value="1">是</option>
								<option value="0">否</option>
							</select>
					    </div>
				    </div>
	    			<div class="layui-form-inline">
					    <label class="layui-form-label">节点序号</label>
					    <div class="layui-input-inline">
					      <input type="text" id="node_activorder" class="layui-input" lay-verify="">
					    </div>
				    </div>
			  	</div>
			  	
	    		<div class="layui-form-item">
					    <label class="layui-form-label">处理人模式</label>
					    <div class="layui-input-inline" style="width:89px">
					   		<select id="node_performermode" lay-filter="node_performermode">
								<option value="single">单人</option>
								<option value="multi">多人</option>
							</select>
						</div>
						<label class="layui-form-label" style="width:121px">多处理人方式</label>
						<div class="layui-input-inline" style="width:78px">
							<select id="node_performorder" disabled>
								<option value="serial">顺序</option>
								<option value="parallel">并序</option>
							</select>
						</div>
						<label class="layui-form-label">处理人选择</label>
						<div class="layui-input-inline" style="width:84px">
							<select id="node_performerchoiceflag">
								<option value="0">是</option>
								<option value="1">否</option>
							</select>
					    </div>
			  	</div>
			  	
	    		<div class="layui-form-item">
				    <label class="layui-form-label">默认处理人</label>
				    <div class="layui-input-inline">
						<input type="hidden" id="node_performer" name="node_performer"  />
						<input type="text" layui-verify="" placeholder="请点击选择处理人"  class="layui-input" id="node_performername"  name="node_performername" readonly=true>
						<input type="button" style="position: absolute;left: 141px;top: 1px;height: 36px;width: 48px;" class="layui-btn layui-btn-normal layui-btn-xs" value="选择" onclick="openSelWin('<%=request.getContextPath()%>/address/tree.jsp?utype=3&sflag=0&count=0&ptype=0&fields=node_performername,node_performer');" />
				    </div>
				    <label class="layui-form-label">处理时限</label>
				    <div class="layui-input-inline">
				      <input type="text" id="node_deadline" lay-verify="" placeholder="请输入处理时限，小时" autocomplete="off" class="layui-input">
			   		</div>
			  	</div>
			  	
	    		<div class="layui-form-item">
					    <label class="layui-form-label">流程参与人</label>
					    <div class="layui-input-block">
					      <select>
							</select>
					    </div>
			  	</div>
			  	
	    		<div class="layui-form-item layui-form-text">
					    <label class="layui-form-label">处理人范围</label>
					    <div class="layui-input-block">
					      <textarea class="layui-textarea" style="min-height:37px" placeholder="请点击选择受理人" layui-verify="required" id="node_performerpurviewname" name="node_performerpurviewname" readonly=true></textarea>
							<input type="hidden" id="node_performerpurview" name="node_performerpurview" />
							<input type=button style="position: absolute;top: -36px;right: 0px;height: 36px;width: 73px;" class="layui-btn layui-btn-xs layui-btn-normal" value="选择" class="formbutton"  onclick="openSelWin('<%=request.getContextPath()%>/address/tree.jsp?utype=3&sflag=0&count=0&ptype=0&fields=node_performerpurviewname,node_performerpurview');" />
					    </div>
			  	</div>
			  	
	    		<div class="layui-form-item layui-form-text">
					    <label class="layui-form-label">流向描述</label>
					    <div class="layui-input-block">
					      <textarea class="layui-textarea" id="node_description" rows="2"></textarea>
					    </div>
			  	</div>
			  	
		    </div>
		    
		    <div class="layui-tab-item content2">
	    		
		    </div>
		  </div>
		</div>
		<button style="display:none" type="button" id="jdSub" lay-submit lay-filter="jdSub">提交</button>  
	</form>
	
	
	<!-- 流程属性设置 -->
	<form id="flowset" class="layui-form layui-form-pane" style="margin:5px;display:none">
	<input type="hidden" id="flow_flowid" />
	  <div class="layui-form-item">
	  	<div class="layui-form-inline">
		    <label class="layui-form-label">流程名称</label>
		    <div class="layui-input-inline">
		      <input type="text" id="flow_flowname" lay-verify="required" placeholder="请输入流程名称" autocomplete="off" class="layui-input">
		    </div>
	    </div>
	  	<div class="layui-form-inline">
		    <label class="layui-form-label">流程属性</label>
		    <div class="layui-input-inline">
		    	<select id="flow_flowtype" value="">
					<option value="normal">普通流程</option>
					<option value="soft">柔性流程</option>
					<option value="subflow">子流程</option>
				</select>
		    </div>
	    </div>
	  </div>
	  <div class="layui-form-item">
	  	<div class="layui-form-inline">
		    <label class="layui-form-label">流程管理员</label>
		    <div class="layui-input-inline">
		      <input type="text" id="flow_administrator" lay-verify="" placeholder="请输入流程管理员" autocomplete="off" class="layui-input">
		    </div>
	    </div>
	  	<div class="layui-form-inline">
		    <label class="layui-form-label">流程创建者</label>
		    <div class="layui-input-inline">
		      <input type="text" id="flow_creator" lay-verify="" placeholder="请输入流程创建者" autocomplete="off" class="layui-input">
		    </div>
	    </div>
	  </div>
	  <div class="layui-form-item">
	  	<div class="layui-form-inline">
		    <label class="layui-form-label">流程排序</label>
		    <div class="layui-input-inline">
		      <input type="text" id="flow_floworder" lay-verify="number" placeholder="请输入流程排序" autocomplete="off" class="layui-input">
		    </div>
	    </div>
	  	<div class="layui-form-inline">
		    <label class="layui-form-label">流程状态</label>
		    <div class="layui-input-inline">
			    <select id="flow_flowstatus" value="">
					<option value="0">可用</option>
					<option value="1">禁用</option>
				</select>
		    </div>
	    </div>
	  </div>
	  <div class="layui-form-item">
	  	<div class="layui-form-inline">
		    <label class="layui-form-label">所属模块</label>
		    <div class="layui-input-inline">
		    	<select id="flow_moduleid" value="" lay-filter="flow_moduleid">
					<%for(int i=0;i<arrList.size();i++){
						String[] moduleInfo=(String[])arrList.get(i);
					%>
						<option value="<%=moduleInfo[0]%>"><%=moduleInfo[1]%></option>
					<%
					}%>
				</select>
		    </div>
	    </div>
	  	<div class="layui-form-inline">
		    <label class="layui-form-label">所属应用</label>
		    <div class="layui-input-inline">
		    	<select id="flow_applicationid" value="">
					<%
					for(int i=0;i<appList.size();i++){
						ModuleApplication app=(ModuleApplication)appList.get(i);
					%>
						<option value="<%=app.getApplicationId()%>"><%=app.getApplicationName()%></option>
					<%	
					}
					%>
				</select>
		    </div>
	    </div>
	  </div>
	  <div class="layui-form-item" style="display: none">
	    <label class="layui-form-label">流程参与人</label>
	    <div class="layui-input-inline">
	      <input type="text" id="flow_flowactor" required placeholder="请输入流程参与人" autocomplete="off" class="layui-input">
	    </div>
	  </div>
	  <div class="layui-form-item layui-form-text">
	    <label class="layui-form-label" style="width:100%">流程参访问范围<span style="margin-left:77%"><input type=button value="选择" class="formbutton"  onclick="openSelWin('<%=request.getContextPath()%>/address/tree.jsp?utype=3&sflag=0&count=0&ptype=0&fields=flow_flowrangename,flow_flowrange');" /></span></label>
	    <div class="layui-input-block">
			<textarea id="flow_flowrangename" style="min-height:35px" name="flow_flowrangename" placeholder="请点击选择" readonly class="layui-textarea"></textarea>
			<input type="hidden" id="flow_flowrange" name="flow_flowrange" value=""/>
	    </div>
	  </div>
	  <div class="layui-form-item layui-form-text">
	    <label class="layui-form-label" style="width:100%">流程描述</label>
	    <div class="layui-input-block">
	      <textarea id="flow_description" style="min-height:90px" placeholder="请输入内容" class="layui-textarea"></textarea>
	    </div>
	  </div>
	  <button style="display:none" id="subtn" lay-submit lay-filter="btn">提交</button>  
	</form>
	
	<!-- 流向属性设置窗口 -->
	<form class="layui-form layui-form-pane" id="winLine" style="display:none;padding:8px" lay-filter="winLine">
	 <input type="hidden" id="transTransId" />
	  <div class="layui-form-item">
        <label class="layui-form-label">流向名称</label>
        <div class="layui-input-block">
          <input type="text" id="transName" lay-verify="required" placeholder="请输入流程名称" autocomplete="off" class="layui-input">
        </div>
	  </div>
	  
	  <div class="layui-form-item">
	  	<div class="layui-form-inline">
	       <label class="layui-form-label">选择方式</label>
	       <div class="layui-input-inline">
	         <select id="transFlag">
				<option value="0">不选中</option>
				<option value="1">默认选中</option>
				<option value="2">固定选中</option>
			</select>
	       </div>
	    </div>
	  	<div class="layui-form-inline">
	       <label class="layui-form-label">操作类型</label>
	       <div class="layui-input-inline">
			<select id="transType">
				<option value="half">虚操作</option>
				<option value="open">实操作</option>
			</select>
	       </div>
	    </div>
	  </div>
	  
	  <div class="layui-form-item layui-form-text">
        <label class="layui-form-label">流向描述</label>
        <div class="layui-input-block">
          <textarea id="transDescription" class="layui-textarea"></textarea>
        </div>
	  </div>
	   <button style="display:none" type="button" id="lxSub" lay-submit lay-filter="lxSub">提交</button>  
	</form>
	
	
	
	
	<div id="winLine1" class="x-hidden">
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
<script type="text/javascript" charset="UTF-8" src="<%=contextPath %>/resources/template/cn/layui/layui.js"></script>
<script type="text/javascript">
var layer = "", form = "", element = "", jdtabIndex = 0, index = "", node = "";
	layui.use(['layer','form','element'],function(){
		layer = layui.layer
		,form = layui.form
		,element = layui.element;
		
		
		//监听节点导航切换为应用控制的时候添加新增按钮
		element.on('tab(jdtab)', function(data){
			  jdtabIndex = data.index;
			  if(data.index == 1) {
					$('.layui-layer-btn.layui-layer-btn- .layui-layer-btn0').css('display','');
					$('.layui-layer-btn.layui-layer-btn- .layui-layer-btn1').css('background-color','#fff');
					$('.layui-layer-btn.layui-layer-btn- .layui-layer-btn1').css('color','#333');
			  }
			  if(data.index == 0) {
				  	$('.layui-layer-btn.layui-layer-btn- .layui-layer-btn0').css('display','none');
					$('.layui-layer-btn.layui-layer-btn- .layui-layer-btn1').css('background-color','#1E9FFF');
					$('.layui-layer-btn.layui-layer-btn- .layui-layer-btn1').css('color','#fff');
			  }
		});
		
		//监听节点属性设置表单提交
		form.on('submit(jdSub)', function(data){
			node.setAttribute('node_activname',$('#node_activname').val());
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
			//alert(index);
			layer.close(index);
		});
		
		//监听流程属性设置表单提交
		form.on('submit(btn)', function(data){
			flowAttr.flow_id=$("#flow_flowid").val();
			flowAttr.flow_flowname=$("#flow_flowname").val();
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
			layer.close(index);
		});
		
		//监听流向属性设置表单提交
		form.on('submit(lxSub)', function(data){
			var line=editor.graph.getSelectionCell();
			
			line.setAttribute('transName',$("#transName").val());
			line.setAttribute("label",$("#transName").val());
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
			layer.close(index);
		});
		
		//监听流程属性里的select
		form.on('select(flow_moduleid)', function(data){
			$.ajax({
				url:"<%=request.getContextPath()%>/workflowManagerM/application.jsp",
				data:"moduleId="+data.elem.value+"&timestamp="+new Date().getTime()+"",
				async:false,
				success:function(data){
					$("#flow_applicationid").html(trim(data));
					form.render();
				}
			});
		}); 
		
		//监听节点属性里的select
		form.on('select(node_performermode)', function(data){
			if(data.value == 'single') {
				$("#node_performorder").attr("disabled",true);
			}else{
				$("#node_performorder").attr("disabled",false);
			}
			form.render();
		});      
		
	});
	
	
	//新建确认
	function newFlow(editor) {
		layer.confirm('请确认保存了当前流程信息！', function(index) {
			var url = window.location.href;
			if(url.indexOf("?") > 0){
				url = url.substring(0,url.indexOf("?"));
			}
			window.location.href = url;
			layer.close(index);
		});
	}
	
	//流程属性保存按钮
	function save(editor,isNew){
		//先检查是否有未填项
		var xml = mxUtils.getPrettyXml(new mxCodec().encode(editor.graph.getModel()));
		var result = doCheck(xml);
		if(result.status){
			layer.msg(result.msg);
			return;
		}
		if(isNew == 1) {
			layer.confirm('是否另存流程？',function(index) {
				doSave(editor, isNew, xml);
				layer.close(index);
			});			
		}else{
			layer.confirm('是否保存流程？',function(index) {
				doSave(editor, isNew, xml);
				layer.close(index);
			});	
		}
	}
	//执行流程属性保存
	function doSave(editor, isNew, xml) {
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
					layer.msg('保存成功！');
				}else if(result=='flowname'){
					layer.msg('流程名称不能为空！');
				}else{
					layer.msg('系统异常，请重试！');
				}
				//$("#flow_applicationid").html(trim(data));
			}
		});
	}
	
	//open流程属性
	function flowSet(editor) {
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
		index = layer.open({
			type: 1,
			content: $('#flowset'),
			area: ['674px', '500px'],
			title: '流程属性设置',
			btn: ['保存', '取消'],
			yes: function(index, layero){
				$('#subtn').trigger('click');
			},
			btn2: function(index, layero){
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
				layer.close(index);
			},
			success: function(layero, index){
			   form.render();
			}
		});
	}
	
	//open节点属性设置or流向属性设置
	function cellAttr(editor) {
		var a=editor.graph.getSelectionCell();
		var label=a.getAttribute('label');
		
		if(!editor.graph.getModel().isEdge(a)){
			node=a;
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
			if(!winCell){
				index = layer.open({
					type: 1,
					content: $('#winCell-win'),
					area: ['674px', '500px'],
					title: '节点属性设置',
					btn: ['新增','保存', '取消'],
					yes: function(index, layero){
						addApp();
						form.render();
					},
					btn2: function(index, layero){
						$('#jdSub').trigger('click');
						return false;
					},
					btn3: function(index, layero){
					},
					success: function(layero, index){
						if($('#node_performermode').val() == 'single'){
							$("#node_performorder").attr("disabled",true);
						}else{
							$("#node_performorder").attr("disabled",false);
						};
						if(jdtabIndex == 1) {
							$('.layui-layer-btn.layui-layer-btn- .layui-layer-btn0').css('display','');
							$('.layui-layer-btn.layui-layer-btn- .layui-layer-btn1').css('background-color','#fff');
							$('.layui-layer-btn.layui-layer-btn- .layui-layer-btn1').css('color','#333');
						}
						if(jdtabIndex == 0) {
						 	$('.layui-layer-btn.layui-layer-btn- .layui-layer-btn0').css('display','none');
							$('.layui-layer-btn.layui-layer-btn- .layui-layer-btn1').css('background-color','#1E9FFF');
							$('.layui-layer-btn.layui-layer-btn- .layui-layer-btn1').css('color','#fff');
						}
					   	form.render();
					}
				});
			}
			}else{
				var line=a;
				$("#transName").val(line.getAttribute('transName'));
				$("#transTransId").val(line.getAttribute('transTransId'));
				$("#transFlag").val(line.getAttribute('transFlag'));
				$("#transType").val(line.getAttribute('transType'));
				$("#transDescription").val(line.getAttribute('transDescription'));
				if(!winLine) {
					index = layer.open({
						type: 1,
						content: $('#winLine'),
						area: ['700px', '350px'],
						title: '流向属性设置',
						btn: ['保存', '取消'],
						yes: function(index, layero){
							$('#lxSub').trigger('click');
						},
						btn2: function(index, layero){
						},
						success: function(layero, index){
							form.render();
						}
					});
				}
			}
	}
	//检查是否有未填项
	function doCheck(xml) {
		var status = false, msg = "";
		//检查流向名称是否为空 
		if(xml.indexOf('label="null"') != -1 || xml.indexOf('label="Line"') != -1) {
			status = true;
			msg = "流向名称不能为空";
		}else if(xml.replace(/\s+/g,"").indexOf('Nodelabel="Node"') != -1) {//检查节点名称是否为空
			status = true;
			msg = "节点名称不能为空";
		}else if(flowAttr.flow_flowname == ""){//检查流程属性-->流程名称是否为空
			status = true;
			msg = "流程属性-->流程名称不能为空";
		};
		return {status:status, msg:msg};
	}
	
	function Trim(str){
		return str.replace(/(^\s+)|(\s+$)/g,"");
	}
</script>
</body>
</html>
