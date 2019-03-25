<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.acl.ACLManager" %>
<%@page import="com.kizsoft.commons.acl.ACLManagerFactory" %>
<%@page import="com.kizsoft.commons.commons.user.Group" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.component.entity.FieldEntity" %>
<%@page import="com.kizsoft.commons.workflow.FlowTransmitInfo" %>
<%@page import="com.kizsoft.oa.archives.beans.ArchivesManager" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="com.kizsoft.commons.workflow.Instance" %>
<%@ page import="com.kizsoft.commons.workflow.Request" %>
<%@ page import="com.kizsoft.commons.workflow.WorkflowFactory" %>
<%@ page import="com.kizsoft.commons.workflow.dao.DAOFactory" %>
<%@ page import="com.kizsoft.commons.workflow.dao.RequestDAO" %>
<%@ page import="com.kizsoft.commons.commons.user.UserManagerFactory" %>
<%@page import="com.kizsoft.commons.commons.orm.SimpleORMUtils"%>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<%@taglib prefix="html" uri="/WEB-INF/oa-html.tld" %>
<%@taglib prefix="oa" uri="/WEB-INF/oa.tld" %>
<%
	//用户登陆验证
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
		return;
	}
	User userInfo = (User) session.getAttribute("userInfo");
	String userID = userInfo.getUserId();
	String userName = userInfo.getUsername();
	Group groupInfo = userInfo.getGroup();
	String groupID = groupInfo.getGroupId();
	String unid=getAttr(request,"unid","");
    String docunid=getAttr(request,"docunid",""); 
    String issuetime=getAttr(request,"issuetime");
    SimpleDateFormat sdfp=new SimpleDateFormat("yyyy-MM-dd");
    if(!issuetime.equals("")){
    issuetime=sdfp.format(sdfp.parse(issuetime));
    }
    String hy=getAttr(request,"hy","");
    SimpleORMUtils instance=SimpleORMUtils.getInstance();
    List<Map<String,Object>> list=instance.queryForMap("select * from ZWDBHY  where unid=?",docunid);
    Object title="";
    if(list.size()!=0){
        Map<String,Object> map=list.get(0);
        title=map.get("title");
    }
    String href="zwdbfk";
    String atitle="批示督办";
    if(hy.equals("会议")){
        atitle="会议督办";
        href="zwdbhyfk";
    }

%>
<%
	String userTemplateName = (String) session.getAttribute("templatename");
	String userTemplateStr = "/resources/template/" + userTemplateName + "/template.jsp";
	if (userTemplateName == null || "".equals(userTemplateName)) {
		userTemplateStr = "/resources/jsp/template.jsp";
	}
%>
<%! 
   public String getAttr(HttpServletRequest request,String name,String replace){
        String temp=replace;
        FieldEntity tempentity = (FieldEntity) request.getAttribute(name);
        if (tempentity == null || tempentity.getValue() == null || "".equals(tempentity.getValue())) {
        } else {
            temp = (String) tempentity.getValue();
        }
        return temp;
    }
	public String getAttr(HttpServletRequest request,String name){
		return getAttr(request,name,"");
	}


%>


<template:insert template="<%=userTemplateStr%>">
<template:put name='title' content="<%=atitle%>" direct='true'/>
<%String str = "<a class=\"menucur\" href=\""+href+"\">"+atitle+"</a>"; %>
<template:put name='moduleNav' content='<%=str%>' direct='true'/>
<template:put name='content'>

