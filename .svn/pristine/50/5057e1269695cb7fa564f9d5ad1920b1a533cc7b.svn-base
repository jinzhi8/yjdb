//===================基本工具类=====================
// some basic tools
function $id(name){
	var e=document.getElementById(name);
	return e;
}

function showHip(text){
	if(flag_hideAll==true)return;
	$id('hip').showHip(text);	
}
function noNull(str){
	if(str==null)return "";	
	if(typeof(str)=="undefined")return "";
	return str;
}

function loadJsFile(url,id){
	//读取一个javascript文件
	var element = document.createElement("script");
	element.type = "text/javascript";
	element.src = url;
	if(id!=null)element.id = id;
	document.getElementsByTagName("head")[0].appendChild(element);
}

function mixIn(/*Object*/source,/*Object*/des){
// make the source's each prop to des
	for(var i in source)
		des[i]=source[i];
	return des;
}
//========================页面操作======================
function setPanelPosition(){
	$id('panel1').style.left=event.left;
	$id('panel1').style.top=event.top;
}
function setPanelScroll(){
	$id('panel1').style.top=parseInt(document.body.scrollTop);
	$id('panel1').style.left=parseInt(document.body.scrollLeft);
	$id('panelDraghandle').style.top=parseInt(document.body.scrollTop);
	$id('panelDraghandle').style.left=parseInt(document.body.scrollLeft);
	//set the position of propertiesPane
	initPropPos();
	
}
function hideOrShowPane(){
	var v=$id('panel1').style.visibility;
	if(v=="visible")v="hidden";
	else v="visible";
	$id('panel1').style.visibility=v;
}

/////////////////////////////////
function beginCreateNode(type){
	selectState=type;
	showHip("请点击画图区域以确定任务位置");	
	event.cancelBubble=true;	
	document.body.attachEvent("onclick",readyForCreateNode);
}
function beginCreateLine(){
	selectState=100;
	showHip("请选择源任务节点");
	event.cancelBubble=true;
}

function readyForCreateNode(){
	if(selectState<1||selectState>99)return;	
	var top=event.y+document.body.scrollTop;
	var left=event.x+document.body.scrollLeft;
	var node=new Node();
	node.index=nodes.length;
	node.name="未命名任务"+node.index;
	node.position=new Position(top,left);
	node.type=selectState;
	nodes[node.index]=node;
	createNode(node);	
	canDragOfNode(node.index);
	selectState=0;	
	showHip("创建任务完成");
	document.body.detachEvent("onclick",readyForCreateNode);
}

function readyForCreateLine(){
	if(selectedOne==selectedTwo){
		showHip("请选择不同的任务");
		return;
	}
	var lineIndexes = nodes[selectedOne].inLine;
	for(var lineIndex in lineIndexes){
		if(lines[lineIndexes[lineIndex]].source==selectedTwo&&lines[lineIndexes[lineIndex]].destination==selectedOne){
			showHip("当前任务之间已经有连接");
			return;
		}
	}
	var line=new Line();
	line.source=selectedTwo;
	line.destination=selectedOne;	
	line.index=lines.length;
	line.name="";
	line=getLineSDPoint(line);
	lines[line.index]=line;
	createLine(line);
	canDragOfLine(line.index);
	showHip("创建连线完成");
}

function _deleteLine(index){
	//delete a Line
	if(lines[index]==null)return;
	lines[index]=null;
	var lc=$id('lc'+index);	
	try{
		lc.innerHTML="";
		document.body.removeChild(lc);	
	}catch(e){}
}
function _deleteNode(index){
	//delete a node;
	//first delete relavent line
		if(nodes[index]==null)return;
		calcInOutLine(index);
		var rlines=nodes[index].inLine;
		for(var i=0;rlines!=null&&i<rlines.length;i++){
			_deleteLine(rlines[i]);
		}
		rlines=nodes[index].outLine;
		for(var i=0;rlines!=null&&i<rlines.length;i++){
			_deleteLine(rlines[i]);
		}
		//second delete node
		nodes[index]=null;
		var nc=$id('nc'+index);
		nc.innerHTML="";
		try{
			document.body.removeChild(nc);
		}catch(e){}
}

function _deleteGraphElement(){
	if(selectedLine!=null){
		_deleteLine(selectedLine);
		selectedLine=null;
	}else if(selectedOne!=null){		
		_deleteNode(selectedOne);
		selectedOne=null;
		selectedTwo=null;
	}else if(selectedArray!=null&&selectedArray.length>0){
		for(var i=0;i<selectedArray.length;i++)
			if(selectedArray[i].type==1)
				_deleteNode(selectedArray[i].index);
			else if(selectedArray[i].type==2)
				_deleteLine(selectedArray[i].index);
		
	}
}

function deleteGraphElement(){
	if(!confirm("确定要删除么?"))return;
	_deleteGraphElement();
}

////区域选择功能
function beginSelectRange(){
	//开始选择一个区域
	_detachEventWhenRange();
	document.body.attachEvent("onmousedown",beginRange);
	document.body.attachEvent("onmouseup",endRange);
	document.body.attachEvent("onmousemove",createRange);
	beginPosition=null;	
	_lockAll();
	//showHip("请选择区域");
	$id('rangeBt').style.border="solid 2px red";
	$id('arrowbt').style.border="solid 1px black";
	document.body.style.cursor="url(./image/icon_arrow1.gif)";
}

function _detachEventWhenRange(){
	try{
		document.body.detachEvent("onmousedown",beginRange);
		document.body.detachEvent("onmouseup",endRange);
		document.body.detachEvent("onmousemove",createRange);
	}catch(e){}
	
}

