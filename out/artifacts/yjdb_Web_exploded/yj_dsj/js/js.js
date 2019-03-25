var getDataFn = {};
getDataFn.dbtj = function () {
    $.ajax({
        async: false,
        type: "post",
        url: "../SyService",
        data: {
            fname: "getTj"
        },
        dataType: "json",
        success: function (data) {
            

        }
    });
}
//超期回复
getDataFn.getFxz = function (title) {
    $.ajax({
        async: false,
        type: "post",
        url: "../SyService",
        data: {
            fname: "getFxz",
            title: title,
        },
        dataType: "json",
        success: function (data) {
            var html = '';
            for (var i = 0; i < data.length; i++) {
            	html += '<div class="dataCenter-table-list"><div>' + data[i].rownum + '</div>';
                html += '<p>' + data[i].ownername + '</p>';
                html += '<p><span>超期回复:<em>' + data[i].cshf + '</em></span><span>超期未办结:<em>' + data[i].cswbj + '</em></span><span>超期办结:<em>' + data[i].csbj + '</em></span></p></div></div>';
            }
            $('#xldsjtj').html(html);
        }
    });
}
//超期回复
getDataFn.getJzly = function () {
    $.ajax({
        async: false,
        type: "post",
        url: "../SyService",
        data: {
            fname: "getJzly"
        },
        dataType: "json",
        success: function (data) {
        	echartsFn.bqCount(data.show);
        }
    });
}
//个分组后三名
getDataFn.getPmtj = function (time) {
    $.ajax({
        async: false,
        type: "post",
        url: "../SyService",
        data: {
            fname: "getPmtj",
            time: time
        },
        dataType: "json",
        success: function (data) {
            var html = '';
            for (var i = 0; i < data.length; i++) {
            	html += '<div class="dataCenter-table-list">';
                html += '<p>' + data[i].name + '</p>';
                html += '<p><span class="dataCenter-table-list-span" title='+data[i].dyw+'>' + data[i].dyw + '<em>' + data[i].dywzf+ '</em></span><span class="dataCenter-table-list-span" title='+data[i].dew+'>' + data[i].dew + '<em>' + data[i].dewzf+ '</em></span><span class="dataCenter-table-list-span" title='+data[i].dsw+'>' + data[i].dsw + '<em>' + data[i].dswzf+ '</em></span></p></div></div>';
            }
            $('#pmtj').html(html);
        }
    });
}

//多次部署
getDataFn.getDcbs = function () {
    $.ajax({
        async: false,
        type: "post",
        url: "../SyService",
        data: {
            fname: "getDcbs"
        },
        dataType: "json",
        success: function (data) {
            var html = '';
            console.log(data);
            for (var i = 0; i < data.length; i++) {
            	if(data[i].zb>0){
            		html += '<li class="fail">';
            		html += '<div>' + data[i].title + '<span>部署<em>' + data[i].zg + '</em>次</span></div>';
                    html += '<p><span>未完成<em>' + data[i].zb + '</em>次</span></p>';
            	}else{
            		html += '<li class="success">';
            		html += '<div>' + data[i].title + '<span>部署<em>' + data[i].zg + '</em>次</span></div>';
                    html += '<p><span>已全部完成</span></p>';
            	}
                html += '<li>';
            }
            $('#dcbs').html(html);
        }
    });
}
$(document).ready(function () {
	/*echartsFn.pmCount();*/
	getDataFn.getFxz("");
	getDataFn.getJzly();
	getDataFn.getPmtj("");
	getDataFn.getDcbs();
});