<input type="hidden" name="moduleId" value="zwdbfk">
<table border="0" align="center" cellpadding="0" cellspacing="0" class="round">
        <tr>
        <%if(hy.equals("会议")){%>
            <td class="title">
                <div align=center>永嘉县人民政府领导会议督办件</div>
            </td>
        <%}else{%>
            <td class="title">
                <div align=center>永嘉县人民政府领导批示督办单</div>
            </td>
        <%}%>
        </tr>
        <tr>
         <td>    
        <table id="baseinfo" width="99%" border="0" align="center" cellpadding="0" cellspacing="0" class="table">
            <%if(hy.equals("会议")){%>
            <tr VALIGN=top>
                <td width="100px" VALIGN="middle" class="deeptd">
                    <div align="center">会议名称</div>
                </td>
                <td class="tinttd" colspan="3">
                     <%=title%>
                </td>
            </tr>
            <%}%>
            <tr VALIGN=top>
                <td width="100px" VALIGN="middle" class="deeptd">
                    <div align="center">督办事项</div>
                </td>
                <td class="tinttd" colspan="3">
                    <html:write name="title"/>
                </td>
            </tr>
            <tr valign="top">
                <td class="deeptd" width="100px">
                    <div align="center">督办内容</div>
                </td>
                <td class="tinttd" colspan="3">
                    <html:write name="require"/>
                </td>
            </tr>
             <tr valign="top">
                <td width="100px" valign="middle" class="deeptd">
                    <div align="center">批示领导</div>
                </td>
                <td class="tinttd" style="width:40%">
                    <html:write name="qfmanid"/>
                </td>
                <td width="100px" valign="middle" class="deeptd">
                    <div align="center">发布时间</div>
                </td>
                <td class="tinttd" style="width:40%">
                    <%=issuetime%>
                </td>
            </tr>   
            <tr valign="top">
                <td width="100px" valign="middle" class="deeptd">
                    <div align="center">牵头领导</div>
                </td>
                <td class="tinttd" style="width:40%">
                    <html:write name="leadername"/>
                </td>
                <td width="100px" valign="middle" class="deeptd">
                    <div align="center">配合领导</div>
                </td>
                <td class="tinttd" style="width:40%">
                    <html:write name="source"/>
                </td>
            </tr>
             <%if(!hy.equals("会议")){%>
            <tr valign="top">
                <td class="deeptd" width="100px">
                    <div align="center">附&nbsp;&nbsp;&nbsp;&nbsp;件</div>
                </td>
                <td class="tinttd" colspan="3">
                    <html:attachment moduleid="zwdbfk" unid="unid" type="attachment" showdelete="false"/>
                    <html:attachment moduleid="zwdb" unid="issueflag" type="attach" showdelete="false"/>
                </td>
            </tr>
            <%}else{%>
            <tr valign="top">
                <td class="deeptd" width="100px">
                    <div align="center">附&nbsp;&nbsp;&nbsp;&nbsp;件</div>
                </td>
                <td class="tinttd" colspan="3">
                    <html:attachment moduleid="zwdbfk" unid="unid" type="attachment" showdelete="false"/>
                    <html:attachment moduleid="zw_hydb" unid="docunid" type="attachment" showdelete="false"/>
                </td>
            </tr>
            <%}%>
            <tr valign="top">
                <td width="100px" valign="middle" class="deeptd">
                    <div align="center">交办时限</div>
                </td>
                <td class="tinttd" >
                    <html:write name="jbsx"/>
                </td>
                <td width="100px" valign="middle" class="deeptd">
                    <div align="center">报送周期</div>
                </td>
                <td class="tinttd">
                    <html:write name = "fklx" />&nbsp;&nbsp;<html:write name = "fkzq" />
                </td>
            </tr>
            <tr valign="top">
                <td width="100px" valign="middle" class="deeptd">
                    <div align="center">牵头单位</div>
                </td>
                <td colspan="3" class="tinttd">
                    <html:write name="managedepname"/>
                </td>
            </tr>
			<tr valign="top">
                <td width="100px" valign="middle" class="deeptd">
                    <div align="center">配合单位</div>
                </td>
                <td colspan="3" class="tinttd">
                    <html:write name="copyto"/>
                </td>
            </tr>
            <tr valign="top">
                <td width="100px" VALIGN=middle class="deeptd">
                    <div align="center">督办机构联系人</div>
                </td>
                <td class="tinttd">
                    <html:write name="lxr" />
                </td>
                <td width="100px" VALIGN=middle class="deeptd">
                    <div align="center">电话号码</div>
                </td>
                <td class="tinttd">
                    <html:write name="lxdh"/>
                </td>
            </tr>
            <tr valign="top">
                <td width="100px" VALIGN=middle class="deeptd">
                    <div align="center">传真号码</div>
                </td>
                <td  class="tinttd" colspan="3">
                    <html:write name="czhm"/>
                </td>
            </tr>
        </table>
    </br>
    <jsp:include page="fkpg.jsp"/>
</template:put>
</template:insert>
<!--索思奇智版权所有-->