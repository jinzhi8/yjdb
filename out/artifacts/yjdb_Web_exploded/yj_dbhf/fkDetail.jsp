<%@page import="java.util.Calendar"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="java.util.Date"%>
<%@page import="java.util.Map"%>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.yjdb.utils.CommonUtil" %>
<%@page import="com.kizsoft.commons.commons.orm.MyDBUtils"%>
<%@page import="com.kizsoft.yjdb.utils.GsonHelp"%>
<html>
<head>
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
	String xmlType = "insert";
	String groupID = groupInfo.getGroupId();
	String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	Date date = new Date();
    String nowtime = sdf.format(date);
    String fkid = CommonUtil.doStr(request.getParameter("fkid"));
    String dataObj = "";
    String attach = "";
    Map<String,Object> map = new HashMap<String, Object>();
    List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
    if(!fkid.equals("")){
    	map = MyDBUtils.queryForUniqueMapToUC("select y.*,l.title title,l.depid depid,l.details details,l.statetime bjtime,l.state statelr from yj_dbhf y,yj_lr l where y.unid = l.unid and fkid = ?", fkid);
    	dataObj = "{\"res\":true,\"data\":"+GsonHelp.toJson(map)+"}";
    	//System.out.println(dataObj);
		attach = CommonUtil.getAttach(fkid,request);
    }else{
    	dataObj = "{\"res\":false}";
    }
    
%>
	<meta charset="utf-8">
	<title>批示件反馈</title>
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
	<script type="text/javascript" src="fkShow.js"></script>	
	<script type="text/javascript">
		$(function(){
			var dataObj = <%=dataObj%>;
			if(dataObj.res) {
				var data = dataObj.data;
				for ( var obj in data) {
					if("title,details,lsqk,problem,xbsl,deptname,statelr".indexOf(obj) == -1) continue;
					if(obj == 'deptname') {
						$('.'+ obj).text(data['deptname'] + "  " + data['linkman'] + "  " + data['createtime']);
						continue;
					}
					if(obj == 'statelr') {
						if("1" == data[obj]) {
							$('.'+ obj).text('未办结 ');
						} else if("2" == data[obj]) {
							$('.'+ obj).text('已办结   ' + data['bjtime']);
						}
						
						continue;
					}
					if(data[obj] == "") {
						$('.'+obj).text('无');
					} else {
						$('.'+obj).text(data[obj]);
					}
				}
			}
		})
	</script>
	<style type="text/css">
		tr td div {
			width:100%;
			word-break: break-all;
			word-wrap: break-word;
		}
	</style>
</head>
<body class="childrenBody">
	<div class="layui-col-lg12 layui-col-md12">
			<blockquote class="layui-elem-quote" style="padding: 15px 82px">
				<input type="hidden" value="<%=fkid %>" id="fkid">
				<input type="hidden" value="<%=map.get("unid") %>" id="unid">
				<div style="text-align:center;" class="title"></div>
				<% if(map.get("depid").equals(groupID)) {%>
				<button class="layui-btn layui-btn-primary layui-btn-sm del" style="position:absolute; right:16px; top:10px"><i class="layui-icon">&#xe640;</i>删除</button>
				<% } %>
			</blockquote>
			<table class="layui-table magt0">
				<colgroup>
					<col width="150">
					<col>
				</colgroup>
				<tbody>
				<tr>
					<td>任务内容</td>
					<td><div class="details"></div></td>
				</tr>
				<tr>
					<td>落实情况</td>
					<td><div class="lsqk"></div></td>
				</tr>
				<tr>
					<td>存在问题</td>
					<td><div class="problem"></div></td>
				</tr>
				<tr>
					<td>下步思路</td>
					<td><div class="xbsl"></div></td>
				</tr>
				<tr>
					<td>反馈单位</td>
					<td><div class="deptname"></div></td>
				</tr>
				<tr>
					<td>办结状态</td>
					<td><div class="statelr"></div></td>
				</tr>
				<tr>
					<td></td>
					<td><%=attach %></td>
				</tr>
				</tbody>
			</table>
		</div>
	<script language="javascript" type="text/javascript" charset="utf-8" src="../resources/js/layer/layerFunction.js"></script>
</body>
</html>
