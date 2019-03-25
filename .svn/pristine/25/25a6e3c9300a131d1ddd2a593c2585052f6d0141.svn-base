<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.commons.orm.MyDBUtils" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.yjdb.utils.CommonUtil" %>
<%@page import="com.kizsoft.yjdb.utils.GsonHelp" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Calendar" %>
<%@page import="java.util.Date" %>
<%@page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<html>
<head>
    <%
        //用户登陆验证
        if (session.getAttribute("userInfo") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        User userInfo = (User) session.getAttribute("userInfo");
        String userID = userInfo.getUserId();
        String userName = userInfo.getUsername();
        Group groupInfo = userInfo.getGroup();
        String groupName = groupInfo.getGroupname();
        String groupID = groupInfo.getGroupId();
        String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
    %>
    <meta charset="utf-8">
    <meta charset="utf-8">
	<meta name="renderer" content="webkit">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
	<meta name="apple-mobile-web-app-status-bar-style" content="black">
	<meta name="apple-mobile-web-app-capable" content="yes">
	<meta name="format-detection" content="telephone=no">
	<link rel="stylesheet" href="../js/layui/css/layui.css" media="all" />
	<link rel="stylesheet" href="../css/public.css" media="all" />
	<script type="text/javascript" src="../js/layui/layui.js"></script>
	<script type="text/javascript" src="../js/jquery-1.11.0.min.js"></script>
	<script type="text/javascript" src="../js/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="newsAdd.js"></script>
</head>
<body>
<form class="layui-form layui-form-pane" action="save.jsp" id="infoform" enctype="multipart/form-data" method="post">
    <fieldset class="layui-elem-field layui-field-title newclass-layui-elem-field" style="margin-top: 15px;">
	  <legend>通过钉钉推送报表</legend>
	</fieldset>
    <div class="layui-form-item">
        <label class="layui-form-label"><i class="hongdian">*</i>发送人员</label>
        <div class="layui-input-block">
            <input type="text" class="layui-input l-text" name="ryname" readonly="true" placeholder="请选择发送人员,只能发送给个人，并且最多发送20位"  lay-verify="required">
            <img class="l-img" title="点击选择处理人" src="<%=request.getContextPath()%>/resources/images/actn133.gif"
                 onclick="openSelWinNew('<%=request.getContextPath()%>/address/tree_ry.jsp?utype=1&sflag=0&count=1&fields=ryname,rynameid');">
            <input type="text" name="rynameid"  style="display:none">
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-inline file">
            <label class="layui-form-label"><i class="hongdian">*</i>附件</label>
            <ul class="layui-input-block file-list">
                <li class="file-line lock">
		  			<span class="file-wrap">
			  			<input type="file" name="fileattache" class="layui-input file-add-input" lay-verify="required">
			  			<span class="view"><label class="gray">请上传附件材料</label><a>选择</a></span>
		  			</span>                   
                </li>
            </ul>
        </div>
    </div>
    <div class="layui-form-item bottom-btn-wrap">
        <submit class="layui-btn" lay-submit="" lay-filter="button">立即提交</submit>
    </div>
</form>
<script language="javascript" type="text/javascript" charset="utf-8"
        src="../resources/js/layer/layerFunction.js"></script>
</body>
</html>

