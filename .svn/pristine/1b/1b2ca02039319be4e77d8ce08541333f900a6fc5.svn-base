<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="com.kizsoft.commons.commons.util.StringHelper,com.kizsoft.commons.uum.pojo.Owner,com.kizsoft.commons.uum.service.IUUMService,com.kizsoft.commons.uum.utils.UUMContend,com.kizsoft.oa.docreport.beans.DocExchange" %>
<%@page import="java.util.ArrayList" %>
<%@page import="java.util.List" %>
<html>
<!--
<META HTTP-EQUIV="Pragma" CONTENT="no-cache" />
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache" />
<META HTTP-EQUIV="Expires" CONTENT="0" />
-->
<head>
	<title>公文收发组</title>
</head>
<SCRIPT LANGUAGE="JavaScript">
	var userAgent = navigator.userAgent.toLowerCase();
	var isNoIE=/(mozilla|opera|webkit)/.test(userAgent) && !/(compatible)/.test(userAgent);
	window.onerror = on_error;
	function on_error() {
		//arglen=arguments.length;
		//var errorMsg="参数个数："+arglen+"个";
		//for(var i=0;i<arglen;i++){
		//	errorMsg+="\n参数"+(i+1)+"："+arguments[i];
		//}
		//alert(errorMsg);
		//window.onerror=null;
		return true;
	}
	var fields = null;
	var nameField = null;
	var idField = null;
	var url = window.location.href;
	var paramstr = url.substr(url.indexOf("?") + 1);
	var params = paramstr.split("&");
	if (params.length) {
		for (i = 0; i < params.length; i++) {
			if (params[i].indexOf("count=") > -1) {
				var tmpCount = params[i].substr(params[i].indexOf("count=") + 6);
				if (tmpCount != null && tmpCount != "" && !isNaN(tmpCount)) {
					checkCount = parseInt(tmpCount);
				}
			} else if (params[i].indexOf("fields=") > -1) {
				fields = params[i].substr(params[i].indexOf("fields=") + 7);
			} else if (params[i].indexOf("sflag=") > -1) {
				starFlag = params[i].substr(params[i].indexOf("sflag=") + 6);
			}
		}
	}
	if (fields != null && fields != "") {
		var returnFields = fields.split(",");
		if(isNoIE){
			nameField = window.opener.document.getElementsByName(returnFields[0])[0];
			idField = window.opener.document.getElementsByName(returnFields[1])[0];
    }else{
			nameField = window.dialogArguments.document.getElementsByName(returnFields[0])[0];
			idField = window.dialogArguments.document.getElementsByName(returnFields[1])[0];
    }
	}
	function returnValue(o) {
		var nameList = "";
		var idList = "";
		for (var i = 0; i < o.length; i++) {
			if (o[i].checked) {
				nameList += o[i].attributes['text'].nodeValue + ","; 
				idList += o[i].value + ",";
			}
		}
		if (nameList.lastIndexOf(",") > 0) {
			nameList = nameList.substring(0, nameList.lastIndexOf(","))
		}
		if (idList.lastIndexOf(",") > 0) {
			idList = idList.substring(0, idList.lastIndexOf(","))
		}
		//if(nameList=="") nameList="*";
		//if(idList=="*") idList="*";
		nameField.value = nameList;
		idField.value = idList;
	}
	function loadValue(o) {
		var names = nameField.value;
		var ids = idField.value;
		var nameList = names.split(",");
		var idList = ids.split(",");
		for (var i = 0; i < o.length; i++) {
			for (var j = 0; j < idList.length; j++) {
				if (idList[j] == o[i].value) {
					o[i].checked = true;
				}
			}
		}
		_gettotal();
	}
	function _sl_group(o,g,b){
        for(var i=0;i<o.length;i++){
            //obj.attributes['clickCount'].nodeValue
            if(o[i].attributes['group'].nodeValue==g)o[i].checked = b
            //if(o[i].checked!=b){o[i].click();}
        }
        _gettotal();
    }
    function _dsl_group(o,g){
        for(var i=0;i<o.length;i++){
            if(o[i].attributes['group'].nodeValue==g){
                if(o[i].checked){
                    o[i].checked = false;
                }
                else{
                    o[i].checked = true;
                    //if(o[i].checked!=b){o[i].click();}
                }
            }
        }
        _gettotal();
    }
	function _sl(o, b) {
		for (var i = 0; i < o.length; i++) {
			o[i].checked = b
			//if(o[i].checked!=b){o[i].click();}
		}
		_gettotal();
	}
	function _dsl(o) {
		for (var i = 0; i < o.length; i++) {
			if (o[i].checked) {
				o[i].checked = false;
			} else {
				o[i].checked = true;
				//if(o[i].checked!=b){o[i].click();}
			}
		}
		_gettotal();
	}
	function _find(obj, str, check) {
		if (str == "") {
			alert("请输入关键字!");
			//obj.focus();
			return false;
		}
		for (var i = 0; i < obj.length; i++) {
			if (obj[i].attributes['text'].nodeValue.indexOf(str) != -1) {
				if (check) {
					obj[i].checked = true;
				}
				obj[i].style.backgroundColor = "orangered";
				obj[i].focus();
			}
		}
		_gettotal();
	}
	function _clear(obj) {
		for (var i = 0; i < obj.length; i++) {
			if (obj[i].style.backgroundColor == "orangered") {
				if (obj[i].checked) {
					obj[i].style.backgroundColor = "#4169E1";
				} else {
					obj[i].style.backgroundColor = "";
				}
			}
		}
	}
	function _checkvalue(obj) {
		if (obj.value == "") {
			alert("请输入关键字!");
			obj.focus();
			return false;
		}
	}
	function _gettotal() {
		var o = document.getElementsByName("ck");
		var b = true;
		var totalselected = 0;
		for (var i = 0; i < o.length; i++) {
			//o[i].checked = b
			//if(o[i].checked!=b){o[i].click();}
			if (o[i].checked) {
				totalselected++;
				if (o[i].style.backgroundColor == "") {
					o[i].style.backgroundColor = "#4169E1";
				}
			} else {
				if (o[i].style.backgroundColor == "orangered") {
				} else {
					o[i].style.backgroundColor = "";
				}
			}
		}
		document.getElementById("totalselected").value = "已经选中" + totalselected + "个";
		document.getElementById("totalselected2").value = "已经选中" + totalselected + "个";
	}
