function getContent() {
    if (document.all["{actionForm.title}"].value == "") {
        alert("����д������⣡")
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