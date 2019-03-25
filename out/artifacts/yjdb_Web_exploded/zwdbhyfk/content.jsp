<%@ page language="java" contentType="text/html;charset=utf-8" %>

<%@page import="java.sql.Connection" %>
<%@page import="java.sql.PreparedStatement" %>
<%@page import="java.sql.ResultSet" %>
<%@page import="com.kizsoft.commons.commons.db.ConnectionProvider" %>   
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.component.entity.FieldEntity" %>
<%@page import="com.kizsoft.commons.uum.pojo.Owner" %>
<%@page import="com.kizsoft.commons.uum.service.IUUMService" %>
<%@page import="com.kizsoft.commons.uum.utils.UUMContend" %>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.text.ParseException"%>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<%@taglib prefix="html" uri="/WEB-INF/oa-html.tld" %>
<%@taglib prefix="oa" uri="/WEB-INF/oa.tld" %>
<%@page import="com.kizsoft.commons.util.UUIDGenerator" %>
<%
    String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
    User userInfo = (User) session.getAttribute("userInfo");
    if (userInfo == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    } 
    String templatename = (String) session.getAttribute("templatename");
    String template = "/resources/template/" + templatename + "/template.jsp";

    String userID = userInfo.getUserId();
    Group groupInfo = userInfo.getGroup();
    String groupID = groupInfo.getGroupId();
    String userName = userInfo.getUsername();
    String depName = groupInfo.getGroupname();
    String doccUNID = (String) ((FieldEntity) request.getAttribute("unid")).getValue();
    String isNewDoc = (doccUNID == null || "".equals(doccUNID)) ? "0" : "1";
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String nowtime=sdf.format(new Date());
		
	String depid=getAttr(request,"depid",groupID);
	String depname=getAttr(request,"depname",depName);
	String userid=getAttr(request,"userid",userID);
	String username=getAttr(request,"username",userName);
	String issuetime=getAttr(request,"issuetime",nowtime);
	String qftime=getAttr(request,"qftime",nowtime);
	String jstime=getAttr(request,"jstime","");
	String fkzq=getAttr(request,"fkzq","");	
	String issueflag=getAttr(request,"issueflag","0");
	String isjs=getAttr(request,"isjs");

    String docUNID=UUIDGenerator.getUUID();
	int count=0;
    String cgsqid="";
    cgsqid=getAttr(request,"unid");	
%>


<%!
    public String Trim(String strIn){
        if(strIn==null||strIn==""){
            return "";
        }else{
            return strIn;
        }
    //  return strIn.replace(/(^\s*)|(\s*$)/g,"");
    }
    public String viewEquips(String uuid,String docUNID){

                Connection db = null;
                PreparedStatement stat = null;
                ResultSet rs=null;

                String sql="";
                int count=1;
                StringBuffer bf=new StringBuffer();
                try{
                    sql="select * from ZWDB where docunid=?";
                    
                    db = ConnectionProvider.getConnection();
                    stat = db.prepareStatement(sql);
                    stat.setString(1,uuid);
                    rs=stat.executeQuery();
                    while(rs.next()){   
                        String unid=Trim(rs.getString("unid"));                  
                        String qfman=Trim(rs.getString("qfman"));
                        String leadername=Trim(rs.getString("leadername"));
                        String title=rs.getString("title");
                        Date jbsx=rs.getDate("jbsx");
                        Date qftime=rs.getDate("qftime");
                         
                        bf.append("<tr ALIGN=top id=\""+unid+"\"><td ALIGN=center>"+qfman+"</td><td ALIGN=center>"+leadername+"</td><td ALIGN=center>"+title+"</td><td ALIGN=center>"+jbsx+"</td><td ALIGN=center>"+qftime+"</td><td ALIGN=center><input type=\"button\" value='编 辑' onclick=\"openNew('"+unid+"','"+docUNID+"');\"/></td></tr>");
                        count++;
                    }
            }catch(Exception e){
            }finally{
                    ConnectionProvider.close(db,stat,rs);
            }
            return bf.toString();
    }
	public String getAttr(HttpServletRequest request,String name){
		return getAttr(request,name,"");
	}

	public String getAttr(HttpServletRequest request,String name,String replace){
		String temp=replace;
		FieldEntity tempentity = (FieldEntity) request.getAttribute(name);
		if (tempentity == null || tempentity.getValue() == null || "".equals(tempentity.getValue())) {
		} else {
			temp = (String) tempentity.getValue();
		}
		return temp;
	}
