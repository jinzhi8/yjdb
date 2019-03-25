<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.commons.orm.SimpleORMUtils"%>
<%@page import="java.util.List"%>
<%@page import="java.io.File"%>
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
	String realpath=request.getSession().getServletContext().getRealPath(path);
    File file=new File(realpath);
    if(!file.exists()){%>
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
	<html>
		<head>
		 <title>在线预览</title>
		 <style type="text/css">
		 .zxyl_imgbox{
		 	width: 100%;
		 	height: 100%;
		 	overflow: hidden;
		 }
		 .zxyl_imgbox img{
		 	max-width: 100%;
		 	max-height: 100%;
		 }
		 </style>
		</head>
		<body>
			<div class="zxyl_imgbox">
				文件传输中，请稍候!
			</div>
		</body>
	</html>	
<%  }else{
		dest=path;
		System.out.println("filepath:"+contextPath+dest);
		int d=dest.lastIndexOf(".");
		if(d>0){
			String suffix=dest.substring(d+1);
	        suffix = suffix.toLowerCase();		
			if("pdf".equals(suffix)){
%>
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
	<html>
	<head>
		<title>在线预览</title>
		<meta name="GENERATOR" content="MSHTML 8.00.7601.19104">
		<script language="javascript" type="text/javascript" charset="utf-8" src="<%=contextPath%>/resources/js/jquery/jquery-1.8.3.min.js"></script>
		<script language="javascript" type="text/javascript" charset="utf-8" src="<%=contextPath%>/resources/js/jquery/jquery.media.js"></script>
		<link href="<%=contextPath%>/resources/template/cn/css/css.css" rel="stylesheet" type="text/css">
		<SCRIPT type=text/javascript>
		$(function() {
			$('.media').media({
				width:980, 
				height:700,
				autoplay: true,
				src:'<%=contextPath+dest%>'
			});   
		});
	</SCRIPT>
	</head>
	<body class="media">
		
	</body>
	</html>
	<%}else if(".jpg,.jpeg,.gif,.png,.bmp".indexOf("."+suffix)>=0){%>
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
	<html>
		<head>
		 <title>在线预览</title>
		 <style type="text/css">
		 .zxyl_imgbox{
		 	width: 100%;
		 	height: 100%;
		 	overflow: hidden;
		 	text-align: center;
		 }
		 .zxyl_imgbox img{
		 	max-width: 100%;
		 	max-height: 100%;
		 	margin: 0 auto;
		 }
		 </style>
		</head>
		<body>
			<div class="zxyl_imgbox">
				<img src="<%=contextPath+dest%>" >
			</div>
		</body>
	</html>
	<%}else{%>
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
	<html>
		<head>
		 <title>在线预览</title>
		</head>
		<body>
			<div style="width:980px; height:600px;">
				当前文件格式不支持预览
			</div>
		</body>
	</html>	
<%		}
	}
}%>