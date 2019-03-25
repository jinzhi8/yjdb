var catalogsjs = {};
catalogsjs.scriptPath = (function() {
	var elements = document.getElementsByTagName('script');
	for ( var i = 0, len = elements.length; i < len; i++) {
		if (elements[i].src && elements[i].src.match(/catalogs[\w\-\.]*\.js/)) {
			return elements[i].src.substring(0, elements[i].src
					.lastIndexOf('/') + 1);
		}
	}
	return "";
})();
function showCatalogs(moduleCode, typeCode) {
	$
			.ajax({
				url : catalogsjs.scriptPath + '/catalogsaction.jsp?module='
						+ moduleCode + '&type=' + typeCode,// 请求的URL
				cache : false, // 不从缓存中取数据
				data : {
					uuid : '-1'
				},// 发送的参数
				type : 'Get',// 请求类型
				dataType : 'json',// 返回类型是JSON
				timeout : 20000,// 超时
				error : function()// 出错处理
				{
					alert("程序出错!");
				},
				success : function(json)// 成功处理
				{
					var len = json.length;// 得到查询到数组长度
					$(
							"<select name='temp_catalogs' id='temp_catalogs' style='width:80px;' onchange='showSubCatalogs(\""
									+ moduleCode
									+ "\",\""
									+ typeCode
									+ "\")'></select>")
							.appendTo("#catalogsdiv");// 在content中添加select元素
					$("<option value=''>请选择</option>").appendTo(
							"#temp_catalogs");
					for ( var i = 0; i < len; i++)// 把查询到数据循环添加到select中
					{
						$(
								"<option value=" + json[i].catalogValue
										+ " uuid=" + json[i].uuid + ">"
										+ json[i].catalogName + "</option>")
								.appendTo("#temp_catalogs");
					}
				}
			});
}
function showSubCatalogs(moduleCode, typeCode) {
	var obj = event.srcElement;// 取得当前事件的对象,也就是你点了哪个select,这里得到的就是那个对象
	var currentObj = $(obj);// 将JS对象转换成jQuery对象,这样才能使用其方法
	var s1 = $(obj).nextAll("select");// 找到当前点击的后面的select对象
	s1.each(function(i) {
		$(this).remove();// 循环把它们删除
	});
	// var value1=$(obj).val();
	var value1 = $(obj).find("option:selected").attr("uuid");
	if ($(obj).val() != '') {
		$.ajax({
			url : catalogsjs.scriptPath + '/catalogsaction.jsp?module='
					+ moduleCode + '&type=' + typeCode,
			cache : false,
			data : {
				uuid : value1
			},
			type : 'Get',
			dataType : 'json',
			timeout : 20000,
			error : function() {
				alert("出错啦");
			},
			success : function(json) {
				var len = json.length;
				if (len != 0) {
					$(
							"<select name='temp_catalogs' style='width:80px' onchange='showSubCatalogs(\""
									+ moduleCode + "\",\"" + typeCode
									+ "\")'></select>")
							.appendTo("#catalogsdiv");
					$("<option value=''>请选择</option>").appendTo(
							"#catalogsdiv>select:last");
					for ( var i = 0; i < len; i++) {
						$(
								"<option value=" + json[i].catalogValue
										+ " uuid=" + json[i].uuid + ">"
										+ json[i].catalogName + "</option>")
								.appendTo("#catalogsdiv>select:last");
					}
				}
			}
		});
	}
}
function getElementLeft(element) {
	var actualLeft = element.offsetLeft;
	var current = element.offsetParent;

	while (current !== null) {
		actualLeft += current.offsetLeft;
		current = current.offsetParent;
	}
	return actualLeft;
}

function getElementTop(element) {
	var actualTop = element.offsetTop;
	var current = element.offsetParent;

	while (current !== null) {
		actualTop += current.offsetTop;
		current = current.offsetParent;
	}
	return actualTop;
}

function openCatalogs(obj, moduleCode, typeCode) {
	if ($("#catalogparentdiv")) {
		$("#catalogparentdiv").remove();
	}
	var otop = getElementTop(obj) + obj.offsetHeight;
	var oleft = getElementLeft(obj);
	$(
			"<div id=\"catalogparentdiv\" style=\"z-index:9999;PADDING-RIGHT: 4px; PADDING-LEFT: 4px; Z-INDEX: 1000; BACKGROUND: #aac7e7; PADDING-BOTTOM: 4px; PADDING-TOP: 4px; POSITION: absolute; moz-box-shadow: 0 0 4px rgba(0,0,0,0.4); webkit-box-shadow: 0 0 4px rgba(0,0,0,0.4); box-shadow: 0 0 4px rgba(0,0,0,0.4); o-box-shadow: 0 0 4px rgba(0,0,0,0.4);white-space:nowrap;background-color:lightblue;position:absolute;width:auto;height:auto;top:"
					+ otop
					+ "px;left:"
					+ oleft
					+ "px\"><div id=\"catalogsdiv\"></div><input name=\"getCatalogsBtn\" type=\"button\" value=\"确定\" />&nbsp;<input name=\"closeCatalogsBtn\" type=\"button\" value=\"关闭\" />&nbsp;<input name=\"clearCatalogsBtn\" type=\"button\" value=\"清空\" /></div>")
			.appendTo(document.body);
	$("#catalogparentdiv").ready(function() {
		$("input[name=getCatalogsBtn]").click(function() {
			getCatalogsValue(obj);
		});
	});
	$("#catalogparentdiv").ready(function() {
		$("input[name=closeCatalogsBtn]").click(function() {
			$("#catalogparentdiv").remove();
		});
	});
	$("#catalogparentdiv").ready(function() {
		$("input[name=clearCatalogsBtn]").click(function() {
			obj.value = "";
			$("#catalogparentdiv").remove();
		});
	});
	showCatalogs(moduleCode, typeCode);
}
function getCatalogsValue(obj) {
	var catalogsValue = "";
	$("select[name=temp_catalogs]").each(function() {
		catalogsValue += $(this).children("option:selected").val();
	});
	obj.value = catalogsValue;
	$("#catalogparentdiv").remove();
}