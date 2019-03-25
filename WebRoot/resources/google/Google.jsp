<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/jquery/jquery.js"></script>
<script>
	$(function() {
		if(confirm("当前浏览器版本过低,推荐使用谷歌浏览器(点击确定下载谷歌浏览器).")){
			window.location.href = "<%=request.getContextPath()%>/resources/google/ChromeStandalone_62.0.3202.94_Setup.exe";
		}
	});
</script>
</head>
</html>