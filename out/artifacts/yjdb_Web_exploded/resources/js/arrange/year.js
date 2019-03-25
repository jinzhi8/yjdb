//<!--
/*****************************************************************************
日期资料
*****************************************************************************/

var lunarInfo=new Array(
0x04bd8,0x04ae0,0x0a570,0x054d5,0x0d260,0x0d950,0x16554,0x056a0,0x09ad0,0x055d2,
0x04ae0,0x0a5b6,0x0a4d0,0x0d250,0x1d255,0x0b540,0x0d6a0,0x0ada2,0x095b0,0x14977,
0x04970,0x0a4b0,0x0b4b5,0x06a50,0x06d40,0x1ab54,0x02b60,0x09570,0x052f2,0x04970,
0x06566,0x0d4a0,0x0ea50,0x06e95,0x05ad0,0x02b60,0x186e3,0x092e0,0x1c8d7,0x0c950,
0x0d4a0,0x1d8a6,0x0b550,0x056a0,0x1a5b4,0x025d0,0x092d0,0x0d2b2,0x0a950,0x0b557,
0x06ca0,0x0b550,0x15355,0x04da0,0x0a5d0,0x14573,0x052d0,0x0a9a8,0x0e950,0x06aa0,
0x0aea6,0x0ab50,0x04b60,0x0aae4,0x0a570,0x05260,0x0f263,0x0d950,0x05b57,0x056a0,
0x096d0,0x04dd5,0x04ad0,0x0a4d0,0x0d4d4,0x0d250,0x0d558,0x0b540,0x0b5a0,0x195a6,
0x095b0,0x049b0,0x0a974,0x0a4b0,0x0b27a,0x06a50,0x06d40,0x0af46,0x0ab60,0x09570,
0x04af5,0x04970,0x064b0,0x074a3,0x0ea50,0x06b58,0x055c0,0x0ab60,0x096d5,0x092e0,
0x0c960,0x0d954,0x0d4a0,0x0da50,0x07552,0x056a0,0x0abb7,0x025d0,0x092d0,0x0cab5,
0x0a950,0x0b4a0,0x0baa4,0x0ad50,0x055d9,0x04ba0,0x0a5b0,0x15176,0x052b0,0x0a930,
0x07954,0x06aa0,0x0ad50,0x05b52,0x04b60,0x0a6e6,0x0a4e0,0x0d260,0x0ea65,0x0d530,
0x05aa0,0x076a3,0x096d0,0x04bd7,0x04ad0,0x0a4d0,0x1d0b6,0x0d250,0x0d520,0x0dd45,
0x0b5a0,0x056d0,0x055b2,0x049b0,0x0a577,0x0a4b0,0x0aa50,0x1b255,0x06d20,0x0ada0)

var solarMonth=new Array(31,28,31,30,31,30,31,31,30,31,30,31);
var Gan=new Array("甲","乙","丙","丁","戊","己","庚","辛","壬","癸");
var Zhi=new Array("子","丑","寅","卯","辰","巳","午","未","申","酉","戌","亥");
var Animals=new Array("鼠","牛","虎","兔","龙","蛇","马","羊","猴","鸡","狗","猪");
var solarTerm = new Array("小寒","大寒","立春","雨水","惊蛰","春分","清明","谷雨","立夏","小满","芒种","夏至","小暑","大暑","立秋","处暑","白露","秋分","寒露","霜降","立冬","小雪","大雪","冬至")
var sTermInfo = new Array(0,21208,42467,63836,85337,107014,128867,150921,173149,195551,218072,240693,263343,285989,308563,331033,353350,375494,397447,419210,440795,462224,483532,504758)
var nStr1 = new Array('日','一','二','三','四','五','六','七','八','九','十')
var nStr2 = new Array('初','十','廿','卅','　')
var monthName = new Array("JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC");
var monthNong = new Array("正","正","二","三","四","五","六","七","八","九","十","十一","十二");

