//====================================== ����ũ�� y���������
function getcnMonthName(month) {
    var ar = new Array(13)
    ar[0] = "��"
    ar[1] = "һ��"
    ar[2] = "����"
    ar[3] = "����"
    ar[4] = "����"
    ar[5] = "����"
    ar[6] = "����"
    ar[7] = "����"
    ar[8] = "����"
    ar[9] = "����"
    ar[10] = "ʮ��"
    ar[11] = "ʮһ��"
    ar[12] = "ʮ����"
    return ar[month]
}

function printYearMon() {

    var year = 2002;

    var tables = '<table cellspacing=0 bordercolordark=#ffffff cellpadding=2 width=95% bordercolorlight=#999999 border=1 align="center" height="109">'
    var tds = ''
    var moncal = '<tr align="right" valign="top">'
    tables += '<tr valign="middle" align="center" bgcolor="#ebebeb">'
    tables += '<td colspan="5" height="27">'
    tables += '<a href=/oasystemep/grsw/arrange.nsf/arrange?openview&count=3000&yea=' + (year - 1) + '>'
    tables += '<img src=/images/last.gif width=6 height=9 border=0></a>&nbsp;&nbsp;&nbsp;' + year + '��&nbsp;&nbsp;&nbsp;'
    tables += '<a href=/oasystemep/grsw/arrange.nsf/arrange?openview&count=3000&yea=' + (year + 1) + '><img src=/images/next.gif width=6 height=9 border=0></a>'
    tables += '</td></tr>'

    for (var i = 1; i <= 12; i++) {
        if (i % 4 == 1) {
            if (tds.length > 0) tds += moncal;

            else tds = moncal;
        }
        tds += '<td height="23" width="48"><a href=/oasystemep/grsw/arrange.nsf/arrange?openview&count=3000&yea=' + year + '&mon=' + i + '>' + getcnMonthName(i) + "</a></td>"
    }

    tables += tds + '</tr></table>'
    document.write(tables)
}


function printDayTodo() {

    //var ls='<a target="_blank" href=/oasystemep/grsw/arrange.nsf/arrange?openform&yea='+year+"&mon="+month+"&dat="+day+"&bgh="
    tables = '<table cellspacing=0 bordercolordark=#ffffff cellpadding=2 width=100% bordercolorlight=#999999 border=1 ><tr bgcolor=#dddddd><td align=left>��<font color=#FF0000>' + year + '��' + month + '��' + day + '��</font>' + '�İ������£�</td></tr></table>'
    //tables='��<font color=#FF0000>'+year+'��'+month+'��'+day+'��</font>'+'�İ������£�'
    tables += '<table cellspacing=0 bordercolordark=#ffffff cellpadding=2 width=99% bordercolorlight=#999999 border=1 align="center">'
    //tables='<div id="arrange_table"><table cellspacing=0 bordercolordark=#ffffff cellpadding=2 width=99% bordercolorlight=#999999 border=1 align="center">'
    tables += '<tr bgcolor=#dddddd height=10px><td align=middle width=42>ʱ��</td><td align=middle width="182">����</td></tr>'

    for (var i = 0; i <= 4; i++) {
        if (i < 4) {
            tables += '<tr bgcolor=#dddddd height=10px><td align=middle width=60 ondblclick="newopen();"><div id="t'

            tables += i + '">&nbsp;</div></td><td width="240" align=left valign=middle ondblclick="newopen()"><div id="it' + i + '">&nbsp;</div></td></tr>'
        } else {
            tables += '<tr bgcolor=#dddddd height=10px><td align=center width=60 ondblclick="newopen()"><div id="t'
            tables += i + '">&nbsp;</div></td><td width="240" align=right valign=middle ondblclick="newopen();"><div id="it' + i + '">&nbsp;</div></td></tr>'
        }
    }

    tables += "</table></div>"
    document.write(tables)
}