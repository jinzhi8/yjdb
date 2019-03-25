<html xmlns="http://www.w3.org/1999/xhtml" class="loginHtml">
<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="java.net.*"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="com.kizsoft.yjdb.utils.CommonUtil"%>
<%@taglib prefix="html" uri="/WEB-INF/struts-html.tld" %>
<%@page import="com.kizsoft.commons.commons.config.SystemConfig" %>
<%
	String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
	//session.setAttribute("userInfo", null);
	String errMsg = (String)session.getAttribute("LogErrMsg");
	//String url = URLEncoder.encode("https://oapi.dingtalk.com/connect/oauth2/sns_authorize?appid=dingoaecjapeti0hll3zhd&response_type=code&scope=snsapi_login&state=STATE&redirect_uri=http://192.168.77.195/yjdb/success.jsp", "utf-8");
	String url = URLEncoder.encode("https://oapi.dingtalk.com/connect/oauth2/sns_authorize?appid=dingoan94rjfcbwgb4dtfz&response_type=code&scope=snsapi_login&state=STATE&redirect_uri=http://10.36.224.23:8181/yjdb/success.jsp", "utf-8");
	String type = CommonUtil.doStr(request.getParameter("type"));
%>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta http-equiv="content-type" content="text/html;charset=utf-8">
<meta content="always" name="referrer">
<title><%=SystemConfig.getFieldValue("/config/systemconfig.xml", "//systemconfig/system/name")%></title>
<link rel="stylesheet" href="resources/template/cn/layui/css/layui.css" media="all" />
<link rel="stylesheet" href="resources/template/cn/css/public.css" media="all" />
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/jquery/jquery.js"></script>
<script type="text/javascript" src="js/layui/layui.js"></script>
<script>
!function (window, document) {
        function d(a) {
            var e, c = document.createElement("iframe"),
                d = "https://login.dingtalk.com/login/qrcode.htm?goto=" + a.goto ;
            d += a.style ? "&style=" + encodeURIComponent(a.style) : "",
                d += a.href ? "&href=" + a.href : "",
                c.src = d,
                c.frameBorder = "0",
                c.allowTransparency = "true",
                c.scrolling = "no",
                c.width =  a.width ? a.width + 'px' : "365px",
                c.height = a.height ? a.height + 'px' : "400px",
                e = document.getElementById(a.id),
                e.innerHTML = "",
                e.appendChild(c)
        }
        window.DDLogin = d
}(window, document);


