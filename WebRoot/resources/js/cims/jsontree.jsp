<%@ page language="java" import="java.util.*" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%
String contextPath = "/".equals(request.getContextPath()) ? "" : request.getContextPath();
%>
<html>
<head>
<!--这是一个相当于无限级联地址的,刚开始页面中什么都没有,刚打开时,只显示最高级的地址,这些地址是从数据库中读取的.-->
<title>初始化</title>
<script type="text/javascript" src="<%=contextPath%>/resources/js/jquery/jquery.js"></script>
<script type="text/javascript">
	function showCatalogs(){
		$.ajax({
			url:'jsontreeaction.jsp?module=library&type=catalog',//请求的URL
			cache: false, //不从缓存中取数据
			data:{uuid:'-1'},//发送的参数
			type:'Get',//请求类型
			dataType:'json',//返回类型是JSON
			timeout:20000,//超时
			error:function()//出错处理
			{
			alert("程序出错!");
			},
			success:function(json)//成功处理
			{
				var len=json.length;//得到查询到数组长度
				$("<select name='temp_catalogs' id='temp_catalogs' style='width:80px' onchange='showSubCatalogs()'></select>").appendTo("#catalogsdiv");//在content中添加select元素
				$("<option value=''>请选择</option>").appendTo("#temp_catalogs");
				for(var i=0;i<len;i++)//把查询到数据循环添加到select中
				{
					$("<option value="+json[i].catalogValue+" uuid="+json[i].uuid+">"+json[i].catalogName+"</option>").appendTo("#temp_catalogs");
				}
			}               
		});
	}
	function showSubCatalogs()
	{
		var obj=event.srcElement;//取得当前事件的对象,也就是你点了哪个select,这里得到的就是那个对象
		var currentObj=$(obj);//将JS对象转换成jQuery对象,这样才能使用其方法
		var s1=$(obj).nextAll("select");//找到当前点击的后面的select对象
		s1.each(function(i){
			$(this).remove();//循环把它们删除
		});
		//var value1=$(obj).val();
		var value1 = $(obj).find("option:selected").attr("uuid");  
			if($(obj).val()!=''){
			$.ajax({
				url:'jsontreeaction.jsp?module=library&type=catalog',
				cache:false,
				data:{uuid:value1},
				type:'Get',
				dataType:'json',
				timeout:20000,
				error:function()
				{
					alert("出错啦");
				},
				success:function(json)
				{
					var len=json.length;
					if(len!=0)
					{
						$("<select name='temp_catalogs' style='width:80px' onchange='showSubCatalogs()'></select>").appendTo("#catalogsdiv");
						$("<option value=''>请选择</option>").appendTo("#catalogsdiv>select:last");
						for(var i=0;i<len;i++)
						{
							$("<option value="+json[i].catalogValue+" uuid="+json[i].uuid+">"+json[i].catalogName+"</option>").appendTo("#catalogsdiv>select:last");
						}
					}
				}
			});
		}
	}
	function openCatalogs(obj){
		if($("#catalogparentdiv")){
			$("#catalogparentdiv").remove(); 
		}
		var otop = obj.offsetTop+obj.offsetHeight;
		var oleft = obj.offsetLeft;
		$("<div id=\"catalogparentdiv\" style=\"PADDING-RIGHT: 4px; PADDING-LEFT: 4px; Z-INDEX: 1000; BACKGROUND: #aac7e7; PADDING-BOTTOM: 4px; PADDING-TOP: 4px; POSITION: absolute; moz-box-shadow: 0 0 4px rgba(0,0,0,0.4); webkit-box-shadow: 0 0 4px rgba(0,0,0,0.4); box-shadow: 0 0 4px rgba(0,0,0,0.4); o-box-shadow: 0 0 4px rgba(0,0,0,0.4);white-space:nowrap;background-color:lightblue;position:absolute;width:auto;height:auto;top:" + otop + "px;left:"+oleft+"px\"><div id=\"catalogsdiv\"></div><input name=\"getCatalogsBtn\" type=\"button\" value=\"确定\" />&nbsp;<input name=\"closeCatalogsBtn\" type=\"button\" value=\"关闭\" />&nbsp;<input name=\"clearCatalogsBtn\" type=\"button\" value=\"清空\" /></div>").appendTo(document.body);
		$("#catalogparentdiv").ready(function(){ 
			$("input[name=getCatalogsBtn]").click(function(){ 
				getCatalogsValue(obj);
			}); 
		}); 
		$("#catalogparentdiv").ready(function(){ 
			$("input[name=closeCatalogsBtn]").click(function(){ 
				$("#catalogparentdiv").remove(); 
			}); 
		}); 
		$("#catalogparentdiv").ready(function(){ 
			$("input[name=clearCatalogsBtn]").click(function(){ 
				obj.value="";
				$("#catalogparentdiv").remove(); 
			}); 
		}); 
		showCatalogs(obj);	
	}
	function getCatalogsValue(obj){
		var catalogsValue ="";
		$("select[name=temp_catalogs]").each(function(){
			catalogsValue += $(this).children("option:selected").val();
		});
		obj.value=catalogsValue;
		$("#catalogparentdiv").remove(); 
	}
</script>
</head>
<body>
   <div id="content" style="width: 500px; border: 1px; border-style: solid; background-color: lightblue;"></div>
   <br/><br/><br/><br/><br/>&nbsp;<input type="text" size="100" onclick="openCatalogs(this);">
</body>
</html>
    