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
<%@page import="com.kizsoft.commons.commons.orm.SimpleORMUtils"%>
<%@page import="com.kizsoft.oa.wcoa.util.Zwdbhymin" %>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<%@taglib prefix="html" uri="/WEB-INF/oa-html.tld" %>
<%@taglib prefix="oa" uri="/WEB-INF/oa.tld" %>
<%
    SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    String nowtime=sdf.format(new Date());
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
    
    
    
    String unid=request.getParameter("unid")==null?"":request.getParameter("unid");
    SimpleORMUtils instance=SimpleORMUtils.getInstance();

    Zwdbhymin info=instance.queryForObject(Zwdbhymin.class,"select * from ZWDB where unid=?",unid);

    //List<Zwdbhymin> list=instance.queryForList(Zwdbhymin.class,"select * from ZWDBHYMIN where unid=?",unid); 

   
    String docunid=request.getParameter("docunid")==null?"":request.getParameter("docunid");
   
    SimpleDateFormat sdfp=new SimpleDateFormat("yyyy-MM-dd");
     
    String jbsx=info.getJbsx()==null?"":info.getJbsx();
    String qftime=info.getQftime()==null?"":info.getQftime();  
    if(!jbsx.equals("")&&!qftime.equals("")){
    jbsx=sdfp.format(sdfp.parse(info.getJbsx()));
    qftime=sdfp.format(sdfp.parse(info.getQftime()));
    System.out.println(qftime);
    }
       
%>
<%!
    
%>
<template:insert template="<%=template%>">
<template:put name='title' content='县领导批示督办' direct='true'/>
<% String str = "";%>
<template:put name='moduleNav' content='<%=str%>' direct='true'/>
<template:put name='content'>
<script type="text/javascript" src="<%=contextPath%>/js/json2.js"></script>
<style type="text/css">
    .table_tc_title{
        text-align: center;
        height: 30px;
        line-height: 30px;
        margin-top: 30px;
    }
    .table_tc1{
        display: table-cell;
        vertical-align: middle;
        border: 1px solid #a5cdf0;
        width: 90%;
        margin: 10px auto;
        margin-top: 30px;
    }
    .save_tc1{
        height: 35px !important;/* 
        line-height: 35px !important; */
        padding: 0px !important;
    }
</style>
    <div class="table_tc_title">文成县人民政府领导会议督办单</div>
        <table id="baseinfo" width="99%" border="0" align="center" cellpadding="0" cellspacing="0" class="table">
            <tr VALIGN=top>
                <td width="180px" VALIGN="middle" class="deeptd">
                    <div align="center">督办事项</div>
                </td>
                <td class="tinttd" colspan="3" style="width:480">
                    <%=info.getTitle()%>
                </td>
            </tr> 
            <tr valign="top">
                <td class="deeptd" width="100px">
                    <div align="center">督办内容</div>
                </td>
                <td class="tinttd" colspan="3">
                    <%=info.getRequire()%>
                </td>
            </tr> 
            <tr valign="top">
                <td width="180px" valign="middle" class="deeptd">
                    <div align="center">批示领导</div>
                </td>
                <td class="tinttd" >
                    <%=info.getQfmanid()%>
                </td>
                 <td width="180px" valign="middle" class="deeptd">
                    <div align="center">发布时间</div>
                </td>
                <td class="tinttd" >
                    <%=qftime%>
                </td>
            </tr> 
            <tr valign="top">
                <td width="180px" valign="middle" class="deeptd">
                    <div align="center">牵头领导</div>
                </td>
                <td class="tinttd" >
                    <%=info.getLeadername()%>
                </td>
                 <td width="180px" valign="middle" class="deeptd">
                    <div align="center">配合领导</div>
                </td>
                <td class="tinttd" >
                    <%=info.getSource()%>
                </td>
            </tr>
            <tr valign="top">
                <td width="180px" valign="middle" class="deeptd" >
                    <div align="center">交办时限</div>
                </td>
                <td class="tinttd" style="width:40%">
                    <%=jbsx%>
                </td>
                <td width="80px" valign="middle" class="deeptd">
                    <div align="center">反馈周期</div>
                </td>
                <td class="tinttd" style="width:40%" >
                    <%=info.getFklx()%>
                </td>
            </tr>
            <tr valign="top">
                <td width="80px" valign="middle" class="deeptd">
                    <div align="center">牵头单位</div>
                </td>
                <td colspan="3" class="tinttd" >
                    <%=info.getManagedepname()%>
                </td>
            </tr>
            <tr valign="top">
                <td width="80px" valign="middle" class="deeptd">
                    <div align="center">配合单位</div>
                </td>
                <td colspan="3" class="tinttd" >
                    <%=info.getCopyto()%>
                </td>
            </tr>
            <tr valign="top">
                <td width="80px" VALIGN=middle class="deeptd">
                    <div align="center">督办机构联系人</div>
                </td>
                <td class="tinttd">
                   <%=info.getLxr()%>
                </td>
                <td width="80px" VALIGN=middle class="deeptd">
                    <div align="center">电话号码</div>
                </td>
                <td class="tinttd">
                    <%=info.getLxdh()%>
                </td>
            </tr>
            <tr valign="top">
                <td width="80px" VALIGN=middle class="deeptd">
                    <div align="center">机关网号码</div>
                </td>
                <td   class="tinttd" colspan="3">
                    <%=info.getCzhm()%>
                </td>
            </tr>
           
        </table>
        <br/>
        <br/>
        <jsp:include page="dbkfkpg.jsp">
        <jsp:param name="unid" value="<%=unid%>" />
        </jsp:include>
        
