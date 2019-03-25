<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.oa.wskzm.util.SimpleORMUtils"%>
<%@page import="java.util.List"%>
<%@page import="com.kizsoft.oa.wskzm.util.DocConverter" %>


<%
	String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
	String uuid=request.getParameter("uuid");
	SimpleORMUtils instance=SimpleORMUtils.getInstance();
	boolean flag=false;
	List<Object[]> list=instance.queryForList("select t.attachmentid,t.attachmentpath,t.attachmentname from COMMON_ATTACHMENT t where t.attachmentid=?",uuid);
	String path="";
	String dest="";
	if(list!=null&&list.size()>0){
		Object[] os=list.get(0);
		path=(String)os[1];
	}
	if(path.endsWith(".doc")||path.endsWith(".docx")){
		dest=path.substring(0,path.lastIndexOf("."))+".pdf";
		String srcpath=request.getSession().getServletContext().getRealPath(path);
		String destpath=request.getSession().getServletContext().getRealPath(dest);
		flag=DocConverter.doc2pdf(srcpath,destpath);
	}else{
		dest=path;
	}
	int d=dest.lastIndexOf(".");
	if(d>0){
		String suffix=dest.substring(d+1); 
		if("pdf".equals(suffix)){
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
    <title>在线预览</title>
    <meta name="GENERATOR" content="MSHTML 8.00.7601.19104">
	<script language="javascript" type="text/javascript" charset="utf-8" src="<%=contextPath%>/resources/js/jquery/jquery.js"></script>
	<link href="<%=contextPath%>/resources/template/cn/css/css.css" rel="stylesheet" type="text/css">
	<script>
	
		var contextPath=window.location.protocol+"//"+window.location.host+"<%=contextPath%>";
		//alert(contextPath);
		var plugin;
		$(function(){
			plugin=document.getElementById("plugin");
			plugin.DisplayToolButton(417,0);
			plugin.DisplayToolButton(400,0);//隐藏打开
			plugin.DisplayToolButton(205,0);//隐藏保存
			plugin.DisplayToolButton(487,0);//隐藏手写签章
			
			plugin.DisplayToolButton(483,0);
			plugin.DisplayToolButton(485,0);
			plugin.DisplayToolButton(488,0);
			plugin.DisplayToolButton(489,0);
			plugin.DisplayToolButton(484,0);
			
			plugin.SetFileZoom(100);
			//plugin.SetRemoteServer("172.20.253.217", 80);
			//plugin.DisplayToolButton(402,1);
			//plugin.EnableToolButton(402,1);
			//plugin.ControlToolBar(2);
			//plugin.attachEvent("OnLoadUrlFinish", jsOnLoadUrlFinish);//成功打开网络PDF文件时触发。
			//plugin.attachEvent("OnSignFinish", jsOnSignFinish);//签章完成时触发。
			//plugin.attachEvent("OnUploadFinish", jsOnUploadFinish);//文件上传完成时触发。
			//alert(plugin.Version);
			plugin.LoadUrlPdf(contextPath+"<%=dest%>","");
		});
		
		function jsOnLoadUrlFinish(lType, lErrCode){
			if(lErrCode == 0){
				alert("文件装载成功");
			}else{
				alert("文件装载失败，错误代码："+lErrCode);
			}
		}
		
		function jsOnSignFinish (lType, lErrCode){
			if(lErrCode == 0){
				alert("签章成功");
			}else{
				alert("签章失败，错误代码："+lErrCode);
			}
		}
		
		function jsOnUploadFinish (lType, lErrCode){
			if(lErrCode == 0){
				alert("上传成功");
				window.returnValue = "1";
			}else{
				alert("上传失败，错误代码："+lErrCode);
				window.returnValue = "0";
			}
		}
		function choose(){
			var val=$("[name=file]").val();
			if(val!=''&&val.indexOf(".pdf")>0){
				plugin.LoadPdf(val,"");
			}else if(val.indexOf(".doc")>0||val.indexOf(".docx")>0){
				var pdf=val.substring(0,val.lastIndexOf('.'))+'.pdf';
				alert(pdf);
				plugin.LoadPdf(pdf,"");
			}else{
				alert("请选择待签章的PDF文件！");
			}
		}
		
	
		function trim(str){ //删除左右两端的空格
			if(str==''||str==undefined){
				return '';
			}
	　　     return str.replace(/(^\s*)|(\s*$)/g, "");
	　　 }
	</script>
</head>
<body>
	<div style="text-align:center">
		<object classid="clsid:EAFFB28E-B6AD-4657-904D-51CD7941A3A4" id="plugin" width="100%" height="600px" class="float_left"/>
	</div>
</body>
</html>

	<%}else if(".jpg,.jpeg,.gif,.png,.bmp".indexOf("."+suffix)>=0){
		System.out.println(contextPath+dest);
	%>
	<html>
		<head>
		 <title>在线预览</title>
		</head>
		<body>
			<div style="width:980px; height:600px;">
				<img src="<%=contextPath+dest%>" style="width:100%;">
			</div>
		</body>
	</html>
	<%}
}%>