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
	
	String unid=request.getParameter("unid");
	SimpleORMUtils instance=SimpleORMUtils.getInstance();
    List<Map<String,Object>> list=instance.queryForMap("select * from ZWDB where unid=?",unid);
    Object hy="";
    if(list.size()!=0){
        Map<String,Object> map=list.get(0);
        hy=map.get("hy");
	}

%>
<script type="text/javascript" src="../js/json2.js"></script>
<script language="JavaScript" src="<%=request.getContextPath()%>/resources/js/jquery/jquery.js" type="text/javascript"></script>
<style type="text/css">

body {
	font-family: Arial, Helvetica, sans-serif;
	font-size:12px;
	color:#666666;
	background:#fff;
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

</style>
</head>
<body bgcolor="#e0e0e0">
<table width="97%" align="center" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<fieldset style="width:98%;padding:1px">
				<legend>
					<b style="font-size:14px">赋文号:</b>
				</legend>
				<form style="padding:0px">
					<table border="0" align="center" width="80%" style="text-align: center"> 
						<tr valign="top">
							<td>
								<%if(hy.equals("会议")){%>
								<b>文会督〔</b>
								<%}else{%>
								<b>文批督〔</b>
								<%}%>
							</td>
							<td>
							    <input type="text" name="year" style="width:60px;" >
							</td>
							<td>
								<b>〕</b>
							</td>	
							<td>
								<input type="text" name="num"  style="width:60px;"   />
							</td>
							<td>
								<b>号</b>	
							</td>
							<%if(hy.equals("会议")){%>
							<td>
								<input type="text" name="js"  style="width:60px;"   />
							</td>
							<td>
								<b>事项</b>	
							</td>
							<%}%>
						</tr>
						<br/>
						<br/>	
			            <tr height="50px" align="center" style="text-align: center">
			                <td colspan="3" >    
			                   <input type="button" value="确定" onclick="peopleAddDel();">  
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
<script type="text/javascript">
function peopleAddDel(){
	var year=$('[name=year]').val();
	var num=$('[name=num]').val();
	var js = $('[name=js]').val();
	var unid="<%=unid%>";
		$.ajax({ 
                async: true, 
                type : "POST", 
                url : "<%=request.getContextPath()%>/zwdbfk/ajax.jsp",
                cache: false,                        
                data : {
                	year : year,
                	num : num,
                	js : js,
                	unid :unid
            },
            success:function(data){
                data=data.replace(/^(\s|\xA0)+|(\s|\xA0)+$/g, '');
                if(data=='ok'){
                	window.parent.returnValue = 1;  
					window.close(); 
                }
            }
        });
}
</script>