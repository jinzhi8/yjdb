/**
 * name: formSelects
 * 基于Layui Select多选
 * version: 4.0.0.0622
 * http://sun.faysunshine.com/layui/formSelects-v4/dist/formSelects-v4.js
 */
(function(layui, window, factory) {
	if(typeof exports === 'object') { // 支持 CommonJS
		module.exports = factory();
	} else if(typeof define === 'function' && define.amd) { // 支持 AMD
		define(factory);
	} else if(window.layui && layui.define) { //layui加载
		layui.define(['jquery'], function(exports) {
			exports('formSelects', factory());
		});
	} else {
		window.formSelects = factory();
	}
})(typeof layui == 'undefined' ? null : layui, window, function() {
	let v = '4.0.0.0622',
		NAME = 'xm-select',
		PNAME = 'xm-select-parent',
		INPUT = 'xm-select-input',
		TDIV = 'xm-select--suffix',
		THIS = 'xm-select-this',
		LABEL = 'xm-select-label',
		SEARCH = 'xm-select-search',
		CREATE = 'xm-select-create',
		CREATE_LONG = 'xm-select-create-long',
		MAX = 'xm-select-max',
		SKIN = 'xm-select-skin',
		DIRECTION = "xm-select-direction",
		HEIGHT = 'xm-select-height',
		DISABLED = 'xm-dis-disabled',
		DIS = 'xm-select-dis',
		TEMP = 'xm-select-temp',
		RADIO = 'xm-select-radio',
		LINKAGE= 'xm-select-linkage',
		DL = 'xm-select-dl',
		HIDE_INPUT = 'xm-hide-input',
		SANJIAO = 'xm-select-sj',
		ICON_CLOSE = 'xm-icon-close',
		FORM_TITLE = 'xm-select-title',
		FORM_SELECT = 'xm-form-select',
		FORM_SELECTED = 'xm-form-selected',
		FORM_NONE = 'xm-select-none',
		FORM_EMPTY = 'xm-select-empty',
		FORM_INPUT = 'xm-input',
		FORM_SELECT_TIPS = 'xm-select-tips',
		CHECKBOX_YES = 'xm-icon-yes',
		CZ = 'xm-cz',
		CZ_GROUP = 'xm-cz-group',
		TIPS = '请选择',
		data = {},
		events = {
			on: {},
			filter: {},
			maxTips: {},
		},
		ajax = {
			type: 'get',
			header: {

			},
			first: true,
			data: {},
			searchUrl: '',
			searchName: 'keyword',
			searchVal: null,
			keyName: 'name',
			keyVal: 'value',
			keySel: 'selected',
			keyDis: 'disabled',
			keyChildren: 'children',
			dataType: '',
			delay: 500,
			beforeSuccess: null,
			success: null,
			error: null,
			beforeSearch: null,
			clearInput: false,
		},
		quickBtns = [
			{icon: 'iconfont icon-quanxuan', name: '全选', click: function(id, cm){
				cm.selectAll(id, true, true);
			}},
			{icon: 'iconfont icon-qingkong', name: '清空', click: function(id, cm){
				cm.removeAll(id, true, true);
			}},
			{icon: 'iconfont icon-fanxuan', name: '反选', click: function(id, cm){
				cm.reverse(id, true, true);
			}},
			{icon: 'iconfont icon-pifu', name: '换肤', click: function(id, cm){
				cm.skin(id);
			}}
		],
		$ = window.$ || (window.layui && window.layui.jquery),
		$win = $(window),
		ajaxs = {},
		FormSelects = function(options) {
			this.config = {
				name: null, //xm-select="xxx"
				max: null,
				maxTips: (vals, val, max) => {
					let ipt = $(`[xid="${this.config.name}"]`).prev().find(`.${NAME}`);
					if(ipt.parents('.layui-form-item[pane]').length) {
						ipt = ipt.parents('.layui-form-item[pane]');
					}
					ipt.attr('style', 'border-color: red !important');
					setTimeout(() => {
						ipt.removeAttr('style');
					}, 300);
				},
				init: null, //初始化的选择值,
				on: null, //select值发生变化
				filter: (id, inputVal, val, isDisabled) => {
					return val.name.indexOf(inputVal) == -1;
				},
				clearid: -1,
				direction: 'auto',
				height: null,
				isEmpty: false,
				btns: [quickBtns[0], quickBtns[1], quickBtns[2]]
			};
			this.select = null;
			this.values = [];
			$.extend(true, this.config, options);
		};
	
	//一些简单的处理方法
	let Common = function(){
		this.loadingCss();
		this.appender();
		this.init();
		this.on();
		this.initVal();
		this.onreset();
		this.listening();
	};
	
	Common.prototype.appender = function(){//针对IE做的一些拓展
		if (!Array.prototype.map) {
		    Array.prototype.map = function(callback, thisArg) {
		        var T, A, k, 
		        	O = Object(this),
		        	len = O.length >>> 0;
		        if (thisArg) {
		            T = thisArg;
		        }
		        A = new Array(len);
		        k = 0;
		        while(k < len) {
		            var kValue, mappedValue;
		            if (k in O) {
		                kValue = O[ k ];
		                mappedValue = callback.call(T, kValue, k, O);
		                A[ k ] = mappedValue;
		            }
		            k++;
		        }
		        return A;
		    };
		}
		if ( !Array.prototype.forEach ) {
		    Array.prototype.forEach = function forEach( callback, thisArg ) {
		        var T, k;
		        if ( this == null ) {
		            throw new TypeError( "this is null or not defined" );
		        }
		        var O = Object(this);
		        var len = O.length >>> 0;
		        if ( typeof callback !== "function" ) {
		            throw new TypeError( callback + " is not a function" );
		        }
		        if ( arguments.length > 1 ) {
		            T = thisArg;
		        }
		        k = 0;
		        while( k < len ) {
		            var kValue;
		            if ( k in O ) {
		
		                kValue = O[ k ];
		                callback.call( T, kValue, k, O );
		            }
		            k++;
		        }
		    };
		}
	}
	
	Common.prototype.init = function(target){
		//初始化页面上已有的select
		$((target ? target : `select[${NAME}]`)).each((index, select) => {
			let othis = $(select),
				id = othis.attr(NAME),
				hasRender = othis.next(`.layui-form-select`),
				disabled = select.disabled,
				max = othis.attr(MAX) - 0,
				isSearch = othis.attr(SEARCH) != undefined,
				searchUrl = isSearch ? othis.attr(SEARCH) : null,
				isCreate = othis.attr(CREATE) != undefined,
				isRadio =  othis.attr(RADIO) != undefined,
				skin = othis.attr(SKIN),
				direction = othis.attr(DIRECTION),
				optionsFirst = select.options[0],
				height = othis.attr(HEIGHT),
				formname = othis.attr('name'),
				layverify = othis.attr('lay-verify'),
				placeholder = optionsFirst ? (
						optionsFirst.value ? TIPS : (optionsFirst.innerHTML || TIPS)
					) : TIPS,
				value = othis.find('option[selected]').toArray().map((option) => {//获取已选中的数据
					return {
						name: option.innerHTML,
						val: option.value,
					}
				}),
				fs = new FormSelects();
				data[id] = fs;
			//先取消layui对select的渲染
			hasRender[0] && hasRender.remove();
			
			//包裹一个div
			othis.wrap(`<div class="${PNAME}"></div>`);

			//构造渲染div
			let dinfo = this.renderSelect(id, placeholder, select); 
			let heightStyle = height ? `style="height: ${height};"` : '';
			let inputHtml =  height ? [
				`<div class="${LABEL}" style="margin-right: 50px;"></div>`,
				`<input type="text" fsw class="${FORM_INPUT} ${INPUT}" ${isSearch ? '' : 'style="display: none;"'} autocomplete="off" debounce="0" style="position: absolute;right: 10px;top: 3px;"/>`
			] : [
				`<div class="${LABEL}">`,
					`<input type="text" fsw class="${FORM_INPUT} ${INPUT}" ${isSearch ? '' : 'style="display: none;"'} autocomplete="off" debounce="0" />`,
				`</div>`
			];
			let reElem =
				$(`<div class="${FORM_SELECT}" ${SKIN}="${skin}">
					<input type="hidden" class="${HIDE_INPUT}" value="" name="${formname}" lay-verify="${layverify}"/>
					<div class="${FORM_TITLE} ${disabled ? DIS : ''}">
						<div class="${FORM_INPUT} ${NAME}" ${heightStyle}>
							${inputHtml.join('')}
							<i class="${SANJIAO}"></i>
						</div>
						<div class="${TDIV}">
							<input type="text" autocomplete="off" placeholder="${placeholder}" readonly="readonly" unselectable="on" class="${FORM_INPUT}">
						</div>
						<div></div>
					</div>
					<dl xid="${id}" class="${DL} ${isRadio ? RADIO:''}">${dinfo}</dl>
				</div>`);
			othis.after(reElem);
			fs.select = othis.remove();//去掉layui.form.render
			fs.values = value;
			fs.config.name = id;
			fs.config.init = value.concat([]);
			fs.config.direction = direction;
			fs.config.height = height;
			fs.config.radio = isRadio;
			
			if(max){//有最大值
				fs.config.max = max;
			}
			
			//如果可搜索, 加上事件
			if(isSearch){
				reElem.find(`.${INPUT}`).on('input propertychange', (e) => {
					let input = e.target,
						inputValue = $.trim(input.value),
						keyCode = e.keyCode;
					if(keyCode === 9 || keyCode === 13 || keyCode === 37 || keyCode === 38 || keyCode === 39 || keyCode === 40) {
						return false;
					}
					
					//过滤一下tips
					this.changePlaceHolder($(input));
					
					let ajaxConfig = ajaxs[id] ? ajaxs[id] : ajax;
					searchUrl = ajaxConfig.searchUrl || searchUrl;
					//如果开启了远程搜索
					if(searchUrl){
						if(ajaxConfig.searchVal){
							inputValue = ajaxConfig.searchVal;
							ajaxConfig.searchVal = '';
						}
						if(!ajaxConfig.beforeSearch || (ajaxConfig.beforeSearch && ajaxConfig.beforeSearch instanceof Function && ajaxConfig.beforeSearch(id, searchUrl, inputValue))){
							let delay = ajaxConfig.delay;
							if(ajaxConfig.first){
								ajaxConfig.first = false;
								delay = 10;
							}
							clearTimeout(fs.clearid);
							fs.clearid = setTimeout(() => {
								reElem.find(`dl > *:not(.${FORM_SELECT_TIPS})`).remove();
								reElem.find(`dd.${FORM_NONE}`).addClass(FORM_EMPTY).text('请求中');
								this.ajax(id, searchUrl, inputValue, false, null, true);
							}, delay);
						}
					}else{
						reElem.find(`dl .layui-hide`).removeClass('layui-hide');
						//遍历选项, 选择可以显示的值
						reElem.find(`dl dd:not(.${FORM_SELECT_TIPS})`).each((idx, item) => {
							let _item = $(item);
							let searchFun = data[id].config.filter || events.filter[id];
							if(searchFun && searchFun(id, inputValue, {
								name: _item.find('span').text(),
								val: _item.attr('lay-value')
							}, _item.hasClass(DISABLED)) == true){
								_item.addClass('layui-hide');
							}
						});
						//控制分组名称
						reElem.find('dl dt').each((index, item) => {
							if(!$(item).nextUntil('dt', ':not(.layui-hide)').length) {
								$(item).addClass('layui-hide');
							}
						});
						//动态创建
						this.create(id, isCreate, inputValue);
						let shows = reElem.find(`dl dd:not(.${FORM_SELECT_TIPS}):not(.layui-hide)`);
						if(!shows.length){
							reElem.find(`dd.${FORM_NONE}`).addClass(FORM_EMPTY).text('无匹配项');
						}else{
							reElem.find(`dd.${FORM_NONE}`).removeClass(FORM_EMPTY);
						}
					}
				});
				if(searchUrl){//触发第一次请求事件
					this.triggerSearch(reElem, true);
				}
			}
		});
	}
	
	Common.prototype.isArray = function(obj){
		return Object.prototype.toString.call(obj) == "[object Array]";
	}
	
	Common.prototype.triggerSearch = function(div, isCall){
		(div ? [div] : $(`.${FORM_SELECT}`).toArray()).forEach((reElem, index) => {
			reElem = $(reElem);
			let id = reElem.find('dl').attr('xid')
			if((id && data[id] && data[id].config.isEmpty) || isCall){
				let obj_caller = reElem.find(`.${INPUT}`)[0];
				if(document.createEventObject) {
				    obj_caller.fireEvent("onchange");
				} else {
				    var evt = document.createEvent("HTMLEvents");
				    evt.initEvent("input", false, true);
				    obj_caller.dispatchEvent(evt);
				}
			}
		});
	}
	
	Common.prototype.ajax = function(id, searchUrl, inputValue, isLinkage, linkageWidth, isSearch){
		let reElem = $(`.${PNAME} dl[xid="${id}"]`).parents(`.${FORM_SELECT}`);
		if(!reElem[0] || !searchUrl){
			return ;
		}
		
		let ajaxConfig = ajaxs[id] ? ajaxs[id] : ajax;
		let ajaxData = $.extend(true, {}, ajaxConfig.data);
		ajaxData[ajaxConfig.searchName] = inputValue;
		ajaxData['_'] = Date.now();
		$.ajax({
			type: ajaxConfig.type,
			headers: ajaxConfig.header,
			url: searchUrl,
			data: ajaxConfig.dataType == 'json' ? JSON.stringify(ajaxData) : ajaxData,
			success: (res) => {
				if(typeof res == 'string'){
					res = JSON.parse(res);
				}
				ajaxConfig.beforeSuccess && ajaxConfig.beforeSuccess instanceof Function && (res = ajaxConfig.beforeSuccess(id, searchUrl, inputValue, res));
				if(this.isArray(res)){
					res = {
						code: 0,
						msg: "",
						data: res,
					}
				}
				if(res.code != 0){
					reElem.find(`dd.${FORM_NONE}`).addClass(FORM_EMPTY).text(res.msg);
				}else{
					reElem.find(`dd.${FORM_NONE}`).removeClass(FORM_EMPTY);
					//获得已选择的values
					this.renderData(id, res.data, isLinkage, linkageWidth, isSearch);
					data[id].config.isEmpty = res.data.length == 0;
				}
				ajaxConfig.success && ajaxConfig.success instanceof Function && ajaxConfig.success(id, searchUrl, inputValue, res);
			},
			error: (err) => {
				reElem.find(`dd[lay-value]:not(.${FORM_SELECT_TIPS})`).remove();
				reElem.find(`dd.${FORM_NONE}`).addClass(FORM_EMPTY).text('服务异常');
				ajaxConfig.error && ajaxConfig.error instanceof Function && ajaxConfig.error(id, searchUrl, inputValue, err);
			}
		});
	}
	
	Common.prototype.renderData = function(id, dataArr, linkage, linkageWidth, isSearch){
		if(linkage){//渲染多级联动
			let result = [],
				index = 0,
				temp = {"0": dataArr},
				ajaxConfig = ajaxs[id] ? ajaxs[id] : ajax;
			do{
				let group = result[index ++] = [],
					_temp = temp;
				temp = {};
				$.each(_temp, (pid, arr) => {
					$.each(arr, (idx, item) => {
						let val = {
							pid: pid,
							name: item[ajaxConfig.keyName],
							val: item[ajaxConfig.keyVal],
						};
						group.push(val);
						let children = item[ajaxConfig.keyChildren];
						if(children && children.length){
							temp[val.val] = children;
						}
					});
				});
			}while(Object.getOwnPropertyNames(temp).length);
			
			let reElem = $(`.${PNAME} dl[xid="${id}"]`).parents(`.${FORM_SELECT}`);
			let html = ['<div class="xm-select-linkage">'];
			
			$.each(result, (idx, arr) => {
				let groupDiv = [`<div style="left: ${(linkageWidth-0) * idx}px;" class="xm-select-linkage-group xm-select-linkage-group${idx + 1} ${idx != 0 ? 'xm-select-linkage-hide':''}">`];
				$.each(arr, (idx2, item) => {
					let span = `<li title="${item.name}" pid="${item.pid}" value="${item.val}"><span>${item.name}</span></li>`;
					groupDiv.push(span);
				});
				groupDiv.push(`</div>`);
				html = html.concat(groupDiv);
			});
//			<li class="xm-select-this xm-select-active"><span>123</span></li>
			html.push('<div style="clear: both; height: 288px;"></div>');
			html.push('</div>');
			reElem.find('dl').html(html.join(''));
			reElem.find(`.${INPUT}`).css('display', 'none');//联动暂时不支持搜索
			return;
		}
		
		
		let reElem = $(`.${PNAME} dl[xid="${id}"]`).parents(`.${FORM_SELECT}`);
		let ajaxConfig = ajaxs[id] ? ajaxs[id] : ajax;
		let pcInput = reElem.find(`.${TDIV} input`);
		
		let values = [];
		reElem.find('dl').html(this.renderSelect(id, pcInput.attr('placeholder') || pcInput.attr('back'), dataArr.map((item) => {
			if(item[ajaxConfig.keySel]){
				values.push({
					name: item[ajaxConfig.keyName],
					val: item[ajaxConfig.keyVal],
				});
			}
			return {
				innerHTML: item[ajaxConfig.keyName],
				value: item[ajaxConfig.keyVal],
				sel: item[ajaxConfig.keySel],
				disabled: item[ajaxConfig.keyDis],
				type: item.type,
				name: item.name
			}
		})));
		
		let label = reElem.find(`.${LABEL}`);
		let dl = reElem.find('dl[xid]');
		if(isSearch){//如果是远程搜索, 这里需要判重
			let oldVal = data[id].values;
			oldVal.forEach((item, index) => {
				dl.find(`dd[lay-value="${item.val}"]`).addClass(THIS);
			});
			values.forEach((item, index) => {
				if(this.indexOf(oldVal, item) == -1){
					this.addLabel(id, label, item);
					dl.find(`dd[lay-value="${item.val}"]`).addClass(THIS);
					oldVal.push(item);
				}
			});
		}else{
			values.forEach((item, index) => {
				this.addLabel(id, label, item);
				dl.find(`dd[lay-value="${item.val}"]`).addClass(THIS);
			});
			data[id].values = values;
		}
		this.commonHanler(id, label);
	}
	
	Common.prototype.create = function(id, isCreate, inputValue){
		if(isCreate && inputValue){
			let fs = data[id],
				dl = $(`[xid="${id}"]`),
				tips=  dl.find(`dd.${FORM_SELECT_TIPS}:first`),
				tdd = null,
				temp = dl.find(`dd.${TEMP}`);
			dl.find(`dd:not(.${FORM_SELECT_TIPS}):not(.${TEMP})`).each((index, item) => {
				if(inputValue == $(item).find('span').text()){
					tdd = item;
				}
			});
			if(!tdd){//如果不存在, 则创建
				if(temp[0]){
					temp.attr('lay-value', inputValue);
					temp.find('span').text(inputValue);
					temp.removeClass('layui-hide');
				}else{
					tips.after($(this.createDD({
						innerHTML: inputValue,
						value: Date.now(),
					}, `${TEMP} ${CREATE_LONG}`)));
				}
			}
		}else{
			$(`[xid=${id}] dd.${TEMP}`).remove();
		}
	}
	
	Common.prototype.createDD = function(item, clz){
		return `<dd lay-value="${item.value}" class="${item.disabled ? DISABLED : ''} ${clz ? clz : ''}">
					<div class="xm-unselect xm-form-checkbox ${item.disabled ? 'layui-checkbox-disbaled ' + DISABLED : ''}" lay-skin="primary">
						<span>${$.trim(item.innerHTML)}</span>
						<i class="${CHECKBOX_YES}"></i>
					</div>
				</dd>`;
	}
	
	Common.prototype.createQuickBtn = function(obj, right){
		return `<div class="${CZ}" method="${obj.name}" title="${obj.name}" ${right ? 'style="margin-right: ' + right + '"': ''}><i class="${obj.icon}"></i><span>${obj.name}</span></div>`
	}
	
	Common.prototype.renderBtns = function(id, show, right){
		let quickBtn = [];
		let dl = $(`dl[xid="${id}"]`);
		quickBtn.push(`<div class="${CZ_GROUP}" show="${show}" style="max-width: ${dl.prev().width() - 54}px;">`);
		$.each(data[id].config.btns, (index, item) => {
			quickBtn.push(this.createQuickBtn(item, right));
		});
		quickBtn.push(`</div>`);
		quickBtn.push(this.createQuickBtn({icon: 'iconfont icon-caidan', name: ''}));
		return quickBtn.join('');
	}
	
	Common.prototype.renderSelect = function(id, tips, select){
		
		let arr = [];
		if(data[id].config.btns.length){
			setTimeout(() => {
				let dl = $(`dl[xid="${id}"]`);
				dl.find(`.${CZ_GROUP}`).css('max-width', `${dl.prev().width() - 54}px`);
			}, 10)
			arr.push([
				`<dd lay-value="" class="${FORM_SELECT_TIPS}" style="background-color: #FFF!important;">`,
				this.renderBtns(id, null, '30px'),
				`</dd>`
			].join(''));
		}else{
			arr.push(`<dd lay-value="" class="${FORM_SELECT_TIPS}">${tips}</dd>`);
		}
		if(this.isArray(select)){
			$(select).each((index, item) => {
				if(item.type === 'optgroup') {
					arr.push(`<dt>${item.name}</dt>`);
				} else {
					arr.push(this.createDD(item));
				}
			});
		}else{
			$(select).find('*').each((index, item) => {
				if(item.tagName.toLowerCase() == 'option' && index == 0 && !item.value){
					return ;
				}
				if(item.tagName.toLowerCase() === 'optgroup') {
					arr.push(`<dt>${item.label}</dt>`);
				} else {
					arr.push(this.createDD(item));
				}
			});
		}
		arr.push('<dt style="display:none;"> </dt>');
		arr.push(`<dd class="${FORM_SELECT_TIPS} ${FORM_NONE} ${arr.length === 2 ? FORM_EMPTY:''}">没有选项</dd>`);
		return arr.join('');
	}
	
	Common.prototype.on = function(){//事件绑定
		this.one();
		
		$(document).on('click', (e) => {
			if(!$(e.target).parents(`.${FORM_TITLE}`)[0]){//清空input中的值
				$(`.${INPUT}`).val('');
				$(`.${PNAME} dl .layui-hide`).removeClass('layui-hide');
				$(`.${PNAME} dl dd.${TEMP}`).remove();
				this.triggerSearch();
			}
			$(`.${PNAME} .${FORM_SELECTED}`).removeClass(FORM_SELECTED);
		});
		
	}
	
	Common.prototype.one = function(target){//一次性事件绑定
		$(target ? target : document).find(`.${FORM_TITLE}`).off('click').on('click', (e) => {
			let othis = $(e.target),
				title = othis.is(FORM_TITLE) ? othis : othis.parents(`.${FORM_TITLE}`),
				dl = title.next(),
				id = dl.attr('xid');
			
			//清空非本select的input val
			$(`dl[xid]`).not(dl).prev().find(`.${INPUT}`).val('');
			$(`dl[xid]`).not(dl).find(`dd.layui-hide`).removeClass('layui-hide');
			
			//如果是disabled select
			if(title.hasClass(DIS)){
				return false;
			}
			//如果点击的是右边的三角或者只读的input
			if(othis.is(`.${SANJIAO}`) || othis.is(`.${INPUT}[readonly]`)){
				this.changeShow(title, !title.parents(`.${FORM_SELECT}`).hasClass(FORM_SELECTED));
				return false;
			}
			//如果点击的是input的右边, focus一下
			if(title.find(`.${INPUT}:not(readonly)`)[0]){
				let input = title.find(`.${INPUT}`),
					epos = {x: e.pageX, y: e.pageY},
					pos = this.getPosition(title[0]),
					width = title.width();
				while(epos.x > pos.x){
					if($(document.elementFromPoint(epos.x, epos.y)).is(input)){
						input.focus();
						this.changeShow(title, true);
						return false;
					}
					epos.x -= 50;
				}
			}
			
			//如果点击的是可搜索的input
			if(othis.is(`.${INPUT}`)){
				this.changeShow(title, true);
				return false;
			}
			//如果点击的是x按钮
			if(othis.is(`i[fsw="${NAME}"]`)){
				let val = {
					name: othis.prev().text(),
					val: othis.parent().attr("value")
				},
				dd = dl.find(`dd[lay-value='${val.val}']`);
				if(dd.hasClass(DISABLED)){//如果是disabled状态, 不可选, 不可删
					return false;
				}
				this.handlerLabel(id, dd, false, val);
				return false;
			}
			
			this.changeShow(title, !title.parents(`.${FORM_SELECT}`).hasClass(FORM_SELECTED));
			return false;
		});
		$(target ? target : document).find(`dl.${DL}`).off('click').on('click', (e) => {
			let othis = $(e.target);
			if(othis.is(`.${LINKAGE}`) || othis.parents(`.${LINKAGE}`)[0]){//linkage的处理
				othis = othis.is('li') ? othis : othis.parents('li');
				let group = othis.parents('.xm-select-linkage-group'),
					id = othis.parents('dl').attr('xid');
				//激活li
				group.find('.xm-select-active').removeClass('xm-select-active');
				othis.addClass('xm-select-active');
				//激活下一个group, 激活前显示对应数据
				group.nextAll('.xm-select-linkage-group').addClass('xm-select-linkage-hide');
				let nextGroup = group.next('.xm-select-linkage-group');
				nextGroup.find('li').addClass('xm-select-linkage-hide');
				nextGroup.find(`li[pid="${othis.attr('value')}"]`).removeClass('xm-select-linkage-hide');
				//如果没有下一个group, 或没有对应的值
				if(!nextGroup[0] || nextGroup.find(`li:not(.xm-select-linkage-hide)`).length == 0){
					let vals = [],
						index = 0,
						isAdd = !othis.hasClass('xm-select-this');
					if(data[id].config.radio){
						othis.parents('.xm-select-linkage').find('.xm-select-this').removeClass('xm-select-this');
					}
					do{
						vals[index ++] = {
							name: othis.find('span').text(),
							val: othis.attr('value')
						}
						/*isAdd ? (
							othis.addClass('xm-select-this')
						) : (
							!othis.parent('.xm-select-linkage-group').next().find(`li[pid="${othis.attr('value')}"].xm-select-this`).length && othis.removeClass('xm-select-this')
						);*/	
						othis = othis.parents('.xm-select-linkage-group').prev().find(`li[value="${othis.attr('pid')}"]`);			
					}while(othis.length);
					vals.reverse();
					let val = {
						name: vals.map((item) => {
								return item.name;
							}).join('/'),
						val: vals.map((item) => {
								return item.val;
							}).join('/'),
					}
					this.handlerLabel(id, null, isAdd, val);
				}else{
					nextGroup.removeClass('xm-select-linkage-hide');
				}
				return false;
			}//xm-select-this xm-select-active
			
			if(othis.is('dt') || othis.is('dl')){
				return false;
			}
			let dd = othis.is('dd') ? othis : othis.parents('dd');
			let id = dd.parent('dl').attr('xid');
			if(dd.hasClass(DISABLED)){//被禁用选项的处理
				return false;
			}
			if(dd.hasClass(FORM_SELECT_TIPS)){//tips的处理
				let btn = othis.is(`.${CZ}`) ? othis : othis.parents(`.${CZ}`);
				if(!btn[0]){
					return false;
				}
				//TODO 快捷操作
				let method = btn.attr('method');
				let obj = data[id].config.btns.filter(bean => bean.name == method)[0];
				obj && obj.click && obj.click instanceof Function && obj.click(id, this);
				return false;
			}
			let isAdd = !dd.hasClass(THIS);
			this.handlerLabel(id, dd, isAdd);
			return false;
		});
	}
	
	Common.prototype.linkageAdd = function(id, val){
		let dl = $(`dl[xid="${id}"]`);
		dl.find('.xm-select-active').removeClass('xm-select-active');
		let vs = val.val.split('/');
		let pid, li, index = 0;
		let lis = [];
		do{
			pid = vs[index];
			li = dl.find(`.xm-select-linkage-group${index + 1} li[value="${pid}"]`);
			li[0] && lis.push(li);
			index ++;
		}while(li.length && pid != undefined);
		if(lis.length == vs.length){
			$.each(lis, (idx, item) => {
				item.addClass('xm-select-this');
			});
		}
	}
	
	Common.prototype.linkageDel = function(id, val){
		let dl = $(`dl[xid="${id}"]`);
		let vs = val.val.split('/');
		let pid, li, index = vs.length - 1;
		do{
			pid = vs[index];
			li = dl.find(`.xm-select-linkage-group${index + 1} li[value="${pid}"]`);
			if(!li.parent().next().find(`li[pid=${pid}].xm-select-this`).length){
				li.removeClass('xm-select-this');
			}
			index --;
		}while(li.length && pid != undefined);
	}
	
	Common.prototype.valToName = function(id, val){
		let dl = $(`dl[xid="${id}"]`);
		let vs = (val + "").split('/');
		let names = [];
		$.each(vs, (idx, item) => {
			let name = dl.find(`.xm-select-linkage-group${idx + 1} li[value="${item}"] span`).text();
			names.push(name);
		});
		return names.length == vs.length ? names.join('/') : null;
	}
	
	Common.prototype.commonHanler = function(key, label){
		//计算input的提示语
		this.changePlaceHolder(label);
		//计算高度
		this.retop(label.parents(`.${FORM_SELECT}`));
		this.checkHideSpan(label);
		this.calcLeft(key, label);
		//表单默认值
		label.parents(`.${PNAME}`).find(`.${HIDE_INPUT}`).val(data[key].values.map((val) => {
			return val.val;
		}).join(','));
		//title值
		label.parents(`.${FORM_TITLE} .${NAME}`).attr('title', data[key].values.map((val) => {
			return val.name;
		}).join(','));
	}
	
	Common.prototype.initVal = function(id){
		let target = {};
		if(id){
			target[id] = data[id];
		}else{
			target = data;
		}
		$.each(target, (key, val) => {
			let values = val.values,		
				div = $(`dl[xid="${key}"]`).parent(),
				label = div.find(`.${LABEL}`),
				dl = div.find('dl');
			dl.find(`dd.${THIS}`).removeClass(THIS);
			
			let _vals = values.concat([]);
			_vals.concat([]).forEach((item, index) => {
				this.addLabel(key, label, item);
				dl.find(`dd[lay-value="${item.val}"]`).addClass(THIS);
			});
			if(val.config.radio){
				_vals.length && values.push(_vals[_vals.length - 1]);
			}
			this.commonHanler(key, label);
		});
	}
	
	Common.prototype.handlerLabel = function(id, dd, isAdd, oval, notOn){
		let div = $(`[xid="${id}"]`).prev().find(`.${LABEL}`),
			val = dd && {
				name: dd.find('span').text(),
				val: dd.attr('lay-value')
			},
			vals = data[id].values,
			on = data[id].config.on || events.on[id];
		if(oval){
			val = oval;
		}
		let fs = data[id];
		if(isAdd && fs.config.max && fs.values.length >= fs.config.max){
			let maxTipsFun = data[id].config.maxTips || events.maxTips[id];
			maxTipsFun && maxTipsFun(id, vals.concat([]), val, fs.max);
			return ;
		}
		if(!notOn){
			if(on && on instanceof Function && (on(id, vals.concat([]), val, isAdd, (dd && dd.hasClass(DISABLED) == false)))) {
				return ;
			}
		}
		let dl = $(`dl[xid="${id}"]`);
		isAdd ? (
			(dd && dd[0] ? (
				dd.addClass(THIS), 
				dd.removeClass(TEMP)
			) : (
				dl.find('.xm-select-linkage')[0] && this.linkageAdd(id, val)
			)),
			this.addLabel(id, div, val),
			vals.push(val)
		) : (
			(dd && dd[0] ? (
				dd.removeClass(THIS)
			) : (
				dl.find('.xm-select-linkage')[0] && this.linkageDel(id, val)
			)),
			this.delLabel(id, div, val),
			this.remove(vals, val)
		);
		if(!div[0]) return ;
		//单选选完后直接关闭选择域
		if(fs.config.radio){
			this.changeShow(div, false);
		}
		//移除表单验证的红色边框
		div.parents(`.${FORM_TITLE}`).prev().removeClass('layui-form-danger');
		
		//清空搜索值
		fs.config.clearInput && div.parents(`.${PNAME}`).find(`.${INPUT}`).val('');
		
		this.commonHanler(id, div);
	}
	
	Common.prototype.addLabel = function(id, div, val){
		if(!val) return ;
		let tips = `fsw="${NAME}"`;
		let [$label, $close] = [
			$(`<span ${tips} value="${val.val}"><font ${tips}>${val.name}</font></span>`), 
			$(`<i ${tips} class="xm-icon-close">×</i>`)
		];
		$label.append($close);
		//如果是radio模式
		let fs = data[id];
		if(fs.config.radio){
			fs.values.length = 0;
			$(`dl[xid="${id}"]`).find(`dd.${THIS}:not([lay-value="${val.val}"])`).removeClass(THIS);
			div.find('span').remove();
		}
		//如果是固定高度
		if(fs.config.height){
			div.append($label);
		}else{
			div.find('input').css('width', '50px');
			div.find('input').before($label);
		}
	}
	
	Common.prototype.delLabel = function(id, div, val){
		if(!val) return ;
		div.find(`span[value="${val.val}"]:first`).remove();
	}
	
	Common.prototype.calcLeft = function(id, div){
		if(data[id].config.height){
			let showLastSpan = div.find('span:not(.xm-span-hide):last')[0];
			div.next().css('left', (showLastSpan ? this.getPosition(showLastSpan).x - this.getPosition(div[0]).x + showLastSpan.offsetWidth + 20 : 10) + 'px');
		}
	}
	
	Common.prototype.checkHideSpan = function(div){
		let parentHeight = div.parents(`.${NAME}`)[0].offsetHeight + 5;
		div.find('span.xm-span-hide').removeClass('xm-span-hide');
		div.find('span').each((index, item) => {
			if(item.offsetHeight + item.offsetTop > parentHeight || this.getPosition(item).y + item.offsetHeight > this.getPosition(div[0]).y + div[0].offsetHeight + 5){
				$(item).addClass('xm-span-hide');
			}
		});
	}
	
	Common.prototype.retop = function(div){//计算dl显示的位置
		let dl = div.find('dl'),
			top = div.offset().top + div.outerHeight() + 5 - $win.scrollTop(),
            dlHeight = dl.outerHeight();
		let up = div.hasClass('layui-form-selectup') || dl.css('top').indexOf('-') != -1 || (top + dlHeight > $win.height() && top >= dlHeight);
		div = div.find(`.${NAME}`);
		
		let fs = data[dl.attr('xid')];
		let base = dl.parents('.layui-form-pane')[0] && dl.prev()[0].clientHeight > 38 ? 14 : 10;
		if(fs){
			if(fs.config.direction == 'up'){
				dl.css({
					top: 'auto',
					bottom: '42px'
				});
				return ;
			}
			if(fs.direction == 'down'){
				dl.css({
					top: div[0].offsetTop + div.height() + base + 'px',
					bottom: 'auto'
				});
				return ;
			}
		}
		
		if(up) {
			dl.css({
				top: 'auto',
				bottom: '42px'
			});
		} else {
			dl.css({
				top: div[0].offsetTop + div.height() + base + 'px',
				bottom: 'auto'
			});
		}
	}
	
	Common.prototype.changeShow = function(children, isShow){//显示于隐藏
		let top = children.parents(`.${FORM_SELECT}`);
		$(`.${PNAME} .${FORM_SELECT}`).not(top).removeClass(FORM_SELECTED);
		if(isShow){
			this.retop(top);
			top.addClass(FORM_SELECTED);
			top.find(`.${INPUT}`).focus();
		}else{
			top.removeClass(FORM_SELECTED);
			top.find(`.${INPUT}`).val('');
			top.find(`dl .layui-hide`).removeClass('layui-hide');
			top.find(`dl dd.${TEMP}`).remove();
			//计算ajax数据是否为空, 然后重新请求数据
			let id = top.find('dl').attr('xid');
			if(id && data[id] && data[id].config.isEmpty){
				this.triggerSearch(top);
			}
		}
	}
	
	Common.prototype.changePlaceHolder = function(div){//显示于隐藏提示语
		//调整pane模式下的高度
		let title = div.parents(`.${FORM_TITLE}`);
		
		let id = div.parents(`.${PNAME}`).find(`dl[xid]`).attr('xid');
		if(data[id] && data[id].config.height){//既然固定高度了, 那就看着办吧
						
		}else{
			let height = title.find(`.${NAME}`)[0].clientHeight;
			title.css('height' , (height > 34 ? height + 4 : height) + 'px');
			//如果是layui pane模式, 处理label的高度
			let label = title.parents(`.${PNAME}`).parent().prev();
			if(label.is('.layui-form-label') && title.parents('.layui-form-pane')[0]){
				height = height > 36 ? height + 4 : height;
				title.css('height' , height + 'px');
				label.css({
					height: height + 2 + 'px',
					lineHeight: (height - 18) + 'px'
				})
			}
		}
		
		let input = title.find(`.${TDIV} input`),
			isShow = !div.find('span:last')[0] && !title.find(`.${INPUT}`).val();
		if(isShow){
			let ph = input.attr('back');
			input.removeAttr('back');
			input.attr('placeholder', ph);
		}else{
			let ph = input.attr('placeholder');
			input.removeAttr('placeholder');
			input.attr('back', ph)
		}
	}
	
	Common.prototype.indexOf = function(arr, val){
		for(let i = 0; i < arr.length; i++) {
			if(arr[i].val == val || arr[i].val == (val ? val.val : val) || arr[i] == val || JSON.stringify(arr[i]) == JSON.stringify(val)) {
				return i;
			}
		}
		return -1;
	}
	
	Common.prototype.remove = function(arr, val){
		let idx = this.indexOf(arr, val ? val.val : val);
		if(idx > -1) {
			arr.splice(idx, 1);
			return true;
		}
		return false;
	}
	
	Common.prototype.selectAll = function(id, isOn, skipDis){
		let dl = $(`[xid="${id}"]`);
		if(dl.find('.xm-select-linkage')[0]){
			return ;
		}
		dl.find(`dd[lay-value]:not(.${FORM_SELECT_TIPS}):not(.${THIS})${skipDis ? ':not(.'+DISABLED+')' :''}`).each((index, item) => {
			item = $(item);
			let val = {
				name: item.find('span').text(),
				val: item.attr('lay-value')
			}
			this.handlerLabel(id, dl.find(`dd[lay-value="${val.val}"]`), true, val, !isOn);
		});
	}
	
	Common.prototype.removeAll = function(id, isOn, skipDis){
		let dl = $(`[xid="${id}"]`);
		if(dl.find('.xm-select-linkage')[0]){//针对多级联动的处理
			data[id].values.concat([]).forEach((item, idx) => {
				let vs = item.val.split('/');
				let pid, li, index = 0;
				do{
					pid = vs[index ++];
					li = dl.find(`.xm-select-linkage-group${index}:not(.xm-select-linkage-hide) li[value="${pid}"]`);
					li.click();
				}while(li.length && pid != undefined);
			});
			return ;
		}
		data[id].values.concat([]).forEach((item, index) => {
			if(skipDis && dl.find(`dd[lay-value="${item.val}"]`).hasClass(DISABLED)){
				
			}else{
				this.handlerLabel(id, dl.find(`dd[lay-value="${item.val}"]`), false, item, !isOn);
			}
		});
	}
	
	Common.prototype.reverse = function(id, isOn, skipDis){
		let dl = $(`[xid="${id}"]`);
		if(dl.find('.xm-select-linkage')[0]){
			return ;
		}
		dl.find(`dd[lay-value]:not(.${FORM_SELECT_TIPS})${skipDis ? ':not(.'+DISABLED+')' :''}`).each((index, item) => {
			item = $(item);
			let val = {
				name: item.find('span').text(),
				val: item.attr('lay-value')
			}
			this.handlerLabel(id, dl.find(`dd[lay-value="${val.val}"]`), !item.hasClass(THIS), val, !isOn);
		});
	}
	
	Common.prototype.skin = function(id){
		let skins = ['default' ,'primary', 'normal', 'warm', 'danger'];
		let skin = skins[Math.floor(Math.random() * skins.length)];
		$(`dl[xid="${id}"]`).parents(`.${PNAME}`).find(`.${FORM_SELECT}`).attr('xm-select-skin', skin);
		this.commonHanler(id, $(`dl[xid="${id}"]`).parents(`.${PNAME}`).find(`.${LABEL}`));
	}
	
	Common.prototype.getPosition = function(e){
		let x = 0, y = 0;
        while (e != null) {
            x += e.offsetLeft;
            y += e.offsetTop;
            e = e.offsetParent;
        }
        return { x: x, y: y };
	};
	
	Common.prototype.onreset = function(){//监听reset按钮, 然后重置多选
		$(document).on('click', '[type=reset]', (e) => {
			$(e.target).parents('form').find(`.${PNAME} dl[xid]`).each((index, item) => {
				let id = item.getAttribute('xid'),
					dl = $(item),
					dd,
					temp = {};
				common.removeAll(id);
				data[id].config.init.forEach((val, idx) => {
					if(val && (!temp[val] || data[id].config.repeat) && (dd = dl.find(`dd[lay-value="${val.val}"]`))[0]){
						common.handlerLabel(id, dd, true);
						temp[val] = 1;
					}
				});
			})
		});
	}
	
	Common.prototype.loadingCss = function(){
		let cssStyle = $(
			`<style type="text/css">`+
			`.xm-select-parent *{margin:0;padding:0;font-family:"Helvetica Neue",Helvetica,"PingFang SC",微软雅黑,Tahoma,Arial,sans-serif}.xm-select-parent{text-align:left}.xm-select-parent select{display:none}.xm-select-parent .xm-select-title{position:relative;min-height:36px}.xm-select-parent .xm-input{cursor:pointer;border-radius:2px;border-width:1px;border-style:solid;border-color:#E6E6E6;display:block;width:100%;box-sizing:border-box;background-color:#FFF;height:36px;line-height:1.3;padding-left:10px;outline:0}.xm-select-parent .xm-select-sj{display:inline-block;width:0;height:0;border-style:dashed;border-color:transparent;overflow:hidden;position:absolute;right:10px;top:50%;margin-top:-3px;cursor:pointer;border-width:6px;border-top-color:#C2C2C2;border-top-style:solid;transition:all .3s;-webkit-transition:all .3s}.xm-select-parent .xm-form-selected .xm-select-sj{margin-top:-9px;transform:rotate(180deg)}.xm-select-parent .xm-form-select dl{display:none;position:absolute;left:0;top:42px;padding:5px 0;z-index:999;min-width:100%;border:1px solid #d2d2d2;max-height:300px;overflow-y:auto;background-color:#fff;border-radius:2px;box-shadow:0 2px 4px rgba(0,0,0,.12);box-sizing:border-box;animation-fill-mode:both;-webkit-animation-name:layui-upbit;animation-name:layui-upbit;-webkit-animation-duration:.3s;animation-duration:.3s;-webkit-animation-fill-mode:both;animation-fill-mode:both}@-webkit-keyframes layui-upbit{from{-webkit-transform:translate3d(0,30px,0);opacity:.3}to{-webkit-transform:translate3d(0,0,0);opacity:1}}@keyframes layui-upbit{from{transform:translate3d(0,30px,0);opacity:.3}to{transform:translate3d(0,0,0);opacity:1}}.xm-select-parent .xm-form-selected dl{display:block}.xm-select-parent .xm-form-select dl dd,.xm-select-parent .xm-form-select dl dt{padding:0 10px;line-height:36px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}.xm-select-parent .xm-form-select dl dd{cursor:pointer;height:36px}.xm-select-parent .xm-form-select dl dd:hover{background-color:#f2f2f2}.xm-select-parent .xm-form-select dl dt{font-size:12px;color:#999}.layui-select-disabled .xm-dis-disabled{border-color:#eee!important}.xm-select-parent .xm-form-select dl .xm-select-tips{padding-left:10px!important;color:#999;font-size:14px}.xm-unselect{-moz-user-select:none;-webkit-user-select:none;-ms-user-select:none}.xm-form-checkbox{position:relative;display:inline-block;vertical-align:middle;height:30px;line-height:30px;margin-right:10px;padding-right:30px;background-color:#fff;cursor:pointer;font-size:0;-webkit-transition:.1s linear;transition:.1s linear;box-sizing:border-box}.xm-form-checkbox *{display:inline-block;vertical-align:middle}.xm-form-checkbox span{padding:0 10px;height:100%;font-size:14px;border-radius:2px 0 0 2px;background-color:#d2d2d2;color:#fff;overflow:hidden;white-space:nowrap;text-overflow:ellipsis}.xm-form-checkbox:hover span{background-color:#c2c2c2}.xm-form-checkbox i{position:absolute;right:0;top:0;width:30px;height:28px;border:1px solid #d2d2d2;border-left:none;border-radius:0 2px 2px 0;color:#fff;font-size:20px;text-align:center}.xm-form-checkbox:hover i{border-color:#c2c2c2;color:#c2c2c2}.xm-form-checkbox[lay-skin=primary]{height:auto!important;line-height:normal!important;border:none!important;margin-right:0;padding-right:0;background:0 0}.xm-form-checkbox[lay-skin=primary] span{float:right;padding-right:15px;line-height:18px;background:0 0;color:#666}.xm-form-checkbox[lay-skin=primary] i{position:relative;top:0;width:16px;height:16px;line-height:16px;border:1px solid #d2d2d2;font-size:12px;border-radius:2px;background-color:#fff;-webkit-transition:.1s linear;transition:.1s linear}.xm-form-checkbox[lay-skin=primary]:hover i{border-color:#5FB878;color:#fff}.xm-icon-yes{width:30px;height:30px;border-radius:4px;background-color:#009688;position:relative}.xm-icon-yes:after{content:'';display:inline-block;border:2px solid #fff;border-top-width:0;border-right-width:0;width:9px;height:5px;-webkit-transform:rotate(-50deg);transform:rotate(-50deg);position:absolute;top:2px;left:3px}.xm-dis-disabled,.xm-dis-disabled:hover{color:#d2d2d2!important;cursor:not-allowed!important}.xm-form-select dl dd.xm-dis-disabled{background-color:#fff!important}.xm-form-select dl dd.xm-dis-disabled span{color:#C2C2C2}.xm-form-select dl dd.xm-dis-disabled .xm-icon-yes{border-color:#C2C2C2}.xm-select-parent{position:relative;-moz-user-select:none;-ms-user-select:none;-webkit-user-select:none}.xm-select-parent .xm-select{line-height:normal;height:auto;padding:4px 10px 1px 10px;overflow:hidden;min-height:36px;left:0;z-index:99;position:absolute;background:0 0;padding-right:20px}.xm-select-parent .xm-select:hover{border-color:#C0C4CC}.xm-select-parent .xm-select .xm-select-label{display:inline-block;margin:0;vertical-align:middle}.xm-select-parent .xm-select-title div.xm-select-label>span{position:relative;padding:2px 5px;background-color:#009688;border-radius:2px;color:#FFF;display:inline-block;line-height:18px;height:18px;margin:2px 5px 2px 0;cursor:initial;user-select:none;font-size:14px;padding-right:25px}.xm-select-parent .xm-select-title div.xm-select-label>span i{position:absolute;right:5px;top:2px;margin-left:8px;border-radius:20px;font-size:18px;cursor:pointer;display:inline-block;height:14px;line-height:15px;width:12px;vertical-align:top;margin-top:2px}.xm-select-parent .xm-select .xm-select-input{border:none;height:28px;background-color:transparent;padding:0;vertical-align:middle;display:inline-block;width:50px}.xm-select-parent .xm-select--suffix input{border:none}.xm-select-parent dl dd.xm-dis-disabled.xm-select-this i{border-color:#C2C2C2;background-color:#C2C2C2;color:#FFF}.xm-select-parent dl dd.xm-select-this i{background-color:#009688;border-color:#009688}.xm-form-selected .xm-select,.xm-form-selected .xm-select:hover{border-color:#009688!important}.xm-select--suffix+div{position:absolute;top:0;left:0;bottom:0;right:0}.xm-select-dis .xm-select--suffix+div{z-index:100;cursor:no-drop!important;opacity:.2;background-color:#FFF}.xm-select-disabled,.xm-select-disabled:hover{color:#d2d2d2!important;cursor:not-allowed!important;background-color:#fff}.xm-select-none{display:none;margin:5px 0;text-align:center}.xm-select-none:hover{background-color:#FFF!important}.xm-select-empty{display:block}.xm-span-hide{display:none!important}.xm-select-radio .xm-icon-yes{border-radius:20px!important}.xm-select-radio .xm-icon-yes:after{border-radius:20px;background-color:#fff;width:6px;height:6px;border:none;top:5px;left:5px}.layui-form-pane .xm-select,.layui-form-pane .xm-select:hover{border:none!important;top:0}.layui-form-pane .xm-select-title{border:1px solid #e6e6e6!important}div[xm-select-skin] .xm-select-title div.xm-select-label>span{border:1px solid #009688}div[xm-select-skin] .xm-select-title div.xm-select-label>span i:hover{opacity:.8;filter:alpha(opacity=80);cursor:pointer}div[xm-select-skin=default] .xm-select-title div.xm-select-label>span{background-color:#F0F2F5;color:#909399;border:1px solid #F0F2F5}div[xm-select-skin=default] .xm-select-title div.xm-select-label>span i{background-color:#C0C4CC;color:#FFF}div[xm-select-skin=default] dl dd.xm-select-this:not(.xm-dis-disabled) i{background-color:#5FB878;border-color:#5FB878;color:#FFF}div[xm-select-skin=default].xm-form-selected .xm-select,div[xm-select-skin=default].xm-form-selected .xm-select:hover{border-color:#C0C4CC!important}div[xm-select-skin=primary] .xm-select-title div.xm-select-label>span{background-color:#009688;color:#FFF;border:1px solid #009688}div[xm-select-skin=primary] .xm-select-title div.xm-select-label>span i{background-color:#009688;color:#FFF}div[xm-select-skin=primary] dl dd.xm-select-this:not(.xm-dis-disabled) i{background-color:#009688;border-color:#009688;color:#FFF}div[xm-select-skin=primary].xm-form-selected .xm-select,div[xm-select-skin=primary].xm-form-selected .xm-select:hover{border-color:#009688!important}div[xm-select-skin=normal] .xm-select-title div.xm-select-label>span{background-color:#1E9FFF;color:#FFF;border:1px solid #1E9FFF}div[xm-select-skin=normal] .xm-select-title div.xm-select-label>span i{background-color:#1E9FFF;color:#FFF}div[xm-select-skin=normal] dl dd.xm-select-this:not(.xm-dis-disabled) i{background-color:#1E9FFF;border-color:#1E9FFF;color:#FFF}div[xm-select-skin=normal].xm-form-selected .xm-select,div[xm-select-skin=normal].xm-form-selected .xm-select:hover{border-color:#1E9FFF!important}div[xm-select-skin=warm] .xm-select-title div.xm-select-label>span{background-color:#FFB800;color:#FFF;border:1px solid #FFB800}div[xm-select-skin=warm] .xm-select-title div.xm-select-label>span i{background-color:#FFB800;color:#FFF}div[xm-select-skin=warm] dl dd.xm-select-this:not(.xm-dis-disabled) i{background-color:#FFB800;border-color:#FFB800;color:#FFF}div[xm-select-skin=warm].xm-form-selected .xm-select,div[xm-select-skin=warm].xm-form-selected .xm-select:hover{border-color:#FFB800!important}div[xm-select-skin=danger] .xm-select-title div.xm-select-label>span{background-color:#FF5722;color:#FFF;border:1px solid #FF5722}div[xm-select-skin=danger] .xm-select-title div.xm-select-label>span i{background-color:#FF5722;color:#FFF}div[xm-select-skin=danger] dl dd.xm-select-this:not(.xm-dis-disabled) i{background-color:#FF5722;border-color:#FF5722;color:#FFF}div[xm-select-skin=danger].xm-form-selected .xm-select,div[xm-select-skin=danger].xm-form-selected .xm-select:hover{border-color:#FF5722!important}.xm-select-parent .layui-form-danger+.xm-select-title .xm-select{border-color:#FF5722!important}.xm-select-linkage li{padding:10px 0;cursor:pointer}.xm-select-linkage li span{padding-left:20px;padding-right:30px;display:inline-block;height:20px;overflow:hidden;text-overflow:ellipsis}.xm-select-linkage li.xm-select-this span{border-left:5px solid #009688;color:#009688;padding-left:15px}.xm-select-linkage-group{position:absolute;left:0;top:0;right:0;bottom:0;overflow-x:hidden;overflow-y:auto}.xm-select-linkage-group li:hover{border-left:1px solid #009688}.xm-select-linkage-group li:hover span{padding-left:19px}.xm-select-linkage-group li.xm-select-this:hover span{padding-left:15px;border-left-width:4px}.xm-select-linkage-group:nth-child(4n+1){background-color:#EFEFEF;left:0}.xm-select-linkage-group:nth-child(4n+1) li.xm-select-active{background-color:#F5F5F5}.xm-select-linkage-group:nth-child(4n+2){background-color:#F5F5F5;left:100px}.xm-select-linkage-group:nth-child(4n+3) li.xm-select-active{background-color:#FAFAFA}.xm-select-linkage-group:nth-child(4n+3){background-color:#FAFAFA;left:200px}.xm-select-linkage-group:nth-child(4n+3) li.xm-select-active{background-color:#FFF}.xm-select-linkage-group:nth-child(4n+4){background-color:#FFF;left:300px}.xm-select-linkage-group:nth-child(4n+4) li.xm-select-active{background-color:#EFEFEF}.xm-select-linkage li{list-style:none}.xm-select-linkage-hide{display:none}.xm-select-linkage-show{display:block}div[xm-select-skin=default] .xm-select-linkage li.xm-select-this span{border-left-color:#5FB878;color:#5FB878}div[xm-select-skin=default] .xm-select-linkage-group li:hover{border-left-color:#5FB878}div[xm-select-skin=primary] .xm-select-linkage li.xm-select-this span{border-left-color:#1E9FFF;color:#1E9FFF}div[xm-select-skin=primary] .xm-select-linkage-group li:hover{border-left-color:#1E9FFF}div[xm-select-skin=normal] .xm-select-linkage li.xm-select-this span{border-left-color:#1E9FFF;color:#1E9FFF}div[xm-select-skin=normal] .xm-select-linkage-group li:hover{border-left-color:#1E9FFF}div[xm-select-skin=warm] .xm-select-linkage li.xm-select-this span{border-left-color:#FFB800;color:#FFB800}div[xm-select-skin=warm] .xm-select-linkage-group li:hover{border-left-color:#FFB800}div[xm-select-skin=danger] .xm-select-linkage li.xm-select-this span{border-left-color:#FF5722;color:#FF5722}div[xm-select-skin=danger] .xm-select-linkage-group li:hover{border-left-color:#FF5722}.xm-form-checkbox[lay-skin=primary] i{top:9px}.xm-form-checkbox[lay-skin=primary] span{line-height:36px}.xm-select-tips[style]:hover{background-color:#FFF!important}.xm-select-parent dd>.xm-cz{position:absolute;top:5px;right:10px}.xm-select-parent dd>.xm-cz-group{margin-right:30px;border-right:2px solid #ddd;height:16px;margin-top:10px;line-height:16px;overflow:hidden}.xm-select-parent dd>.xm-cz-group .xm-cz{display:inline-block;margin-right:30px}.xm-select-parent dd>.xm-cz-group .xm-cz i{margin-right:10px}.xm-select-parent dd>.xm-cz-group[show=name] .xm-cz i{display:none}.xm-select-parent dd>.xm-cz-group[show=icon] .xm-cz span{display:none}.xm-select-parent dd .xm-cz:hover{color:#009688}div[xm-select-skin=default] dd .xm-cz:hover{color:#C0C4CC}div[xm-select-skin=primary] dd .xm-cz:hover{color:#009688}div[xm-select-skin=normal] dd .xm-cz:hover{color:#1E9FFF}div[xm-select-skin=warm] dd .xm-cz:hover{color:#FFB800}div[xm-select-skin=danger] dd .xm-cz:hover{color:#FF5722}`+
			`</style>`+
			`<link rel="stylesheet" type="text/css" href="//at.alicdn.com/t/font_711182_8sv6blqzaw2.css"/>`
		);
		($('head link:last')[0] && $('head link:last').after(cssStyle)) || $('head').append(cssStyle);
	}
	
	Common.prototype.listening = function(){//TODO 用于监听dom结构变化, 如果出现新的为渲染select, 则自动进行渲染
		let flag = false;
		let index = 0;
		$(document).on('DOMNodeInserted', (e) => {
			if(flag){//避免递归渲染
				return ;
			}
			flag = true;
			//渲染select
			$(`select[${NAME}]`).each((index, select) => {
				let sid = select.getAttribute(NAME);
				common.init(select);
				common.one($(`dl[xid="${sid}"]`).parents(`.${PNAME}`));
				common.initVal(sid);
			});
			
			flag = false;
		});
	}

	
	let Select4 = function(){
		this.v = v;
	};
	let common = new Common();
	
	Select4.prototype.value = function(id, type, isAppend){
		if(typeof id != 'string'){
			return [];
		}
		let fs = data[id];
		if(!fs){
			return [];
		}
		if(typeof type == 'string' || type == undefined){
			let arr = fs.values.concat([]) || [];
			if(type == 'val') {
				return arr.map((val) => {
					return val.val;
				});
			}
			if(type == 'valStr') {
				return arr.map((val) => {
					return val.val;
				}).join(',');
			}
			if(type == 'name') {
				return arr.map((val) => {
					return val.name;
				});
			}
			if(type == 'nameStr') {
				return arr.map((val) => {
					return val.name;
				}).join(',');
			}
			return arr;
		}
		if(common.isArray(type)) {
			let dl = $(`[xid="${id}"]`),
				temp = {},
				dd,
				isAdd = true;
			if(isAppend == false){//删除传入的数组
				isAdd = false;
			}else if(isAppend == true){//追加模式
				isAdd = true;
			}else{//删除原有的数据
				common.removeAll(id);
			}
			if(isAdd){
				fs.values.forEach((val, index) => {
					temp[val.val] = 1;
				});
			}
			type.forEach((val, index) => {
				if(val && (!temp[val] || fs.config.repeat)){
					if((dd = dl.find(`dd[lay-value="${val}"]`))[0]){
						common.handlerLabel(id, dd, isAdd, null, true);
						temp[val] = 1;
					}else{
						let name = common.valToName(id, val);						
						if(name){
							common.handlerLabel(id, dd, isAdd, {
								name: name,
								val: val
							}, true);
							temp[val] = 1;
						}
					}
				}
			});
		}
	}
	
	Common.prototype.bindEvent = function(name, id, fun){
		if(id && id instanceof Function){
			fun = id;
			id = null;
		}
		if(fun && fun instanceof Function){
			if(!id){
				$.each(data, (id, val) => {
					data[id] ? (data[id].config[name] = fun) : (events[name][id] = fun)				
				})
			}else{
				data[id] ? (data[id].config[name] = fun) : (events[name][id] = fun)
			}
		}
	}
	
	Select4.prototype.on = function(id, fun){
		common.bindEvent('on', id, fun);
		return this;
	}
	
	Select4.prototype.filter = function(id, fun){
		common.bindEvent('filter', id, fun);
		return this;
	}
	
	Select4.prototype.maxTips = function(id, fun){
		common.bindEvent('maxTips', id, fun);
		return this;
	}
	
	Select4.prototype.config = function(id, config, isJson){
		if(id && typeof id == 'object'){
			isJson = config == true;
			config = id;
			id = null;
		}
		if(config && typeof config== 'object'){
			if(isJson){
				config.header || (config.header = {});
				config.header['Content-Type'] = 'application/json; charset=UTF-8';
				config.dataType = 'json';
			}
			id ? (
				ajaxs[id] = $.extend(true, {}, ajax, config),
				data[id] && (data[id].config.direction = config.direction),
				config.searchUrl && data[id] && common.triggerSearch($(`.${PNAME} dl[xid="${id}"]`).parents(`.${FORM_SELECT}`), true)
			) : (
				$.extend(true, ajax, config)
			);
		}
		return this;
	}
	
	Select4.prototype.render = function(id){
		let target = {};
		id ? (data[id] && (target[id] = data[id])) : data;
		
		if(Object.getOwnPropertyNames(target).length){
			$.each(target, (key, val) => {//恢复初始值
				let dl = $(`dl[xid="${key}"]`),
					vals = [];
				val.select.find('option[selected]').each((index, item) => {
					vals.push(item.value);
				});
				//移除创建元素
				dl.find(`.${CREATE_LONG}`).remove();
				//清空INPUT
				dl.prev().find(`.${INPUT}`).val('');
				//触发search
				common.triggerSearch(dl.parents(`.${FORM_SELECT}`), true);
				//移除hidn
				dl.find(`.layui-hide`).removeClass('layui-hide');
				//重新赋值
				this.value(key, vals);
			});
		}
		($(`select[${NAME}="${id}"]`)[0] ? $(`select[${NAME}="${id}"]`) : $(`select[${NAME}]`)).each((index, select) => {
			let sid = select.getAttribute(NAME);
			common.init(select);
			common.one($(`dl[xid="${sid}"]`).parents(`.${PNAME}`));
			common.initVal(sid);
		});
		return this;
	}
	
	Select4.prototype.disabled = function(id){
		let target = {};
		id ? (data[id] && (target[id] = data[id])) : (target = data);
		
		$.each(target, (key, val) => {
			$(`dl[xid="${key}"]`).prev().addClass(DIS);
		});
		return this;
	}
	
	Select4.prototype.undisabled = function(id){
		let target = {};
		id ? (data[id] && (target[id] = data[id])) : (target = data);
		
		$.each(target, (key, val) => {
			$(`dl[xid="${key}"]`).prev().removeClass(DIS);
		});
		return this;
	}
	
	Select4.prototype.data = function(id, type, config){
		if(!id || !type || !config){
			return this;
		}
		//检测该id是否尚未渲染
		!data[id] && this.render(id).value(id, []);
		this.config(id, config);
		if(type == 'local'){
			common.renderData(id, config.arr, config.linkage == true, config.linkageWidth ? config.linkageWidth : '100');
		}else if(type == 'server'){
			common.ajax(id, config.url, config.keyword, config.linkage == true, config.linkageWidth ? config.linkageWidth : '100');
		}
		return this;
	}
	
	Select4.prototype.btns = function(id, btns, config){
		if(!btns || !common.isArray(btns)) {
			return this;
		};
		let target = {};
		id ? (data[id] && (target[id] = data[id])) : (target = data);
		
		btns = btns.map((obj) => {
			if(typeof obj == 'string'){
				if(obj == 'select'){
					return quickBtns[0];
				}
				if(obj == 'remove'){
					return quickBtns[1];
				}
				if(obj == 'reverse'){
					return quickBtns[2];
				}
				if(obj == 'skin'){
					return quickBtns[3];
				}
			}
			return obj;
		});
		
		$.each(target, (key, val) => {
			val.config.btns = btns;
			let dd = $(`dl[xid="${key}"]`).find(`.${FORM_SELECT_TIPS}:first`);
			if(btns.length){
				let show = config && config.show && (config.show == 'name' || config.show == 'icon') ? config.show : '';
				let html = common.renderBtns(key, show, config && config.space ? config.space : '30px');
				dd.html(html);
			}else{
				let pcInput = dd.parents(`.${FORM_SELECT}`).find(`.${TDIV} input`);
				let html = pcInput.attr('placeholder') || pcInput.attr('back');
				dd.html(html);
				dd.removeAttr('style');
			}
		});
		
		return this;
	}
	
	Select4.prototype.search = function(id, val){
		if(id && data[id]){
			ajaxs[id] = $.extend(true, {}, ajax, {
				first: true,
				searchVal: val
			});
			common.triggerSearch($(`dl[xid="${id}"]`).parents(`.${FORM_SELECT}`), true);
		}
		return this;
	}
	
	return new Select4();
});