<%@page language="java" contentType="text/html;charset=UTF-8"%>
<%@page import="com.kizsoft.commons.commons.textReader.WordReader"%>
<%@page import="com.kizsoft.commons.commons.textReader.ExcelReader"%>
<%@page import="com.kizsoft.commons.commons.textReader.RtfReader"%>
<%@page import="com.kizsoft.commons.commons.textReader.WordExcelToHtml" %>
<%@page import="com.kizsoft.commons.commons.util.StringHelper" %>
<%@page import="java.util.regex.Matcher"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="java.io.File"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="com.kizsoft.commons.commons.attachment.AttachmentEntity"%>
<%@page import="com.kizsoft.commons.commons.attachment.AttachmentManager"%>
<%!
public long getFileSizes(File f) throws Exception{//取得文件大小
        long s=0;
        if (f.exists()) {
            FileInputStream fis = null;
            fis = new FileInputStream(f);
           s= fis.available();
        }
        return s;
    }
    // 递归
    public long getFileSize(File f)throws Exception//取得文件夹大小
    {
        long size = 0;
        File flist[] = f.listFiles();
        for (int i = 0; i < flist.length; i++)
        {
            if (flist[i].isDirectory())
            {
                size = size + getFileSize(flist[i]);
            } else
            {
                size = size + flist[i].length();
            }
        }
        return size;
    }
    public String FormetFileSize(long fileS) {//转换文件大小
        DecimalFormat df = new DecimalFormat("#.00");
        String fileSizeString = "";
        if (fileS < 1024) {
            fileSizeString = df.format((double) fileS) + "B";
        } else if (fileS < 1048576) {
            fileSizeString = df.format((double) fileS / 1024) + "KB";
        } else if (fileS < 1073741824) {
            fileSizeString = df.format((double) fileS / 1048576) + "MB";
        } else {
            fileSizeString = df.format((double) fileS / 1073741824) + "GB";
        }
        return fileSizeString;
    }