//国历节日 *表示放假日
var sFtv = new Array(
"0101*元旦",
"0214 情人节",
"0308 妇女节",
"0312 植树节",
"0315 消费者权益日",
"0401 愚人节",
"0501 劳动节",
"0504 青年节",
"0512 护士节",
"0601 儿童节",
"0701 建党节",
"0801 建军节",
"0808 父亲节",
"0909 毛泽东逝世纪念",
"0910 教师节",
"0928 孔子诞辰",
"1001*国庆节",
"1006 老人节",
"1024 联合国日",
"1112 孙中山诞辰纪念",
"1220 澳门回归纪念",
"1225 圣诞节",
"1226 毛泽东诞辰纪念")


//农历节日 *表示放假日
var lFtv = new Array(
"0101*春节",
"0115 元宵节",
//"0217 小付生日",
"0505 端午节",
"0707 七夕情人节",
"0715 中元节",
"0815 中秋节",
"0909 重阳节",
"1208 腊八节",
"1224 小年",
"0100*除夕")

//某月的第几个星期几
var wFtv = new Array(
"0520 母亲节",
"0716 合作节",
"1144 感恩节")


/*****************************************************************************
                                      日期计算
*****************************************************************************/

//====================================== 传回农历 y年的总天数
function lYearDays(y) {
   var i, sum = 348
   for(i=0x8000; i>0x8; i>>=1) sum += (lunarInfo[y-1900] & i)? 1: 0
   return(sum+leapDays(y))
}

//====================================== 传回农历 y年闰月的天数
function leapDays(y) {
   if(leapMonth(y))  return((lunarInfo[y-1900] & 0x10000)? 30: 29)
   else return(0)
}

//====================================== 传回农历 y年闰哪个月 1-12 , 没闰传回 0
function leapMonth(y) {
   return(lunarInfo[y-1900] & 0xf)
}

//====================================== 传回农历 y年m月的总天数
function monthDays(y,m) {
   return( (lunarInfo[y-1900] & (0x10000>>m))? 30: 29 )
}

//====================================== 算出农历, 传入日期物件, 传回农历日期物件
//                                       该物件属性有 .year .month .day .isLeap .yearCyl .dayCyl .monCyl
function Lunar(objDate) {

   var i, leap=0, temp=0
   var baseDate = new Date(1900,0,31)
   var offset   = (objDate - baseDate)/86400000

   this.dayCyl = offset + 40
   this.monCyl = 14

   for(i=1900; i<2050 && offset>0; i++) {
      temp = lYearDays(i)
      offset -= temp
      this.monCyl += 12
   }

   if(offset<0) {
      offset += temp;
      i--;
      this.monCyl -= 12
   }

   this.year = i
   this.yearCyl = i-1864

   leap = leapMonth(i) //闰哪个月
   this.isLeap = false

   for(i=1; i<13 && offset>0; i++) {
      //闰月
      if(leap>0 && i==(leap+1) && this.isLeap==false)
         { --i; this.isLeap = true; temp = leapDays(this.year); }
      else
         { temp = monthDays(this.year, i); }

      //解除闰月
      if(this.isLeap==true && i==(leap+1)) this.isLeap = false

      offset -= temp
      if(this.isLeap == false) this.monCyl++
   }

   if(offset==0 && leap>0 && i==leap+1)
      if(this.isLeap)
         { this.isLeap = false; }
      else
         { this.isLeap = true; --i; --this.monCyl;}

   if(offset<0){ offset += temp; --i; --this.monCyl; }

   this.month = i
   this.day = offset + 1
}

//==============================传回国历 y年某m+1月的天数
function solarDays(y,m) {
   if(m==1)
      return(((y%4 == 0) && (y%100 != 0) || (y%400 == 0))? 29: 28)
   else
      return(solarMonth[m])
}
//============================== 传入 offset 传回干支, 0=甲子
function cyclical(num) {
   return(Gan[num%10]+Zhi[num%12])
}

