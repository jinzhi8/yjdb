function checkleader() {
    var leadername = document.all.username;
    if (leadername == null || leadername.value == "") {
        alert("��ѡ���쵼����");
        return false;
    }

    return true;
}