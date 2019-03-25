function lTrim(str) {
    var leftidx = 0;
    while (str.charAt(leftidx) == " ") {
        leftidx++;
    }
    str = str.slice(leftidx);
    return str;
}


//去掉字串右边的空格 
function rTrim(str) {
    var rightidx = str.length;
    while (str.charAt(rightidx - 1) == " ") {
        rightidx--;
    }
    str = str.slice(0, rightidx);
    return str;
}

//去掉字串两边的空格 
function trim(str) {
    return lTrim(rTrim(str));
} 