//============================== 月历属性
function calElement(sYear,sMonth,sDay,week,lYear,lMonth,lDay,isLeap,cYear,cMonth,cDay) {

      this.isToday    = false;
      //国历
      this.sYear      = sYear;
      this.sMonth     = sMonth;
      this.sDay       = sDay;
      this.week       = week;
      //农历
      this.lYear      = lYear;
      this.lMonth     = lMonth;
      this.lDay       = lDay;
      this.isLeap     = isLeap;
      //干支
      this.cYear      = cYear;
      this.cMonth     = cMonth;
      this.cDay       = cDay;

      this.color      = '';

      this.lunarFestival = ''; //农历节日
      this.solarFestival = ''; //国历节日
      this.solarTerms    = ''; //节气

}

//===== 某年的第n个节气为几日(从0小寒起算)
function sTerm(y,n) {
   var offDate = new Date( ( 31556925974.7*(y-1900) + sTermInfo[n]*60000  ) + Date.UTC(1900,0,6,2,5) )
   return(offDate.getUTCDate())
}

//============================== 传回月历物件 (y年,m+1月)
function calendar(y,m) {

   var sDObj, lDObj, lY, lM, lD=1, lL, lX=0, tmp1, tmp2
   var lDPOS = new Array(3)
   var n = 0
   var firstLM = 0

   sDObj = new Date(y,m,1)            //当月一日日期

   this.length    = solarDays(y,m)    //国历当月天数
   this.firstWeek = sDObj.getDay()    //国历当月1日星期几


   for(var i=0;i<this.length;i++) {

      if(lD>lX) {
         sDObj = new Date(y,m,i+1)    //当月一日日期
         lDObj = new Lunar(sDObj)     //农历
         lY    = lDObj.year           //农历年
         lM    = lDObj.month          //农历月
         lD    = lDObj.day            //农历日
         lL    = lDObj.isLeap         //农历是否闰月
         lX    = lL? leapDays(lY): monthDays(lY,lM) //农历当月最後一天

         if(n==0) firstLM = lM
         lDPOS[n++] = i-lD+1
      }

      //sYear,sMonth,sDay,week,
      //lYear,lMonth,lDay,isLeap,
      //cYear,cMonth,cDay
      this[i] = new calElement(y, m+1, i+1, nStr1[(i+this.firstWeek)%7],
                               lY, lM, lD++, lL,
                               cyclical(lDObj.yearCyl) ,cyclical(lDObj.monCyl), cyclical(lDObj.dayCyl++) )


      if((i+this.firstWeek)%7==0)   this[i].color = 'red'  //周日颜色
      if((i+this.firstWeek)%7==6) this[i].color = 'red' //周休二日颜色 
   }

   //节气
   tmp1=sTerm(y,m*2  )-1
   tmp2=sTerm(y,m*2+1)-1
   this[tmp1].solarTerms = solarTerm[m*2]
   this[tmp2].solarTerms = solarTerm[m*2+1]
   if(m==3) this[tmp1].color = 'red' //清明颜色

   //国历节日
   for(i in sFtv)
      if(sFtv[i].match(/^(\d{2})(\d{2})([\s\*])(.+)$/))
         if(Number(RegExp.$1)==(m+1)) {
            this[Number(RegExp.$2)-1].solarFestival += RegExp.$4 + ' '
            if(RegExp.$3=='*') this[Number(RegExp.$2)-1].color = 'red'
         }

   //月周节日
   for(i in wFtv)
      if(wFtv[i].match(/^(\d{2})(\d)(\d)([\s\*])(.+)$/))
         if(Number(RegExp.$1)==(m+1)) {
            tmp1=Number(RegExp.$2)
            tmp2=Number(RegExp.$3)
            this[((this.firstWeek>tmp2)?7:0) + 7*(tmp1-1) + tmp2 - this.firstWeek].solarFestival += RegExp.$5 + ' '
         }

   //农历节日
   for(i in lFtv)
      if(lFtv[i].match(/^(\d{2})(.{2})([\s\*])(.+)$/)) {
         tmp1=Number(RegExp.$1)-firstLM
         if(tmp1==-11) tmp1=1
         if(tmp1 >=0 && tmp1<n) {
            tmp2 = lDPOS[tmp1] + Number(RegExp.$2) -1
            if( tmp2 >= 0 && tmp2<this.length) {
               this[tmp2].lunarFestival += RegExp.$4 + ' '
               if(RegExp.$3=='*') this[tmp2].color = 'red'
            }
         }
      }

   //黑色星期五
   if((this.firstWeek+12)%7==5)
      this[12].solarFestival += '黑色星期五 '

   //今日
   if(y==tY && m==tM) this[tD-1].isToday = true;

}

