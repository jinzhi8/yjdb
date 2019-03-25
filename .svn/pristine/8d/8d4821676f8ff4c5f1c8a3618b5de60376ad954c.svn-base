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
		    //var errMsg = '<%=errMsg%>';
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