function beginRange(){
	_clearSelected();
	beginPosition=new Position(event.y+document.body.scrollTop,event.x+document.body.scrollLeft);
	var img=document.createElement("img");
	img.id="range1";
	img.src="./image/blank.gif";
	img.style.position="absolute";
	img.style.top=beginPosition.top;
	img.style.left=beginPosition.left;
	img.style.width="0px";
	img.style.height="0px";
	img.style.zIndex="9999";
	img.style.border="solid 1px #000000";
	img.style.backgroundColor="#9999ff";
	img.style.filter="Alpha(Opacity=50)";
	document.body.appendChild(img);
}
function endRange(){
	_detachEventWhenRange();
	try{
		document.body.removeChild($id('range1'));
	}catch(e){}
	beginPosition=null;
	// set the selectedObject into Array
	selectedArray=new Array();
	var i,obj;
	for(i=0;i<nodes.length;i++)
		if(nodes[i]!=null){
			if($id('node'+i).style.borderColor=="red"){
				obj=new Object();
				obj.type=1;
				obj.index=i;
				selectedArray[selectedArray.length]=obj;
				calcInOutLine(i);
				//showHip("1+"+i);
			}
		}
	for(i=0;i<lines.length;i++)
		if(lines[i]!=null){
			if($id('mid'+i).style.borderColor=="red"){
				obj=new Object();
				obj.type=2;
				obj.index=i;
				selectedArray[selectedArray.length]=obj;
				//showHip("2+"+i);
			}	
		}
	//showHip(selectedArray.length);
	beginSelectRange();
}

function showRangeBt(){
	//hiden the button of arrow ,and display rangeBt
	$id('arrowBt').style.border="solid 2px red";
	$id('rangeBt').style.border="solid 1px black";
	document.body.style.cursor="auto";
	
}

function _judgeObjInRange(objPos,rangePos,rangeWidth,rangeHeight){
	if(objPos.top>=rangePos.top&&objPos.top<=rangePos.top+rangeHeight&&
	   objPos.left>=rangePos.left&&objPos.left<=rangePos.left+rangeWidth)
		return true;
	return false;	
}

function _clearSelected(){
//clear all the selected object
	selectedLine=null;
	selectedOne=null;
	selectedTwo=null;
	for(var i=0;i<nodes.length;i++)
		if(nodes[i]!=null){
			$id('node'+i).style.border="solid 1px black";	
		}
	for(var i=0;i<lines.length;i++)
		if(lines[i]!=null){
			$id('mid'+i).style.border="solid 1px black";	
		}
}

function _clearSelectedArray(){
	selectedArray=null;	
	for(var i=0;i<nodes.length;i++)
		if(nodes[i]!=null){
			$id('node'+i).style.border="solid 1px black";	
		}
	for(var i=0;i<lines.length;i++)
		if(lines[i]!=null){
			$id('mid'+i).style.border="solid 1px black";	
		}
}

function createRange(){
	if(beginPosition==null)return;
	// change the range at time
	var pos=new Position(event.y+document.body.scrollTop,event.x+document.body.scrollLeft);
	var _w=Math.abs(beginPosition.left-pos.left);
	var _h=Math.abs(beginPosition.top-pos.top);
	var rng=$id('range1');
	var _t,_l;
	if(beginPosition.top>pos.top)_t=pos.top;
	else _t=beginPosition.top;
	if(beginPosition.left>pos.left)_l=pos.left;
	else _l=beginPosition.left;
	rng.style.top=_t+"px";
	rng.style.left=_l+"px";
	rng.style.width=_w+"px";
	rng.style.height=_h+"px";
	var rangePos=new Position(_t,_l);
	//select the objects when which are in the range	
	//TODO  优化下面的代码
	var i;
	for(i=0;i<nodes.length;i++)
		if(nodes[i]!=null){
			if(_judgeObjInRange(nodes[i].position,rangePos,_w,_h))//在区域内									
				$id('node'+i).style.border="solid 2px red";
			else
				$id('node'+i).style.border="solid 1px black";			
		}
	for(i=0;i<lines.length;i++)
		if(lines[i]!=null){
			if(_judgeObjInRange(lines[i].midPoint,rangePos,_w,_h))	
				$id('mid'+i).style.border="solid 2px red";				
			else
				$id('mid'+i).style.border="solid 1px black";
		}	
}
////////////////////////////////general operation,not be triged bt the buttons 
function _lockAll(){
	var i;
	for(i=0;i<nodes.length;i++)
		if(nodes[i]!=null)
			$id('node'+i).locked();
	for(i=0;i<lines.length;i++)
		if(lines[i]!=null)
			$id('mid'+i).locked();	
}

function _unlockAll(){
	var i;
	for(i=0;i<nodes.length;i++)
		if(nodes[i]!=null)
			$id('node'+i).unlocked();
	for(i=0;i<lines.length;i++)
		if(lines[i]!=null)
			$id('mid'+i).unlocked();	
}

function selectThisNode(index){
	event.cancelBubble=true
	_clearSelectedArray();
	
	if(selectedOne!=null){
		$id('node'+selectedOne).style.border="solid 1px black";
	}
	if(selectedLine!=null){
		$id('mid'+selectedLine).style.border="solid 1px black";
		selectedLine=null;		
	}
	selectedTwo=selectedOne;
	selectedOne=index;
	if(selectedOne!=null){
		$id('node'+selectedOne).style.border="solid 2px red";
	}
	
	if(selectState==0){
		showNodePropertiesPane();		
		return;
	}
	if(selectState==100){
		selectState=101;
		showHip("请选择目标任务");
		return;
	}
	if(selectState==101){		
		selectState=0;
		readyForCreateLine();
		return;
	}	
}
function selectThisLine(index){
	event.cancelBubble=true;	
	_clearSelectedArray();
	if(selectState!=0)return;
	if(selectedOne!=null){
		$id('node'+selectedOne).style.border="solid 1px black";
	}
	if(selectedLine!=null){
		$id('mid'+selectedLine).style.border="solid 1px black";
		selectedLine=null;		
	}
	selectedOne=null;
	selectedTwo=null;
	selectedLine=index;
	if(selectedLine!=null){
		$id('mid'+selectedLine).style.border="solid 2px red";
	}
	
	showLinePropertiesPane();
}
//////////////////////属性设置