$(document).ready(function(){
	var obj = DDLogin({
	    id:"login_container",
	    goto:"<%=url%>",
	    style: "border:none;background-color:#FFFFFF; margin-top:-10px;",
		width : "265",
	    height: "330"
	});

	var hanndleMessage = function (event) {
        var origin = event.origin;
        console.log("origin", event.origin);
        if( origin == "https://login.dingtalk.com" ) { //判断是否来自ddLogin扫码事件。
            var loginTmpCode = event.data; //拿到loginTmpCode后就可以在这里构造跳转链接进行跳转了
            console.log("loginTmpCode", loginTmpCode);
            //window.location.href="https://oapi.dingtalk.com/connect/oauth2/sns_authorize?appid=dingoaecjapeti0hll3zhd&response_type=code&scope=snsapi_login&state=STATE&redirect_uri=http://192.168.77.195/yjdb/success.jsp&loginTmpCode="+loginTmpCode
            window.location.href="https://oapi.dingtalk.com/connect/oauth2/sns_authorize?appid=dingoan94rjfcbwgb4dtfz&response_type=code&scope=snsapi_login&state=STATE&redirect_uri=http://10.36.224.23:8181/yjdb/success.jsp&loginTmpCode="+loginTmpCode		
        }

	};

	if (typeof window.addEventListener != 'undefined') {
	    window.addEventListener('message', hanndleMessage, false);
	} else if (typeof window.attachEvent != 'undefined') {
	    window.attachEvent('onmessage', hanndleMessage);
	}

});
    
	//判断当前浏览类型  
	function BrowserType()  
	{  
	    var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串  
	    var isOpera = userAgent.indexOf("Opera") > -1; //判断是否Opera浏览器  
	    var isIE = userAgent.indexOf("compatible") > -1 && userAgent.indexOf("MSIE") > -1 && !isOpera; //判断是否IE<11浏览器 
	    var isEdge = userAgent.indexOf("Windows NT 6.1; Trident/7.0;") > -1 && !isIE; //判断是否IE的Edge浏览器  
	    var isFF = userAgent.indexOf("Firefox") > -1; //判断是否Firefox浏览器  
	    var isSafari = userAgent.indexOf("Safari") > -1 && userAgent.indexOf("Chrome") == -1; //判断是否Safari浏览器  
	    var isChrome = userAgent.indexOf("Chrome") > -1 && userAgent.indexOf("Safari") > -1; //判断Chrome浏览器  
		var isIE11 = userAgent.indexOf("Trident") > -1 && userAgent.indexOf("rv:11.0") > -1;//判断IE11浏览器
	    if (isIE)   
	    {  
	         var reIE = new RegExp("MSIE (\\d+\\.\\d+);");  
	         reIE.test(userAgent);  
	         var fIEVersion = parseFloat(RegExp["$1"]);  
	         if(fIEVersion == 7)  
	         { return "IE7";}  
	         else if(fIEVersion == 8)  
	         { return "IE8";}  
	         else if(fIEVersion == 9)  
	         { return "IE9";}  
	         else if(fIEVersion == 10)  
	         { return "IE10";}  
	         else  
	         { return "0"}//IE版本过低  
	     }//isIE end  
	     if(isIE11) { return "IE11";}
	     if (isFF) {  return "FF";}  
	     if (isOpera) {  return "Opera";}  
	     if (isSafari) {  return "Safari";}  
	     if (isChrome) { return "Chrome";}  
	     if (isEdge) { return "Edge";}  
	 }

	 $(function() {
		var version = BrowserType();
		if (version == "IE7" || version=="IE8" || version=="0") {
			$("#zmmsg").attr("style","display:block;");
		}
	});
	 
	 $(document).on('click','.choice-line a',function(){
			var type = $(this).attr('data-type');
			$(this).addClass('active').siblings().removeClass('active');
			$('.'+type+'-wrap').addClass('active').siblings().removeClass('active');
		})
		layui.use(['form','layer','jquery'],function(){
		    var form = layui.form,
		        layer =layui.layer
		        $ = layui.jquery;
		    //判断有无返回信息
		    var errMsg = '<%=errMsg%>';
		   	if(errMsg != null && errMsg != 'null'){
		   		layer.msg('<%=errMsg%>', {icon: 5});
		   	}

		    var type = '<%=type%>';
		    if(type=="loginMore"){
		        layui.layer.open({
		            type: 2,
		            area: ['40%', '40%'],
		            content: 'loginMore.jsp',
		            end: function(){
		                location.href = 'index.jsp';
		            }
		        });
		    }

		    //表单输入效果
		    $(".loginBody .input-item").click(function(e){
		        e.stopPropagation();
		        $(this).addClass("layui-input-focus").find(".layui-input").focus();
		    })
		    $(".loginBody .layui-form-item .layui-input").focus(function(){
		        $(this).parent().addClass("layui-input-focus");
		    })
		    $(".loginBody .layui-form-item .layui-input").blur(function(){
		        $(this).parent().removeClass("layui-input-focus");
		        if($(this).val() != ''){
		            $(this).parent().addClass("layui-input-active");
		        }else{
		            $(this).parent().removeClass("layui-input-active");
		        }
		    })
		    
		})
