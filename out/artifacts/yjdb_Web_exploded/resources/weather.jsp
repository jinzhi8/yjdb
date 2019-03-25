<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
	<title> New Document </title>
	<meta name="Generator" content="EditPlus">
</head>
<script language="javascript" src="prototype.js"></script>
<script language="javascript">

	//取得中国所有的城市
	function getCity() {
		var url = "http://192.168.1.222/com.kizsoft.oa/resources/geturl.jsp";
		var cityPara = {method:"get" ,
			parameters:"url=" + encodeURIComponent("http://www.google.com/ig/cities?output=xml&hl=zh-cn&country=cn"),
			onComplete:showCityRespose
		};
		var cityRequest = new Ajax.Request(url, cityPara);
	}
	function createXMLDOM() {

		var arrSignatures = ["MSXML2.DOMDocument.5.0", "MSXML2.DOMDocument.4.0",
			"MSXML2.DOMDocument.3.0", "MSXML2.DOMDocument",
			"Microsoft.XmlDom"];

		for (var i = 0; i < arrSignatures.length; i++) {
			try {

				var oXmlDom = new ActiveXObject(arrSignatures[i]);

				return oXmlDom;

			} catch (oError) {
				//ignore
			}
		}

		throw new Error("你的系统没有安装MSXML");
	}
	function showCityRespose(originalRequest) {
		cityInfo = originalRequest.responseXML;
		//alert("-"+originalRequest.responseText);
		//cityInfo = createXMLDOM();
		//try{
		//	cityInfo.loadXML(originalRequest.responseText);
		//}catch(e){
		//	var oParser=new DOMParser();
		//	cityInfo=oParser.parseFromString(originalRequest.responseText,"text/xml");
		//}
		//alert(cityInfo);
		cityNodes = cityInfo.getElementsByTagName("city");
		//alert(cityNodes.length);
		for (var i = 0; i < cityNodes.length; i++) {
			var city = cityNodes[i];
			var cityName = getData(city, "name");
			var latitude = getData(city, "latitude_e6");
			var longitude = getData(city, "longitude_e6");
			var option = document.createElement("option");
			$("city").options.add(option);
			option.innerText = cityName;
			option.value = ",,," + latitude + "," + longitude;
		}
	}
	function forecast(city) {
		$("result").innerHTML = "请稍等";
		var url = "http://192.168.1.222/com.kizsoft.oa/resources/geturl.jsp";
		var para = {method:"get" ,
			parameters:"url=" + encodeURIComponent("http://www.google.com/ig/api?hl=zh-cn&weather=") + encodeURIComponent(city) ,
			onComplete:showResult
		};
		var forecastRequest = new Ajax.Request(url, para);
	}

	//显示预报结果
	function showResult(originalRequest) {
		$("result").innerHTML = "";
		resultXML = originalRequest.responseXML;
		forecastNodes = resultXML.getElementsByTagName("forecast_conditions");
		alert(originalRequest.responseText);
		alert(forecastNodes.length);
		for (i = 0; i < forecastNodes.length; i++) {
			var oneNode = forecastNodes[i];
			var weekday = getData(oneNode, "day_of_week");
			var low = getData(oneNode, "low");
			var high = getData(oneNode, "high");
			var icon = getData(oneNode, "icon");
			var result = document.createElement("div");
			result.appendChild(document.createTextNode(weekday));
			result.appendChild(document.createElement("br"));
			result.appendChild(document.createTextNode("最低温度" + low));
			result.appendChild(document.createElement("br"));
			result.appendChild(document.createTextNode("最高温度" + high));
			result.appendChild(document.createElement("br"));
			var image = document.createElement("img");
			image.setAttribute("src", "http://www.google.com" + icon);
			result.appendChild(image);
			$("result").appendChild(result);
		}
		//alert($("result").innerHTML);
	}

	//取得数据值
	function getData(parentNode, nodeName) {
		return parentNode.getElementsByTagName(nodeName)[0].getAttribute("data");
	}
</script>
<body onLoad="getCity()">
<div id="selectcity">
	<form name="form1" method="post" action="">
		<select name="city" id="city" onChange="forecast(this.value)">
			<option value="">选择城市</option>
		</select>
	</form>
</div>

<div id="result">

</div>
</body>
</html><!--索思奇智版权所有-->