function showFlowPropertiesPane(){
	if(flag_hideAll)return;
	initPropPos();
	if($id('props').src!="setFlowProperties.htm")
		$id('props').src="setFlowProperties.htm";
	$id('props').style.visibility="visible";	

	if(selectedOne!=null){
		var obj=new Object();
		obj.index=selectedOne;
		obj.name=nodes[selectedOne].name;
		obj.comment=nodes[selectedOne].comment;
		obj.info=nodes[selectedOne].info;
		window["props"].show(obj);
	}
	if(selectedLine!=null){
		var obj=new Object();
		obj.index=selectedLine;
		obj.name=lines[selectedLine].name;
		obj.comment=lines[selectedLine].comment;
		window["props"].show(obj);
	}
}
function showNodePropertiesPane(){
	if(flag_hideAll)return;
	initPropPos();
	if($id('props').src!="setNodeProperties.htm")
		$id('props').src="setNodeProperties.htm";
	$id('props').style.visibility="visible";	

	if(selectedOne!=null){
		var obj=new Object();
		obj.index=selectedOne;
		obj.name=nodes[selectedOne].name;
		obj.comment=nodes[selectedOne].comment;
		obj.info=nodes[selectedOne].info;
		window["props"].show(obj);
	}
}
function showLinePropertiesPane(){
	if(flag_hideAll)return;
	initPropPos();
	if($id('props').src!="setLineProperties.htm")
		$id('props').src="setLineProperties.htm";
	$id('props').style.visibility="visible";	

	if(selectedLine!=null){
		var obj=new Object();
		obj.index=selectedLine;
		obj.name=lines[selectedLine].name;
		obj.comment=lines[selectedLine].comment;
		window["props"].show(obj);
	}
}

function hidePropertiesPane(){
	$id('props').style.visibility="hidden";	
	//if($id('props').src!="setProperties.htm"){
	//	$id('props').src="setProperties.htm";
	//}
}

function setProperties(/*object*/ info){
	//由设置页面调用，传入设置的内容
	if(selectedOne!=null){
		nodes[selectedOne].name=info.name;
		nodes[selectedOne].comment=info.comment;
		if(info.info!=null)nodes[selectedOne].info=info.info;
		setNodeName(selectedOne);
	}else if(selectedLine!=null){
		lines[selectedLine].name=info.name;
		lines[selectedLine].comment=info.comment;
		setLineName(selectedLine);
	}else{
		showHip("设置失败：未选择任务");	
	}
}

function clearAll(){
	//删除所有的节点
	var i;
	selectedOne=null;
	selectedLine=null;
	selectedArray=new Array();
	for(i=0;i<nodes.length;i++)
		if(nodes[i]!=null){
			var obj=new Object();
			obj.type=1;
			obj.index=i;
			selectedArray[selectedArray.length]=obj;	
		}
	for(i=0;i<lines.length;i++)
		if(lines[i]!=null){
			var obj=new Object();
			obj.type=2;
			obj.index=i;
			selectedArray[selectedArray.length]=obj;	
		}
	_deleteGraphElement();	
}

function clearAllDom(){
	//只删除所有的HTML对象，不删除nodes数组
	var i;
	selectedOne=null;
	selectedLine=null;
	selectedArray=new Array();
	for(i=0;i<nodes.length;i++)
		if(nodes[i]!=null){
			var nc=$id('nc'+i);
			nc.innerHTML="";
			try{
				document.body.removeChild(nc);
			}catch(e){}
		}
	for(i=0;i<lines.length;i++)
		if(lines[i]!=null){
			var lc=$id('lc'+i);	
			try{
				lc.innerHTML="";
				document.body.removeChild(lc);	
			}catch(e){}	
		}
}

/////////////////
function initPropPos(){
	//初始化设置属性的窗口的位置
	var pp=$id('props');
	pp.style.top=window.document.body.clientHeight+window.document.body.scrollTop-pp.offsetHeight-2;
	pp.style.left=window.document.body.scrollLeft+1;
	pp.style.border="solid 1px black";
}

function init(){
	//loadJsFile("../objects/line.js","js_line");
	//loadJsFile("../objects/node.js","js_node");
	//loadJsFile("../objects/position.js","js_pos");
	//loadJsFile("../acting/doGraphElement.js","js_dge");
	//loadJsFile("../acting/saveOrLoad.js","js_sl");
	//loadJsFile("../acting/dataTrans.js","js_trans");
	//loadJsFile("../posing/treePos.js","js_tp");
	
	if(flag_hideAll){
		$id('panelDraghandle').style.visibility="hidden";
		$id('panel1').style.visibility="hidden";
	}
}

/////////////////////////////
function autoTreePos(){
	//自动布局
	clearAllDom();	
	initPosing();
	setNodeRelation();	
	treePosing();
	//$id('panel1').style.visibility="hidden";
	//_testShow();
}

