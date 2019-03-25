function greturn() {}
function checkit() {
    var obj = document.all.tx;
    if (obj != null) {
        if (obj.checked == true) document.all.txcontent.style.display = "inline";
    }
    var obj = document.all.txday
    if (obj != null) {
        if (obj.checked == true) document.all.txdaycontent.style.display = "inline";
    }

}

function checksubmit() {
    if (document.all.todo_subject.value == "") {
        alert("请输入工作主题！");
        return false;
    }

    var str_bghour = document.all.bghour.options[document.all.bghour.selectedIndex].text;
    var str_bgmin = document.all.bgmin.options[document.all.bgmin.selectedIndex].text;
    var str_edhour = document.all.edhour.options[document.all.edhour.selectedIndex].text;
    var str_edmin = document.all.edmin.options[document.all.edmin.selectedIndex].text;

    if (document.all.bghour.selectedIndex > document.all.edhour.selectedIndex) {
        alert("结束时间小于开始时间！")
        return false;
    }

    if (document.all.bghour.selectedIndex == document.all.edhour.selectedIndex) {
        if (document.all.bgmin.selectedIndex > document.all.edmin.selectedIndex) {
            alert("结束时间小于开始时间！");
            return false;
        }
    }


}
function showHideNoticeOption(obj) {

    if (obj.value == "0") {
        document.all.txcontent.style.display = 'inline';
        document.all.txdaycontent.style.display = 'none';
    } else {
        document.all.txcontent.style.display = 'none';
        document.all.txdaycontent.style.display = 'inline';
    }
}

function selectedOption(obj, value) {

    for (var i = 1; i < obj.options.length; i++) {
        if (obj.options[i].value == value) {
            obj.options[i].selected = "true";
        }
    }
}