var userAgent = navigator.userAgent.toLowerCase();
var isNoIE = /(mozilla|opera|webkit)/.test(userAgent)
		&& !/(compatible)/.test(userAgent);
var checkedIdList = new Array();
var checkedNameList = new Array();
var checkedObjList = new Array();
var removedIdList = new Array();

var utype = "1";
var dtype = "0";
var rtype = "0";
var ptype = "1";
var atype = "0";
var gtype = "0";
var checkCount = 1;
var fields = null;
var nameField = null;
var idField = null;
var setCountFlag = false;
var activid = null;
var range = null;
var starFlag = "1";

var url = window.location.href;
var paramstr = url.substr(url.indexOf("?") + 1);
var params = paramstr.split("&");
if (params.length) {
	for (i = 0; i < params.length; i++) {
		if (params[i].indexOf("utype=") > -1) {
			utype = params[i].substr(params[i].indexOf("utype=") + 6);
		} else if (params[i].indexOf("dtype=") > -1) {
			dtype = params[i].substr(params[i].indexOf("dtype=") + 6);
		} else if (params[i].indexOf("rtype=") > -1) {
			rtype = params[i].substr(params[i].indexOf("rtype=") + 6);
		} else if (params[i].indexOf("ptype=") > -1) {
			ptype = params[i].substr(params[i].indexOf("ptype=") + 6);
		} else if (params[i].indexOf("atype=") > -1) {
			atype = params[i].substr(params[i].indexOf("atype=") + 6);
		} else if (params[i].indexOf("gtype=") > -1) {
			gtype = params[i].substr(params[i].indexOf("gtype=") + 6);
		} else if (params[i].indexOf("count=") > -1) {
			var tmpCount = params[i].substr(params[i].indexOf("count=") + 6);
			if (tmpCount != null && tmpCount != "" && !isNaN(tmpCount)) {
				checkCount = parseInt(tmpCount);
			}
		} else if (params[i].indexOf("fields=") > -1) {
			fields = params[i].substr(params[i].indexOf("fields=") + 7);
		} else if (params[i].indexOf("activid=") > -1) {
			activid = params[i].substr(params[i].indexOf("activid=") + 8);
		} else if (params[i].indexOf("range=") > -1) {
			range = params[i].substr(params[i].indexOf("range=") + 6);
		} else if (params[i].indexOf("sflag=") > -1) {
			starFlag = params[i].substr(params[i].indexOf("sflag=") + 6);
		}
	}
}
if (fields != null && fields != "") {
	var returnFields = fields.split(",");
	// nameField =
	// window.dialogArguments.document.all[returnFields[0].toString()];
	// idField =
	// window.dialogArguments.document.all[returnFields[1].toString()];
	if (isNoIE) {
		nameField = window.opener.document.getElementsByName(returnFields[0])[0];
		idField = window.opener.document.getElementsByName(returnFields[1])[0];
	} else {
		nameField = window.dialogArguments.document
				.getElementsByName(returnFields[0])[0];
		idField = window.dialogArguments.document
				.getElementsByName(returnFields[1])[0];
	}
}

// utype 地址本类型 1、根节点选择 2、父节点选择 3、根节点与父节点都允许选择
// 对应于系统中 1、只选择用户 2、只选择部门 3、用户与部门都允许选择
// count 允许被选择的 checkbox 数量 0表示不限量选择
function loadWebFX(text, action, type) {
	if (type == "utype") {
		if (action.indexOf("?") > -1)
			action = action + "&utype=" + utype;
		else
			action = action + "?utype=" + utype;

		if (activid != null && activid != "") {
			action = action + "&activid=" + activid;
		}

		if (range != null && range != "") {
			action = action + "&range=" + range;
		}

		return new WebFXLoadTree(text, action);
	} else if (type == "dtype") {
		if (action.indexOf("?") > -1)
			action = action + "&dtype=" + dtype;
		else
			action = action + "?dtype=" + dtype;

		if (activid != null && activid != "") {
			action = action + "&activid=" + activid;
		}

		if (range != null && range != "") {
			action = action + "&range=" + range;
		}
		return new WebFXLoadTree(text, action);
	} else if (type == "rtype") {
		return new WebFXLoadTree(text, action);
	} else if (type == "ptype") {
		if (action.indexOf("?") > -1)
			action = action + "&ptype=" + ptype;
		else
			action = action + "?ptype=" + ptype;

		if (activid != null && activid != "") {
			action = action + "&activid=" + activid;
		}

		if (range != null && range != "") {
			action = action + "&range=" + range;
		}

		return new WebFXLoadTree(text, action);
	} else if (type == "atype") {
		if (action.indexOf("?") > -1)
			action = action + "&atype=" + atype;
		else
			action = action + "?atype=" + atype;

		return new WebFXLoadTree(text, action);
	} else if (type == "gtype") {
		if (action.indexOf("?") > -1)
			action = action + "&gtype=" + gtype;
		else
			action = action + "?gtype=" + gtype;

		return new WebFXLoadTree(text, action);
	}

}

