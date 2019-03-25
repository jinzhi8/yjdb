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
	 List<Map<String,Object>> list=MyDBUtils.queryForMapToUC("select t.*  from yj_tz t  order by openness desc,createtime desc");
	 Map<String,Object> countMap=MyDBUtils.queryForUniqueMap("select count(decode(t.type, '0', 1)) count0,count(decode(t.type, '1', 1)) count1,count(decode(t.type, '2', 2)) count2,count(decode(t.type, '3', 1)) count3,count(decode(t.type, '4', 1)) count4  from yj_tz t  order by openness desc,createtime desc");

%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>用户中心</title>
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
  <link rel="stylesheet" href="../js/layui/css/layui.css">
  <link rel="stylesheet" href="../css/global.css">
  <script type="text/javascript" src="../js/jquery-1.11.0.min.js"></script>
</head>
<body>
  <div class="fly-panel fly-panel-user newclass-fly-panel">
    <div class="layui-tab layui-tab-brief" lay-filter="user">
      <ul class="layui-tab-title">
        <li class="layui-this">信息（<span><%=countMap.get("count0")%></span>）</li>
        <li >公告（<span><%=countMap.get("count1")%></span>）</li>
        <li >公示（<span><%=countMap.get("count2")%></span>）</li>
        <li >通知（<span><%=countMap.get("count3")%></span>）</li>
        <li >通告（<span><%=countMap.get("count4")%></span>）</li>
        <%if(aclManager.isOwnerRole(userID, "dbk")){%>
        	<li class="addNews_btn">新增</li>
        <%}%>
      </ul>
      <div class="layui-tab-content" style="padding: 20px 0;">
      
        <div class="layui-tab-item layui-show">
          <ul class="mine-view jie-row">
          	<%for(Map<String,Object> map:list){
          		if(((String)map.get("type")).equals("0")){
          			int count=MyDBUtils.queryForInt("select count(1) from yj_tz_yd t where dbid=?",(String)map.get("unid"));
          	%>	
            <li>
              <a class="jie-title" href="javascript:yl('<%=map.get("unid")%>');" ><%=map.get("title")%></a>
              <i><%=map.get("createtime")%></i>
              <%if(((String)map.get("openness")).equals("1")){%>
              	<a style="background-color:red;" class="mine-edit">置顶</a>
              <%}if(userID.equals(map.get("userid"))){%>
              	<a class="mine-edit"  href="javascript:addNews('<%=map.get("unid")%>');" style="cursor:pointer">编辑</a>
              <%}%>
              <em><%=count %>阅</em>
            </li>
            <%}}%>
          </ul>
        </div>
        
        <div class="layui-tab-item">
          <ul class="mine-view jie-row">
          	<%for(Map<String,Object> map:list){
          		if(((String)map.get("type")).equals("1")){
          			int count=MyDBUtils.queryForInt("select count(1) from yj_tz_yd t where dbid=?",(String)map.get("unid"));
          	%>
            <li>
              <a class="jie-title" href="javascript:yl('<%=map.get("unid")%>');" ><%=map.get("title")%></a>
              <i><%=map.get("createtime")%></i>
              <%if(((String)map.get("openness")).equals("1")){%>
              	<a style="background-color:red;" class="mine-edit">置顶</a>
              <%}if(userID.equals(map.get("userid"))){%>
              	<a class="mine-edit"  href="javascript:addNews('<%=map.get("unid")%>');" style="cursor:pointer">编辑</a>
              <%}%>
              <em><%=count %>阅</em>
            </li>
            <%}}%>
          </ul>
        </div>
        
        <div class="layui-tab-item">
          <ul class="mine-view jie-row">
          	<%for(Map<String,Object> map:list){
          		if(((String)map.get("type")).equals("2")){
          			int count=MyDBUtils.queryForInt("select count(1) from yj_tz_yd t where dbid=?",(String)map.get("unid"));
          	%>
            <li>
              <a class="jie-title" href="javascript:yl('<%=map.get("unid")%>');" ><%=map.get("title")%></a>
              <i><%=map.get("createtime")%></i>
              <%if(((String)map.get("openness")).equals("1")){%>
              	<a style="background-color:red;" class="mine-edit">置顶</a>
              <%}if(userID.equals(map.get("userid"))){%>
              	<a class="mine-edit"  href="javascript:addNews('<%=map.get("unid")%>');" style="cursor:pointer">编辑</a>
              <%}%>
              <em><%=count %>阅</em>
            </li>
            <%}}%>
          </ul>
        </div>
        
        <div class="layui-tab-item">
          <ul class="mine-view jie-row">
          	<%for(Map<String,Object> map:list){
          		if(((String)map.get("type")).equals("3")){
          			int count=MyDBUtils.queryForInt("select count(1) from yj_tz_yd t where dbid=?",(String)map.get("unid"));
          	%>
            <li>
              <a class="jie-title" href="javascript:yl('<%=map.get("unid")%>');" ><%=map.get("title")%></a>
              <i><%=map.get("createtime")%></i>
              <%if(((String)map.get("openness")).equals("1")){%>
              	<a style="background-color:red;" class="mine-edit">置顶</a>
              <%}if(userID.equals(map.get("userid"))){%>
              	<a class="mine-edit"  href="javascript:addNews('<%=map.get("unid")%>');" style="cursor:pointer">编辑</a>
              <%}%>
              <em><%=count %>阅</em>
            </li>
            <%}}%>
          </ul>
        </div>
        
        <div class="layui-tab-item">
          <ul class="mine-view jie-row">
          	<%for(Map<String,Object> map:list){
          		if(((String)map.get("type")).equals("4")){
          			int count=MyDBUtils.queryForInt("select count(1) from yj_tz_yd t where dbid=?",(String)map.get("unid"));
          	%>
            <li>
              <a class="jie-title" href="javascript:yl('<%=map.get("unid")%>');" ><%=map.get("title")%></a>
              <i><%=map.get("createtime")%></i>
              <%if(((String)map.get("openness")).equals("1")){%>
              	<a style="background-color:red;" class="mine-edit">置顶</a>
              <%}if(userID.equals(map.get("userid"))){%>
              	<a class="mine-edit"  href="javascript:addNews('<%=map.get("unid")%>');" style="cursor:pointer">编辑</a>
              <%}%>
              <em><%=count %>阅</em>
            </li>
            <%}}%>
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
          title : "通知公告",
          type : 2,
          content : "newsAdd.jsp?unid="+unid,
          success : function(layero, index){
              setTimeout(function(){
                  layui.layer.tips('点击此处返回列表', '.layui-layer-setwin .layui-layer-close', {
                      tips: 3
                  });
              },500)
          }
      })
      layui.layer.full(index);
      //改变窗口大小时，重置弹窗的宽高，防止超出可视区域（如F12调出debug的操作）
     /*  $(window).on("resize",function(){
          layui.layer.full(index);
      }) */
}

//预览
function yl(unid){
      var index = layui.layer.open({
          title : "通知公告",
          type : 2,
          content : "ylNewsAdd.jsp?unid="+unid,
          success : function(layero, index){
              setTimeout(function(){
                  layui.layer.tips('点击此处返回列表', '.layui-layer-setwin .layui-layer-close', {
                      tips: 3
                  });
              },500)
          }
      })
      layui.layer.full(index);
      //改变窗口大小时，重置弹窗的宽高，防止超出可视区域（如F12调出debug的操作）
      $(window).on("resize",function(){
          layui.layer.full(index);
      })
}
</script>
</body>
</html>