var $;
var reload;
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
        url : 'tableAction.jsp?status=select&dtype='+dtype+'&type='+type,
        page : true,
        limit : 15,
        limits : [10,15,20,25],
        id : "newsListTable",
        cols : [[
            {type: "checkbox"},
            {field: 'rn', title: 'ID', width:'5%', align:"center"},
            {title: '办件名称', width:'26%',templet:'#titleTpl',style:'cursor:pointer',event:'titleClick'},
            {field: 'psperson', title: '批示领导',sort: true, align:'center'},
            /*{field: 'lwdepname', title: '来文文号',sort: true,width:'8%', align:'center'},*/
            {field: 'bh', title: '编号',sort: true, align:'center'},
            {field: 'state', title: '办件状态',sort: true,align:'center',templet:"#state"},
            {field: 'createtime', title: '发布时间',sort: true, align:'center'},
            {field: 'jbsx', title: '交办时限',sort: true, align:'center',templet:"#setColor"},
            {field: 'state', title: '是否办结',sort: true, align:'center', templet:function(d){
                    var boolean="";
                    if(d.state=="2"){
                        boolean="checked";
                    }
                    return '<input type="checkbox" value='+d.unid+' name="state" lay-filter="newsTop" lay-skin="switch" lay-text="是|否"  '+boolean+'>'
                }},
            {field: 'gqstate', title: '是否挂起',sort: true, align:'center', templet:function(d){
            	var boolean="";
            	if(d.gqstate=="1"){
            		boolean="checked";
            	}
                return '<input type="checkbox" value='+d.unid+' name="gqstate" lay-filter="gqTop" lay-skin="switch" lay-text="是|否"  '+boolean+'>'
            }},
            {title: '操作',  width:'15%', templet:'#newsListBar'}
        ]]
    });
    reload=function(){
    	tableIns.reload();
    };

    //是否挂起
    form.on('switch(gqTop)', function(data){
    	/*$(this).val(data.value);*/
        var unid=data.value;
        var status="";
        //var index = layer.msg('修改中，请稍候',{icon: 16,time:false,shade:0.8});
            if(data.elem.checked){
                layer.msg("挂起成功！");
                status="1";
                upGqStatus(unid,status);
            }else{
                data.action = 'qxgq';
                data.unid = data.value;
                addNews(data);
            }
    })

    //是否办结
    form.on('switch(newsTop)', function(data){
    	  	var unid=data.value;
    	  	var status="";
	    	  	if(data.elem.checked){
		    	  	layer.confirm('确认办结？', {
		      		  btn: ['正常办结', '超时办结'] //可以无限个按钮
		      		}, function(index, layero){
		      		  //按钮【按钮一】的回调
		      			layer.msg("办结成功！");
		                status="2";
		                upStatus(unid,status);
		                reload();
		      		}, function(index){
		      		  //按钮【按钮二】的回调
		      			layer.msg("超时办结成功！");
		                status="3";
		                upStatus(unid,status);
		                reload();
		      		});
	    	  	}else{
	    	  		layer.msg("取消办结成功！");
	                status="1";
	                upStatus(unid,status);
	                reload();
	    	  	}  
    })

    //搜索【此功能需要后台配合，所以暂时没有动态效果演示】
    $(".search_btn").on("click",function(){
        if($(".searchVal").val() !== ''){
            table.reload("newsListTable",{
                page: {
                    curr: 1 //重新从第 1 页开始
                },
                url: 'tableAction.jsp?status=select&dtype='+dtype+'&type='+type,
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
            url: 'tableAction.jsp?status=select&dtype=' + dtype + '&type='+type,
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
            content : "tableAdd.jsp?unid="+edit.unid+"&dtype="+dtype+'&action='+edit.action,
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
        /*$(window).on("resize",function(){
            layui.layer.full(index);
        })*/
    }

    $(".addNews_btn").click(function(){
    	addDbj();
    })
    
    $("#wn").click(function(){
    	 var checkStatus = table.checkStatus('newsListTable'),
         data = checkStatus.data;
    	 if(data.length > 0) {
         layer.confirm('确定将选中的件设为（取消）蜗牛件？', {icon: 3, title: '提示信息'}, function (index) {
         	for (var i in data) {
         		whstatus(data[i].unid,"1",data[i].whstatus);
             }
             layer.close(index);
             tableIns.reload();
             layer.alert(data.length+"条数据设置成功成功");
         })
	     }else{
	         layer.msg("请选择对应的蜗牛件");
	     }
    })
     $("#hq").click(function(){
    	 var checkStatus = table.checkStatus('newsListTable'),
         data = checkStatus.data;
    	 if(data.length > 0) {
         layer.confirm('确定将选中的件设为（取消）红旗件？', {icon: 3, title: '提示信息'}, function (index) {
         	for (var i in data) {
         		whstatus(data[i].unid,"2",data[i].whstatus);
             }
             layer.close(index);
             tableIns.reload();
             layer.alert(data.length+"条数据设置成功成功");
         })
	     }else{
	         layer.msg("请选择需对应的红旗件");
	     }
    })
    
    //是否蜗牛件还是红旗件
    function whstatus(unid,state,whstatus){
        $.ajax({
            type:"post",
            url:"../yj_lr/updateAction.jsp",
            data:{"status":"whstatus","unid":unid,"state":state,"whstatus":whstatus},
            dataType:"json",
            success:function(result){
            }
        });
    }
    
    

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
                reload();
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
                reload();
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
                reload();
            });
        } else if(layEvent === 'dbtj'){ //预览
        	layui.layer.open({
        		type: 2,
        		area: ['100%', '100%'],
        		content: 'dbtj.jsp?unid=' + data.unid,
        		cancel : function(index, layero){
        		    //do something
        		    layer.close(index); //如果设定了yes回调，需进行手工关闭
                    tableIns.reload();
        		}
        	});
        }else if(layEvent === 'lsjl'){ //历史记录
        	dHistory(data.unid);
        }else if(layEvent === 'titleClick'){
        	/*layui.layer.open({
        		type: 2,
        		area: ['100%', '100%'],
        		content: 'dbtj.jsp?unid=' + data.unid
        	}); */  
            parent.addTab($('<a data-url="'+ getRootPath() +'/yj_dbhf/fkShow.jsp?unid='+ data.unid +'&v=1"><i class="layui-icon" data-icon=""></i><cite>回复情况</cite></a>'));
        } 
    });

    //批量导入
    $('#pldr').click(function(){
    	layui.layer.open({
    		type: 2,
    		area: ['50%', '50%'],
    		content: 'importuserfromxls.jsp?dtype='+dtype,
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

			window.location.href="tableAction.jsp?status=pldc&chkid=" + chkid +"&dtype="+dtype;
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
    
    // 按钮隐藏显示
    $('#gd').click(function() {
    	  $(".bt").removeClass("layui-hide");
    	  $(".gd").addClass("layui-hide");
    });
    $('#yc').click(function() {
  	  $(".bt").addClass("layui-hide");
  	 $(".gd").removeClass("layui-hide");
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
				setdoc(checkStatus.data[i].unid,'tzd');
			}

    	} else if(checkStatus.data.length > 1) {
    		layer.alert("仅支持单行生成", {icon: 5});
    	} else {
    		layer.alert("请选择要生成的行", {icon: 5});
    	}
    });
    
  //导出督办提醒单
    $('#dbtxd').click(function() {
    	var checkStatus = table.checkStatus('newsListTable');
    	if(checkStatus.data.length == 1) {
			for (var i = 0; i < checkStatus.data.length; i++) {
				setdoc(checkStatus.data[i].unid,'txd');
//				setbbdoc(checkStatus.data[i].unid,'txd');
			}

    	} else if(checkStatus.data.length > 1) {
    		layer.alert("仅支持单行生成", {icon: 5});
    	} else {
    		layer.alert("请选择要生成的行", {icon: 5});
    	}
    });

})
//生成批示单
function setdoc(unid,status){
	var index = layer.msg('文档生成中',{icon: 16,time:false,shade:0.8});
	$.ajax({
		async: true,   //要异步
		type:"post",
		url:"../SyService",
		data:{
			fname:"getWord",
			type:"qt",
			status:status,
			unid:unid
		},
		dataType: "json",
		success:function(data){
			layer.close(index);
			window.location.href="../DownloadAttach?uuid="+data.unid+"";
		},error:function(data){
   			layer.close(index);
   			layer.msg("生成失败，请稍后再试！");
   		}
	});
}


