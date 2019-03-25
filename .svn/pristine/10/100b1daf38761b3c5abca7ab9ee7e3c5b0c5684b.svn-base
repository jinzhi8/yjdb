<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.workflow.Flow" %>
<%@page import="com.kizsoft.commons.workflow.dao.FlowDAO" %>
<%@page import="java.util.ArrayList" %>
<%@page import="com.kizsoft.commons.acl.ACLManager" %>
<%@page import="com.kizsoft.commons.acl.ACLManagerFactory" %>
<%@page import="com.kizsoft.commons.component.entity.FieldEntity" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Date" %>
<%@page import="java.util.List" %>
<%@page import="java.util.Map" %>
<%@page import="java.util.HashMap" %>
<%@page import="com.kizsoft.commons.commons.db.ConnectionProvider" %>
<%@page import="java.sql.Connection" %>
<%@page import="java.sql.PreparedStatement" %>
<%@page import="java.sql.ResultSet" %>
<%@page import="com.kizsoft.commons.commons.orm.SimpleORMUtils"%>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<%@taglib prefix="html" uri="/WEB-INF/oa-html.tld" %>
<%@taglib prefix="oa" uri="/WEB-INF/oa.tld" %>
<html>
<head>
<%
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
	}
	User userInfo = (User) session.getAttribute("userInfo");
	String userID = userInfo.getUserId();
	String userName = userInfo.getUsername();

	String templatename = (String) session.getAttribute("templatename");
    String template = "/resources/template/" + templatename + "/template.jsp";
	String unid=request.getParameter("unid");

	SimpleORMUtils instance=SimpleORMUtils.getInstance();
    List<Map<String,Object>> list=instance.queryForMap("select * from ZWDB where unid=?",unid);
    Object hy="";
    if(list.size()!=0){
        Map<String,Object> map=list.get(0);
        hy=map.get("hy");
	}

	List<Map<String,Object>> messageList=instance.queryForMap("select * from ZWDB_MESSAGE where userid=?",userID);
	Map<String,Object> map;

	List<Map<String,Object>> yyList=instance.queryForMap("select * from ZWDB_DXYY where dbid=? order by time desc",unid);
	String name="";
	String phone="";
	String content="";
	if(yyList.size()!=0){
		Map<String,Object> yMap=yyList.get(0);
		name=(String)yMap.get("name");
		phone=(String)yMap.get("phone");
		content=(String)yMap.get("content");
	}


%>
<template:insert template="<%=template%>">
<template:put name='title' content='县领导批示督办' direct='true'/>
<% String str = "短信催办";%>
<template:put name='moduleNav' content='<%=str%>' direct='true'/>
<template:put name='content'>
<!-- <script type="text/javascript" src="../js/json2.js"></script>-->
<script language="JavaScript" src="<%=request.getContextPath()%>/resources/js/jquery/jquery.js" type="text/javascript"></script>
<link rel="stylesheet" href="<%=request.getContextPath()%>/js/layui/css/layui.css"  media="all">
<script type="text/javascript" src="<%=request.getContextPath()%>/js/layer/layer.js" ></script>
<style type="text/css">