function autoPoseNodes(){	
	if(nodeDatas==null)return;
	_initNodesFromExt(nodeDatas);
	initPosing();
	treePosing();
	//_testShow();
}
//=========================元素操作============================ 
function numToType(num){
//节点类型的转换，将数字转成对应的字符串
	num=parseInt(num);
	switch(num){
		case 1:
			return "start";
		case 2:
			return "taskNode";
		case 3:
			return "fork";
		case 4:
			return "join";
		case 99:
			return "end";				
	}
}
function typeToNum(type){
	//节点类型转换，将字符串转成对应的数字
	var num=-1;
	if(type=="start")
		num=1;
	else if(type=="taskNode")
		num=2;
	else if(type=="fork")
		num=3;
	else if(type=="join")
		num=4;
	else if(type=="end")
		num=99;
	return num;
}
 
function calcArrowPoint(sPoint,dPoint){
//determine the arrowPoints regarded by the source and the destination point 	
	var ret=new Array(2);
	var p1=new Position();
	var p2=new Position();
	var d=Math.sqrt((dPoint.top-sPoint.top)*(dPoint.top-sPoint.top)+(dPoint.left-sPoint.left)*(dPoint.left-sPoint.left));
	p1.left = dPoint.left + 10 * ((sPoint.left - dPoint.left) + (sPoint.top - dPoint.top) / 2) / d;	
	p1.top = dPoint.top + 10 * ((sPoint.top - dPoint.top) - (sPoint.left - dPoint.left) / 2) / d; 
	p2.left = dPoint.left + 10 * ((sPoint.left - dPoint.left) - (sPoint.top - dPoint.top) / 2) / d; 
	p2.top = dPoint.top + 10 * ((sPoint.top - dPoint.top) + (sPoint.left - dPoint.left) / 2) / d; 	
	ret[0]=p1;ret[1]=p2;
	return ret;
}

function getLineSDPoint(line){
	//according the sourceNode and DetinationNode to determine the line's sPoint midPoint and dPoint
	if(line.source==null||line.destination==null)return;
	if(nodes.length<2)return;	//if there is not at least two node , then return
	var sDom=$id("node"+line.source);
	var dDom=$id("node"+line.destination);
	var p1,p2,p3,p4;
	var d1,d2,d3,d4;
	p1=new Position(sDom.style.posTop,sDom.style.posLeft);	//top-left
	p2=new Position(p1.top,p1.left+sDom.offsetWidth);	//top-right;
	p3=new Position(p1.top+sDom.offsetHeight,p1.left);	//bottem-left;
	p4=new Position(p1.top+sDom.offsetHeight,p1.left+sDom.offsetWidth);		//bottom-right
	d1=new Position(dDom.style.posTop,dDom.style.posLeft);	//top-left
	d2=new Position(d1.top,d1.left+dDom.offsetWidth);	//top-right;
	d3=new Position(d1.top+dDom.offsetHeight,d1.left);	//bottem-left;
	d4=new Position(d1.top+dDom.offsetHeight,d1.left+dDom.offsetWidth);

	if((p1.top+sDom.offsetHeight)<d1.top){
		//source is above the destination
		line.sPoint=new Position(p3.top,(p3.left+p4.left)/2);
		line.dPoint=new Position(d1.top,(d1.left+d2.left)/2);
		line.midPoint=new Position((p3.top+d1.top)/2,(line.sPoint.left+line.dPoint.left)/2);
	}else if((d1.top+dDom.offsetHeight)<p1.top){
		//destination is above the source
		line.sPoint=new Position(p1.top,(p1.left+p2.left)/2);
		line.dPoint=new Position(d3.top,(d3.left+d4.left)/2);
		line.midPoint=new Position((d3.top+p1.top)/2,(line.sPoint.left+line.dPoint.left)/2);
	}else if(p1.left<d1.left){
		//source is at the left of the destination
		line.sPoint=new Position((p2.top+p4.top)/2,p2.left);
		line.dPoint=new Position((d1.top+d3.top)/2,d1.left);
		line.midPoint=new Position((line.sPoint.top+line.dPoint.top)/2,(line.sPoint.left+line.dPoint.left)/2);
	}else{
		//source is at the right of the destination
		line.sPoint=new Position((p1.top+p3.top)/2,p1.left);
		line.dPoint=new Position((d2.top+d4.top)/2,d2.left);
		line.midPoint=new Position((line.sPoint.top+line.dPoint.top)/2,(line.sPoint.left+line.dPoint.left)/2);		
	}
	return line;
}


function calcInOutLine(index){
//calculate the inlines and outlines of a node which index is parameter : index	
var i,inline=new Array(),outline=new Array();
for(i=0;i<lines.length;i++){
	if(lines[i]==null)continue;
	if(lines[i].source==index) outline[outline.length]=i;
	if(lines[i].destination==index) inline[inline.length]=i;
}
nodes[index].inLine=inline;
nodes[index].outLine=outline;
}

function _judgeNodeAndMidPos(nodeId,lineId,/* flag==1?source:destination*/flag){
	//判断节点和线中间块的位置关系
	//返回：1 左；2上；3右；4下
	var node=$id("node"+nodeId);
	var mid=$id("mid"+lineId);
	var p1,p2,p3,p4,d1,d2,d3,d4;
	p1=new Position(node.style.posTop,node.style.posLeft);	//top-left
	p2=new Position(p1.top,p1.left+node.offsetWidth);	//top-right;
	p3=new Position(p1.top+node.offsetHeight,p1.left);	//bottem-left;
	p4=new Position(p1.top+node.offsetHeight,p1.left+node.offsetWidth);		//bottom-right
	d1=new Position(mid.style.posTop,mid.style.posLeft);	//top-left
	d2=new Position(d1.top,d1.left+mid.offsetWidth);	//top-right;
	d3=new Position(d1.top+mid.offsetHeight,d1.left);	//bottem-left;
	d4=new Position(d1.top+mid.offsetHeight,d1.left+mid.offsetWidth);
	
	var pp=flag==1?lines[lineId].sPoint:lines[lineId].dPoint;	//the target which is to be changed
	if((p1.top+node.offsetHeight)<d1.top){
		pp.top=p3.top;
		pp.left=(p3.left+p4.left)/2;
		return 2;
	}else if((d1.top+mid.offsetHeight)<p1.top){
		pp.top=p1.top;
		pp.left=(p1.left+p2.left)/2;
		return 4;
	}else if(p1.left<d1.left){
		pp.left=p2.left;
		pp.top=(p2.top+p4.top)/2;
		return 1;
	}else{
		pp.left=p1.left;
		pp.top=(p1.top+p3.top)/2;
		return 3;
	}	

}

