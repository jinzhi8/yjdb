<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="java.net.*"%>
<%@taglib prefix="html" uri="/WEB-INF/struts-html.tld" %>
<%@page import="com.kizsoft.commons.commons.config.SystemConfig" %>
<%
	String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
	String redirectPath = (String) request.getAttribute("redirectpath");
	redirectPath = redirectPath == null ? "" : redirectPath;
%>

<%
			/*String userIP = request.getRemoteAddr();
			String hostAddress = null;
					InetAddress myServer = null;
					
					try {
						myServer = InetAddress.getByName("www.zjsos.net");
						hostAddress =myServer.getHostAddress();
					} catch (UnknownHostException e) {
					}
					if(userIP!=null&&hostAddress!=null){
					if (userIP.indexOf("172.20.68") > -1) {
						if (Integer.parseInt(userIP.substring(userIP.lastIndexOf(".") + 1, userIP.length())) >= 193 && Integer.parseInt(userIP.substring(userIP.lastIndexOf(".") + 1, userIP.length())) <= 221) {

						} else {
							//response.sendRedirect(request.getContextPath() + "/login.jsp");
							//return;
						}
					} else if (userIP.indexOf("127.0.0.1") > -1) {

					} else if (userIP.indexOf(hostAddress) > -1) {

					} else {
						//response.sendRedirect(request.getContextPath() + "/login.jsp");
						//return;
					}
					} */
		%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=SystemConfig.getFieldValue("/config/systemconfig.xml", "//systemconfig/system/name")%></title>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/jquery/jquery.js"></script>
<SCRIPT LANGUAGE="JavaScript">
	//<!--
	if (top.location != self.location) top.location = self.location;
	if (navigator.userAgent.match(/(UCWEB|ucweb|operamini|iOS|ipad|ipod|iphone|android|webOS|up.browser|up.link|mmp|symbian|smartphone|midp|wap|vodafone|o2|pocket|kindle|mobile|hiptop|\bpda|psp|treo|nokia|blackberry)/i))
	{
		//location.href="<%=contextPath%>/conference/ipad/";
		//location.replace("<%=contextPath%>/conference/ipad/");
		//document.write("<meta http-equiv='Refresh' content='0;URL=<%=contextPath%>/conference/ipad/'>");
	}
	function checkFormca(){
		window.location.href='<%=SystemConfig.getFieldValue("/config/systemconfig.xml", "//systemconfig/caserver/url")%><%=contextPath%>/calogin.do';
		//document.loginForm.submit();
	}
	//-->
</SCRIPT>
<script>
	function cklick() {
		if(document.all.username.value == "") {
			alert("请输入用户名!");
			document.all.username.focus();
			return false;
		}
		if(document.all.password.value == "") {
			alert("请输入密码!");
			document.all.password.focus();
			return false;
		}
		
	/*$.ajax({
	  url: 'loginEC.do',
	  data:"name="+encodeURI(encodeURI(document.all.username.value.replace(/\s+/g,""))),
	  success: function(userName) {
	  
	  
	  //alert(userName);
	  document.all.username.value=userName;
     document.forms[0].submit();
           return true;	 
	  }
	});*/
		
	   document.forms[0].submit();
		return false;
	}
</script>
<style type="text/css">
* {
	margin:0;
	padding:0;
	list-style:none;
}
html {
	height:100%;
}
body {
	height:100%;
	text-align:center;
	background-image:url(images/body-bg.jpg);
	background-repeat:repeat-x;
}
.centerDiv {
	display:inline-block;
	zoom:1;
*display:inline;
	vertical-align:middle;
	text-align:left;
	width:983px;
	padding:10px;
	background-image:url(images/main-bg1.jpg);
	background-repeat:no-repeat;
	height:530px;
}
.hiddenDiv {
	height:100%;
	overflow:hidden;
	display:inline-block;
	width:1px;
	overflow:hidden;
	margin-left:-1px;
	zoom:1;
*display:inline;
*margin-top:-1px;
	_margin-top:0;
	vertical-align:middle;
}
.tltle
{
	margin:35px 0px 0px -10px;
}
.photo
{
	margin:153px 0px 0px 55px;
	_margin:163px 0px 0px 55px;
	*margin:163px 0px 0px 55px;
}
.photo1
{
	margin:-233px 0px 0px 680px;
}
a
{
	margin-left:10px;
	color:#a7a7a7;
	text-decoration:none;
}
a:hover
{
	text-decoration:underline;
	color:#00F;
}
</style>
</head>
<body>

