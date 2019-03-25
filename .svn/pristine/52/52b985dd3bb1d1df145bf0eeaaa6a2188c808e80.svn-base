<%@page language="java" contentType="text/html;charset=UTF-8"%>
<%@page import="com.kizsoft.commons.commons.textReader.WordReader"%>
<%@page import="com.kizsoft.commons.commons.textReader.ExcelReader"%>
<%@page import="java.util.regex.Matcher"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="com.kizsoft.commons.commons.attachment.AttachmentEntity"%>
<%@page import="com.kizsoft.commons.commons.attachment.AttachmentManager"%>
<%
	String str = "";
	String attachmentName = "";
	String uuid = request.getParameter("uuid");
	String view = request.getParameter("view");
	if (request.getHeader("User-Agent").toUpperCase().indexOf("MSIE") == -1){
		view = "text";
	} 
	AttachmentEntity attachmentEntity = new AttachmentEntity();
	AttachmentManager attachmentManager = new AttachmentManager();
	attachmentEntity = attachmentManager.getAttachmentByUNID(uuid);
	if(attachmentEntity!=null){
		attachmentName = attachmentEntity.getAttachmentName();
%>
<HTML>
<HEAD>
<TITLE><%=attachmentName%></TITLE>
<%
		if("office".equals(view)){
%>
<style type="text/css">
html,body{
	overflow: hidden;
	margin:0px;
	border:0px;
	width: 100%;
	height: 100%;
}
</style>
<script type="text/javascript" charset="utf-8" src="<%=request.getContextPath()%>/resources/ocx/weboffice.js"></script>
<SCRIPT language=javascript event=NotifyCtrlReady for=WebOfficeObj>
//<!--
	WebOfficeObj_NotifyCtrlReady();
//-->
</SCRIPT>
<SCRIPT language=javascript tyle="text/javascript">
window.$=function(id) {return typeof id == 'string' ? document.getElementById(id) : id;}; 
var WebOfficeObj;
function WebOfficeObj_NotifyCtrlReady() {
	try{
		WebOfficeObj = $('WebOfficeObj');
		WebOfficeObj.OptionFlag |= 128;
		WebOfficeObj.OptionFlag &= 0xff7f;
		WebOfficeObj.LoadOriginalFile("../../DownloadAttach?uuid=<%=attachmentEntity.getAttachmentId()%>","<%out.print(attachmentEntity.getAttachmentName().substring(attachmentEntity.getAttachmentName().lastIndexOf(".")+1));%>");
		WebOfficeObj.SetWindowText("浙江索思科技有限公司版权所有", 0); 
		if('<%out.print(attachmentEntity.getAttachmentName().substring(attachmentEntity.getAttachmentName().lastIndexOf(".")+1));%>'=='doc'){
			WebOfficeObj.GetDocumentObject().ActiveWindow.ActivePane.DisplayRulers = false;
			WebOfficeObj.GetDocumentObject().ActiveWindow.ActivePane.View.Zoom.Percentage = 100;
			//Application.ActiveDocument.Windows(1).View.ShowParagraphs=false; 
			WebOfficeObj.GetDocumentObject().ActiveWindow.View.ShowParagraphs=false; 
		}
		//WebOfficeObj.HideMenuItem(0x6fcb); //保存，打印，打印预览，全屏
		WebOfficeObj.HideMenuItem(0x6fcf); //打印，打印预览，全屏
		WebOfficeObj.HideMenuArea("","","","");
		WebOfficeObj.HideMenuArea("hideall","","",""); 
		WebOfficeObj.ShowRevisions(0);
		WebOfficeObj.SetTrackRevisions(0);
		//WebOfficeObj.Save();
		//WebOfficeObj.PutSaved(1);
		//WebOfficeObj.AutoRecover.Enabled=false;
		WebOfficeObj.SaveInterval=0;
		WebOfficeObj.SetSecurity(0x02);
		WebOfficeObj.SetSecurity(0x04);
		WebOfficeObj.SetSecurity(0x08);
		//WebOfficeObj.ProtectDoc(1, 1, "0x0x0x0x0x");
	}catch(e){
		//alert("异常\r\nError:"+e+"\r\nError Code:"+e.number+"\r\nError Des:"+e.description);
	}
}
window.onunload = function() {
	try{
		$('WebOfficeObj').Close();
	}catch(e){
		//alert("异常\r\nError:"+e+"\r\nError Code:"+e.number+"\r\nError Des:"+e.description);
	}
}
</SCRIPT>
</HEAD>
<BODY>
<script>LoadWebOffice('100%');</script>
</BODY>
</HTML>
<%
		}else{
			if(attachmentName.toLowerCase().indexOf(".xls")>-1){
				ExcelReader excelReader = new ExcelReader();
				String attachmentPath = request.getRealPath("/")+attachmentEntity.getAttachmentPath();
				str = excelReader.getTextFromExcel(attachmentPath);
				str = "<div style=\"align:center;\"><span style=\"width:98%; line-height:1.8em; text-indent:20px; font-size:14px; border:#59ACFF 1px solid; background:#ECF5FF; margin:15px auto; padding:8px;\">您正在以文本格式查看文件！原文件下载：<a style=\"color:red;\" href=\""+request.getContextPath()+"/DownloadAttach?uuid="+attachmentEntity.getAttachmentId()+"\">"+attachmentEntity.getAttachmentName()+"</a></span></div><p style=\"text-indent:2em;\">&nbsp;</p>"+str;
			}else if(attachmentName.toLowerCase().indexOf(".doc")>-1){
				WordReader wordReader = new WordReader();
				String attachmentPath = request.getRealPath("/")+attachmentEntity.getAttachmentPath();
				str = wordReader.getTextFromWord(attachmentPath);
				str = "<div style=\"align:center;\"><span style=\"width:98%; line-height:1.8em; text-indent:20px; font-size:14px; border:#59ACFF 1px solid; background:#ECF5FF; margin:15px auto; padding:8px;\">您正在以文本格式查看文件！原文件下载：<a style=\"color:red;\" href=\""+request.getContextPath()+"/DownloadAttach?uuid="+attachmentEntity.getAttachmentId()+"\">"+attachmentEntity.getAttachmentName()+"</a></span></div><p style=\"text-indent:2em;\">&nbsp;</p>" + str;
			}
%>
<HTML>
<HEAD>
<TITLE><%=attachmentName%></TITLE>
<link href="<%=request.getContextPath()%>/resources/css/css.css" rel="stylesheet" type="text/css">
<style type="text/css">
p{text-indent:2em;}
.excel{
border-collapse:collapse;
border-spacing:0;
border:1px solid #000000;
}
.excel td {
padding: 0;
border:1px solid #000000;
}
</style>
</HEAD>
<BODY>
<TABLE CLASS="outline" border="0" align=center bgcolor="#000000" WIDTH="700px" CELLSPACING=0 CELLPADDING=0><TR VALIGN=top><TD bgcolor="#808080" WIDTH="100%">
<div align="center">
<table border="0" cellpadding="0" cellspacing="0" style="MARGIN-LEFT: 20px;MARGIN-BOTTOM: 20px; MARGIN-RIGHT: 20px; MARGIN-TOP: 20px">
<tr><td valign="top"><table border="0" cellpadding="0" cellspacing="0"><tr>
<td bgcolor="#ffffff" style="BORDER-BOTTOM: #000000 1px solid; BORDER-LEFT: #000000 1px solid; BORDER-RIGHT: #000000 1px solid; BORDER-TOP: #000000 1px solid" nowrap width="700" height="842" valign="center">
<div align="center" style="MARGIN-LEFT: 20px;MARGIN-BOTTOM: 30px; MARGIN-RIGHT: 20px; MARGIN-TOP: 40px">
<table border="0" cellpadding="0" cellspacing="0" width="685" height="740"><tr><td  width="100%" valign="top">
<table border="0" width="680px" class="showpage"><tr><td valign="top" style="font-size:12pt;">
<%=str%>
</td></tr></table>
</td></tr></table></div></td><center><td width="3" valign="top"><table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%"><tr><td width="3" height="3"></td></tr><tr><td width="100%" bgcolor="#000000" height="*">&nbsp;</td></tr></table></td></center></tr></table></td></tr><tr><td valign="top" height="3"><table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%"><tr><td width="3"></td><td bgcolor="#000000"><font style="line-height:1px; FONT-SIZE: 1px" >&nbsp;</font></td></tr></table></td></tr></table></div>
</td></tr></table>
</BODY>
</HTML>
<%
		}
	}else{
		str = "文件不存在！";
	}
%>
