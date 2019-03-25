$(function(){
	
	//创建Ec对象
	Ec = {};
	
	//创建dataGrid对象。必须项  id url columns
	Ec.datagrid = function(obj){
		
		obj.type="table";
		//创建HTML元素
		creatHtml(obj);
		//设置默认属性
		obj.striped = obj.striped||true;					//斑马线
		obj.pagination = obj.pagination||true;				//分页
		obj.loadMsg = obj.loadMsg||"拼命加载中...";
		obj.rownumbers = obj.rownumbers||true;				//行数
		obj.nowrap = obj.nowrap||false;						//是否显示在同一行中  
		obj.selectOnCheck = obj.selectOnCheck||false; 		//单击复选框是否选择行
		obj.checkOnSelect = obj.checkOnSelect||false; 		//单击行是否选中复选框
		obj.pageSize = obj.pageSize||15;					//一页显示多少行
		obj.pageList = obj.pageList||[10,15,20,25,50,100]; 	//分页行数选择列表
		obj.onLoadSuccess = obj.onLoadSuccess||loadSuccess;	//数据加载成功后触发事件
		obj.fit = obj.fit==undefined?true:obj.fit;							//datagrid自动填充body那么大
		obj.fitColumns = obj.fitColumns==undefined?true:obj.fitColumns;				//是否列宽自动调整大小，自动铺满。
		obj.form_btn = obj.form_btn||{};					//把from初始化。
		obj.tb_tbn = obj.tb_tbn||{};						//初始化tb_tbn
		obj.singleSelect = obj.singleSelect||true;			//如果为true，则只允许选择一行。
		obj.selectFileKey = obj.selectFileKey||"";			//查询的sql主键
		obj.deleteFileKey = obj.deleteFileKey||"";			//删除的SQL主键
		var searchFormOpenClick = obj.searchFormOpen==undefined?true:obj.searchFormOpen;	//通过执行click事件来控制初始化的时候是隐藏还是显示，这样对外的接口就不需要改变了
		obj.searchFormOpen = true;		                    //是否打开查询界面 默认是打开 值：false(关闭) true(打开)
		var hidParams = obj.queryParams || "";              //查询时是否追加默认条件
		obj.appid = obj.appid || "";                        //应用ID
		obj.creator = obj.creator || "";                    //数据创建人字段名 
		obj.frozenColumns=obj.frozenColumns ||"";
		//设置工具条
		if(obj.toolbar!=false){
			//1、创建一个DIV容器
			creatHtml({
				type:"div",
				id:obj.id+"_tbdiv",
				style:'padding:0px;height:auto'
			});
			obj.toolbar = "#"+obj.id+"_tbdiv";
			//2、创建tb_btn容器 在 DIV容器
			creatHtml({
				father:obj.id+"_tbdiv",
				type:"div",
				id:obj.id+"_tbdiv_btndiv",
				style:'height:auto;'
			});
			
			//往容放查询条件的DIV插入一个图片
			creatHtml({
				father:obj.id+"_tbdiv",
				type:"img",
				style:"position:absolute;float:right;z-index:100;right:5px;top:5px;cursor:pointer",
				src:obj.searchFormOpen?(getRootPath()+"/resources/js/easyui/img/icon/shang.png"):(getRootPath()+"/resources/js/easyui/img/icon/xia.png"),
				click:"searchImgClick(this)",
				title:"关/开",
				id:obj.id+"_search_img"
			});
			
			//3、创建from查询条件容器 在 DIV容器
			creatHtml({
				father:obj.id+"_tbdiv",
				type:"form",
				id:obj.id+"_serchform",
				style:'margin:0;background-color:#FFFFFF;'+(obj.searchFormOpen?"display:block":"display:none")
			});
			
			//3.1 往一级DIV _tbdiv里面添加 隐藏的打印DIV
			creatHtml({
				father:obj.id+"_tbdiv",
				type:"div",
				id:obj.id+"_printDIV",
				style:'display: none;text-align: center;'
			});
			
			//4、往tb_btn容器添加添加按钮
			$.each(obj.tb_tbn,function(i,n){
				if(n.id=="add"){
					//新增按钮
					n.click=function(){
								openWin(getRootPath()+obj.editUrl,n.text);
							}
				}else if(n.id=="del"){
					//删除按钮
					n.click=delTy;
				}else{
					n.click=eval(n.click);
				}
				n.father=obj.id+"_tbdiv_btndiv";
				Ec.linkbutton(n);
			});
			

			//往form里面添加table 背景 
			creatHtml({
				father:obj.id+"_serchform",
				type:"table",
				style:"display:inline;",
				id:obj.id+"_serchform_tab_bgtab",
				clazs:'tab2'
			});
			
			//往背景TAB 里面添加内容
			$("#"+obj.id+"_serchform_tab_bgtab").append("<tr><td id='bgtab_td_1'></td><td id='bgtab_td_2'></td></tr>");
			
			
			//5、往table背景布局里面添加table
			creatHtml({
				father:"bgtab_td_1",
				type:"table",
				style:"display:inline;",
				id:obj.id+"_serchform_tab",
				clazs:'tab2'
			});
			
			//6、往table里面添加查询条件
			var hiddenFormbtn="";

			//查询追加默认值
			if(hidParams!=""){
				for(var hkey in hidParams) {
				    hiddenFormbtn+="<input type='hidden' name='"+hkey+"' value='"+hidParams[hkey]+"'/>";
				}
			}
			
			$.each(obj.form_btn,function(i,n){
				//隐藏数据属性
				if("hidden"==n.type){
					hiddenFormbtn+="<input type='"+n.type+"' name='"+n.name+"' value='"+n.value+"'/>";
				    
					return true;
				}
				
				//第一次和第四个元素的倍数新增一行
				if(i==0||i%4==0){
					$("#"+obj.id+"_serchform_tab").append("<tr><td></td><td></td><td></td><td></td></tr>");
				}
				//每次在最后一行的的一个空的TD里面添加控件  设置ID是为了获取控件
				//$("#"+obj.id+"_serchform_tab > tbody > tr:last > td:empty:first").attr("id",obj.id+"_serchform_tab_tr_td_"+i+"_label").attr("style","display: none;");
				
				//创建控件
				/*creatHtml({
					father:obj.id+"_serchform_tab_tr_td_"+i+"_label",
					type:"label",
					text:n.label,
					id:n.id+"label"
				});*/
				
				//每次在最后一行的的一个空的TD里面添加控件  设置ID是为了获取控件
				$("#"+obj.id+"_serchform_tab > tbody > tr:last > td:empty:first").attr("id",obj.id+"_serchform_tab_tr_td_"+i+"_input");
				//创建控件
				n.father=obj.id+"_serchform_tab_tr_td_"+i+"_input";
				//creatHtml(n);
				if("datebox"==n.type){
					//日期控件
					n.editable = false;
					Ec.datebox(n);
				}else if("combobox"==n.type){
					//下拉框
					n.editable = n.editable||false;
					Ec.combobox(n);
				}else if("combogrid"==n.type){
					Ec.combogrid(n);
				}else if("combotree"==n.type){
					Ec.combotree(n);
				}else if("numberbox"==n.type){
					//数字框
					Ec.numberbox(n);
				}else{
					//普通控件
					Ec.textbox(n);
				}
				
				
			});
			$("#"+obj.id+"_serchform_tab").append("<tr style='display:none'><td></td colspan='4'>"+hiddenFormbtn+"</td></tr>");		
			
			//创建查询按钮和重置按钮 TO FORM
			Ec.linkbutton({
				father:"bgtab_td_2",
				text:'查询',
				click:fromSub,
				id:obj.id+"_serchform_sub",
				style:"vertical-align: bottom;",
				plain:true,
				iconCls:'icon-search'
				
			});//创建查询按钮和重置按钮 TO FORM
			
			Ec.linkbutton({
				father:"bgtab_td_2",
				text:'重置',
				click:fromReset,
				id:obj.id+"_serchform_reset",
				style:"vertical-align:bottom;",
				plain:true,
				iconCls:'icon-reload'
			});
			
			//往FORM 里面添加deleteFileKey
			creatHtml({
				father:obj.id+"_serchform",
				type:"hidden",
				id:"deleteFileKey",
				value:obj.deleteFileKey
			});
			
		}
		
		//如果有指定地址，就加载地址的数据，没有的话，就根据SQLKEY来跳转到公用方法。
		if(obj.dataGridLoadUrl){
			obj.url = obj.dataGridLoadUrl;
		}else{
			obj.url = "";
		}
		
		if(obj.editUrl){
			//如果还没有定义单机事件才绑定单机事件，如果用户自己已经定义了单机事件，用用户自己的。
			if(!obj.onClickCell){
				//如果有绑定二级页面才激活单机事件
				obj.onClickCell = function(rowIndex, field, value){
					//编辑事件
					cellClick(rowIndex, field, value,getRootPath()+obj.editUrl);
				}
			}
			
		}
		
		
		//logPrint(obj);
		$("#"+obj.id.replace("_tbdiv","")).datagrid(obj);
		//提供一个获取当前dagagrid的方法
		getDataGrid=function(){
			return $("#"+obj.id);
		}
		
		//回调函数
		if(obj.backfun){
			obj.backfun.call();
		}
		
		//添加回车监听事件给查询表单
		$("#"+obj.id+"_serchform").keydown(function(event){
			if(event.keyCode==13){
				//提交查询
				$("#"+obj.id+"_serchform_sub").click();
			}
		});
		
		//如果不需要显示的话执行下点击事件，这样是比较消耗性能的。
		if(!searchFormOpenClick){
			$("#"+obj.id+"_search_img").click();
		}
		
		
	}
	
	//创建treegrid对象。必须项  id url columns
	Ec.treegrid = function(obj){
		
		obj.type="table";
		//创建HTML元素
		creatHtml(obj);
		//设置默认属性
		obj.striped = obj.striped||true;					//斑马线
		obj.pagination = obj.pagination||false;				//分页
		obj.loadMsg = obj.loadMsg||"拼命加载中...";
		obj.rownumbers = obj.rownumbers||true;				//行数
		obj.nowrap = obj.nowrap||false;						//是否显示在同一行中  
		obj.selectOnCheck = obj.selectOnCheck||false; 		//单击复选框是否选择行
		obj.checkOnSelect = obj.checkOnSelect||false; 		//单击行是否选中复选框
		obj.pageSize = obj.pageSize||15;					//一页显示多少行
		obj.pageList = obj.pageList||[10,15,20,25,50,100]; 	//分页行数选择列表
		obj.onLoadSuccess = obj.onLoadSuccess||loadSuccess;	//数据加载成功后触发事件
		obj.fit = obj.fit==undefined?true:obj.fit;							//datagrid自动填充body那么大
		obj.fitColumns = obj.fitColumns==undefined?true:obj.fitColumns;				//是否列宽自动调整大小，自动铺满。
		obj.form_btn = obj.form_btn||{};					//把from初始化。
		obj.tb_tbn = obj.tb_tbn||{};						//初始化tb_tbn
		obj.singleSelect = obj.singleSelect||true;			//如果为true，则只允许选择一行。
		obj.selectFileKey = obj.selectFileKey||"";			//查询的sql主键
		obj.deleteFileKey = obj.deleteFileKey||"";			//删除的SQL主键
		var searchFormOpenClick = obj.searchFormOpen==undefined?true:obj.searchFormOpen;	//通过执行click事件来控制初始化的时候是隐藏还是显示，这样对外的接口就不需要改变了
		obj.searchFormOpen = true;		                    //是否打开查询界面 默认是打开 值：false(关闭) true(打开)
		var hidParams = obj.queryParams || "";              //查询时是否追加默认条件
		obj.appid = obj.appid || "";                        //应用ID
		obj.creator = obj.creator || "";                    //数据创建人字段名 
		obj.frozenColumns=obj.frozenColumns ||"";
		//设置工具条
		if(obj.toolbar!=false){
			//1、创建一个DIV容器
			creatHtml({
				type:"div",
				id:obj.id+"_tbdiv",
				style:'padding:0px;height:auto'
			});
			obj.toolbar = "#"+obj.id+"_tbdiv";
			//2、创建tb_btn容器 在 DIV容器
			creatHtml({
				father:obj.id+"_tbdiv",
				type:"div",
				id:obj.id+"_tbdiv_btndiv",
				style:'height:auto;'
			});
			
			//往容放查询条件的DIV插入一个图片
			creatHtml({
				father:obj.id+"_tbdiv",
				type:"img",
				style:"position:absolute;float:right;z-index:100;right:5px;top:5px;cursor:pointer",
				src:obj.searchFormOpen?(getRootPath()+"/resources/js/easyui/img/icon/shang.png"):(getRootPath()+"/resources/js/easyui/img/icon/xia.png"),
				click:"searchImgClick(this)",
				title:"关/开",
				id:obj.id+"_search_img"
			});
			
			//3、创建from查询条件容器 在 DIV容器
			creatHtml({
				father:obj.id+"_tbdiv",
				type:"form",
				id:obj.id+"_serchform",
				style:'margin:0;background-color:#FFFFFF;'+(obj.searchFormOpen?"display:block":"display:none")
			});
			
			//3.1 往一级DIV _tbdiv里面添加 隐藏的打印DIV
			creatHtml({
				father:obj.id+"_tbdiv",
				type:"div",
				id:obj.id+"_printDIV",
				style:'display: none;text-align: center;'
			});
			
			//4、往tb_btn容器添加添加按钮
			$.each(obj.tb_tbn,function(i,n){
				if(n.id=="add"){
					//新增按钮
					n.click=function(){
								openWin(getRootPath()+obj.editUrl,n.text);
							}
				}else if(n.id=="del"){
					//删除按钮
					n.click=delTy;
				}else{
					n.click=eval(n.click);
				}
				n.father=obj.id+"_tbdiv_btndiv";
				Ec.linkbutton(n);
			});
			

			//往form里面添加table 背景 
			creatHtml({
				father:obj.id+"_serchform",
				type:"table",
				style:"display:inline;",
				id:obj.id+"_serchform_tab_bgtab",
				clazs:'tab2'
			});
			
			//往背景TAB 里面添加内容
			$("#"+obj.id+"_serchform_tab_bgtab").append("<tr><td id='bgtab_td_1' ></td><td id='bgtab_td_2'></td></tr>");
			
			
			//5、往table背景布局里面添加table
			creatHtml({
				father:"bgtab_td_1",
				type:"table",
				style:"display:inline;",
				id:obj.id+"_serchform_tab",
				clazs:'tab2'
			});
			
			//6、往table里面添加查询条件
			var hiddenFormbtn="";

			//查询追加默认值
			if(hidParams!=""){
				for(var hkey in hidParams) {
				    hiddenFormbtn+="<input type='hidden' name='"+hkey+"' value='"+hidParams[hkey]+"'/>";
				}
			}
			
			$.each(obj.form_btn,function(i,n){
				//隐藏数据属性
				if("hidden"==n.type){
					hiddenFormbtn+="<input type='"+n.type+"' name='"+n.name+"' value='"+n.value+"'/>";
				    
					return true;
				}
				
				//第一次和第四个元素的倍数新增一行
				if(i==0||i%4==0){
					$("#"+obj.id+"_serchform_tab").append("<tr><td></td><td></td><td></td><td></td></tr>");
				}
				//每次在最后一行的的一个空的TD里面添加控件  设置ID是为了获取控件
				//$("#"+obj.id+"_serchform_tab > tbody > tr:last > td:empty:first").attr("id",obj.id+"_serchform_tab_tr_td_"+i+"_label");
				
				//创建控件
				/*creatHtml({
					father:obj.id+"_serchform_tab_tr_td_"+i+"_label",
					type:"label",
					text:n.label,
					id:n.id+"label"
				});*/
				
				//每次在最后一行的的一个空的TD里面添加控件  设置ID是为了获取控件
				$("#"+obj.id+"_serchform_tab > tbody > tr:last > td:empty:first").attr("id",obj.id+"_serchform_tab_tr_td_"+i+"_input");
				//创建控件
				n.father=obj.id+"_serchform_tab_tr_td_"+i+"_input";
				//creatHtml(n);
				if("datebox"==n.type){
					//日期控件
					n.editable = false;
					Ec.datebox(n);
				}else if("combobox"==n.type){
					//下拉框
					n.editable = n.editable||false;
					Ec.combobox(n);
				}else if("combogrid"==n.type){
					Ec.combogrid(n);
				}else if("combotree"==n.type){
					Ec.combotree(n);
				}else if("numberbox"==n.type){
					//数字框
					Ec.numberbox(n);
				}else{
					//普通控件
					Ec.textbox(n);
				}
				
				
			});
			$("#"+obj.id+"_serchform_tab").append("<tr style='display:none'><td></td colspan='4'>"+hiddenFormbtn+"</td></tr>");		
			
			//创建查询按钮和重置按钮 TO FORM
			Ec.linkbutton({
				father:"bgtab_td_2",
				text:'查询',
				click:fromTreeSub,
				id:obj.id+"_serchform_sub",
				style:"vertical-align: bottom;",
				plain:true,
				iconCls:'icon-search'
				
			});//创建查询按钮和重置按钮 TO FORM
			
			Ec.linkbutton({
				father:"bgtab_td_2",
				text:'重置',
				click:fromReset,
				id:obj.id+"_serchform_reset",
				style:"vertical-align:bottom;",
				plain:true,
				iconCls:'icon-reload'
			});
			
			//往FORM 里面添加deleteFileKey
			creatHtml({
				father:obj.id+"_serchform",
				type:"hidden",
				id:"deleteFileKey",
				value:obj.deleteFileKey
			});
			
		}
		
		//如果有指定地址，就加载地址的数据，没有的话，就根据SQLKEY来跳转到公用方法。
		if(obj.treeGridLoadUrl){
			obj.url = obj.treeGridLoadUrl;
		}else{
			obj.url = "";
		}
		
		if(obj.editUrl){
			//如果还没有定义单机事件才绑定单机事件，如果用户自己已经定义了单机事件，用用户自己的。
			if(!obj.onClickCell){
				//如果有绑定二级页面才激活单机事件
				obj.onClickCell = function(rowIndex, field, value){
					//编辑事件
					cellClick(rowIndex, field, value,getRootPath()+obj.editUrl);
				}
			}
			
		}
		
		
		//logPrint(obj);
		$("#"+obj.id.replace("_tbdiv","")).treegrid(obj);
		//提供一个获取当前dagagrid的方法
		getTreeGrid=function(){
			return $("#"+obj.id);
		}
		
		//回调函数
		if(obj.backfun){
			obj.backfun.call();
		}
		
		//添加回车监听事件给查询表单
		$("#"+obj.id+"_serchform").keydown(function(event){
			if(event.keyCode==13){
				//提交查询
				$("#"+obj.id+"_serchform_sub").click();
			}
		});
		
		//如果不需要显示的话执行下点击事件，这样是比较消耗性能的。
		if(!searchFormOpenClick){
			$("#"+obj.id+"_search_img").click();
		}
		
		
	}
	
	
	
	Ec.alert = function(msg){
		$.messager.alert("消息提醒",msg);
	}
	//创建linkbutton方法
	Ec.linkbutton = function(obj){
		//设置创建的HTML类型
		obj.type="a";
		//创建HTML对象
		creatHtml(obj);
		//渲染HTML对象成easyui控件
		$("#"+obj.id).linkbutton(obj);
		obj.type="linkbutton";
		
	}
	Ec.textbox=function(obj){
		//设置创建的HTML类型
		obj.type="input";
		//创建HTML对象
		creatHtml(obj);
		//渲染HTML对象成easyui控件
		$("#"+obj.id).textbox(obj);
		obj.type="textbox";
	}
	Ec.datebox=function(obj){
		//设置创建的HTML类型
		obj.type="input";
		//创建HTML对象
		creatHtml(obj);
		//渲染HTML对象成easyui控件
		$("#"+obj.id).datebox(obj);
		obj.type="datebox";
	}
	Ec.combobox=function(obj){
		//设置创建的HTML类型
		obj.type="input";
		//创建HTML对象
		creatHtml(obj);
		//渲染HTML对象成easyui控件
		$("#"+obj.id).combobox(obj);
		obj.type="combobox";
	}
	Ec.combotree=function(obj){
		//设置创建的HTML类型
		obj.type="input";
		//创建HTML对象
		creatHtml(obj);
		//渲染HTML对象成easyui控件
		$("#"+obj.id).combotree(obj);
		obj.type="combotree";
	}
	Ec.combogrid=function(obj){
		//设置创建的HTML类型
		obj.type="input";
		//创建HTML对象
		creatHtml(obj);
		//渲染HTML对象成easyui控件
		$("#"+obj.id).combogrid(obj);
		obj.type="combogrid";
	}
	
	Ec.numberbox=function(obj){
		//设置创建的HTML类型
		obj.type="input";
		//创建HTML对象
		creatHtml(obj);
		//渲染HTML对象成easyui控件
		$("#"+obj.id).numberbox(obj);
		obj.type="numberbox";
	}
	
	Ec.show = function(msg){
		$.messager.show({
			title:'消息提醒',
			msg:msg,
			timeout:3000,
			showType:'slide'
		});
		
	}
	
	Ec.draggable = function(obj){
		obj.type="img";
		creatHtml(obj);
		$('#'+obj.id).draggable(obj); 
	}
	Ec.pk = function(obj){
		obj.type="pk";
		creatHtml(obj);
	}
	
	//生成UUID
	var CHARS = '0123456789abcdefghijklmnopqrstuvwxyz'.split('');
	Ec.uuid = function () {
	    var chars = CHARS, uuid = [], i;
	    for (i = 0; i < 32; i++){
	    	uuid[i] = chars[0 | Math.random()*36];
	    }
	    return uuid.join('');
	};
		
});
