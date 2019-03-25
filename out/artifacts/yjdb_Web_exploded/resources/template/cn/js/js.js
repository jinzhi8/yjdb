//<!--   
//屏蔽鼠标右键、Ctrl+N、Shift+F10、F5刷新、退格键 
//屏蔽F1帮助   
//function killerrors() { 
//return true; 
//} 
//window.onerror = killerrors; 

window.onhelp = function() {return   false;};
function KeyDown() {
    //屏蔽Alt+方向键←
    //屏蔽Alt+方向键→
    if ((window.event.altKey) && ((window.event.keyCode == 37) || (window.event.keyCode == 39))) {
        event.returnValue = false;
    }
    //屏蔽退格删除键
    //屏蔽F5刷新键
    //Ctrl   +   R
    //if((event.keyCode==8)||(event.keyCode==116)||(event.ctrlKey&&event.keyCode==82)){
    if ((event.keyCode == 116) || (event.ctrlKey && event.keyCode == 82)) {
        event.keyCode = 0;
        event.returnValue = false;
    }
    //屏蔽Ctrl+N
    if ((event.ctrlKey) && (event.keyCode == 78)) {
        event.returnValue = false;
    }
    //屏蔽shift+F10
    if ((event.shiftKey) && (event.keyCode == 121)) {
        event.returnValue = false;
    }
    //屏蔽shift加鼠标左键新开一网页
    if (window.event.srcElement.tagName == "A" && window.event.shiftKey) {
        window.event.returnValue = false;
    }
    //屏蔽Alt+F4
    if ((window.event.altKey) && (window.event.keyCode == 115)) {
        window.showModelessDialog("about:blank", "", "dialogWidth:1px;dialogheight:1px");
        return   false;
    }
}
/*   另外可以用   window.open   的方法屏蔽   IE   的所有菜单
 第一种方法：
 window.open("你的.htm",   "","toolbar=no,location=no,directories=no,menubar=no,scrollbars=no,resizable=yes,status=no,top=0,left=0")
 第二种方法是打开一个全屏的页面：
 window.open("你的.asp",   "",   "fullscreen=yes")
 */
//-->
//function   document.oncontextmenu()   {return   false}
document.onkeydown = function() {KeyDown();};

/**
 * 根据ID获得元素
 * @param id
 * @return
 */
var $getId = function (id) {
    return "string" == typeof id ? document.getElementById(id) : id;
};

/**
 * 得到前一个元素
 * @param elem
 * @return
 */
function getPreviousSibling(elem) {
    //elem = document.getElementById(elem);
    elem = elem.previousSibling;
    while (elem.previousSibling && elem.tagName == 'undefined') {
        elem = elem.previousSibling;
    }
    return elem;
}

/**
 * 得到后一个元素
 * @param elem
 * @return
 */
function getNextSibling(elem) {
    //elem = document.getElementById(elem);
    elem = elem.nextSibling;
    while (elem.previousSibling && elem.tagName == 'undefined') {
        elem = elem.nextSibling;
    }
    return elem;
}

/**
 * 在制定元素后插入元素
 * @param new_node
 * @param existing_node
 * @return
 */
function insertAfter(new_node, existing_node) {
    if (existing_node.nextSibling) {
        existing_node.parentNode.insertBefore(new_node, existing_node.nextSibling);
    } else {
        existing_node.parentNode.appendChild(new_node);
    }
}

/**
 * 添加附件
 * @param obj
 * @param inputname
 * @return
 */
function appendAttachment(obj, inputname) {
    var previousObj = getPreviousSibling(obj);
    var inputElement = document.createElement("INPUT");
    inputElement.type = "file";
    inputElement.name = inputname;
    inputElement.onkeydown = function() {return false;};
    var brElement = document.createElement("BR");
    insertAfter(brElement, previousObj);
    insertAfter(inputElement, previousObj);
}

/*
  *添加多附件
  */

 function addattachment2(objname,obj){
    var more = $(objname);
    var br = document.createElement("br");
    var input = document.createElement("input");
    var button = document.createElement("input");
    input.type = "file";
    input.name = objname;
    button.type = "button";
    button.value = "删除";
    insertAfter(br, obj);
    insertAfter(input, obj);
    insertAfter(button, obj);
    button.onclick = function(){
        more.parentNode.removeChild(br);
        more.parentNode.removeChild(input);
        more.parentNode.removeChild(button);
    }; 
}