</script>
<style type="text/css">
.login-top-header {
    position: absolute;
    left: 0px;
    top: 50%;
    background: url(resources/template/cn/images/login-logo.png) no-repeat center;
    width: 100%;
    height: 52px;
    margin-top: -244px;
}
</style>
</head>
<body class="loginBody">
	<div class="login-top-header">
		<!-- <%=SystemConfig.getFieldValue("/config/systemconfig.xml", "/systemconfig/system/description")%> -->
	</div>
	<!-- <div class="layui-form">
		<div class="login_face"><img src="resources/template/cn/images/Galogo.png" class="userAvatar"></div>
		<div class="choice-line">
			<span class="btn-wrap">
				<a class="active" data-type="mobile">钉钉验证登录</a>
				<a data-type="dingding">扫码登录</a>
			</span>
			<span class="line"></span>
		</div>
		<div class="type-choice-wrap mobile-wrap active">
			<div class="position-wrap">
				<div class="layui-form-item input-item">
					<label for="userName">手机号</label>
					<input type="text" placeholder="请输入手机号" autocomplete="off" name="mobile" id="mobile" class="layui-input" lay-verify="required">
				</div>
				<div class="layui-form-item input-item yzm">
					<label for="password">验证码</label>
					<input type="password" placeholder="请输入密码" autocomplete="off" name="yzm" id="yzm" class="layui-input" lay-verify="required">
					<input type="button" class="layui-btn layui-btn-sm get-code" value="获取验证码"  onclick="getLoginCode(this);"/>
				</div>
				<div class="layui-form-item">
					<input type="button" class="layui-btn layui-block sub" value="登录"/>	
				</div>
			</div>
		</div>
		<div class="type-choice-wrap dingding-wrap ">
			<div class="login-position">
				<div  id="login_container"></div>
				<span>IOS移动网络下可能会出现扫码失败<p>请用验证码方式登录</p></span>
			</div>
		</div>
	</div>-->
	<div class="layui-form-now">
		<div class="choicelogin-body">
			<div class="type-choice-wrap mobile-wrap left-ddlogin">
				<div class="choicelogin-line">钉钉验证登录</div>
				<div class="position-wrap">
					<div class="layui-form-item input-item">
						<label for="userName">手机号</label>
						<input type="text" placeholder="请输入手机号" autocomplete="off" name="mobile" id="mobile" class="layui-input" lay-verify="required">
					</div>
					<div class="layui-form-item input-item yzm">
						<label for="password">验证码</label>
						<input type="password" placeholder="请输入密码" autocomplete="off" name="yzm" id="yzm" class="layui-input" lay-verify="required">
						<input type="button" class="layui-btn layui-btn-sm get-code" value="获取验证码"  onclick="getLoginCode(this);"/>
					</div>
					<div class="layui-form-item">
						<input type="button" class="layui-btn layui-block sub" value="登录"/>	
					</div>
					<span>IOS移动网络下可能会出现扫码失败<p>请用验证码方式登录</p></span>
					<span class="oldlogin-link">登录旧版本:&nbsp;<a href="http://172.20.146.69/login.php" target="view_window">http://172.20.146.69/login.php</a></span>
				</div>
			</div>
			<div class="type-choice-wrap dingding-wrap left-ddlogin">
				<div class="login-position">
					<div  id="login_container"></div>
				</div>
			</div>
		</div>
	</div>
	<!-- 页面遮罩层 -->
	<div class="liulangqi_note" id="zmmsg" style="display:none;">
  		<div class="gdnote_box">
  			<h1>温馨提示</h1>
    		<p>您当前的浏览器版本过低，请使用谷歌浏览器、360浏览器6.0以上的极速模式(包括6.0)、IE11以上（包含IE11）3、以达到更好的使用体验。</p>
 		</div>
	</div>
	<!-- 页面遮罩层 -->