<script type="text/javascript">
function validateForm() {
        if (document.all.title.value == "") {
            alert("基本信息不完整,请填写!");
            return false;
        }
        var title=$("[name=title]").val();
        if(title==''){
            alert("请选择督办事项!");
            return false;
        }
        
        var leadername=$("[name=leadername]").val();
        if(leadername==''){
            alert("请选择牵头领导!");
            return false;
        }
        
        var jbsx=$("[name=jbsx]").val();
        if(jbsx==''){
            alert("请选择交办时限!");
            return false;
        }

        var qftime=$("[name=qftime]").val();
        if(qftime==''){
            alert("请选择部署时间!");
            return false;
        }
        
        var managedepname=$("[name=managedepname]").val();
        if(managedepname==''){
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
function insertDetail(){
    var docunid="<%=docunid%>";
    var userID="<%=userID%>";
    var groupID="<%=groupID%>";     
    var userName="<%=userName%>";   
    var depName="<%=depName%>";  
    var title=$('[name=title]').val();
    var require=$('[name=require]').val();
    var leadername=$('[name=leadername]').val();
    var source=$('[name=source]').val();
    var jbsx=$('[name=jbsx]').val();
    var fklx=$('[name=fklx]').val();
    var issuetime="<%=nowtime%>"
    var qftime=$('[name=qftime]').val();
    var managedepname=$('[name=managedepname]').val();
    var managedepid=$('[name=managedepid]').val();
    var copyto=$('[name=copyto]').val();
    var copytoid=$('[name=copytoid]').val();
    var lxr=$('[name=lxr]').val();
    var lxdh=$('[name=lxdh]').val();
    var czhm=$('[name=czhm]').val();
    var qfman=$('[name=qfman]').val();
        $.ajax({ 
                async: true, 
                type : "POST", 
                url : "<%=request.getContextPath()%>/zw_hydb/insertAjax.jsp?",
                cache: false,                      
                data : {
                    docunid:docunid,
                    userID : userID,
                    groupID : groupID,
                    userName:userName,
                    depName : depName,
                    title : title,
                    require : require,
                    leadername:leadername,
                    source : source,
                    jbsx : jbsx,
                    fklx:fklx,
                    issuetime:issuetime,
                    qftime : qftime,
                    managedepname : managedepname,
                    managedepid:managedepid,
                    copyto : copyto,
                    copytoid : copytoid,
                    lxr:lxr,
                    lxdh : lxdh,
                    czhm : czhm, 
                    qfman : qfman   
            },
            success:function(data){
                
                data=data.replace(/^(\s|\xA0)+|(\s|\xA0)+$/g, ''); 
                data=JSON.parse(data);
                window.opener.callfun(data);
                //window.returnValue=data;  
                window.close();  
                
            }
        });
}
function updateDetail(){
    var docunid="<%=docunid%>";
    var unid="<%=unid%>";
    var userID="<%=userID%>";
    var groupID="<%=groupID%>";     
    var userName="<%=userName%>";   
    var depName="<%=depName%>";  
    var title=$('[name=title]').val();
    var require=$('[name=require]').val();
    var leadername=$('[name=leadername]').val();
    var source=$('[name=source]').val();
    var jbsx=$('[name=jbsx]').val();
    var fklx=$('[name=fklx]').val();
    var issuetime="<%=nowtime%>"
    var qftime=$('[name=qftime]').val();
    var managedepname=$('[name=managedepname]').val();
    var managedepid=$('[name=managedepid]').val();
    var copyto=$('[name=copyto]').val();
    var copytoid=$('[name=copytoid]').val();
    var lxr=$('[name=lxr]').val();
    var lxdh=$('[name=lxdh]').val();
    var czhm=$('[name=czhm]').val();
    var qfman=$('[name=qfman]').val();
        $.ajax({ 
                async: true, 
                type : "POST", 
                url : "<%=request.getContextPath()%>/zw_hydb/updateAjax.jsp?",
                cache: false,                        
                data : {
                    docunid:docunid,
                    unid :unid,
                    userID : userID,
                    groupID : groupID,
                    userName:userName,
                    depName : depName,
                    title : title,
                    require : require,
                    leadername:leadername,
                    source : source,
                    jbsx : jbsx,
                    fklx:fklx,
                    issuetime:issuetime,
                    qftime : qftime,
                    managedepname : managedepname,
                    managedepid:managedepid,
                    copyto : copyto,
                    copytoid : copytoid,
                    lxr:lxr,
                    lxdh : lxdh,
                    czhm : czhm,
                    qfman :qfman   
            },
            success:function(data){
                data=data.replace(/^(\s|\xA0)+|(\s|\xA0)+$/g, '');             
                data=JSON.parse(data);
                window.opener.updatecallfun(data);
                //window.returnValue=data;  
                window.close();    
            }
        });
}
</script>
</template:put>
</template:insert>