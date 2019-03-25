var weekdays = new Array(7);
var link_year;
var link_month;
var link_day;   //用于周历的超链接
//月份的编码是按照：0，1，2，3，4，5，6，7，8，9，10，11
newday = new Date(year, month - 1, day);
theDate = new Date(year, month - 1, day);
var weeknum = newday.getDay()//当前日期的星期
mmm = parseInt(month);
weekdays[weeknum] = theDate.getYear() + "-" + mmm + "-" + theDate.getDate();

//将本周日期放入数组weekdays[7]中
for (i = weeknum; i < 6; i++) {
    weekdays[i + 1] = back(weekdays[i], i + 1)
}

for (i = weeknum; i > 0; i--) {
    weekdays[i - 1] = fore(weekdays[i], i - 1)
}
setCal()

function leapYear(year) {
    if ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0 ))) {
        return true
    }
    return false
}

function getDays(month, year) {
    var ar = new Array(12)
    ar[0] = 31
    ar[1] = (leapYear(year)) ? 29 : 28
    ar[2] = 31
    ar[3] = 30
    ar[4] = 31
    ar[5] = 30
    ar[6] = 31
    ar[7] = 31
    ar[8] = 30
    ar[9] = 31
    ar[10] = 30
    ar[11] = 31
    return ar[month]
}

function getMonthName(month) {
    var ar = new Array(12)
    ar[0] = "1月"
    ar[1] = "2月"
    ar[2] = "3月"
    ar[3] = "4月"
    ar[4] = "5月"
    ar[5] = "6月"
    ar[6] = "7月"
    ar[7] = "8月"
    ar[8] = "9月"
    ar[9] = "10月"
    ar[10] = "11月"
    ar[11] = "12月"
    return ar[month]
}

function back(datestr, pos) {
    str1 = datestr
    var weeky = str1.substring(-1, 4)
    str1 = str1.substring(5)
    var num1 = str1.search("-")
    var weekm = str1.substring(-2, num1)
    var weekd = str1.substring(num1 + 1)
    var week = weeky + "-" + weekm + "-" + weekd
    var daynn = getDays(weekm - 1, weeky)//weekm是月份数，但是第一个参数却只是数组下标
    weekdd = parseInt(weekd) + 1
    weekmm = parseInt(weekm) + 1
    weekyy = parseInt(weeky) + 1
    if (weekdd - parseInt(daynn) <= 0) {weekdays[pos] = weeky + "-" + weekm + "-" + weekdd} else if (weekmm <= 12) {weekdays[pos] = weeky + "-" + weekmm + "-1";} else {weekdays[pos] = weekyy + "-1-1";}
    return(weekdays[pos])
}//fun

function fore(datestr, pos) {
    str1 = datestr
    var weeky = str1.substring(-1, 4)
    str1 = str1.substring(5)
    var num1 = str1.search("-")
    var weekm = str1.substring(-2, num1)
    var weekd = str1.substring(num1 + 1)
    var week = weeky + "-" + weekm + "-" + weekd//就是参数？

    var daynn = getDays(weekm - 2, weeky)//上月的天数。weekm是月份数，但是第一个参数却只是数组下标
    weekdd = parseInt(weekd) - 1
    weekmm = parseInt(weekm) - 1
    weekyy = parseInt(weeky) - 1
    if (weekdd > 0) {weekdays[pos] = weeky + "-" + weekm + "-" + weekdd} else if (weekmm > 0) {weekdays[pos] = weeky + "-" + weekmm + "-" + daynn;} else {weekdays[pos] = weekyy + "-12-31"}
    return (weekdays[pos])
}//funfore

function setCal() {
    var monthName = getMonthName(month) // 获取显示月份
    var firstDayInstance = new Date(year, month, 1)
    var firstDay = firstDayInstance.getDay()// 获取星期顺序号，1-星期六，2-星期天

    firstDayInstance = null
    var days = getDays(month, year) // 获取要显示的月份的总天数
    drawCal(firstDay + 1, days, monthName, year)
}
//转换日期函数