</SCRIPT>
<body style="font-size:9pt" onload="loadValue(document.getElementsByName('ck'));list_group();">
<br>

<div align="center" style="font-size:9pt">
	<input type=text name="searchstr" value="" size="20">
	<input type=button value="搜索" onclick="document.all.searchstr2.value=document.all.searchstr.value;_find(document.getElementsByName('ck'),document.all.searchstr.value,false);">
	<input type=button value="搜索&选中" onclick="document.all.searchstr2.value=document.all.searchstr.value;_find(document.getElementsByName('ck'),document.all.searchstr.value,true);">
	<input type=button value="清除标记" onclick="_clear(document.getElementsByName('ck'));">
	<input type=button value="全选" onclick="_sl(document.getElementsByName('ck'),true);">
	<input type=button value="清除" onclick="_sl(document.getElementsByName('ck'),false);">
	<input type=button value="反选" onclick="_dsl(document.getElementsByName('ck'));">
	<input type=button value="确定" onclick="returnValue(document.getElementsByName('ck'));window.close();">
	<input type=button value="取消" onclick="window.close();">
	<input type=text id=totalselected name=totalselected value="" readonly size="15">
</div>
<hr>
<table width="100%" border="0" align="center">
	<tr>
		<td align="center" style="width:80%;border:1px solid #4169E1;">
			<div style="width:100%;height:100%;overflow:auto">
				<% //用户登陆验证
					if (session.getAttribute("userInfo") == null) {
						response.sendRedirect(request.getContextPath() + "/login.jsp");
						//request.getRequestDispatcher("/login.jsp").forward(request,response);
					}
					IUUMService iuumService = UUMContend.getUUMService();
					String getGroup = StringHelper.isNull(request.getParameter("group")) ? "" : request.getParameter("group");
					if("".equals(getGroup)){
						List topLevelList =  new ArrayList();
						topLevelList = iuumService.getTopLevel();
						if(topLevelList!=null&&topLevelList.size()==1){
							topLevelList = iuumService.getDeptChildByOwnerId(((Owner)topLevelList.get(0)).getId());
						}
						for (int j = 0; j < topLevelList.size(); j++) {
							Owner topOwner = (Owner)topLevelList.get(j);
							if("".equals(getGroup)){
								getGroup = topOwner.getOwnercode();
							}else{
								getGroup += "," + topOwner.getOwnercode();
							}
						}
					}
					String getRows = StringHelper.isNull(request.getParameter("row")) ? "4" : request.getParameter("row");
					String[] groupList = StringHelper.split(getGroup, ",", true);
					List list = new ArrayList();
					
					int m = 1;
					for (int j = 0; j < groupList.length; j++) {
						Owner owner = iuumService.getOwnerByOwnercode(groupList[j]);
						list = iuumService.getAllChildDeptByOwnerId(owner.getId());
						if (list != null) {
							out.print("<fieldset><legend><b>" + owner.getOwnername() + "</b>&nbsp;<input type=button value=\"全选\" onClick=\"_sl_group(document.getElementsByName('ck'),'"+owner.getId()+"',true);\">&nbsp;<input type=button value=\"清除\" onClick=\"_sl_group(document.getElementsByName('ck'),'"+owner.getId()+"',false);\">&nbsp;<input type=button value=\"反选\" onClick=\"_dsl_group(document.getElementsByName('ck'),'"+owner.getId()+"');\"></legend>");
							out.print("<table width='100%' style='font-size:9pt'>");
							out.print("<tr>");
							int p = 1;
							/**
							if(owner.getFlag()==4){
								out.print("<td align=left><input type='checkbox' style='color:orange;height:15px;' onclick='_gettotal();' name='ck' id=ck" + m + " group='"+owner.getId()+"' value='" + owner.getId() + "' text=" + owner.getOwnername() + " ><label for='ck" + m + "'>" + owner.getOwnername() + "</label><td>");
								if ((p) % Integer.parseInt(getRows) == 0 && p != 1){ 
									out.print("</tr><tr>");
								}
								p++;
								m++;
							}
							**/
							for (int k = 0; k < list.size(); k++) {
								if(((Owner) (list.get(k))).getFlag()==4||((Owner) (list.get(k))).getFlag()==3){
									out.print("<td align=left><input type='checkbox' style='color:orange;height:15px;' onclick='_gettotal();' name='ck' id=ck" + m + " group='"+owner.getId()+"' value='" + ((Owner) (list.get(k))).getId() + "' text=" + ((Owner) (list.get(k))).getOwnername() + " ><label for='ck" + m + "'>" + ((Owner) (list.get(k))).getOwnername() + "</label><td>");
									if ((p) % Integer.parseInt(getRows) == 0 && p != 1){ 
										out.print("</tr><tr>");
									}
									p++;
									m++;
								}
							}
							out.print("</tr>");
							out.print("</table>");
							out.print("</fieldset>");
						}
					}%>
			</div>
		</td>
		<td style="width:20%;font-size:9pt" valign="top">
			<div style="width:100%;overflow:auto;margin:0px 0px;margin-top:0px;padding:2 5;color:white;align:center;font-weight:bold;background-color:#4169E1;border:1px solid #4169E1;">
				自定义公文收发组
			</div>
			<div style="width:100%;overflow:auto;margin:0px 0px;margin-bottom:0px;padding:5 5 5 10;background-color:#eee;line-height:1.4;color:black;border:1px solid #4169E1;">
				<input type=text name="grouptype" value="" size="20" title="请在文本框处输入自定义公文收发组的名字。">
				<input type=hidden name="grouptypeid">
				<input type=hidden name="groupuserid">
				<input type=hidden name="groupid" value="<%=getGroup%>">
				<input type=button value="保存公文收发组" onclick='insert_group();' title="保存所选人员或单位为一个&#13&#10自定义公文收发组&#13&#10以便下次快速选中当前所选人员。">
			</div>
			<div id="grouplist" style="word-wrap:break-word;width:100%;height:60%;overflow:auto;margin:0px 0px;margin-bottom:0px;padding:5 5 5 1;background-color:#eee;line-height:1.4;color:black;border:1px solid #4169E1;"></div>
		</td>
	</tr>
