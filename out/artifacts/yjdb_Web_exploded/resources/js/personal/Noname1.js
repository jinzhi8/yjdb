function getUrl() {
    var url = window.location;
    return url;
}
function setAction(actionName) {
    //"save","submit","senddoc","getissuecode"
    document.all.action.value = actionName;
}
function checkFields() {
    var messenger = document.all("messenger");
    if (messenger == null || messenger.value == "") {
        alert("批示内容不能为空");
        messenger.focus();
        return false;
    }
    return true;
}
function confirmFav() {
    if (confirm("确认要收藏么？")) {
        var urldo = "favouritePersonalAction.do?method=creat";
        window.location = urldo;
    }
}
function confirmAdd() {
    if (confirm("确认要添加么")) {
        if (method = creat) {
            var urldo = "personalAction.do?method=creat";
            window.location = urldo
        } else {
            var urldo = "personalAction.do?&method=save"
            window.location = urldo2004 - 7 - 16
        }
    }

}
function confirmDel() {
    if (confirm("确认要删除么")) {
        var urldo = "personalAction.do?" + document.all.personalForm.value
        ";
        url + = "&method=del&"
    }
}
function closeForm1() {
    alert("-------");
    window.close();
}