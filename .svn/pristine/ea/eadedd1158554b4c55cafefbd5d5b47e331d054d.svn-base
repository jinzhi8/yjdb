//生成相关的日程安排信息

function explortdata() {

    var zdays = document.all['zdays'].value;//当前月的总天数

    var zmonth = document.all['zmonth'].value;//当前月
    var zyear = document.all['zyear'].value;//当前年份

    var a1year = document.all["ayear"].value;
    var a1month = document.all["amonth"].value;

    if (a1month.toString().length == 1) {
        a1month = "0" + a1month;
    }

    var a1date = document.all["adate"].value;
    if (a1date.toString().length == 1) {
        a1date = "0" + a1date;
    }
    var aid = "dss" + a1year + "-" + a1month + "-" + a1date;


    if (zmonth.toString().length == 1) {
        zmonth = "0" + zmonth;
    }

    //月历
    if (document.all['atype'].value == "1") {
        for (var i = 1; i <= zdays; i++) {
            if (i < 10) var ii = "0" + i; else var ii = i;

            var objs = document.all["dss" + zyear + "-" + zmonth + "-" + ii];
            var str = "";
            var str1 = "";
            if (objs != null) {
                if (objs.length) {
                    for (var j = 0; j < objs.length; j++)

                    {
                        if (objs[j].id == aid) {

                            str1 = "<tr><td><a href='javascript:;' onclick=javascript:window.open('showarrange.jsp?docid=" + objs[j].name + "','','scrollbars=no,titlebar=yes,toolbar=no,menubar=no,resizebar=yes,width=470,height=340,top=200,left=200');>" + objs[j].value + "</a><br></td></tr>";

                            if (document.all["t" + objs[j].beg].innerHTML == "&nbsp;") {
                                document.all["t" + objs[j].beg].innerHTML = str1;
                            } else {
                                document.all["t" + objs[j].beg].innerHTML = document.all["t" + objs[j].beg].innerHTML + str1;
                            }
                        }
                        if (j < 3) {
                            if (objs[j].nam == "%%") {
                                str = str + "<tr><td title=\'" + objs[j].value + "\'>" + "<a href=javascript:; onclick=javascript:window.open('showarrange.jsp?docid=" + objs[j].name + "','','scrollbars=no,titlebar=yes,toolbar=no,menubar=no,resizebar=yes,width=470,height=340,top=200,left=200');>" + objs[j].beg + ":" + objs[j].bgm + "[" + objs[j].typ + "]" + "</a></td></tr>";
                            } else {
                                str = str + "<tr><td title=\'" + objs[j].value + "\'>" + "<a href=javascript:; onclick=javascript:window.open('showarrange.jsp?docid=" + objs[j].name + "','','scrollbars=no,titlebar=yes,toolbar=no,menubar=no,resizebar=yes,width=470,height=340,top=200,left=200');>" + objs[j].nam + objs[j].beg + ":" + objs[j].bgm + "</a></td></tr>";
                            }
                        }
                    }

                    str = "<table>" + str + "</table>";
                    if (j >= 3)document.all["d" + zyear + "-" + zmonth + "-" + ii].innerHTML = document.all["d" + zyear + "-" + zmonth + "-" + ii].innerHTML + str + "<img border=0 src=/images/next.gif width=6 height=9>"; else document.all["d" + zyear + "-" + zmonth + "-" + ii].innerHTML = document.all["d" + zyear + "-" + zmonth + "-" + ii].innerHTML + str;
                } else {
                    if (objs.id == aid) {
                        str1 = "<tr><td><a <a href=javascript:; onclick=javascript:window.open('showarrange.jsp?docid=" + objs.name + "','','scrollbars=no,titlebar=yes,toolbar=no,menubar=no,resizebar=yes,width=470,height=340,top=200,left=200');>" + objs.value + "</a><br></td></tr>";
                        if (document.all["t" + objs.beg].innerHTML == "&nbsp;") {
                            document.all["t" + objs.beg].innerHTML = str1;
                        } else {
                            document.all["t" + objs.beg].innerHTML = document.all["t" + objs.beg].innerHTML + str1;
                        }
                    }

                    if (objs.nam == "%%") {
                        str = str + "<tr><td title=\'" + objs.value + "\'>" + "<a href=javascript:; onclick=javascript:window.open('showarrange.jsp?docid=" + objs.name + "','','scrollbars=no,titlebar=yes,toolbar=no,menubar=no,resizebar=yes,width=470,height=340,top=200,left=200');>" + objs.beg + ":" + objs.bgm + "[" + objs.typ + "]" + "</a></td></tr>";
                    } else {
                        str = str + "<tr><td title=\'" + objs.value + "\'>" + "<a href=javascript:; onclick=javascript:window.open('showarrange.jsp?docid=" + objs.name + "','','scrollbars=no,titlebar=yes,toolbar=no,menubar=no,resizebar=yes,width=470,height=340,top=200,left=200');>" + objs.nam + objs.beg + ":" + objs.bgm + "</a></td></tr>";
                    }
                    str = "<table>" + str + "</table>"
                    document.all["d" + zyear + "-" + zmonth + "-" + ii].innerHTML = document.all["d" + zyear + "-" + zmonth + "-" + ii].innerHTML + "<br>" + str;

                }
            }
        }
    }


    //周历
    if (document.all['atype'].value == "2") {
        var bgtime0 = document.all['bgtime'].value;
        var endtime0 = document.all['endtime'].value;

        //解析一周的开始时间
        var i = bgtime0.indexOf("-");
        var j = bgtime0.lastIndexOf("-");
        var mystr1 = bgtime0.substr(0, i);
        if (j - i == 2) {
            var mystr2 = bgtime0.substr(i + 1, 1);
            mystr2 = "0" + mystr2;
        } else {
            var mystr2 = bgtime0.substr(i + 1, 2);
        }
        var mystr3 = bgtime0.substr(j + 1, bgtime0.length - j);
        if (mystr3.length == "1") {
            mystr3 = "0" + mystr3;
        }
        var bgtime = "dss" + mystr1 + "-" + mystr2 + "-" + mystr3;

        //解析一周的结束时间
        var i1 = endtime0.indexOf("-");
        var j1 = endtime0.lastIndexOf("-");
        var mystr4 = endtime0.substr(0, i1);
        if (j1 - i1 == 2) {
            var mystr5 = endtime0.substr(i1 + 1, 1);
            mystr5 = "0" + mystr5;
        } else {
            var mystr5 = endtime0.substr(i1 + 1, 2);
        }
        var mystr6 = endtime0.substr(j1 + 1, endtime0.length - j1);

        if (mystr6.length == "1") {
            mystr6 = "0" + mystr6;
        }
        var endtime = "dss" + mystr4 + "-" + mystr5 + "-" + mystr6;

        var weeks = document.all.tags("input");
        for (r = 0; r < weeks.length; r++) {

            if (weeks[r].id.length == 13) {
                if ((weeks[r].id <= endtime) && (weeks[r].id >= bgtime)) {
                    var oldid = weeks[r].id;
                    var newid = oldid.replace("dss", "d");

                    var str3 = "";
                    var str4 = "";
                    if (weeks[r].nam == "%%") {
                        str3 = "<a href='javaScript:;' title=\'" + weeks[r].value + "\' onclick=javascript:window.open('showarrange.jsp?docid=" + weeks[r].name + "','日程安排','scrollbars=no,titlebar=yes,toolbar=no,menubar=no,resizebar=yes,width=470,height=340,top=200,left=200');>" + weeks[r].beg + ":" + weeks[r].bgm + "[" + weeks[r].typ + "]" + "</a>&nbsp;";
                    } else {
                        str3 = "<a href='javaScript:;' title=\'" + weeks[r].value + "\' onclick=javascript:window.open('showarrange.jsp?docid=" + weeks[r].name + "','日程安排','scrollbars=no,titlebar=yes,toolbar=no,menubar=no,resizebar=yes,width=470,height=340,top=200,left=200');>" + weeks[r].nam + weeks[r].beg + ":" + weeks[r].bgm + "</a>&nbsp;";
                    }
                    if (document.all[newid] != null) {
                        document.all[newid].innerHTML = document.all[newid].innerHTML + str3;
                    }
                }
                if (aid == weeks[r].id) {
                    str4 = "<tr><td><a href=showarrange.jsp?docid=" + weeks[r].name + ">" + weeks[r].value + "</a><br></td></tr>";
                    document.all["t" + weeks[r].beg].innerHTML = document.all["t" + weeks[r].beg].innerHTML + str4;
                }
            }

        }

    }


    //年历

    if (document.all['atype'].value == "3") {
        var yobject = document.all.tags("input");
        for (q = 1; q < yobject.length; q++) {
            var str8 = "";
            if (aid == yobject[q].id) {
                str8 = "<tr><td><a href=showarrange.jsp?docid=" + yobject[q].name + ">" + yobject[q].value + "</a><br></td></tr>";
                var newid = "t" + yobject[q].beg;
                document.all[newid].innerHTML = document.all[newid].innerHTML + str8;
            }

        }
    }
}

