var itemList = new Array();
var errorList = new Array();

function itemListReg(itemcontent) {
    itemList[itemList.length] = itemcontent;
    return (itemList.length - 1);
}

function errorListReg(errorcontent) {
    errorList[errorList.length] = errorcontent;
    return (errorList.length - 1);
}

function itemContent(item_id, item_name, status, nullable, data_type, data_pattern) {
    this.item_id = item_id;
    this.item_name = item_name;
    this.status = status;
    this.nullable = nullable;
    this.data_type = data_type;
    this.data_pattern = data_pattern;
    this.item_order = itemListReg(this);
}

function errorContent(errorInfo, itemobj) {
    this.errorInfo = errorInfo;
    this.itemobj = itemobj;
    this.error_order = errorListReg(this);
}

function initContext() {
    for (var i = 0; i < itemList.length; i++) {
        var itemcontent = itemList[i];
        setItemStatus(itemcontent.item_id, itemcontent.status);
    }
}

function validateContext() {
    errorList = new Array();
    for (i = 0; i < itemList.length; i++) {
        validateItem(itemList[i]);
    }

    if (showError()) {
        disablebutton();
        return true;
    } else {
        return false;
    }
    return showError();
}

function showError() {
    var errorInfo = "";
    var itemobj = null;

    for (i = 0; i < errorList.length; i++) {
        var errorcontent = errorList[i];
        if (errorInfo == null || errorInfo == "") {
            errorInfo = errorcontent.errorInfo;
        } else {
            errorInfo += "\n " + errorcontent.errorInfo;
        }
        if (itemobj == null)
            itemobj = errorcontent.itemobj;
    }

    if (errorInfo != "") {
        if (itemobj != null) {
            itemobj.focus();
        }
        alert(errorInfo);
        return false;
    }

    return true;
}

