//实现流转过程中选择单人的地址本选择功能
//数据库showaddress.nsf		代理winet_saddress调用
//Created 2003-06-09 by zhanghao

var singleFlag = false;		//是否已经选择人员
function formatit(obj) {
    var saveOption = parent.document.all.saveOptions;
    var saveItemID = parent.document.all.saveItemID;
    var saveUserids = parent.document.all.saveUserids;

    if (saveOption.value != "") {
        saveOption.value += "," + obj.value;
    } else {
        saveOption.value = obj.value;
    }
    if (saveItemID.value != "") {
        saveItemID.value += "," + obj.id;
    } else {
        saveItemID.value = obj.id;
    }

    if (saveUserids.value != "") {
        saveUserids.value += "," + obj.userid;
    } else {
        saveUserids.value = obj.userid;
    }
}

function clk(content, param) {
    var obj = document.all[content];
    if (obj.checked == false) {
        obj.checked = true;
    } else {
        obj.checked = false;
    }
    checkit(obj);
    reflash();
}

function moveOut(obj) {
    var objID = obj.id;
    var saveItemID = parent.document.all.saveItemID;
    var itemIDs = saveItemID.value;
    var itemIDList = itemIDs.split(",");
    var saveOptions = parent.document.all.saveOptions;
    var optArray = saveOptions.value.split(",");

    var useridList = parent.document.all.saveUserids;
    var userArray = useridList.value.split(",");
    var saveOpt = "";
    var itemStr = "";
    var userStr = "";

    for (var i = 0; i < itemIDList.length; i++) {
        if (itemIDList[i] != objID) {
            if (saveOpt != "") {
                saveOpt += "," + optArray[i];
                itemStr += "," + itemIDList[i];
                userStr += "," + userArray[i];
            } else {
                saveOpt = optArray[i];
                itemStr = itemIDList[i];
                userStr = userArray[i]
            }
        }
    }
    saveOptions.value = saveOpt;
    saveItemID.value = itemStr;
    useridList.value = userStr;
}

function moveIdxOut(selIndex) {
    if (selIndex > -1) {
        var itemIDs = parent.document.all.saveItemID;
        var itemIDList = itemIDs.value.split(",");
        var saveOptions = parent.document.all.saveOptions;
        var optArray = saveOptions.value.split(",");

        var objID = itemIDList[selIndex];
        if (objID != "") {
            var obj = document.all[objID];
            obj.checked = false;
            checkit(obj);
        }
        var newArr = new Array();
        newArr = newArr.concat(optArray.slice(0, selIndex), optArray.slice(selIndex + 1));
        saveOptions.value = newArr.join(",");

        newArr = new Array();
        newArr = newArr.concat(itemIDList.slice(0, selIndex), itemIDList.slice(selIndex + 1))
        itemIDs.value = newArr.join(",");

    }

}

function Sel(n) {
}
function expandCompressNode(node, num) {
    for (var i = 1; i <= num; i++) {
        var obj = document.all["Item" + node + "_" + i]
        if (obj != null) {
            if (obj.style.display == "none") {
                obj.style.display = "block";
            } else {
                obj.style.display = "none";
            }
        }
    }
    if (document.all["Item" + node].hstyle == "no") {
        document.all["PM" + node].src = "explorer/image/tminus20.gif";
        document.all["Item" + node].hstyle = "yes";
    } else {
        document.all["PM" + node].src = "explorer/image/lplus20.gif";
        document.all["Item" + node].hstyle = "no";
    }

}

function removeallcheck(objIDs) {
    singleFlag = false;
    for (x in objIDs) {
        if (objIDs[x] != "") {
            var obj = document.all[objIDs[x]];
            obj.checked = false;
            if (objIDs[x].indexOf("_") < 0) {
                var objID = obj.id;
                for (i = 1; i <= obj.num; i++) {
                    subObjID = objID + "_" + i.toString(10);
                    document.all[subObjID].checked = false;
                }
            }
        }
    }
}

function checkit(obj) {

    if (obj.checked == true) {
        if (true) {
            formatit(obj);
            singleFlag = true;
            parent.getold();
        } else {
            alert("只能选择一位人员！");
            obj.checked = false;
            return false;
        }
    } else {
        singleFlag = false;
        moveOut(obj);
    }
    parent.getold();
}

function checkitb(obj) {
    itemID = obj.id;

    if (obj.checked == true) {

        formatit(obj.value, itemID);
        singleFlag = true;

    } else {
        singleFlag = false;
        moveOut(obj);
    }
}

function reflash() {
    parent.getold("");
}