//====================== 中文日期
function cDay(d){
   var s;

   switch (d) {
      case 10:
         s = '初十'; break;
      case 20:
         s = '二十'; break;
         break;
      case 30:
         s = '三十'; break;
         break;
      default :
         s = nStr2[Math.floor(d/10)];
         s += nStr1[d%10];
   }
   return(s);
}

function cMon(d){
var s;
s=monthNong[d]+"月"
return(s)
}

//该物件属性有 .year .month .day .isLeap .yearCyl .dayCyl .monCyl
/*
var hello=new Date()
var str11=new Lunar(hello)
yy=2002
mm=3
cld = new calendar(yy,mm);
alert (cld.length)
for (i=0;i<cld.length;i++)
{
alert(cld[i].color)
alert(cld[i].solarFestival)
alert(cld[i].lunarFestival)
alert(cld[i].solarTerms)
alert(cld[i].isToday)
alert('国历日期')
alert(cld[i].sYear)
alert(cld[i].sMonth)
alert(cld[i].sDay)
alert(cld[i].week)
alert('农历日期')
alert(cld[i].lYear)
alert(cMon(cld[i].lMonth))
alert(cDay(cld[i].lDay))
alert('干支')
alert(cld[i].cYear)
alert(cld[i].cMonth)
alert(cld[i].cDay)
break;
}
*/


//cld = new calendar(SY,SM);
//alert(str11.year)
//alert(str11.month)
//alert(str11.day)
//alert(str11.isLeap)
//alert(str11.yearCyl)
//alert(str11.monCyl)
//alert(str11.dayCyl)
//cld = new calendar(year,month-1);

var Today = new Date();
var tY = Today.getFullYear();
var tM = Today.getMonth();
var tD = Today.getDate();
//////////////////////////////////////////////////////////////////////////////

var width = "130";
var offsetx = 2;
var offsety = 16;

var x = 0;
var y = 0;
var snow = 0;
var sw = 0;
var cnt = 0;

var dStyle;


