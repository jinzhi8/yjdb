document.write('<script language="javascript" type="text/javascript" charset="utf-8" src="'+getRootPath()+'/js/layer/layer.js"></script>');
function alertMsg(content,inputObj){
	layer.open({
		title:"温馨提示",
		content:content,
		yes: function(index, layero){		
			layer.close(index);
			if(typeof(inputObj)!="undefined"){
				inputObj.focus();
			}
		}
	});
}
//iframeWin对象
var iframeWin;

//返回iframeWin对象
function getIframeWin(){
	return $("div.layui-layer-content > iframe")[0].contentWindow;
}

/*
 * 获取项目名称
 */
function getRootPath(){
    //获取当前网址，如： http://localhost:8088/test/test.jsp
    var curPath=window.document.location.href;
    console.info("curPath:"+curPath);
    //获取主机地址之后的目录，如： test/test.jsp
    var pathName=window.document.location.pathname;
    console.info("pathName:"+pathName);
    var pos=curPath.indexOf(pathName);
    console.info("pos:"+pos);
    //获取主机地址，如： http://localhost:8088
    var localhostPaht=curPath.substring(0,pos);
    console.info("localhostPaht:"+localhostPaht);
    //获取带"/"的项目名，如：/test
    var projectName=pathName.substring(0,pathName.substr(1).indexOf('/')+1);
    console.info("projectName:"+projectName);
    return(localhostPaht+projectName);
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



//人员选择
function openSelWinNew(url){
	layer.open({
		type: 2,
		title: '人员选择',
		fix: true,
		maxmin: false,
		area: ['600px', '500px'],
		offset: '50px',
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

//附件
var file = [];
file.add = function(obj){
  var obj = $(obj);
  var parents = obj.parents('li.file-line');
  var html = '';
  html = '<li class="file-line">';
  html += '<span class="file-wrap">';
  html += '<input type="file" name="fileattache"   class="layui-input file-add-input">';
  html += '<span class="view"><label class="gray">请选择文件</label><a>选择</a></span>';
  html += '</span>';
  html += '<a class="btn remove-file" onclick="file.remove(this)">删除</a>';
  html += '<a class="btn add-file" onclick="file.add(this)">增加</a>';
  html += '</li>';
  parents.after(html);
  if(obj.siblings('.remove-file').length == 0){
    obj.after('<a class="btn remove-file" onclick="file.remove(this)">删除</a>');
  }
  obj.remove();
}
file.remove = function(obj){
  var obj = $(obj);
  var parentsLi = obj.parents('li.file-line');
  var list = obj.parents('ul.file-list').find('li.file-line');
  var listLen = list.length;
  if(listLen > 0){
    parentsLi.remove();
		listLen --;
  }
  if(parentsLi.find('.add-file').length == 1){
    $('.file-list li:last-child').append('<a class="btn add-file" onclick="file.add(this)">增加</a>').find('.remove-file').remove();
  }
	var lastRemove = $('.file-list').eq(0).find('.remove-file');
	if(listLen == 1 & lastRemove.length > 0){
		lastRemove.remove();
		console.log(lastRemove);
	}

}
$(document).on('change','.file-wrap input',function(e){
  var file = e.currentTarget.files[0].name;
	var parents = $(this).parents('li.file-line');
	var view = parents.find('.view label');
	view.html(file).removeClass('gray');
})

//数据提交
function submitAndSave(url){
//	if(!$("#disclaimer").is(':checked')){
//		layer.alert("请勾选同意本条款!");
//		return false;
//	}
	layer.confirm('提交后不可删除修改，是否确认提交？', {
		offset: '100px',
		btn: ['确认','取消'] //按钮
	}, function(index1,layero){
		layer.close(index1);
		//设置遮罩
		var zcdiv = layer.load(2,{
			shade:[0.3,'#000'],
		});
	$("#infoform").ajaxSubmit({
		dataType:'json',
		error:function(){
			layer.close(zcdiv);
			layer.open({
				title:"温馨提示",
				content:"提交出错",
				offset: '100px',
			});
		},
		success:function(data){
			if(data.success){
				//关闭遮罩
				layer.close(zcdiv);
				layer.open({
					title:"温馨提示",
					content:"提交成功",
					offset: '100px',
					yes: function(index, layero){
						window.parent.location.reload();
						var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
						window.parent.layer.close(index);
						/*window.location.href=url;*/
					}
				
				});
				}else{
					layer.close(zcdiv);
					alertMsg(data.msg);
				}
		}
	});
	}, function(){
	});
}

//查看附件
function showAttach(uuid){
	var url = '../resources/jsp/signature/showAttach.jsp?uuid='+uuid || "";
	var title = "查看附件" || "窗口";
	var width = "80%" || "1000px";
	var height = "500px" || "600px";
	if(url!=""){
		layer.open({
			type: 2,
			title: title,
			fix: true,
			maxmin: false,
			offset: '50px',
			area: [width, height],
			content: url
		});
	}else{
		layer.alert("访问URL不存在");
	}
} 

//附件删除
function del(unid){
	layer.confirm('是否确认删除该附件？', {
		  offset: '100px',
		  btn: ['确认','取消'] //按钮
		}, function(index1,layero){
			layer.close(index1);
			//设置遮罩
			var zcdiv = layer.load(2,{
				shade:[0.3,'#000']
			});
			$.ajax({
				type:"post",
				url:"../yj_common/Action.jsp",
				dataType: "json",
				data:{"unid":unid,"status":"scfj"},
				success:function(data){
					if(data.success==true){
						window.location.href=window.location.href;
					}
				}
			});
		}, function(){

	});
}
