var cFrame = window.parent.cframe;

function showConfig(unitid, configPath) {
    var pos = configPath.indexOf("&");
    var path = "";
    if (pos > -1) {
        path = configPath + "&unitid=" + unitid;
    } else {
        path = configPath + "?unitid=" + unitid;
    }

    cFrame.location = path;
}

function openRegindex() {
    cFrame.location = "regindex.jsp";
}