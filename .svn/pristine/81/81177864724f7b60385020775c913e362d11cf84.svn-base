<%@ page language="java" contentType="text/html;charset=utf-8"%>
<%@page import="com.kizsoft.commons.commons.user.*"%>
<%@page import="com.kizsoft.commons.commons.util.StringHelper"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page import="com.kizsoft.commons.component.entity.FieldEntity"%>
<%@page import="com.kizsoft.commons.uum.pojo.Owner"%>
<%@page import="com.kizsoft.commons.uum.utils.UUMContend"%>
<%@page import="com.kizsoft.commons.uum.service.IUUMService"%>
<%@page import="com.kizsoft.commons.commons.db.ConnectionProvider"%>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld"%>

<%
    User userInfo = (User)session.getAttribute("userInfo");
	if(userInfo == null) {
        response.sendRedirect(request.getContextPath()+"/login.jsp");
		return;
	}
	String parentID = StringHelper.isNull(request.getParameter("parentid"))?"":request.getParameter("parentid");
	String ownerID = StringHelper.isNull(request.getParameter("ownerid"))?"":request.getParameter("ownerid");
	IUUMService uumService = UUMContend.getUUMService();
	String ownerName = ((Owner)uumService.getOwnerByOwnerid(ownerID)).getOwnername();
%>
<%
	String action = StringHelper.isNull(request.getParameter("action"))?"":request.getParameter("action");
	if("update".equals(action)){
		if(!StringHelper.isNull(parentID)&&!StringHelper.isNull(ownerID)){
			Connection conn = null;
			Statement stmt = null;
			ResultSet rs = null;
			try
			{
				conn = ConnectionProvider.getConnection();
				stmt = conn.createStatement();
				String sql = "delete from ownerrelation WHERE ownerid='"+ownerID+"'";
				stmt.executeUpdate(sql);
				sql = "select max(orderid) maxorder from ownerrelation t where parentid='"+parentID+"'";
				rs = stmt.executeQuery(sql);
				int maxorder = 1;
				if(rs.next()){
					maxorder = rs.getInt(1)+1;
				}
				sql = "insert into ownerrelation(id,ownerid,parentid,relation,orderid) values(sys_guid(),'"+ownerID+"','"+parentID+"','1',"+maxorder+")";
				stmt.executeUpdate(sql);
				conn.commit();
			}catch(Exception e){
				conn.rollback();
				e.printStackTrace();
				out.print("<script>alert('移动错误！');window.close();</script>");
			}finally{
				ConnectionProvider.close(conn, stmt, rs);
			}
			out.print("<script>window.close();</script>");
		}
	}
%>

<link rel="stylesheet" href="<%=request.getContextPath() %>/resources/template/cn/layui/css/layui.css" media="all" />
<form action="?" class="layui-main layui-form">
<input type="hidden" name="action" value="update">
<input type="hidden" name="ownerid" value="<%=ownerID%>">
<fieldset class="layui-elem-field" style="margin-top:20px">
  <div class="layui-field-box">
	  <div class="layui-form-item">
	  	<div class="layui-inline">
		    <label class="layui-form-label" style="color:red"><%=ownerName%></label>
		    <span class="layui-word-aux layui-text">移动到</span>
		</div>
		
	  	<div class="layui-inline">
		    <div class="layui-input-inline">
		      <input type="text" name="parentname" readonly lay-verify="yanzheng" placeholder="请点击选择" disabled autocomplete="off" class="layui-input">
		      <input type="hidden" name="parentid">
		    </div>
		    <input type="button" id="check" class="layui-btn layui-btn-normal layui-btn-xs" value="选择">
		</div>
		
	    <div class="layui-form-item">
		    <div class="layui-input-block">
		      <button class="layui-btn" lay-submit lay-filter="formDemo">立即提交</button>
		      <button type="reset" class="layui-btn layui-btn-primary">重置</button>
		    </div>
		  </div>
	  </div>
  </div>
</fieldset>
</form>
<script type="text/javascript" src="<%=request.getContextPath() %>/resources/js/jquery-1.11.0.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath() %>/resources/template/cn/layui/layui.js"></script>
<script type="text/javascript">
	var layer;
	layui.use(['form'], function() {
		var form = layui.form;
		layer = layui.layer;
		//监听提交
		form.on('submit(formDemo)', function(data){
		});
		$('#check').click(function(){
			openSelWin('<%=request.getContextPath()%>/address/tree.jsp?utype=2&sflag=0&count=1&fields=parentname,parentid');
		});
		
		form.verify({
			  yanzheng: function(value, item){ //value：表单的值、item：表单的DOM对象
			    if($('[name=parentid]').val() == ''){
			      return '请选择部门';
			    }
			    if($('[name=ownerid]').val() == $('[name=parentid]').val()){
			      return '被移动部门不能喝目标部门相同!';
			    }
			  }
			  
		});
	});
</script>
<script type="text/javascript" src="<%=request.getContextPath() %>/resources/template/cn/layui/layerFunction.js"></script>