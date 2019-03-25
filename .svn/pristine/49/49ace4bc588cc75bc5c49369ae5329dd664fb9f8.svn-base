

function logPrint(msg){
	//console.info(msg);
}

var getDataGrid;		//获取主页面datagrid
//创建HTML对象
function creatHtml(obj){
	//统一设置属性的默认值
	obj.style=obj.style||"";
	obj.id=obj.id||"";
	obj.url=obj.url||"";
	obj.method=obj.method||"post";
	obj.name = obj.name==null?obj.id:obj.name;
	obj.label = obj.label==null?"&nbsp;":obj.label;
	obj.clazs=obj.clazs||"";
	obj.editable=obj.editable==undefined?true:obj.editable;		
	obj.fileKey=obj.fileKey||"";
	obj.param=obj.param||"";
	obj.ajaxfun=obj.ajaxfun||"";
	obj.otherSql=obj.otherSql||"";
	obj.hidname=obj.hidname||"";
	obj.width=obj.width||"";
	obj.value=obj.value||"";
	obj.border=obj.border||"0";
	obj.alt=obj.alt||"";
	obj.dataoptions=obj.dataoptions||"";
	obj.hidx=obj.hidx||"";
	obj.hidy=obj.hidy||"";
	obj.click=obj.click||"";
	obj.title=obj.title||"";
	
	
	
	if(obj.type == "table"){
		getFather(obj).append("<table class='"+obj.clazs+"' style='"+obj.style+"' border='"+obj.border+"' id='"+obj.id+"'></table>");
	}else if(obj.type == "a"){
		$("<a class='"+obj.clazs+"' style='"+obj.style+"' href='javascript:void(0);' id='"+obj.id+"' ></a>").bind("click",obj.click).appendTo(getFather(obj))
	}else if(obj.type == "div"){
		getFather(obj).append("<div class='"+obj.clazs+"' style='"+obj.style+"' id='"+obj.id+"'></div>");
	}else if(obj.type == "form"){
		getFather(obj).append("<form class='"+obj.clazs+"' style='"+obj.style+"' id='"+obj.id+"' url='"+obj.url+"' method='"+obj.method+"' ></form>");
	}else if(obj.type == "input"){
		getFather(obj).append("<input value='"+obj.value+"' class='"+obj.clazs+"' style='"+obj.style+"' id='"+obj.id+"' name='"+obj.name+"' width='"+obj.width+"' editable='"+obj.editable+"' fileKey='"+obj.fileKey+"' param='"+obj.param+"' ajaxfun='"+obj.ajaxfun+"' otherSql='"+obj.otherSql+"' hidname='"+obj.hidname+"'></input>");
	}else if(obj.type == "br"){
		getFather(obj).append("<br/>");
	}else if(obj.type == "nbsp"){
		for(var i=0;i<obj.size;i++){
			getFather(obj).append("&nbsp;");
		}
	}else if(obj.type == "label"){
		getFather(obj).append("<label id='"+obj.id+"' name='"+obj.name+"' class='"+obj.clazs+"' style='"+obj.style+"'>"+obj.text+"</label>");
	}else if(obj.type == "hidden"){
		getFather(obj).append("<input type='hidden' id='"+obj.id+"' name='"+obj.name+"' value='"+obj.value+"'></input>");
	}else if(obj.type == "object"){
		getFather(obj).append(obj.htm);
	}else if(obj.type == "img"){
		getFather(obj).append("<img onclick='"+obj.click+"' alt='"+obj.alt+"' src='"+obj.src+"' class='"+obj.clazs+"' style='"+obj.style+"' id='"+obj.id+"' name='"+obj.name+"' title='"+obj.title+"' data-options='"+obj.dataoptions+"' cursor='"+obj.cursor+"' hidx='"+obj.hidx+"' hidy='"+obj.hidy+"'/>");
	}else if(obj.type == "pk"){
		getFather(obj).append("<input type='hidden' id='"+obj.id+"' name='"+obj.name+"' value='"+Ec.uuid()+"'></input>");
	}
	
}

//返回选择的对象
function getFather(obj){
	if(obj.father == null){
		return $("body");
	}else{
		return $("#"+obj.father);
	}
}

//datagrid加载成功后默认触发事件
function loadSuccess(){
	
}

//datagrid默认的查询提交方法
function fromSub(){
	//根据form的ID 获取grid的ID
	var grid = '#'+$(this).attr('id').replace('_serchform_sub','');
	//获取表单数据
	var formData = $('#'+$(this).attr('id').replace('_sub','')).serializeJson();
	//查询
	$(grid).datagrid('load',formData);
	
}
//treegrid默认的查询提交方法
function fromTreeSub(){
	//根据form的ID 获取grid的ID
	var grid = '#'+$(this).attr('id').replace('_serchform_sub','');
	//获取表单数据
	var formData = $('#'+$(this).attr('id').replace('_sub','')).serializeJson();
	//查询
	$(grid).treegrid('load',formData);
	
}


//默认的重置方法
function fromReset(){
	//必须调用easyui的重置方法
	$('#'+$(this).attr('id').replace('_reset','')).form('reset');
	
}

