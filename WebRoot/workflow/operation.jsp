<%@page language="java" contentType="text/html;charset=UTF-8" %>

<%@page import="com.kizsoft.commons.Constant" %>
<%@page import="com.kizsoft.commons.commons.attachment.AttachmentEntity" %>
<%@page import="com.kizsoft.commons.commons.attachment.AttachmentManager" %>
<%@page import="com.kizsoft.commons.commons.user.User" %>
<%@page import="com.kizsoft.commons.commons.user.UserManagerFactory" %>
<%@page import="com.kizsoft.commons.commons.util.StringHelper" %>
<%@page import="com.kizsoft.commons.component.taglib.TagUtils" %>
<%@page import="com.kizsoft.commons.workflow.*" %>
<%@page import="com.kizsoft.oa.personal.Messengerdata" %>
<%@page import="com.kizsoft.oa.personal.PersonalForm" %>
<%@page import="org.apache.struts.Globals" %>
<%@page import="org.apache.xpath.XPathAPI" %>
<%@page import="org.w3c.dom.Document" %>
<%@page import="org.w3c.dom.Element" %>
<%@page import="org.xml.sax.InputSource" %>
<%@page import="javax.xml.parsers.DocumentBuilder" %>
<%@page import="javax.xml.parsers.DocumentBuilderFactory" %>
<%@page import="java.io.StringReader" %>
<%@page import="java.util.ArrayList" %>
<%@page import="java.util.Collection" %>
<%@page import="java.util.Date" %>
<%@page import="java.util.Map" %>
<%@page import="java.util.List" %>
<%@page import="java.util.Iterator" %>
<%@taglib prefix="html" uri="/WEB-INF/oa-html.tld" %>
<%

    FlowTransmitInfo flowTransmitInfo = (FlowTransmitInfo) request.getAttribute("flowTransmitInfo");
    String flowID = flowTransmitInfo.getFlowID();
    String taskID = flowTransmitInfo.getTaskID();
    String instanceID = flowTransmitInfo.getInstanceID();
    String moduleID = flowTransmitInfo.getModuleID();

    String handleServUrl = "http://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath();
    String handlePath = "/attachment/workflow/" + new Date().getTime();
    String handleName = "handwritepic.bmp";
    boolean handleFlag = false;

    User userInfo = (User) session.getAttribute("userInfo");
    String userID = userInfo.getUserId();

    Flow curFlow = flowTransmitInfo.getCurFlow();
    Activity curActivity = flowTransmitInfo.getCurActivity();
    Task curTask = flowTransmitInfo.getCurTask();
    Request curRequest = null;

    String flowType = null;
    String activType = null;
    String reqAction = null;
    String splitMode = null;
    String message = "";

    if (!StringHelper.isNull(taskID)) {
        if (curTask == null) curTask = WorkflowFactory.getTaskManager().getTask(taskID);
        if (curFlow == null) curFlow = curTask.getFlow();
        if (curActivity == null) curActivity = curTask.getActivity();

        curRequest = WorkflowFactory.getRequestManager().getCurRequest(taskID);
    } else if (!StringHelper.isNull(flowID)) {
        if (curFlow == null) curFlow = WorkflowFactory.getFlowManager().getFlow(flowID);
        if (curActivity == null) curActivity = WorkflowFactory.getActivityManager().getFirstFlowActivity(flowID);
    }

    if (curFlow != null) flowType = curFlow.getFlowType();

    if (curRequest != null) {
        reqAction = curRequest.getReqAction();
        message = curRequest.getMessage();

        AttachmentEntity handleEntity = new AttachmentManager().getAttachmentByUNID(Constant.MODULE_NAME_WORKFLOWHANDWRITE, curRequest.getReqId(), null);
        if (handleEntity != null) {
            handleFlag = true;
            handlePath = handleEntity.getAttachmentPath();
            handleName = handleEntity.getAttachmentName();
        }
    }

    if (curActivity != null) {
        activType = curActivity.getActivType();
        splitMode = curActivity.getSplitMode();
    }

    if (StringHelper.isNull(splitMode)) splitMode = "OR";


    if ("normal".equals(flowType) || "subflow".equals(flowType)) {

        //****************************************************************************
        //如果是普通流程显示以下控制面板
        //获得下一步的活动列表
        //以下是对正常流程选择模式的显示模式控制方法！

        //取得下一步的操作列表
        Collection nextTransList = WorkflowFactory.getTransitionManager().getNextTransitions(curActivity.getActivId());
        boolean subflowFlag = false;
        boolean nextTransFlag = false;

        if ("subflow".equalsIgnoreCase(activType)) subflowFlag = true;

        if (nextTransList != null && nextTransList.size() > 0){
            nextTransFlag = true;
        }
%>
<div id="divlccz">
<table width="100%" align="center" class="table">
<tr>
    <td class="deeptd" width="120px">当前操作：</td>
    <td class="tinttd" colspan="5" style="color:red"><%=curActivity.getActivName()%>
        <input type="hidden" name="curactivname" value="<%=curActivity.getActivName()%>">&nbsp;&nbsp;时限：<%=curActivity.getDeadline() == null ? "无" : curActivity.getDeadline() + "小时"%>
        &nbsp;&nbsp;<a href="javascript:void(0);" onclick="window.open('<%=request.getContextPath()%>/workflow/viewvmlflow.jsp?flowid=<%=flowID%>&activid=<%=curActivity.getActivId()%>',window,'status:no;dialogWidth:800px;dialogHeight:600px;scroll:auto;help:no;')"><font color="red"><b>查看流程图</b></font></a>
    </td>
</tr>
<% //子流程处理
    if (subflowFlag) {
        Collection subflowList = WorkflowFactory.getFlowManager().getSubFlowList(moduleID, userID);

        String selectedSubflow = null;
        String subflowPerformer = "";
        String subflowPerformer_cn = "";

        if (!StringHelper.isNull(reqAction)) {
            StringReader xmlStr = new StringReader(reqAction);
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            DocumentBuilder builder = dbf.newDocumentBuilder();
            Document doc = builder.parse(new InputSource(xmlStr));
            String xpath = "/subflows/subflow";
            Element node = (Element) XPathAPI.selectSingleNode(doc, xpath);
            if (node != null) {
                selectedSubflow = node.getAttribute("id");

                Element pfNode = (Element) node.getFirstChild();
                if (pfNode != null) {
                    subflowPerformer = pfNode.getAttribute("value");
                    subflowPerformer_cn = pfNode.getAttribute("cvalue");
                }
            }
            xmlStr.close();
        }%>
<tr id="flowSubflowTr">
    <td class="deeptd" rowspan="2">
        <% if (nextTransFlag) {%>
        <INPUT TYPE="radio" class="radio" NAME="workflowOperationFlag" value='subflow' checked>
        <% }%>
        子流程处理操作：
    </td>
    <td class="deeptd" width="50px">&nbsp;</td>
    <td class="deeptd" width="180px">处理流程</td>
    <td class="deeptd" width="220px">处 理 人</td>
    <td class="deeptd">&nbsp;&nbsp;</td>
</tr>
<tr>
    <td class="deeptd" width="50px"><INPUT TYPE="checkbox" NAME="subflow_check" checked disabled></td>
    <td class="deeptd" width="180px">
        <SELECT NAME="subflow_selection">
            <% for (Iterator itr = subflowList.iterator(); itr.hasNext(); ) {
                Flow subflow = (Flow) itr.next();
                String optionSelected = "";

                if (subflow.getFlowId().equals(selectedSubflow)) optionSelected = " selected ";%>
            <option value="<%=subflow.getFlowId()%>" <%=optionSelected%>><%=subflow.getFlowName()%>
                    <%
	}
%>
        </SELECT>
    </td>
    <td class="deeptd" width="220px">
        <input name="subflow_performer" value="<%=subflowPerformer%>" type="hidden" readonly>
        <input name="subflow_performer_cn" value="<%=subflowPerformer_cn%>" type="text" class="textclass" readonly>
    </td>
    <td class="deeptd">
        <!-- 子流程的处理人员选择。没有控制人员选择范围。 -->
        <img src="<%=request.getContextPath()%>/resources/images/actn133.gif"
             onclick="window.showModalDialog('<%=request.getContextPath()%>/address/tree.jsp?utype=1&sflag=0&count=1&fields=subflow_performer_cn,subflow_performer',window,'status:no;dialogWidth:300px;dialogHeight:380px;scroll:no;help:no;')">
    </td>
</tr>
<% }

    if (nextTransFlag) {%>
<tr id="flowOperationTr">
    <td width="120px" class="deeptd" rowspan="<%=nextTransList.size()+1%>">
        <% if (subflowFlag) {%>
        <INPUT TYPE="radio" class="radio" NAME="workflowOperationFlag" value='nextTrans'>
        <% }%>
        下一操作：
    </td>
    <td class="deeptd" width="200px">操作</td>
    <td class="deeptd" width="200px">下一步流程</td>
    <td class="deeptd" width="80px">时限</td>
    <td class="deeptd">处理人</td>
    <td class="deeptd" width="120px">&nbsp;</td>
</tr>
<% int sn = 1;
    String checked = "";
//		boolean isChecked = false;

    for (Iterator itr = nextTransList.iterator(); itr.hasNext(); ) {
        Transition transition = (Transition) itr.next();

        Activity activity = transition.getToActivity();

        String transName = transition.getTransName() == null ? "" : transition.getTransName();
        String transID = transition.getTransId() == null ? "" : transition.getTransId();
        String transDesc = transition.getDescription() == null ? "" : transition.getDescription();
        String activID = activity.getActivId() == null ? "" : activity.getActivId();
        String activName = activity.getActivName() == null ? "" : activity.getActivName();
        String performer = activity.getPerformer() == null ? "" : activity.getPerformer();
        //String performer_cn = activity.getPerformer_cn()==null?"":activity.getPerformer_cn();
        String performer_cn = "";
        try {
            if (!"".equals(performer)){
                performer_cn = UserManagerFactory.getUserManager().findUser(performer).getUsername();
            }else{
                Instance curInstance = flowTransmitInfo.getCurInstance();
                if (curInstance!= null) {
                    Collection requestList = WorkflowFactory.getRequestManager().getRequestListByInstanceWithSubflow(curInstance);
                    if (requestList.size() > 0) {
                        for (Iterator requestListItr = requestList.iterator(); requestListItr.hasNext();) {
                            Request oldRequest = (Request) requestListItr.next();
                            if(activID.equals(oldRequest.getActivId())){
                                performer = oldRequest.getParticipant();
                                performer_cn = oldRequest.getParticipant_cn();
                            }
                        }
                    }
                }
            }
        } catch (Exception ex) {
            System.out.println("Activ 用户读取错误！");
            performer_cn = "";
            performer = "";
        }

        if ("1".equals(transition.getTransFlag())) {
            checked = " checked ";
        } else if ("2".equals(transition.getTransFlag())) {
            checked = " disabled checked ";
        } else {
            checked = "";
        }
        if (!StringHelper.isNull(reqAction)) {
            StringReader xmlStr = new StringReader(reqAction);
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            DocumentBuilder builder = dbf.newDocumentBuilder();
            Document doc = builder.parse(new InputSource(xmlStr));
            String xpath = "/activities/activity[@transid='" + transID + "']";
            Element node = (Element) XPathAPI.selectSingleNode(doc, xpath);
            if (node != null) {
                if ("".equals(checked)) checked = "checked";
                Element pfNode = (Element) node.getFirstChild();
                if (pfNode != null) {
                    performer = pfNode.getAttribute("value");
                    performer_cn = pfNode.getAttribute("cvalue");
                }
            } else {
                checked = " ";
            }
            xmlStr.close();
        }
		String szdid=request.getParameter("szdid");
		String desc=activity.getDescription();
		
%>
<TR id="flowOperationTr">
    <TD class="tinttd">
        <% if ("XOR".equalsIgnoreCase(splitMode)) {%>
        <input name="flow_radio" type="radio" transdesc='<%=transDesc%>' radioIndex="<%=sn%>" <%=checked%>>
        <% } else if ("AND".equalsIgnoreCase(splitMode)) {%>
        <input name="flow_check_<%=sn%>" type="checkbox" transdesc='<%=transDesc%>' checked disabled>
        <% } else {%>
        <input name="flow_check_<%=sn%>" type="checkbox" <%=checked%> transdesc='<%=transDesc%>'>
        <% }%>
        <%=transName%>
    </TD>
    <TD class="tinttd">
        <%=activName%>
        <input name="activID_<%=sn%>" value="<%=activID%>" style="display:none">
        <input name="activName_<%=sn%>" value="<%=activName%>" style="display:none">
        <input name="transID_<%=sn%>" value="<%=transID%>" title="<%=transName%>" style="display:none">
    </TD>
    <TD class="tinttd">
        <%=activity.getDeadline() == null ? "无" : activity.getDeadline() + "小时"%>
    </TD>
    <TD class="tinttd">

        <% if (!(activity.getPerformerChoiceFlag() != null && "3".equals(activity.getPerformerChoiceFlag()))) {%>
        <input name="performer_<%=sn%>" value="<%=performer%>" type="hidden" readonly>
        <input name="performer_cn_<%=sn%>" value="<%=performer_cn%>" type="text" class="textclass" style="width:98%" readonly />
        <% } else {%>
        &nbsp;
        <% }%>
    </TD>
    <TD class="tinttd">
        <% if ("multi".equals(activity.getPerformerMode())) {%>
        <img style="cursor:default;" title="点击选择处理人" src="<%=request.getContextPath()%>/resources/images/actn133.gif"
             onclick="openSelWin('<%=request.getContextPath()%>/address/tree.jsp?utype=3&rtype=0&ptype=0&sflag=0&count=0&activid=<%=activID%>&fields=performer_cn_<%=sn%>,performer_<%=sn%>');setAutoChecked(<%=sn%>);">
			 <span id="<%=activID%>_default">&nbsp;</span><input type="button" value="保存默认" onclick="addActivityDefault('<%=activID%>','performer_cn_<%=sn%>','performer_<%=sn%>')">
			 <script>$(function(){getActivityDefault('<%=activID%>','performer_cn_<%=sn%>','performer_<%=sn%>');});</script>
        <% } else {%>
        <img style="cursor:default;" title="点击选择处理人" src="<%=request.getContextPath()%>/resources/images/actn133.gif"
             onclick="openSelWin('<%=request.getContextPath()%>/address/tree.jsp?utype=1&rtype=0&ptype=0&sflag=0&count=1&activid=<%=activID%>&fields=performer_cn_<%=sn%>,performer_<%=sn%>');setAutoChecked(<%=sn%>);">
			 <span id="<%=activID%>_default">&nbsp;</span><input type="button" value="保存默认" onclick="addActivityDefault('<%=activID%>','performer_cn_<%=sn%>','performer_<%=sn%>')">
			 <script>$(function(){getActivityDefault('<%=activID%>','performer_cn_<%=sn%>','performer_<%=sn%>');});</script>
        <% }%>
    </TD>
</TR>
<% sn++;
}
}%>
<%
    if (!"0".equals(curActivity.getShowmessageFlag())) {
        TagUtils tagUtils = TagUtils.getInstance();
        Messengerdata messengerManager = new Messengerdata();
        ArrayList arrayList_Messenger = (ArrayList) messengerManager.selMdata(userID);
        PersonalForm personalForm;
%>
<tr >
    <td class="deeptd">处理意见：
        <!--<a href="javascript:greturn()"
           onclick="window.showModalDialog('<%=request.getContextPath()%>/personal/getMessage.jsp?field=flow_message',window,'status:no;dialogWidth:475px;dialogHeight:280px;scroll:no;help:no;')"><font
                size=2><b>>></b></font></a>-->
    </td>
    <td class="tinttd" colspan="3" align="right" style="width:50%;">
        <textarea name="flow_message" cols="85" rows="10" class="textareaclass"><%=(message == null ? "" : tagUtils.filterFormat(tagUtils.filter(message)))%></textarea>
        <input type="hidden" name="flow_description" value="">
        <INPUT TYPE=button id="addMessBtn" onClick="addMess();" VALUE="保存当前批示" CLASS="formbutton">
    </td>
    <td class="tinttd" colspan="2" style="padding: 0;margin: 0;">
        <table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="table">
            <tr>
                <td class="deeptd" width="5%" height="46">个人批示 <!--<a href="<%=request.getContextPath()%>/personal/personalMessManager.jsp" style="font-style:bold;color:red;" title="点击编辑个人批示">>></a>--></td>
                <td class="tinttd" width="95%">
                    <select multiple id="messes" name="messes" size="9" style="width:400" class="text">
                        <%
                            for (int i = 0; i < arrayList_Messenger.size(); i++) {
                            PersonalForm personalFormi = (PersonalForm) arrayList_Messenger.get(i);
                        %>
                        <option title="<%=personalFormi.getMessenger()%>"><%=personalFormi.getMessenger()%></option>
                        <% } %>
                    </select>
                    <script>
                        $(function () {
                            $("#messes").dblclick(function () {
                                $("#messes option:selected").each(function () {
                                    $("textarea[name=flow_message]").val($("textarea[name=flow_message]").val() + $(this).val());
                                    $(this).removeAttr("selected");
                                });
                            });
                            $("#messes").click(function () {
                                $("#messes option:selected").each(function () {
                                    $("textarea[name=flow_message]").val($("textarea[name=flow_message]").val() + $(this).val());
                                    $(this).removeAttr("selected");
                                });
                            });
                        });
                        function addMess() {
							if($('textarea[name=flow_message]').val()!=''){
								$('#addMessBtn').attr('disabled',"true");
								$.ajax({
									async:true,
									type:"POST",
									url:"<%=request.getContextPath()%>/personal/getMessage.jsp",
									cache:false,
									dataType:'html',
									data:{
										action:"insert",
										mess:$('textarea[name=flow_message]').val()
									},
									success:function (result) {
										$("#messes").html(result);
										$('#addMessBtn').removeAttr("disabled");
										alert("保存批示成功！");
									},
									error:function () {
										$('#addMessBtn').removeAttr("disabled");
										alert("保存批示失败！");
									}
								});
							}else{
								alert("当前批示为空！");
							}
                        }
						function addActivityDefault(activ_id,performer_cn,performer) {
							if($("[name="+performer_cn+"]").val()!=''&&$("[name="+performer+"]").val()!=''){
								$.ajax({
									async:true,
									type:"POST",
									url:"<%=request.getContextPath()%>/workflow/flowActivityDefault.jsp",
									cache:false,
									dataType:'json',
									data:{
										action:"save",
										userid:'<%=userID%>',
										activ_id:activ_id,
										participant_cn:$("[name="+performer_cn+"]").val(),
										participant:$("[name="+performer+"]").val()
									},
									success:function (result) {
										if(result.success){
											getActivityDefault(activ_id,performer_cn,performer);
											alert("保存成功！");
										}else{
											alert("保存失败！");
										}
									},
									error:function () {
										alert("保存失败！");
									}
								});
							}else{
								alert("当前处理人为空！");
							}
                        }
						function getActivityDefault(activ_id,performer_cn,performer) {
							if(activ_id!=''){
								$.ajax({
									async:true,
									type:"POST",
									url:"<%=request.getContextPath()%>/workflow/flowActivityDefault.jsp",
									cache:false,
									dataType:'json',
									data:{
										action:"get",
										userid:'<%=userID%>',
										activ_id:activ_id
									},
									success:function (result) {
										if(result.success){
											$("#"+activ_id+"_default").html("<a href='javascript:void(0);' title='点击设置为当前处理人！' onclick='setActivityDefault(\""+performer_cn+"\",\""+performer+"\",\""+result.participant_cn+"\",\""+result.participant+"\")'>"+result.participant_cn+"</a>");
										}
									},
									error:function () {
										//alert("失败！");
									}
								});
							}
                        }
						function setActivityDefault(performer_cn,performer,participant_cn,participant) {
							$("[name='"+performer_cn+"']").val(participant_cn);
							$("[name='"+performer+"']").val(participant);
						}
                    </script>
                </td>
            </tr>
        </table>
    </td>
</tr>
<% }
    if (false) {%>
<tr style="display:none;">
    <td class="deeptd">签批意见：</td>
    <td class="tinttd" colspan="5" height="50px">
        <!--
		<INPUT TYPE=button
               onClick="window.showModalDialog('<%=request.getContextPath()%>/resources/handwrite/handWriter.html',window,'status:no;dialogWidth:650px;dialogHeight:450px;scroll:no;help:no;');"
               VALUE="手写签批" name="handwritebutton" CLASS="formbutton">
        
             <input type="button" onclick="DoHandDraw();" value="全文批注" name="handdrawbutton" class="formbutton" />
          -->
        <br>

        <div id="handlewritearea">
            <% if (handleFlag) {%>
            <img src="<%=request.getContextPath()+handlePath+"/"+handleName%>">
            <% }%>
        </div>
    </td>
</tr>
<% }
    int affixNumber = curActivity.getAffixNumber().intValue();
    affixNumber = 1;
    for (int i = 1; i <= affixNumber; i++) {
        String flow_attachment = "flow_attachment_0" + i;
%>
<tr style="display:none;">
    <td class="deeptd">其他意见：</td>
    <td class="tinttd" colspan="5">
        <html:file name="<%=flow_attachment%>"/>
    </td>
</tr>
<% }
    if (affixNumber > 0) {
        if (curRequest != null) {
            pageContext.setAttribute("curRequestID", curRequest.getReqId());%>
<tr style="display:none;">
    <td class="deeptd">附&nbsp;&nbsp;&nbsp;&nbsp;件：</td>
    <td class="tinttd" colspan="5">
        <html:attachment moduleid="workflow" unid="curRequestID"/>&nbsp;
    </td>
</tr>
<% }
}%>
<tr>
    <td class="deeptd">短信提醒：</td>
    <td class="tinttd" colspan="5">
        <input class=checkbox type=checkbox name=issmsremindchk id=issmsremindchk
               onclick="if(this.checked){document.getElementById('issmsremind').value=1 }else{document.getElementById('issmsremind').value=0};"><label
            for=issmsremindchk>短信提醒下一步处理人员</label><input type=hidden name=issmsremind id=issmsremind value="0">&nbsp;
		
		<!-- <input class=checkbox type=checkbox name=isjstxremindchk id=isjstxremindchk onpropertychange="if(this.checked){document.getElementById('isjstxremind').value=1}else{document.getElementById('isjstxremind').value=0};" >
		<label for=isjstxremindchk>即时通讯提醒下一步处理人员</label><input type=hidden name=isjstxremind id=isjstxremind value="0">&nbsp;
		
		<input class=checkbox type=checkbox name=issendmsnchk id=issendmsnchk onpropertychange="if(this.checked){document.getElementById('issendmsn').value=1}else{document.getElementById('issendmsn').value=0};" >
		<label for=issendmsnchk>短信提醒申请人</label><input type=hidden name=issendmsn id=issendmsn value="0">&nbsp;
		<input type=hidden name=issendmsn id=issendmsn value="0"/>
		<input type="hidden" name="smstemplate" value=""/> -->
    </td>
</tr>
<tr>
	<td colspan="6"></td>
</tr>
</table>
<input type="hidden" name="<%=Globals.TRANSACTION_TOKEN_KEY%>"
       value="<%=(String)session.getAttribute(Globals.TRANSACTION_TOKEN_KEY)%>"/>
</div>
<% }%>
<table border="0" style="border:1px solid black;display:none" width="100%">
    <tr>
        <td>
            子流程：<input value="" name="subflowID" style="display:none" readonly>
            子流程参与人：<input name="subflow_performerList" style="display:none" readonly>
        </td>
    </tr>
    <tr>
        <td>
            操作列表：<input value="" name="flow_transList" style="display:none" readonly>
            下一步活动：<input value="" name="flow_activList" style="display:none" readonly>
            参　与　人：<input value="" name="flow_performerList" style="display:none" readonly>
            参与人名称：<input value="" name="flow_performerCNList" style="display:none" readonly>
        </td>
    </tr>
    <tr>
        <td>
            <input name="flowID" value="<%=(flowID==null?"":flowID)%>" style="display:none" readonly>
            <input name="taskID" value="<%=(taskID==null?"":taskID)%>" style="display:none" readonly>
            <input name="instanceID" value="<%=(instanceID==null?"":instanceID)%>" style="display:none" readonly>
            <input name="moduleID" value="<%=(moduleID==null?"":moduleID)%>" style="display:none" readonly>
            <input name="submitMethod" value="0" style="display:none" readonly>
            <input name="encFlag" value="1" style="display:none" disabled>

            <!-- Begin 手写批注 -->
            <input name="handleservurl" value="<%=handleServUrl%>" style="display:none" readonly>
            <input name="handWritePath" value="<%=handlePath%>" style="display:none" readonly>
            <input name="handWriteName" value="<%=handleName%>" style="display:none" readonly>
            <input name="handWriteFlag" value="<%=(handleFlag?"1":"0")%>" style="display:none" readonly>
            <!-- End 手写批注 -->

        </td>
    </tr>
