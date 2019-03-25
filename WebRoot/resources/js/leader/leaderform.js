function checkleader() {
    var leadername = document.all.username;
    if (leadername == null || leadername.value == "") {
        alert("请选择领导姓名");
        return false;
    }

    return true;
}