function showCalendar(ctrlobj, resourcepath) {
    showx = event.screenX - event.offsetX + 60; // + deltaX;
    showy = event.screenY - event.offsetY + 12; // + deltaY;
    newWINwidth = 210 + 4 + 18;
    //window.open("calendar/CalendarDlg.htm");
    retval = window.showModalDialog("./resources/calendar/CalendarDlg.htm", "", "dialogWidth:197px; dialogHeight:210px; dialogLeft:" + showx + "px; dialogTop:" + showy + "px; status:no; directories:yes;scrollbars:no;Resizable=no; ");
    if (retval != null) {
        ctrlobj.value = retval;
    } else {
        //alert("canceled");
    }
}


function openCalendar(ctrlobj) {
    showx = event.screenX - event.offsetX + 60; // + deltaX;
    showy = event.screenY - event.offsetY + 12; // + deltaY;
    newWINwidth = 210 + 4 + 18;

    retval = window.showModalDialog("resources/calendar/CalendarDlg.htm", "", "dialogWidth:197px; dialogHeight:210px; dialogLeft:" + showx + "px; dialogTop:" + showy + "px; status:no; directories:yes;scrollbars:no;Resizable=no; ");
    if (retval != null) {
        ctrlobj.value = retval;
    } else {
    }
}

function openCalendar2(ctrlobj) {
    showx = event.screenX - event.offsetX + 60; // + deltaX;
    showy = event.screenY - event.offsetY + 12; // + deltaY;
    newWINwidth = 210 + 4 + 18;

    retval = window.showModalDialog("resources/calendar/DatetimeDlg.htm", "", "dialogWidth:197px; dialogHeight:230px; dialogLeft:" + showx + "px; dialogTop:" + showy + "px; status:no; directories:yes;scrollbars:no;Resizable=no; ");
    if (retval != null) {
        ctrlobj.value = retval;
    } else {
    }
}

function openCalendar1(ctrlobj) {
    showx = event.screenX - event.offsetX + 60; // + deltaX;
    showy = event.screenY - event.offsetY + 12; // + deltaY;
    newWINwidth = 210 + 4 + 18;

    retval = window.showModalDialog("../resources/calendar/CalendarDlg.htm", "", "dialogWidth:197px; dialogHeight:210px; dialogLeft:" + showx + "px; dialogTop:" + showy + "px; status:no; directories:yes;scrollbars:no;Resizable=no; ");
    if (retval != null) {
        ctrlobj.value = retval;
    } else {
    }
}

function opencurCalendar(ctrlobj) {
    showx = event.screenX - event.offsetX + 60; // + deltaX;
    showy = event.screenY - event.offsetY + 12; // + deltaY;
    newWINwidth = 210 + 4 + 18;

    retval = window.showModalDialog("../resources/calendar/CalendarDlg.htm", "", "dialogWidth:197px; dialogHeight:210px; dialogLeft:" + showx + "px; dialogTop:" + showy + "px; status:no; directories:yes;scrollbars:no;Resizable=no; ");
    if (retval != null) {
        ctrlobj.value = retval;
    } else {
    }
}