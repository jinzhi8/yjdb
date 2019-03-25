function getContent() {
    if (document.all["{actionForm.title}"].value == "") {
        alert("请填写公告标题！")
        document.all["{actionForm}"].focus;
        return false;
    }
    file = editer.document.body.innerHTML;
    document.all["{actionForm.content}"].value = file;
    return true;
}

function issue() {
    document.all["{actionForm.issueFlag}"].value = "1";
}