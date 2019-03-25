<%@page language="java" contentType="text/html;charset=UTF-8" %>


<%
	String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
	
	
	
	
%>


<div id="msg" style="display:none;">
<div style="width:300px;border:#CCC solid 2px;text-align:center;">
	<div style="width:100%;line-height:20px;background-color:#CCC;font-size:12px;text-align:left">
		电子签章
	</div>
   <br/>
   <p><a href="<%=contextPath%>/resources/jsp/signature/showpdf.jsp" target="_blank">在线签章</a></p>
   <br/>
   <p><a href="<%=contextPath%>/resources/jsp/signature/showpdf.jsp" target="_blank">上传签章文件</a></p>
   <br/>
</div>
</div>

<div id="div1" style="position:fixed;_position:absolute;bottom:40px;left:40px;cursor:pointer;display:none">
	<div style="background-color:#FFF;height:200px;width:300px;padding:10px 5px 5px 15px" >
		<a href="javascript:void(0)" onclick="$('#div1').css('display','none');" style="cursor:pointer" ><span style="color:red;font-size:12px;float:right;">关闭</span></a>
		<span style="color:blue;font-size:14px;line-height:20px;font-weight:bold;">更新通知</span>
			<p>
				原数字印章转换控件升级,需重新安装数字印章转换控件,请点击此处下载.
			</p>
	</div>
</div>



<script>
function stamp(){
	$('#div1').css("display","none");
	//$('#tipsdiv').remove();
	//new tips({msg:$('#msg').html()});
}

var tips = function(options){
		//对象唯一标识
		//this.id = 'tips_' + new Date().getTime();
		this.id = 'tipsdiv';
		//对象宽高
		this.padding = options.padding || 0;
		this.msg = options.msg || '';
		//对象
		this.obj = document.createElement('div');
		//设置属性
		this.obj.id = this.id;
		this.obj.style.position = 'absolute';
		this.obj.style.margin = '0';
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
</script>