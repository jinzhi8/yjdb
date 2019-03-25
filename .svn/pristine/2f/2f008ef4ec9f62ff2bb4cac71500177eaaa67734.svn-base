function checkField() {
    var form = document.forms[0];
    var flag = false;
    for (var i = 0; i < form.elements.length; i++) {
        if (form.elements[i].value != "" && form.elements[i].name != "") {
            if (form.elements[i].name != "statflag" && form.elements[i].name != "sortname") {
                flag = true;
            }
        }
    }
    if (!flag) {
        //alert("查询项不能全部为空！至少要选择其中一项进行查询！");
        //return false;
        return true;
    } else {
        return true;
    }
}

function disablebutton(flag) {
    var buttons = document.forms[0].elements;
    for (i = 0; i < buttons.length; i++) {
        var curobj = buttons[i];
        if (curobj.type == 'button' || curobj.type == 'submit') {
            curobj.disabled = flag;
        }
    }
}