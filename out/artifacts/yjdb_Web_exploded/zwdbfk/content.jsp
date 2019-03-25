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
    String docUNID = (String) ((FieldEntity) request.getAttribute("unid")).getValue();
    String isNewDoc = (docUNID == null || "".equals(docUNID)) ? "0" : "1";
	String taskid = request.getParameter("taskid");
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
	String nowtime=sdf.format(new Date());

	String depid=getAttr(request,"depid",groupID);
	String depname=getAttr(request,"depname",depName);
	String userid=getAttr(request,"userid",userID);
	String username=getAttr(request,"username",userName);
	String issuetime=getAttr(request,"issuetime",nowtime);
	String qfmanid=getAttr(request,"qfmanid",userID);
	String qftime=getAttr(request,"qftime",nowtime);

	String fkzq=getAttr(request,"fkzq","");
    String fklx=getAttr(request,"fklx","");
    String qfman=getAttr(request,"qfman","");
	String managedepname=getAttr(request,"managedepname","");
    String managedepid=getAttr(request,"managedepid","");

	String issueflag=getAttr(request,"issueflag","0");
	String isjs=getAttr(request,"isjs");
    String num=getAttr(request,"num");
    String year=getAttr(request,"year");
    SimpleDateFormat sdfp=new SimpleDateFormat("yyyy-MM-dd");
    String docunid=getAttr(request,"docunid","");
    String hy=getAttr(request,"hy","");

	if(!issuetime.equals("")&&!qftime.equals("")){
    qftime=sdfp.format(sdfp.parse(qftime));
    issuetime=sdfp.format(sdfp.parse(issuetime));
    }
    String titlename="永嘉县人民政府领导批示督办单";
    String href="zwdbfk";
	String atitle="批示督办";
	if(hy.equals("会议")){
        atitle="会议督办";
        href="zwdbhyfk";
        titlename="永嘉县人民政府领导会议督办单";
    }
%>


<%!

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
<template:put name='title' content='<%=atitle%>' direct='true'/>
<% String str = "<a class=\"menucur\" href=\""+href+"\">"+atitle+"</a>";%>
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
    function isjsls(){
        $("[name=isjs]").val('2');
    }
	
	function fkchange(){
		var fklx=$("[name=fklx]").val();
		if(fklx=='一次性反馈'){
			$("#hide_show").css("display","none");
			$("[name=fkzq]").val("");
		}else{
			$("#hide_show").css("display","block");
		}
	}
	function insertRange(){
    var unid="<%=docUNID%>";
        $.ajax({ 
                async: true, 
                type : "POST", 
                url : "<%=request.getContextPath()%>/zwdb/rangeInsert.jsp?",
                cache: false,                      
                data : {
                    unid:unid   
            },
            success:function(data){               
            }
        });
    }
    function changeCopyDepName(){
        var ids=$("[name=copytoid]").val();
        $.ajax({
            async: true,
            type: "POST",
            url: "<%=request.getContextPath()%>/getshou/action.jsp",
            cache: false,
            dataType: 'html',
            data: {
                ids:ids
            },
            success: function (data) {
                data=trim(data);
                $("[name=copyto]").val(data);  
            }
        });
    }
function trim(str){ //删除左右两端的空格
        if(str==''){
            return '';
        }
　　    return str.replace(/(^\s*)|(\s*$)/g, "");
　　} 

    function peopleChange(){
        var ids=$("[name=lxr_id]").val();
        $.ajax({
            async: true,
            type: "POST",
            url: "<%=request.getContextPath()%>/zwdbfk/hmaction.jsp",
            cache: false,
            dataType: 'html',
            data: {
                ids:ids
            },
            success: function (data) {
                $("[name=czhm]").val(trim(data.split(":")[0])); 
                $("[name=lxdh]").val(trim(data.split(":")[1])); 
            }
        });
    }
    String.prototype.trim = function () {
        return this .replace(/^\s\s*/, '' ).replace(/\s\s*$/, '' );
    }	
