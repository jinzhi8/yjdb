function setSaveFlag(flagval) {
    // 0������  1���ύ  2������  3��ɾ��  4��ȡ��ɾ��  5������ɾ��  6��ȡ��
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
            alert("��һ��������Ա����Ϊ��");
            return false;
        }

    } else if (status == "2") {

    } else if (status == "3") {
    } else if (status == "") {
    } else {
    }
}