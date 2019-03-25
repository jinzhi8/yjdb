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
	<script type="text/javascript" src="../js/layui/layui.js"></script>
	<script type="text/javascript" src="../js/jquery-1.11.0.min.js"></script>
	<script type="text/javascript" src="../js/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="newsAdd.js"></script>
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
	<div class="layui-col-md9 layui-col-xs12">
	<div class="newclass-nytopboxs">
		<div class="layui-form-item">
		    <label class="layui-form-label"><i class="hongdian">*</i>标题</label>
		    <div class="layui-input-block mySelect" id="test">
		       <%-- <select name="title">
					<%=CommonUtil.getHistory()%>
			  </select> --%>
			  	 <input type="text" name="title" id="title" lay-verify="required"  placeholder="请输入标题" class="layui-input" >
		    </div>
		</div>
		<div class="layui-form-item" >
	  		<div class="layui-inline">
		      <label class="layui-form-label">附件</label>
		      <ul class="layui-input-block file-list">
				<li class="file-line lock">
		  			<span class="file-wrap">
			  			<input type="file" name="fileattache"   class="layui-input file-add-input">
			  			<span class="view"><label class="gray">请上传附件材料</label><a>选择</a></span>
		  			</span>
		  			<a class="btn add-file" onclick="file.add(this)" href="javascript:;">增加</a>
				</li>
		      </ul>
		      <%=attach %>
		    </div>
	    </div>
	    <div class="layui-form-item" >
	  		<div class="layui-inline">
				<label class="layui-form-label">钉消息推送</label>
				<div class="layui-input-block">
					<input type="radio" name="tzstatus" title="否" lay-skin="primary"  lay-filter="tzstatus"  value="0" />
					<input type="radio" name="tzstatus" title="是" lay-skin="primary"  lay-filter="tzstatus" value="1"   checked/>
				</div>
			</div>	
		</div>
		<div class="layui-form-item  mb">
		    <label class="layui-form-label "></i>通知单位</label>
		    <div class="layui-input-block">
				<input type="text" class="layui-input l-text" id="tsdepname"  style="width:95%;"  name="tsdepname" readonly="true"  placeholder="请选择需要推送的单位">
				<img  class="l-img" title="点击选择处理人" src="<%=request.getContextPath()%>/resources/images/actn133.gif" onclick="openSelWinNew('<%=request.getContextPath()%>/address/tree_jg.jsp?utype=0&rtype=0&ptype=0&sflag=0&count=0&fields=tsdepname,tsdepnameid');">
				<input type="text" name="tsdepnameid" style="display:none" >
			</div>
		</div>
		<div class="layui-form-item layui-hide mb">
		    <label class="layui-form-label"></i>消息模板</label>
		    <div class="layui-input-block">
				<input type="text" class="layui-input"  name="xxmb" id="xxmb"    value="">
			</div>
	   </div>
	   <div class="layui-form-item magb0">
			<label class="layui-form-label">内容</label>
			<div class="layui-input-block">
				<textarea class="layui-textarea layui-hide" name="zwcontent"  id="zwcontent" placeholder="请输入正文标题"></textarea>
			</div>
	   </div>
	</div>
	</div>
	<div class="layui-col-md3 layui-col-xs12">
	<div class="newclass-nytopboxs">
		<blockquote class="layui-elem-quote title"><i class="seraph icon-caidan"></i> 公告分类</blockquote>
		<div class="border category">
			<div class="">
				<p><input type="checkbox" name="type" title="信息" lay-skin="primary" value="0" lay-check-type="radio"  checked/></p>
				<p><input type="checkbox" name="type" title="公告" lay-skin="primary" value="1" lay-check-type="radio"/></p>
				<p><input type="checkbox" name="type" title="公示" lay-skin="primary" value="2" lay-check-type="radio"/></p>
				<p><input type="checkbox" name="type" title="通知" lay-skin="primary" value="3" lay-check-type="radio"/></p>
				<p><input type="checkbox" name="type" title="通告" lay-skin="primary" value="4" lay-check-type="radio"/></p>
			</div>
		</div>
		<blockquote class="layui-elem-quote title magt10"><i class="layui-icon">&#xe609;</i> 发     布</blockquote>
		<div class="border">
			<div class="layui-form-item layui-hide">
				<label class="layui-form-label"><i class="layui-icon">&#xe60e;</i> 状　态</label>
				<div class="layui-input-block">
					<select name="status" lay-verify="required">
						<option value="1">立即发布</option>
						<option value="0">保存草稿</option>
					</select>
				</div>
			</div>
			<div class="layui-form-item openness">
				<label class="layui-form-label"><i class="seraph icon-look"></i> 置　顶</label>
				<div class="layui-input-block">
					<input type="radio" name="openness" title="是" lay-skin="primary"   value="1"/>
					<input type="radio" name="openness" title="否" lay-skin="primary"   checked  value="0" />
				</div>
			</div>
			<hr class="layui-bg-gray" />
			<div class="layui-center">
				<a class="layui-btn layui-btn-sm"  lay-filter="addNews" lay-submit><i class="layui-icon">&#xe609;</i>发布</a>
				<%if(!unid.equals("")){%>
					<a class="layui-btn layui-btn-sm deleteNews"  lay-filter="" lay-submit>删除</a>
				<%}%>
			</div>
		</div>
	</div>
	</div>
</form>
<script language="javascript" type="text/javascript" charset="utf-8" src="../resources/js/layer/layerFunction.js"></script>
</body>
</html>