%>
<%
	String str = "";
	String attachmentName = "";
	String attachmentId = "";
	String attachmentPath = "";
	String uuid = request.getParameter("uuid");
	String view = request.getParameter("view");
	if (request.getHeader("User-Agent").toUpperCase().indexOf("MSIE") == -1){
		view = "text";
	} 
	AttachmentEntity attachmentEntity = new AttachmentEntity();
	AttachmentManager attachmentManager = new AttachmentManager();
	String getAttachmentPath = request.getParameter("path");
	attachmentEntity = attachmentManager.getAttachmentByUNID(uuid);
	if(attachmentEntity!=null){
		attachmentId = attachmentEntity.getAttachmentId();
		attachmentName = attachmentEntity.getAttachmentName();
		attachmentPath = attachmentEntity.getAttachmentPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<TITLE><%=attachmentName%></TITLE>
<%
		if("office".equals(view)){
		//以office格式预览--start
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
<script language="javascript" type="text/javascript" src="<%=request.getContextPath()%>/resources/js/ntko/ntko.js"></script>
<script language="JScript" for=TANGER_OCX event="OnDocumentClosed()">TANGER_OCX_bDocOpen = false;</script>
<script language="JScript" for=TANGER_OCX event="OnDocumentOpened(file,doc)">
function stripscript(s) 
{ 
var pattern = new RegExp("[`~!@#$^&*()=|{}':;',\\[\\]<>/?~！@#……&*——|{}‘；：”“']"); 
var rs = ""; 
for (var i = 0; i < s.length; i++) { 
rs = rs+s.substr(i, 1).replace(pattern, ''); 
} 
return rs; 
}
TANGER_OCX_bDocOpen = true;
TANGER_OCX_OBJ.WebFileName = stripscript('<%=attachmentName%>');
TANGER_OCX_OBJ.Caption  = '';
//TANGER_OCX_OBJ.SetReadOnly(true,""); 
</script>
<script language="JScript" for="TANGER_OCX" event="OnCustomButtonOnMenuCmd(btnPos,btnCaption,btnCmdid)">
	if(1 == btnCmdid){
		TANGER_OCX_OBJ.ShowDialog(2);
		TANGER_OCX_OBJ.CancelLastCommand = true;
	} else if(2 == btnCmdid){
		try{
			TANGER_OCX_OBJ.PrintOut(true);
		}catch(e){}
		TANGER_OCX_OBJ.CancelLastCommand = true;
	} else if(3 == btnCmdid){
		TANGER_OCX_OBJ.PrintPreview();
		TANGER_OCX_OBJ.CancelLastCommand = true;
	} else if(4 == btnCmdid){
		window.location.href="<%=request.getContextPath()%>/resources/jsp/docreader.jsp?uuid=<%=attachmentId%>";
		TANGER_OCX_OBJ.CancelLastCommand = true;
	}
</script>
<SCRIPT LANGUAGE="JavaScript">
var TANGER_OCX_bDocOpen = false; //标识是否已经打开了文档
var TANGER_OCX_OBJ = null; //标识控件对象
window.onload=function(){
	TANGER_OCX_OBJ = document.all("TANGER_OCX");
	TANGER_OCX_OBJ.FileNew = false;
	TANGER_OCX_OBJ.FileOpen = false;
	TANGER_OCX_OBJ.FileClose = false;
	TANGER_OCX_OBJ.FileSave = true;
	TANGER_OCX_OBJ.FileSaveAs = false;
	TANGER_OCX_OBJ.FilePrint = true;
	TANGER_OCX_OBJ.FilePrintPreview = true;
	TANGER_OCX_OBJ.FilePageSetup = true;
	TANGER_OCX_OBJ.FileProperties = false;
	TANGER_OCX_OBJ.IsShowEditMenu = false;
	TANGER_OCX_OBJ.IsShowInsertMenu = false;
	TANGER_OCX_OBJ.IsShowToolMenu = false;
	TANGER_OCX_OBJ.IsShowHelpMenu = false;
	TANGER_OCX_OBJ.DefaultOpenDocType = 1;
	//TANGER_OCX_OBJ.WebUserName = '';
	TANGER_OCX_OBJ.Titlebar = false;
	TANGER_OCX_OBJ.Menubar = true;
	TANGER_OCX_OBJ.ToolBars = false;
	TANGER_OCX_OBJ.Statusbar = true;
	TANGER_OCX_OBJ.Hidden2003Menus="编辑(&E);视图(&V);插入(&I);格式(&O);工具(&T);表格(&A);窗口(&W);帮助(&H);";	
	TANGER_OCX_OBJ.AddCustomButtonOnMenu(1," 保存 ",true,1);
	TANGER_OCX_OBJ.AddCustomButtonOnMenu(2," 打印 ",true,2);
	TANGER_OCX_OBJ.AddCustomButtonOnMenu(3," 打印预览 ",true,3);
	TANGER_OCX_OBJ.AddCustomButtonOnMenu(4," 使用文本方式查看 ",true,4);
	TANGER_OCX_OBJ.BeginOpenFromURL(window.location.protocol+"//"+window.location.host+"<%=request.getContextPath()%>/DownloadAttach?uuid=<%=attachmentId%>",false);
};
</SCRIPT>
</HEAD>
<BODY>
<script>LoadWebOffice('100%');</script>
</BODY>
</HTML>
<%
		//以office格式预览--end
		}else{
			String attachmentRealPath = "";
			String attachmentSize = "0KB";
			attachmentRealPath = request.getRealPath(attachmentPath);
			File attachmentFile = new File(attachmentRealPath);
			if(attachmentFile.exists()){
				long fileSize = getFileSizes(attachmentFile);
				if(fileSize>0){
					attachmentSize = FormetFileSize(fileSize);
					if(attachmentName.toLowerCase().indexOf(".xls")>-1){
						ExcelReader excelReader = new ExcelReader();
						try{
							str = excelReader.getTextFromExcel(attachmentRealPath);
						}catch(Exception e2){
							str = "";
						}
					}else if(attachmentName.toLowerCase().indexOf(".doc")>-1){
						if("html".equals(view)){
							WordExcelToHtml we = new WordExcelToHtml();
							str = we.WordToHtml(attachmentRealPath,request);
						}else{
							WordReader wordReader = new WordReader();
							try{
								str = wordReader.getTextFromWord(attachmentRealPath);
							}catch(Exception e){
								try{
									str = (new RtfReader()).getTextFromRtf(attachmentRealPath);
									str = StringHelper.replaceAll(str,"\n","<br/><p>");
									str = StringHelper.replaceAll(str,"\r","<br/><p>");
								}catch(Exception e2){
									str = "";
								}
							}
						}
					}
				}
			}else{
				str = "文件不存在!";
			}
%>
<style type="text/css">
html,body{background:#999; font-size:16px;line-height:1.5;}
div p{line-height:1.5;}
<%if(attachmentName.toLowerCase().indexOf(".xls")>-1){%>
.word{background:#fff; border:1px solid #333; min-height:600px; margin-left:auto; margin-right:auto; padding-left:72px; padding-right:72px; 
padding-top:35px;}
<%}else{%>
.word{width:650px; background:#fff; border:1px solid #333; min-height:600px; margin-left:auto; margin-right:auto; padding-left:72px; padding-right:72px; 
padding-top:35px;}
<%}%>
.word .header{font-size:12px; border-bottom: 1px solid #999; text-align:right; color:#999}
.word .body{}
.word .body .title{ text-align:center; color:#f00; font-size:22px;}
.word .body .content{min-height:600px; /*高度最小值设置为：100px*/ height:auto !important; /*兼容FF,IE7也支持 !important标签*/ height:600px; /*兼容ie6*/ overflow:visible;}
.word .body .content p{ text-indent:2em;} 
.word .footer{font-size:12px; border-top: 1px solid #999; text-align:right; color:#999; position:relative; top:0px; left:0px; padding-top:5px; margin-
bottom:70px;}
#thumb {text-align:center;}
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
<div class="word">
	<%if("html".equals(view)){%>
	<div class="header">您正在以HTML预览文件！&nbsp;<a style="color:red;text-decoration:none;" href="<%=request.getContextPath()%>/resources/jsp/docreader.jsp?view=text&uuid=<%=attachmentId%>">使用纯文本预览</a>&nbsp;<a style="color:red;text-decoration:none;" href="<%=request.getContextPath()%>/resources/jsp/docreader.jsp?view=office&uuid=<%=attachmentId%>">使用OFFICE预览</a><br/>&nbsp;原文件下载：<a style="color:red;text-decoration:none;" href="<%=request.getContextPath()%>/DownloadAttach?uuid=<%=attachmentId%>"><%=attachmentName%></a></div>
	<%}else{%>
	<div class="header">您正在以纯文本预览文件！<!--&nbsp;<a style="color:red;text-decoration:none;" href="<%=request.getContextPath()%>/resources/jsp/docreader.jsp?view=html&uuid=<%=attachmentId%>">使用HTML预览</a>-->&nbsp;<a style="color:red;text-decoration:none;" href="<%=request.getContextPath()%>/resources/jsp/docreader.jsp?view=office&uuid=<%=attachmentId%>">使用OFFICE预览</a><br/>&nbsp;原文件下载：<a style="color:red;text-decoration:none;" href="<%=request.getContextPath()%>/DownloadAttach?uuid=<%=attachmentId%>"><%=attachmentName%></a></div>
	<%}%>
    <div class="body">
    	<h1 class="title">&nbsp;<!--<%=attachmentName%>--></h1>
        <div class="content">
		<div id="thumb"></div>
        	<p><%=str%></p>
        </div>
    </div>
    <div class="footer"><div class="info">附件大小：<%=attachmentSize%>&nbsp;<br/>&nbsp;<br/>&nbsp;<br/></div></div>
</div>
</BODY>
</HTML>
<%
		}
	}else if(getAttachmentPath!=null&&!"".equals(getAttachmentPath)){
		String  attachStr = "";
		if(getAttachmentPath.toLowerCase().indexOf(".xls")>-1){
			ExcelReader excelReader = new ExcelReader();
			attachStr = excelReader.getTextFromExcel(request.getRealPath(getAttachmentPath));
		}else if(getAttachmentPath.toLowerCase().indexOf(".doc")>-1){
			if("html".equals(view)){
				WordExcelToHtml we = new WordExcelToHtml();
				try{
					attachStr = we.WordToHtml(request.getRealPath(getAttachmentPath),request);
				}catch(Exception e1){
					try{
						attachStr = (new RtfReader()).getTextFromRtf(request.getRealPath(getAttachmentPath));
						attachStr = StringHelper.replaceAll(attachStr,"\n","<br/><p>");
						attachStr = StringHelper.replaceAll(attachStr,"\r","<br/><p>");
					}catch(Exception e2){
						attachStr = "";
					}
				}
			}else{
				WordReader wordReader = new WordReader();
				try{
					attachStr = wordReader.getTextFromWord(request.getRealPath(getAttachmentPath));
				}catch(Exception e3){
					try{
						attachStr = (new RtfReader()).getTextFromRtf(request.getRealPath(getAttachmentPath));
						attachStr = StringHelper.replaceAll(attachStr,"\n","<br/><p>");
						attachStr = StringHelper.replaceAll(attachStr,"\r","<br/><p>");
					}catch(Exception e4){
						attachStr = "";
					}
				}
			}
		}
		out.println("<p>"+attachStr);
	}else{
		str = "文件不存在！";
	}
%>