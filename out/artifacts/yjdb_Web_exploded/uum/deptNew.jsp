<%@page import="com.kizsoft.commons.uum.utils.UUMContend"%>
<%@page import="java.util.Map"%>
<%@page import="com.kizsoft.commons.uum.pojo.Owner"%>
<%@page import="com.kizsoft.commons.commons.orm.MyDBUtils"%>
<%@page import="com.kizsoft.oa.wzbwsq.util.GsonHelp"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@page import="com.kizsoft.commons.uum.pojo.Role" %>
<%@page import="java.util.List" %>
<% try {
	List list = (List) request.getAttribute("list");
	List list2 = (List) request.getAttribute("list2"); //已选中的职位信息
	String ownerid = (String) request.getAttribute("ownerid");
	String action = (String) request.getAttribute("edit");
	Owner owner = null;
	List roleList = null;
	if(ownerid != null){
		MyDBUtils db = new MyDBUtils();
		roleList = UUMContend.getUUMService().getRoleListByOwnerId(ownerid);
		owner = db.queryForObject(Owner.class, "select * from owner where id = ?", ownerid);
		//System.out.println(GsonHelp.toJson(owner));
	}
	if (action == null) action = "null";
	//System.out.println(GsonHelp.toJson(list));
	%>

<title>
</title>
<link href="css/styles.css" rel="stylesheet" type="text/css"/>
<link rel="stylesheet" href="<%=request.getContextPath() %>/resources/template/cn/layui/css/layui.css" media="all" />
<base target="_self">
<body align="center" style="padding:5px">
<script type="text/javascript">
	function send(target) {
		document.deptForm.action = "owner.do?action=" + target;
		document.deptForm.submit();
	}
</script>
<html:form action="uum/owner.do" method="post" styleClass="layui-form" target="_self">
<input type="hidden" name="ownerid" value="<%=ownerid%>">
<div class="layui-tab">
  <ul class="layui-tab-title">
    <li class="layui-this">部门信息</li>
    <li>属性信息</li>
    <li>职位信息</li>
  </ul>
  
  <div class="layui-tab-content">
    <div class="layui-tab-item layui-show">
      <div class="layui-form-item">
	    <div class="layui-inline">
	      <label class="layui-form-label">部门代码</label>
	      <div class="layui-input-inline">
	     <% if (action.equals("edit")) { %>
	        <input type="tel" name="ownercode" id="ownercode" readonly autocomplete="off" class="layui-input">
       	 <% } else {  %>
	        <input type="tel" name="ownercode" lay-verify="required" placeholder="请输入部门代码" autocomplete="off" class="layui-input">
	     <% } %>
	      </div>
	    </div>
	    <div class="layui-inline">
	      <label class="layui-form-label">部门名称</label>
	      <div class="layui-input-inline">
	        <input type="text" name="ownername" id="ownername" lay-verify="required" placeholder="请输入部门名称" autocomplete="off" class="layui-input">
	      </div>
	    </div>
	  </div>
	  
	  <div class="layui-form-item">
	      <label class="layui-form-label">类型</label>
	      <div class="layui-input-inline">
	      	<select name="flag" id="flag">
	      		<option value="2">科室</option>
	      		<option value="3">子部门</option>
	      		<option value="4">部门</option>
	      		<option value="5">组织</option>
	      	</select>
	      </div>
	  </div>
	  
	  <div class="layui-form-item layui-form-text">
	      <label class="layui-form-label">描述</label>
	      <div class="layui-input-block">
	      	<textarea class="layui-textarea" id="desc" name="desc"></textarea>
	      </div>
	  </div>
    
    </div>
    <!-- 属性信息 -->
    <div class="layui-tab-item">
     <div class="layui-form-item">
     	<div class="layui-inline">
	      <label class="layui-form-label">联系电话</label>
	      <div class="layui-input-inline">
	        <input type="tel" name="telephone" id="telephone" autocomplete="off" class="layui-input">
	      </div>
	    </div>
     	<div class="layui-inline">
	      <label class="layui-form-label">传真号码</label>
	      <div class="layui-input-inline">
	        <input type="tel" name="faxno" id="faxno" autocomplete="off" class="layui-input">
	      </div>
	    </div>
	  </div>
	  
     <div class="layui-form-item">
     	<div class="layui-inline">
	      <label class="layui-form-label">联系地址</label>
	      <div class="layui-input-inline">
	        <input type="tel" name="address" id="address" autocomplete="off" class="layui-input">
	      </div>
	    </div>
     	<div class="layui-inline">
	      <label class="layui-form-label">电子邮件</label>
	      <div class="layui-input-inline">
	        <input type="tel" name="email" id="email" lay-verify="emaila" autocomplete="off" class="layui-input">
	      </div>
	    </div>
	  </div>
    </div>
    <!-- 职位信息 -->
    <div class="layui-tab-item">
    	<fieldset>
			<legend>选择职位</legend>
			<table width="400" height="65" border="0" align=center cellpadding=0 cellspacing=0>
				<tr>
					<td width="49%" align="right"><select lay-ignore name="leftcol" class="smallcol" size="6" multiple>
						<% 
						if (list != null) {
							for (int i = 0; i < list.size(); i++) {
								Role role = (Role) list.get(i); %>
						<option value="<%=role.getId()%>"><%=role.getRolename()%>
						</option>
						<% }
						} %>
					</select> &nbsp;&nbsp;</td>
					<td width="4%" align="right">
						<img src="images/rt.gif" title="右移" width="16" height="16" border="0" onclick="moveModule('leftcol','finRole')">
						<img src="images/lt.gif" title="左移" width="16" height="16" border="0" onclick="moveModule('finRole','leftcol')">
						<br>
					</td>
					<td width="47%" align="left">
						<div align="center">
							<select name="finRole" lay-verify="selecta" lay-ignore class="smallcol" multiple="multiple">
									<% 		if (roleList != null) {
											for (int i = 0; i < roleList.size(); i++) {
												Role role = (Role) roleList.get(i); %>
										<option value="<%=role.getId()%>"><%=role.getRolename()%></option>
										<% }
										} %>
							</select>
						</div>
					</td>
				</tr>
			</table>
		</fieldset>
    </div>
  </div>
</div>
<div class="layui-form-item" style="position:fixed;right:21px;bottom:-1px">
  <div class="layui-input-block">
    <button class="layui-btn layui-btn-normal" type="button" lay-submit lay-filter="save">保存</button>
    <button class="layui-btn layui-btn-primary" type="button" id="close">关闭</button>
  </div>
</div>
</html:form>


<script type="text/javascript" src="<%=request.getContextPath() %>/resources/template/cn/layui/layui.js"></script>
<script type="text/javascript">
	layui.use(['layer','jquery','form','element'], function() {
		var form = layui.form
		,layer = layui.layer
		,$ = layui.jquery
		,element = layui.element;
		<% if(ownerid != null) { %>
		$('#ownercode').val('<%=owner.getOwnercode()%>');
		$('#ownername').val('<%=owner.getOwnername()%>');
		$('#flag').val('<%=owner.getFlag()%>');
		$('#desc').val('<%=owner.getDescription()%>');
		$('#telephone').val('<%=owner.getPhone()%>');
		$('#faxno').val('<%=owner.getFaxno()%>');
		$('#address').val('<%=owner.getAddress()%>');
		$('#email').val('<%=owner.getEmail()%>');
		
		
		
		var flag = '<%=owner.getFlag()%>';
		$("#flag option[value='"+flag+"']").attr("selected",true);
		form.render('select');
		<% } %>
		
		//监听表单提交
		form.on('submit(save)', function(data){
			<% if(action.equals("edit")) { %>
				send("moddept");
			<% } else { %>
				send("savedept");
			<% } %>
  		});
		//关闭按钮
		$('#close').click(function(){
			var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
			parent.layer.close(index); //再执行关闭   
		});
		
		form.verify({
			emaila: function(value, item){
				if(!/^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+(.[a-zA-Z0-9_-])+/.test(value) && value != ""){
					return '邮箱不正确';
				}
			},
			selecta: function(){
				$('[name=finRole] option').attr("selected","selected");
			}
		});
	});
</script>
<script language="Javascript">
	function formSubmit() {
		document.deptForm.submit();
	}
	function moveModule(o_col, d_col) {

		var ops = document.deptForm[o_col].options;
		var oplen = ops.length;
		for (o_sl = oplen - 1; o_sl >= 0; o_sl--) {
			//o_sl = document.fm[o_col].selectedIndex;
			d_sl = document.deptForm[d_col].length;
			if (o_sl != -1 && document.deptForm[o_col].options[o_sl].value > "" && ops[o_sl].selected) {
				oText = document.deptForm[o_col].options[o_sl].text;
				oValue = document.deptForm[o_col].options[o_sl].value;
				document.deptForm[o_col].options[o_sl] = null;
				document.deptForm[d_col].options[d_sl] = new Option(oText, oValue, false, true);
			}
		}
	}
</script>

<% } catch (Exception ex) {
	ex.printStackTrace();
}%><!--索思奇智版权所有-->