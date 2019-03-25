<%@page import="java.util.List"%>
<%@page import="com.kizsoft.commons.module.beans.ModuleInfo"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.kizsoft.yjdb.utils.GsonHelp"%>
<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.module.beans.ModuleManager" %>
<%@page import="com.kizsoft.commons.workflow.Flow" %>
<%@page import="com.kizsoft.commons.workflow.dao.FlowDAO" %>
<%@page import="java.util.ArrayList" %>
<%@page import="java.util.Collection" %>
<%@page import="java.util.Iterator" %>
<% //用户登陆验证
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
	}
	String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
	User userInfo = (User) session.getAttribute("userInfo");
	String userID = userInfo.getUserId();
	Group groupInfo = userInfo.getGroup();
	String groupID = groupInfo.getGroupId();
	String idsStr = userID;

	String moduleID = request.getParameter("moduleid");

	FlowDAO flowDAO = new FlowDAO();
	ModuleManager moduleManager = new ModuleManager();
	ArrayList arrList = (ArrayList) moduleManager.getModuleListWithFlow(idsStr);
	List<Map<String, Object>> alist = new ArrayList<Map<String, Object>>();
	for(int i = 0; i < arrList.size(); i++) {
		Map<String,Object> map = new HashMap<String,Object>();
		String[] ss = (String[])arrList.get(i);
		map.put("name", ss[1]);
		map.put("id", "1");
		Collection flowsList2 = flowDAO.getFlowList(userID, ss[0]); 
		int ff = flowsList2.size();
		List sss = new ArrayList();
		Iterator iterator2 = flowsList2.iterator();
		for (int j = 1; j <= ff; j++) {
			Flow flow = (Flow) iterator2.next();
			Map<String,Object> map2 = new HashMap<String,Object>();
			map2.put("name", flow.getFlowName());
			map2.put("flowid", flow.getFlowId());
			sss.add(map2);
		}
		map.put("children", sss);
		alist.add(map);
	}
	String json = GsonHelp.toJson(alist);
%>
<link rel="stylesheet" href="<%=contextPath%>/resources/template/cn/layui/css/layui.css" +math.random()="" media="all">
<script language="JavaScript">
	function openflow(flowId) {
		var appletwin = window.parent.document.cframe.window;
		appletwin.location.href="<%=contextPath%>/workflowManagerM/mxGraph.jsp?flowid="+flowId;
	}
</script>
<SCRIPT src="<%=contextPath%>/resources/tree/tree.js" type=text/javascript></SCRIPT>

<style type="text/css">
	html {
		overflow-x: hidden;
		width: 100%;
		height: 100%;
		scrollbar-base-color: #f0f0f0;
	}

	body {
		overflow-x: hidden;
		margin: 0px;
		background-color: #FFFFFF;
		color: #555555;
		width: 100%;
		height: 100%;
		font-size: 12px;
	}

	td {
		padding: 0px;
		font-size: 12px;
	}

	a {
		font-size: 12px;
		color: #555555;
		text-decoration: none;
	}

	img {
		border: 0px;
	}
	
	.layui-elem-quote.quoteBox {
		width: 77%;	
		line-height: 35px;
	}
	
	.layui-elem-quote.quoteBox span {
		font-size: 20px;
	}
</style>
<body>
<blockquote class="layui-elem-quote quoteBox">
		<span>应用模块导航</span>
</blockquote>
<ul id="demo"></ul>
<script type="text/javascript" charset="UTF-8" src="<%=contextPath %>/resources/template/cn/layui/layui.js"></script>
<SCRIPT type=text/javascript>
	layui.use(['layer','tree'],function(){
		var layer = layui.layer
		tree = layui.tree;
		
		//树状结构
		layui.tree({
			  elem: '#demo' //传入元素选择器
			  ,nodes: <%=json%>
			  ,click: function(node){
				  if(node.id != 1) {
					  openflow(node.flowid);
				  }
			  }
			});
			    
		
	});
</SCRIPT>
</body>

<!--索思奇智版权所有-->