function drawCal(firstDay, lastDate, monthName, year) {
    var headerHeight = 34 // height of the table's header cell
    var border = 2 // 3D height of table's border
    var cellspacing = 2 // width of table's border
    var headerColor = "midnightblue" // color of table's header
    var headerSize = "-1" // size of tables header font
    var colWidth = 92 // width of columns in table   92
    var dayCellHeight = 50 // height of cells containing days of the week
    var dayColor = "0000BC" // color of font representing week days
    var cellwidth = 500// height of cells representing dates in the calendar
    var todayColor = "red" // color specifying today's date in the calendar
    var timeColor = "purple" // color of font representing current time

    var text = ""
    text += '<CENTER>'
    //text += '<TABLE BORDER=1 style="font-size: 9pt" width=100% cellspacing=2 cellpadding=0 bordercolor="#E4E4E4" >'
    text += '<table cellspacing=0 bordercolordark=#ffffff cellpadding=2 width=99% bordercolorlight=#999999 border=1 align="center">'
    text += '<TH bgcolor="#EFEBEF" COLSPAN=7 HEIGHT=' + headerHeight + '>';
    text += '<a href="arrange.jsp?type=2&year=' + lasty + '&month=' + lastm + '&day=' + lastd + '&share=' + share + '"><img src="../resources/images/arrange/last.gif" width="6" height="9" border=0></a>&nbsp;' + weekdays[0] + '到' + weekdays[6] + '&nbsp;';
    //alert(weekdays[0]);
    //alert(weekdays[6]);
    document.all["bgtime"].value = weekdays[0];
    document.all["endtime"].value = weekdays[6];
    text += '<a href="arrange.jsp?typ=2&year=' + nexty + '&month=' + nextm + '&day=' + nextd + '&share=' + share + '"><img src="../resources/images/arrange/next.gif" width="6" height="9" border=0></a>'
    text += '</TH>' // close header cell

    // variables to hold constant settings
    var openCol = '';

    var closeCol = '</FONT></TD>';

    var weekDay = new Array(7)
    weekDay[0] = "星期天"
    weekDay[1] = "星期一"
    weekDay[2] = "星期二"
    weekDay[3] = "星期三"
    weekDay[4] = "星期四"
    weekDay[5] = "星期五"
    weekDay[6] = "星期六"


    // create first row of table to set column width and specify week day
    for (var dayNum = 0; dayNum < 7; ++dayNum) {
        getweeklink(weekdays[dayNum]);

        if (link_month.toString().length == "1") {
            alink_month = "0" + link_month;
        } else {
            alink_month = link_month;
        }
        if (link_day.toString().length == "1") {
            alink_day = "0" + link_day;
        } else {
            alink_day = link_day;
        }

        text += '<TR ALIGN="left" VALIGN="center"  style="font-size: 9pt">'

        if (document.all.adate.value == link_day) {
            openCol = '<TD bgcolor="#B8C3DE" WIDTH=' + colWidth + ' HEIGHT=' + dayCellHeight + ' align=center >';
        } else {
            openCol = '<TD bgcolor="#E7E7E7" WIDTH=' + colWidth + ' HEIGHT=' + dayCellHeight + ' align=center >';
        }

        openCol += '<FONT COLOR="' + dayColor + '">';

        text += openCol + '<a href="arrange.jsp?year=' + link_year + '&month=' + link_month + '&day=' + link_day + '&type=2&share=' + share + '">' + weekDay[dayNum] + "<br>" + weekdays[dayNum] + '</a>' + closeCol
        text += '<TD width=' + cellwidth + '><div id="d' + link_year + '-' + alink_month + '-' + alink_day + '">&nbsp;</div></TD>'
        text += '</TR>'
    }
    text += '</TABLE>'
    text += '</CENTER>'
    document.write(text)

}

function getweeklink(weekstr) {  //参数说明：weekstr：日期字符串
    str = weekstr;
    pos = str.indexOf("-");
    if (pos > 0) {
        link_year = str.substring(0, pos);
        str = str.substring(pos + 1);
    }

    pos = str.indexOf("-");
    if (pos > 0) {
        link_month = str.substring(0, pos);
        str = str.substring(pos + 1);
    }

    link_day = str;

}