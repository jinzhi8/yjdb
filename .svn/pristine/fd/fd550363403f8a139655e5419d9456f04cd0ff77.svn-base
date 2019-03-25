window.onerror = on_error;
function on_error() {
    arglen = arguments.length;
    var errorMsg = "参数个数：" + arglen + "个";
    for (var i = 0; i < arglen; i++) {
        errorMsg += "\n参数" + (i + 1) + "：" + arguments[i];
    }
    //alert(errorMsg);   
    //window.onerror=null;   
    return true;
}
/**
 * 根据ID获得元素
 * @param id
 * @return
 */
var $getId = function (id) {
    return "string" == typeof id ? document.getElementById(id) : id;
};

/**
 * 得到前一个元素
 * @param elem
 * @return
 */
function getPreviousSibling(elem) {
    //elem = document.getElementById(elem);
    elem = elem.previousSibling;
    while (elem.previousSibling && elem.tagName == 'undefined') {
        elem = elem.previousSibling;
    }
    return elem;
}

/**
 * 得到后一个元素
 * @param elem
 * @return
 */
function getNextSibling(elem) {
    //elem = document.getElementById(elem);
    elem = elem.nextSibling;
    while (elem.previousSibling && elem.tagName == 'undefined') {
        elem = elem.nextSibling;
    }
    return elem;
}

/**
 * 在制定元素后插入元素
 * @param new_node
 * @param existing_node
 * @return
 */
function insertAfter(new_node, existing_node) {
    if (existing_node.nextSibling) {
        existing_node.parentNode.insertBefore(new_node, existing_node.nextSibling);
    } else {
        existing_node.parentNode.appendChild(new_node);
    }
}

/**
 * 添加附件
 * @param obj
 * @param inputname
 * @return
 */
function appendAttachment(obj, inputname) {
    var previousObj = getPreviousSibling(obj);
    var inputElement = document.createElement("INPUT");
    inputElement.type = "file";
    inputElement.name = inputname;
    inputElement.onkeydown = function() {return false;}
    var brElement = document.createElement("BR");
    insertAfter(brElement, previousObj);
    insertAfter(inputElement, previousObj);
}
function setAction(actionField, actionName) {
    document.all[actionField].value = actionName;
}
function fucCheckNum(obj) {
    var i,j,strTemp;
    strTemp = "0123456789";
    if (obj.value.length == 0) {
        //return 0
    }
    for (i = 0; i < obj.value.length; i++) {
        j = strTemp.indexOf(obj.value.charAt(i));
        if (j == -1) {
            //说明有字符不是数字
            //return 0;
            alert("请填写数字！");
            obj.value = "";
            obj.focus();
        }
    }
    //说明是数字
    //return 1;
}
function getTimeStamp() {
    d = new Date();
    return ("ts=" + d.getTime());
}

/*替换字符串某位置的字符*/
function replace(str, pos, ch) {
    if ((pos >= str.length) || (pos < 0)) {
        return str;
    }
    var s1 = str.substr(0, pos);
    var s2 = str.substr(pos + 1, str.length - pos);
    return (s1 + ch + s2);
}
function replaceAll(str, regex, replacement) {
    var va = str;
    var temp = va.replace(regex, replacement);
    while (temp != va) {
        va = temp;
        temp = va.replace(regex, replacement);
    }
    return va;
}

function trim(str) {
    var strTmp;
    if ((str == "") || (str == null))
        return "";
    for (var i = 0; i < str.length && str.charAt(i) == " "; i++) ;
    strTmp = str.substring(i, str.length);

    for (var i = strTmp.length - 1; i > 0 && strTmp.charAt(i) == " "; i--) ;
    strTmp = strTmp.substring(0, i + 1);

    return strTmp;
}
// if there are same char in strSource and strInvalid, return false.
//For example: strSource="Abcdef'gh", strInvalid=" ';*& ", the result is false. because
// the strSource has "'"
function isValidStr(strSource, strInvalid) {
    var isValid = true;
    for (var i = 0; i < strSource.length && isValid == true; i++) {
        for (var j = 0; j < strInvalid.length; j++) {
            if (strSource.charAt(i) == strInvalid.charAt(j)) {
                isValid = false;
                break;
            }
        }
    }
    return isValid;
}

/*正常有效的输入值应该避免的字符*/
function getInValidStr() {
    return("'&*?%\"");
}

