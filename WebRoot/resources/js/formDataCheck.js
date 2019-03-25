//**************************************************************/
//*****    单位：浙大网新互连网                      ***********/
//*****    作者：陈定道                              ***********/
//*****    时间：2003/10/15                          ***********/
//*****    备注：此代码可任意拷贝                    ***********/
//*****          请保留此头文件，谢谢!               ***********/
//**************************************************************/


// 验证是否 货币
function isMoney(strValue) {
    // 货币必须是 -12,345,678.9 等格式 或者为空
    if (isEmpty(strValue)) return true;

    return checkExp(/^[+-]?\d+(,\d{3})*(\.\d+)?$/g, strValue);
}

// 验证是否 货币
function isMoney10(strValue) {
    // 货币必须是 -12345678.9 等格式 或者为空
    if (isEmpty(strValue)) return true;

    return checkExp(/^\d{1,8}(\.\d{0,2})?$/g, strValue);
}

// 验证是否 货币
function isMoney16(strValue) {
    // 货币必须是 -12345678.9 等格式 或者为空
    if (isEmpty(strValue)) return true;

    return checkExp(/^\d{1,14}(\.\d{0,2})?$/g, strValue);
}

// 验证是否 URL
function isURL(strValue) {
    // http://www.yysoft.com/ssj/default.asp?Type=1&ArticleID=789
    //if( isEmpty( strValue ) ) return true;

    //var pattern = /^(http|https|ftp):\/\/(\w+\.)+[a-z]{2,3}(\/\w+)*(\/\w+\.\w+)*(\?\w+=\w*(&\w+=\w*)*)*/gi;
    // var pattern = /^(http|https|ftp):(\/\/|\\\\)(\w+\.)+(net|com|cn|org|cc|tv|[0-9]{1,3})((\/|\\)[~]?(\w+(\.|\,)?\w\/)*([?]\w+[=])*\w+(\&\w+[=]\w+)*)*$/gi;
    // var pattern = ((http|https|ftp):(\/\/|\\\\)((\w)+[.]){1,}(net|com|cn|org|cc|tv|[0-9]{1,3})(((\/[\~]*|\\[\~]*)(\w)+)|[.](\w)+)*(((([?](\w)+){1}[=]*))*((\w)+){1}([\&](\w)+[\=](\w)+)*)*)/gi;

    //return checkExp( pattern, strValue );
    return true;

}

// 验证是否 Email
function isEmail(strValue) {
    // Email 必须是 x@a.b.c.d 等格式 或者为空
    if (isEmpty(strValue)) return true;

    //return checkExp( /^\w+@(\w+\.)+\w+$/gi, strValue );	//2001.12.24测试出错 检查 jxj-xxx@114online.com时不能通过
    //Modify By Tianjincat 2001.12.24
    var pattern = /^(([0-9a-zA-Z]+)|([0-9a-zA-Z]+[_.0-9a-zA-Z-]*[0-9a-zA-Z]+))@([a-zA-Z0-9-]+[.])+([a-zA-Z]{2}|net|com|gov|mil|org|edu|int)$/;
    return checkExp(pattern, strValue);

}

// 验证是否邮政编码
function isPostCode(strValue) {
    if (isEmpty(strValue))
        return true;
    var pattern = /^\d{6}$/;
    return checkExp(pattern, strValue);
}

function isNumeric2(strValue) {
    // 数字必须是 0123456789 或者为空
    if (isEmpty(strValue))  return true;
    return checkExp(/^\d*$/g, strValue);
}

// 验证是否 电话
function isPhone(strValue) {
    // 普通电话	(0755)4477377-3301/(86755)6645798-665
    // Call 机	95952-351
    // 手机		130/131/135/136/137/138/13912345678
    // 或者为空
    if (isEmpty(strValue)) return true;

    return checkExp(/(^\(\d{3,5}\)\d{6,8}(-\d{2,8})?$)|(^\d+-\d+$)|(^(130|131|135|136|137|138|139)\d{8}$)/g, strValue);
}

function isNumeric(strValue) {
    if (isEmpty(strValue)) return true;

    return checkExp(/^\d*$/, strValue);
}
// 使用正则表达式，检测 s 是否满足模式 re
function checkExp(re, s) {
    return re.test(s);
}
// 验证是否 为空
function isEmpty(strValue) {
    if (strValue == "")
        return true; else
        return false;
}

