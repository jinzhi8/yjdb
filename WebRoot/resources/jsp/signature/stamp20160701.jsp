<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.oa.wskzm.util.SimpleORMUtils"%>
<%@page import="java.util.List"%>

<%
	String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
	String docid=request.getParameter("docid");
	String moduleId=request.getParameter("moduleId");
	
	
%>
<style>
	.black_overlay{ 
		display: none; 
		position: absolute; 
		top: 0%; 
		left: 0%; 
		width: 100%; 
		height: 100%; 
		background-color: black; 
		z-index:1001; 
		-moz-opacity: 0.8; 
		opacity:.80; 
		filter: alpha(opacity=80); 
	} 
	.white_content { 
		display: none; 
		position:fixed;
		_position:absolute;
		padding: 16px; 
		border: 8px solid orange; 
		background-color: white; 
		z-index:1002; 
		overflow: auto;
	}
</style>

<script>
	function stamp(){
		if(sfqz()=="1"&&!confirm("已经存在签章证明，是否重新签章？")){
			return;
		}
		var bh = $(document).height()+20;  
		var bw = $(document).width()-18;
		$('#divQz').css('display','block');
		$("#fade").css({ 
			height:bh, 
			width:bw, 
			display:"block" 
		});
	}
	
	
	function validateFormsp(){
		if(sfqz()=="0"&&confirm("该证明不存在签章证明，是否进行签章？")){
			stamp();
			return false;
		}
		return validateForm();
	}
	
	
	function closeQz(){
		$('#divQz').css('display','none');
		$('#fade').css('display','none');
	}
	
	
	function showZxqz(){
		$('#divZxqz').css('display','block');
	}
	function closeZxqz(){
		$('#divZxqz').css('display','none');
		closeQz();
	}
	
	function showUp(){
		$('#divUp').css('display','block');
	}
	
	function closeUp(){
		$('#divUp').css('display','none');
		closeQz();
	}
	
	function upload(){
		 $("#fileForm").ajaxSubmit({
            type: "post",
            url: "<%=request.getContextPath()%>/resources/jsp/signature/upload.jsp",
            success: function (data) {
				data=trim(data);
				if(data=='1'){
					alert("文件上传成功！");
					window.location.href=window.location.href;
				}else{
					alert("文件上传失败！");
				}
            },
            error: function (msg) {
               alert("文件上传失败！");    
            }
        });
	}
	
	
		function sfqz(){
			/*$.ajax({
				type:"post",
				url:"<%=request.getContextPath()%>/resources/jsp/signature/sfqz.jsp",
				data:{"docid":"<%=docid%>","moduleId":"<%=moduleId%>","type":"dzqzwj"},
				success:function(data){
					alert(data);
				}
			});
			*/
			
			var flag='';
			 $.ajax({
				type: "post",
				url: "<%=request.getContextPath()%>/resources/jsp/signature/sfqz.jsp",
				data:{"docid":"<%=docid%>","moduleId":"<%=moduleId%>","type":"dzqzwj"},
				async:false,
				success: function (data) {
					data=trim(data);
					flag=data;
				}
			});
			return flag
			
	}
	
	
	function showBdqz(){
		var retval=window.showModalDialog('<%=request.getContextPath()%>/resources/jsp/signature/pdfqz.jsp?docid=<%=docid%>&moduleId=<%=moduleId%>',window,'status:no;dialogWidth:980px;dialogHeight:600px;scroll:yes;help:no;');
		//alert("showBdqz"+retval);
		if(retval=='1'){
			closeQz();
			window.location.href=window.location.href;
		}
	}
	
	
	function loadPdf(uuid,path){
		var retval=window.showModalDialog('<%=request.getContextPath()%>/resources/jsp/signature/pdfqz.jsp?docid=<%=docid%>&moduleId=<%=moduleId%>&uuid='+uuid,window,'status:no;dialogWidth:980px;dialogHeight:600px;scroll:yes;help:no;');
		//alert("loadPdf"+retval);
		if(retval=='1'){
			closeZxqz();
			window.location.href=window.location.href;
		}
	}
	
	function trim(str){ //删除左右两端的空格
		if(str==''||str==undefined){
			return '';
		}
　　     return str.replace(/(^\s*)|(\s*$)/g, "");
　　 }
	
	
	$(function(){
		/*
		var    s  =  "网页可见区域宽："+  document.body.clientWidth;  
			s  +=  "\r\n网页可见区域高："+  document.body.clientHeight;  
			s  +=  "\r\n网页可见区域高："+  document.body.offsetWeight  +"  (包括边线的宽)";  
			s  +=  "\r\n网页可见区域高："+  document.body.offsetHeight  +"  (包括边线的宽)";  
			s  +=  "\r\n网页正文全文宽："+  document.body.scrollWidth;  
			s  +=  "\r\n网页正文全文高："+  document.body.scrollHeight;  
			s  +=  "\r\n网页被卷去的高："+  document.body.scrollTop;  
			s  +=  "\r\n网页被卷去的左："+  document.body.scrollLeft;  
			s  +=  "\r\n网页正文部分上："+  window.screenTop;  
			s  +=  "\r\n网页正文部分左："+  window.screenLeft;  
			s  +=  "\r\n屏幕分辨率的高："+  window.screen.height;  
			s  +=  "\r\n屏幕分辨率的宽："+  window.screen.width;  
			s  +=  "\r\n屏幕可用工作区高度："+  window.screen.availHeight;  
			s  +=  "\r\n屏幕可用工作区宽度："+  window.screen.availWidth;  
			alert(s);

			var s = ""; 
			s += " 网页可见区域宽："+ document.body.clientWidth; 
			s += "\r\n 网页可见区域高："+ document.body.clientHeight; 
			s += "\r\n 网页可见区域宽："+ document.body.offsetWidth + " (包括边线和滚动条的宽)"; 
			s += "\r\n 网页可见区域高："+ document.body.offsetHeight + " (包括边线的宽)"; 
			s += "\r\n 网页正文全文宽："+ document.body.scrollWidth; 
			s += "\r\n 网页正文全文高："+ document.body.scrollHeight; 
			s += "\r\n 网页被卷去的高(ff)："+ document.body.scrollTop; 
			s += "\r\n 网页被卷去的高(ie)："+ document.documentElement.scrollTop; 
			s += "\r\n 网页被卷去的左："+ document.body.scrollLeft; 
			s += "\r\n 网页正文部分上："+ window.screenTop; 
			s += "\r\n 网页正文部分左："+ window.screenLeft; 
			s += "\r\n 屏幕分辨率的高："+ window.screen.height; 
			s += "\r\n 屏幕分辨率的宽："+ window.screen.width; 
			s += "\r\n 屏幕可用工作区高度："+ window.screen.availHeight; 
			s += "\r\n 屏幕可用工作区宽度："+ window.screen.availWidth; 
			s += "\r\n 你的屏幕设置是 "+ window.screen.colorDepth +" 位彩色"; 
			s += "\r\n 你的屏幕设置 "+ window.screen.deviceXDPI +" 像素/英寸"; 
			alert (s); 
		*/

		var bh =document.body.scrollHeight-document.body.clientHeight/2;  
		var bw = document.body.clientWidth/2;
		var qzleft=bw-$('#divQz').width()/2;
		var qztop=bh-$('#divQz').height()/2;
		$('#divQz').css("top",qztop+"px");
		$('#divQz').css("left",qzleft+"px");
		
		
		var zxqzleft=bw-$('#divZxqz').width()/2;
		var zxqztop=bh-$('#divZxqz').height()/2;
		//$('#divZxqz').offset({top:zxqztop,left:zxqzleft});
		$('#divZxqz').css("top",zxqztop+"px");
		$('#divZxqz').css("left",zxqzleft+"px");
		
		var upleft=bw-$('#divUp').width()/2;
		var uptop=bh-$('#divUp').height()/2;
		//$('#divUp').offset({top:uptop,left:upleft});
		$('#divUp').css("top",uptop+"px");
		$('#divUp').css("left",upleft+"px");
		
	});
	
	
	function dw(id){
		var bh =document.body.scrollHeight-document.body.clientHeight/2;  
		var bw = document.body.clientWidth/2;
		var qzleft=bw-$('#'+id).width()/2;
		var qztop=bh-$('#'+id).height()/2;
		$('#'+id).css("top",qztop+"px");
		$('#'+id).css("left",qzleft+"px");
	}
	
	