body{
	font-family: Arial, Helvetica, sans-serif;
	font-size:12px;
	color:#666666;
	background:#fff;
    font-family: SimHei;
	text-align:center;

}
	fieldset {
	padding:10px;
	margin-top:5px;
	border:1px solid #1E7ACE;
	background:#fff;
}
fieldset legend {
	color:#1E7ACE;
	font-weight:bold;
	padding:3px 20px 3px 20px;
	border:1px solid #1E7ACE;	
	background:#fff;
}
.zt {
    cornerRadius: 12;
    font-weight: bold;
}
.prompt_divs{
	color: red;
    font-size: 14px;
    font-family: SimHei;
    margin: 10px 0px;
    text-indent: 10px;
}
.table_tcs{
	border:1px solid #1E7ACE;
}
.three_radios{
	padding-top: 12px;
}
</style>
</head>
<body bgcolor="#e0e0e0">
<table width="97%" align="center" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<fieldset style="width:98%;padding:1px">
				<legend>
					<b style="font-size:14px">短信催办:</b>
				</legend>
				<form style="padding:0px">
					<table border="0" align="center" width="80%" style="text-align: center" class="table_tcs"> 
						<tr valign="top">
							<td width="100px" VALIGN="middle" class="deeptd">
			                    <div align="center" class="zt">办理人员：</div>
			                </td>
							<td class="tinttd" width="400px">
			                    <html:text name="lxr" value="<%=name%>" style="width:80%"/> &nbsp;
 		             			<img style="cursor:default;" title="点击选择处理人" src="<%=request.getContextPath()%>/resources/images/actn133.gif" onclick="openSelWin('<%=request.getContextPath()%>/address/tree_ry.jsp?utype=1&sflag=0&count=1&fields=lxr,lxr_id');peopleChange();">
			                    <html:hidden name="lxr_id"/>
			                </td>
						</tr>
						<tr VALIGN=top>
			                <td width="100px" VALIGN="middle" class="deeptd">
			                    <div align="center" class="zt">手机号码：</div>
			                </td>
			                <td class="tinttd" width="400px">
			                    <html:text name="lxdh" value="<%=phone%>" />
			                </td>
			            </tr>
			            <tr valign="top">
							<TD WIDTH="100px" VALIGN=middle class="deeptd">
								<DIV ALIGN=center><strong>催办内容</strong><!--<font color="red">*</font>--></DIV>
							</TD>
							<TD  class="tinttd" width="400px">
								    <span style="position:absolute;border:1pt solid #c1c1c1;overflow:hidden;width:308px;height:22px;clip:rect(-1px 310px 310px 290px);    margin-top: -10px;">
									 <select name="aabb3" id="aabb3" style="width:310px;height:22px;margin:-2px;" onChange="javascript:document.getElementById('dbmessage').value=document.getElementById('aabb3').options[document.getElementById('aabb3').selectedIndex].value;">
									 <option value="" style="color:#c2c2c2;">---请选择催办内容---</option>
									 <%for(int i=0;i<messageList.size();i++){
									     map=messageList.get(i);
									     for(int j=i+1;j<messageList.size();j++){
									        if(messageList.get(i).get("dbmessage").equals(messageList.get(j).get("dbmessage")))
									        {break;}
									        if(j==messageList.size()-1){%>
					                        <option value="<%=map.get("dbmessage")%>"><%=map.get("dbmessage")%></option>              
									        <%}}} if(messageList.size()>0){%>
					                        <option value="<%=messageList.get(messageList.size()-1).get("dbmessage")%>"><%=messageList.get(list.size()-1).get("dbmessage")%></option>
					                        <%}%>
									 </select>
									 </select>
									 </span>
									 <span style="position:absolute;border-top:1pt solid #c1c1c1;border-left:1pt solid #c1c1c1;border-bottom:1pt solid #c1c1c1;width:290px;height:19px;    margin-top: -10px;">
									 <input type="text" name="require" id="dbmessage" value="<%=content%>"  style="width:290px;height:18px;line-height: 19px;border: 0pt;outline: none;">
									 </span>
					                
							</TD>
			            </tr> 

			            <div class="prompt_divs">提示：如对方不在通讯录内，请直接输入对方手机长号,并用英文逗号隔开</div>	
            <tr align="center" style="text-align: center">
                <td colspan="3" class="three_radios">
                	<input type="radio" checked name="check" value="1" title="选择/不选择">反馈日前1天
                	<input type="radio" name="check" value="3" title="选择/不选择">反馈日前3天
                	<input type="radio" name="check" value="7" title="选择/不选择">反馈日前7天	
				</td>
            </tr>
            <tr height="50px" align="center" style="text-align: center" name="formName">
                <td colspan="3" > 
                   <input type="button" value="短信预约" class="layui-btn layui-btn-xs" onclick="messageYy();">   
                   <input type="button" value="短信发送" onclick="peopleAddDel();" class="layui-btn layui-btn-xs"> 
                   <input type="button" value="保存当前催办内容" onclick="insertMessage();" class="layui-btn layui-btn-xs">  
				</td>
            </tr>
		</table>
	</form>
	</fieldset>
