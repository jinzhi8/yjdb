document.write("<style media=\"print\">.noprint{display:none}</style>");
document.write("<object id=printerobject style='display:none' classid='clsid:1663ed61-23eb-11d2-b92f-008048fdd814'  codebase='/wzoa/print/smsx.cab#Version=6,3,435,20'></object>");
function getprintbar() {
    document.write("<input type=\"button\" class=\"noprint\" value=\"直接打印\" onclick=\"print()\" style=\"width:90px\"><input type=\"button\" class=\"noprint\" value=\"打印\" onclick=\"printit(true)\" style=\"width:90px\"><input type=\"button\" class=\"noprint\" value=\"打印预览\" onclick=\"preview()\" style=\"width:90px\"><input type=\"button\" class=\"noprint\" value=\"打印设置\" onclick=\"printsetup()\" style=\"width:90px\"><input type=\"button\" class=\"noprint\"  value=\"下载打印控件\" title=\"如果无法打印,请点击下载控件。\" onclick=\"location.href='/wzoa/print/smsx.exe'\" style=\"width:90px\">");
}
function printsetup() {
    if (!document.getElementById("printerobject").object) {
        alert("打印控件未安装!请下载并安装控件！\n请下载并安装弹出的打印控件安装程序，步骤如下：\n1、下载窗口点击［运行］或［保存］本地后在运行。\n2、弹出的IE安全警告，点击［运行］。\n3、Do you want to install ScriptX? 点击［是］。\n4、安装授权提示，点击［Yes］\n5、ScriptX was sccuessfully installed,点击［确定］。\n6、Do you want to restart your computer now? 点击［否］。\n7、在刷新打印的页面再点击打印。如果提示打印控件未安装请重新启动电脑。");
        //navigate("scriptx.htm");
        location.href = "/wzoa/print/smsx.exe"
        return;
    }
    var p = document.getElementById("printerobject");
    try {
        p.printing.header = "";
        p.printing.footer = "";
        p.printing.leftMargin = 3.81;
        p.printing.rightMargin = 4.36;
        p.printing.topMargin = 4.19;
        p.printing.bottomMargin = 7.24;
        //portrait:true为竖向，false为横向
        p.printing.portrait = true;
    } catch(e) {
        alert("找不到打印机,请添加或安装打印机！\n以下情况可能会找不到打印机无法打印:\n1、电脑上未连接打印机。\n2、电脑上未安装打印机。\n3、电脑上未正确安装打印机。\n4、网络打印机未连接上。\n5、使用远程终端的时候未加载本地打印机。\n6、请到［开始］［设置］［控制面板］［打印机和传真］查看是否有正常可用的打印机。");
        return;
    }
    p.printing.PageSetup();
}
function preview() {
    if (!document.getElementById("printerobject").object) {
        alert("打印控件未安装!请下载并安装控件！\n请下载并安装弹出的打印控件安装程序，步骤如下：\n1、下载窗口点击［运行］或［保存］本地后在运行。\n2、弹出的IE安全警告，点击［运行］。\n3、Do you want to install ScriptX? 点击［是］。\n4、安装授权提示，点击［Yes］\n5、ScriptX was sccuessfully installed,点击［确定］。\n6、Do you want to restart your computer now? 点击［否］。\n7、在刷新打印的页面再点击打印。如果提示打印控件未安装请重新启动电脑。");
        //navigate("scriptx.htm");
        location.href = "/wzoa/print/smsx.exe"
        return;
    }
    var p = document.getElementById("printerobject");
    try {
        p.printing.header = "";
        p.printing.footer = "";
        p.printing.leftMargin = 3.81;
        p.printing.rightMargin = 4.36;
        p.printing.topMargin = 4.19;
        p.printing.bottomMargin = 7.24;
        //portrait:true为竖向，false为横向
        p.printing.portrait = true;
    } catch(e) {
        alert("找不到打印机,请添加或安装打印机！\n以下情况可能会找不到打印机无法打印:\n1、电脑上未连接打印机。\n2、电脑上未安装打印机。\n3、电脑上未正确安装打印机。\n4、网络打印机未连接上。\n5、使用远程终端的时候未加载本地打印机。\n6、请到［开始］［设置］［控制面板］［打印机和传真］查看是否有正常可用的打印机。");
        window.status = "找不到打印机,请添加或安装打印机！";
        return;
    }
    p.printing.Preview();
}
function print() {
    if (!document.getElementById("printerobject").object) {
        alert("打印控件未安装!请下载并安装控件！\n请下载并安装弹出的打印控件安装程序，步骤如下：\n1、下载窗口点击［运行］或［保存］本地后在运行。\n2、弹出的IE安全警告，点击［运行］。\n3、Do you want to install ScriptX? 点击［是］。\n4、安装授权提示，点击［Yes］\n5、ScriptX was sccuessfully installed,点击［确定］。\n6、Do you want to restart your computer now? 点击［否］。\n7、在刷新打印的页面再点击打印。如果提示打印控件未安装请重新启动电脑。");
        location.href = "/wzoa/print/smsx.exe"
        return;
    }
    var p = document.getElementById("printerobject");
    try {
        p.printing.header = "";
        p.printing.footer = "";
        p.printing.leftMargin = 3.81;
        p.printing.rightMargin = 4.36;
        p.printing.topMargin = 4.19;
        p.printing.bottomMargin = 7.24;
        //portrait:true为竖向，false为横向
        p.printing.portrait = true;
    } catch(e) {
        alert("找不到打印机,请添加或安装打印机！\n以下情况可能会找不到打印机无法打印:\n1、电脑上未连接打印机。\n2、电脑上未安装打印机。\n3、电脑上未正确安装打印机。\n4、网络打印机未连接上。\n5、使用远程终端的时候未加载本地打印机。\n6、请到［开始］［设置］［控制面板］［打印机和传真］查看是否有正常可用的打印机。");
        return;
    }
    try {
        window.status = "准备打印...";
        p.printing.Print(false);
        //p.printing.Print(true);
        window.status = "正在打印...";
    } catch(e) {
        alert("打印出错,当前页面已经在打印或打印机忙！");
        window.status = "打印出错,当前页面已经在打印或打印机忙！";
        return;
    }
    window.status = "打印完成！";
}
function printit(obj) {
    if (!document.getElementById("printerobject").object) {
        alert("打印控件未安装!请下载并安装控件！\n请下载并安装弹出的打印控件安装程序，步骤如下：\n1、下载窗口点击［运行］或［保存］本地后在运行。\n2、弹出的IE安全警告，点击［运行］。\n3、Do you want to install ScriptX? 点击［是］。\n4、安装授权提示，点击［Yes］\n5、ScriptX was sccuessfully installed,点击［确定］。\n6、Do you want to restart your computer now? 点击［否］。\n7、在刷新打印的页面再点击打印。如果提示打印控件未安装请重新启动电脑。");
        location.href = "/wzoa/print/smsx.exe"
        return;
    }
    var p = document.getElementById("printerobject");
    try {
        p.printing.header = "";
        p.printing.footer = "";
        p.printing.leftMargin = 3.81;
        p.printing.rightMargin = 4.36;
        p.printing.topMargin = 4.19;
        p.printing.bottomMargin = 7.24;
        //portrait:true为竖向，false为横向
        p.printing.portrait = true;
    } catch(e) {
        alert("找不到打印机,请添加或安装打印机！\n以下情况可能会找不到打印机无法打印:\n1、电脑上未连接打印机。\n2、电脑上未安装打印机。\n3、电脑上未正确安装打印机。\n4、网络打印机未连接上。\n5、使用远程终端的时候未加载本地打印机。\n6、请到［开始］［设置］［控制面板］［打印机和传真］查看是否有正常可用的打印机。");
        return;
    }
    try {
        window.status = "准备打印...";
        //p.printing.Print(false);
        p.printing.Print(obj);
        window.status = "正在打印...";
    } catch(e) {
        alert("打印出错,当前页面已经在打印或打印机忙！");
        window.status = "打印出错,当前页面已经在打印或打印机忙！";
        return;
    }
    window.status = "打印完成！";
}