function deletead(objname,obj){
	//var html=document.getElementById('attachmentID').innerHTML;
	//document.getElementById('attachmentID').innerHTML=html; 
	//alert(objname);
	//alert(obj.value);
	//alert(obj.previousSibling.value);
	//var c=obj.parentNode.firstChild;
	//alert(c.value);
	//var br=obj.nextSibling;
	//br.parentNode.removeChild(br);
	var file=obj.previousSibling;
	//file.parentNode.removeChild(file);
	//obj.parentNode.removeChild(obj);
	//alert(file.value);
	file.outerHTML=file.outerHTML.replace(/(value=\").+\"/i,"$1\"");
  // var previousObj = getPreviousSibling(obj);
   // alter(previousObj);
   //previousObj.value='';
  //  var previousObj2 = getPreviousSibling(previousObj);
   //alter(previousObj2.value);
   //alter(obj.parentNode);
    //var more = document.getElementById(objname);
    //var more = event.srcElement;    
    //obj.parentNode.removeChild(previousObj);
}

function addattachment(objname,obj){
    //var more = document.getElementById(objname);
    //var more = event.srcElement;
    var more = obj;
    var br = document.createElement("br");
    var input = document.createElement("input");
    var button = document.createElement("input");
    
    input.type = "file";
    input.name = objname;
    input.className = "fileclass";
    
    button.type = "button";
    button.value = "删除";
    
    more.parentNode.insertBefore(br, more);
    more.parentNode.insertBefore(input, more);
    more.parentNode.insertBefore(button, more);

    button.onclick = function(){
        more.parentNode.removeChild(br);
        more.parentNode.removeChild(input);
        more.parentNode.removeChild(button);
    }; 
}
//兼容ie，firefox等浏览器的showModelessDialog
var userAgent = navigator.userAgent.toLowerCase();
var isNoIE=/(mozilla|opera|webkit)/.test(userAgent) && !/(compatible)/.test(userAgent);
var isFireFox=/mozilla|opera/.test(userAgent) && !/(compatible|webkit)/.test(userAgent);
if(isFireFox)
{
    window.showModelessDialog=function (url)
    {
        var windowName=(arguments[1]==null?"":arguments[1].toString());
        var feature=(arguments[2]==null?"":arguments[2].toString());
        var OpenedWindow=window.open(url,windowName,feature);
        //window.addEventListener('click',function (){OpenedWindow.focus();},false);
        return OpenedWindow;
    }
    window.showModalDialog=function (url,id,status)
    {
        var windowName=(arguments[1]==null?"":arguments[1].toString());
        var feature=(arguments[2]==null?"":arguments[2].toString());
        var OpenedWindow=window.open(url,windowName,feature);
        //window.addEventListener('click',function (){OpenedWindow.focus();},false);
        return OpenedWindow;
    }
}
else
{
    //子窗口中调用父窗口
    //IE中用window.parent.document
    //FF中用window.opener.document
    //下面的代码将 作用于IE '重载' window.showModelessDialog 方法 统一用 window.opener访问父窗口
    var originFn=window.showModelessDialog;
    window.showModelessDialog=function (url)
    {
        var OpenedWindow= originFn(url,arguments[1],arguments[2]);
        OpenedWindow.opener=window;
    }
}
function popW(s)
{
    var OpenedWindow=window.showModelessDialog(s,'','width=400,height=400');

}
var $$ = function (id) {
	return "string" == typeof id ? document.getElementById(id) : id;
};
function LoadEditor(obj,type){
	if(type=='simple'){
		KE.show({
			id : obj,
			resizeMode : 1,
			imageUploadJson : KE.scriptPath+'/upload_json.jsp',
			fileManagerJson : KE.scriptPath+'/file_manager_json.jsp',
			allowFileManager : true,
			allowPreviewEmoticons : false,
			allowUpload : true,
			items : [
			'fullscreen','fontname', 'fontsize', '|', 'textcolor', 'bgcolor', 'bold', 'italic', 'underline',
			'removeformat', '|', 'justifyleft', 'justifycenter', 'justifyright', 'insertorderedlist',
			'insertunorderedlist', '|', 'emoticons', 'image', 'link']
		});
	}else{
		KE.show({
			id : obj,
			imageUploadJson : KE.scriptPath+'/upload_json.jsp',
			fileManagerJson : KE.scriptPath+'/file_manager_json.jsp',
			allowFileManager : true,
			cssPath : './index.css',
			afterCreate : function(id) {
				
			}
		});
	}
}