function loadWeb() {
	if (ptype != null && ptype != "" && ptype != "0") {
		document.write(loadWebFX("个人地址本", "personalTree.do", "ptype"));
	}
	if (atype != null && atype != "" && atype != "0") {
		document.write(loadWebFX("公共通讯录", "publicAddressTree.do", "atype"));
	}
	if (gtype != null && gtype != "" && gtype != "0") {
		document.write(loadWebFX("个人通讯录", "personalAddressTree.do", "gtype"));
	}
	if (utype != null && utype != "" && utype != "0") {
		utree = new loadWebFX("组织机构", "userTree.do", "utype");
		document.write(utree);
	}
	if (dtype != null && dtype != "" && dtype != "0") {
		// document.write(loadWebFX("公文交换","docTree.do","dtype"));
	}
	if (rtype != null && rtype != "" && rtype != "0") {
		document.write(loadWebFX("角色选择", "roleTree.do", "rtype"));
	}
}

function checkNode(obj, userid, username) {
	username = obj.getAttribute('text');
	if (obj.checked) {
		if (checkCount > 0) {
			if (checkedIdList.length == checkCount) {
				if (checkCount == 1) {
					resetCheck();
					obj.checked = true;
				} else {
					alert("可选择的人员数量已满");
					obj.checked = false;
					return false;
				}
			}
		}
		addCheck(userid, username,obj);
	} else {
		removeCheck(userid);
	}
}

function addCheck(userid, username,obj) {
	checkedIdList[checkedIdList.length] = userid;
	checkedNameList[checkedNameList.length] = username;
	checkedObjList[checkedObjList.length] = obj.attributes('id').value;
	//alert(checkedNameList);
	//alert(checkedObjList);
	showcheckeduser();
}

function removeCheck(userid) {
	if (checkedIdList.length > 0) {
		for (i = 0; i < checkedIdList.length; i++) {
			if (checkedIdList[i] == userid) {
				if(document.getElementById(checkedObjList[i])){
					document.getElementById(checkedObjList[i]).checked=false;
				}
				for (j = i; j < checkedIdList.length - 1; j++) {
					checkedIdList[j] = checkedIdList[j + 1];
					checkedNameList[j] = checkedNameList[j + 1];
					checkedObjList[j] = checkedObjList[j + 1];
				}
				if(checkedIdList.length>0){
					checkedIdList.length -= 1;
				}
				if(checkedNameList.length>0){
					checkedNameList.length -= 1;
				}
				if(checkedObjList.length>0){
					checkedObjList.length -= 1;
				}
				break;
			}
		}
	}
	//reloadSelection();
	showcheckeduser();
}

function resetCheck() {
	var checkObj = document.all["selCheckObj"];
	if (checkObj.length) {
		for (i = 0; i < checkObj.length; i++) {
			checkObj[i].checked = false;
		}
	} else {
		checkObj.checked = false;
	}

	checkedIdList = new Array();
	checkedNameList = new Array();
	checkedObjList = new Array();
	removedIdList = new Array();
}

function addRemovedIdList(userid) {
	removedIdList[removedIdList.length] = userid;
}

function removeFromRemovedIdList(userid) {
	var resumeFlag = false;
	if (removedIdList.length > 0) {
		for (i = 0; i < removedIdList.length; i++) {
			if (removedIdList[i] == userid) {
				for (j = i; j < removedIdList.length - 1; j++) {
					removedIdList[j] = removedIdList[j + 1];
				}
				removedIdList.length -= 1;
				resumeFlag = true;
				break;
			}
		}
	}

	return resumeFlag;
}

function confirmSelection() {
	var names = "";
	var ids = "";

	if (checkedIdList.length > 0) {
		names = checkedNameList.join(",");
		ids = checkedIdList.join(",");
	} else {
		if (starFlag == "1") {
			names = "*";
			ids = "*";
		} else {
			names = "";
			ids = "";
		}

	}
	if (nameField) {
		nameField.value = names;
	}
	if (idField) {
		idField.value = ids;
	}
}
function showcheckeduser(){
	var htmlstr = "";
	if (checkedIdList.length >= 0) {
		for (i = 0; i < checkedIdList.length; i++) {
			htmlstr += "<span style='font-size:12px;'>"+checkedNameList[i]+"&nbsp;&nbsp;<a href='#' onclick='removeCheck(\""+checkedIdList[i]+"\");'>删除</a></span><br/>";
			//htmlstr += "<span onclick='removeCheck(\""+checkedIdList[i]+"\");'>"+checkedNameList[i]+"&nbsp;&nbsp;<a href='#' onclick='removeCheck(\""+checkedIdList[i]+"\");'>删除</a></span><br/>";
			//checkedIdList[j];
			//checkedNameList[j];
		}
		document.getElementById('userdiv').innerHTML = "已选择<span style='color:red'>"+checkedIdList.length+"</span>个用户<hr/>"+htmlstr;
		document.getElementById('userdiv').scrollTop = document.getElementById('userdiv').scrollHeight;
	}
}
function reloadSelection() {
	var names = "";
	var ids = "";

	if (nameField) {
		names = nameField.value;
	}
	if (idField) {
		ids = idField.value;
	}

	if (ids != null && ids != "" && ids != "*") {
		checkedNameList = names.split(",");
		checkedIdList = ids.split(",");
		removedIdList = ids.split(",");
	}
}
function clear_All() {
	checkedIdList = "";
	checkedNameList = "";
}

// 重置已选择列表
window.onload=function(){
	reloadSelection();
	showcheckeduser();
}