function maxLength(strValue, max) {
    if (strValue.length > max) {
        return false;
    }
    return true;
}
// 验证是否 日期
function isDate(strValue) {
    // 日期格式必须是 2001-10-1/2001-1-10 或者为空
    if (isEmpty(strValue)) return true;

    if (!checkExp(/^\d{4}-[01]?\d-[0-3]?\d$/g, strValue)) return false;
    // 或者 /^\d{4}-[1-12]-[1-31]\d$/

    var arr = strValue.split("-");
    var year = arr[0];
    var month = arr[1];
    var day = arr[2];

    // 1 <= 月份 <= 12，1 <= 日期 <= 31
    if (!( ( 1 <= month ) && ( 12 >= month ) && ( 31 >= day ) && ( 1 <= day ) ))
        return false;

    // 润年检查
    if (!( ( year % 4 ) == 0 ) && ( month == 2) && ( day == 29 ))
        return false;

    // 7月以前的双月每月不超过30天
    if (( month <= 7 ) && ( ( month % 2 ) == 0 ) && ( day >= 31 ))
        return false;

    // 8月以后的单月每月不超过30天
    if (( month >= 8) && ( ( month % 2 ) == 1) && ( day >= 31 ))
        return false;

    // 2月最多29天
    if (( month == 2) && ( day >= 30 ))
        return false;

    return true;
}