</table>
<script>
	function myXMLHttpRequest() {
		var xmlHttp = false;
		try {
			xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
		} catch (e) {
			try {
				xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
			} catch (e2) {
				xmlHttp = false;
			}
		}
		if (!xmlHttp && typeof XMLHttpRequest != 'undefined') {
			xmlHttp = new XMLHttpRequest();
		}
		return xmlHttp;
	}
	function get_selected(o) {
		var userIDList = "";
		for (var i = 0; i < o.length; i++) {
			if (o[i].checked) {
				userIDList += o[i].value + ",";
			}
		}
		if (userIDList.lastIndexOf(",") > 0) {
			userIDList = userIDList.substring(0, userIDList.lastIndexOf(","))
		}
		return userIDList;
	}
	function insert_group() {
		document.all.groupuserid.value = get_selected(document.getElementsByName('ck'));
		groupUserID = document.all.groupuserid.value;
		groupType = encodeURIComponent(Trim(document.all.grouptype.value));
		groupID = document.all.groupid.value;
		if (groupUserID != "" && groupType != "" && groupID != "") {
			var xmlHttp = new myXMLHttpRequest();
			content = "action=insert&grouptypeid=&grouptype=" + groupType + "&groupuserid=" + groupUserID + "&groupid=" + groupID;
			xmlHttp.open("POST", "docgroupsact.jsp", false);
			xmlHttp.setRequestHeader("Content-Length", content.length);
			xmlHttp.setRequestHeader("CONTENT-TYPE", "application/x-www-form-urlencoded");
			xmlHttp.send(content);
			//xmlHttp.onreadystatechange = responseShow;
			if (xmlHttp.responseText.indexOf("success") > 0) {
				list_group();
			}
			delete xmlHttp;
			document.all.grouptype.value = "";
			document.all.groupuserid.value = "";
		} else {
			if (groupUserID == "") {
				alert("请选择接收人员！");
			} else if (groupType == "") {
				document.all.grouptype.value = "";
				document.all.grouptype.focus();
				alert("请输入自定义组名字！");
			} else if (groupID == "") {
				alert("其他类型错误！");
			}
		}
	}
	function list_group() {
		var xmlHttp = new myXMLHttpRequest();
		groupID = document.all.groupid.value;
		content = "action=list&groupid=" + groupID;
		xmlHttp.open("POST", "docgroupsact.jsp", false);
		xmlHttp.setRequestHeader("Content-Length", content.length);
		xmlHttp.setRequestHeader("CONTENT-TYPE", "application/x-www-form-urlencoded");
		xmlHttp.send(content);
		//xmlHttp.onreadystatechange = responseShow;
		document.getElementById("grouplist").innerHTML = Trim(xmlHttp.responseText);
		delete xmlHttp;
	}
	function select_group(groupTypeID) {
		var xmlHttp = new myXMLHttpRequest();
		content = "action=select&grouptypeid=" + groupTypeID;
		xmlHttp.open("POST", "docgroupsact.jsp", false);
		xmlHttp.setRequestHeader("Content-Length", content.length);
		xmlHttp.setRequestHeader("CONTENT-TYPE", "application/x-www-form-urlencoded");
		xmlHttp.send(content);
		_sl(document.getElementsByName('ck'), false);
		select_user(Trim(xmlHttp.responseText));
		delete xmlHttp;
	}
	function delete_group(groupTypeID) {
		if (confirm("您是否删除这个自定义组？")) {
			var xmlHttp = new myXMLHttpRequest();
			content = "action=delete&grouptypeid=" + groupTypeID;
			xmlHttp.open("POST", "docgroupsact.jsp", false);
			xmlHttp.setRequestHeader("Content-Length", content.length);
			xmlHttp.setRequestHeader("CONTENT-TYPE", "application/x-www-form-urlencoded");
			xmlHttp.send(content);
			delete xmlHttp;
			list_group();
		}
	}
	function up_group(groupTypeID) {
		var xmlHttp = new myXMLHttpRequest();
		content = "action=up&grouptypeid=" + groupTypeID;
		xmlHttp.open("POST", "docgroupsact.jsp", false);
		xmlHttp.setRequestHeader("Content-Length", content.length);
		xmlHttp.setRequestHeader("CONTENT-TYPE", "application/x-www-form-urlencoded");
		xmlHttp.send(content);
		delete xmlHttp;
		list_group();
	}
	function down_group(groupTypeID) {
		var xmlHttp = new myXMLHttpRequest();
		content = "action=down&grouptypeid=" + groupTypeID;
		xmlHttp.open("POST", "docgroupsact.jsp", false);
		xmlHttp.setRequestHeader("Content-Length", content.length);
		xmlHttp.setRequestHeader("CONTENT-TYPE", "application/x-www-form-urlencoded");
		xmlHttp.send(content);
		delete xmlHttp;
		list_group();
	}
	function select_user(userIDList) {
		var obj = document.getElementsByName('ck');
		for (var i = 0; i < obj.length; i++) {
			if (userIDList.indexOf(obj[i].value) > 0) {
				obj[i].checked = true;
			}
		}
		_gettotal();
	}
	function responseShow() {
		if (xmlHttp.readyState == 4) {
			var response = xmlHttp.responseText;
			alert(response);
		}
	}

	function Trim(TRIM_VALUE) {
		if (TRIM_VALUE.length < 1) {
			return"";
		}
		TRIM_VALUE = RTrim(TRIM_VALUE);
		TRIM_VALUE = LTrim(TRIM_VALUE);
		if (TRIM_VALUE == "") {
			return "";
		} else {
			return TRIM_VALUE;
		}
	} //End Function

	function RTrim(VALUE) {
		var w_space = String.fromCharCode(32);
		var v_length = VALUE.length;
		var strTemp = "";
		if (v_length < 0) {
			return"";
		}
		var iTemp = v_length - 1;

		while (iTemp > -1) {
			if (VALUE.charAt(iTemp) == w_space) {
			} else {
				strTemp = VALUE.substring(0, iTemp + 1);
				break;
			}
			iTemp = iTemp - 1;
		} //End While
		return strTemp;
	} //End Function

	function LTrim(VALUE) {
		var w_space = String.fromCharCode(32);
		if (v_length < 1) {
			return"";
		}
		var v_length = VALUE.length;
		var strTemp = "";

		var iTemp = 0;

		while (iTemp < v_length) {
			if (VALUE.charAt(iTemp) == w_space) {
			} else {
				strTemp = VALUE.substring(iTemp, v_length);
				break;
			}
			iTemp = iTemp + 1;
		} //End While
		return strTemp;
	} //End Function
