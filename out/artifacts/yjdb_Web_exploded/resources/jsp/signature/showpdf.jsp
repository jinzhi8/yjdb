<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.oa.wskzm.util.SimpleORMUtils"%>
<%@page import="java.util.List"%>
<%
	String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
	
	String docid=request.getParameter("docid");
	String moduleId=request.getParameter("moduleId");
	
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
    <title>电子签章</title>
    <meta name="GENERATOR" content="MSHTML 8.00.7601.19104">
	<script language="javascript" type="text/javascript" charset="utf-8" src="<%=contextPath%>/resources/js/jquery/jquery.js"></script>
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
			}else{
				alert("上传失败，错误代码："+lErrCode);
			}
		}
		
		
		function aa(){

			plugin.LoadUrlPdf("http://www.zjsos.net:11180/wskzm/wskzmweb/123.pdf","");
			//plugin.LoadUrlPdf("E:\Java\apache-tomcat-wf\webapps\test\111.pdf","");
			//plugin.SetRemoteServer("172.20.253.217", 80);
		}
		
		function choose(){
			var val=$("[name=file]").val();
			if(val!=''&&path.indexOf(".pdf")>0){
				plugin.LoadPdf(val,"");
			}else{
				alert("请选择待签章的PDF文件！");
			}
			
		}
		
		function wl(){
			plugin.LoadUrlPdf("http://www.zjsos.net:11180/wskzm/wskzmweb/123.pdf","");
		}
		
		function upload(){
			var pdfPath = plugin.CurrentCachePath;
			alert(pdfPath);
			plugin.uploadSignedFile(contextPath+"/resources/jsp/signature/upload.jsp",pdfPath, "docid=<%=docid%>&moduleId=<%=moduleId%>&type=dzqzwj");
		}
		
		
		
		function loadPdf(uuid,path){
			alert(111);
			if(path.indexOf(".pdf")>0){
				alert(111);
				plugin.LoadUrlPdf(contextPath+path,"");
			}else{
				alert(2222);
				$.ajax({
					type:"post",
					url:"<%=contextPath%>/resources/jsp/signature/transfor.jsp",
					data:{"uuid":uuid,"path":path},
					success:function(data){
						data=trim(data);
						if(data!='1'){
							alert(data);
							plugin.LoadUrlPdf(contextPath+data,"");
						}else{
							alert("转换失败，请重试！");
						}
					}
				});
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
		<table id="viewtable" class="viewlist">
		  <tbody>
			<tr class="head">
			  <th align="center" class="head" width="10%">行政区划代码</th>
			  <th align="center" class="head" width="21%">证明名称</th>
			</tr>
			<%
			SimpleORMUtils instance=SimpleORMUtils.getInstance();
			List<Object[]> list=instance.queryForList("select t.attachmentid,t.attachmentpath,t.attachmentname from COMMON_ATTACHMENT t where t.docunid=? and t.moduleid=? and (t.attachmentname like '%.doc' or t.attachmentname like '%.docx' or t.attachmentname like '%.pdf' )",docid,moduleId);
			for(int i=0,size=list.size();i<size;i++){
				Object[] os=list.get(i);
				String css=i%2==0?"wang":"yuan";
				
			%>
			<tr class="<%=css%>">
			  <td width="10%" align="center">
				<a href="javascript:void(0)" onclick="loadPdf('<%=os[0]%>','<%=os[1]%>')" hidefocus="true"><%=os[1]%></a></td>
			  <td width="21%" align="center">
				<a href="javascript:void(0)" onclick="loadPdf('<%=os[0]%>','<%=os[1]%>')" hidefocus="true"><%=os[2]%></a></td>
			</tr>
			<%}%>
		  </tbody>
		</table>

		<input type="file" name="file" value="">
		<input type="button" onclick="choose();" value="本地文件签章">
		<input type="button" onclick="upload();" value="保存签章文件">
		<br/><br/>
		
		<object classid="clsid:EAFFB28E-B6AD-4657-904D-51CD7941A3A4" id="plugin" width="100%" height="600px" class="float_left"/>
	</div>
</body>
</html>
