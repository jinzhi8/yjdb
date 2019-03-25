<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.oa.wskzm.util.SimpleORMUtils"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.kizsoft.oa.wskzm.util.DocConverter" %>
<%@ page import="com.kizsoft.commons.commons.user.User" %>
<%@ page import="com.kizsoft.oa.wskzm.manager.ServiceUtils" %>

<%
	
	if (session.getAttribute("userInfo") == null) {
		response.sendRedirect(request.getContextPath() + "/login.jsp");
	}
	User userInfo = (User) session.getAttribute("userInfo");
	String userID = userInfo.getUserId();
	String userName = userInfo.getUsername();
	
	String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
	String uuid=request.getParameter("uuid");
	String docid=request.getParameter("docid");
	String moduleId=request.getParameter("moduleId");
	
	SimpleORMUtils instance=SimpleORMUtils.getInstance();
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy年MM月dd日");
	boolean flag=false;
	String path="";
	String data="";
	
	String action=request.getParameter("action");
	String act=request.getParameter("act");
	if("transfor".equals(action)){
		List<Object[]> list=instance.queryForList("select t.attachmentid,t.attachmentpath,t.attachmentname from COMMON_ATTACHMENT t where t.attachmentid=?",uuid);
		
		if(list!=null&&list.size()>0){
			Object[] os=list.get(0);
			path=(String)os[1];
		}
		
		System.out.println(uuid+"               "+path);
		
		//if(path.lastIndexOf(".")>0&&!path.endsWith(".pdf")){
			//dest=path.substring(0,path.lastIndexOf("."))+".pdf";
			//String srcpath=request.getSession().getServletContext().getRealPath(path);
			//String destpath=request.getSession().getServletContext().getRealPath(dest);
			//flag=DocConverter.doc2pdf(srcpath,destpath,false);
		Map<String,String> map=new HashMap<String,String>();
		map.put("date",sdf.format(new Date()));
		map.put("dept",userName);
		data=DocConverter.converter(request,path,map,true);
		System.out.println(data);
		if(data.endsWith(".pdf"))
			flag=true;
		out.println("{\"success\":"+flag+",\"data\":\""+data+"\"}");
		return;
	}else if("sczm".equals(action)){
		path="/wskzmweb/template/"+moduleId+".doc";
		///System.out.println("select * from "+moduleId+" where unid=?     "+docid);
		//Map<String,Object> omap=instance.queryForUniqueMap("select * from "+moduleId+" where unid=?",docid);
		Map<String,String> map=ServiceUtils.findZmMap(moduleId,docid);
		map.put("date",sdf.format(new Date()));
		map.put("dept",userName);
		data=DocConverter.converterTemplate(request,path,map,false);
		System.out.println(data);
		if(data.endsWith(".pdf"))
			flag=true;
		out.println("{\"success\":"+flag+",\"data\":\""+data+"\"}");
		return;
	}
	
%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
    <title>电子签章</title>
    <meta name="GENERATOR" content="MSHTML 8.00.7601.19104">
	<script language="javascript" type="text/javascript" charset="utf-8" src="<%=contextPath%>/resources/js/jquery/jquery1.3.js"></script>
	<link href="<%=contextPath%>/resources/template/cn/css/css.css" rel="stylesheet" type="text/css">
	<script>
	
		var contextPath=window.location.protocol+"//"+window.location.host+"<%=contextPath%>";
		//alert(contextPath);
		var plugin;
		$(function(){
			plugin=document.getElementById("plugin");
			plugin.DisplayToolButton(400,0);//隐藏打开
			plugin.DisplayToolButton(205,0);//隐藏保存
			plugin.DisplayToolButton(487,0);//隐藏手写签章
			plugin.SetFileZoom(100);
			//plugin.SetRemoteServer("172.20.253.217", 80);
			//plugin.DisplayToolButton(402,1);
			//plugin.EnableToolButton(402,1);
			//plugin.ControlToolBar(2);
			plugin.attachEvent("OnLoadUrlFinish", jsOnLoadUrlFinish);//成功打开网络PDF文件时触发。
			plugin.attachEvent("OnSignFinish", jsOnSignFinish);//签章完成时触发。
			plugin.attachEvent("OnUploadFinish", jsOnUploadFinish);//文件上传完成时触发。
			//alert(plugin.Version);
			<%if(act!=null&&!"".equals(act)){%>
				if(confirm("生成转化待签章文件需要十几秒的时间，是否转化？")){
					$.ajax({
						type:"post",
						url:"<%=contextPath%>/resources/jsp/signature/pdfqz.jsp",
						data:{"uuid":"<%=uuid%>","action":"<%=act%>","moduleId":"<%=moduleId%>","docid":"<%=docid%>"},
						success:function(data){
							//alert(data);
							var json=eval("("+trim(data)+")");
							if(json.success){
								plugin.LoadUrlPdf(contextPath+json.data,"");
							}else{
								alert("转换失败，"+json.data);
							}
						}
					});
				}
			<%}%>
			
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
				/*var pdf=val.substring(0,val.lastIndexOf('.'))+'.pdf';
				alert(pdf);
				plugin.ConvertWordFileToPdf(val,pdf);
				plugin.LoadPdf(pdf,"");*/
				$("#fileForm").ajaxSubmit({
					type: "post",
					url: "<%=request.getContextPath()%>/resources/jsp/signature/convertWordFileToPdf.jsp",
					success: function (data) {
						data=trim(data);
						if(data.indexOf(".pdf")){
							plugin.LoadUrlPdf(contextPath+data,"");
						}else{
							alert("文件转换失败！");  
						}
					}
				});
			}else{
				alert("请选择待签章的PDF文件！");
			}
		}
		
		function upload(){
			var pdfPath = plugin.CurrentCachePath;
			//alert(pdfPath);
			if(pdfPath==''){
				alert("请打开要盖章的文件！");
				return ;
			}
			var url=contextPath+"/resources/jsp/signature/upload.jsp?docid=<%=docid%>&moduleId=<%=moduleId%>&type=dzqzwj&uuid=<%=uuid%>";
			//alert(url);
			plugin.uploadSignedFile(url,pdfPath, "");
			
			window.close();
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
	<br/>
	<div style="text-align:center">
		<form id='fileForm' enctype='multipart/form-data'>
			<label>请选择签章文件：<label><input type="file" name="file" value="" onchange="choose();">
			<!--<input type="button" onclick="choose();" value="本地证明签章">-->
			<input type="button" onclick="upload();" value="保存签章证明">
		</form>
		<object classid="clsid:EAFFB28E-B6AD-4657-904D-51CD7941A3A4" id="plugin" width="100%" height="550px" class="float_left"/>
	</div>
</body>
</html>
