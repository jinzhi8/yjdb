function advSearch() {
    document.all.fastSearch.style.display = "none";
    document.all.advSearch.style.display = "inline";
    document.all.view.style.display = "none";
}

function showClen(ctrlobj) {
    showx = event.screenX - event.offsetX + 60; // + deltaX;
    showy = event.screenY - event.offsetY + 12; // + deltaY;
    newWINwidth = 210 + 4 + 18;
    //window.open("../resources/calendar/CalendarDlg.htm");
    retval = window.showModalDialog("../resources/calendar/CalendarDlg.htm", "", "dialogWidth:197px; dialogHeight:210px; dialogLeft:" + showx + "px; dialogTop:" + showy + "px; status:no; directories:yes;scrollbars:no;Resizable=no; ");
    if (retval != null) {
        ctrlobj.value = retval;
    } else {
        //alert("canceled");
    }
}

function advSearchCancel() {
    document.all.fastSearch.style.display = "inline";
    document.all.advSearch.style.display = "none";
    document.all.view.style.display = "inline";
}
function doSearch() {
    var moduleid = document.all.moduleid.value;
    if (moduleid == "getdocread") moduleid = "getdoc"; //收文阅件
    if (moduleid == "meeting2") moduleid = "meeting";  //文件
    if (moduleid == "file_bj") moduleid = "meeting"; //便笺
    if (moduleid == "meetingnotify") moduleid = "meeting"; //会议通知
    if (moduleid == "filebase") moduleid = "filebase"; //文件库
    if (moduleid == "sharedoc") moduleid = "sharebase"; //综合材料库
    if (moduleid == "sharebase") moduleid = "sharebase"; //综合材料库

    var searchkeyForm = document.forms['searchkeyform'];
    var formElements = searchkeyForm.elements;

    var searchDepFlag;
    if (searchkeyForm.searchDepFlag != null)
        searchDepFlag = searchkeyForm.searchDepFlag.value; else
        searchDepFlag = "";
    var searchStr = "";
    var queryfields = "";
    var queryfieldNames = "";

    for (var i = 0; i < formElements.length; i++) {
        var obj = formElements[i];
        var objsort = obj.sort;
        var searchStrTemp = "";
        if (objsort != null && objsort != "") {
            if (objsort == "text") {
                var searchObjnameStr;
                if (obj.field != null) {
                    searchObjnameStr = obj.field + ":";
                    if (queryfields != "") {
                        queryfields += ",";
                        queryfieldNames += ",";
                    }
                    queryfields += obj.field;
                    queryfieldNames += obj.fieldName;

                } else {
                    searchObjnameStr = "";
                }

                keys = dosplit(dotrim(doreplaceSpace(doreplaceKeywords(obj.value))), " ");

                for (var j = 0; j < keys.length; j++) {
                    if (keys[j] != "") {
                        if (searchStrTemp != "")
                            searchStrTemp += " AND ";
                        searchStrTemp += searchObjnameStr + keys[j];
                    }
                }
            }
        }

        if (searchStrTemp != "") {
            if (searchStr != "")
                searchStr += " AND ";
            searchStr += searchStrTemp;
        }
    }
    if (searchStr == "") {
        alert("请输入查询条件！");
        return false;
    } else {
        if (searchDepFlag != "") searchStr += " AND depflag:" + searchDepFlag;
    }
    var searchdoForm = document.forms['searchForm'];
    searchdoForm.queryString.value = searchStr;
    searchdoForm.depflag.value = searchDepFlag;

    //全文检索路径配置
    //searchdoForm.baseId.value = "/was/WebSphere/searchindex/oadata/"+moduleid;
    searchdoForm.baseId.value = "C:/workspace/webapps/searchoa/search/" + moduleid;

    searchdoForm.queryfields.value = queryfields;
    searchdoForm.queryfieldNames.value = queryfieldNames;

    searchdoForm.submit();
}

function dealKeyDown(event) {
    var keyCode = event.keyCode;
    if (keyCode == 13) {
        alert("return");
    }
}
function replaceString(searchStr, source, replace) {
    var newString;
    i = searchStr.indexOf(source)
    while (i >= 0) {
        newString = searchStr.replace(source, replace);
        searchStr = newString;
        i = searchStr.indexOf(source);
    }
    return searchStr;
}
function LTrim(str) {
    var whitespace = new String(" \t\n\r");
    var s = new String(str);
    if (whitespace.indexOf(s.charAt(0)) != -1) {
        var j = 0, i = s.length;
        while (j < i && whitespace.indexOf(s.charAt(j)) != -1) {
            j++;
        }
        s = s.substring(j, i);
    }
    return s;
}
function RTrim(str) {
    var whitespace = new String(" \t\n\r");
    var s = new String(str);
    if (whitespace.indexOf(s.charAt(s.length - 1)) != -1) {
        var i = s.length - 1;
        while (i >= 0 && whitespace.indexOf(s.charAt(i)) != -1) {
            i--;
        }
        s = s.substring(0, i + 1);
    }
    return s;
}
function Trim(str) {
    return RTrim(LTrim(str));
}

function windowInfo(Str) {
    window.open(Str, '_blank', 'scrollbars=yes,width=790,height=600');
}

//

function dotrim(str) {
    return str.replace(/(^\s*)|(\s*$)/g, "");
}

function doreplaceSpace(str) {
    return str.replace(/(\s+)/g, " ");
}

function doreplaceKeywords(str) {
    return str.replace(/\b(AND|OR|:)\b/gi, " ");
}

function dosplit(str, seperator) {
    return str.split(seperator);
}