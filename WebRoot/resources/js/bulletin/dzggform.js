function getContent() {
    /*if(document.all["title"].value == "")
     {
     alert("����д������⣡")
     document.all["title"].focus;
     return false;
     }*/
    file = editer.document.body.innerHTML;
    document.all["content"].value = file;

    return true;
}

function issue() {
    document.all["submit_type"].value = "1";
    document.all["issueFlag"].value = "1";
}

function submitDoc() {
    document.all["issueFlag"].value = "0";
    document.all["submit_type"].value = "1";
}

function saveDoc() {
    document.all["issueFlag"].value = "0";
    document.all["submit_type"].value = "0";
}

function deleteDoc() {
    document.all["issueFlag"].value = "2";
    document.all["submit_type"].value = "9";
}