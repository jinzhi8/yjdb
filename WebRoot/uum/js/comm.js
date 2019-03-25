function MouseOutChange1(obj) {
    obj.className = "even";
}

function MouseOutChange2(obj) {
    obj.className = "odd";
}
function MouseOverChange(obj) {
    obj.className = "table_display_3";
}
function CheckAll(form) {
    for (var i = 0; i < form.elements.length; i++) {
        var e = form.elements[i];
        if (e.name != 'chkall')
            e.checked = form.chkall.checked;
    }
}