function moveRelevantLines(index){
// redraw the lines that is connected on the nodes[index]
	var atop=nodes[index].position.top-event.top;	//the - between the new top and old top
	var aleft=nodes[index].position.left-event.left;
	var i;
	for(i=0;nodes[index].inLine!=null&&i<nodes[index].inLine.length;i++){
		lines[nodes[index].inLine[i]].dPoint.top-=atop;
		lines[nodes[index].inLine[i]].dPoint.left-=aleft;
		//judge the posiiton with the midPoint
		_judgeNodeAndMidPos(index,nodes[index].inLine[i],2);
		
		reDrawLine(nodes[index].inLine[i]);
	}
	for(i=0;nodes[index].outLine!=null&&i<nodes[index].outLine.length;i++){
		lines[nodes[index].outLine[i]].sPoint.top-=atop;
		lines[nodes[index].outLine[i]].sPoint.left-=aleft;
		//judge the posiiton with the midPoint
		_judgeNodeAndMidPos(index,nodes[index].outLine[i],1);

		reDrawLine(nodes[index].outLine[i]);
	}
	//update new position
	nodes[index].position.top=event.top;
	nodes[index].position.left=event.left;

}

function reDrawLine(index){
// for some reasons , the line's position is changed,so we must redraw the line	
	//showHip('redrawline'+index);
	var pp=calcArrowPoint(lines[index].midPoint,lines[index].dPoint);
	var line=lines[index];
	//var cmd="line"+index+".points.value='"+lines[index].sPoint.left+","+lines[index].sPoint.top+","+lines[index].midPoint.left+","+lines[index].midPoint.top+","+lines[index].dPoint.left+","+lines[index].dPoint.top+","+pp[0].left+","+pp[0].top+","+lines[index].dPoint.left+","+lines[index].dPoint.top+","+pp[1].left+","+pp[1].top+"'";
	var old=$id("line"+line.index);
	old.points.value="'"+lines[index].sPoint.left+","+lines[index].sPoint.top+","+lines[index].midPoint.left+","+lines[index].midPoint.top+","+lines[index].dPoint.left+","+lines[index].dPoint.top+","+pp[0].left+","+pp[0].top+","+lines[index].dPoint.left+","+lines[index].dPoint.top+","+pp[1].left+","+pp[1].top+"'";
//	var html="<v:polyline id='line"+line.index+"' style='position:absolute;top:0px;left:0px;Z-INDEX:1;' points='"+line.sPoint.left+","+line.sPoint.top+","+line.midPoint.left+","+line.midPoint.top+","+line.dPoint.left+","+line.dPoint.top+","+pp[0].left+","+pp[0].top+","+line.dPoint.left+","+line.dPoint.top+","+pp[1].left+","+pp[1].top+"' filled='f' />";
	
//	var newLine=document.createElement(html);
//	newLine.id="line"+index;
//	newLine.style.position="absolute";
//	newLine.style.top=0;
//	newLine.style.left=0;
//	newLine.points.value="'"+lines[index].sPoint.left+","+lines[index].sPoint.top+","+lines[index].midPoint.left+","+lines[index].midPoint.top+","+lines[index].dPoint.left+","+lines[index].dPoint.top+","+pp[0].left+","+pp[0].top+","+lines[index].dPoint.left+","+lines[index].dPoint.top+","+pp[1].left+","+pp[1].top+"'";
//	newLine.filled="f";
//	container.removeChild(old);
//	container.appendChild(newLine);
}
function reDrawLineMid(index){
//move the midPoint so we must redraw line
	var left,top;
	top=event.top+3;
	left=event.left+3;
	lines[index].midPoint.left=left;
	lines[index].midPoint.top=top;
	//judge the position with the sPoint and dPoint
	_judgeNodeAndMidPos(lines[index].source,index,1);
	_judgeNodeAndMidPos(lines[index].destination,index,2);
	var line=lines[index];
	var pp=calcArrowPoint(lines[index].midPoint,lines[index].dPoint);
	var old=$id("line"+line.index);
	old.points.value="'"+lines[index].sPoint.left+","+lines[index].sPoint.top+","+lines[index].midPoint.left+","+lines[index].midPoint.top+","+lines[index].dPoint.left+","+lines[index].dPoint.top+","+pp[0].left+","+pp[0].top+","+lines[index].dPoint.left+","+lines[index].dPoint.top+","+pp[1].left+","+pp[1].top+"'";
	cmd="lineText"+index+".style.top='"+(lines[index].midPoint.top-6)+"px';";
	eval(cmd);
	cmd="lineText"+index+".style.left='"+(lines[index].midPoint.left+10)+"px';";
	eval(cmd);
}

////////////////crete the HtmlObject
function _getNodeClass(type){
	//select the different style accroding to the type
	var rst="node";
	switch(type){
		case 1:
			rst="beginNode";
			break;
		case 2:
			rst="generalNode";
			break;
		case 3:
			rst="forkNode";
			break;
		case 4:
			rst="joinNode";
			break;		
		case 99:
			rst="endNode";
			break;
	}
	return rst;
}

