document.write('<script language="javascript" type="text/javascript" charset="utf-8" src="/tzgaww/resources/js/layer/layer.js"></script>');

//iframeWin对象
var iframeWin;

//返回iframeWin对象
function getIframeWin(){
	return $("div.layui-layer-content > iframe")[0].contentWindow;
}

//人员选择
function openSelWin(url){
	layer.open({
		type: 2,
		title: '人员选择',
		fix: true,
		maxmin: false,
		area: ['600px', '500px'],
		offset: '100px',
		content: url,
		btn: ['确定', '清空', '展开','收缩','取消'],
		yes: function(index, layero){
			iframeWin.confirmSelection();
			layer.close(index);
		},
		btn2: function(index, layero){
			//按钮【按钮二】的回调
			iframeWin.clear_All();
			iframeWin.confirmSelection();
			layer.close(index);
			//return false 开启该代码可禁止点击该按钮关闭
		},
		btn3: function(index, layero){
			//按钮【按钮三】的回调
			iframeWin.utree.expandAll();
			return false;
			//return false 开启该代码可禁止点击该按钮关闭
		},
		btn4: function(index, layero){
			//按钮【按钮三】的回调
			iframeWin.utree.collapseChildren();
			return false;
			//return false 开启该代码可禁止点击该按钮关闭
		},
		cancel: function(){ 
			//右上角关闭回调

			//return false 开启该代码可禁止点击该按钮关闭
		},
		success: function(layero, index){
			iframeWin = $("div.layui-layer-content > iframe")[0].contentWindow; 
		}
	});
}

function openJgSelWin(url){
	layer.open({
		type: 2,
		title: '监管事项选择',
		fix: true,
		maxmin: false,
		area: ['600px', '500px'],
		offset: '100px',
		content: url,
		btn: ['确定', '清空', '展开','收缩','取消'],
		yes: function(index, layero){
			iframeWin.confirmSelection();
			layer.close(index);
		},
		btn2: function(index, layero){
			//按钮【按钮二】的回调
			iframeWin.clear_All();
			iframeWin.confirmSelection();
			layer.close(index);
			//return false 开启该代码可禁止点击该按钮关闭
		},
		btn3: function(index, layero){
			//按钮【按钮三】的回调
			iframeWin.utree.expandAll();
			return false;
			//return false 开启该代码可禁止点击该按钮关闭
		},
		btn4: function(index, layero){
			//按钮【按钮三】的回调
			iframeWin.utree.collapseChildren();
			return false;
			//return false 开启该代码可禁止点击该按钮关闭
		},
		cancel: function(){ 
			//右上角关闭回调

			//return false 开启该代码可禁止点击该按钮关闭
		},
		success: function(layero, index){
			iframeWin = $("div.layui-layer-content > iframe")[0].contentWindow; 
		}
	});
}
//查看流程图
function openFlowWin(url){
	layer.open({
		type: 2,
		title: '窗口',
		fix: true,
		maxmin: false,
		area: ['1000px', '600px'],
		content: url
	});
}

//弹出IFrame窗口
function openIframeWin(obj){
	var url = obj.url || "";
	var title = obj.title || "窗口";
	var width = obj.width || "1000px";
	var height = obj.height || "600px";
	if(url!=""){
		layer.open({
			type: 2,
			title: title,
			fix: true,
			maxmin: false,
			offset: '100px',
			area: [width, height],
			content: url
		});
	}else{
		layer.alert("访问URL不存在");
	}
}


