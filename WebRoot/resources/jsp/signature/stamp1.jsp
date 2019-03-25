<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.oa.wskzm.util.SimpleORMUtils"%>
<%@page import="java.util.List"%>

<%
	String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
	String docid=request.getParameter("docid");
	String moduleId=request.getParameter("moduleId");
%>
<script>
function stamp() { 
	showBg();
	new tips({msg:$('#mainQz').html(),id:"mainDiv"});
} 

function closeQz(){
	//closeBg();
	$("#mainDiv").css("overflow","hidden");
}

function showZxqz(){
	//overflow:hidden
	//$("#dialogZxqz").css("overflow","hidden");
	$("#dialogZxqz").show(); 
}
function closeZxqz(){
	$("#dialogZxqz").css("overflow","hidden");
	$("#dialogZxqz").hide(); 
}

function showUp(){
	$("#dialogUp").show(); 
}
function closeUp(){
	$("#dialogUp").hide(); 
}

function showBdqz(){
	
}



var tips = function(options){
		//对象唯一标识
		//this.id = 'tips_' + new Date().getTime();
		this.id = options.id;
		//对象宽高
		this.padding = options.padding || 0;
		this.msg = options.msg || '';
		//对象
		this.obj = document.createElement('div');
		//设置属性
		this.obj.id = this.id;
		this.obj.style.position = 'absolute';
		this.obj.style.margin = '0';
		this.obj.style.zIndex= 5;
		this.obj.style.backgroundColor = '#FFF';
		this.obj.style.padding = this.padding + 'px';
		this.obj.innerHTML = this.msg;
		//加入到body
		document.body.appendChild(this.obj);
		//实际高度
		this.width = document.getElementById(this.id).offsetWidth;
		this.height = document.getElementById(this.id).offsetHeight;
		//设置top left
		var body = (document.compatMode && document.compatMode!="BackCompat")? document.documentElement : document.body;
		var left = body.scrollLeft + (body.clientWidth - this.width)/2;
		var top = body.scrollTop + (body.clientHeight - this.height)/2;
		//更改位置
		this.obj.style.left = left + 'px';
		this.obj.style.top = top + 'px';
		this.html = function(html){
			document.getElementById(this.id).innerHTML = html;
		};
		//关闭
		this.close = function(){
			document.getElementById(this.id).style.display = 'none';
		};
	};



function loadPdf(uuid,path){
	window.showModalDialog('<%=request.getContextPath()%>/resources/jsp/signature/pdfqz.jsp?uuid='+uuid,window,'status:no;dialogWidth:1000px;dialogHeight:600px;scroll:yes;help:no;');	
	/*if(path.indexOf(".pdf")>0){
		plugin.LoadUrlPdf(contextPath+path,"");
	}else{
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
	}*/
}





//关闭灰色 jQuery 遮罩 
function closeBg() { 
	$("#fullbg").hide(); 
} 
//打开灰色 jQuery 遮罩 
function showBg(){
	var bh = $(document).height();  
	var bw = $(document).width(); 
	$("#fullbg").css({ 
		height:bh, 
		width:bw, 
		display:"block" 
	}); 
}


</script>
<style>
.fullbg { 
	background-color:gray; 
	left:0; 
	opacity:0.5; 
	position:absolute; 
	top:0; 
	z-index:3; 
	filter:alpha(opacity=50); 
	-moz-opacity:0.5; 
	-khtml-opacity:0.5; 
	display:none;
} 
.dialog { 
	background-color:#fff; 
	border:5px solid rgba(0,0,0, 0.2);
	height:100%;
	padding:1px; 
	position:fixed !important; /* 浮动对话框 */ 
	position:absolute;
	width:100%;
	border-radius:5px; 
	
} 
.dialog p { 
	margin:0 0 12px; 
	height:24px; 
	line-height:24px; 
	background:#CCCCCC; 
} 

.dialog .close {
	text-align:right; 
	padding-right:10px; 
	float:right 
} 
.dialog .close a { 
	color:#fff; 
	text-decoration:none; 
} 

.dialog .title { 
	margin:0 0 0 5px; 
	height:24px; 
	line-height:24px; 
	color:#fff; 
	float:left;
} 


</style>

<div id="fullbg" class="fullbg"></div>
<div style="display:none;">
	<div id="mainQz">
		<div id="dialogQz" class="dialog" style="width:200px;height:150px;"> 
			<p style="width:100%"><span class="title">签章</span>  <span class="close"><a href="#" onclick="closeQz();">关闭</a></span></p> 
			<div style="width:100%;text-align:left;padding-left:50px;">
				<span style="line-height:30px;"><a href="javascript:void(0);" onclick="showZxqz();">在线签章</a><span><br/>
				<span style="line-height:30px;"><a href="javascript:void(0);" onclick="showUp();">上传签章文件</a></span><br/>
				<span style="line-height:30px;"><a href="javascript:void(0);" onclick="showBdqz()">本地文件签章</a></span>
			</div>
		</div>
	</div>
	
	<div id="mainZxqz">
		<div id="dialogZxqz" class="dialog"> 
			<p style="width:100%"><span class="title">在线签章</span>  <span class="close"><a href="#" onclick="closeZxqz();">关闭</a></span></p> 
			<div style="width:100%;text-align:left;">
				<table id="viewtable" class="viewlist">
				<tr class="head">
				  <th align="center" class="head" width="80%">文件名称</th>
				  <th align="center" class="head" width="20%">操作</th>
				</tr>
				<%
				System.out.println(docid);
				System.out.println(moduleId);
				
				SimpleORMUtils instance=SimpleORMUtils.getInstance();
				List<Object[]> list=instance.queryForList("select t.attachmentid,t.attachmentpath,t.attachmentname from COMMON_ATTACHMENT t where t.docunid=? and t.moduleid=? and (t.attachmentname like '%.doc' or t.attachmentname like '%.docx' or t.attachmentname like '%.pdf' )",docid,moduleId);
				for(int i=0,size=list.size();i<size;i++){
					Object[] os=list.get(i);
					String css=i%2==0?"wang":"yuan";
					
				%>
				<tr class="<%=css%>">
				  <td width="10%" align="center">
					<%=os[2]%>	
				  </td>
				  <td width="21%" align="center">
					<a href="javascript:void(0)" onclick="loadPdf('<%=os[0]%>','<%=os[1]%>')" hidefocus="true">签章</a></td>
				</tr>
				<%}%>
				</table>
			</div> 
		</div> 
	</div> 
	
	<div id="mainUp">
		<div id="dialogUp" class="dialog"> 
			<p style="width:100%"><span class="title">上传签章文件</span>  <span class="close"><a href="#" onclick="closeUp();">关闭</a></span></p> 
			<div style="width:100%;text-align:center;">
				<input type="file" name="file"/><br/><br/>
				<input type="button" value="上传"/>
			</div> 
		</div> 
	</div> 
</div>