//document.onmousemove = mEvn;
//
    </script>
    //********************************************************************农历计算以及节日节气纪念日
    //********************************************************************农历计算以及节日节气纪念日
    //********************************************************************农历计算以及节日节气纪念日

    //getWeekBE(2001,12,1)
    setCal()
    var lastyear;
    var lastmonth;
    var nextyear;
    var nextmonth;

    //闰年计算有问题？？？
    function leapYear(year) {
            if ((year % 400 == 0)||((year % 100 != 0) && (year % 4 == 0 )))
        //if (year % 4 == 0)
            {
            return true
            }
    return false
    }

    function getDays(month, year) {
            var ar = new Array(13)
            ar[0] = 31
            ar[1] = 31
            ar[2] = (leapYear(year)) ? 29 : 28
            ar[3] = 31
            ar[4] = 30
            ar[5] = 31
            ar[6] = 30
            ar[7] = 31
            ar[8] = 31
            ar[9] = 30
            ar[10] = 31
            ar[11] = 30
            ar[12] = 31
            return ar[month]
            }


    function getMonthName(month) {
            var ar = new Array(13)
            ar[0] = "月"
            ar[1] = "1月"
            ar[2] = "2月"
            ar[3] = "3月"
            ar[4] = "4月"
            ar[5] = "5月"
            ar[6] = "6月"
            ar[7] = "7月"
            ar[8] = "8月"
            ar[9] = "9月"
            ar[10] = "10月"
            ar[11] = "11月"
            ar[12] = "12月"
            return ar[month]
            }
    function getcnMonthName(month) {
            var ar = new Array(13)
            ar[0] = "月"
            ar[1] = "一月"
            ar[2] = "二月"
            ar[3] = "三月"
            ar[4] = "四月"
            ar[5] = "五月"
            ar[6] = "六月"
            ar[7] = "七月"
            ar[8] = "八月"
            ar[9] = "九月"
            ar[10] = "十月"
            ar[11] = "十一月"
            ar[12] = "十二月"
            return ar[month]
            }


    function setCal() {
            var monthName = getMonthName(month) // 获取显示月份
            var firstDayInstance = new Date(year, month-1, 1)
            var firstDay = firstDayInstance.getDay()// 获取星期顺序号，0-星期六，6-星期天
            firstDayInstance = null
            if (month==1)
            {
            lastyear=year-1
            lastmonth=12
            nextyear=year
            nextmonth=month+1
            }
    else if(month==12)
    {
            lastyear = year
            lastmonth=month-1
            nextyear=year+1
            nextmonth=1
            }
    else
    {
            lastyear = year
            lastmonth=month - 1
            nextyear=year
            nextmonth=month+1
            }
    var days = getDays(month, year) // 获取要显示的月份的总天数
    //drawDayCal(firstDay + 1, days, monthName, year)

    if (type==1) drawCal(firstDay + 1, days, monthName, year)
    if (type==3) printYearCal()
    }

    function drawDayCal(firstDay, lastDate, monthName, year) {
            var headerHeight = 34
            var border = 2
            var cellspacing = 2
            var headerColor = "midnightblue"
            var headerSize = "-1"
            var colWidth = 92
            var dayCellHeight = 18
            var dayColor = "darkblue"
            var cellHeight = 60
            var todayColor = "red"
            var timeColor = "purple"
            var monthnum
            var text = ""

        //get month

            switch(monthName)
            {
            case "一月":
            monthnum=1;
            break;
            case "二月":
            monthnum=2;
            break;
            case "三月":
            monthnum=3;
            break;
            case "四月":
            monthnum=4;
            break;
            case "五月":
            monthnum=5;
            break;
            case "六月":
            monthnum=6;
            break;
            case "七月":
            monthnum=7;
            break;
            case "八月":
            monthnum=8;
            break;
            case "九月":
            monthnum=9;
            break;
            case "十月":
            monthnum=10;
            break;
            case "十一月":
            monthnum=11;
            break;
            case "十二月":
            monthnum=12;
            break;
            }

    text += '
        <CENTER>'
        text += '
            <table width=220 border=0 cellspacing=1 cellpadding=0>'
            text += '
                <TH bgcolor="#E4E4E4" COLSPAN=7 HEIGHT=16>'+monthName+'
                    </TH>'

                    var openCol = '
                        <TD HEIGHT=16>'
                        var closeCol = '</TD>'

                        // create array of abbreviated day names
                        var weekDay = new Array(7)
                        weekDay[0] = "日"
	weekDay[1] = "一"
	weekDay[2] = "二"
	weekDay[3] = "三"
	weekDay[4] = "四"
	weekDay[5] = "五"
	weekDay[6] = "六"
	
	// create first row of table to set column width and specify week day
	text += '<TR ALIGN="center" >'
	for (var dayNum = 0; dayNum < 7; ++dayNum) {
		text += openCol + weekDay[dayNum] + closeCol 
	}
	text += '</TR>'
	
	// declaration and initialization of two variables to help with tables
	var digit = 1

	cld = new calendar(year,monthnum-1);
	var curCell = 1
	for (var row = 1; row <= Math.ceil((lastDate + firstDay - 1) / 7); ++row) {    //row表示几周
		text += '<TR ALIGN="center" VALIGN="middle">'
		for (var col = 1; col <= 7; ++col) {

			if (digit > lastDate)
			{
                            for(var ll=0;ll<=7 - col;ll++)
			     {
                                text += '<TD>　</TD>';
				curCell++
                             }
			     break
                        }
			else if (curCell < firstDay) 
			{
				text += '<TD>　</TD>';
				curCell++
			} 
			else {
					//3
				//	if (digit>31)
			//	{
					//digit=digit-1
				//}
					showcolor=cld[digit-1].color//当日颜色
											//日期下显示的内容
					solarFestival=cld[digit-1].solarFestival;//国历节日
					lunarFestival=cld[digit-1].lunarFestival;//阴历节日
					solarTerms=cld[digit-1].solarTerms;      //阴历节气
					lDay=cDay(cld[digit-1].lDay);            //阴历日期-天
					lMonth=cMon(cld[digit-1].lMonth)
					//***************************显示显示次序/start
					/*
					if (solarFestival!="")
					{kingfort="
                            <font color=blue>
                                <b>"+solarFestival+"</b>
                            </font>
                        "
                        }
                        else if (lunarFestival!="")
                        {kingfort = "<font color=red><b>" + lunarFestival + "</b></font>"
                                }
                        else if (solarTerms!="")
                        {kingfort = "<font color=olive><b>" + solarTerms + "</b></font>"
                                }
                        else if (lDay=="初一")
                        {kingfort = (cld[digit - 1].isLeap ? '闰' : '') + lMonth
                                }
                        else
                        {
                                kingfort = lDay
                                }
                        */
                        //***************************显示显示次序/end
                        //3
                        if (solarTerms!="")
                        {kingfort = "<font color=olive><b>" + solarTerms + "</b></font>"
                                }
                        else if (lDay=="初一")
                        {kingfort = "<font size=1>" + (cld[digit - 1].isLeap ? '闰' : '') + lMonth + "</font>"
                                }
                        else
                        {
                                kingfort = lDay
                                }
                        text += '
                            <TD HEIGHT=16>
                                <a href=arrange.jsp?type=3&year='+year+'&month='+monthnum+'&day='+digit+'&share='+share+'>' + '
                                    <font color='+showcolor+'>'+digit+'</font>
                                    <br>' +kingfort+'</a>
                                </TD>
                            '
                            digit++
                            }
                            }
                            text += '</TR>
                        '
                        }
                        text += '</TABLE>
                    '
                    text += '</CENTER>
                '
                document.write(text)
                }

                //右上的月历导航
                function printYearMon()
                {
                        var tables='<table cellspacing=0 bordercolordark=#ffffff cellpadding=2 width=95% bordercolorlight=#999999 border=1 align="center" height="109">'
                        var tds=''
                        var moncal='<tr align="right" valign="top">'
                        tables+='<tr valign="middle" align="center" bgcolor="#ebebeb">'
                        tables+='<td colspan="5" height="27">'
                        tables+='<a href=arrange.jsp?type=3&year='+ (year-1) +'&share='+share+'>'
                        tables+='<img src=../resources/images/arrange/last.gif width=6 height=9 border=0></a>&nbsp;&nbsp;&nbsp;'+year+'年&nbsp;&nbsp;&nbsp;'
                        tables+='<a href=arrange.jsp?type=3&year='+(year+1)+'&share='+share+'><img src=../resources/images/arrange/next.gif width=6 height=9 border=0></a>'
                        tables+='</td></tr>'

                        for (var i=1;i<=12;i++)
                        {
                        if(i%4==1)
                        {
                        if (tds.length>0) tds+=moncal
                        else tds=moncal
                        }
                tds+='
                    <td height="23" width="48">
                        <a href=arrange.jsp?year='+year+'&month='+i+'&share='+share+'>'+getcnMonthName(i)+"</a>
                    </td>
                "
                }
                tables+=tds+'</tr>
            </table>
        '
        document.write(tables)
        }

        function printDayTodo()
        {
                var ls='<a href="javascript:;" onclick=javascript:window.open("arrangeform.jsp?year='+year+'&month='+month+'&day='+day+'&bgh='
                var showStr = '您好，您';
                if (share!='0')
                {
                showStr='';
                }
        tables=showStr+'
            <font color=#FF0000>'+year+'年'+month+'月'+day+'日</font>
        '+'的安排如下：
            <table cellspacing=0 bordercolordark=#ffffff cellpadding=2 width=99% bordercolorlight=#999999 border=1 align="center">'
            tables+='
                <tr bgcolor=#dddddd height=10px>
                    <td align=middle width=42>时段
                        </td>
                            <td align=middle width="182">主题</td>
                        </tr>
                    '

                    for(var i=7;i
                        <=23;i++)
                        {
                                if (i<10)
                                {
                                tables+='<tr bgcolor=#dddddd height=10px><td align=middle width=42>'

                                tables+=ls+i+'","","scrollbars=no,titlebar=yes,toolbar=no,menubar=no,resizebar=yes,width=470,height=340,top=200,left=200");return false;>0'+i+':00</a></td><td width="182" align=left valign=middle><div id="t0'+i+'">&nbsp;</div></td></tr>'
                                }
                        else
                        {
                                tables += '<tr bgcolor=#dddddd height=10px><td align=center width=42>'
                                tables+=ls+i+'","","scrollbars=no,titlebar=yes,toolbar=no,menubar=no,resizebar=yes,width=470,height=340,top=200,left=200");>'+i+':00</a></td><td width="182" align=left valign=middle><div id="t'+i+'">&nbsp;</div></td></tr>'
                                }
                        }
                        //tables+='
                            <tr bgcolor=#dddddd height=10px>
                                <td align=middle width=42>'+ls+'>其它
                                    </a></td>
                                    <td width="182">
                                        <div id=tt>&nbsp;</div>
                                    </td>
                                </tr>
                            '
                            tables+="</table>
                        "
                        document.write(tables)
                        }

                        function getWeekBE(year,month,day)
                        {
                                var flag=0;
                                var i;
                                var otheryear;
                                var othermonth;
                                var otherday;
                                var wkday= new Array(7);
                                var curDayInstance = new Date(year, month -1 , day);
                                var curDay = curDayInstance.getDay();

                                for ( i=0;i<curDay;i++ )
                                {
                                if (day - (curDay-i) <=0 )
                                {
                                if (month == 1)
                                {
                                otheryear=year - 1;
                                othermonth=12;
                                }
                        else
                        {
                                otheryear = year;
                                othermonth=month-1;
                                }
                        otherday=getDays(othermonth,otheryear) - (curDay - i) + 1;
                        }
                        else
                        {
                                otheryear = year;
                                othermonth=month;
                                otherday=day - (curDay-i);
                                }
                        wkday[i]=otheryear+"年"+othermonth+"月"+otherday+"日";
                        }
                        otherday=0;
                        for (i=curDay;i
                            <=6;i++)
                            {

                                    if ((day + (i-curDay)) > getDays(month,year))
                                    {

                                    if ( month == 12 )
                                    {
                                    otheryear=year+1;
                                    othermonth=1;

                                    }
                            else
                            {
                                    otheryear = year;
                                    othermonth=month+1;

                                    }
                            if (flag==0)
                            {
                                    otherday = 1;
                                    flag=1;
                                    }
                            else
                            otherday++;
                            }
                            else
                            {
                                    otheryear = year;
                                    othermonth=month;
                                    otherday=day+i-curDay;
                                    }
                            wkday[i]=otheryear+"年"+othermonth+"月"+otherday+"日";
		//alert(otheryear+"-"+othermonth+"-"+otherday)
                            }
                            document.write(wkday[0]+" - "+wkday[6]+"
                                <br>")
                                for (i=0;i
                                    <7;i++)
                                    {

                                            document.write(wkday[i] + "<br>")

                                            }
                                    }
                                    function printYearCal()
                                    {
                                            document.write('<table cellspacing=0 bordercolordark=#ffffff cellpadding=2 width=99% bordercolorlight=#999999 border=1 align="center">')
                                            document.write('<tr valign="middle" align="center" bgcolor="#ebebeb"><td colspan="3" height="37"><a href=arrange.jsp?type=3&year='+(year-1)+'&share='+share+'><img src="../resources/images/arrange/last.gif" width="6" height="9" border=0></a>&nbsp;&nbsp;&nbsp;'+year+'年&nbsp;&nbsp;&nbsp;<a href=arrange.jsp?type=3&year='+(year+1)+'&share='+share+'><img src="../resources/images/arrange/next.gif" width="6" height="9" border=0></a>')
                                            document.write("</td></tr>")
                                        //画出每个月的表格
                                            for (row=1;row<=6;row++)
                                            {

                                            var firstDayInstance = new Date(year, (row-1)*2, 1)
                                            var firstDay = firstDayInstance.getDay()// 获取星期顺序号，0-星期六，6-星期天
                                            firstDayInstance = null
                                            document.write("<tr><td width=240 height=209>")
                                            drawDayCal(firstDay+1,getDays((row-1)*2+1,year),getcnMonthName((row-1)*2+1),year);
                                            document.write("</td><td width=240 height=209>")
                                            var firstDayInstance = new Date(year, (row-1)*2+1, 1)
                                            var firstDay = firstDayInstance.getDay()// 获取星期顺序号，0-星期六，6-星期天
                                            firstDayInstance = null
                                            drawDayCal(firstDay+1,getDays((row-1)*2+2,year),getcnMonthName((row-1)*2+2),year)
                                            document.write("</td></tr>")

                                            }
                                    document.write("
                                        </table>")

                                        }
                                        function drawYearDayCal(firstDay, lastDate, monthName, year) {
                                                var headerHeight = 34
                                                var border = 2
                                                var cellspacing = 2
                                                var headerColor = "midnightblue"
                                                var headerSize = "-1"
                                                var colWidth = 92
                                                var dayCellHeight = 18
                                                var dayColor = "darkblue"
                                                var cellHeight = 60
                                                var todayColor = "red"
                                                var timeColor = "purple"

                                                var text = ""
                                                text += '<CENTER>'
                                                text += '<table width=190 border=0 cellspacing=1 cellpadding=0>'
                                                text += '<TH bgcolor="#E4E4E4" COLSPAN=7 HEIGHT=16>'
                                                text += year+"年"+monthName
                                                text += '</TH>'

                                                var openCol = '<TD HEIGHT=16>'
                                                var closeCol = '</TD>'

                                            // create array of abbreviated day names
                                                var weekDay = new Array(7)
                                                weekDay[0] = "日"
                                                weekDay[1] = "一"
                                                weekDay[2] = "二"
                                                weekDay[3] = "三"
                                                weekDay[4] = "四"
                                                weekDay[5] = "五"
                                                weekDay[6] = "六"

                                            // create first row of table to set column width and specify week day
                                                text += '<TR ALIGN="center" >'
                                                for (var dayNum = 0; dayNum < 7; ++dayNum) {
                                                text += openCol + weekDay[dayNum] + closeCol
                                                }
                                        text += '</TR>
                                    '

                                    // declaration and initialization of two variables to help with tables
                                    var digit = 1
                                    var curCell = 1

                                    for (var row = 1; row
                                        <= Math.ceil((lastDate + firstDay - 1) / 7); ++row) {
                                                text += '<TR ALIGN="center" VALIGN="middle">'
                                                for (var col = 1; col <= 7; ++col) {
                                                if (digit > lastDate)
                                                {
                                                for(var ll=0;ll<=7 - col;ll++)
                                                {
                                                text += '<TD>　</TD>';
                                                curCell++
                                                }
                                        break
                                        }
                                        else if (curCell
                                            < firstDay)
                                            {
                                                    text += '<TD>　</TD>';
                                                    curCell++
                                                    }
                                            else {
                                                    text += '<TD HEIGHT=16><a href=arrange.jsp?type=3&year=>' + year + digit + '&share=' + share + '</a></TD>'
                                                    digit++
                                                    }
                                            }
                                            text += '
                                                </TR>'
                                                }
                                                text += '</TABLE>
                                            '
                                            text += '</CENTER>
                                        '
                                        document.write(text)
                                        }
