<html>
<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="java.util.*" %>
<%@page import="com.kizsoft.commons.commons.user.*"%>
<%@page import="com.kizsoft.commons.commons.util.StringHelper"%>
<%@page import="com.kizsoft.commons.uum.service.IUUMService"%>
<%@page import="com.kizsoft.commons.uum.utils.UUMContend"%>
<%@page import="com.kizsoft.commons.uum.pojo.Owner"%>
<%@page import="com.kizsoft.commons.acl.ACLManager"%>
<%@page import="com.kizsoft.commons.acl.ACLManagerFactory"%>
<%//用户登陆验证
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
		return;
	}
	User userInfo = (User) session.getAttribute("userInfo");
	String userID = userInfo.getUserId();
%>
<%
	IUUMService iuumService = UUMContend.getUUMService();
	List topLevelList =  new ArrayList();
	topLevelList = iuumService.getTopLevel();
	for (int j = 0; j < topLevelList.size(); j++) {
		Owner topOwner = (Owner)topLevelList.get(j);
		
	}
%>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<title>用户</title>
	<script type="text/javascript" charset="utf-8" src="<%=request.getContextPath()%>/resources/js/treeview/jquery.js"></script>
	<script type="text/javascript" charset="utf-8" src="<%=request.getContextPath()%>/resources/js/treeview/jquery.tree.js"></script>
	<script type="text/javascript" charset="utf-8" src="<%=request.getContextPath()%>/resources/js/treeview/treedata.js"></script>
	<link href="<%=request.getContextPath()%>/resources/js/treeview/jquery.tree.css" type="text/css" rel="stylesheet"/>
	<script type="text/javascript">
        $(document).ready(function() {
            var o = { 
				method: "POST", //默认采用POST提交数据
                datatype: "json", //数据类型是json
                url: false, //异步请求的url
                //cbiconpath: jsPath+"images/icons/", //checkbox icon的目录位置
                //icons: ["checkbox_0.gif", "checkbox_1.gif", "checkbox_2.gif"],
                //emptyiconpath:jsPath+"images/s.gif", //checkbxo三态的图片
                showcheck: true, //是否显示checkbox
                oncheckboxclick: false, //当checkstate状态变化时所触发的事件，但是不会触发因级联选择而引起的变化
                onnodeclick: false, // 触发节点单击事件
                cascadecheck: false, //是否启用级联，默认启用
                //data: null, //初始化数据
                clicktoggle: true, //点击节点展开和收缩子节点
                //theme: "bbit-tree-arrows" //三种风格备选：bbit-tree-lines ,bbit-tree-no-lines,bbit-tree-arrows
                //url: "http://jscs.cloudapp.net/ControlsSample/GetChildData" 
                theme: "bbit-tree-lines", //bbit-tree-lines ,bbit-tree-no-lines,bbit-tree-arrows
                onnodeclick:function(item){}
            };
            o.data = treedata;
            $("#tree").treeview(o);
            $("#showchecked").click(function(e){
				var userIds = [];
				var userNames = [];
                var items=$("#tree").getTSNs();
				for (var i = 0, l = items.length; i < l; i++) {
					userIds.push(items[i].text);
					userNames.push(items[i].value);
				}
				alert(userIds.join(","));
				alert(userNames.join(","));
                if(items !=null)
                alert(items.join(","));
                else
                alert("");
            });
        });
	</script>
</head>
<body class='ie'>
    <div style="border-bottom: #c3daf9 1px solid; border-left: #c3daf9 1px solid; width: 250px; height: 500px; overflow: auto; border-top: #c3daf9 1px solid; border-right: #c3daf9 1px solid;">
        <div id="tree">   
        </div>
    </div>
	<div style="margin-bottom:5px;">
        <button id="showchecked">确定</button>
    </div>
</body>
</html>