function createNode(node){
	var html="";
	var clazz=_getNodeClass(node.type);
	html="<div id='node"+node.index+"' onBeginDrag='calcInOutLine("+node.index+");' ondblclick='showNodePropertiesPane();' onSelected='selectThisNode("+node.index+");' onDraging='moveRelevantLines("+node.index+")' class='"+clazz+"' style='top:"+node.position.top+";left:"+node.position.left+";z-index:"+(currentIndex++)+"'><table border=0 width=100% height=100%><tr><td align=center valign=middle style='font-size:12px'>"+node.name+"</td></tr></table></div>";
	var nc=document.createElement("div");
	nc.id="nc"+node.index;
	document.body.appendChild(nc);
	nc.innerHTML+=html;
}

function canDragOfNode(index){
	if(index!=null){
		eval("$id('node"+index+"').style.behavior='url(./sndrag.htc)';");
		return;
	}
	var i;
	for(i=0;i<nodes.length;i++)
		eval("$id('node"+i+"').style.behavior='url(./sndrag.htc)';");
}

function canDragOfLine(index){
	if(index!=null){
		eval("$id('mid"+index+"').style.behavior='url(./sndrag.htc)';");
		return;
	}
	var i;
	for(i=0;i<nodes.length;i++)
		eval("$id('mid"+i+"').style.behavior='url(./sndrag.htc)';");
}

function createLine(line){
	//alert(line.name);
	var html;
	var pp=calcArrowPoint(line.midPoint,line.dPoint);	
	html="<v:polyline id='line"+line.index+"' style='position:absolute;top:0px;left:0px;Z-INDEX:"+(currentIndex)+";' points='"+line.sPoint.left+","+line.sPoint.top+","+line.midPoint.left+","+line.midPoint.top+","+line.dPoint.left+","+line.dPoint.top+","+pp[0].left+","+pp[0].top+","+line.dPoint.left+","+line.dPoint.top+","+pp[1].left+","+pp[1].top+"' filled='f' />";
	html+="<img id='mid"+line.index+"' onselected='selectThisLine("+line.index+")' onDraging='reDrawLineMid("+line.index+")' class='mid' style='Z-INDEX:"+(currentIndex)+";top:"+(line.midPoint.top-3)+";left:"+(line.midPoint.left-3)+"' />";
	html+="<div id='lineText"+line.index+"' style='top:"+(line.midPoint.top-6)+";left:"+(line.midPoint.left+10)+";z-index:"+(currentIndex++)+"' class='linetext' >"+line.name+"</div>";
	var lc=document.createElement("div");
	lc.id="lc"+line.index;
	document.body.appendChild(lc);
	lc.innerHTML+=html;
}

function setNodeName(index){
	if(nodes[index]==null)return;
	$id('node'+index).children[0].rows[0].cells[0].innerHTML=nodes[index].name;
}
function setLineName(index){
	if(lines[index]==null)return;
	$id('lineText'+index).innerHTML=lines[index].name;
}
//======================一些保存和读取用的方法=========================
function saveFlow(){
// 保存流程
// 弹出保存窗口，保存为txt文件，里面的内容是js
	var str=createSaveString();
	alert(str);
	if(str=="")return;
	window["frmSave"].document.open();
 	window["frmSave"].document.write("<html><meta http-equiv='Content-Type' content='text/html; charset=utf-8' /><body><form name='form1'>复制下面的内容到程序中<br><textarea id='t1' style='width:400px;height:400px'>"+str+"</textarea></form></body></html>");
	window["frmSave"].document.execCommand('SaveAs',false,'工作流程文件.htm');
	window["frmSave"].document.close();
}
function loadFlow(filename){
// load the flowDefinition	from a file
	if(!confirm("确定读取么？"))return;
	clearAll();
	$id('props').src="loadFlow.htm";
	initPropPos();
	$id('props').style.visibility="visible";
}
//加载JSON数据导入为流程
function doLoadFlow(str){
	nodes=new Array();
	lines=new Array();
	eval(str);
	for(var i=0;nn!=null&&i<nn.length;i++){
		var node=new Node();
		node=mixIn(nn[i],node);
		node.type=typeToNum(node.type);
		node.position=new Position(node.position.top,node.position.left);
		nodes[node.index]=node;
		createNode(node);
		canDragOfNode(node.index);
	}
	for(var i=0;ll!=null&&i<ll.length;i++){
		var line=new Line();
		line=mixIn(ll[i],line);
		line.sPoint=new Position(line.sPoint.top,line.sPoint.left);
		line.midPoint=new Position(line.midPoint.top,line.midPoint.left);
		line.dPoint=new Position(line.dPoint.top,line.dPoint.left);
		lines[line.index]=line;
		createLine(line);
		canDragOfLine(line.index);		
	}
}


