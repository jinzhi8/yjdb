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
<%@page import="com.kizsoft.oa.wcoa.util.SimpleORMUtils"%>
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

	List<Map<String,Object>> yyList=instance.queryForMap("select * from ZWDB_DXYY ");
	Object one=yyList.get(0).get("one");
	Object three=yyList.get(0).get("three");
	Object serven=yyList.get(0).get("serven");

%>
<template:insert template="<%=template%>">
<template:put name='title' content='县领导批示督办' direct='true'/>
<% String str = "短信催办";%>
<template:put name='moduleNav' content='<%=str%>' direct='true'/>
<template:put name='content'>
<script type="text/javascript" src="../js/json2.js"></script>
<script language="JavaScript" src="<%=request.getContextPath()%>/resources/js/jquery/jquery.js" type="text/javascript"></script>
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
			                    <html:textarea name="lxr" style="width:80%"/> &nbsp;
			                    <img src="<%=request.getContextPath()%>/resources/images/actn133.gif" onclick="window.showModalDialog('<%=request.getContextPath()%>/address/tree.jsp?utype=3&sflag=0&count=0&activid=2c90b371078d506501078d955ae50004&fields=lxr,lxr_id',window,'status:no;dialogWidth:300px;dialogHeight:3100px;scroll:no;help:no;');peopleChange();">
			                    <html:hidden name="lxr_id"/>
			                </td>
						</tr>
						<tr VALIGN=top>
			                <td width="100px" VALIGN="middle" class="deeptd">
			                    <div align="center" class="zt">手机号码：</div>

			                </td>
			                <td class="tinttd" width="400px">
			                    <html:textarea name="lxdh" />
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
									 <input type="text" name="require" id="dbmessage"  style="width:290px;height:18px;line-height: 19px;border: 0pt;outline: none;">
									 </span>
					                
							</TD>
			            </tr> 

			            <div class="prompt_divs">提示：如对方不在通讯录内，请直接输入对方手机长号,并用英文逗号隔开</div>	
            <tr align="center" style="text-align: center">
                <td colspan="3" class="three_radios">
                <%if(one.equals("1")){%>
                	<input type="checkbox" name="check" checked="checked"  title="选择/不选择">反馈日前1天
                <%}else{%>
                	<input type="checkbox" name="check"  title="选择/不选择">反馈日前1天
                <%}if(three.equals("1")){%>
                	<input type="checkbox" name="check" checked="checked"  title="选择/不选择">反馈日前3天
                <%}else{%>
                	<input type="checkbox" name="check"  title="选择/不选择">反馈日前3天
                <%}if(serven.equals("1")){%>
                	<input type="checkbox" name="check" checked="checked"  title="选择/不选择">反馈日前7天
                <%}else{%>
                	<input type="checkbox" name="check"  title="选择/不选择">反馈日前7天
                <%}%>	
				</td>
            </tr>
            <tr height="50px" align="center" style="text-align: center" name="formName">
                <td colspan="3" > 
                   <input type="button" value="短信预约" onclick="messageYy();">   
                   <input type="button" value="短信发送" onclick="peopleAddDel();"> 
                   <input type="button" value="保存当前催办内容" onclick="insertMessage();">  
				</td>
            </tr>
        	
					</table>
				</form>
			</fieldset>
		</td>
	</tr>
</table>
</body>
</html>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/json2.js"></script>
<script type="text/javascript">
		function messageYy(){
	       	var check1 ={check0:0,check1:0,check2:0}; 
	       	var cek=$('[name="check"]');
	       	for (var i = 0; i < cek.length; i++) {  		
	       		if(cek[i].checked){
	       			eval("check1.check"+i+"=1");
	       			//eval("check"+i+"=true");
	       		}
	       	};
			//alert(check1.length==0 ?'你还没有选择任何内容！':check1); 
	        $.ajax({
	            async: true,
	            type: "POST",
	            url: "<%=request.getContextPath()%>/zwdbfk/insertMessage.jsp",
	            cache: false,
	            dataType: 'html',
	            data: {
	                check1:JSON.stringify(check1),
	                status:"2"
	            },
	            success: function (data) {
	                alert("预约成功");
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
                data=data.replace(/^(\s|\xA0)+|(\s|\xA0)+$/g, '');
                if(data=='000000'){
                    alert("催办成功！");
                    window.close();
                }else{
                	alert("短信发送失败");
                }
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