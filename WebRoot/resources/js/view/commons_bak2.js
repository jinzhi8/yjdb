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
    var searchkeyForm = document.forms['searchkeyform'];
    var obj = searchkeyForm.elements;
    var searchStr = "";
    var getValue;
    for (var i = 0; i < obj.length; i++) {
        var objsort = obj[i].sort;
        if (objsort != null && objsort != "") {
            if (objsort == "text") {
                getValue = obj[i].value;
                getValue = Trim(getValue);
                getValue = replaceString(getValue, "    ", " ");
                getValue = replaceString(getValue, "   ", " ");
                getValue = replaceString(getValue, "  ", " ");
                getValue = replaceString(getValue, " ", "$$");
                getValue = replaceString(getValue, "$$", " AND ");
                searchStr = searchStr + getValue + " ";
                //searchStr = searchStr + obj[i].name + ":" + obj[i].value + " ";
            }
            /*
             else if (objsort == "date")
             {
             if (obj)
             {
             }
             }
             */
        }
    }
    var searchdoForm = document.forms['searchForm'];
    searchdoForm.queryString.value = searchStr;
    ///was/WebSphere/searchindex/oadata/
    searchdoForm.baseId.value = "d:/search/" + moduleid;
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
    window.open(Str, '_blank', 'scrollbars=yes,resizable=yes,width=790,height=600');
}