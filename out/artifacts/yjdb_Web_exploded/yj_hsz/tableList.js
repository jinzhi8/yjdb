var $;
layui.use(['form','layer','laydate','table','laytpl','jquery','upload'],function(){
    	var form = layui.form,
        layer =layui.layer,
        upload = layui.upload,
        laydate = layui.laydate,
        laytpl = layui.laytpl,
        table = layui.table;
        $ = layui.jquery;

    var date = new Date();
    laydate.render({
        elem: '#yfxz'
        ,type: 'month'
        ,value: date.getFullYear() + '-' + (date.getMonth() + 1)

    });
    laydate.render({
        elem: '#sjq'
        ,type: 'date'
    });
    laydate.render({
        elem: '#sjz'
        ,type: 'date'
    });

    //新闻列表
    var tableIns = table.render({
        elem: '#tableList',
        url : 'tableAction.jsp?status=select',
        cellMinWidth : 95,
        page : true,
        height : "full-125",
        limit : 15,
        limits : [10,15,20,25],
        id : "newsListTable",
        cols : [[
            {type: "checkbox", fixed:"left", width:50},
            {field: 'rn', title: 'ID', width:60, align:"center"},
            {field: 'title', title: '督办件名称',sort: true,width:500, align:'center'},
            {field: 'psperson', title: '批示领导',sort: true,width:100, align:'center'},
            {field: 'lwdepname', title: '来文文号',sort: true,width:100, align:'center'},
            {field: 'bh', title: '编号',width:180,sort: true, align:'center'},
            {field: 'state', title: '督办件类型',width:150,sort: true,align:'center',templet:"#state"},
            {field: 'lxrname', title: '督办联系人',width:150,sort: true, align:'center'},
            {field: 'fklx', title: '反馈类型',width:110, align:'center',templet:"#fklx"},
            {field: 'createtime', title: '发布时间',width:110, align:'center'},
            {title: '操作',  minWidth:100, templet:'#newsListBar',align:"center"}
        ]]
    });

    //是否挂起
    form.on('switch(gqTop)', function(data){
        var unid=data.value;
        var status="";
        //var index = layer.msg('修改中，请稍候',{icon: 16,time:false,shade:0.8});
        setTimeout(function(){
            if(data.elem.checked){
                layer.msg("挂起成功！");
                status="1";
                upGqStatus(unid,status);
            }else{
                data.action = 'qxgq';
                data.unid = data.value;
                addNews(data);
            }
            tableIns.reload();
        },500);
    })

    //是否办结
    form.on('switch(newsTop)', function(data){
    	  	var unid=data.value;
    	  	var status="";
	        //var index = layer.msg('修改中，请稍候',{icon: 16,time:false,shade:0.8});
	        setTimeout(function(){
	           /* alert(obj.unid);*/
	            if(data.elem.checked){
	                layer.msg("办结成功！");
	                status="2";
	                upStatus(unid,status);
	            }else{
	                layer.msg("取消办结成功！");
	                status="1";
	                upStatus(unid,status);
	            }
	            tableIns.reload();
	        },500);
    })

    //搜索【此功能需要后台配合，所以暂时没有动态效果演示】
    $(".search_btn").on("click",function(){
        if($(".searchVal").val() !== ''){
            table.reload("newsListTable",{
                page: {
                    curr: 1 //重新从第 1 页开始
                },
                url: 'tableAction.jsp?status=select&dtype='+dtype+'',
                where: {
                    key: $(".searchVal").val()  //搜索的关键字
                }
            })
        }else{
            layer.msg("请输入搜索的内容");
        }
    });
	//条件搜索
    $(".search_btn_a").on("click",function(){
        var sjq,sjz,sfbj = $('[name=sfbj]').val();
        if($('[name=tjxz]').val() === '1') {
            var yjxz = $('#yfxz').val();
            sjq = yjxz + '-01';
            sjz = yjxz + "_" +new Date(yjxz.substr(0,4),yjxz.substr(5,2),0).getDate()
        } else {
            sjq = $('#sjq').val();
            sjz = $('#sjz').val();
        }
        table.reload("newsListTable", {
            page: {
                curr: 1 //重新从第 1 页开始
            },
            url: 'tableAction.jsp?status=select&dtype=' + dtype + '',
            where: {
                key: $(".searchVal").val(),  //搜索的关键字
                sjq: sjq,
                sjz: sjz,
                sfbj: sfbj
            }
        });
    });

    //新增督办件
    function addDbj(){
        var index = layui.layer.open({
            title : "新增督办件",
            type : 2,
            content : "tableAdd.jsp?dtype="+dtype,
            success : function(layero, index){
                setTimeout(function(){
                    layui.layer.tips('点击此处返回列表', '.layui-layer-setwin .layui-layer-close', {
                        tips: 3
                    });
                },500)
            }
        })
        layui.layer.full(index);
        //改变窗口大小时，重置弹窗的宽高，防止超出可视区域（如F12调出debug的操作）
        /*$(window).on("resize",function(){
            layui.layer.full(index);
        })*/
    }

    //编辑督办件
    function addNews(edit){
        var index = layui.layer.open({
            title : "编辑督办件",
            type : 2,
            content : "../yj_lr/tableAdd.jsp?unid="+edit.unid+"&hsz=hsz",
            success : function(layero, index) {
                setTimeout(function () {
                    layui.layer.tips('点击此处返回列表', '.layui-layer-setwin .layui-layer-close', {
                        tips: 3
                    });
                }, 500);
            }
        });
        layui.layer.full(index);
        //改变窗口大小时，重置弹窗的宽高，防止超出可视区域（如F12调出debug的操作）
       /* $(window).on("resize",function(){
            layui.layer.full(index);
        })*/
    }

    $(".addNews_btn").click(function(){
    	addDbj();
    })

    //批量删除
    $(".delAll_btn").click(function(){
        var checkStatus = table.checkStatus('newsListTable'),
            data = checkStatus.data;
        if(data.length > 0) {
            layer.confirm('确定删除选中的督办件？', {icon: 3, title: '提示信息'}, function (index) {
            	/*ayui.each(checkStatus, function(index, item) {
            		item.del();
            	});*/
            	for (var i in data) {
                    removePerson(data[i].unid,"remove");
                }
                layer.close(index);
                tableIns.reload();
                layer.alert(data.length+"条数据批量删除成功");
            })
        }else{
            layer.msg("请选择需要删除的数据");
        }
    })

    //批量办结
    $(".upAll_btn").click(function(){
        var checkStatus = table.checkStatus('newsListTable'),
            data = checkStatus.data;
        if(data.length > 0) {
            layer.confirm('确定办结选中的督办件？', {icon: 3, title: '提示信息'}, function (index) {
            	/*ayui.each(checkStatus, function(index, item) {
            		item.del();
            	});*/
            	for (var i in data) {
            		upStatus(data[i].unid,"2");
                }
                layer.close(index);
                tableIns.reload();
                layer.alert(data.length+"条数据批量办结成功");

            })
        }else{
            layer.msg("请选择需要办结的数据");
        }
    })

    //列表操作
    table.on('tool(newsList)', function(obj){
        var layEvent = obj.event,
            data = obj.data;
        if(layEvent === 'edit'){ //编辑
            addNews(data);
        } else if(layEvent === 'del'){ //删除
            layer.confirm('确定删除此督办件？',{icon:3, title:'提示信息'},function(index){
            	obj.del(); //删除对应行（tr）的DOM结构
                layer.close(index);
                removePerson(data.unid,"remove");
            });
        } else if(layEvent === 'dbtj'){ //预览
        	layui.layer.open({
        		type: 2,
        		area: ['100%', '100%'],
        		content: 'dbtj.jsp?unid=' + data.unid
        	});
        }else if(layEvent === 'lsjl'){ //历史记录
        	dHistory(data.unid);
        }
    });

    //批量导入
    $('#pldr').click(function(){
    	layui.layer.open({
    		type: 2,
    		area: ['50%', '50%'],
    		content: 'importuserfromxls.jsp',
    		end: function(){
    			tableIns.reload();
    		}
    	});
    });

    //批量导出
    $('#pldc').click(function(){
    	var checkStatus = table.checkStatus('newsListTable');
    	if(checkStatus.data.length) {
    		var chkid = "";
			for (var i = 0; i < checkStatus.data.length; i++) {
				if(i < checkStatus.data.length-1){
					chkid += checkStatus.data[i].unid + ",";
				} else {
					chkid += checkStatus.data[i].unid;
				}
			}

			window.location.href="tableAction.jsp?status=pldc&chkid=" + chkid;
    	} else {
    		layer.alert("请选择要导出的行", {icon: 5});
    	}
    });
    //条件导出
	$('#tjdc').click(function() {
		if($('.blockb ').css('display') === 'block') {
            $('.blockb').hide(500);
		} else {
            $('.blockb').show(500);
		}
	});

    form.on('select(tjxz)', function(data){
        if(data.value === '1') {
            $('.sjd').hide();
            $('.yfxz').show();
		} else if(data.value === '2') {
            $('.yfxz').hide();
            $('.sjd').css('display','inline-block');
		}
    });

    //导出反馈列表
    $('#fkdc').click(function() {
    	var checkStatus = table.checkStatus('newsListTable');
    	if(checkStatus.data.length == 1) {
			for (var i = 0; i < checkStatus.data.length; i++) {
				window.location.href="tableAction.jsp?status=fkdc&unid=" + checkStatus.data[i].unid;
			}

    	} else if(checkStatus.data.length > 1) {
    		layer.alert("仅支持单行导出", {icon: 5});
    	} else {
    		layer.alert("请选择要导出的行", {icon: 5});
    	}
    });

    //导出督办通知单
    $('#dbtzd').click(function() {
    	var checkStatus = table.checkStatus('newsListTable');
    	if(checkStatus.data.length == 1) {
			for (var i = 0; i < checkStatus.data.length; i++) {
				setdoc(checkStatus.data[i].unid);
			}

    	} else if(checkStatus.data.length > 1) {
    		layer.alert("仅支持单行生成", {icon: 5});
    	} else {
    		layer.alert("请选择要生成的行", {icon: 5});
    	}
    });

})
//生成批示单
function setdoc(unid){
	$.ajax({
		async: false,
		type:"post",
		url:"../SyService",
		data:{
			fname:"getWord",
			type:"qt",
			unid:unid
		},
		dataType: "json",
		success:function(data){
			window.location.href="../DownloadAttach?uuid="+data.unid+"";
		}
	});
}
//删除督办件
function removePerson(unid,status){
	$.ajax({
		type:"post",
		url:"../yj_common/Action.jsp",
		data:{"status":status,"unid":unid,"moduleid":"yj_lr"},
		dataType:"json",
		success:function(result){
		}
	});
}

//是否挂起
function upGqStatus(unid,state){
    $.ajax({
        type:"post",
        url:"../yj_lr/updateAction.jsp",
        data:{"status":"upgq","unid":unid,"gqstate":state},
        dataType:"json",
        success:function(result){
        }
    });
}

//是否办结
function upStatus(unid,state){
	$.ajax({
		type:"post",
		url:"../yj_lr/updateAction.jsp",
		data:{"status":"upkg","unid":unid,"state":state},
		dataType:"json",
		success:function(result){
		}
	});
}

//钉消息历史记录
function dHistory(unid){
	layer.open({
		type: 2,
		title: '',
		fix: true,
		maxmin: false,
		area: ['1000px', '700px'],
		content : "dHistory/dHistory.jsp?docunid="+unid,
		/*offset: '100px'*/
	});
}