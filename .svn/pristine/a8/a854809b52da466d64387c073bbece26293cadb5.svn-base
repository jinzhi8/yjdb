function getUrl() {
    var url = window.location;
    return url;
}
function messId(messId) {
    document.all["messId"].value = messId;
}
function setMethod(Method) {
    //"save","submit","senddoc","getissuecode"
    document.personalForm["method"].value = Method;
}
function checkFields() {
    var messenger = document.all["messenger"].value;
    if (messenger == null || messenger == "") {
        alert("批示内容不能为空");
        messenger.focus();
        return false;
    }
    return true;
}
function confirmFav() {
    //if (confirm("确认要收藏么？"))
    //{
    document.personalForm.method.value = "creat";
    document.personalForm.submit();
    //}
}
function confirmAdd() {
    if (checkFields()) {
        //if (confirm("确认要添加么"))
        //{
        if (document.personalForm["method"].value == "create") {
            document.personalForm.submit();
        } else {
            document.personalForm.submit();
        }
        //}
    }
}
function confirmDel() {
    if (confirm("确认要删除么")) {
        document.personalForm.method.value = "del";
        document.personalForm.submit();
    }
}

