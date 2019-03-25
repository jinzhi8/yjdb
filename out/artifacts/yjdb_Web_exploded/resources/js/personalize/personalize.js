function copyModule(o_col, d_col) {
    var ops = document.fm[o_col].options;
    var oplen = ops.length;
    var isok = 0;

    for (o_sl = oplen - 1; o_sl >= 0; o_sl--) {
        //o_sl = document.fm[o_col].selectedIndex;
        d_sl = document.fm[d_col].length;
        if (o_sl != -1 && document.fm[o_col].options[o_sl].value > "" && ops[o_sl].selected) {
            oText = document.fm[o_col].options[o_sl].text;
            oValue = document.fm[o_col].options[o_sl].value;
            //document.fm[o_col].options[o_sl] = null;
            document.fm[d_col].options[d_sl] = new Option(oText, oValue, false, true);
            isok = 1;
        }
    }
    if (isok == 0) {
        alert("请选择一个要显示图片的栏目。");
    }
}

function moveModule(o_col, d_col) {
    var ops = document.fm[o_col].options;
    var oplen = ops.length;
    var isok = 0;

    for (o_sl = oplen - 1; o_sl >= 0; o_sl--) {
        //o_sl = document.fm[o_col].selectedIndex;
        d_sl = document.fm[d_col].length;
        if (o_sl != -1 && document.fm[o_col].options[o_sl].value > "" && ops[o_sl].selected) {
            oText = document.fm[o_col].options[o_sl].text;
            oValue = document.fm[o_col].options[o_sl].value;
            document.fm[o_col].options[o_sl] = null;
            document.fm[d_col].options[d_sl] = new Option(oText, oValue, false, true);
            isok = 1;
        }
    }
    if (isok == 0) {
        alert("请选择一个栏目再进行栏目转移。");
    }
}

function orderModule(down, col) {
    sl = document.fm[col].selectedIndex;
    if (sl != -1 && document.fm[col].options[sl].value > "") {
        oText = document.fm[col].options[sl].text;
        oValue = document.fm[col].options[sl].value;
        if (document.fm[col].options[sl].value > "" && sl > 0 && down == 0) {
            document.fm[col].options[sl].text = document.fm[col].options[sl - 1].text;
            document.fm[col].options[sl].value = document.fm[col].options[sl - 1].value;
            document.fm[col].options[sl - 1].text = oText;
            document.fm[col].options[sl - 1].value = oValue;
            document.fm[col].selectedIndex--;
        } else if (sl < document.fm[col].length - 1 && document.fm[col].options[sl + 1].value > "" && down == 1) {
            document.fm[col].options[sl].text = document.fm[col].options[sl + 1].text;
            document.fm[col].options[sl].value = document.fm[col].options[sl + 1].value;
            document.fm[col].options[sl + 1].text = oText;
            document.fm[col].options[sl + 1].value = oValue;
            document.fm[col].selectedIndex++;
        }
    } else {
        alert("请选择一个栏目再进行栏目调序");
    }
}
function delMod(col) {
    req = "";
    sl = document.fm[col].selectedIndex;
    var ops = document.fm[col].options;
    var oplen = ops.length;
    var isok = 0;
    //先检查是否有选择栏目
    for (sl = oplen - 1; sl >= 0; sl--) {
        if (ops[sl].value > "" && ops[sl].selected) {
            isok = 1;
        }
    }
    if (isok == 0) {
        alert("请选择至少一个栏目");
    } else if (confirm("不显示选中的栏目吗？")) {
        for (sl = oplen - 1; sl >= 0; sl--) {
            if (sl != -1 && document.fm[col].options[sl].value > "" && ops[sl].selected) {
                //if (confirm("这将删除选中的栏目：["+document.fm[col].options[sl].text+"]"))
                //{
                if (document.fm[col].options[sl].value != ".none") {
                    var v;
                    //删除，需要把禁止取消掉
                    if (document.fm[col].length == 1) {
                        v = document.fm[col].options[0].value;
                        document.fm[col].options[0].text = "";
                        document.fm[col].options[0].value = ".none";
                    } else {
                        v = document.fm[col].options[sl].value;
                        document.fm[col].options[sl] = null;
                    }
                    enablecheck(v, col.substring(0, 4));
                } else {
                    //alert("请选择至少一个栏目");
                }
                //}
            }
        }
    }
}
//删除，需要把禁止取消掉
function enablecheck(colname, align) {
    if (align = "left")
        eval("document.all.lst" + colname + ".disabled=false;"); else
        eval("document.all.rst" + colname + ".checked=false;");
}
function postsave() {
    //先确定再保存
    addcol();
    doSub();
    document.all.action.value = "save";
    document.fm.submit();
}
function setdefault() {
    //设为缺省
    document.all.action.value = "setdefault";
    document.fm.submit();
}
function doSub() {
    document.all.leftcol_lst.value = makeList(document.all.leftcol);
    document.all.rightcol_lst.value = makeList(document.all.rightcol);
    return true;
}