</body>
<script>
	//判断当前浏览类型  
	function BrowserType()  
	{  
	    var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串  
	    var isOpera = userAgent.indexOf("Opera") > -1; //判断是否Opera浏览器  
	    var isIE = userAgent.indexOf("compatible") > -1 && userAgent.indexOf("MSIE") > -1 && !isOpera; //判断是否IE<11浏览器 
	    var isEdge = userAgent.indexOf("Windows NT 6.1; Trident/7.0;") > -1 && !isIE; //判断是否IE的Edge浏览器  
	    var isFF = userAgent.indexOf("Firefox") > -1; //判断是否Firefox浏览器  
	    var isSafari = userAgent.indexOf("Safari") > -1 && userAgent.indexOf("Chrome") == -1; //判断是否Safari浏览器  
	    var isChrome = userAgent.indexOf("Chrome") > -1 && userAgent.indexOf("Safari") > -1; //判断Chrome浏览器  
		var isIE11 = userAgent.indexOf("Trident") > -1 && userAgent.indexOf("rv:11.0") > -1;//判断IE11浏览器
	    if (isIE)   
	    {  
	         var reIE = new RegExp("MSIE (\\d+\\.\\d+);");  
	         reIE.test(userAgent);  
	         var fIEVersion = parseFloat(RegExp["$1"]);  
	         if(fIEVersion == 7)  
	         { return "IE7";}  
	         else if(fIEVersion == 8)  
	         { return "IE8";}  
	         else if(fIEVersion == 9)  
	         { return "IE9";}  
	         else if(fIEVersion == 10)  
	         { return "IE10";}  
	         else  
	         { return "0"}//IE版本过低  
	     }//isIE end  
	     if(isIE11) { return "IE11";}
	     if (isFF) {  return "FF";}  
	     if (isOpera) {  return "Opera";}  
	     if (isSafari) {  return "Safari";}  
	     if (isChrome) { return "Chrome";}  
	     if (isEdge) { return "Edge";}  
	 }

	 $(function() {
		var version = BrowserType();
		if (version == "IE7" || version=="IE8" ||version == "IE9" || version=="IE10"|| version=="0") {
			$("#zmmsg").attr("style","display:block;");
		}
	});
	 
	 $(document).on('click','.choice-line a',function(){
			var type = $(this).attr('data-type');
			$(this).addClass('active').siblings().removeClass('active');
			$('.'+type+'-wrap').addClass('active').siblings().removeClass('active');
		})
		layui.use(['form','layer','jquery'],function(){
		    var form = layui.form,
		        layer =layui.layer
		        $ = layui.jquery;
		    //判断有无返回信息
		    var errMsg = '<%=errMsg%>';
		   	if(errMsg != null && errMsg != 'null'){
		   		layer.msg('<%=errMsg%>', {icon: 5});
		   	}

		    var type = '<%=type%>';
		    if(type=="loginMore"){
		        layui.layer.open({
		            type: 2,
		            area: ['40%', '40%'],
		            content: 'loginMore.jsp',
		            end: function(){
		                location.href = 'index.jsp';
		            }
		        });
		    }

		    //表单输入效果
		    $(".loginBody .input-item").click(function(e){
		        e.stopPropagation();
		        $(this).addClass("layui-input-focus").find(".layui-input").focus();
		    })
		    $(".loginBody .layui-form-item .layui-input").focus(function(){
		        $(this).parent().addClass("layui-input-focus");
		    })
		    $(".loginBody .layui-form-item .layui-input").blur(function(){
		        $(this).parent().removeClass("layui-input-focus");
		        if($(this).val() != ''){
		            $(this).parent().addClass("layui-input-active");
		        }else{
		            $(this).parent().removeClass("layui-input-active");
		        }
		    })
		    
		})
		 $('.sub').click(function() {
			 var unObj = $("input[name=yzm]").val();
				if(unObj== "") {
					layer.alert("请输入验证码!");
					return false;
				}
				$.ajax({
					type:"post",
					url:"success.jsp",
					data:{
						yzm:unObj,
						status:"3"
					},
					dataType:'json',
					success:function(data){
						if(data.result=="index"){
							window.location.href="index.jsp";
						}else if(data.result=="login"){
							window.location.href="login.jsp";
						}else if(data.result=="loginMore"){
							layui.layer.open({
					    		type: 2,
					    		area: ['40%', '40%'],
					    		content: 'loginMore.jsp',
					    		end: function(){
					    		    location.href = 'index.jsp';
					    		}
					    	});
						}else{
							layer.msg(data.result);
						}
					}
				});
		 })
		function getLoginCode(obj){
			var unObj = $("input[name=mobile]").val();
			if(unObj== "") {
				layer.alert("请输入手机号!");
				return false;
			}
			sendCode(obj);
			$.ajax({
				type:"post",
				url:"success.jsp",
				data:{
					mobile:unObj,
					status:"2"
				},
				dataType:'json',
				success:function(data){
					layer.msg(data.result);
				}
			});
		}
			var clock="";
			var nums = 60;
			var btn;
			function sendCode(thisBtn){
				btn = thisBtn;
				btn.disabled = true; //将按钮置为不可点击
				btn.value = nums+'秒后获取';
				clock = setInterval(doLoop, 1000); //一秒执行一次
			}
			function doLoop(){
				nums--;
				if(nums > 0){
					btn.value = nums+'秒后获取';
				}else{
					clearInterval(clock); //清除js定时器
					btn.disabled = false;
					btn.value = '获取验证码';
					nums = 10; //重置时间
				}
			}
</script>
</html>