<div class="centerDiv">
<div class="photo"><img alt="" src="<%=request.getContextPath()%>/images/photo.jpg"/></div>
<div class="photo1">
<html:form action="login.do" focus="username" onsubmit="return cklick();">
<html:hidden property="userflag" value="1"/>
<html:hidden property="depid" value=""/>
<table width="200" border="0" cellspacing="12" cellpadding="0" class="conter">
  <tr>
    <td style="font-size:16px; color:#c49c18; font-weight:bold;">用户名：</td>
  </tr>
  <tr>
    <td><html:text property="username" style="font-size:16px;line-height:33px;width:175px;padding-left:10px;padding-right:10px;background:none;background-repeat:no-repeat; border:none; background-image:url(images/txt.jpg); height:33px;"/></td>
  </tr>
  <tr>
    <td style="font-size:16px; color:#c49c18; font-weight:bold;">密&nbsp;&nbsp;&nbsp;&nbsp;码：</td>
  </tr>
  <tr>
    <td><html:password property="password" style="font-size:16px;line-height:33px;width:175px;padding-left:10px;padding-right:10px;background:none; border:none; background-image:url(images/txt.jpg);background-repeat:no-repeat;height:33px;"/></td>
  </tr>
  <tr>
    <td style=" text-align:center; font-size:12px;vertical-align:middle;">
	<input type="checkbox" name="issavepassword" id="issavepassword" value="1"/><label for="issavepassword">记住密码</label>&nbsp;&nbsp;<input type="checkbox" name="isautologin" id="isautologin" value="1"/><label for="isautologin">自动登录</label><html:hidden property="savedeadline" value="7"/>
	</td>
  </tr>
  <tr>
    <td style="text-align:center;"><input type="image" value="button" src="<%=request.getContextPath()%>/images/login.jpg"/>
    <!--<input type="image" value="button" src="<%=request.getContextPath()%>/images/zsdl.jpg" onclick="checkFormca();"/>-->
    </td>
  </tr>
  <tr>
   <td style="font-size:12px;text-align:center;"  >
	<a href="<%=request.getContextPath()%>/resources/ocx/soa.exe">控件下载</a><a href="http://122.228.130.114:3080/mobile/download.html">移动办公OA下载</a> 
<!--	<a href="">常用字体下载</a>
	<br/>
	 <a href="">数字印章驱动下载</a>   <a href="<%=request.getContextPath()%>/resources/ocx/kizoa.exe">控件下载</a>--> 
	</td>
  </tr>
  <tr>
    <td style="font-size:12px;text-align:center;vertical-align:top;">
		<span style="color:red;font-size:12px;vertical-align:middle;">
			<%
                session.setAttribute("userInfo", null);
                if (session.getAttribute("LogErrMsg") != null) {
                  out.println((String) session.getAttribute("LogErrMsg"));
                }
                session.invalidate();
            %>
			&nbsp;
		</span>
	</td>
  </tr>
</table>
</html:form>
</div>
<div style="text-align:center; margin-top:40px; color:#086389">温州市瓯江口新区开发建设管理委员会<br/><br/>技术支持：浙江索思科技有限公司</div>
</div>
<div class="hiddenDiv"></div>
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
          //out.println(cname + "=" + cvalue + "<br>");
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
<script LANGUAGE="JavaScript">
  window.onload = function(){
    document.all.username.value = "<%=saveUsername%>";
    document.all.password.value = "<%=savePassword%>";
    if("<%=isSavePassword%>"=="1"){
			document.all.issavepassword.checked=true;
    }
    if("<%=isAutoLogin%>"=="1"){
		//	document.all.isautologin.checked=true;
    }
    if (document.all.username.value == "") {
      document.all.username.focus();
    } else {
      document.all.password.focus();
    }
    if("<%=isAutoLogin%>"=="1"&&document.all.password.value!=""&&"<%=isLogout%>"!="1"){
			//document.forms[0].submit();
		}
	}
	document.all.isautologin.onchange = function(){
		if(this.checked==true){document.all.issavepassword.checked=true;}
	};
	document.all.issavepassword.onchange = function(){
		if(this.checked==false){document.all.isautologin.checked=false;}
	};
</script>
</html>