function dataIsValid(obj) {
    for (i = 0; i < obj.length; i++) {
        title = obj.elements[i].title;
        var name = title.split("|");
        if (name[1] == "none") {//先检查是否有空

            msg = name[0] + "不能为空!";
            if (name[2] == "edit") {//编辑形
                if ((obj.elements[i].value).length < 1) {
                    obj.elements[i].focus();
                    obj.elements[i].select();
                    alert(msg);
                    return false;
                }

            } else if (name[2] == "list") {//下拉型

                if ((obj.elements[i].value).length < 1) {
                    obj.elements[i].focus();


                    alert(msg);
                    return false;
                }

            }
        }
        //日期格式可以为空，检查格式是否正确
        else if (name[1] == "date" && name[2] == "edit") {//后检查日期格式是否正确
            if (isDate(obj.elements[i].value) == false) {
                msg = name[0] + "格式不正确!";
                alert(msg);
                obj.elements[i].focus();
                obj.elements[i].select();
                return false;
            }
        }
        //日期格式不可以为空，检查格式是否正确
        else if (name[1] == "datenone" && name[2] == "edit") {//检查日期格式是否正确且不空
                if ((obj.elements[i].value).length < 1) {
                    msg = name[0] + "不能为空!";
                    obj.elements[i].focus();
                    obj.elements[i].select();
                    alert(msg);
                    return false;
                }//首先检查是否空
                if (isDate(obj.elements[i].value) == false) {
                    msg = name[0] + "格式不正确!";
                    alert(msg);
                    obj.elements[i].focus();
                    obj.elements[i].select();
                    return false;
                }
            }
            //检查是否是数字 且可以为空
            else if (name[1] == "numeric" && name[2] == "edit") {//检查是否是数字且可以为空

                    if (isNumeric(obj.elements[i].value) == false) {
                        msg = name[0] + "必须是数字!";
                        alert(msg);
                        obj.elements[i].focus();
                        obj.elements[i].select();
                        return false;
                    }

                }
                //检查是否是数字 且不可以为空
                else if (name[1] == "numericnone" && name[2] == "edit") {//检查是否是数字且不可以为空

                        if ((obj.elements[i].value).length < 1) {
                            msg = name[0] + "不能为空!";
                            obj.elements[i].focus();
                            obj.elements[i].select();
                            alert(msg);
                            return false;
                        }//首先检查是否空
                        if (isNumeric(obj.elements[i].value) == false) {
                            msg = name[0] + "必须是数字!";
                            alert(msg);
                            obj.elements[i].focus();
                            obj.elements[i].select();
                            return false;
                        }

                    }
                    //检查是否是货币且可以为空
                    else if (name[1] == "money" && name[2] == "edit") {//检查是否是货币且可以为空
                            if (isMoney(obj.elements[i].value) == false) {
                                msg = name[0] + "必须是小数形,比如：11.11!";
                                alert(msg);
                                obj.elements[i].focus();
                                obj.elements[i].select();
                                return false;
                            }

                        }
                        //检查是否是货币且不可以为空
                        else if (name[1] == "moneynone" && name[2] == "edit") {//检查是否是货币且不可以为空
                                if ((obj.elements[i].value).length < 1) {
                                    msg = name[0] + "不能为空!";
                                    obj.elements[i].focus();
                                    obj.elements[i].select();
                                    alert(msg);
                                    return false;
                                }
                                if (isMoney(obj.elements[i].value) == false) {
                                    msg = name[0] + "必须是小数形,比如：11.11!";
                                    alert(msg);
                                    obj.elements[i].focus();
                                    obj.elements[i].select();
                                    return false;
                                }

                            }
                            //检查是否是 最多8位整数  最多2位小数 可以为空
                            else if (name[1] == "money10" && name[2] == "edit") {
                                    if (!isMoney10(obj.elements[i].value)) {
                                        msg = name[0] + "格式不正确";
                                        alert(msg);
                                        obj.elements[i].focus();
                                        obj.elements[i].select();
                                        return false;
                                    }
                                }
                                //检查是否是 最多8位整数  最多2位小数 不可以为空
                                else if (name[1] == "money10none" && name[2] == "edit") {
                                        if (isEmpty(obj.elements[i].value)) {
                                            msg = name[0] + "不能为空";
                                            alert(msg);
                                            obj.elements[i].focus();
                                            return false;
                                        }
                                        if (!isMoney10(obj.elements[i].value)) {
                                            msg = name[0] + "格式不正确";
                                            alert(msg);
                                            obj.elements[i].focus();
                                            obj.elements[i].select();
                                            return false;
                                        }
                                    }
                                    //检查是否是 最多14位整数  最多2位小数  可以为空
                                    else if (name[1] == "money16" && name[2] == "edit") {
                                            if (!isMoney16(obj.elements[i].value)) {
                                                msg = name[0] + "格式不正确";
                                                alert(msg);
                                                obj.elements[i].focus();
                                                obj.elements[i].select();
                                                return false;
                                            }
                                        }
                                        //检查是否是 最多14位整数  最多2位小数 不可以为空
                                        else if (name[1] == "money16none" && name[2] == "edit") {
                                                if (isEmpty(obj.elements[i].value)) {
                                                    msg = name[0] + "不能为空";
                                                    alert(msg);
                                                    obj.elements[i].focus();
                                                    return false;
                                                }
                                                if (!isMoney16(obj.elements[i].value)) {
                                                    msg = name[0] + "格式不正确";
                                                    alert(msg);
                                                    obj.elements[i].focus();
                                                    obj.elements[i].select();
                                                    return false;
                                                }
                                            }
                                            //email可以为空
                                            else if (name[1] == "email" && name[2] == "edit") {
                                                    if (!isEmail(obj.elements[i].value)) {
                                                        msg = name[0] + "格式不正确";
                                                        alert(msg);
                                                        obj.elements[i].focus();
                                                        obj.elements[i].select();
                                                        return false;
                                                    }
                                                }
                                                //email不可以为空
                                                else if (name[1] == "emailnone" && name[2] == "edit") {
                                                        if (isEmpty(obj.elements[i].value)) {
                                                            msg = name[0] + "不能为空";
                                                            alert(msg);
                                                            obj.elements[i].focus();
                                                            return false;
                                                        }
                                                        if (!isEmail(obj.elements[i].value)) {
                                                            msg = name[0] + "格式不正确";
                                                            alert(msg);
                                                            obj.elements[i].focus();
                                                            obj.elements[i].select();
                                                            return false;
                                                        }
                                                    }
                                                    //电话可以为空
                                                    else if (name[1] == "tel" && name[2] == "edit") {
                                                            if (!isPhone(obj.elements[i].value)) {
                                                                msg = name[0] + "格式不正确";
                                                                alert(msg);
                                                                obj.elements[i].focus();
                                                                obj.elements[i].select();
                                                                return false;
                                                            }
                                                        }
                                                        //电话不可以为空
                                                        else if (name[1] == "telnone" && name[2] == "edit") {
                                                                if (isEmpty(obj.elements[i].value)) {
                                                                    msg = name[0] + "不能为空";
                                                                    alert(msg);
                                                                    obj.elements[i].focus();
                                                                    return false;
                                                                }
                                                                if (!isPhone(obj.elements[i].value)) {
                                                                    msg = name[0] + "格式不正确";
                                                                    alert(msg);
                                                                    obj.elements[i].focus();
                                                                    obj.elements[i].select();
                                                                    return false;
                                                                }
                                                            }
                                                            //url判断
                                                            else if (name[1] == "url" && name[2] == "edit") {
                                                                    if (!isURL(obj.elements[i].value)) {
                                                                        msg = name[0] + "格式不正确";
                                                                        alert(msg);
                                                                        obj.elements[i].focus();
                                                                        obj.elements[i].select();
                                                                        return false;
                                                                    }
                                                                }
                                                                //邮编校验，可以为空
                                                                else if (name[1] == "postcode" && name[2] == "edit") {
                                                                        if (!isPostCode(obj.elements[i].value)) {
                                                                            msg = name[0] + "格式不正确";
                                                                            alert(msg);
                                                                            obj.elements[i].focus();
                                                                            obj.elements[i].select();
                                                                            return false;
                                                                        }
                                                                    }
        /*
         else if(name[1]=="numericnull"&&name[2]=="edit"){//检查是否是数字且可以为空
         if(isNumeric2(obj.elements[i].value)==false){
         msg=name[0]+"必须是数字!";
         alert(msg);
         obj.elements[i].focus();
         obj.elements[i].select();
         return false;
         }

         }
         */
    }//for
    return true;
}
function check(obj) {
    if (!dataIsValid(obj))
        return false;
    return true;
} 
