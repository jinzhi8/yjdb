function setcheck(obj) {
    if (obj.checked) {
        if (!confirm("�Ƿ񽫸����̽ڵ���Ϊ��ʼ�ڵ㣿")) {
            obj.checked = false;
        }
    }
}