//回车时换行
function autoTab(input) {
    var keyCode = event.keyCode;
    var key = 0;
    if (keyCode == 13) {
        var index = -1, i = 0, found = false;
        while (i < input.form.length - 1 && index == -1) {
            if (input.form[i] == input) {
                if (input.form[i + 1].type == 'text') {
                    index = i;
                    key = 1;
                } else {
                    input = input.form[i + 1];
                    i++;
                }
            } else i++;
        }
        if (key == 1)
            input.form[(index + 1)].focus();
    }
}

//whether str is a  number.
function isNumber(str) {
    var oneChar;
    var isNum = true;

    str = str + "";

    if (str.length == 0)
        return false;

    if (str.charAt(0) == "-") {
        str = str.substr(1, str.length - 1);
    }

    if (str.length == 0)
        return false;

    for (var i = 0; i < str.length; i++) {
        oneChar = str.charAt(i);
        if ((oneChar < "0" || oneChar > "9") && oneChar != ".") {
            isNum = false;
        }
    }
    return isNum;
}

//whether str is a integer number.
function isInteger(str) {
    var oneChar;
    var isNum = true;

    str = str + "";

    if (str.length == 0)
        return false;

    if (str.charAt(0) == "-") {
        str = str.substr(1, str.length - 1);
    }

    if (str.length == 0)
        return false;

    for (var i = 0; i < str.length; i++) {
        oneChar = str.charAt(i);
        if (oneChar < "0" || oneChar > "9") {
            isNum = false;
        }
    }
    return isNum;
}

//whether str is a  number,小数点必须在几位内
function isNumberXsd(str, nxsd) {
    var oneChar;
    var isHasXsd = false;
    var iXSD = -1;

    var isNumTure = false;

    str = trim(str);

    if (nxsd < 0)
        return false; else if (nxsd == 0) {
        return isInteger(str);
    } else if (!isNumber(str))
        return false;

    for (var i = str.length; i > 0; i--) {
        oneChar = str.charAt(i);
        if (oneChar != ".")
            iXSD = iXSD + 1; else {
            isHasXsd = true;
            break;
        }
    }

    if (isHasXsd) {
        if (iXSD <= nxsd)
            isNumTure = true;
    } else {
        isNumTure = true;
    }

    return isNumTure;
}


//whether the length of str is too big.
function isLenValid(str, strLen) {
    if (str.length > strLen) {
        return false;
    } else {
        return true;
    }
}
//replace the space in parameter "str" with "%20" after trim "str".
function convertStr(str) {
    var t = "";
    var strTmp = trim(str);
    for (var i = 0; i < strTmp.length; i++) {
        if (strTmp.charAt(i) == " ")
            t += "%20"; else
            t += strTmp.charAt(i);
    }
    return t;
}


//获取字符串的真真长度
function strlength(str) {
    var iLen = 0;
    if (str.length > 0) {
        for (var i = 0; i < str.length; i++) {
            if (str.charAt(i) >= "\u0080")
                iLen += 2; else
                iLen += 1;
        }
    }
    return iLen;
}

function viewCalendar(obj) {
    showx = event.screenX;
    showy = event.screenY;
    newWINwidth = 210 + 4 + 18;
    //window.open("leader/CalendarDlg.htm");
    retval = window.showModalDialog("leader/CalendarDlg.htm", "", "dialogWidth:197px; dialogHeight:210px; dialogLeft:" + showx + "px; dialogTop:" + showy + "px; status:no; directories:yes;scrollbars:no;Resizable=no; ");
    if (retval != null) {
        obj.value = retval;
    }
    obj.focus();
}

function isValidStringObj(obj, objname, must) {
    var s = trim(obj.value);

    if (s == "") {
        if (must) {
            alert(objname + "必须填写！");
            obj.focus();
            return false;
        } else {
            return true;
        }
    }
    if (!isValidStr(s, getInValidStr())) {
        alert(objname + "不能包含字符" + getInValidStr() + "！");
        obj.focus();
        return false;
    }
    return true;
}

function isValidIntegerObj(obj, objname, must) {
    var s = trim(obj.value);

    if (s == "") {
        if (must) {
            alert(objname + "必须填写！");
            obj.focus();
            return false;
        } else {
            return true;
        }
    }
    if (!isInteger(s)) {
        alert(objname + "必须为整数！");
        obj.focus();
        return false;
    }
    return true;
}

function isValidNumberObj(obj, objname, must) {
    var s = trim(obj.value);

    if (s == "") {
        if (must) {
            alert(objname + "必须填写！");
            obj.focus();
            return false;
        } else {
            return true;
        }
    }
    if (!isNumber(s)) {
        alert(objname + "必须为数字！");
        obj.focus();
        return false;
    }
    return true;
}

