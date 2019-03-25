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
<%@page import="java.util.*"%>
<%@ page import="com.kizsoft.commons.workflow.Instance" %>
<%@ page import="com.kizsoft.commons.workflow.Request" %>
<%@ page import="com.kizsoft.commons.workflow.WorkflowFactory" %>
<%@ page import="com.kizsoft.commons.workflow.dao.DAOFactory" %>
<%@ page import="com.kizsoft.commons.workflow.dao.RequestDAO" %>
<%@page import="java.sql.Connection" %>
<%@page import="java.sql.PreparedStatement" %>
<%@page import="java.sql.ResultSet" %>
<%@page import="com.kizsoft.commons.commons.db.ConnectionProvider" %>   
<%@ page import="com.kizsoft.commons.commons.user.UserManagerFactory" %>
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

%>
<%
    String userTemplateName = (String) session.getAttribute("templatename");
    String userTemplateStr = "/resources/template/" + userTemplateName + "/template.jsp";
    if (userTemplateName == null || "".equals(userTemplateName)) {
        userTemplateStr = "/resources/jsp/template.jsp";
    }
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

    public String viewEquips(String uuid){

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
                         
                        bf.append("<tr ALIGN=top id=\""+unid+"\"><td ALIGN=center>"+qfman+"</td><td ALIGN=center>"+leadername+"</td><td ALIGN=center>"+title+"</td><td ALIGN=center>"+jbsx+"</td><td ALIGN=center>"+qftime+"</td><td ALIGN=center><input type=\"button\" value='查 看' onclick=\"openNew('"+unid+"');\"/></td></tr>");
                        count++;
                    }
            }catch(Exception e){
            }finally{
                    ConnectionProvider.close(db,stat,rs);
            }
            return bf.toString();
    }

%>
<script type="text/javascript">
    function openNew(zunid)
            {
                /*var ret_val;//接受返回值
                //var strReturn;//返回值处理后存的变量
                // var url = "bm_select.aspx";
                var url="<%=request.getContextPath()%>/zw_hydb/selecttime.jsp?unid="+zunid;
                alert(url);
                var sFeatures = "dialogHeight:700px; dialogWidth: 800px; center: Yes; help: No; resizable: No; status: No;";
                ret_val = window.open (url,"",sFeatures);*/
                //alert(ret_val);
                //console.log(ret_val);
                //alert(ret_val[0].unid);
                //window.location.reload();
                var width = 800;
                var height = 500;
                //var iTop = (window.screen.availHeight - 30 - width) / 2;
                //var iLeft = (window.screen.availWidth - 10 - height) / 2;
                var iTop = (window.screen.availHeight - height ) / 2;
                var iLeft = (window.screen.availWidth - width) / 2 + 90;
                var win = window.open("<%=request.getContextPath()%>/zwdbhyfk/openShow.jsp?unid="+zunid, "弹出窗口", "width=" + width + ", height=" + height + ",top=" + iTop + ",left=" + iLeft + ",toolbar=no, menubar=no, scrollbars=yes, resizable=no,location=no, status=no,alwaysRaised=yes,depended=yes");
            }
</script>  
</script>

<template:insert template="<%=userTemplateStr%>">
<template:put name='title' content='会议件督办' direct='true'/>
<%String str = "<a class=\"menucur\" href=\"zwdbhyfk\">会议件督办</a>"; %>
<template:put name='moduleNav' content='<%=str%>' direct='true'/>
<template:put name='content'>

<input type="hidden" name="moduleId" value="zwdbhyfk">
<table border="0" align="center" cellpadding="0" cellspacing="0" class="round">
        <tr>
            <td class="title">
                <div align=center>文成县人民政府领导会议督办单</div>
            </td>
        </tr>
        <!-- <tr>
            <td>
                <div align="right">
                    立项编〔<html:write name="year"/>〕<html:write name="num"/>号
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
                    <html:write name="title"/>
                </td>
            </tr>
            <tr valign="top">
                <td width="80px" valign="middle" class="deeptd">
                    <div align="center">部署县长</div>
                </td>
                <td class="tinttd" style="width:40%">
                    <html:write name="leadername"/>
                </td>
                <td width="80px" valign="middle" class="deeptd">
                    <div align="center">会议时间</div>
                </td>
                <td class="tinttd" style="width:40%">
                    <html:write name="qftime"/>
                </td>
            </tr>
            <tr valign="top">
                <td width="80px" valign="middle" class="deeptd">
                    <div align="center">会议类型</div>
                </td>
                <td class="tinttd" >
                    <html:write name="source"/>
                </td>
                <td width="80px" valign="middle" class="deeptd">
                    <div align="center">是否办结</div>
                </td>
                <td class="tinttd">
                    <html:write name = "qfman" />
                </td>
            </tr>
            <tr valign="top">
                <td class="deeptd" width="100px">
                    <div align="center">附&nbsp;&nbsp;&nbsp;&nbsp;件</div>
                </td>
                <td class="tinttd" colspan="3">
                   
                    <html:attachment moduleid="zw_hydb" unid="unid" type="attachment" showdelete="false"/>
                    <html:attachment moduleid="zwdbhyfk" unid="unid" type="attachment" showdelete="false"/>
                </td>
            </tr>
            <tr valign="top">
                <td width="80px" valign="middle" class="deeptd">
                    <div align="center">会议议程</div>
                </td>
                <td colspan="3" class="tinttd">
                    <html:write name="require"/>
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
            </tr>
            <%=viewEquips(unid)%>           
        </table>    
    </br>
</template:put>
</template:insert>
<!--索思奇智版权所有-->