</script>

<div id="divQz" class="white_content" style="width:250px;height:200px">
  <a href="javascript:void(0)" onclick="closeQz();" style="cursor:pointer;margin-right:10px;"><span style="color:red;float:right;">关闭</span></a>
  <span style="color:blue;font-weight:bold;">签章</span>
  <div style="text-align:left;padding:0 0 0 30px;font-size:14px;margin-top:15px;">
	  <p><a href="javascript:void(0)" onclick="showZxqz();" style="line-height:24px;">1、自动生成并盖章</a></p>
	  <p><a href="javascript:void(0)" onclick="showUp();" style="line-height:24px;">2、上传签章证明</a></p>
	  <p><a href="javascript:void(0)" onclick="showBdqz();" style="line-height:24px;">3、上传证明并盖章</a></p>
  </div>
</div>

<div id="divZxqz" class="white_content" style="width:500px;height:300px">
   <a href="javascript:void(0)" onclick="closeZxqz();" style="cursor:pointer;margin-right:10px;"><span style="color:red;float:right;">关闭</span></a>
   <span style="color:blue;font-weight:bold;">自动生成并盖章</span>
   <div style="text-align:center;font-size:14px;margin-top:15px;">
	  <table  id="viewtable" class="viewlist">
		<tr class="head">
		  <th align="center" class="head" width="80%">文件名称</th>
		  <th align="center" class="head" width="20%">操作</th>
		</tr>
		<%
		SimpleORMUtils instance=SimpleORMUtils.getInstance();
		List<Object[]> list=instance.queryForList("select t.attachmentid,t.attachmentpath,t.attachmentname from COMMON_ATTACHMENT t where t.docunid=? and t.moduleid=? and t.type!='dzqzwj' and (t.attachmentname like '%.doc' or t.attachmentname like '%.docx' or t.attachmentname like '%.pdf' )",docid,moduleId);
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

<div id="divUp" class="white_content" style="width:300px;height:200px">
	<a href="javascript:void(0)" onclick="closeUp();" style="cursor:pointer;margin-right:10px;"><span style="color:red;float:right;">关闭</span></a>
    <span style="color:blue;font-weight:bold;">上传签章证明</span>
    <div style="text-align:center;padding:0 0 0 30px;font-size:14px;margin-top:15px;">
		<form id='fileForm' enctype='multipart/form-data'>
			 <input type="file" name="file"><br/>
			 <input type="hidden" name="docid" value="<%=docid%>" />
			 <input type="hidden" name="moduleId" value="<%=moduleId%>" />
			 <input type="hidden" name="type" value="dzqzwj" />
			 <br/>
			 <input type="button" onclick="upload()" value="上传">&nbsp;&nbsp;<input type="button" onclick="closeUp()" value="取消">
		 </form>
    </div>
</div>


<div id="fade" class="black_overlay"></div>