function isValidDateObj(obj, objname, must) {
    var s = trim(obj.value);

    if (s == "") {
        if (must) {
            alert(objname + "必须填写！");
            obj.focus();
            return false;
        } else {
            return true;
        }
    }
    if (!isDate(s)) {
        alert(objname + "必须为日期格式yyyy-mm-dd！");
        obj.focus();
        return false;
    }
    return true;
}

function isValidStringLength(obj, objname, len) {
    var s = trim(obj.value);
    if (strlength(s) > len) {
        alert(objname + "超出长度限制 " + len + " ！");
        obj.focus();
        return false;
    }
    return true;
}

function isDate(s) {
    var ary = s.split("-");
    if (ary.length != 3) {
        return false;
    }
    if (!(isInteger(ary[0]) && isInteger(ary[1]) && isInteger(ary[2]))) {
        return false;
    }
    return true;
}
function StrToDate(str) {
    str = trim(str);
    var ary = str.split("-");
    if (ary.length != 3) {
        return null;
    }
    if (!(isInteger(ary[0]) && isInteger(ary[1]) && isInteger(ary[2]))) {
        return null;
    }
    return new Date(ary[0], (ary[1] - 1), ary[2]);
}

function CompStrDate(sd1, sd2) {
    sd1 = trim(sd1);
    sd2 = trim(sd2);
    var d1 = StrToDate(sd1);
    var d2 = StrToDate(sd2);
    if (d1 == null || d2 == null) {
        return true;
    }
    if (d1.getTime() - d2.getTime() >= 0) {
        return true;
    } else {
        return false;
    }
}

function CompDate(d1, d2) {
    if (d1 == null || d2 == null) {
        return true;
    }
    if (d1.getTime() - d2.getTime() >= 0) {
        return true;
    } else {
        return false;
    }
}


/**
 * 是否是合法的Email地址
 * @return boolean
 */
function isEmail(s) {
    var regu = "^(([0-9a-zA-Z]+)|([0-9a-zA-Z]+[_.0-9a-zA-Z-]*[0-9a-zA-Z]+))@([a-zA-Z0-9-]+[.])+([a-zA-Z]{2}|net|com|gov|mil|org|edu|int)$";
    var re = new RegExp(regu);

    if (s.search(re) != -1) {
        return true;
    } else {
        return false;
    }
}

function isInt(s) {
    //alert(s);
    if (s.match("^[0-9]+$")) {
        return true;
    } else {
        return false;
    }
}
function isFloat(s) {

    if (isInt(s) || s.match("^[0-9]+.[0-9]{0,2}$")) {
        return true;
    } else {
        return false;
    }
}
function dosubmit() {

    if (checkInput() == true) {
        document.frm.submit();
    }
}
function checkStrlen(obj, name, len) {
    var s = trim(obj.value);
    if (strlength(s) > len) {
        alert(name + "长度必须小于等于" + len);
        obj.focus();
        return false;
    }
    return true;
}

function body_keydown() {
    if (window.event.srcElement.tagName == "INPUT" || window.event.srcElement.tagName == "SELECT" || window.event.srcElement.tagName == "A") {
        if (event.keyCode == 13) {
            event.keyCode = 9;
        }
    }
}

function confirmDelete() {
    if (confirm("是否确定删除此文档？"))
        return confirm("删除的文档不可恢复。是否继续？");

    return false;
}

// 转换xml到json。Changes XML to JSON
function xmlToJson(xml) {
	
	// Create the return object
	var obj = {};

	if (xml.nodeType == 1) { // element
		// do attributes
		if (xml.attributes.length > 0) {
		obj["@attributes"] = {};
			for (var j = 0; j < xml.attributes.length; j++) {
				var attribute = xml.attributes.item(j);
				obj["@attributes"][attribute.nodeName] = attribute.nodeValue;
			}
		}
	} else if (xml.nodeType == 3) { // text
		obj = xml.nodeValue;
	}

	// do children
	if (xml.hasChildNodes()) {
		for(var i = 0; i < xml.childNodes.length; i++) {
			var item = xml.childNodes.item(i);
			var nodeName = item.nodeName;
			if (typeof(obj[nodeName]) == "undefined") {
				obj[nodeName] = xmlToJson(item);
			} else {
				if (typeof(obj[nodeName].length) == "undefined") {
					var old = obj[nodeName];
					obj[nodeName] = [];
					obj[nodeName].push(old);
				}
				obj[nodeName].push(xmlToJson(item));
			}
		}
	}
	return obj;
};

// Assuming xmlDoc is the XML DOM Document
//var jsonText = JSON.stringify(xmlToJson(xmlDoc));
