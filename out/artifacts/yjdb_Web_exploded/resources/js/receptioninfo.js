function setSaveFlag(flagval) {
    // 0、保存  1、提交  2、发布  3、删除  4、取消删除  5、永久删除  6、取回
    document.all['{actionForm.saveFlag}'].value = flagval;
}
function resetSaveFlag(flagval) {
    document.all['{actionForm.saveFlag}'].value = '';
}

function selItem(selobj, textobj) {
    textobj.value = selobj.options[selobj.selectedIndex].text;
}

function greturn() {
}
function checkSaveFlag() {
    if (document.all['{actionForm.saveFlag}'].value == '') {
        alert('hhhh');
        return false;
    } else {
        return true;
    }
}

function checkFields(status) {
    var main_send = document.all["{actionForm.main_send}"];
    var file_sort = document.all["{actionForm.file_sort}"];
    var rangeIDList = document.all["{actionForm.rangeIDList}"];
    var nextUserID = document.all["{actionForm.nextUserID}"];
    var issue_dep = document.all["{actionForm.issue_dep}"];

    if (status == "1") {
        if (nextUserID == null || nextUserID.value == "") {
            alert("下一步操作人员不能为空");
            return false;
        }

    } else if (status == "2") {

    } else if (status == "3") {
    } else if (status == "") {
    } else {
    }
}