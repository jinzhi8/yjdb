function setcheck(obj) {
    if (obj.checked) {
        if (!confirm("是否将该流程节点置为初始节点？")) {
            obj.checked = false;
        }
    }
}