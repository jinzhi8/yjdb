<%@page import="java.util.Calendar"%>
<%@page import="com.kizsoft.yjdb.utils.CommonUtil"%>
<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.acl.ACLManager" %>
<%@page import="com.kizsoft.commons.acl.ACLManagerFactory" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%
//用户登陆验证
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
		return;
	}
	User userInfo = (User) session.getAttribute("userInfo");
	String userId = userInfo.getUserId();
	String userName = userInfo.getUsername();
	Group groupInfo = userInfo.getGroup();
	String groupName = groupInfo.getGroupname();
	String groupID = groupInfo.getGroupId();
	Calendar calendar=Calendar.getInstance();
	int month=calendar.get(Calendar.MONTH);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="cache-control" content="no-cache">
    <title>永嘉督办系统</title>
    <script type="text/javascript" src="../yj_sy/lib/jquery-3.2.1.min.js"></script>
    <link rel="stylesheet" href="../js/layui/css/layui.css" media="all" />
    <link rel="stylesheet" href="css/index.css">
    <script type="text/javascript" src="../yj_sy/lib/echarts.min.js"></script>
    <script type="text/javascript" src="../yj_sy/lib/layer.js"></script>
    <script type="text/javascript" src="../js/layui/layui.js"></script>
</head>
<body>
	<div class="dataCenter-table-pmtj" id="dataCenter-tablescrollbar">
		<div class="dataCenter-table-pmtjtitle">
			<div class="title"><span id="time"><%=month%></span>月各分组排名后三位</div>
			<div class="layui-inline">
	           <div class="layui-input-inline">
	              <input type="text" readonly class="layui-input" id="test" placeholder="时间">
	           </div>
	        </div>
        </div>
		<div id="pmtj" class="public-list pmtj"></div>
    </div>
	<div class="dataCenter-table" id="dataCenter-tablescrollbar">
		<form class="layui-form positionlayui-form">
		      <select name="yhz" lay-verify="required" lay-filter="yhz">
		        <option value="县领导" selected="">县领导</option>
		        <option value="县直属有关单位">县直属有关单位</option>
		        <option value="功能区、乡镇（街道）">功能区、乡镇（街道）</option>
		        <option value="县属国有企业">县属国有企业</option>
		        <option value="重点工程建设单位">重点工程建设单位</option>
		      </select>
		</form>
		<div id="xldsjtj" class="public-list xldsjtj"></div>
    </div>
    <div class="dataCenter-list" id="dataCenter-tablescrollbar">
    	<ul id="dcbs">
    		<!-- <li class="success">
    			<div>这个是事项名字<span>部署<em>1</em>次</span></div>
    			<p>全部完成</p>
    		</li>
    		<li class="fail">
    			<div>这个是事项名字<span>部署<em>10</em>次</span></div>
    			<p>未完成：<span>主要原因是哪些方因是哪些方因是哪些方因是哪些方因是哪些方面balabalabala</span></p>
    		</li> -->
    	</ul>
	</div>
    <div id="bqCount-echart"></div>
</body>
<script src="js/index.js"></script>
<script src="js/js.js?v=<%=Math.random()%>"></script>
<script>
layui.use(['form', 'layer', 'laydate', 'table', 'laytpl','element'], function () {
    var form = layui.form,
        layer = layui.layer,
        laydate = layui.laydate,
        laytpl = layui.laytpl,
        element = layui.element,
        table = layui.table;
   
	form.on("select(yhz)", function (data) {
		getDataFn.getFxz(data.value);
	});
	
	//年月选择器
	laydate.render({ 
	  elem: '#test'
	  ,type: 'month'
	  ,done: function(value, date, endDate){
	  	  $('#time').text(value);
		  getDataFn.getPmtj(value);
	   }
	});
});
</script>
</html>
