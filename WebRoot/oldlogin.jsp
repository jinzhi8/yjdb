<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" class="loginHtml">
<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="java.net.*"%>
<%@taglib prefix="html" uri="/WEB-INF/struts-html.tld" %>
<%@page import="com.kizsoft.commons.commons.config.SystemConfig" %>
<%
	String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
	String redirectPath = (String) request.getAttribute("redirectpath");
	redirectPath = redirectPath == null ? "" : redirectPath;
	session.setAttribute("userInfo", null);
	String errMsg = (String)session.getAttribute("LogErrMsg");
%>
<head>
<meta charset="UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge"> 
<meta name="viewport" content="width=device-width, initial-scale=1"> 
<title><%=SystemConfig.getFieldValue("/config/systemconfig.xml", "//systemconfig/system/name")%></title>
<link rel="stylesheet" href="resources/template/cn/layui/css/layui.css" media="all" />
<link rel="stylesheet" href="resources/template/cn/css/public.css" media="all" />
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/jquery/jquery.js"></script>
<script>
	if (top.location != self.location) top.location = self.location;

	$(function() {
		var version = $.browser.version;
		if (version == "8.0" || version == "7.0" || version=="6.0" || version=="5.0") {
			window.location.href = "<%=request.getContextPath()%>/resources/google/Google.jsp";
		}
	});
</script>
</head>
<body class="loginBody">
	<div id="login_container"></div>
	<div style="text-align: center;color: white;width: 324px;position: absolute;left:0px;top:160px;right:0px;margin:auto;font-size:xx-large;">
		<%=SystemConfig.getFieldValue("/config/systemconfig.xml", "/systemconfig/system/description")%>
	</div>	
	<div class="layui-form">
				<html:form action="login.do" focus="username" >
					<html:hidden property="userflag" value="1"/>
					<html:hidden property="depid" value=""/>
					
					<div class="login_face"><img src="resources/template/cn/images/Galogo.png" class="userAvatar"></div>
					<div class="layui-form-item input-item">
						<label for="userName">用户名</label>
						<input type="text" placeholder="请输入用户名" autocomplete="off" name="username" id="userName" class="layui-input" lay-verify="required">
					</div>
					<div class="layui-form-item input-item">
						<label for="password">密码</label>
						<input type="password" placeholder="请输入密码" autocomplete="off" name="password" id="password" class="layui-input" lay-verify="required">
					</div>
					<div class="layui-form-item">
			          <input type="checkbox" lay-skin="primary" title="记住密码" id="issave" name="issavepassword" value="1">
			        </div>
					<div class="layui-form-item">
						<button class="layui-btn layui-block sub" lay-submit lay-filter="sub">登录</button>
						<!--<a class="act-but submit" href="https://41.246.147.7:8443/tzgaww/ZsTest/TzgaZs.jsp" style="color: #FFFFFF">证书登录</a>-->
					</div>
					
			</html:form>
				 
</div>
<script type="text/javascript" src="resources/template/cn/layui/layui.js"></script>
</body>
<%
  // 将适用目录下所有Cookie读入并存入cookies数组中
  Cookie cookies[] = request.getCookies();
  Cookie sCookie = null;
  String cname = null;
  String cvalue = null;
  String saveUsername = "";
  String savePassword = "";
  String isSavePassword= "";
  String isAutoLogin = "";
  String isLogout = "";
  // 如果没有任何cookie
  if (cookies != null) {
      for (int i = 0; i < cookies.length; i++) {
          // 循环列出所有可用的Cookie
          sCookie = cookies[i];
          sCookie.setPath(request.getContextPath()); 
          cname = sCookie.getName();
          cvalue = sCookie.getValue();
          if ("username".equals(cname)) {
              saveUsername = java.net.URLDecoder.decode(cvalue,"UTF-8");
          }
          if ("password".equals(cname)) {
              savePassword = cvalue;
          }
          if ("issavepassword".equals(cname)) {
              isSavePassword = cvalue;
          }
          if ("isautologin".equals(cname)) {
              isAutoLogin = cvalue;
          }
          if ("islogout".equals(cname)) {
              isLogout = cvalue;
          }
      }
  }
%>

<script type="text/javascript">
layui.use(['form','layer','jquery'],function(){
    var form = layui.form,
        layer =layui.layer
        $ = layui.jquery;
    //判断有无返回信息
    var errMsg = '<%=errMsg%>';
   	if(errMsg != null && errMsg != 'null'){
   		layer.msg('<%=errMsg%>', {icon: 5});
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
    //勾选记住密码
    if("<%=isSavePassword%>"=="1"){
    	$('#issave').attr('checked', true);
    	$('#userName').val('<%=saveUsername%>');
    	$('#password').val('<%=savePassword%>');
    	form.render('checkbox');
    }else{
    	$('#username').val('');
    	$('#password').val('');
    }
    //监听表单提交
    form.on('submit(sub)',function(data){
    });
    
    
    /* //按回车登录
    $(document).keyup(function(event){
   	 if(event.keyCode ==13){
   		$(".layui-btn.layui-block.sub").trigger("click");
   	 }
   	}); */
})
	
  if( !('placeholder' in document.createElement('input')) ){  
   
    $('input[placeholder],textarea[placeholder]').each(function(){   
      var that = $(this),   
      text= that.attr('placeholder');   
      if(that.val()===""){   
        that.val(text).addClass('placeholder');   
      }   
      that.focus(function(){   
        if(that.val()===text){   
          that.val("").removeClass('placeholder');   
        }   
      })   
      .blur(function(){   
        if(that.val()===""){   
          that.val(text).addClass('placeholder');   
        }   
      })   
      .closest('form').submit(function(){   
        if(that.val() === text){   
          that.val('');   
        }   
      });   
    });   
  }  
</script> 

<script type="text/javascript">

  window.onload = function(){
    
    //if("<%=isAutoLogin%>"=="1"){
	//		document.all.isautologin.checked=true;
   // }
    if (document.all.username.value == "") {
      document.all.username.focus();
    } else {
      document.all.password.focus();
    }
    if("<%=isAutoLogin%>"=="1"&&document.all.password.value!=""&&"<%=isLogout%>"!="1"){
			document.forms[0].submit();
		}
	}
	/**document.all.issavepassword.onchange = function(){
		if(this.checked==false){document.all.isautologin.checked=false;}
	};**/

  function codeDel(){
	var username=$('[name=username]').val();
	if(username==""){
		alert("请输入用户名!");
		document.all.username.focus();
		return false;
	}
	var password=$('[name=password]').val();
	if(password==""){
		alert("请输入密码！");
		document.all.password.focus();
		return false;
	}
	return true;
}	
</script>

</html>