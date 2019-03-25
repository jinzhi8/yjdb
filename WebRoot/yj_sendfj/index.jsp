<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.commons.orm.MyDBUtils"%>
<%@page import="java.util.*"%>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="com.kizsoft.yjdb.utils.CommonUtil"%>
<%@page import="com.kizsoft.yjdb.utils.GsonHelp"%>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.acl.ACLManager" %>
<%@page import="com.kizsoft.commons.acl.ACLManagerFactory" %>
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
	 ACLManager aclManager = ACLManagerFactory.getACLManager();
	 int count=MyDBUtils.queryForInt("select count(1) from common_attachment t where docunid='钉钉推送附件上传'  order by uploadtime desc");
	 List<Map<String,Object>> list=MyDBUtils.queryForMapToUC("select t.*,to_char(t.uploadtime,'yyyy-mm-dd')time  from common_attachment t where docunid='钉钉推送附件上传'  order by uploadtime desc");
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>推送列表</title>
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
  <link rel="stylesheet" href="../js/layui/css/layui.css">
  <link rel="stylesheet" href="../css/global.css">
  <script type="text/javascript" src="../js/jquery-1.11.0.min.js"></script>
  <script language="javascript" type="text/javascript" charset="utf-8" src="../resources/js/layer/layerFunction.js"></script>
</head>
<body>
  <div class="fly-panel fly-panel-user newclass-fly-panel">
    <div class="layui-tab layui-tab-brief" lay-filter="user">
      <ul class="layui-tab-title">
        <li class="layui-this">推送列表（<span><%=count%></span>）</li>
        <%if(aclManager.isOwnerRole(userID, "dbk")||aclManager.isOwnerRole(userID, "sysadmin")){%>
        	<li class="addNews_btn">钉钉推送</li>
        <%}%>
      </ul>
      <div class="layui-tab-content" style="padding: 20px 0;">
        <div class="layui-tab-item layui-show">
          <ul class="mine-view jie-row">
          	<%for(Map<String,Object> map:list){
          	%>	
            <li>
              <a class="jie-title" href="<%=request.getContextPath()+"/DownloadAttach?uuid="+map.get("attachmentid")%>" ><%=map.get("attachmentname")%></a>
              <i><%=map.get("time")%></i>
              <%-- <%if(((String)map.get("openness")).equals("1")){%>
              	<a style="background-color:red;" class="mine-edit">置顶</a> --%>
              <%if(aclManager.isOwnerRole(userID, "dbk")){%>
              	<a class="mine-edit newclass-mine-edit"  href="javascript:del('<%=map.get("attachmentid")%>');" style="cursor:pointer">删除</a>
              <%}%>
              <!-- <em>6666下载次数</em> -->
            </li>
            <%}%>
          </ul>
        </div>
      </div>
      
    </div>
  </div>
<script src="../js/layui/layui.js"></script>
<script>
layui.define(['layer', 'laytpl', 'form', 'element', 'upload', 'util'], function(exports){
	  var $ = layui.jquery
	  ,layer = layui.layer
	  ,laytpl = layui.laytpl
	  ,form = layui.form
	  ,element = layui.element
	  ,upload = layui.upload
	  ,util = layui.util
	  ,device = layui.device()
	  ,DISABLED = 'layui-btn-disabled';
	  
	  $(".addNews_btn").click(function(){
	        addNews("");
	  })
	  
});
//添加文章
function addNews(unid){
      var index = layui.layer.open({
          title : "",
          area: ['80%', '80%'],
          type : 2,
          content : "newsAdd.jsp?unid="+unid
      })
}
</script>
</body>
</html>