function setItemStatus(item_id, status) {
    var obj = document.all[item_id];
    if (obj != null) {
        if (obj.tagName == null) {
            if (obj.length != null) {
                for (var i = 0; i < obj.length; i++) {
                    dowithItemStatus(obj[i], status);
                }
            }
        } else {
            dowithItemStatus(obj, status);
        }
    } else if (document.getElementById(item_id) != null) {
        if (obj.tagName == null) {
            if (obj.length != null) {
                for (var i = 0; i < obj.length; i++) {
                    dowithItemStatus(obj[i], status);
                }
            }
        } else {
            dowithItemStatus(obj, status);
        }
    }
}
function letsgo(o) {
    var l = o.childNodes.length;
    if (l == 0) return;
    for (var i = 0; i < l; i++) {
        if (o.childNodes[i].nodeType == 1) {
            o.childNodes[i].disabled = true;
            letsgo(o.childNodes[i]);
        }
    }
}
function dowithItemStatus(obj, status) {
    if (obj) {
        if (status == "0") {
            obj.style.display = "none";
        } else if (status == "1") {
			obj.title = "";
            obj.style.display = "";
			obj.readOnly = false;
        } else if (status == "2") {
            if (obj.tagName.toLowerCase() == 'input' || obj.tagName.toLowerCase() == 'textarea') {
                obj.readOnly = true;
                //obj.title = "该项不可修改!";
                //obj.onclick = function() {return false;};
                //obj.ondblclick = function() {return false;};
                //obj.onchange = function() {return false;};
                //obj.onpropertychange = function() {return false;};
                //obj.style.cssText += ";background-color:#FFFFFF;border:0px;overflow-y:visible;";
            } else if (obj.tagName.toLowerCase() == 'select') {
                obj.readOnly = true;
                //obj.title = "该项不可修改!";
                //obj.onclick = function() {return false;};
                //obj.ondblclick = function() {return false;};
                //obj.onchange = function() {return false;};
                //obj.onpropertychange = function() {return false;};
                //obj.onfocus = function() {this.blur();};
                //obj.onbeforeactivate = function() {return false;};
                //obj.onmouseover = function() {this.setCapture();};
                //obj.onmouseout = function() {this.releaseCapture();};
                obj.style.cssText += ";background-color:#FFFFFF;border:0px;overflow-y:visible;";
            }
        } else if (status == "3") {
            obj.disabled = true;
        } else if (status == "4") {
            obj.disabled = true;
            obj.style.display = "none";
        } else {
            obj.style.display = "inline";
            obj.readonly = false;
            obj.disabled = false;
        }

        var ol = obj.childNodes.length;
        if (ol > 0 && status == "2") {
            for (var i = 0; i < ol; i++) {
                if (obj.childNodes[i].nodeType == 1) {
                    if (status == "0") {
                        obj.childNodes[i].style.display = "none";
                    } else if (status == "1") {
						obj.title = "";
                        obj.childNodes[i].style.display = "block";
						obj.readOnly = false;
                    } else if (status == "2") {
                        if (obj.childNodes[i].tagName.toLowerCase() == 'input' || obj.childNodes[i].tagName.toLowerCase() == 'select' || obj.childNodes[i].tagName.toLowerCase() == 'textarea') {
                            obj.childNodes[i].readOnly = true;
                            //obj.childNodes[i].title = "该项不可修改!";
                            //obj.childNodes[i].onclick = function() {return false;};
                            //obj.childNodes[i].ondblclick = function() {return false;};
                            //obj.childNodes[i].onchange = function() {return false;};
                            //obj.childNodes[i].onpropertychange = function() {return false;};
                            obj.childNodes[i].style.cssText += ";background-color:#FFFFFF;border:0px;overflow-y:visible;";
                        } else if (obj.childNodes[i].tagName.toLowerCase() == 'select') {
                            obj.childNodes[i].readOnly = true;
                            //obj.childNodes[i].title = "该项不可修改!";
                            //obj.childNodes[i].onclick = function() {return false;};
                            //obj.childNodes[i].ondblclick = function() {return false;};
                            //obj.childNodes[i].onchange = function() {return false;};
                            //obj.childNodes[i].onpropertychange = function() {return false;};
                            //obj.childNodes[i].onfocus = function() {this.blur();};
                            //obj.childNodes[i].onbeforeactivate = function() {return false;};
                            //obj.childNodes[i].onmouseover = function() {this.setCapture();};
                            //obj.childNodes[i].onmouseout = function() {this.releaseCapture();};
                            obj.childNodes[i].style.cssText += ";background-color:#FFFFFF;border:0px;overflow-y:visible;";
                        }
                    } else if (status == "3") {
                        obj.childNodes[i].disabled = true;
                    } else if (status == "4") {
                        obj.childNodes[i].disabled = true;
                        obj.childNodes[i].style.display = "none";
                    } else {
                        obj.childNodes[i].style.display = "inline";
                        obj.childNodes[i].readonly = false;
                        obj.childNodes[i].disabled = false;
                    }
                    dowithItemStatus(obj.childNodes[i], status);
                }
            }
        }
    }
}

function dowithItemStatus1(obj, status) {
    if (obj != null) {
        if (status == "0") {
            obj.style.display = "none";
        } else if (status == "2") {
            obj.readOnly = true;
        } else if (status == "3") {
            obj.disabled = true;
        } else if (status == "4") {
            obj.disabled = true;
            obj.style.display = "none";
        } else {
            obj.style.display = "inline";
            obj.readonly = false;
            obj.disabled = false;
        }
    }
}

function validateItem(valItem) {
    var nullable = valItem.nullable;
    var data_pattern = valItem.data_pattern;
    var item_id = valItem.item_id;

    var itemobj = document.all[item_id];
    if (nullable == "1") {
        if (itemobj != null) {
            if (itemobj.value == "") {
				var errorInfo = valItem.item_name+"不能为空！";
				new errorContent(errorInfo, itemobj);
            }
        }
    }
    if (data_pattern != "") {
    }
}
function disablebutton() {
    var buttons = document.forms[0].elements;
    for (i = 0; i < buttons.length; i++) {
        var curobj = buttons[i];
        if (curobj.type == 'button' || curobj.type == 'submit') {
            curobj.disabled = true;
        }
    }
}	