function createSaveString(){
	if(nodes==null||nodes.length<1)return "";
	var str="";
	var sline="";
	var i;
	//alert(nodes.length);
	for(i=0;i<nodes.length;i++)
		if(nodes[i]!=null){
			str+=",{index:'"+nodes[i].index+"',name:'"+nodes[i].name+"',type:'"+numToType(nodes[i].type)+"',comment:'"+noNull(nodes[i].comment)+"',position:{top:"+nodes[i].position.top+",left:"+nodes[i].position.left+"}}";					
		}
	if(str!=""){
		str="var nn=["+str.substr(1)+"];";	
	}
	//alert(str+","+nodes[1].comment);
	for(i=0;i<lines.length;i++)
		if(lines[i]!=null){
			sline+=",{index:'"+lines[i].index+"',name:'"+lines[i].name+"',comment:'"+noNull(lines[i].comment)+"',source:"+lines[i].source+",destination:"+lines[i].destination+",midPoint:{top:'"+lines[i].midPoint.top+"',left:'"+lines[i].midPoint.left+"'},sPoint:{top:'"+lines[i].sPoint.top+"',left:'"+lines[i].sPoint.left+"'},dPoint:{top:'"+lines[i].dPoint.top+"',left:'"+lines[i].dPoint.left+"'}}";	
		}
	if(sline!=""){
		sline="var ll=["+sline.substr(1)+"];";
	}
	return ""+str+sline;

}
//========================节点、连线、位置=================
//节点
function Node(name,type,comment,/*Position Object*/position,width,height,/*Object*/info,
							/*Array of NodeIndex*/parentNode,childNode,
							/*Array of lineIndex*/inLine,outLine
						 ){
	//construction					 	
	this.name=name;
	this.type=type;
	this.comment=comment;
	this.position=position;	//top and left
	this.width=width;
	this.height=height;
	this.info=info;	//some extra informations
	this.parentNode=parentNode;//save the Node Object itself
	this.childNode=childNode;
	this.inLine=inLine;//save the Line Object
	this.outLine=outLine;
	this.index=-1;
}
//连线
function Line(name,/*Node index*/source,/*Node index*/destination,
						  /*Position Object*/midPoint,sPoint,dPoint,/*Object*/info
						 ){
//construction	
	this.name=name;
	this.source=source;
	this.destination=destination;
	this.midPoint=midPoint;
	this.sPoint=sPoint;
	this.dPoint=dPoint;
  this.info=info;
	this.index=-1;// save the index in the array
}
//位置
function Position(top,left){
	this.top=parseFloat(top);
	this.left=parseFloat(left);
	this.toString=function(){
		return this.top+","+this.left;	
	}
}
//====================自动排列=======================
// 将节点自动排列
/*实现目标：
	1 将所有的节点自动排序
	2 解决连线的重叠问题
分析：
	1 设置每个节点的parentNode和childNode
	2 找到一个parentNode 为null的做为树根设坐标（row=0,0)
	3 判断childNode的节点数为每个子节点设置坐标（row+1,col)，
		3.1 子节点的位置（row+1,fa.col+(i-(total/2))）
	4 如果坐标位置被占用，那么修改父节点坐标，使其col++ ，重复3
		4.1 判断占用关键是看col因为是自顶到下的，所以row不会重复
	5 设置完这个节点的子节点以后，设置这个节点为已操作already=1
	6 查找一个父节点不为空already=0的节点，重复3
	7 重复2
	8 完成节点的坐标设置，进行位移

	9 建立两点之间的连线
	10 写连线的名称和备注（选）
	11 判断如果两个连线的midPoint重叠，就左右移开
	12 如果连线的midPoint和node重叠，就移开
	
	author:shennan amushen@yahoo.com.cn
*/

var treeRow=0;		//记录当前行数
var already=new Array();	//记录是否已经操作
var treeNodes=null;		//这个树的所有节点，自顶至下，自左到右
var i_tn;					//treeNodes的循环变量
var minest=999;				//横坐标最小值，在位移的时候使用
var M_LEFT=120;				//坐标放大的倍数
var M_TOP=60;
var isNoRoot=true;		//如果出现环，没有根节点

function initPosing(){
	treeRow=0;
	minest=999;
	isNoRoot=true;
	for(var i=0;nodes!=null&&i<nodes.length;i++)
		already[i]=0;
}

function setNodeRelation(){
	//设置每个节点的父子节点
	if(nodes==null||nodes.length<1)return;
	var i;
	for(i=0;i<nodes.length;i++){
		if(nodes[i]!=null){
			nodes[i].parentNode=new Array();
			nodes[i].childNode=new Array();
		}
	}
	if(lines==null||lines.length<1)return;
	for(i=0;i<lines.length;i++){
		if(lines[i]==null)continue;
		nodes[lines[i].source].childNode.push(lines[i].destination);
		nodes[lines[i].destination].parentNode.push(lines[i].source);		
	}
}

function _getRoot(){
	var i;
	for(i=0;nodes!=null&&i<nodes.length;i++){
		if(nodes[i]==null)continue;
		if(already[i]==1)continue;
		if(nodes[i].parentNode.length>0)continue;		
		isNoRoot=false;
		return i;
	}
	if(isNoRoot){//出现环就返回第一个节点
		isNoRoot=false;
		for(i=0;nodes!=null&&i<nodes.length;i++){
			if(nodes[i]!=null){		
				return i;
			}
		}
	}
	return null;
}

function _setPosOfTree(root){
	//设置treeNodes数组
	treeNodes=new Array();
	treeNodes.push(root);
	var j,flag;
	i_tn=0;
	var k=0;
	while(k<treeNodes.length){
		for(var i=0;i<nodes[treeNodes[k]].childNode.length;i++){
			if(already[nodes[treeNodes[k]].childNode[i]]==1)continue;
			//必须保证这个点没有出现过,防止出现环路
			flag=true;
			for(j=0;j<treeNodes.length;j++)
				if(treeNodes[j]==nodes[treeNodes[k]].childNode[i]){
					flag=false;
					break;
				}
			if(flag)treeNodes.push(nodes[treeNodes[k]].childNode[i]);	
		}
		k++;
	}
}

function _getNextRoot(){
	//下一个要处理的节点
	if(i_tn==treeNodes.length-1)return null;
	i_tn++;
	return treeNodes[i_tn];
}

