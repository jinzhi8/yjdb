layui.use(['form','layer','table','layedit', 'element'],function(){
    	var layer =layui.layer,
        layedit = layui.layedit,
        form = layui.form,
        element = layui.element,
        table = layui.table;
    //新闻列表
    var boo = true;
    var tableIns = table.render({
        elem: '#tableList',
        // url : 'tableAction.jsp?status=selectDbTalk&unid='+unid,
        url : 'tableAction.jsp?status=selectDbTalk',
        id : "newsListTable",
        page: true,
        cols : [[
        	{checkbox: true},
            {title: '发送人', width:150,templet:function(d){
					return d.username+'【'+ d.deptname +'】';
				}},
            {title: '主题', minWidth:300, templet:function(d){
            	if(d.flag === "2"){
            		return "回复："+d.title+" - "+d.content;
            	} else {
            		return d.title+" - "+d.content;
            	}
            }},
            {title: '时间', width: 160, templet: function(d){
            	var fs = new Date(d.createtime).getTime();
            	var now = new Date().getTime();

            	var cc = now - fs;
            	if(Math.round(cc/1000) < 60) {
            		return Math.round(cc/1000)+" 秒前";
            	} else if(Math.round(cc/(1000*60)) < 60){
            		return Math.round(cc/(1000*60))+" 分钟前";
            	} else if(Math.round(cc/(1000*60*60)) < 3){
            		if(new Date(d.createtime).format("dd") == new Date().format("dd")){
            			return Math.round(cc/(1000*60*60))+" 小时前";
            		} else {
            			return "昨天 "+new Date(d.createtime).format("HH:mm");
            		}

            	} else {
            		if(parseInt(new Date().format("dd")) == parseInt(new Date(d.createtime).format("dd"))){
            			return "今天 "+new Date(d.createtime).format("HH:mm");
            		} else if ((parseInt(new Date().format("dd"))-1) ==  parseInt(new Date(d.createtime).format("dd"))){
            			return "昨天 "+new Date(d.createtime).format("HH:mm");
            		} else if((parseInt(new Date().format("dd"))-2) ==  parseInt(new Date(d.createtime).format("dd"))){
            			return "前天 "+new Date(d.createtime).format("HH:mm");
            		} else {
            			return d.createtime;
            		}
            	}
            }},
            {title: '状态', width: 80,templet:function(d){
            	if(d.state == 0) {
            		return "未读";
            	} else if(d.state == 1){
            		return "已读";
            	} else if(d.state == 2){
            		return "已回复";
            	} else {
            		return "未读";
            	}
            }},
            {title: '操作', width: 80,templet:'<div><a href="javascript:;" class="layui-table-link" lay-event="detail">查看</a></div>'}
        ]],

    });

    form.on('submit(formDemo)', function(data){
    	//console.log(data.elem) //被执行事件的元素DOM对象，一般为button对象
    	//console.log(data.form) //被执行提交的form对象，一般在存在form标签时才会返回
    	//console.log(data.field) //当前容器的全部表单字段，名值对形式：{name: value}
    	//return false; //阻止表单跳转。如果需要表单跳转，去掉这段即可。

    	$.ajax({
    		type: 'post',
    		url: 'tableAction.jsp',
    		data: {
    			status: 'addDbTalk',
    			field: JSON.stringify(data.field)
    		},
    		success: function(res) {
    			var d = eval("("+ res +")");
    			if(d.code == 1) {
    				layer.msg("已发送", {icon: '6'});
    			} else {
    				layer.msg("发送失败,请稍后重试", {icon: '5'});
    			}
    			$(".select").trigger("click");
    		}
    	});

    });

    form.on('submit(send)', function(data){
    	//console.log(data.field) //当前容器的全部表单字段，名值对形式：{name: value}
    	$.ajax({
    		type: 'post',
    		url: 'tableAction.jsp',
    		data: {
    			status: 'addDbTalk',
    			field: JSON.stringify(data.field)
    		},
    		success: function(res) {
    			var d = eval("("+ res +")");
    			if(d.code == 1) {
    				layer.msg("已发送", {icon: '6'});
    			} else {
    				layer.msg("发送失败,请稍后重试", {icon: '5'});
    			}
    			$(".select").trigger("click");
    		}
    	});

    });

    var index;

    //新建
    $('.add').click(function(){
    	$('.tab1').hide();
    	$('.tab3').hide();
    	$('.tab4').hide();
    	$('.tab2').show(100);

    	index = layedit.build('content',{
        	tool: [
        		  'strong' //加粗
        		  ,'italic' //斜体
        		  ,'underline' //下划线
        		  ,'del' //删除线

        		  ,'|' //分割线

        		  ,'left' //左对齐
        		  ,'center' //居中对齐
        		  ,'right' //右对齐
        		  ,'face' //表情
        		]

        });

    });

    //收件箱
    $('.select').click(function(){
    	tableIns.reload();
    	$('.tab2').hide();
    	$('.tab4').hide();
    	$('.tab3').hide();
    	$('.tab1').show(100);
    });
    //发件箱
    var tabIns2;
    tabIns2 = table.render({
        elem: '#sendList'
        // ,url:'tableAction.jsp?status=selectSendMes&unid='+unid
        ,url:'tableAction.jsp?status=selectSendMes'
        ,cols: [[
            {type:'numbers', width:50, title: '序号'}
            ,{field:'username', width: 100, title: '收件人'}
            ,{field:'title',width:520,title: '主题'}
            ,{field:'time', width: 200, title: '时间'}
            ,{field:'state', width:100, title: '状态'}
        ]]
    });
    $('.send').click(function(){
        $('.tab2').hide();
        $('.tab1').hide();
        $('.tab3').hide();
        $('.tab4').show(100);
        tabIns2.reload();
	});

    $('.show').click(function(){
    	$('.tab3-1').show(100,function(){
    		$('.show').hide();
    		//$('#contenta').val('<div style="margin-bottom:80px"><span></span></div>'+$('.tab3-2').html());

    	});
    });
    //删除
    $('.del').click(function() {
    	var checkStatus = table.checkStatus('newsListTable');
    	//console.log(checkStatus.data);
    	if(checkStatus.data.length){
    		layer.confirm('确定要删除么?', {icon: 3, title:'提示'}, function(index){
    			$.ajax({
            		type: 'post',
            		url: 'tableAction.jsp',
            		data: {
            			status: 'delDbTalkState',
            			field: JSON.stringify(checkStatus.data)
            		},
            		success: function(res) {
            			var data = eval("("+ res +")");
            			if(data.count != 0) {
            				layer.msg("成功删除 "+data.count+" 条数据", {icon:'6'});
            				$(".select").trigger("click");
            			} else {
            				layer.msg("删除错误,请稍后重试", {icon: '5'});
            			}
            		}
            	});
    			layer.close(index);
    		});
    	} else {
    		layer.msg("请选择要删除的数据", {icon: '3'});
    	}
    });

  //监听工具条
    table.on('tool(newsList)', function(obj){
    	var data = obj.data;
    	var layEvent = obj.event;
    	var tr = obj.tr;

    	if(layEvent === 'detail'){
    		if(data.state == 0) {
    			$.ajax({
            		type: 'post',
            		url: 'tableAction.jsp',
            		data: {
            			status: 'updateDbTalkState',
            			id: data.id,
            			state: '1'
            		},
            		success: function(res) {
            		}
            	});
    		}

    		$('.tab3-1').hide();
    		$('.show').show();
    		$('.tab1').hide(0,function(){
        		$('.tab3').show(100,function() {
        			$('.title').text(data.title);
        			$('.username').text(data.username);
        			$('.createtime').text(data.createtime);
        			$('.content').html(data.content);

        			$('.tab3 [name=sid]').val(data.userid);
        			$('.tab3 [name=title]').val(data.title);
        			$('.tab3 [name=sname]').val(data.username);
        			$('.tab3 [name=id]').val(data.id);
        			$('#contenta').val("");
        		    index = layedit.build('contenta',{
        		    	tool: [
        		    		'strong' //加粗
        		    		,'italic' //斜体
        		    		,'underline' //下划线
        		    		,'del' //删除线

        		    		,'|' //分割线

        		    		,'left' //左对齐
        		    		,'center' //居中对齐
        		    		,'right' //右对齐
        		    		,'face' //表情
        		    		]

        		    });

        		});
        	});

    	}
    });


    //获得项目路径   yjdb
	function getRootPatha() {
		var pathName = window.document.location.pathname;
		var projectName = pathName.substring(0, pathName.substr(1).indexOf('/') + 1);
		return projectName;
	}

	form.verify({
		  content: function(value, item){
			  layedit.sync(index);
			  value = layedit.getContent(index);
			  if($.trim(value) == ""){
				  return "内容不能为空";
			  }
		  }
	});

	function reload(){
		window.location.reload();
	}

	Date.prototype.format=function(fmt) {
	    var o = {
	    "M+" : this.getMonth()+1, //月份
	    "d+" : this.getDate(), //日
	    "h+" : this.getHours()%12 == 0 ? 12 : this.getHours()%12, //小时
	    "H+" : this.getHours(), //小时
	    "m+" : this.getMinutes(), //分
	    "s+" : this.getSeconds(), //秒
	    "q+" : Math.floor((this.getMonth()+3)/3), //季度
	    "S" : this.getMilliseconds() //毫秒
	    };
	    var week = {
	    "0" : "/u65e5",
	    "1" : "/u4e00",
	    "2" : "/u4e8c",
	    "3" : "/u4e09",
	    "4" : "/u56db",
	    "5" : "/u4e94",
	    "6" : "/u516d"
	    };
	    if(/(y+)/.test(fmt)){
	        fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));
	    }
	    if(/(E+)/.test(fmt)){
	        fmt=fmt.replace(RegExp.$1, ((RegExp.$1.length>1) ? (RegExp.$1.length>2 ? "/u661f/u671f" : "/u5468") : "")+week[this.getDay()+""]);
	    }
	    for(var k in o){
	        if(new RegExp("("+ k +")").test(fmt)){
	            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));
	        }
	    }
	    return fmt;
	}
});
