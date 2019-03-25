function explortdata() {

    var zdays = document.all['zdays'].value;//当前月的总天数
    var zmonth = document.all['zmonth'].value;//当前月
    var zyear = document.all['zyear'].value;//当前年份
    //alert(zdays);
    var a1year = document.all["ayear"].value;
    var a1month = document.all["amonth"].value;
    var auser = document.all['auser'].value//当前用户

    if (a1month.toString().length == 1) {
        a1month = "0" + a1month;
    }

    var a1date = document.all["adate"].value;
    if (a1date.toString().length == 1) {
        a1date = "0" + a1date;
    }
    var aid = "dss" + a1year + "-" + a1month + "-" + a1date;

    //月历

    var objs = document.all[aid];
    var str = "";
    var str1 = "";
    var curhour = "";
    var curmin = "";
    var i = 0;
    if (objs != null) {
        if (objs.length) {
            for (var j = 0; (j < objs.length && i <= 4); j++) {

                if (objs[j].id == aid) {
                    if (i < 4) {
                        curhour = objs[j].beg;
                        curmin = objs[j].bgm;
                        if (curhour.length == 1) {
                            curhour = "0" + curhour;
                        }

                        str = "<tr><td><a href=\"javascript:void(0);\" onclick=\"javascript:window.open('../arrange/showarrange.jsp?docid=" + objs[j].name + "','','scrollbars=no,titlebar=yes,toolbar=no,menubar=no,resizebar=yes,width=470,height=340,top=200,left=200');\">" + curhour + ":" + curmin + "</a><br></td></tr>";
                        str1 = "<tr><td><a href=\"javascript:void(0);\" onclick=\"javascript:window.open('../arrange/showarrange.jsp?docid=" + objs[j].name + "','','scrollbars=no,titlebar=yes,toolbar=no,menubar=no,resizebar=yes,width=470,height=340,top=200,left=200');\">" + objs[j].value + "</a><br></td></tr>";

                        document.all["t" + i].innerHTML = str;
                        document.all["it" + i].innerHTML = str1;
                    } else if (i = 4) {
                        str = "&yea=" + a1year + "&mon=" + a1month + "&dat=" + a1date;
                        str1 = "<tr><td><a target='_blank' href='arrange.jsp?year=" + a1year + "&month=" + a1month + "&day=" + a1date + "&type=1'>更多>>></a><br></td></tr>";
                        document.all["it" + i].innerHTML = str1;

                    }
                    i++;
                }
            }
        } else {
            curhour = objs.beg;
            curmin = objs.bgm;
            if (curhour.length == 1) {
                curhour = "0" + curhour;
            }

            if (objs.id == aid) {
                str = "<tr><td><a href=\"javascript:void(0);\" onclick=\"javascript:window.open('../arrange/showarrange.jsp?docid=" + objs.name + "','','scrollbars=no,titlebar=yes,toolbar=no,menubar=no,resizebar=yes,width=470,height=340,top=200,left=200');\">" + curhour + ":" + curmin + "</a><br></td></tr>";
                str1 = "<tr><td><a href=\"javascript:void(0);\" onclick=\"javascript:window.open('../arrange/showarrange.jsp?docid=" + objs.name + "','','scrollbars=no,titlebar=yes,toolbar=no,menubar=no,resizebar=yes,width=470,height=340,top=200,left=200');\">" + objs.value + "</a><br></td></tr>";
                document.all["t0"].innerHTML = str;
                document.all["it0"].innerHTML = str1;
            }

        }
    }
}
