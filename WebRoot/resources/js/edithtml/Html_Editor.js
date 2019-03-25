var tbEventSrcElement;
var bInit = false;
var tbToolbars = new Array();

function btnOver() {
    if (event.srcElement.tagName != "IMG") return false;
    var image = event.srcElement;
    var element = image.parentElement;

    if (image.className == "ICO") {
        element.className = "BTN_OVERUP";
    } else if (image.className == "ICO_DOWN") {
        element.className = "BTN_OVERDOWN";
    }

    event.cancelBubble = true;
}

function btnOut() {
    if (event.srcElement.tagName != "IMG") {
        event.cancelBubble = true;
        return false;
    }

    var image = event.srcElement;
    var element = image.parentElement;

    tbRaisedElement = null;

    element.className = "BTN";
    image.classNmae = "ICO";

    event.cancelBubble = true;
}

function btnDown() {
    if (event.srcElement.tagName != "IMG") {
        event.cancelBubble = true;
        event.returnValue = false;
        return false;
    }

    var image = event.srcElement;
    var element = image.parentElement;

    element.className = "BTN_OVERDOWN";
    image.className = "ICO_DOWN";

    event.cancelBubble = true;
    event.returnValue = false;
    return false;
}

function btnUp() {
    var element, image, userOnClick, radioButtons, i;

    if (event.srcElement.tagName == "IMG") {
        image = event.srcElement;
        element = image.parentElement;
    } else {
        element = event.srcElement;
        image = element.children.tags("IMG")[0];
    }

    if ((image.className != "ICO") && (image.className != "ICO_DOWN") && (image.className != "ICO_DOWNPRESS")) return;

    tbEventSrcElement = element;

    if (element.TBUSERONCLICK) {
        eval(element.TBUSERONCLICK + "anonymous()");
    }

    element.className = "BTN_OVERUP";

    image.className = "ICO";

    event.cancelBubble = true;
    return false;
}

function TBCancelEvent() {
    event.returnValue = false;
    event.cancelBubble = true;
}

var tbContentElementObject = null;
var tbContentElementTop = 0;
var tbContentElementBottom = 0;
var tbLastHeight = 0;
var tbLastWidth = 0;

function InitBtn(element) {
    element.onmouseover = btnOver;
    element.onmouseout = btnOut;
    element.onmousedown = btnDown;
    element.onmouseup = btnUp;
    element.ondragstart = TBCancelEvent;
    element.onselectstart = TBCancelEvent;
    element.onselect = TBCancelEvent;
    element.TBUSERONCLICK = element.onclick; // Save away the original onclick event
    element.onclick = TBCancelEvent;

    element.TBINITIALIZED = true;
}

function PopTB(tb) {
    var i, elements, s;

    elements = tb.children;
    for (i = 0; i < elements.length; i++) {
        if (elements[i].tagName == "SCRIPT" || elements[i].tagName == "!") continue;
        switch (elements[i].className) {
            case "BTN" :
                if (elements[i].TBINITIALIZED == null) InitBtn(elements[i]);
                elements[i].style.posLeft = tb.TBTOOLBARWIDTH;
                tb.TBTOOLBARWIDTH += elements[i].offsetWidth + 1;
                break;

            case "GEN" :
                elements[i].style.posLeft = tb.TBTOOLBARWIDTH;
                tb.TBTOOLBARWIDTH += elements[i].offsetWidth + 1;
                break;

            case "SEP" :
                elements[i].style.posLeft = tb.TBTOOLBARWIDTH + 2;
                tb.TBTOOLBARWIDTH += 5;
                break;
        }
    }
}

function InitTB(tb) {
    var s1, tr;

    tb.TBTOOLBARWIDTH = 5;

    PopTB(tb);

    tb.style.posWidth = tb.TBTOOLBARWIDTH + 4;
    tb.insertAdjacentHTML("AfterBegin", '<DIV class=tbHandleDiv style="LEFT: 3"> </DIV><DIV class=tbHandleDiv style="LEFT: 6"> </DIV>');
}

function LayoutTB() {
    var x,y,i;
    x = 0;
    y = 0;

    if (tbToolbars.length == 0) return;

    for (i = 0; i < tbToolbars.length; i++) {
        if ((x > 0) && (x + parseInt(tbToolbars[i].TBTOOLBARWIDTH) > document.body.offsetWidth)) {
            x = 0;
            y += tbToolbars[i].offsetHeight;
        }
        tbToolbars[i].style.left = x;
        x += parseInt(tbToolbars[i].TBTOOLBARWIDTH) + 4;
        tbToolbars[i].style.posTop = y;
    }

    tbContentElementTop = y + tbToolbars[0].offsetHeight;

    tbContentElementObject.style.posTop = tbContentElementTop;
    tbContentElementObject.style.left = 0;
    tbContentElementObject.style.posHeight = document.body.offsetHeight - tbContentElementBottom - tbContentElementTop;
    tbContentElementObject.style.width = document.body.offsetWidth;

    tbLastHeight = document.body.offsetHeight;
    tbLastWidth = document.body.offsetWidth;
}

function LayoutElem() {
    tbContentElementObject.style.posTop = tbContentElementTop;
    tbContentElementObject.style.left = 0;
    tbContentElementObject.style.posHeight = document.body.offsetHeight - tbContentElementBottom - tbContentElementTop;
    tbContentElementObject.style.width = document.body.offsetWidth;

    tbLastHeight = document.body.offsetHeight;
    tbLastWidth = document.body.offsetWidth;
}

document.onreadystatechange = function () {
    var i, s;

    if (document.readyState != "complete") return;

    if (bInit) return;
    bInit = true;

    document.body.scroll = "no";
    for (i = 0; i < document.body.all.length; i++) {
        if (document.body.all[i].className == "BAR") {
            InitTB(document.body.all[i]);
            tbToolbars[tbToolbars.length] = document.body.all[i];
        }
    }
    tbContentElementObject = document.body.all["tbContentElement"];
    LayoutTB();

    window.onresize = LayoutElem;
    if (top.auto)
        PutContents(top.text);
}