//序列化表单成json对象   --jquery本身就有自带这个方法，以后不用这个方法
$.fn.serializeJson=function(){ 
    var serializeObj={}; 
    var array=this.serializeArray(); 
    var str=this.serialize(); 
    $(array).each(function(){ 
        if(serializeObj[this.name]){ 
            if($.isArray(serializeObj[this.name])){ 
                serializeObj[this.name].push(this.value); 
            }else{ 
                serializeObj[this.name]=[serializeObj[this.name],this.value]; 
            } 
        }else{ 
            serializeObj[this.name]=this.value;  
        } 
    }); 
    return serializeObj; 
};  


function openWin(obj){
		//统一设置属性的默认值
			obj.width=obj.width||900;
			obj.height=obj.height||500;
			obj.title=obj.title||"窗口";
			obj.url=obj.url||"";
			//窗口地址不能为空
			if(obj.url!=""){
				window.parent.$('#top-win').window({
					left:(window.parent.document.body.clientWidth-900)*0.5,
					top:(window.parent.document.body.clientHeight-400)*0.5,
					href:randomUrl(obj.url),
					title:obj.title,
					draggable:true,
					modal:true,
					closed:true,
					cache:false,
					iconCls:'icon-save',
					width:obj.width,
					height:obj.height,
					padding:10,
					collapsible:false,
					minimizable:false,
					maximizable:false,
					resizable:false,
					inline:true,
					openAnimation:'slide',
					closeAnimation:'slide',
					closeDuration:200,
					openDuration:300,
					onClose:function(){
						//清楚窗口内容
						try {
							window.parent.$(this).window("clear");	
						}catch(e){
							console.log(e);
						}
						
					}
					
				}).window('open');
			}
}

//关闭窗口，刷新页面
function closeWin(){
	window.parent.$('#top-win').window('close');
}
		
//给地址智能加上随机数
function randomUrl(url){
	if(url.indexOf("?") > 0 )
	{
	    //包含？ 说明是这种格式的/yyglAction.do?method=getYy     /#/g这种写法标识替换所有#，g表示全局的意思，全局搜索。
		return encodeURI(url+"&randomUrl&="+Math.random()).replace(/#/g,"%23");
	}else{
		return encodeURI(url+"?randomUrl="+Math.random()).replace(/#/g,"%23");
	}
}


/*
 * 获取项目名称
 */
function getRootPath(){
    //获取当前网址，如： http://localhost:8088/test/test.jsp
    var curPath=window.document.location.href;
    //获取主机地址之后的目录，如： test/test.jsp
    var pathName=window.document.location.pathname;
    var pos=curPath.indexOf(pathName);
    //获取主机地址，如： http://localhost:8088
    var localhostPaht=curPath.substring(0,pos);
    //获取带"/"的项目名，如：/test
    var projectName=pathName.substring(0,pathName.substr(1).indexOf('/')+1);
    return(localhostPaht+projectName);
}

/*
 * 单击表单缩放图片执行方法
 */
function searchImgClick(i){
	
	var MyImg = $(i);
	var MyForm = $(i).next("form");
	var DgId = MyImg.attr("id").replace("_search_img","");
	if(MyForm.css("display")=="block"){
		MyForm.hide(function(){
			MyImg.attr("src",getRootPath()+"/resources/js/easyui/img/icon/xia.png");
			$("#"+DgId).datagrid("resize");
		});
	}else{
		MyForm.show(function(){
			MyImg.attr("src",getRootPath()+"/resources/js/easyui/img/icon/shang.png");
			$("#"+DgId).datagrid("resize");
		});
	}
	
	
	
}

function cellClick(rowIndex, field, value,url){
	if(field != "chk"){
		var pageid = getDataGrid().datagrid('getRows')[rowIndex].pageid;
		if(url.indexOf("?") > 0){
		    openWin(randomUrl(url+"&pageid="+pageid),"修改");
		}else{
		    openWin(randomUrl(url+"?pageid="+pageid),"修改");
		}
	}
}

//统一的删除方法
function delTy(){
	var ids = [] ;
	var rows = getDataGrid().datagrid('getChecked');
	var isN = true;	//判断是否是数字
	var dt ;		//记录查询条件数据
	if(rows.length > 0){
		for(var i=0; i<rows.length; i++){
			ids.push(rows[i].pageid);
			if(isNaN(rows[i].pageid)){
				isN = false;
			}
		}
		
		if(isN){
			//数字不需要编
			dt = "ids="+ids+"&fileKeys="+$("#deleteFileKey").val();
		}else{
			//不是数字的话需要重置下格式
			dt = JSON.stringify(ids).replace(/\"/g,"'").replace("[","").replace("]","");
			dt = "ids="+dt+"&fileKeys="+$("#deleteFileKey").val();
		}

		
		$.messager.confirm('确认对话框', '是否删除选中的'+ids.length+'条数据？', function(r){
			if (r){
				//执行删除操作
				$.ajax({
					type:"POST",
					data:dt,
					url:getRootPath()+'/UtilController/delComm.do',
					success:function(data){
						getDataGrid().datagrid('reload');
						Ec.show(data);
						/*$.ajax({
							type:"POST",
							data:dt,
							url:getRootPath()+'/UtilController/delfile.do',
							success:function(data){								
							}
						});*/
					}
				});
			}
		});	
		
		
	}else{
		Ec.alert("请先选择要删除的数据");
	}
	
	
}
		