</script>
<form action="<%=request.getContextPath()%>/save" method="post" enctype="multipart/form-data">
    <input type="hidden" name="xmlName" value="zwdbfk">
    <input type="hidden" name="xmlType" value="<%=(String) request.getAttribute("xmlType")%>">
    <input type="hidden" name="moduleId" value="zwdbfk">
    <html:hidden name="unid"/>
    <html:hidden name="depid" value="<%=depid%>"/>
    <html:hidden name="depname" value="<%=depname%>"/>
    <html:hidden name="userid" value="<%=userid%>"/>
    <html:hidden name="username" value="<%=username%>"/>
    <html:hidden name="issuetime" value="<%=issuetime%>"/>
    <html:hidden name="issueflag" value="<%=issueflag%>"/>
    <html:hidden name="isjs" value="2"/>
    <html:hidden name="qfman" value="<%=qfman%>"/>
    <html:hidden name="num" value="<%=num%>"/>
    <html:hidden name="year" value="<%=year%>"/>
    <html:hidden name="docunid" value="<%=docunid%>"/>
    <html:hidden name="hy" value="<%=hy%>"/>
    <table border="0" align="center" cellpadding="0" cellspacing="0" class="round">
        <tr>
            <td class="title">
                <div align=center><%=titlename%></div>
            </td>
        </tr>

        <tr>
         <td>    
        <table id="baseinfo" width="99%" border="0" align="center" cellpadding="0" cellspacing="0" class="table">
            <tr VALIGN=top>
                <td width="100px" VALIGN="middle" class="deeptd">
                    <div align="center">督办事项</div>
                </td>
                <td class="tinttd" colspan="3">
                    <html:text name="title"/>
                </td>
            </tr> 
            <tr valign="top">
                <td class="deeptd" width="100px">
                    <div align="center">文号</div>
                </td>
                <td class="tinttd" colspan="3">
		                    永批督〔<html:text name="year" style="width:60px"/>〕<html:text name="num" style="width:50px"/>号
                </td>
            </tr>
            <tr valign="top">
                <td class="deeptd" width="100px">
                    <div align="center">督办内容</div>
                </td>
                <td class="tinttd" colspan="3">
                    <html:textarea name="require" style="height:120px"/>
                </td>
            </tr>
            <tr valign="top">
                <td width="100px" valign="middle" class="deeptd">
                    <div align="center">批示领导<font color="red">*</font></div>
                </td>
                <td class="tinttd">
                    <html:text name="qfmanid" style="width:45%" /> &nbsp;
			        <img style="cursor:default;" title="点击选择处理人" src="<%=request.getContextPath()%>/resources/images/actn133.gif" onclick="openSelWin('<%=request.getContextPath()%>/address/tree_ry.jsp?utype=1&sflag=0&count=1&fields=qfmanid');">
                </td>
                <td width="100px"   VALIGN=middle class="deeptd">
                    <div align="center">发布时间</div>
                </td>
                <td  class="tinttd" >
                     <html:hidden name="issuetime"  value="<%=issuetime%>"/><%=issuetime%>
                </td>
            </tr>  
            <tr valign="top">
                <td width="100px" valign="middle" class="deeptd">
                    <div align="center">牵头领导</div>
                </td>
                <td class="tinttd" >
                    <html:text name="leadername" readonly="true"  style="width:45%"/>
			        <img style="cursor:default;" title="点击选择处理人" src="<%=request.getContextPath()%>/resources/images/actn133.gif" onclick="openSelWin('<%=request.getContextPath()%>/address/tree_ry.jsp?utype=0&rtype=0&ptype=0&sflag=0&count=0&fields=leadername,leaderid');">
                    <html:hidden name="leadernameid" />
                </td>
                <td width="100px" valign="middle" class="deeptd">
                    <div align="center">配合领导</div>
                </td>
                <td class="tinttd" >
                    <html:text name="source" style="width:45%" readonly="true" /> &nbsp;
			         <img style="cursor:default;" title="点击选择处理人" src="<%=request.getContextPath()%>/resources/images/actn133.gif" onclick="openSelWin('<%=request.getContextPath()%>/address/tree_ry.jsp?utype=0&rtype=0&ptype=0&sflag=0&count=0&fields=source,sourceid');">
                    <html:textarea name="sourceid" style="display:none"/> 
                </td>
            </tr>
            <%if(!hy.equals("会议")){%>
            <tr valign="top">
                <td class="deeptd" width="100px">
                    <div align="center">附&nbsp;&nbsp;&nbsp;&nbsp;件</div>
                </td>
                <td class="tinttd" colspan="3">
                    <html:file name="attachment"/>
                    <html:attachment moduleid="zwdbfk" unid="unid" type="attachment"/>
                    <html:attachment moduleid="zwdb" unid="issueflag" type="attach"/>
                </td>
            </tr>
            <%}else{%>
            <tr valign="top">
                <td class="deeptd" width="100px">
                    <div align="center">附&nbsp;&nbsp;&nbsp;&nbsp;件</div>
                </td>
                <td class="tinttd" colspan="3">
                    <html:file name="attachment"/>
                    <html:attachment moduleid="zwdbfk" unid="unid" type="attachment"/>
                    <html:attachment moduleid="zw_hydb" unid="docunid" type="attachment"/>
                </td>
            </tr>
            <%}%>
            <tr valign="top">
                <td width="100px" valign="middle" class="deeptd">
                    <div align="center">交办时限</div>
                </td>
                <td class="tinttd" style="width:40%">
                    <html:text name="jbsx" readonly="readonly"/>
                </td>
                <td width="100px" valign="middle" class="deeptd">
                    <div align="center">反馈周期</div>
                </td>
                <td class="tinttd" style="width:40%">
                    <html:hidden name="fklx"  value="<%=fklx%>"/>
                    <html:hidden name="fkzq"  value="<%=fkzq%>"/>
                    <%=fklx%>&nbsp;&nbsp;<%=fkzq%>
                </td>
            </tr>
            <tr valign="top" style="display:none">
                <td width="100px" VALIGN=middle class="deeptd">
                    <div align="center">部署时间</div>
                </td>
                <td class="tinttd" style="width:40%">
                    <html:hidden name="qftime" value="<%=qftime%>"/><%=qftime%>
                </td>
            </tr>
            <tr valign="top">
                <td width="100px" valign="middle" class="deeptd">
                    <div align="center">牵头单位</div>
                </td>
                <td colspan="3" class="tinttd">
                    <html:text name="managedepname" readonly="true"  style="width:90%"/>
			        <img style="cursor:default;" title="点击选择处理人" src="<%=request.getContextPath()%>/resources/images/actn133.gif" onclick="openSelWin('<%=request.getContextPath()%>/address/tree_jg.jsp?utype=0&rtype=0&ptype=0&sflag=0&count=1&fields=managedepname,managedepid');">
                    <html:hidden name="managedepid"/>
                </td>
            </tr>
			<tr valign="top">
                <td width="100px" valign="middle" class="deeptd">
                    <div align="center">配合单位</div>
                </td>
                <td colspan="3" class="tinttd">
                    <html:text name="copyto" readonly="true"  style="width:90%"/>
			        <img style="cursor:default;" title="点击选择处理人" src="<%=request.getContextPath()%>/resources/images/actn133.gif" onclick="openSelWin('<%=request.getContextPath()%>/address/tree_jg.jsp?utype=0&rtype=0&ptype=0&sflag=0&count=0&fields=copyto,copytoid');changeCopyDepName();">
                    <html:hidden name="copytoid"/>
                </td>
            </tr>
            <tr valign="top">
                <td width="100px" VALIGN=middle class="deeptd">
                    <div align="center">督办联系人</div>
                </td>
                <td class="tinttd">
                    <html:text name="lxr" style="width:45%" /> &nbsp;
		             <img style="cursor:default;" title="点击选择处理人" src="<%=request.getContextPath()%>/resources/images/actn133.gif" onclick="openSelWin('<%=request.getContextPath()%>/address/tree_ry.jsp?utype=1&sflag=0&count=1&fields=lxr,lxr_id');peopleChange();">
                    <html:hidden name="lxr_id"/>
                </td>
                <td width="100px" VALIGN=middle class="deeptd">
                    <div align="center">电话号码</div>
                </td>
                <td class="tinttd">
                    <html:text name="lxdh"/>
                </td>
            </tr>
            <tr valign="top">
                <td width="100px" VALIGN=middle class="deeptd">
                    <div align="center">机关网号码</div>
                </td>
                <td  class="tinttd" colspan="3">
                    <html:text name="czhm"/>
                </td>
            </tr>
        </table>
        <br/><br/>
        <jsp:include page="dbkfkpg.jsp"/>
        <tr>
            <td height="30">
                <DIV align="center">
                                <input type="submit" name="saveConent" class="formbutton" value="保  存"/>
                                <input type="submit" name="delContent" class="formbutton" value="删  除" onclick="document.all.xmlType.value='delete';return confirmDelete();"/>
                </DIV>
            </td>
        </tr>
    </table>
</form>
</template:put>
</template:insert>
