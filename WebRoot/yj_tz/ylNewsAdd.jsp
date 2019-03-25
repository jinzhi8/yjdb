<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="java.util.Date"%>
<%@page import="java.util.Map"%>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.sql.Clob" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.yjdb.utils.CommonUtil" %>
<%@page import="com.kizsoft.commons.commons.orm.MyDBUtils"%>
<%@page import="com.kizsoft.yjdb.utils.GsonHelp"%>
<%@page import="com.kizsoft.commons.util.UUIDGenerator"%>
<!DOCTYPE html>
<html>
<%
	 //用户登陆验证
	 if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
	 }
	 User userInfo = (User) session.getAttribute("userInfo");
	 String userID = userInfo.getUserId();
	 String userName = userInfo.getUsername();
	 Group groupInfo = userInfo.getGroup();
	 String groupName = groupInfo.getGroupname();
	 String groupID = groupInfo.getGroupId();
	 String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
	 SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
	 String nowtime=sdf.format(new Date());
	 String xmlType = "insert";
	 String unid= CommonUtil.doStr(request.getParameter("unid"));
	 String dataObj = "";
	 String attach="";
	 if(!unid.equals("")){
	  	Map<String,Object> map=MyDBUtils.queryForUniqueMapToUC("select * from yj_tz where unid=?", unid);
	  	String zwcontent= CommonUtil.ClobToString((Clob)map.get("zwcontent"));
	  	map.put("zwcontent",zwcontent);
	  	dataObj = "{\"res\":true,\"data\":"+GsonHelp.toJson(map)+"}";
			xmlType = "update";
			attach=CommonUtil.getAttach(unid,request);
	 }else{
	  	dataObj = "{\"res\":false}";
	 }
	 MyDBUtils.executeUpdate("insert into yj_tz_yd(unid,dbid,userid,username,depid,depname,time) values(?,?,?,?,?,?,sysdate)", new Object[]{UUIDGenerator.getUUID(), unid, userID, userName,groupID,groupName});

%>
<head>
	<meta charset="utf-8">
	<meta name="renderer" content="webkit">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
	<meta name="apple-mobile-web-app-status-bar-style" content="black">
	<meta name="apple-mobile-web-app-capable" content="yes">
	<meta name="format-detection" content="telephone=no">
	<link rel="stylesheet" href="../js/layui/css/layui.css" media="all" />
	<link rel="stylesheet" href="../css/public.css" media="all" />
	<script type="text/javascript" src="../js/jquery-1.11.0.min.js"></script>
	<script type="text/javascript" src="../js/jquery.easyui.min.js"></script>
	<script type="text/javascript">
		var dataObj=<%=dataObj%>;
	</script>
</head>
<body class="childrenBody">
<form class="layui-form layui-row layui-col-space10" action="<%=contextPath%>/yj_common/save.jsp"  id="infoform" enctype="multipart/form-data" method="post" >	
	<input type="hidden" name="xmlName" value="yjtz"/>
	<input type="hidden" name="xmlType" value="<%=xmlType%>"/>
	<input type="hidden" name="moduleId" value="yjtz"/>
	<input type="hidden" name="userid" value="<%=userID%>"/>
	<input type="hidden" name="username" value="<%=userName%>"/>
	<input type="hidden" name="depname" value="<%=groupName%>"/>
	<input type="hidden" name="depid" value="<%=groupID%>"/>
	<input type="hidden" name="unid" value="<%=unid%>"/>
	<input type="hidden" name="createtime" value="<%=nowtime %>" />
		<div class="layui-row layui-col-space10">
				<div class="layui-form-item magt3">
					<label class="layui-form-label">标题</label>
					<div class="layui-input-block">
						<input type="text" class="layui-input" name="title" lay-verify="required" placeholder="请输入标题" readonly>
					</div>
				</div>
		</div>
		<div class="layui-form-item magb0">
			<label class="layui-form-label">内容</label>
			<div class="layui-input-block">
				<textarea class="layui-textarea layui-hide" name="zwcontent"  id="zwcontent" readonly></textarea>
			</div>
		</div>

</form>
<script type="text/javascript" src="../js/layui/layui.js"></script>
<script type="text/javascript" src="newsAdd.js"></script>
<script language="javascript" type="text/javascript" charset="utf-8" src="../resources/js/layer/layerFunction.js"></script>
</body>
</html>