</script>
<div align="center" style="font-size:9pt;display:none;">
	<% DocExchange docExchange = new DocExchange();
		//System.out.println(docExchange.post("http://localhost/oa/login.do", "username=admin&password=12345"));
		//out.println(docExchange.post("http://localhost/weboa/docreport/getexchangeuser.jsp", ""));
		String edocURLStr = docExchange.getEdocURL();
		String[] edocURLList = StringHelper.split(edocURLStr, "|", true);
		for (int i = 0; i < edocURLList.length; i++) {%>	<br/>

	<div style="width:100%;overflow:auto;margin:0px 0px;margin-top:0px;padding:2 5;color:white;align:center;font-weight:bold;background-color:#4169E1;border:1px solid #4169E1;">
		<b><%=edocURLList[i].substring(0, edocURLList[i].indexOf(","))%>
		</b>
	</div>
	<div style="width:100%;overflow:auto;margin:0px 0px;margin-bottom:0px;padding:5 5 5 10;background-color:#eee;line-height:1.4;color:black;border:1px solid #4169E1;display:none;">
		<% //out.println(edocURLList[i].substring(edocURLList[i].indexOf(",")+1,edocURLList[i].length()));
			String docExchangeUserStr = docExchange.post(edocURLList[i].substring(edocURLList[i].indexOf(",") + 1, edocURLList[i].length()), "");
			//out.println("--"+docExchangeUserStr+"--");
			if (!"".equals(docExchangeUserStr) && docExchangeUserStr != null) {
				String[] docExchangeList = StringHelper.split(docExchangeUserStr, "|", true);
				for (int j = 0; j < docExchangeList.length; j++) {
					//Owner owner = iuumService.getOwnerByOwnercode(docExchangeList[j]);
					//out.println(docExchangeList[j]);
					//out.println(docExchangeList[j].substring(docExchangeList[j].indexOf(","),docExchangeList[j].length())+"<br>");
					out.print("<input type='checkbox' style='color:orange;height:15px;' onclick='_gettotal();' name='ck' id=ck" + (m + j) + " value='" + docExchangeList[j].substring(0, docExchangeList[j].indexOf(",")) + "' text='" + docExchangeList[j].substring(docExchangeList[j].indexOf(",") + 1, docExchangeList[j].length()) + "' ><label for='ck" + (m + j) + "'>" + docExchangeList[j].substring(docExchangeList[j].indexOf(",") + 1, docExchangeList[j].length()) + "</label>");
					m++;
				}
			}
			//out.print("<input type='checkbox' style='color:orange;height:15px;' onclick='_gettotal();' name='ck' id=ck"+(m+j)+" value='"+docExchangeList[j].substring(1,docExchangeList[j].indexOf(","))+"' text='"+docExchangeList[j].substring(docExchangeList[j].indexOf(",")+1,docExchangeList[j].length())+"' ><label for='ck"+(m+j)+"'>"+docExchangeList[j].substring(docExchangeList[j].indexOf(",")+1,docExchangeList[j].length())+"</label>");

		%>
	</div>
	<%

		}

	%>
	&nbsp;<br/>

</div>
<hr>
<div align="center" style="font-size:9pt">
	<input type=text name="searchstr2" value="" size="20">
	<input type=button value="搜索" onclick="document.all.searchstr.value=document.all.searchstr2.value;_find(document.getElementsByName('ck'),document.all.searchstr2.value,false);">
	<input type=button value="搜索&选中" onclick="document.all.searchstr.value=document.all.searchstr2.value;_find(document.getElementsByName('ck'),document.all.searchstr2.value,true);">
	<input type=button value="清除标记" onclick="_clear(document.getElementsByName('ck'));">
	<input type=button value="全选" onclick="_sl(document.getElementsByName('ck'),true);">
	<input type=button value="清除" onclick="_sl(document.getElementsByName('ck'),false);">
	<input type=button value="反选" onclick="_dsl(document.getElementsByName('ck'));">
	<input type=button value="确定" onclick="returnValue(document.getElementsByName('ck'));window.close();">
	<input type=button value="取消" onclick="window.close();">
	<input type=text id=totalselected2 name=totalselected2 value="" readonly size="15">
</div>
<br>
<br>
</body>
</html>
<!--索思奇智版权所有-->