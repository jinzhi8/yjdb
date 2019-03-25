var AffixRegisterURL = "http://10.20.65.207/StampServer/interfaces/background/affixRegister.do";
var SendPrintURL = "http://10.20.65.207/StampServer/extend/interfaces/SendPrint.jsp";
var tempStampCEB = "C:\\ceb.ceb";
function showErr(){
	alert("请您下载电子公章系统控件并安装，如果已经安装请点击页面顶部提示栏运行加载项！");
	//location.href="<%=request.getContextPath()%>/help/stamp.exe";
}
function deleteFile(strFileName){
	var objCEBManage, lRet;
	try{
		objCEBManage = new ActiveXObject("StampPubCom.StampPubFuncCom");
	}catch(e){
		showErr();
		return false;
	}
	lRet = objCEBManage.DeleteFile(strFileName);
	delete objCEBManage;
	if(lRet=="0"){
		return true;
	}
	return false;
}
function HTTPUploadFile(UploadFileSrc,UploadFileURL){
	var nRet;
	var objPostRecv;
	try{
		objPostRecv = new ActiveXObject("ASPCom.PostRecv");
	}catch(e){
		showErr();
		return false;
	}
	if(objPostRecv&&typeof(objPostRecv)!='undefined'){
		nRet = objPostRecv.HTTPUploadFile(UploadFileSrc, UploadFileURL);
		delete objPostRecv;
		if ( nRet == "0" ){
			//alert(" http上载成功！");
			return true;
		}else{
			alert("http上载失败！错误返回值：" + nRet + objPostRecv.GetErrorMessage());
			return false;
		}
	}
}
function HTTPDownloadFile(strDownloadFileName,strDownloadURL){
	var nRet;
	var objPostRecv;
	try{
		objPostRecv = new ActiveXObject("ASPCom.PostRecv");
	}catch(e){
		showErr();
		return false;
	}
	if(objPostRecv&&typeof(objPostRecv)!='undefined'){
		nRet = objPostRecv.HTTPDownloadFile(strDownloadFileName, strDownloadURL)
		delete objPostRecv;
		if (nRet == "0" ){
			//alert("http下载成功！");
			return true;
		}else{
			alert("http下载失败！错误返回值：" + nRet + objPostRecv.GetErrorMessage());
			return false;
		}
	}else{
		showErr();
	}
	return false;
}
function SealStamp(strCEBFileName,UnitName,AffixRegisterURL,SendPrintURL){
	var objStampClientTool;
	var lRet = "";
	var strErrMessage = "";
	try{
		objStampClientTool  = new ActiveXObject("StampClientTool.StampTool");
	}catch(e){
		showErr();
		return false;
	}
	if(objStampClientTool&&typeof(objStampClientTool)!='undefined'){
		lRet = objStampClientTool.LocalSealStampEx2(strCEBFileName,UnitName,AffixRegisterURL,SendPrintURL,"<DeviceStyle>26</DeviceStyle>","");
		delete objStampClientTool;
		if(lRet != 0){
			strErrMessage = objStampClientTool.GetErrorMessage();
			alert("盖章失败原因:" +strErrMessage);
		}else{
			return true;
		}
	}else{
		showErr();
	}
	return false;
}
function VisualPrint(strCEBFileName,UnitName,SendPrintURL){
	var lRet = "";
	var objAutoPrint;
	try{
		objAutoPrint = new ActiveXObject("AutoPrintSvr.AutoPrint");
	}catch(e){
		showErr();
		return false;
	}
	if(objAutoPrint&&typeof(objAutoPrint)!='undefined'){
		lRet = objAutoPrint.VisualPrintLocalCEB(strCEBFileName,UnitName,SendPrintURL);
	}
	delete objAutoPrint;
}
function loadXML(xmlStr){
	var xmlDoc=null;
	//判断浏览器的类型
	//支持IE浏览器
	if(!window.DOMParser && window.ActiveXObject){   //window.DOMParser 判断是否是非ie浏览器
		var xmlDomVersions = ['MSXML.2.DOMDocument.6.0','MSXML.2.DOMDocument.3.0','Microsoft.XMLDOM'];
		for(var i=0;i<xmlDomVersions.length;i++){
			try{
				xmlDoc = new ActiveXObject(xmlDomVersions[i]);
				xmlDoc.async = false;
				xmlDoc.loadXML(xmlStr); //loadXML方法载入xml字符串
				break;
			}catch(e){
			}
		}
	}
	return xmlDoc;
}
function getCeb(strFileId,strBaseUrl,cebTitle,UnitName){
	if (strFileId == ""){
		return;
	}
	var xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
	var content = "action=getceb&uuid="+strFileId+"&moduleid=documents&doctype=cebattach&title="+encodeURIComponent(cebTitle)+"&timestamp="+(new Date()).getTime();
	xmlHttp.open("POST",strBaseUrl+"/documents/saveceb.jsp", false);
	xmlHttp.setRequestHeader("Content-Length", content.length);
	xmlHttp.setRequestHeader("CONTENT-TYPE", "application/x-www-form-urlencoded");
	xmlHttp.send(content);
	var responseStr = xmlHttp.responseText;
	var xml_dom = loadXML(responseStr);
	var result = xml_dom.selectSingleNode("//Result").text;
	if (result == "0"){
		var fileID = xml_dom.selectSingleNode("//FileID").text;
		var fileContent = xml_dom.selectSingleNode("//FileContent").text;
		var filePath = fileContent.substring(0,fileContent.lastIndexOf("/")+1);
		var fileName = fileContent.substring(fileContent.lastIndexOf("/")+1);
		if(HTTPDownloadFile(tempStampCEB,strBaseUrl+fileContent)){
			SealStamp(tempStampCEB,UnitName,AffixRegisterURL,SendPrintURL);
			if(HTTPUploadFile(tempStampCEB,strBaseUrl+"/documents/saveceb.jsp?action=saveceb&filepath="+filePath+"&filename="+fileName)){
				return fileContent;
			}			
		}
	}else if (result == "2"){
		setTimeout("getCeb('"+strFileId+"')", 1000);
	}else{
		//alert("error:"+xml_dom.selectSingleNode("//ErrorMsg").text);
	}
	return "";
}