function makeList(col) {
    val = "";
    for (j = 0; j < col.length; j++) {
        if (val > "") { val += ","; }
        if (col.options[j].value > "" && col.options[j].value != ".none") val += col.options[j].value;
    }
    return val;
}
function addcol() {
    //把选中的栏目加入上面布局
    var allobj = document.all;

    var colobj;
    if (allobj.selectcol[0].checked) {
        colobj = document.fm["rightcol"];
    } else {
        alert("请选择左中右布局放入！");
    }
    var objlen = allobj.length;
    for (i = objlen - 1; i >= 0; i--) {
        var obj = allobj[i];
        //所有名称前缀是st的checkbox
        if (obj.type == "checkbox")
            if (obj.checked && !obj.disabled)
                if ((obj.name.substring(0, 3) == "rst")) {
                    //debug
                    //alert("i:"+i+" name:"+obj.name.substring(2));
                    var len = colobj.length;
                    colobj.options[len] = new Option(obj.value, obj.name.substring(3), false, true);
                    obj.disabled = true;
                }
    }
}
function addcol2() {
    //把选中的栏目加入上面布局
    var allobj = document.all;

    var colobj;
    if (allobj.selectcol2[0].checked) {
        colobj = document.fm["leftcol"];
    } else {
        alert("请选择左中右布局放入！");
    }
    var objlen = allobj.length;
    for (i = objlen - 1; i >= 0; i--) {
        var obj = allobj[i];
        //所有名称前缀是st的checkbox
        if (obj.type == "checkbox")
            if (obj.checked && !obj.disabled) //选中并且没有禁止
                if ((obj.name.substring(0, 3) == "lst")) {
                    //debug
                    //alert("i:"+i+" name:"+obj.name.substring(2));
                    var len = colobj.length;
                    colobj.options[len] = new Option(obj.value, obj.name.substring(3), false, true);
                    obj.disabled = true;
                }
    }
}
//将已经存在的栏目disable掉
function disablecol() {
    var allobj = document.all;
    var i,j;
    for (j = 0; j < allobj.length; j++) {
        var obj = allobj[j];
        if (obj.type == "checkbox")
            if (obj.name.substring(0, 3) == "lst" || obj.name.substring(0, 3) == "rst") {
                var colobj;
                //左栏
                colobj = document.fm["leftcol"];
                for (i = 0; i < colobj.length; i++) {
                    //栏目号相同
                    if (obj.name.substring(3) == colobj.options[i].value) {
                        obj.checked = true;
                        obj.disabled = true;
                    }
                }
                //右栏
                colobj = document.fm["rightcol"];
                for (i = 0; i < colobj.length; i++) {
                    //栏目号相同
                    if (obj.name.substring(3) == colobj.options[i].value) {
                        obj.checked = true;
                        obj.disabled = true;
                    }
                }
            }
    }
}