function treePosing(){
	//主控函数	
	var root=null;
	var i;
	var maxCol=-999;	//下一行的最大left位置
	var total;//孩子总数
	
	root=_getRoot();
	if(root!=null){
		nodes[root].position.left=0;	//根始终在0位置		
		nodes[root].position.top=treeRow;//自顶向下
		_setPosOfTree(root);	//为一个树设置标号，自顶向下，自左向右标
	}
	treeRow++;	//开始第一层
	while(root!=null){
		total=nodes[root].childNode.length;
		//首先确定root的位置是否需要调整
		if(maxCol!=-999){
			//可能不是这层的第一个，有可能需要调整位置
			nodes[root].position.left=maxCol+1+parseInt(total/2);
		}
		//为这个点的孩子节点设置位置
		for(i=0;i<nodes[root].childNode.length;i++){
			if(already[nodes[root].childNode[i]]==1)continue;//如果子节点已经展开，那么就不再设置
			
			nodes[nodes[root].childNode[i]].position.top=treeRow;
			nodes[nodes[root].childNode[i]].position.left=nodes[root].position.left+(i-parseInt(total/2));
			//下面的三行代码可以让布局更对称，但是太占空间了，所以删除
			//if(total%2==0)
				//if(i-parseInt(total/2)>=0)
					//nodes[nodes[root].childNode[i]].position.left++;
					
			maxCol=nodes[nodes[root].childNode[i]].position.left;	
			if(maxCol<minest)minest=maxCol;
		}
		already[root]=1;
		root=_getNextRoot();
		if(root!=null&&nodes[root].position.top==treeRow){
			//换行	
			treeRow++;
			maxCol=-999;
		}
		
		if(root==null){
		//开始下一棵树	
			treeRow++;
			root=_getRoot();
			if(root!=null){
				nodes[root].position.left=0;	//根始终在0位置		
				nodes[root].position.top=treeRow;//自顶向下
				_setPosOfTree(root);	//为一个树设置标号，自顶向下，自左向右标
				treeRow++;
				
			}
		}
		
	}//end of while(root)

	//开始为每个节点设置准确坐标
	_moveAllToRight();
	//坐标放大
	_magnifyPos();
	//创建节点
	_createAllTreeNode();
	//创建节点间的连线
	_createAllTreeLine();	
}
function _moveAllToRight(){
	if(minest==999)minest=0;
	for(var i=0;nodes!=null&&i<nodes.length;i++)
		if(nodes[i]!=null){
			nodes[i].position.left-=minest-1;
		}
}

function _magnifyPos(){
	for(var i=0;nodes!=null&&i<nodes.length;i++)
		if(nodes[i]!=null){
			nodes[i].position.left*=M_LEFT;
			nodes[i].position.top*=M_TOP;
		}
	
}
function _createAllTreeNode(){
	var i;
	for(i=0;nodes!=null&&i<nodes.length;i++)
		if(nodes[i]!=null){
			createNode(nodes[i]);
			canDragOfNode(i);
		}
}

function _createAllTreeLine___bak(){
	//lines=null;
	//lines=new Array();
	var i,j;
	for(i=0;nodes!=null&&i<nodes.length;i++){
		if(nodes[i]!=null){
			for(j=0;j<nodes[i].childNode.length;j++){
				var line=new Line();
				line.source=i;
				line.destination=nodes[i].childNode[j];
				line.index=lines.length;
				line.name="";
				line=getLineSDPoint(line);
				lines.push(line);				
			}
		}
	}
	//避免连线重叠,只判断mid
	_avoidLineOverlap();
	for(i=0;lines!=null&&i<lines.length;i++){
		if(lines[i]!=null){
			createLine(lines[i]);
			canDragOfLine(i);
		}
	}
}
function _createAllTreeLine(){
	newlines=null;
	newlines=new Array();
	var i,j;
	for(i=0;lines!=null&&i<lines.length;i++){
		if(lines[i]!=null){
			var line=new Line();
			line=lines[i];
			line=getLineSDPoint(line);
			line.comment=lines[i].comment;
			newlines.push(line);	
		}
	}
	//避免连线重叠,只判断mid
	_avoidLineOverlap();
	for(i=0;newlines!=null&&i<newlines.length;i++){
		if(newlines[i]!=null){
			createLine(newlines[i]);
			canDragOfLine(i);
		}
	}
	lines=newlines;
}

function _avoidLineOverlap(){
	if(lines==null||lines.length<1)return;
	var i,j,d;
	for(i=0;i<lines.length;i++)
		if(lines[i]!=null){
			for(j=i+1;j<lines.length;j++)
				if(lines[j]!=null){
					//计算两点距离
					d=Math.sqrt(Math.pow(lines[i].midPoint.top-lines[j].midPoint.top,2)+Math.pow(lines[i].midPoint.left-lines[j].midPoint.left,2));
					if(d<10){
						lines[j].midPoint.left=lines[i].midPoint.left+10;
						lines[j].midPoint.top=lines[i].midPoint.top+10;
						
					}
				}			
		}	
}

function _initNodesFromExt(/*nodeDatas*/nd){
//将外部数据转换成系统格式的数据
	var i,j;
	nodes=null;
	nodes=new Array();
	for(i=0;i<nd.length;i++){
		var node=new Node();
		node.index=nd[i].index;
		node.name=nd[i].name;
		node.type=typeToNum(nd[i].type);
		node.position=new Position();
		node.childNode=new Array();
		node.parentNode=new Array();
		if(nd[i].children!=null)node.childNode=nd[i].children;
//		alert(node.index+","+node.name+",child:"+node.childNode);		
		nodes[node.index]=node;
	}
	//设置父节点
	for(i=0;i<nodes.length;i++)
		if(nodes[i]!=null){			
			for(j=0;j<nodes[i].childNode.length;j++){	
				try{
					nodes[nodes[i].childNode[j]].parentNode.push(i);
				}catch(e){}			
			}
		}	
		nd=null;
}
/////////////////

function _testShow(){	
	var str="";
	for(var i=0;i<nodes.length;i++)
		if(nodes[i]!=null)
			str+=nodes[i].name+":"+nodes[i].position+"<br>";
	$id('_test').innerHTML=str;
}
