<%@page language="java" contentType="text/html;charset=UTF-8" %>

<%@page import="com.kizsoft.commons.commons.db.ConnectionProvider" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="java.sql.Connection" %>
<%@page import="java.sql.PreparedStatement" %>
<%@page import="java.sql.ResultSet" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<%
	String userTemplateName = (String) session.getAttribute("templatename");
	String userTemplateStr = "/resources/template/" + userTemplateName + "/template.jsp";
	if(userTemplateName==null||"".equals(userTemplateName)){
		userTemplateStr = "/resources/jsp/template.jsp";
	}
%>
<template:insert template="<%=userTemplateStr%>">
<template:put name='title' content='个人资料修改' direct='true'/>
<%String str = "<a class=\"menucur\" href=\"person_modify.jsp\">个人资料修改</a>";%>
<template:put name='moduleNav' content='<%=str%>' direct='true'/>
<template:put name='moduleNav' content='<%=str%>' direct='true'/>
<template:put name='content'>
<style type="text/css">
	.layui-form-label {
		width:100px;
	}
	.layui-input-block{
		margin-left:130px
	}
</style>
<%//用户登陆验证
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
	}
	User userInfo = (User) session.getAttribute("userInfo");
	String userID = userInfo.getUserId();


	Connection db = null;
	PreparedStatement stat = null;
	ResultSet rs = null;
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

	String saveFlag = request.getParameter("saveFlag");
	try {
		db = ConnectionProvider.getConnection();
		if (saveFlag != null) {
			if (saveFlag.equals("1")) //数据保存

			{   
				String getSex = request.getParameter("sex");
				String getBirthday = request.getParameter("birthday");
				getBirthday = (getBirthday==null||"".equals(getBirthday))?"null":"to_date('"+getBirthday+"','yyyy-MM-dd')";
				String getIP = request.getParameter("ip");
				String getPhone = request.getParameter("phone");
				String getPhoneShort = request.getParameter("phoneshort");
				String getHomePhone = request.getParameter("homephone");
				String getmobile = request.getParameter("mobile");
				String getPosition = request.getParameter("position");
				String getmobileshort = request.getParameter("mobileshort");
				String getFaxno = request.getParameter("faxno");
				String getEmail = request.getParameter("email");
				String getCardNO = request.getParameter("cardno");
				String getAddress = request.getParameter("address");
				String getEmail_user = request.getParameter("email_user");
				String getEmail_psd = request.getParameter("email_psd");
				String getRangeList_arr = request.getParameter("rangelist_arr");
				String getRangeIDList_arr = request.getParameter("rangeidlist_arr");
				String getownerName=request.getParameter("ownername");
				String sql = "select * from owner where id='" + userID + "'";
				try {
					stat = db.prepareStatement(sql);
					rs = stat.executeQuery();

					if (rs.next()) {
						sql = "update owner set phoneshort = '" + getPhoneShort + "',homephone = '" + getHomePhone + "',SEX = '" + getSex + "',BIRTHDAY = " + getBirthday + ",PHONE = '" + getPhone + "',mobile = '" + getmobile + "',mobileshort='"+getmobileshort+"',FAXNO = '" + getFaxno + "',EMAIL = '" + getEmail + "',CARDNO = '" + getCardNO + "',ADDRESS = '" + getAddress + "',position='"+getPosition+"',ip='"+getIP+"',ownername='"+getownerName+"' where ID = '" + userID + "'";
						stat = db.prepareStatement(sql);
						//System.out.println(sql);
						stat.executeUpdate();
						db.commit();
					}
				} catch (Exception e) {
					e.printStackTrace();
					try {
						db.rollback();
					} catch (Exception ex) {}
				}

				out.println("<script>window.location.href='" + request.getContextPath() + "/personalize/person_modify.jsp';</script>");
			}
		} else {
		    String ownercode="";
			String ip = "";
			String sex = "";
			String birthday = "";
			String phone = "";
			String phoneshort = "";
			String homephone = "";
			String position = "";
			String mobile = "";
			String mobileshort = "";
			String faxno = "";
			String email = "";
			String cardno = "";
			String address = "";
			String email_user = "";
			String email_psd = "";
			String rangelist_arr = "";
			String rangeidlist_arr = "";
            String ownername="";
			String sql = "select * from owner  where id='" + userID + "'";
			stat = db.prepareStatement(sql);
			rs = stat.executeQuery();
			String SeXFlag_1 = "";
			String SeXFlag_2 = "";
			if (rs.next()) //查到数据
			{   ownercode=rs.getString("ownercode");
				sex = rs.getString("SEX");
				if (sex == null) sex = "";
				if (sex.equals("1")) SeXFlag_1 = "checked";
				else SeXFlag_2 = "checked";
				birthday = rs.getDate("BIRTHDAY")==null?"":sdf.format(rs.getDate("BIRTHDAY"));
				if (birthday == null) birthday = "";
				ip = rs.getString("ip");
				if (ip == null) ip = "";
				phone = rs.getString("PHONE");
				if (phone == null) phone = "";
				phoneshort = rs.getString("PHONESHORT");
				if (phoneshort == null) phoneshort = "";
				homephone = rs.getString("HOMEPHONE");
				if (homephone == null) homephone = "";
				mobile = rs.getString("mobile");
				if (mobile == null) mobile = "";
				mobileshort = rs.getString("mobileshort");
				if (mobileshort == null) mobileshort = "";
				faxno = rs.getString("FAXNO");
				if (faxno == null) faxno = "";
				email = rs.getString("EMAIL");
				if (email == null) email = "";
				cardno = rs.getString("CARDNO");
				if (cardno == null) cardno = "";
				address = rs.getString("ADDRESS");
				if (address == null) address = "";
				position = rs.getString("POSITION");
				if (position == null) position = "";
				ownername = rs.getString("ownername");
				if (ownername  == null) ownername = "";
			}

%>
<div style="padding:10px">
<FORM class="layui-form" METHOD=POST ACTION="person_modify.jsp?saveFlag=1" name="thisform">
<blockquote class="layui-elem-quote">
	<span style="font-size:20px">个人资料修改</span>
</blockquote>
 <div class="layui-form-item">
    <label class="layui-form-label">用户名</label>
    <div class="layui-input-block">
      <input type="text" name="ownercode" value="<%=ownercode%>" placeholder="请输入用户名" required autocomplete="off" class="layui-input">
    </div>
  </div>

 <div class="layui-form-item">
 	<div class="layui-inline">
	   <label class="layui-form-label">性别</label>
	   <div class="layui-input-inline">
	     <input type="radio" name="sex" value="1" title="男" <%=SeXFlag_1%>>
		 <input type="radio" name="sex" value="0" title="女" <%=SeXFlag_2%>>
	   </div>
    </div>
 	<div class="layui-inline">
	   <label class="layui-form-label">出生年月</label>
	   <div class="layui-input-inline">
	   	<input type="text" class="layui-input" name="birthday" value="<%=birthday%>" placeholder="点击选择时间" required id="bir">
	   </div>
    </div>
  </div>
  	
 <div class="layui-form-item">
 	<div class="layui-inline">
	   <label class="layui-form-label">手机</label>
	   <div class="layui-input-inline">
	   <input type="text" name="mobile" value="<%=mobile%>" placeholder="请输入手机号" lay-verify="phone" autocomplete="off" class="layui-input">
	   </div>
    </div>
 	<div class="layui-inline">
	   <label class="layui-form-label">姓名</label>
	   <div class="layui-input-inline">
	   <input type="text" name="ownername" value="<%=ownername%>" placeholder="请输入姓名" required autocomplete="off" class="layui-input">
	   </div>
    </div>
  </div>	
  
 <div class="layui-form-item">
 	<div class="layui-inline">
	   <label class="layui-form-label">办公电话</label>
	   <div class="layui-input-inline">
	   <input type="text" name="phone" value="<%=phone%>" placeholder="请输入办公电话" required autocomplete="off" class="layui-input">
	   </div>
    </div>
 	<div class="layui-inline">
	   <label class="layui-form-label">办公电话短号</label>
	   <div class="layui-input-inline">
	   <input type="text" name="phoneshort" value="<%=phoneshort%>" placeholder="请输入办公电话短号" required autocomplete="off" class="layui-input">
	   </div>
    </div>
  </div>	
  
 <div class="layui-form-item">
 	<div class="layui-inline">
	   <label class="layui-form-label">办公传真</label>
	   <div class="layui-input-inline">
	   <input type="text" name="faxno" value="<%=faxno%>" placeholder="请输入办公传真" required autocomplete="off" class="layui-input">
	   </div>
    </div>
 	<div class="layui-inline">
	   <label class="layui-form-label">家庭电话</label>
	   <div class="layui-input-inline">
	   <input type="text" name="homephone" value="<%=homephone%>" placeholder="请输入家庭电话" required autocomplete="off" class="layui-input">
	   </div>
    </div>
  </div>	
  
 <div class="layui-form-item">
 	<div class="layui-inline">
	   <label class="layui-form-label">电子邮件</label>
	   <div class="layui-input-inline">
	   <input type="text" name="email" value="<%=email%>" placeholder="请输入电子邮件" lay-verify="email" autocomplete="off" class="layui-input">
	   </div>
    </div>
 	<div class="layui-inline">
	   <label class="layui-form-label">身份证号</label>
	   <div class="layui-input-inline">
	   <input type="text" name="cardno" value="<%=cardno%>" placeholder="请输入身份证号" lay-verify="identity" autocomplete="off" class="layui-input">
	   </div>
    </div>
  </div>
  	
 <div class="layui-form-item">
 	<div class="layui-inline">
	   <label class="layui-form-label">联系地址</label>
	   <div class="layui-input-inline">
	   <input type="text" name="address" value="<%=address%>" placeholder="请输入联系地址" required autocomplete="off" class="layui-input">
	   </div>
    </div>
 	<div class="layui-inline">
	   <label class="layui-form-label">虚拟网</label>
	   <div class="layui-input-inline">
	   <input type="text" name="mobileshort" value="<%=mobileshort%>" placeholder="请输入虚拟网" required autocomplete="off" class="layui-input">
	   </div>
    </div>
  </div>	
 <div class="layui-form-item">
	<label class="layui-form-label">职务</label>
	<div class="layui-input-block">
	<input type="text" name="position" value="<%=position%>" placeholder="请输入职务" required autocomplete="off" class="layui-input">
	</div>
  </div>	
 <div class="layui-form-item">
	<label class="layui-form-label">受信任IP</label>
	<div class="layui-input-inline">
	<input type="text" id="ip" name="ip" value="<%=ip%>" placeholder="请输入IP" required autocomplete="off" class="layui-input">
	</div>
	<span class="layui-word-aux">您当前登录的地址是</span>
	<span style="color:red"><%=request.getRemoteAddr()%></span>
	<input class="layui-btn layui-btn-xs" style="width:86px" value="设置为信任IP" type="button" onclick="$('#ip').val('<%=request.getRemoteAddr()%>')">
	<br>
	<span class="layui-word-aux">如果填写了受信任IP地址，则您在非受信任IP地址登陆，会发送短信到您的手机上。不填写，则不提醒。</span>
  </div>	
  <div class="layui-form-item">
    <div class="layui-input-block">
      <button class="layui-btn" lay-submit lay-filter="formDemo">立即提交</button>
      <button type="reset" class="layui-btn layui-btn-primary">重置</button>
    </div>
  </div> 
  </FORM>
</div>
<%}
} catch (Exception e) {
	out.print(e);
} finally {
	ConnectionProvider.close(db, stat, rs);
}%>
<script type="text/javascript">
	layui.use(['form','laydate'], function(){
		var form = layui.form,
		laydate = layui.laydate;
		
		//时间渲染
		laydate.render({
		   elem: '#bir'
		});
	});
</script>
</template:put>
</template:insert><!--索思奇智版权所有-->