%>



<template:insert template="<%=template%>">
<template:put name='title' content='会议件督办' direct='true'/>
<% String str = "<a class=\"menucur\" href=\"zwdbhyfk\">会议件督办</a>";%>
<template:put name='moduleNav' content='<%=str%>' direct='true'/>
<template:put name='content'>
<script>
	function validateForm() {
		if (document.all.title.value == "") {
			alert("基本信息不完整,请填写!");
			return false;
		}
		
		var leaderid=$("[name=leaderid]").val();
		if(leaderid==''){
			alert("请选择牵头领导!");
			return false;
		}
		
		var jbsx=$("[name=jbsx]").val();
		if(jbsx==''){
			alert("请选择交办时限!");
			return false;
		}
		
		var managedepid=$("[name=managedepid]").val();
		if(managedepid==''){
			alert("请选择牵头单位!");
			return false;
		}
		
		
		
		var fklx=$("[name=fklx]").val();
		if(fklx=='定期'){
			$("[name=fkzq]").val("");
		}else{
			var fkzq= $("[name=fkzq]").val();
			if(fkzq==''){
				alert("请选择反馈周期!");
				return false;
			}
		}
		
		return true;
	}
	
	function fkchange(){
		var fklx=$("[name=fklx]").val();
		if(fklx=='定期'){
			$("#hide_show").css("display","none");
			$("[name=fkzq]").val("");
		}else{
			$("#hide_show").css("display","block");
		}
	}

    function remove(count){
            trId="deletebutton"+count;
            $("#"+trId).remove();
        }
        function deleteinput(){
            var count=$("[name='count']").val();
            count--;
            var equipmentname="equipmentname"+count;
            var equipunid="equipunid"+count;

            $.post("<%=request.getContextPath()%>/cgsq/operatorcgsq.jsp",{"type":"delequip","equipunid":$("[name="+equipunid+"]").val()},function(data){
                        data=Trim(data);
            });
            $("#"+equipmentname).remove();
            
            $("[name='count']").val(count);
            count--;
            var addequip="equipmentname"+count;
            var deletebutton="deletebutton"+count;
            $("#"+addequip).append("<td ALIGN=center id=\""+deletebutton+"\"><input type=\"button\" value='删  除' onclick='deleteinput()'/></td>");
        
        }
        function openNew(zunid,docunid)
            {
                var width = 800;
                var height = 500;
                //var iTop = (window.screen.availHeight - 30 - width) / 2;
                //var iLeft = (window.screen.availWidth - 10 - height) / 2;
                var iTop = (window.screen.availHeight - height ) / 2;
                var iLeft = (window.screen.availWidth - width) / 2 + 90;
                var win = window.open("<%=request.getContextPath()%>/zwdbhyfk/openContent.jsp?unid="+zunid+"&docunid=<%=docUNID%>", "弹出窗口", "width=" + width + ", height=" + height + ",top=" + iTop + ",left=" + iLeft + ",toolbar=no, menubar=no, scrollbars=yes, resizable=no,location=no, status=no,alwaysRaised=yes,depended=yes");
            }
        function updatecallfun(ret_val){
                //var json=JSON.parse(data);
                //alert('updatecallfun');
                var unid=ret_val[0].unid;
                var leadername=ret_val[0].leadername;
                var title=ret_val[0].title;
                var jbsx=ret_val[0].jbsx;
                var qftime=ret_val[0].qftime;
                var qfman=ret_val[0].qfman;
                var docunid="<%=docUNID%>";
                var count=$("[name='count']").val();
                //document.getElementById(unid).removeNode();
                $("#"+unid).html("<tr ALIGN=top id=\""+unid+"\"><td ALIGN=center>"+qfman+"</td><td ALIGN=center>"+leadername+"</td><td ALIGN=center>"+title+"</td><td ALIGN=center>"+jbsx+"</td><td ALIGN=center>"+qftime+"</td><td ALIGN=center><input type=\"button\" value='编 辑' onclick=\"openNew('"+unid+"','"+docunid+"');\"/></td></tr>");
                //alert('updatecallfunend');
        }
        function callfun(ret_val){
            //var json=JSON.parse(data);
                var count=$("[name='count']").val();
                var unid=ret_val[0].unid;
                var leadername=ret_val[0].leadername;
                var title=ret_val[0].title;
                var jbsx=ret_val[0].jbsx;
                var qftime=ret_val[0].qftime;
                var qfman=ret_val[0].qfman;
                var docunid="<%=docUNID%>";
                $("#mytable").append("<tr ALIGN=top id=\""+unid+"\"><td ALIGN=center>"+qfman+"</td><td ALIGN=center>"+leadername+"</td><td ALIGN=center>"+title+"</td><td ALIGN=center>"+jbsx+"</td><td ALIGN=center>"+qftime+"</td><td ALIGN=center><input type=\"button\" value='编 辑' onclick=\"openNew('"+unid+"','"+docunid+"');\"/></td></tr>");

                $("[name='count']").val(++count);                
        }

        function isjsls(){
        $("[name=isjs]").val('2');
    }
    function insertRange(){
    var unid="<%=doccUNID%>";
        $.ajax({ 
                async: true, 
                type : "POST", 
                url : "<%=request.getContextPath()%>/zw_hydb/rangeInsert.jsp?",
                cache: false,                      
                data : {
                    unid:unid   
            },
            success:function(data){               
            }
        });
    }   		
