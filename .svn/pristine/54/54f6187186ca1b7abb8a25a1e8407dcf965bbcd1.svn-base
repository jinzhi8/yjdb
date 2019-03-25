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
<%@page import="java.util.*" %>
<%@page import="com.kizsoft.commons.commons.orm.SimpleORMUtils"%>
<%@page import="com.kizsoft.oa.wcoa.util.Zwdbhymin" %>
<%@taglib prefix="template" uri="/WEB-INF/struts-template.tld" %>
<%@taglib prefix="html" uri="/WEB-INF/oa-html.tld" %>
<%@taglib prefix="oa" uri="/WEB-INF/oa.tld" %>
<%
    SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
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
   List<Map<String,Object>> list=instance.queryForMap("select count(*) as count from zwdb where to_char(qftime,'yyyy-mm-dd')=?",nowtime); 
    String count="";
    if(list.size()!=0){
        SimpleDateFormat sd=new SimpleDateFormat("yyyyMMdd");
        String time=sd.format(new Date());
        Map<String,Object> map =list.get(0);
        count=map.get("count").toString();
        int num = Integer.parseInt(count)+1;
        count = String.valueOf(num);
        count=time+"00"+count;
        
    }

   
    String docunid=request.getParameter("docunid")==null?"":request.getParameter("docunid");
   
    SimpleDateFormat sdfp=new SimpleDateFormat("yyyy-MM-dd");
     
    String jbsx=info.getJbsx()==null?"":info.getJbsx();
    String qftime=info.getQftime()==null?"":info.getQftime();  
    if(!jbsx.equals("")&&!qftime.equals("")){
    jbsx=sdfp.format(sdfp.parse(info.getJbsx()));
    qftime=sdfp.format(sdfp.parse(info.getQftime()));
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
                <html:hidden name="num"  value="<%=info.getNum()%>"/>
                <html:hidden name="year"  value="<%=info.getYear()%>"/>
            <tr VALIGN=top>
                <td width="180px" VALIGN="middle" class="deeptd">
                    <div align="center">督办事项<font color="red">*</font></div>
                </td>
                <td class="tinttd" colspan="3">
                    <html:text name="title" value="<%=info.getTitle()%>" />
                </td>
            </tr> 
            <tr valign="top">
                <td class="deeptd" width="100px">
                    <div align="center">督办内容<font color="red">*</font></div>
                </td>
                <td class="tinttd" colspan="3">
                    <html:textarea name="require" value="<%=info.getRequire()%>" style="height:120px" />
                </td>
            </tr> 
            <tr valign="top">
                <td width="180px" valign="middle" class="deeptd">
                    <div align="center">批示领导<font color="red">*</font></div>
                </td>
                <td class="tinttd">
                    <html:textarea name="qfmanid" value="<%=info.getQfmanid()%>" style="width:35%" /> &nbsp;
                    <img src="<%=request.getContextPath()%>/resources/images/actn133.gif" onclick="window.showModalDialog('<%=request.getContextPath()%>/address/tree.jsp?utype=1&sflag=0&count=1&activid=2c90b371078d506501078d955ae50004&fields=qfmanid',window,'status:no;dialogWidth:300px;dialogHeight:380px;scroll:no;help:no;')">
                </td>
                <td width="80px" VALIGN=middle class="deeptd">
                    <div align="center">发布时间</div>
                </td>
                <td  class="tinttd">
                     <html:hidden name="issuetime"  value="<%=nowtime%>"/><%=nowtime%>
                </td>
            </tr> 
            <tr valign="top">
                <td width="180px" valign="middle" class="deeptd">
                    <div align="center">牵头领导<font color="red">*</font></div>
                </td>
                <td class="tinttd" >
                    <html:textarea name="leadername" style="width:50%" value="<%=info.getLeadername()%>" readonly="true" /> &nbsp;
                    <img src="<%=request.getContextPath()%>/resources/images/actn133.gif" value="<%=info.getSource()%>" onclick="window.showModalDialog('<%=request.getContextPath()%>/address/tree.jsp?utype=3&sflag=0&count=0&activid=2c90b371078d506501078d955ae50004&fields=leadername,leaderid',window,'status:no;dialogWidth:300px;dialogHeight:380px;scroll:no;help:no;')">
                    <html:textarea name="leaderid" style="display:none"/> 
                </td>
                 <td width="180px" valign="middle" class="deeptd">
                    <div align="center">配合领导</div>
                </td>
                <td class="tinttd" >
                    <html:textarea name="source" style="width:50%" value="<%=info.getSource()%>" readonly="true" /> &nbsp;
                    <img src="<%=request.getContextPath()%>/resources/images/actn133.gif" value="<%=info.getSource()%>" onclick="window.showModalDialog('<%=request.getContextPath()%>/address/tree.jsp?utype=3&sflag=0&count=0&activid=2c90b371078d506501078d955ae50004&fields=source,sourceid',window,'status:no;dialogWidth:300px;dialogHeight:380px;scroll:no;help:no;')">
                    <html:textarea name="sourceid" style="display:none"/> 
                </td>
            </tr>
            <tr valign="top">
                <td width="180px" valign="middle" class="deeptd" >
                    <div align="center">交办时限<font color="red">*</font></div>
                </td>
                <td class="tinttd" style="width:40%">
                    <html:hidden name="jbsx"  value="<%=jbsx%>"/><%=jbsx%>
                </td>
                <td width="80px" valign="middle" class="deeptd">
                    <div align="center">反馈周期<font color="red">*</font></div>
                </td>
                <td class="tinttd" style="width:40%">
                    <html:hidden name="fklx"  value="<%=info.getFklx()%>"/><%=info.getFklx()%>
                    <html:hidden name="fkzq"  value="<%=info.getFkzq()%>"/><%=info.getFkzq()%>
                </td>
            </tr>
            <tr valign="top"  style="display:none">
                
                <td width="80px" VALIGN=middle class="deeptd">
                    <div align="center">部署时间</div>
                </td>
                <td class="tinttd" style="width:40%" style="display:none">
                    <html:hidden name="qftime" value="<%=nowtime%>" /><%=nowtime%>
                </td>
            </tr>
            <tr valign="top">
                <td width="100px" valign="middle" class="deeptd">
                    <div align="center">牵头单位</div>
                </td>
                <td colspan="3" class="tinttd">
                    <html:textarea name="managedepname" readonly="true" value="<%=info.getManagedepname()%>"  style="width:90%"/>
                    <img src="<%=request.getContextPath()%>/resources/images/actn133.gif" onclick="window.showModalDialog('<%=request.getContextPath()%>/address/mailboxtreeqtdw.jsp?utype=3&sflag=0&count=0&ptype=1&fields=managedepname,managedepid',window,'status:no;dialogWidth:670px;dialogHeight:520px;scroll:no;help:no;');changeCopyDepName();">
                    <html:hidden name="managedepid" value="<%=info.getManagedepid()%>"/>
                </td>
            </tr>
            <tr valign="top">
                <td width="80px" valign="middle" class="deeptd">
                    <div align="center">配合单位</div>
                </td>
                <td colspan="3" class="tinttd">
                    <html:textarea name="copyto" readonly="true"  value="<%=info.getCopyto()%>" style="width:90%"/>
                    <img src="<%=request.getContextPath()%>/resources/images/actn133.gif" onclick="window.showModalDialog('<%=request.getContextPath()%>/address/mailboxtree.jsp?utype=3&sflag=0&count=0&ptype=1&fields=copyto,copytoid',window,'status:no;dialogWidth:670px;dialogHeight:520px;scroll:no;help:no;');changeCopyDepName();">
                    <html:hidden name="copytoid"  />
                </td>
            </tr>
           <tr valign="top">
                <td width="80px" VALIGN=middle class="deeptd">
                    <div align="center">督办机构联系人</div>
                </td>
                <td class="tinttd">
                    <html:textarea name="lxr"  value="<%=info.getLxr()%>" style="width:70%" /> &nbsp;
                    <img src="<%=request.getContextPath()%>/resources/images/actn133.gif" onclick="window.showModalDialog('<%=request.getContextPath()%>/address/tree.jsp?utype=3&sflag=0&count=0&activid=2c90b371078d506501078d955ae50004&fields=lxr,lxr_id',window,'status:no;dialogWidth:300px;dialogHeight:3100px;scroll:no;help:no;');">
                </td>
                <td width="80px" VALIGN=middle class="deeptd">
                    <div align="center">电话号码</div>
                </td>
                <td class="tinttd">
                    <html:text name="lxdh" value="<%=info.getLxdh()%>" style="width:70%"/>
                </td>
            </tr>
            <tr valign="top">
                <td width="80px" VALIGN=middle class="deeptd">
                    <div align="center">机关网号码</div>
                </td>
                <td   class="tinttd" colspan="3">
                    <html:text name="czhm" value="<%=info.getCzhm()%>" style="width:70%"/>
                </td>
                <td width="80px" VALIGN=middle class="deeptd" style="display: none">
                    <div align="center">是否办结</div>
                </td>
                <td class="tinttd" style="display: none">
                    <html:select name = "qfman"  style="width:150px">
                       <html:option value = "未办结">未办结</html:option>
                            <html:option value = "办结">办结</html:option>
                            <html:option value = "未办结">未办结</html:option>
                    </html:select>(督办科填写)
                </td>
            </tr>
        </table>
        <br/>
            <div height="50px"   align="center"> 
            <%if(unid.equals("")){%>       
                <input class="viewbutton save_tc1"  type="button" onclick="if(validateForm()){insertDetail();}"  value="保存"/>
            <%}else{%>
                <input class="viewbutton save_tc1"  type="button" onclick="updateDetail();"  value="修改"/>
            <%}%>    
            </div>
<script type="text/javascript">   
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
function fkchange(){
        var fklx=$("[name=fklx]").val();
        if(fklx=='一次性反馈'){
            $("#hide_show").css("display","none");
            $("[name=fkzq]").val("");
        }else{
            $("#hide_show").css("display","block");
        }
    }
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
        if(fklx=='一次性反馈'){
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
    var leaderid=$('[name=leaderid]').val();
    var source=$('[name=source]').val();
    var sourceid=$('[name=sourceid]').val();
    var jbsx=$('[name=jbsx]').val();
    var fklx=$('[name=fklx]').val();
    var fkzq=$('[name=fkzq]').val();
    var issuetime="<%=nowtime%>";
    var qftime=$('[name=qftime]').val();
    var managedepname=$('[name=managedepname]').val();
    var managedepid=$('[name=managedepid]').val();
    var copyto=$('[name=copyto]').val();
    var copytoid=$('[name=copytoid]').val();
    var lxr=$('[name=lxr]').val();
    var lxdh=$('[name=lxdh]').val();
    var czhm=$('[name=czhm]').val();
    var qfman=$('[name=qfman]').val();
    var year=$('[name=year]').val();
    var num=$('[name=num]').val();
    var qfmanid=$('[name=qfmanid]').val();
        $.ajax({ 
                async: true, 
                type : "POST", 
                url : "<%=request.getContextPath()%>/zw_hydb/insertAjax.jsp",
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
                    leaderid:leaderid,
                    source : source,
                    sourceid:sourceid,
                    jbsx : jbsx,
                    fklx:fklx,
                    fkzq:fkzq,
                    issuetime:issuetime,
                    qftime : qftime,
                    managedepname : managedepname,
                    managedepid:managedepid,
                    copyto : copyto,
                    copytoid : copytoid,
                    lxr:lxr,
                    lxdh : lxdh,
                    czhm : czhm, 
                    qfman : qfman,
                    year : year,
                    num :num,
                    qfmanid:qfmanid   
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
    var unid="<%=unid%>";
    var docunid="<%=docunid%>";
    var userID="<%=userID%>";
    var groupID="<%=groupID%>";     
    var userName="<%=userName%>";   
    var depName="<%=depName%>";  
    var title=$('[name=title]').val();
    var require=$('[name=require]').val();
    var leadername=$('[name=leadername]').val();
    var leaderid=$('[name=leaderid]').val();
    var source=$('[name=source]').val();
    var sourceid=$('[name=sourceid]').val();
    var jbsx=$('[name=jbsx]').val();
    var fklx=$('[name=fklx]').val();
    var fkzq=$('[name=fkzq]').val();
    var issuetime="<%=nowtime%>";
    var qftime=$('[name=qftime]').val();
    var managedepname=$('[name=managedepname]').val();
    var managedepid=$('[name=managedepid]').val();
    var copyto=$('[name=copyto]').val();
    var copytoid=$('[name=copytoid]').val();
    var lxr=$('[name=lxr]').val();
    var lxdh=$('[name=lxdh]').val();
    var czhm=$('[name=czhm]').val();
    var qfman=$('[name=qfman]').val();
    var year=$('[name=year]').val();
    var num=$('[name=num]').val();
    var qfmanid=$('[name=qfmanid]').val();
        $.ajax({ 
                async: true, 
                type : "POST", 
                url : "<%=request.getContextPath()%>/zw_hydb/updateAjax.jsp",
                cache: false,                      
                data : {
                    unid :unid,
                    docunid:docunid,
                    userID : userID,
                    groupID : groupID,
                    userName:userName,
                    depName : depName,
                    title : title,
                    require : require,
                    leadername:leadername,
                    leaderid:leaderid,
                    source : source,
                    sourceid:sourceid,
                    jbsx : jbsx,
                    fklx:fklx,
                    fkzq:fkzq,
                    issuetime:issuetime,
                    qftime : qftime,
                    managedepname : managedepname,
                    managedepid:managedepid,
                    copyto : copyto,
                    copytoid : copytoid,
                    lxr:lxr,
                    lxdh : lxdh,
                    czhm : czhm, 
                    qfman : qfman,
                    year : year,
                    num :num,
                    qfmanid:qfmanid   
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