</td>
</tr>
</table>
<table width="99%" border="0" align="center" cellpadding="0" cellspacing="0" class="table">
		<tr VALIGN=top>
			<td class="tinttd" colspan="4">
				
			</td>
		</tr>	
	<%for(int i=0;i<yyList.size();i++){   //反馈评估信息
			Map<String,Object> yymap =yyList.get(i);
	%>
		<tr VALIGN=top>
			<td width="100px" VALIGN=middle class="deeptd">
                <div align="center">预约人</div>
            </td>
            <td class="tinttd" style="width:400px">
                <%=yymap.get("username")%>
            </td>
            <td width="100px" VALIGN="middle" class="deeptd">
			<div align="center">预约时间</div>
			</td>
			<td class="tinttd" style="width:400px">
				<%=yymap.get("time")%>
			</td>
        </tr>
		<tr VALIGN=top>
			<td width="100px" VALIGN="middle" class="deeptd">
				<div align="center">办理人员</div>
			</td>
			<td class="tinttd" style="width:400px">
				<%=yymap.get("name")%>(<%=yymap.get("phone")%>)
			</td>
			<td width="100px" VALIGN="middle" class="deeptd">
			<div align="center">反馈日前</div>
			</td>
			<td class="tinttd" style="width:400px">
				<%=yymap.get("state")%>天
			</td>
		</tr>
		<tr VALIGN=top>
			<td width="100px" VALIGN="middle" class="deeptd">
				<div align="center">催办内容</div>
			</td>
			<td class="tinttd" colspan="3">
				<%=yymap.get("content")%>
			</td>
		</tr>	
		<tr VALIGN=top>
			<td class="tinttd" colspan="4">
				
			</td>
		</tr>	
	<%}%>
</table>
</body>
</html>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/json2.js"></script>
<script type="text/javascript">
		function messageYy(){
	       /*	var check1 ={check0:0,check1:0,check2:0}; 
	       	var cek=$('[name="check"]');
	       	for (var i = 0; i < cek.length; i++) {  		
	       		if(cek[i].checked){
	       			eval("check1.check"+i+"=1");
	       			//eval("check"+i+"=true");
	       		}
	       	};*/
			//alert(check1.length==0 ?'你还没有选择任何内容！':check1); 
			var check = $('input:radio[name="check"]:checked').val();
			var lxdh=$('[name=lxdh]').val();
			if(lxdh.indexOf("null") != -1){
				alert('该办理人员手机号码不存在!');
				return false;
			}
			if(lxdh==""){
				alert('请输入手机号码!');
				return false;
			}
			var require = $('[name=require]').val();
			if(require==""){
				alert('请输入催办内容!');
				return false;
			}
			var lxr=$('[name=lxr]').val();
			var unid="<%=unid%>";
	        $.ajax({
	            async: true,
	            type: "POST",
	            url: "<%=request.getContextPath()%>/zwdbfk/insertMessage.jsp",
	            cache: false,
	            dataType: 'html',
	            data: {
	                check:check,
	                lxr:lxr,
	                lxdh:lxdh,
	                require:require,
	                unid:unid,
	                status:"2"
	            },
	            success: function (data) {
	               	  alert("预约成功，到期会自动发送！");
					  window.parent.location.reload();
				  	  var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
				  	  window.parent.layer.close(index);
	               
	            }
	        });
		}
function peopleAddDel(){
	var lxdh=$('[name=lxdh]').val();
	if(lxdh.indexOf("null") != -1){
		alert('该办理人员手机号码不存在!');
		return false;
	}
	var require = $('[name=require]').val();
	if(require==""){
		alert('请输入催办内容!');
		return false;
	}
	var lxr=$('[name=lxr]').val();
		$.ajax({ 
                async: true, 
                type : "POST", 
                url : "<%=request.getContextPath()%>/zwdbfk/sendMessage.jsp",
                cache: false,                        
                data : {
                	lxdh : lxdh,
                	require : require,
                	lxr:lxr
            },
            success:function(data){
            	alert("短信发送成功！");
            	window.parent.location.reload();
				var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
				window.parent.layer.close(index);
            }
        });
}
	function peopleChange(){
	        var ids=$("[name=lxr_id]").val();
	        $.ajax({
	            async: true,
	            type: "POST",
	            url: "<%=request.getContextPath()%>/zwdbfk/action.jsp",
	            cache: false,
	            dataType: 'html',
	            data: {
	                ids:ids
	            },
	            success: function (data) {
	                $("[name=lxdh]").val(trim(data.split(":")[1])); 
	            }
	        });
	}
	function insertMessage(){
	        var require=$("[name=require]").val();
	        if(require==""){
				alert('请输入催办内容!');
				return false;
			}
	        $.ajax({
	            async: true,
	            type: "POST",
	            url: "<%=request.getContextPath()%>/zwdbfk/insertMessage.jsp",
	            cache: false,
	            dataType: 'html',
	            data: {
	                require:require,
	                status:"1"
	            },
	            success: function (data) {
	                alert("保存成功");
	            }
	        });
	}
    function trim(str){ //删除左右两端的空格
        if(str==''){
            return '';
        }
　　     return str.replace(/(^\s*)|(\s*$)/g, "");
　　} 
</script>
</template:put>
</template:insert>