</table>
<script>
    /* 取得字符串的字节长度 */
    function checkstrlen(obj, strlen) {
        var i;
        var str = obj.value;
        var len;
        len = 0;
        for (i = 0; i < str.length; i++) {
            if (str.charCodeAt(i) > 255) {
                len += 2;
            } else {
                len++;
            }
        }
        if (len > parseInt(strlen)) {
            //alert("处理意见超出最大长度" + strlen);
            //return false;
        }
        return true;
    }
</script>
<script language="javaScript">
    function greturn() {
    }

    function setAutoChecked(sn) {
        var curcheckbox = document.all["flow_check_" + sn];
        if (curcheckbox != null && !curcheckbox.disabled) {
            if (document.all["performer_" + sn].value == null || document.all["performer_" + sn].value == "") {
                curcheckbox.checked = false;
            } else {
                curcheckbox.checked = true;
            }
        } else if (curcheckbox == null) {
            var flow_radios = document.all["flow_radio"];
            if (flow_radios != null) {
                for (i = 0; i < flow_radios.length; i++) {
                    if (flow_radios[i].radioIndex == sn) {
                        flow_radios[i].checked = true;
                        return;
                    }
                }
            }
        }
    }
    function checkperformer(alertStr) {
        if (alertStr != "") {
            alert(alertStr);
            return false;
        } else {
            return true;
        }
    }
    function submitFlow() {
        var workflowOperationFlag = document.all.workflowOperationFlag;
        var transAlert = "";
        if (workflowOperationFlag != null) {
            var operationFlag = "";
            if (workflowOperationFlag.length) {
                for (i = 0; i < workflowOperationFlag.length; i++) {
                    if (workflowOperationFlag[i].checked) {
                        operationFlag = workflowOperationFlag[i].value;
                        break;
                    }
                }
            } else {
                operationFlag = workflowOperationFlag.value;
            }

            if (operationFlag == "subflow") {
                initSubflow();
            } else {
                transAlert = initNextTrans();
            }
        } else {
            if (document.all.subflow_selection != null) {
                initSubflow();
            } else {
                transAlert = initNextTrans();
            }
        }

        return transAlert;
    }
    function initSubflow() {
        clearNextTrans();
        var subflow_selection = document.all.subflow_selection;
        var subflow_performer = document.all.subflow_performer;
        if (subflow_selection != null) {
            if (subflow_performer != null) {
                var subflow_performerList = document.all.subflow_performerList;
                var subflowID = document.all.subflowID;

                subflowID.value = subflow_selection.options[subflow_selection.selectedIndex].value;
                subflow_performerList.value = subflow_performer.value;
            }
        }
    }

    function clearSubflow() {
        document.all.subflow_performerList.value == "";
        document.all.subflowID.value == "";
    }

    function initNextTrans() {
        clearSubflow();
        var hasNextFlow = false;
        var alertStr = "";

        var i = 1;
        var transList = "";
        var activList = "";
        var performerList = "";
        var performerCNList = "";
        if (document.all["flow_radio"]) {
            var radioObj = document.all["flow_radio"];
            if (radioObj.length) {
                while (!hasNextFlow && (i <= radioObj.length)) {
                    if (radioObj[i - 1].checked) {
                        hasNextFlow = true;
                        var transID_obj = document.all["transID_" + i];
                        var activID_obj = document.all["activID_" + i];
                        var performer_obj = document.all["performer_" + i];
                        var performer_cn_obj = document.all["performer_cn_" + i];
                        transList += transID_obj.value + ";";
                        activList += activID_obj.value + ";";
                        if (performer_obj != null) {
                            if (performer_obj.value == "")
                                alertStr = "请确认已选择下一步流程办理人员";
                            performerList += performer_obj.value + ";";
                            performerCNList += performer_cn_obj.value + ";";
                        } else {
                            performerList += ";";
                            performerCNList += ";";
                        }
                    }
                    i++;
                }
            } else {
                if (radioObj.checked) {
                    hasNextFlow = true;
                    var transID_obj = document.all["transID_" + i];
                    var activID_obj = document.all["activID_" + i];
                    var performer_obj = document.all["performer_" + i];
                    var performer_cn_obj = document.all["performer_cn_" + i];
                    transList += transID_obj.value + ";";
                    activList += activID_obj.value + ";";
                    if (performer_obj != null) {
                        if (performer_obj.value == "")
                            alertStr = "请确认已选择下一步流程办理人员";
                        performerList += performer_obj.value + ";";
                        performerCNList += performer_cn_obj.value + ";";
                    } else {
                        performerList += ";";
                        performerCNList += ";";
                    }
                } else {
                }
            }
        } else {
            while (document.all["activID_" + i]) {
                if (document.all["flow_check_" + i].checked == true) {
                    hasNextFlow = true;
                    var transID_obj = document.all["transID_" + i];
                    var activID_obj = document.all["activID_" + i];
                    var performer_obj = document.all["performer_" + i];
                    var performer_cn_obj = document.all["performer_cn_" + i];
                    transList += transID_obj.value + ";";
                    activList += activID_obj.value + ";";
                    if (performer_obj != null) {
                        if (performer_obj.value == "")
                            alertStr = "请确认已选择下一步流程办理人员";
                        performerList += performer_obj.value + ";";
                        performerCNList += performer_cn_obj.value + ";";
                    } else {
                        performerList += ";";
                        performerCNList += ";";
                    }
                }
                i++;
            }
        }
        document.all.flow_transList.value = transList;
        document.all.flow_activList.value = activList;
        document.all.flow_performerList.value = performerList;
        document.all.flow_performerCNList.value = performerCNList;

        if (!hasNextFlow)
            alertStr = "请确认已选择下一步流程";

        return alertStr;
    }

    function clearNextTrans() {
        document.all.flow_activList.value = "";
        document.all.flow_performerList.value = "";
    }

    function setSubmitMethod(submitmethod) {
        document.all.submitMethod.value = submitmethod;
    }

    submitFlow();	

</script>

<!--索思奇智版权所有-->