</script>
<form action="<%=request.getContextPath()%>/save" method="post" enctype="multipart/form-data" onSubmit="return validateContext();">
    <input type="hidden" name="xmlName" value="zwdbhyfk">
    <input type="hidden" name="xmlType" value="<%=(String) request.getAttribute("xmlType")%>">
    <input type="hidden" name="moduleId" value="zwdbhyfk">
    <html:hidden name="unid"/>
    <html:hidden name="depid" value="<%=depid%>"/>
    <html:hidden name="depname" value="<%=depname%>"/>
    <html:hidden name="issueflag" value="<%=docUNID%>"/>
    <html:hidden name="userid" value="<%=userid%>"/>
    <html:hidden name="username" value="<%=username%>"/>
    <html:hidden name="issuetime" value="<%=issuetime%>"/>
    <html:hidden name="isjs" value="<%=isjs%>"/>
	<html:hidden name="jstime" value="<%=jstime%>"/>
    <table border="0" align="center" cellpadding="0" cellspacing="0" class="round">
        <tr>
            <td class="title">
                <div align=center>文成县人民政府领导会议督办单</div>
            </td>
        </tr>
        <!-- <tr>
            <td>
                <div align="right">
                    会议立项编〔<html:text name="year" style="width:60px"/>〕<html:text name="num" style="width:50px"/>号
                </div>
            </td>
        </tr> -->
        <tr>
         <td>    
        <table id="baseinfo" width="99%" border="0" align="center" cellpadding="0" cellspacing="0" class="table">
            <tr VALIGN=top>
                <td width="80px" VALIGN="middle" class="deeptd">
                    <div align="center">会议名称</div>
                </td>
                <td class="tinttd" colspan="3">
                    <html:text name="title"/>
                </td>
            </tr> 
            <tr valign="top">
                <td width="80px" VALIGN=middle class="deeptd">
                    <div align="center">部署县长</div>
                </td>
                <td class="tinttd" >
                    <html:textarea name="leadername" style="width:35%" readonly="true" /> &nbsp;
                    <img src="<%=request.getContextPath()%>/resources/images/actn133.gif" onclick="window.showModalDialog('<%=request.getContextPath()%>/address/tree.jsp?utype=1&sflag=0&count=1&activid=2c90b371078d506501078d955ae50004&fields=leadername,leaderid',window,'status:no;dialogWidth:300px;dialogHeight:380px;scroll:no;help:no;')">
                    <html:textarea name="leaderid" style="display:none"/> 
                </td>
                <td width="80px" VALIGN=middle class="deeptd">
                    <div align="center">会议时间</div>
                </td>
                <td class="tinttd" style="width:40%">
                    <html:text name="qftime" readonly="true" styleClass="Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'});" style="width:40%"/>
                </td>
            </tr>
             <tr valign="top">
                <td width="80px" VALIGN=middle class="deeptd">
                    <div align="center">会议类型</div>
                </td>
                <td class="tinttd" >
                    <html:select name = "source" style="width:150px">
                        <html:option value = "区长例会">区长例会</html:option>
                        <html:option value = "区政府全体会议">区政府全体会议</html:option>
                        <html:option value = "区政府常务会议">区政府常务会议</html:option>
                        <html:option value = "区长办公会议">区长办公会议</html:option>
                        <html:option value = "区长（主任）例会">区长（主任）例会</html:option>
                        <html:option value = "区政府专题会议">区政府专题会议</html:option>
                        <html:option value = "其他">其他</html:option>
                    </html:select>
                </td>
                <td width="80px" VALIGN=middle class="deeptd">
                    <div align="center">是否办结</div>
                </td>
                <td class="tinttd" >
                    <html:select name = "qfman" style="width:150px">
                       <html:option value = "未办结">未办结</html:option>
                            <html:option value = "办结">办结</html:option>
                            <html:option value = "未办结">未办结</html:option>
                    </html:select>
                </td>
            </tr>    
            <tr valign="top">
                <td class="deeptd" width="100px">
                    <div align="center">附&nbsp;&nbsp;&nbsp;&nbsp;件</div>
                </td>
                <td class="tinttd" colspan="3">
                    <html:file name="attachment"/>
                    <html:attachment moduleid="zw_hydb" unid="unid" type="attachment"/>
                    <html:attachment moduleid="zwdbhyfk" unid="unid" type="attachment"/>
                </td>
            </tr>
            <tr valign="top">
                <td class="deeptd" width="100px">
                    <div align="center">会议议程</div>
                </td>
                <td class="tinttd" colspan="3">
                    <html:textarea name="require" style="height:120px"/>
                </td>
            </tr>  
        </table>
        <table width="100%" id="mytable" class="round" cellpadding="0" cellspacing="0">
            <tr VALIGN=top>
                <td WIDTH="10%" class="deeptd"><DIV ALIGN=center><font color="#FF0000" size="1">*</font>是否办结</DIV></td>
                <td WIDTH="10%" class="deeptd"><DIV ALIGN=center><font color="#FF0000" size="1">*</font>牵头领导</DIV></td>
                <td WIDTH="40%" class="deeptd"><DIV ALIGN=center><font color="#FF0000" size="1">*</font>督办事项</DIV></td>
                <td WIDTH="15%" class="deeptd"><DIV ALIGN=center><font color="#FF0000" size="1">*</font>交办期限</DIV></td>
                <td WIDTH="15%" class="deeptd"><DIV ALIGN=center><font color="#FF0000" size="1">*</font>部署时间</DIV></td>
                <td WIDTH="10%" class="deeptd"><DIV ALIGN=center>操作</DIV></td>
                <input type="hidden" name="count" value="<%=count%>">
            </tr>
            <%=viewEquips(cgsqid,docUNID)%>           
        </table>    
       <!--  <table width="100%" border="0">
           <tr>
               <td><DIV ALIGN=center><input type="button" name="addContent" class="formbutton" id="addcontent" value="添  加" onclick="openNew('');"  /></DIV></td>  
           </tr>
       </table> -->
		<br/>            
       
        <tr>
            <td height="30">
                <DIV align="center">
                    <input type="submit" name="saveConent" class="formbutton" value="保  存" onclick="return validateForm();"/>
                    <input type="submit" name="delContent" class="formbutton" value="删  除" onclick="deletemin();document.all.xmlType.value='delete';return confirmDelete();"/>
                </DIV>
            </td>
        </tr>
    </table>
</form>
</template:put>
</template:insert>
<script>
    function deletemin(){
       var unid="<%=cgsqid%>";
        $.ajax({ 
                async: true, 
                type : "POST", 
                url : "<%=request.getContextPath()%>/zwdbhyfk/ajaxmin.jsp?",
                cache: false,                      
                data : {
                    unid:unid   
            },
            success:function(data){               
            }
        });
    }
</script>