//生成报表
function setbbdoc(unid,status){
	var index = layer.msg('文档生成中',{icon: 16,time:false,shade:0.8});
	$.ajax({
		async: true,   //要异步
		type:"post",
		url:"../SyService",
		data:{
			fname:"getWord",
			type:"doc",
			qs:"9",
			createtime:"2018年7月16日",
			year:"2018",
			startMonth:"1",
			endMonth:"6",
			unid:unid
		},
		dataType: "json",
		success:function(data){
			layer.close(index);
			window.location.href="../DownloadAttach?uuid="+data.unid+"";
		},error:function(data){
   			layer.close(index);
   			layer.msg("生成失败，请稍后再试！");
   		}
	});
}


//删除督办件
function removePerson(unid,status){
	$.ajax({
		type:"post",
		async:false, 
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
        	reload();
        }
    });
}

//是否办结
function upStatus(unid,state){
	$.ajax({
		type:"post",
		async:false, 
		url:"../yj_lr/updateAction.jsp",
		data:{"status":"upkg","unid":unid,"state":state},
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
		area: ['90%', '90%'],
		content : "dHistory/dHistory.jsp?docunid="+unid,
		/*offset: '100px'*/
	});
}

function getRootPath(){
    var pathname = window.document.location.pathname;
    var projectName=pathname.substring(0,pathname.substr(1).indexOf('/')+1);
    return projectName;
}
