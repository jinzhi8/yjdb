function openDocument(flowID, fileTypeID) {
    if (fileTypeID) {
        window.location.href = "../workflowEntry.do?flowid=" + flowID + "&typeid=" + fileTypeID; //当前页打开
        //window.open("../workflowEntry.do?flowid="+flowID+"&typeid="+fileTypeID);
    } else {
        window.location.href = "../workflowEntry.do?flowid=" + flowID;
        //window.open("../workflowEntry.do?flowid="+flowID);
    }
}
var userAgent = navigator.userAgent.toLowerCase();
var isNoIE=/(mozilla|opera|webkit)/.test(userAgent) && !/(compatible)/.test(userAgent);
if(isNoIE){
	window.dialogArguments = window.opener;
}
function selectFlow(moduleID){
	layer.open({
		type: 2,
		title: '窗口',
		fix: true,
		maxmin: false,
		area: ['345px', '250px'],
		content: "../workflow/selectFlow.jsp?moduleID=" + moduleID
	});
}
function selectFlowWithTemplates(moduleID,moduleCode,typeCode) {
    var urlstr = "../workflow/selectFlowWithTemplates.jsp?moduleID=" + moduleID +"&module="+moduleCode+"&type="+typeCode;
    window.showModalDialog(urlstr, window, 'status:no;dialogWidth:345px;dialogHeight:320px;scroll:no;help:no;');
}
function selectFileInfo() {
    window.showModalDialog('createFile.jsp?module=senddoc', window, 'status:no;dialogWidth:345px;dialogHeight:320px;scroll:no;help:no;');
}
