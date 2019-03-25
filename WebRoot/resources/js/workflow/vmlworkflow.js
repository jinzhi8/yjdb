function Group() {
	this.id = null;
	this.name = null;
	this.count = 0;
	this.nodes = [];
	this.lines = [];
	this.selectedObj = [];
	this.selectedLineFrom = [];
	this.selectedLineTo = [];
	this.mouseX = -1;
	this.mouseY = -1;
	this.mouseEndX = -1;
	this.mouseEndY = -1;
	this.action = null;
	this.lineFlag = null;
	this.multiSelect = false;
	this.ctrlKey = false;
	this.nodeMirror = null;
	this.lineMirror = null;
	this.bottomHeight = 10;
	this.rightWidth = 10;
	this.init = function() {
		var obj = document.getElementById('group');
		obj.setAttribute('bindClass', this);
		obj.onmousedown = GroupEvent.mouseDown;
		obj.onmousemove = GroupEvent.mouseMove;
		obj.onmouseup = GroupEvent.mouseUp;
		obj.onkeydown = GroupEvent.keyDown;
		obj.onkeyup = GroupEvent.keyUp;
		this.lineMirror = new Line();
		this.lineMirror.textFlag = false;
		this.lineMirror.mirrorFlag = true;
		this.lineMirror.init();
		this.lineMirror.setDisplay('none');
		this.lineMirror.strokeObj.dashStyle = 'dashdot';
		this.lineMirror.obj.strokecolor = '#000000';
		this.nodeMirror = new Node();
		this.nodeMirror.strokeFlag = true;
		this.nodeMirror.shadowFlag = false;
		this.nodeMirror.textFlag = false;
		this.nodeMirror.mirrorFlag = true;
		this.nodeMirror.init();
		this.nodeMirror.setDisplay('none');
		this.nodeMirror.obj.strokecolor = 'black';
		this.nodeMirror.obj.style.zIndex = '100';
		this.nodeMirror.obj.filled = false;
		this.nodeMirror.strokeObj.dashstyle = 'dot';
	};
	this.getObjectNum = function() {
		this.count++;
		return this.count;
	};
	this.point = function(flag) {
		if (flag == 'down') {
			this.mouseX = GroupEvent.getMouseX();
			this.mouseY = GroupEvent.getMouseY();
		} else if (flag == 'up') {
			this.mouseEndX = GroupEvent.getMouseX();
			this.mouseEndY = GroupEvent.getMouseY();
		}
	};
	this.getEventNode = function(flag) {
		var res = null;
		var nodeNum = this.nodes.length;
		var node = null;
		var x;
		var y;
		if (flag == 'down') {
			x = this.mouseX;
			y = this.mouseY;
		} else if (flag == 'up') {
			x = this.mouseEndX;
			y = this.mouseEndY;
		}
		for ( var i = (nodeNum - 1); i >= 0; i--) {
			node = this.nodes[i];
			if (node.pointInObj(x, y)) {
				res = node;
				break;
			}
		}
		return res;
	};
	this.getEventLine = function() {
		var res = null;
		var lineNum = this.lines.length;
		var line = null;
		var x = this.mouseX;
		var y = this.mouseY;
		var isStroke = -1;
		for ( var i = (lineNum - 1); i >= 0; i--) {
			line = this.lines[i];
			if (line.pointInObj(x, y)) {
				if (res == null || line.obj.style.zIndex == '22') {
					res = null;
					res = GroupEvent.insertObjInArr(res, line);
					isStroke = line.pointInStroke(x, y);
					if (isStroke == 0) {
						this.selectedLineTo = [];
						this.selectedLineFrom = [];
						this.selectedLineTo = GroupEvent.insertObjInArr(
								this.selectedLineTo, line);
					} else if (isStroke == 1) {
						this.selectedLineTo = [];
						this.selectedLineFrom = [];
						this.selectedLineFrom = GroupEvent.insertObjInArr(
								this.selectedLineFrom, line);
					}
				}
			}
		}
		return res;
	};
	this.moveSelectedObj = function() {
		var x = GroupEvent.getMouseX();
		var y = GroupEvent.getMouseY();
		var num = this.selectedObj.length;
		var lineNum = this.lines.length;
		var line = null;
		for ( var i = 0; i < num; i++) {
			this.selectedObj[i].move(x, y, this.mouseX, this.mouseY);
			for ( var j = 0; j < lineNum; j++) {
				line = this.lines[j];
				if ((line.fromObj == this.selectedObj[i])
						|| (line.toObj == this.selectedObj[i])) {
					line.relink();
				}
			}
		}
	};
	this.moveSelectedObjEnd = function() {
		var num = this.selectedObj.length;
		for ( var i = 0; i < num; i++) {
			this.selectedObj[i].moveEnd();
		}
	};
	this.moveLine = function() {
		var x = GroupEvent.getMouseX();
		var y = GroupEvent.getMouseY();
		var num = this.selectedLineTo.length;
		for ( var i = 0; i < num; i++) {
			this.selectedLineTo[i].setTo(x, y, null);
		}
		num = this.selectedLineFrom.length;
		for ( var i = 0; i < num; i++) {
			this.selectedLineFrom[i].setFrom(x, y, null);
		}
	};
	this.moveLineEnd = function(selNode) {
		var num = this.selectedLineTo.length;
		if (selNode != null) {
			for ( var i = 0; i < num; i++) {
				if (this.fuckyou(this.selectedLineTo[i].fromObj, selNode)) {
					this.selectedLineTo[i].setTo(this.mouseEndX,
							this.mouseEndY, selNode);
					this.selectedLineTo[i].relink();
				} else {
					this.selectedLineTo[i].relink();
				}
			}
		} else {
			for ( var i = 0; i < num; i++) {
				this.selectedLineTo[i].relink();
			}
		}
		this.selectedLineTo = [];
		num = this.selectedLineFrom.length;
		if (selNode != null) {
			for ( var i = 0; i < num; i++) {
				if (this.fuckyou(selNode, this.selectedLineFrom[i].toObj)) {
					this.selectedLineFrom[i].setFrom(this.mouseEndX,
							this.mouseEndY, selNode);
					this.selectedLineFrom[i].relink();
				} else {
					this.selectedLineFrom[i].relink();
				}
			}
		} else {
			for ( var i = 0; i < num; i++) {
				this.selectedLineFrom[i].relink();
			}
		}
		this.selectedLineFrom = [];
	};
	this.drawLineEnd = function(selNode) {
		if (selNode != null) {
			this.drawMirrorLineTo(selNode);
			if (this.fuckyou(this.lineMirror.fromObj, this.lineMirror.toObj)) {
				var line = new PolyLine();
				line.init();
				line.setShape(this.lineFlag);
				line.link(this.lineMirror);
				this.clearSelected();
			}
		}
		this.lineMirror.setDisplay('none');
	};
	this.drawMirrorLineFrom = function(selObj) {
		this.lineMirror.setFrom(this.mouseX, this.mouseY, selObj);
		this.lineMirror.setTo(this.mouseX, this.mouseY, selObj);
		this.lineMirror.setDisplay('');
	};
	this.drawMirrorLineTo = function(selObj) {
		var x = GroupEvent.getMouseX();
		var y = GroupEvent.getMouseY();
		this.lineMirror.setTo(x, y, selObj);
	};
	this.drawMirrorNodeStart = function() {
		this.multiSelect = false;
		this.nodeMirror.setLeft(GroupEvent.getX(this.mouseX));
		this.nodeMirror.setTop(GroupEvent.getY(this.mouseY));
		this.nodeMirror.setHeight(0);
		this.nodeMirror.setWidth(0);
	};
	this.drawMirrorNode = function() {
		var x = GroupEvent.getMouseX();
		var y = GroupEvent.getMouseY();
		this.nodeMirror.setWidth(Math.abs(GroupEvent.getX(x)
				- GroupEvent.getX(this.mouseX)));
		this.nodeMirror.setHeight(Math.abs(GroupEvent.getY(y)
				- GroupEvent.getY(this.mouseY)));
		if (GroupEvent.getX(x) < GroupEvent.getX(this.mouseX)) {
			this.nodeMirror.setLeft(GroupEvent.getX(x));
		}
		if (GroupEvent.getY(y) < GroupEvent.getY(this.mouseY)) {
			this.nodeMirror.setTop(GroupEvent.getY(y));
		}
		this.nodeMirror.setDisplay('');
	};
	this.drawMirrorNodeEnd = function() {
		this.nodeMirror.setDisplay('none');
		if (this.embodyObj())
			this.multiSelect = true;
	};
	this.embodyObj = function() {
		var res = false;
		var x1 = this.nodeMirror.left;
		var x2 = this.nodeMirror.left + this.nodeMirror.width;
		var y1 = this.nodeMirror.top;
		var y2 = this.nodeMirror.top + this.nodeMirror.height;
		var nodeNum = this.nodes.length;
		var lineNum = this.lines.length;
		var node = null;
		var line = null;
		for ( var i = 0; i < nodeNum; i++) {
			node = this.nodes[i];
			if ((x1 <= node.left) && (x2 >= (node.left + node.width))
					&& (y1 <= node.top) && (y2 >= (node.top + node.height))) {
				node.setSelected();
				this.selectedObj = GroupEvent.insertObjInArr(this.selectedObj,
						node);
				node.x = 0;
				node.y = 0;
				node.mouseX = node.left;
				node.mouseY = node.top;
				res = true;
			}
		}
		for ( var i = 0; i < lineNum; i++) {
			line = this.lines[i];
			if ((x1 <= Math.min(line.fromX, line.toX))
					&& (x2 >= Math.max(line.fromX, line.toX))
					&& (y1 <= Math.min(line.fromY, line.toY))
					&& (y2 >= Math.max(line.fromY, line.toY))) {
				line.setSelected();
				this.selectedObj = GroupEvent.insertObjInArr(this.selectedObj,
						line);
				res = true;
			}
		}
		return res;
	};
	this.fuckyou = function(fromObj, toObj) {
		var res = true;
		if (fromObj == toObj) {
			res = false;
		}
		var len = this.lines.length;
		var line = null;
		for ( var i = 0; i < len; i++) {
			line = this.lines[i];
			if ((line.fromObj == fromObj) && (line.toObj == toObj)) {
				res = false;
				alert("两点之间已经存在连接！");
				break;
			}
		}
		return res;
	};
	this.clearSelected = function() {
		var num = this.selectedObj.length;
		for ( var i = 0; i < num; i++) {
			this.selectedObj[i].clearSelected();
		}
		this.selectedObj = [];
	};
	this.selectAll = function() {
		this.selectedObj = [];
		var num = this.nodes.length;
		var obj = null;
		for ( var i = 0; i < num; i++) {
			obj = this.nodes[i];
			obj.setSelected();
			this.selectedObj = GroupEvent.insertObjInArr(this.selectedObj, obj);
			obj.x = 0;
			obj.y = 0;
			obj.mouseX = obj.left;
			obj.mouseY = obj.top;
		}
		num = this.lines.length;
		obj = null;
		for ( var i = 0; i < num; i++) {
			obj = this.lines[i];
			obj.setSelected();
			this.selectedObj = GroupEvent.insertObjInArr(this.selectedObj, obj);
		}
	};
	this.removeSelected = function() {
		var num = this.nodes.length;
		var obj = null;
		var arr = new Array();
		var count = 0;
		for ( var i = 0; i < num; i++) {
			obj = this.nodes[i];
			if (obj.selected) {
				obj.remove();
			} else {
				arr[count] = obj;
				count++;
			}
		}
		this.nodes = arr;
		num = this.lines.length;
		obj = null;
		arr = new Array();
		var count = 0;
		for ( var i = 0; i < num; i++) {
			obj = this.lines[i];
			if (obj.selected) {
				obj.remove();
			} else {
				arr[count] = obj;
				count++;
			}
		}
		this.lines = arr;
		this.selectedObj = [];
	};
	this.setGroupArea = function() {
		var obj = document.getElementById('group');
		var maxWidth = -1;
		var maxHeight = -1;
		var num = this.nodes.length;
		var node = null;
		for ( var i = 0; i < num; i++) {
			node = this.nodes[i];
			if (maxWidth < (node.left + node.width)) {
				maxWidth = node.left + node.width;
			}
			if (maxHeight < (node.top + node.height)) {
				maxHeight = node.top + node.height;
			}
		}
		if (maxHeight > document.body.clientHeight) {
			obj.style.height = (maxHeight + this.bottomHeight) + 'px';
		} else {
			obj.style.height = '100%'
		}
		if (maxWidth > document.body.clientWidth) {
			obj.style.width = (maxWidth + this.rightWidth) + 'px';
		} else {
			obj.style.width = '100%'
		}
	};
	this.toJson = function() {
		var jNodes = [];
		var nodeNum = this.nodes.length;
		for ( var i = 0; i < nodeNum; i++) {
			GroupEvent.insertObjInArr(jNodes, this.nodes[i].toJson());
		}
		var jLines = [];
		var lineNum = this.lines.length;
		for ( var i = 0; i < lineNum; i++) {
			GroupEvent.insertObjInArr(jLines, this.lines[i].toJson());
		}
		var json = {
			id : this.id,
			name : this.name,
			count : this.count,
			nodes : jNodes,
			lines : jLines
		};
		return JSON.encode(json);
	};
	this.jsonTo = function(json) {
		this.id = json.id;
		this.name = json.name;
		this.count = json.count;
		var jNodes = json.nodes;
		var nodeNum = jNodes.length;
		var node = null;
		for ( var i = 0; i < nodeNum; i++) {
			switch (jNodes[i].shape) {
			case 'img': {
				node = new NodeImg();
				break;
			}
			case 'oval': {
				node = new NodeOval();
				break;
			}
			default:
				node = new Node();
				break;
			}
			node.jsonTo(jNodes[i]);
			node.init();
		}
		var jLines = json.lines;
		var lineNum = jLines.length;
		var line = null;
		for ( var i = 0; i < lineNum; i++) {
			switch (jLines[i].shape) {
			default:
				line = new PolyLine();
				break;
			}
			line.jsonTo(jLines[i]);
			line.init();
			line.relink();
		}
	};
	this.setProp = function(selObj, flag) {
		var win = document.getElementById('propWin');
		win.setAttribute('selected', selObj);
		win.setAttribute('type', flag);
		for ( var i = 0; i < Prop.panels.length; i++) {
			var panel = document.getElementById(Prop.panels[i].id);
			if (flag == Prop.panels[i].flag) {
				win.t.innerHTML = Prop.panels[i].title;
				panel.style.display = '';
				var tabs = panel.getAttribute('tabs');
				if (tabs)
					tabs.setSelected();
				if (selObj)
					selObj.setProperty(flag);
			} else {
				panel.style.display = 'none';
			}
		}
	};
	this.eventStart = function() {
		if (this.ctrlKey) {
			this.multiSelect = true;
		}
		var selNode = this.getEventNode('down');
		var selLine = this.getEventLine();
		if (!this.multiSelect) {
			this.clearSelected();
		}
		if (selNode != null) {
			this.setProp(selNode, 'n');
			if (!GroupEvent.isInArr(this.selectedObj, selNode)) {
				if (!this.ctrlKey) {
					this.multiSelect = false;
					this.clearSelected();
				}
				selNode.setSelected();
				this.selectedObj = GroupEvent.insertObjInArr(this.selectedObj,
						selNode);
			} else {
				if (this.ctrlKey) {
					selNode.clearSelected();
					this.selectedObj = GroupEvent.removeObjInArr(
							this.selectedObj, selNode);
				}
			}
			if (this.lineFlag == null) {
				this.action = 'nodedown';
			} else if (this.lineFlag != null) {
				this.action = 'drawline';
				this.drawMirrorLineFrom(selNode);
			}
		} else if (selLine != null) {
			this.setProp(selLine[selLine.length - 1], 'l');
			for ( var i = 0; i < selLine.length; i++) {
				if (!GroupEvent.isInArr(this.selectedObj, selLine[i])) {
					if (!this.ctrlKey) {
						this.multiSelect = false;
					}
					selLine[i].setSelected();
					this.selectedObj = GroupEvent.insertObjInArr(
							this.selectedObj, selLine[i]);
				} else {
					if (this.ctrlKey) {
						selLine[i].clearSelected();
						this.selectedObj = GroupEvent.removeObjInArr(
								this.selectedObj, selLine[i]);
					}
				}
			}
			if (this.selectedLineTo.length > 0) {
				this.action = 'moveline';
				for ( var i = 0; i < this.selectedLineTo.length; i++) {
					this.selectedLineTo[i].setMoveSelected();
				}
			}
			if (this.selectedLineFrom.length > 0) {
				this.action = 'moveline';
				for ( var i = 0; i < this.selectedLineFrom.length; i++) {
					this.selectedLineFrom[i].setMoveSelected();
				}
			}
		} else {
			this.setProp(null, 'help');
			this.action = 'blankdown';
			if (!this.ctrlKey) {
				this.clearSelected();
				this.drawMirrorNodeStart();
			}
		}
	}
};
var GroupEvent = {
	mouseDown : function() {
		var group = document.getElementById('group');
		var Love = group.getAttribute('bindClass');
		document.selection.empty();
		Love.point('down');
		Love.eventStart();
		return false;
	},
	mouseMove : function() {
		var group = document.getElementById('group');
		var Love = group.getAttribute('bindClass');
		if (Love.action != null) {
			switch (Love.action) {
			case "nodedown":
				Love.moveSelectedObj();
				break;
			case "drawline":
				Love.drawMirrorLineTo(null);
				break;
			case "moveline":
				Love.moveLine(null);
				break;
			case "blankdown":
				Love.drawMirrorNode();
				break;
			default:
			}
		}
		return false;
	},
	mouseUp : function() {
		var group = document.getElementById('group');
		var Love = group.getAttribute('bindClass');
		if (Love.action != null) {
			Love.point('up');
			var selNode = Love.getEventNode('up');
			switch (Love.action) {
			case "nodedown":
				Love.moveSelectedObjEnd();
				break;
			case "drawline":
				Love.drawLineEnd(selNode);
				break;
			case "moveline":
				Love.moveLineEnd(selNode);
				break;
			case "blankdown":
				Love.drawMirrorNodeEnd();
				break;
			default:
			}
		}
		Love.setGroupArea();
		Love.action = null;
		return false;
	},
	keyDown : function() {
		var group = document.getElementById('group');
		var Love = group.getAttribute('bindClass');
		if (window.event.ctrlKey)
			Love.ctrlKey = true;
		switch (window.event.keyCode) {
		case 46:
			Love.removeSelected();
			break;
		case 65:
			if (window.event.ctrlKey) {
				Love.selectAll();
				Love.multiSelect = true;
				window.event.returnValue = false;
			}
			break;
		default:
		}
	},
	keyUp : function() {
		var group = document.getElementById('group');
		var Love = group.getAttribute('bindClass');
		Love.ctrlKey = false;
	},
	getX : function(x) {
		return (x + document.body.scrollLeft);
	},
	getY : function(y) {
		return (y + document.body.scrollTop);
	},
	getMouseX : function() {
		return window.event.clientX
	},
	getMouseY : function() {
		return window.event.clientY
	},
	insertObjInArr : function(arr, s) {
		if (arr == null)
			arr = [];
		arr[arr.length] = s;
		return arr;
	},
	removeObjInArr : function(arr, s) {
		var tArr = null;
		var count = 0;
		if (arr != null) {
			tArr = [];
			var num = arr.length;
			for ( var i = 0; i < num; i++) {
				if (arr[i] != s) {
					tArr[count] = arr[i];
					count++;
				}
			}
		}
		return tArr;
	},
	isInArr : function(arr, s) {
		var res = false;
		if (arr != null) {
			var num = arr.length;
			for ( var i = 0; i < num; i++) {
				if (arr[i] == s) {
					res = true;
					break;
				}
			}
		}
		return res;
	}
}
function Line() {
	this.id = 'line_';
	this.name = 'New Line';
	this.number = -1;
	this.type = 'line';
	this.shape = 'line';
	this.selected = false;
	this.fromX = -1;
	this.fromY = -1;
	this.toX = -1;
	this.toY = -1;
	this.textFlag = false;
	this.mirrorFlag = false;
	this.obj = null;
	this.strokeObj = null;
	this.textObj = null;
	this.fromObj = null;
	this.toObj = null;
	this.init = function() {
		var groupObj = document.getElementById('group');
		var obj = document.createElement('v:line');
		groupObj.appendChild(obj);
		obj.title = this.name;
		obj.from = '0,0';
		obj.to = '0,0';
		obj.strokecolor = 'blue';
		obj.strokeweight = '1';
		obj.filled = 'false';
		obj.style.position = 'absolute';
		obj.style.zIndex = '2';
		obj.style.cursor = 'hand';
		this.obj = obj;
		var strokeObj = document.createElement('v:stroke');
		obj.appendChild(strokeObj);
		strokeObj.endArrow = "Classic";
		this.strokeObj = strokeObj;
		if (this.textFlag) {
			var textObj = document.createElement('v:textbox');
			textObj.inset = '10pt,1pt,5pt,5pt';
			textObj.style.textAlign = 'center';
			textObj.style.verticalAlign = 'bottom';
			textObj.style.color = 'blue';
			textObj.style.fontSize = '9pt';
			textObj.innerHTML = this.name;
			obj.appendChild(textObj);
			this.textObj = textObj;
		}
		if (!this.mirrorFlag) {
			var Love = groupObj.getAttribute('bindClass');
			this.number = Love.getObjectNum();
			this.id = this.id + this.number;
			obj.id = this.id;
			Love.lines[Love.lines.length] = this;
		}
	};
	this.setFrom = function(x, y, obj) {
		this.fromX = GroupEvent.getX(x);
		this.fromY = GroupEvent.getY(y);
		if (obj)
			this.fromObj = obj;
		this.obj.from = this.fromX + ',' + this.fromY;
	};
	this.setTo = function(x, y, obj) {
		this.toX = GroupEvent.getX(x);
		this.toY = GroupEvent.getY(y);
		if (obj)
			this.toObj = obj;
		this.obj.to = this.toX + ',' + this.toY;
	};
	this.setDisplay = function(flag) {
		this.obj.style.display = flag;
	};
	this.link = function(lineMirror) {
		this.fromObj = lineMirror.fromObj;
		this.toObj = lineMirror.toObj;
		this.relink();
		this.fromObj.clearSelected();
	};
	this.relink = function() {
		var fromDots = this.fromObj.getDots();
		var toDots = this.toObj.getDots();
		var fromDotNum = fromDots.length;
		var toDotNum = toDots.length;
		var lineLen = -1;
		var fromDot;
		var toDot;
		for ( var i = 0; i < fromDotNum; i++) {
			for ( var j = 0; j < toDotNum; j++) {
				if (lineLen < 0) {
					lineLen = this.getLineLength(fromDots[i].x, fromDots[i].y,
							toDots[j].x, toDots[j].y);
					fromDot = fromDots[i];
					toDot = toDots[j];
				} else if (lineLen > this.getLineLength(fromDots[i].x,
						fromDots[i].y, toDots[j].x, toDots[j].y)) {
					lineLen = this.getLineLength(fromDots[i].x, fromDots[i].y,
							toDots[j].x, toDots[j].y);
					fromDot = fromDots[i];
					toDot = toDots[j];
				}
			}
		}
		this.fromX = fromDot.x;
		this.fromY = fromDot.y;
		this.toX = toDot.x;
		this.toY = toDot.y;
		this.obj.from = this.fromX + ',' + this.fromY;
		this.obj.to = this.toX + ',' + this.toY;
	};
	this.getLineLength = function(x1, y1, x2, y2) {
		return Math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
	};
	this.pointInObj = function(x, y) {
		var res = false;
		x = GroupEvent.getX(x);
		y = GroupEvent.getY(y);
		var x1 = this.fromX;
		var x2 = this.toX;
		var y1 = this.fromY;
		var y2 = this.toY;
		var x21 = x2 - x1;
		var y21 = y2 - y1;
		if (x21 == 0) {
			res = (Math.abs(x - x1) < 5) && (Math.min(y1, y2) <= y)
					&& (Math.max(y1, y2) >= y);
		} else if (y21 == 0) {
			res = (Math.abs(y - y1) < 5) && (Math.min(x1, x2) <= x)
					&& (Math.max(x1, x2) >= x);
		} else {
			res = (Math.min(y1, y2) <= y)
					&& (Math.max(y1, y2) >= y)
					&& (Math.min(x1, x2) <= x)
					&& (Math.max(x1, x2) >= x)
					&& ((Math.abs(Math.floor((x21 / y21) * (y - y1) + x1 - x)) < 5) || (Math
							.abs(Math.floor((y21 / x21) * (x - x1) + y1 - y)) < 5));
		}
		return res;
	};
	this.pointInStroke = function(x, y) {
		var res = -1;
		x = GroupEvent.getX(x);
		y = GroupEvent.getY(y);
		var x1 = this.fromX;
		var x2 = this.toX;
		var y1 = this.fromY;
		var y2 = this.toY;
		if ((Math.abs(x2 - x) < 6) && (Math.abs(y2 - y) < 6))
			res = 0;
		if ((Math.abs(x1 - x) < 6) && (Math.abs(y1 - y) < 6))
			res = 1;
		return res;
	};
	this.setSelected = function() {
		this.obj.strokecolor = 'green';
		if (this.textObj)
			this.textObj.style.color = 'green';
		this.selected = true;
		this.obj.style.zIndex = '22';
	};
	this.move = function() {
	};
	this.moveEnd = function() {
	};
	this.setMoveSelected = function() {
		this.obj.strokecolor = 'red';
		if (this.textObj)
			this.textObj.style.color = 'green';
		this.selected = true;
		this.obj.style.zIndex = '22';
	};
	this.clearSelected = function() {
		this.obj.strokecolor = 'blue';
		if (this.textObj)
			this.textObj.style.color = 'blue';
		this.selected = false;
		this.obj.style.zIndex = '2';
	};
	this.remove = function() {
		var group = document.getElementById('group');
		group.removeChild(this.obj);
	}
}
function Menu() {
	this.id = 'menu';
	this.left = 10;
	this.top = 3;
	this.height = 30;
	this.width = 300;
	this.selected = false;
	this.obj = null;
	this.menuObj = null;
	this.x = -1;
	this.y = -1;
	this.img = new Array('folder.gif', 'save.gif', 'start.gif', 'end.gif',
			'node.gif', 'member.gif', 'forward.gif', 'drop-yes.gif',
			'delete.gif', 'grid.gif');
	this.text = new Array('打开', '保存', '开始环节', '结束环节', '环节（长方形）', '环节（图片）',
			'路径（直线）', '路径（折线）', '删除', '网格');
	this.action = new Array('MenuAction.open()', 'MenuAction.save()',
			'MenuAction.start()', 'MenuAction.end()', 'MenuAction.nodeRect()',
			'MenuAction.nodeImg()',
			'if(MenuAction.line()) MenuAction.changeStyle(this)',
			'if(MenuAction.polyline()) MenuAction.changeStyle(this)',
			'MenuAction.remove()', 'MenuAction.grid()');
	this.init = function() {
		var toolObj = document.getElementById('tool');
		var obj = document.createElement('div');
		toolObj.appendChild(obj);
		toolObj.appendChild(this.createMenu());
		obj.id = 'movebar';
		obj.setAttribute('bindClass', this);
		this.obj = obj;
		obj.onmousedown = MenuEvent.mouseDown;
		obj.onmousemove = MenuEvent.mouseMove;
		obj.onmouseup = MenuEvent.mouseUp;
		obj.style.position = 'absolute';
		obj.style.left = this.left;
		obj.style.top = this.top;
		var td = document.createElement('div');
		td.innerHTML = '&nbsp;&nbsp;';
		obj.appendChild(td);
	};
	this.createMenu = function() {
		var obj = document.createElement('div');
		this.menuObj = obj;
		obj.id = this.id;
		obj.style.position = 'absolute';
		obj.style.height = this.height;
		obj.style.left = this.left + 8;
		obj.style.top = this.top;
		var tobj = document.createElement('table');
		obj.appendChild(tobj);
		var tb = document.createElement('tbody');
		tobj.appendChild(tb);
		var tr = document.createElement('tr');
		tb.appendChild(tr);
		var td = null;
		for ( var i = 0; i < this.img.length; i++) {
			td = document.createElement('td');
			tr.appendChild(td);
			td.innerHTML = '<img src="img/'
					+ this.img[i]
					+ '"><span onmousemove="MenuAction.over(this)" onmouseout="MenuAction.out(this)" onclick="'
					+ this.action[i] + '">' + this.text[i]
					+ '</span><img src="img/grid-blue-split.gif">';
		}
		return obj;
	};
	this.down = function() {
		var x = GroupEvent.getMouseX();
		var y = GroupEvent.getMouseY();
		x = GroupEvent.getX(x);
		y = GroupEvent.getY(y);
		this.x = x - this.obj.offsetLeft;
		this.y = y - this.obj.offsetTop;
		this.selected = true;
	};
	this.move = function() {
		if (this.selected) {
			var x = GroupEvent.getMouseX();
			var y = GroupEvent.getMouseY();
			this.left = GroupEvent.getX(x) - this.x;
			this.top = GroupEvent.getY(y) - this.y;
			this.obj.style.left = this.left + 'px';
			this.obj.style.top = this.top + 'px';
			this.menuObj.style.left = (this.left + 8) + 'px';
			this.menuObj.style.top = this.top + 'px';
		}
	};
	this.up = function() {
		this.selected = false;
		if (this.left < 10) {
			this.left = 10;
			this.obj.style.left = this.left + 'px';
			this.menuObj.style.left = (this.left + 8) + 'px';
		}
		if (this.top < 3) {
			this.top = 3;
			this.obj.style.top = this.top + 'px';
			this.menuObj.style.top = this.top + 'px';
		}
	}
};
var MenuEvent = {
	mouseDown : function() {
		var menu = document.getElementById('movebar');
		var menuClass = menu.getAttribute('bindClass');
		menu.setCapture();
		menuClass.down();
	},
	mouseMove : function() {
		var menu = document.getElementById('movebar');
		var menuClass = menu.getAttribute('bindClass');
		menuClass.move();
		return false;
	},
	mouseUp : function() {
		var menu = document.getElementById('movebar');
		var menuClass = menu.getAttribute('bindClass');
		menuClass.up();
		menu.releaseCapture();
		document.getElementById('group').focus();
	}
};
var MenuAction = {
	open : function() {
	},
	save : function() {
		var group = document.getElementById('group');
		var Love = group.getAttribute('bindClass');
		clipboardData.setData("Text", Love.toJson());
	},
	start : function() {
		var n = new NodeOval();
		n.init();
	},
	end : function() {
		var n = new NodeOval();
		n.setType('end');
		n.init();
	},
	nodeRect : function() {
		var n = new Node();
		n.init();
	},
	nodeImg : function() {
		var n = new NodeImg();
		n.init();
	},
	line : function() {
		var group = document.getElementById('group');
		var Love = group.getAttribute('bindClass');
		if (Love.lineFlag == null) {
			Love.lineFlag = 'line';
		} else if (Love.lineFlag == 'line') {
			Love.lineFlag = null;
		} else {
			return false;
		}
		return true;
	},
	polyline : function() {
		var group = document.getElementById('group');
		var Love = group.getAttribute('bindClass');
		if (Love.lineFlag == null) {
			Love.lineFlag = 'polyline';
		} else if (Love.lineFlag == 'polyline') {
			Love.lineFlag = null;
		} else {
			return false;
		}
		return true;
	},
	remove : function() {
		var group = document.getElementById('group');
		var Love = group.getAttribute('bindClass');
		Love.removeSelected();
	},
	grid : function() {
		var obj = document.body.style.backgroundImage;
		if (obj == '')
			document.body.style.backgroundImage = 'url(img/bg.jpg)';
		else
			document.body.style.backgroundImage = '';
	},
	changeStyle : function(obj) {
		if (obj.style.color == '')
			obj.style.color = '#ffffff';
		else
			obj.style.color = '';
	},
	over : function(obj) {
		obj.style.backgroundColor = '#A8D0F9';
	},
	out : function(obj) {
		obj.style.backgroundColor = '';
	}
}
function Node() {
	this.id = 'node_';
	this.name = 'New Node';
	this.number = -1;
	this.type = 'node';
	this.shape = 'rect';
	this.property = null;
	this.selected = false;
	this.left = 100;
	this.top = 80;
	this.width = 100;
	this.height = 40;
	this.mouseX = -1;
	this.mouseY = -1;
	this.x = -1;
	this.y = -1;
	this.strokeFlag = false;
	this.shadowFlag = true;
	this.textFlag = true;
	this.mirrorFlag = false;
	this.obj = null;
	this.shadowObj = null;
	this.textObj = null;
	this.strokeObj = null;
	this.init = function() {
		var groupObj = document.getElementById('group');
		var obj = document.createElement('v:rect');
		groupObj.appendChild(obj);
		obj.title = this.name;
		obj.style.position = 'absolute';
		obj.style.left = this.left;
		obj.style.top = this.top;
		obj.style.width = this.width;
		obj.style.height = this.height;
		obj.style.cursor = 'hand';
		obj.style.zIndex = '1';
		obj.strokecolor = 'blue';
		obj.strokeweight = '1';
		this.obj = obj;
		if (this.shadowFlag) {
			var shadowObj = document.createElement('v:shadow');
			shadowObj.on = 'T';
			shadowObj.type = 'single';
			shadowObj.color = '#b3b3b3';
			shadowObj.offset = '5px,5px';
			obj.appendChild(shadowObj);
			this.shadowObj = shadowObj;
		}
		if (this.strokeFlag) {
			var strokeObj = document.createElement('v:stroke');
			obj.appendChild(strokeObj);
			this.strokeObj = strokeObj;
		}
		if (this.textFlag) {
			var textObj = document.createElement('v:textbox');
			textObj.inset = '2pt,5pt,2pt,5pt';
			textObj.style.textAlign = 'center';
			textObj.style.color = 'blue';
			textObj.style.fontSize = '9pt';
			textObj.innerHTML = this.name;
			obj.appendChild(textObj);
			this.textObj = textObj;
		}
		if (!this.mirrorFlag) {
			var Love = groupObj.getAttribute('bindClass');
			if (this.number < 0) {
				this.number = Love.getObjectNum();
				this.id = this.id + this.number;
				obj.id = this.id;
				this.name = this.id;
				this.obj.title = this.id;
				this.textObj.innerHTML = this.id;
			}
			Love.nodes[Love.nodes.length] = this;
		}
	};
	this.setDisplay = function(flag) {
		this.obj.style.display = flag;
	};
	this.pointInObj = function(x, y) {
		var res = false;
		x = GroupEvent.getX(x);
		y = GroupEvent.getY(y);
		var x1 = this.left;
		var x2 = x1 + this.width;
		var y1 = this.top;
		var y2 = y1 + this.height;
		if ((x >= x1) && (x <= x2) && (y >= y1) && (y <= y2)) {
			this.mouseX = x;
			this.mouseY = y;
			this.x = x - this.obj.offsetLeft;
			this.y = y - this.obj.offsetTop;
			res = true;
		}
		return res;
	};
	this.move = function(x, y, mouseX, mouseY) {
		this.left = GroupEvent.getX(x) - this.x - GroupEvent.getX(mouseX)
				+ this.mouseX;
		this.top = GroupEvent.getY(y) - this.y - GroupEvent.getY(mouseY)
				+ this.mouseY;
		this.obj.style.left = this.left + 'px';
		this.obj.style.top = this.top + 'px';
	};
	this.moveEnd = function() {
		this.x = 0;
		this.y = 0;
		this.mouseX = this.left;
		this.mouseY = this.top
	};
	this.setSelected = function() {
		this.shadowObj.color = 'green';
		this.obj.strokecolor = 'green';
		this.textObj.style.color = 'green';
		this.selected = true;
	};
	this.clearSelected = function() {
		this.shadowObj.color = '#b3b3b3';
		this.obj.strokecolor = 'blue';
		this.textObj.style.color = 'blue';
		this.selected = false;
	};
	this.remove = function() {
		var group = document.getElementById('group');
		group.removeChild(this.obj);
	};
	this.setLeft = function(n) {
		this.left = n;
		this.obj.style.left = n;
	};
	this.setTop = function(n) {
		this.top = n;
		this.obj.style.top = n;
	};
	this.setWidth = function(n) {
		this.width = n;
		this.obj.style.width = n;
	};
	this.setHeight = function(n) {
		this.height = n;
		this.obj.style.height = n;
	};
	this.getDots = function() {
		var l = this.left;
		var t = this.top;
		var w = this.width;
		var h = this.height;
		var dots = new Array();
		var dot;
		dots[dots.length] = {
			x : l,
			y : t + h / 2
		};
		dots[dots.length] = {
			x : l + w,
			y : t + h / 2
		};
		dots[dots.length] = {
			x : l + w / 2,
			y : t
		};
		dots[dots.length] = {
			x : l + w / 2,
			y : t + h
		};
		dots[dots.length] = {
			x : l,
			y : t
		};
		dots[dots.length] = {
			x : l + w,
			y : t
		};
		dots[dots.length] = {
			x : l,
			y : t + h
		};
		dots[dots.length] = {
			x : l + w,
			y : t + h
		};
		return dots;
	};
	this.setProperty = function(type) {
		Prop.clear();
		document.getElementById(type + '_p_id').innerHTML = this.id;
		document.getElementById(type + '_p_name').value = this.name;
		if (this.property) {
			var num = this.property.length;
			for ( var i = 0; i < num; i++) {
				switch (this.property[i].text) {
				case 'span':
					document.getElementById(this.property[i].id).innerHTML = this.property[i].value;
					break;
				default:
					document.getElementById(this.property[i].id).value = this.property[i].value;
					break;
				}
			}
		}
	};
	this.getProperty = function(property) {
		this.property = property;
		this.name = property.n_p_name;
		this.title = this.name;
	};
	this.toJson = function() {
		var json = {
			id : this.id,
			name : this.name,
			type : this.type,
			shape : this.shape,
			number : this.number,
			left : this.left,
			top : this.top,
			width : this.width,
			height : this.height,
			property : this.property
		};
		return json;
	};
	this.jsonTo = function(json) {
		this.id = json.id;
		this.name = json.name;
		this.type = json.type;
		this.shape = json.shape;
		this.number = json.number;
		this.left = json.left;
		this.top = json.top;
		this.width = json.width;
		this.height = json.height;
		this.property = json.property;
	}
}
function test() {
	alert('测试');
};
function clickCheckBox() {
};
var Prop = {
	nodes : [ [ {
		subject : '环节ID',
		id : 'n_p_id',
		text : 'span'
	}, {
		subject : '环节名称',
		id : 'n_p_name',
		text : 'input'
	}, {
		subject : '环节描述',
		id : 'n_p_desc',
		text : 'textarea'
	} ], [ {
		subject : '群组',
		id : 'n_p_group',
		text : 'input',
		btn : {
			click : test,
			hide : true
		}
	}, {
		subject : '处理人',
		id : 'n_p_role',
		text : 'input',
		btn : {
			click : test,
			hide : true
		}
	}, {
		subject : '1',
		id : 'n_p_node',
		text : 'input'
	}, {
		subject : '2',
		id : 'n_p_dgroup',
		text : 'input',
		btn : {
			click : test,
			hide : true
		}
	}, {
		subject : '3',
		id : 'n_p_dnode',
		text : 'input',
		btn : {
			click : test,
			hide : true
		}
	}, {
		subject : '4',
		id : 'n_p_dcur',
		text : 'select',
		options : [ {
			id : '0',
			text : '否'
		}, {
			id : '1',
			text : '是'
		} ]
	}, {
		subject : '5',
		id : 'n_p_num',
		text : 'input'
	}, {
		subject : '6',
		id : 'n_p_other',
		text : 'input'
	} ], [ {
		subject : '1',
		id : 'n_p_in',
		text : 'input'
	}, {
		subject : '2',
		id : 'n_p_out',
		text : 'input'
	} ], [ {
		subject : '环节办理时限',
		id : 'n_p_time',
		text : 'input'
	}, {
		subject : '通知方式',
		id : 'n_p_timetype',
		text : 'input'
	}, {
		subject : '1',
		id : 'n_p_timeedit',
		text : 'input'
	}, {
		subject : '2',
		id : 'n_p_timesend',
		text : 'input'
	} ], [ {
		subject : '启动前调用',
		id : 'n_p_call1',
		text : 'input'
	}, {
		subject : '启动后调用',
		id : 'n_p_call2',
		text : 'input'
	}, {
		subject : '进行中调用',
		id : 'n_p_call3',
		text : 'input'
	}, {
		subject : '完成前调用',
		id : 'n_p_call4',
		text : 'input'
	}, {
		subject : '完成后调用',
		id : 'n_p_call5',
		text : 'input'
	} ] ],
	lines : [ [ {
		subject : 'ID',
		id : 'l_p_id',
		text : 'span'
	}, {
		subject : '名称',
		id : 'l_p_name',
		text : 'input'
	}, {
		subject : '描述',
		id : 'l_p_desc',
		text : 'textarea'
	}, {
		subject : '上一环节',
		id : 'l_p_pre',
		text : 'span'
	}, {
		subject : '下一环节',
		id : 'l_p_next',
		text : 'span'
	}, {
		subject : '1',
		id : 'l_p_type',
		text : 'input'
	}, {
		subject : '2',
		id : 'l_p_mp',
		text : 'input'
	}, {
		subject : '3',
		id : 'l_p_mpsel',
		text : 'input'
	}, {
		subject : '4',
		id : 'l_p_mptype',
		text : 'input'
	}, {
		subject : '5',
		id : 'l_p_mplx',
		text : 'input'
	} ], [ {
		subject : '可使用群组',
		id : 'l_p_group',
		text : 'input'
	}, {
		subject : '可使用角色',
		id : 'l_p_role',
		text : 'input'
	}, {
		subject : '不可使用群组',
		id : 'l_p_dgroup',
		text : 'input'
	}, {
		subject : '可使用角色',
		id : 'l_p_drole',
		text : 'input'
	} ] ],
	panels : [
			{
				flag : 'help',
				id : 'help',
				type : 0,
				title : '帮助',
				body : '1.环节可用鼠标拖拽<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;鼠标选中环节后不释放，拖拽鼠标，环节将随鼠标移动，释放鼠标后，环节不再移动。<br>'
						+ '2.路径的两个端点可以通过鼠标拖拽，改变路径指向的环节<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;鼠标选中路径的端点后不释放，拖拽鼠标，路径被选中的端点将鼠标移动，在选中的环节释放鼠标后，路径被选中的端点将指向该选中的环节。<br>'
						+ '3.ctrl+a，全选。<br>4.按住ctrl，鼠标选中对象，可以多选。<br>5.delete，删除选中对象。<br>6.使用鼠标多选<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;鼠标点击空白处不释放，拖拽鼠标，会出现一个长方形虚框，虚框的范围随着鼠标移动而变化，虚框范围内的对象将被选中。'
						+ '<br>'
			}, {
				flag : 'n',
				id : 'n_prop_panel',
				type : 1,
				title : '环节',
				tabs : [ {
					id : '常规',
					val : 0,
					type : 'nodes'
				}, {
					id : '候选人',
					val : 1,
					type : 'nodes'
				}, {
					id : '控制',
					val : 2,
					type : 'nodes'
				}, {
					id : '时限',
					val : 3,
					type : 'nodes'
				}, {
					id : '调用',
					val : 4,
					type : 'nodes'
				} ]
			}, {
				flag : 'l',
				id : 'l_prop_panel',
				type : 1,
				title : '路径',
				tabs : [ {
					id : '基本',
					val : 0,
					type : 'lines'
				}, {
					id : '人员',
					val : 1,
					type : 'lines'
				} ]
			} ],
	clear : function() {
		for ( var i = 0; i < this.nodes.length; i++) {
			var obj = this.nodes[i];
			for ( var j = 0; j < obj.length; j++) {
				switch (obj[j].text) {
				case 'span':
					document.getElementById(obj[j].id).innerHTML = '';
					break;
				default:
					document.getElementById(obj[j].id).value = '';
					break;
				}
			}
		}
		for ( var i = 0; i < this.lines.length; i++) {
			var obj = this.lines[i];
			for ( var j = 0; j < obj.length; j++) {
				switch (obj[j].text) {
				case 'span':
					document.getElementById(obj[j].id).innerHTML = '';
					break;
				default:
					document.getElementById(obj[j].id).value = '';
					break;
				}
			}
		}
	},
	setProperty : function(type) {
		var objs = null;
		if (type == 'n')
			objs = this.nodes;
		else
			objs = this.lines;
		var arr = [];
		for ( var i = 0; i < objs.length; i++) {
			var obj = objs[i];
			for ( var j = 0; j < obj.length; j++) {
				var v = null;
				switch (obj[j].text) {
				case 'span':
					v = document.getElementById(obj[j].id).innerHTML;
					break;
				default:
					v = document.getElementById(obj[j].id).value;
					break;
				}
				var json = {
					id : obj[j].id,
					text : obj[j].text,
					value : v
				};
				arr[arr.length] = json;
			}
		}
		return arr;
	}
}
function NodeImg() {
	this.id = 'node_';
	this.name = 'New Node';
	this.number = -1;
	this.type = 'node';
	this.shape = 'img';
	this.property = null;
	this.selected = false;
	this.left = 100;
	this.top = 80;
	this.width = 75;
	this.height = 70;
	this.imgHeight = 35;
	this.imgWidth = 35;
	this.textHeight = 35;
	this.textWidth = 75;
	this.imgDLeft = 20;
	this.textDTop = 40;
	this.mouseX = -1;
	this.mouseY = -1;
	this.x = -1;
	this.y = -1;
	this.strokeFlag = false;
	this.shadowFlag = true;
	this.textFlag = true;
	this.mirrorFlag = false;
	this.obj = null;
	this.shadowObj = null;
	this.textObj = null;
	this.strokeObj = null;
	this.init = function() {
		var groupObj = document.getElementById('group');
		var obj = document.createElement('img');
		obj.src = 'img/img.gif';
		groupObj.appendChild(obj);
		obj.title = this.name;
		obj.style.position = 'absolute';
		obj.style.left = this.left + this.imgDLeft;
		obj.style.top = this.top;
		obj.style.width = this.imgWidth;
		obj.style.height = this.imgHeight;
		obj.style.cursor = 'hand';
		obj.style.zIndex = '1';
		this.obj = obj;
		if (this.textFlag) {
			var textObj = document.createElement('div');
			textObj.style.backgroundColor = '#CEDEF0';
			textObj.style.position = 'absolute';
			textObj.style.left = this.left;
			textObj.style.top = this.top + this.textDTop;
			textObj.style.width = this.textWidth;
			textObj.style.height = this.textHeight;
			textObj.style.textAlign = 'center';
			textObj.style.fontSize = '9pt';
			textObj.style.wordBreak = 'break-all';
			textObj.style.overflow = 'hidden';
			textObj.style.zIndex = '0';
			textObj.innerHTML = this.name;
			textObj.style.zIndex = '1';
			groupObj.appendChild(textObj);
			this.textObj = textObj;
		}
		if (!this.mirrorFlag) {
			var Love = groupObj.getAttribute('bindClass');
			if (this.number < 0) {
				this.number = Love.getObjectNum();
				this.id = this.id + this.number;
				obj.id = this.id;
				this.name = this.id;
				this.obj.title = this.id;
				if (this.textObj)
					this.textObj.innerHTML = this.id;
			}
			Love.nodes[Love.nodes.length] = this;
		}
	};
	this.setDisplay = function(flag) {
		this.obj.style.display = flag;
		this.textObj.style.display = flag;
	};
	this.pointInObj = function(x, y) {
		var res = false;
		x = GroupEvent.getX(x);
		y = GroupEvent.getY(y);
		var x1 = this.left + this.imgDLeft;
		var x2 = x1 + this.imgWidth;
		var y1 = this.top;
		var y2 = y1 + this.imgHeight;
		if ((x >= x1) && (x <= x2) && (y >= y1) && (y <= y2)) {
			this.mouseX = x;
			this.mouseY = y;
			this.x = x - this.obj.offsetLeft + this.imgDLeft;
			this.y = y - this.obj.offsetTop;
			res = true;
		}
		return res;
	};
	this.move = function(x, y, mouseX, mouseY) {
		this.left = GroupEvent.getX(x) - this.x - GroupEvent.getX(mouseX)
				+ this.mouseX;
		this.top = GroupEvent.getY(y) - this.y - GroupEvent.getY(mouseY)
				+ this.mouseY;
		this.obj.style.left = this.left + this.imgDLeft;
		this.obj.style.top = this.top;
		this.textObj.style.left = this.left;
		this.textObj.style.top = this.top + this.textDTop;
	};
	this.moveEnd = function() {
		this.x = 0;
		this.y = 0;
		this.mouseX = this.left;
		this.mouseY = this.top
	};
	this.setSelected = function() {
		this.textObj.style.backgroundColor = 'green';
		this.textObj.style.color = '#ffffff';
		this.selected = true;
	};
	this.clearSelected = function() {
		this.textObj.style.backgroundColor = '#CEDEF0';
		this.textObj.style.color = '';
		this.selected = false;
	};
	this.remove = function() {
		var group = document.getElementById('group');
		group.removeChild(this.obj);
		group.removeChild(this.textObj);
	};
	this.setLeft = function(n) {
		this.left = n;
		this.obj.style.left = this.left + this.imgDLeft;
		this.textObj.style.left = this.left;
	};
	this.setTop = function(n) {
		this.top = n;
		this.obj.style.top = this.top;
		this.textObj.style.top = this.top + this.textDTop;
	};
	this.setWidth = function(n) {
		this.width = n;
		this.obj.style.width = n;
	};
	this.setHeight = function(n) {
		this.height = n;
		this.obj.style.height = n;
	};
	this.getDots = function() {
		var l = this.left;
		var t = this.top;
		var w = this.width;
		var h = this.height;
		var dots = new Array();
		var dot;
		dots[dots.length] = {
			x : l + this.imgDLeft,
			y : t + this.imgHeight / 2
		};
		dots[dots.length] = {
			x : l + this.imgDLeft + this.imgWidth,
			y : t + this.imgHeight / 2
		};
		dots[dots.length] = {
			x : l + w / 2,
			y : t
		};
		dots[dots.length] = {
			x : l + w / 2,
			y : t + h
		};
		return dots;
	};
	this.setProperty = function(type) {
		Prop.clear();
		document.getElementById(type + '_p_id').innerHTML = this.id;
		document.getElementById(type + '_p_name').value = this.name;
		if (this.property) {
			var num = this.property.length;
			for ( var i = 0; i < num; i++) {
				switch (this.property[i].text) {
				case 'span':
					document.getElementById(this.property[i].id).innerHTML = this.property[i].value;
					break;
				default:
					document.getElementById(this.property[i].id).value = this.property[i].value;
					break;
				}
			}
		}
	};
	this.getProperty = function(property) {
		this.property = property;
		this.name = property.n_p_name;
		this.title = this.name;
	};
	this.toJson = function() {
		var json = {
			id : this.id,
			name : this.name,
			type : this.type,
			shape : this.shape,
			number : this.number,
			left : this.left,
			top : this.top,
			width : this.width,
			height : this.height,
			property : this.property
		};
		return json;
	};
	this.jsonTo = function(json) {
		this.id = json.id;
		this.name = json.name;
		this.type = json.type;
		this.shape = json.shape;
		this.number = json.number;
		this.left = json.left;
		this.top = json.top;
		this.width = json.width;
		this.height = json.height;
		this.property = json.property;
	}
}
JSON = new function() {
	this.decode = function() {
		var filter, result, self, tmp;
		if ($$("toString")) {
			switch (arguments.length) {
			case 2:
				self = arguments[0];
				filter = arguments[1];
				break;
			case 1:
				if ($[typeof arguments[0]](arguments[0]) === Function) {
					self = this;
					filter = arguments[0];
				} else
					self = arguments[0];
				break;
			default:
				self = this;
				break;
			}
			;
			if (rc.test(self)) {
				try {
					result = e("(".concat(self, ")"));
					if (filter && result !== null
							&& (tmp = $[typeof result](result))
							&& (tmp === Array || tmp === Object)) {
						for (self in result)
							result[self] = v(self, result) ? filter(self,
									result[self]) : result[self];
					}
				} catch (z) {
				}
			} else {
				throw new JSONError("bad data");
			}
		}
		;
		return result;
	};
	this.encode = function() {
		var self = arguments.length ? arguments[0] : this, result, tmp;
		if (self === null)
			result = "null";
		else if (self !== undefined && (tmp = $[typeof self](self))) {
			switch (tmp) {
			case Array:
				result = [];
				for ( var i = 0, j = 0, k = self.length; j < k; j++) {
					if (self[j] !== undefined && (tmp = JSON.encode(self[j])))
						result[i++] = tmp;
				}
				;
				result = "[".concat(result.join(","), "]");
				break;
			case Boolean:
				result = String(self);
				break;
			case Date:
				result = '"'.concat(self.getFullYear(), '-',
						d(self.getMonth() + 1), '-', d(self.getDate()), 'T',
						d(self.getHours()), ':', d(self.getMinutes()), ':',
						d(self.getSeconds()), '"');
				break;
			case Function:
				break;
			case Number:
				result = isFinite(self) ? String(self) : "null";
				break;
			case String:
				result = '"'.concat(self.replace(rs, s).replace(ru, u), '"');
				break;
			default:
				var i = 0, key;
				result = [];
				for (key in self) {
					if (self[key] !== undefined
							&& (tmp = JSON.encode(self[key])))
						result[i++] = '"'.concat(key.replace(rs, s).replace(ru,
								u), '":', tmp);
				}
				;
				result = "{".concat(result.join(","), "}");
				break;
			}
		}
		;
		return result;
	};
	this.toDate = function() {
		var self = arguments.length ? arguments[0] : this, result;
		if (rd.test(self)) {
			result = new Date;
			result.setHours(i(self, 11, 2));
			result.setMinutes(i(self, 14, 2));
			result.setSeconds(i(self, 17, 2));
			result.setMonth(i(self, 5, 2) - 1);
			result.setDate(i(self, 8, 2));
			result.setFullYear(i(self, 0, 4));
		} else if (rt.test(self))
			result = new Date(self * 1000);
		return result;
	};
	var c = {
		"\b" : "b",
		"\t" : "t",
		"\n" : "n",
		"\f" : "f",
		"\r" : "r",
		'"' : '"',
		"\\" : "\\",
		"/" : "/"
	}, d = function(n) {
		return n < 10 ? "0".concat(n) : n
	}, e = function(c, f, e) {
		e = eval;
		delete eval;
		if (typeof eval === "undefined")
			eval = e;
		f = eval("" + c);
		eval = e;
		return f
	}, i = function(e, p, l) {
		return 1 * e.substr(p, l)
	}, p = [ "", "000", "00", "0", "" ], rc = null, rd = /^[0-9]{4}\-[0-9]{2}\-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}$/, rs = /(\x5c|\x2F|\x22|[\x0c-\x0d]|[\x08-\x0a])/g, rt = /^([0-9]+|[0-9]+[,\.][0-9]{1,3})$/, ru = /([\x00-\x07]|\x0b|[\x0e-\x1f])/g, s = function(
			i, d) {
		return "\\".concat(c[d])
	}, u = function(i, d) {
		var n = d.charCodeAt(0).toString(16);
		return "\\u".concat(p[n.length], n)
	}, v = function(k, v) {
		return $[typeof result](result) !== Function
				&& (v.hasOwnProperty ? v.hasOwnProperty(k)
						: v.constructor.prototype[k] !== v[k])
	}, $ = {
		"boolean" : function() {
			return Boolean
		},
		"function" : function() {
			return Function
		},
		"number" : function() {
			return Number
		},
		"object" : function(o) {
			return o instanceof o.constructor ? o.constructor : null
		},
		"string" : function() {
			return String
		},
		"undefined" : function() {
			return null
		}
	}, $$ = function(m) {
		function $(c, t) {
			t = c[m];
			delete c[m];
			try {
				e(c)
			} catch (z) {
				c[m] = t;
				return 1
			}
		}
		;
		return $(Array) && $(Object)
	};
	try {
		rc = new RegExp(
				'^("(\\\\.|[^"\\\\\\n\\r])*?"|[,:{}\\[\\]0-9.\\-+Eaeflnr-u \\n\\r\\t])+?$')
	} catch (z) {
		rc = /^(true|false|null|\[.*\]|\{.*\}|".*"|\d+|\d+\.\d+)$/
	}
};
function NodeOval() {
	this.id = 'node_';
	this.name = 'New Node';
	this.number = -1;
	this.type = 'start';
	this.shape = 'oval';
	this.property = null;
	this.selected = false;
	this.left = 100;
	this.top = 80;
	this.width = 20;
	this.height = 20;
	this.mouseX = -1;
	this.mouseY = -1;
	this.x = -1;
	this.y = -1;
	this.strokeFlag = false;
	this.shadowFlag = true;
	this.textFlag = false;
	this.mirrorFlag = false;
	this.obj = null;
	this.shadowObj = null;
	this.textObj = null;
	this.strokeObj = null;
	this.init = function() {
		var groupObj = document.getElementById('group');
		var obj = document.createElement('v:oval');
		groupObj.appendChild(obj);
		obj.title = this.name;
		obj.style.position = 'absolute';
		obj.style.left = this.left;
		obj.style.top = this.top;
		obj.style.width = this.width;
		obj.style.height = this.height;
		obj.style.cursor = 'hand';
		obj.style.zIndex = '1';
		if (this.type == 'start') {
			obj.fillcolor = '#33CC00';
			obj.strokecolor = '#33CC00';
		} else {
			obj.fillcolor = 'red';
			obj.strokecolor = 'red';
		}
		obj.strokeweight = '1';
		this.obj = obj;
		if (this.shadowFlag) {
			var shadowObj = document.createElement('v:shadow');
			shadowObj.on = false;
			shadowObj.type = 'single';
			shadowObj.color = '#b3b3b3';
			shadowObj.offset = '3px,3px';
			obj.appendChild(shadowObj);
			this.shadowObj = shadowObj;
		}
		if (this.strokeFlag) {
			var strokeObj = document.createElement('v:stroke');
			obj.appendChild(strokeObj);
			this.strokeObj = strokeObj;
		}
		if (this.textFlag) {
			var textObj = document.createElement('v:textbox');
			textObj.inset = '2pt,5pt,2pt,5pt';
			textObj.style.textAlign = 'center';
			textObj.style.color = 'blue';
			textObj.style.fontSize = '9pt';
			textObj.innerHTML = this.name;
			obj.appendChild(textObj);
			this.textObj = textObj;
		}
		if (!this.mirrorFlag) {
			var Love = groupObj.getAttribute('bindClass');
			if (this.number < 0) {
				this.number = Love.getObjectNum();
				this.id = this.id + this.number;
				obj.id = this.id;
				this.name = this.id;
				this.obj.title = this.id;
				if (this.textObj)
					this.textObj.innerHTML = this.id;
			}
			Love.nodes[Love.nodes.length] = this;
		}
	};
	this.setType = function(type) {
		if (type)
			this.type = type;
	};
	this.setDisplay = function(flag) {
		this.obj.style.display = flag;
	};
	this.pointInObj = function(x, y) {
		var res = false;
		x = GroupEvent.getX(x);
		y = GroupEvent.getY(y);
		var x1 = this.left;
		var x2 = x1 + this.width;
		var y1 = this.top;
		var y2 = y1 + this.height;
		var centerX = x1 + this.width / 2;
		var centerY = y1 + this.height / 2;
		var radius = this.width / 2;
		var d = (x - centerX) * (x - centerX) + (y - centerY) * (y - centerY);
		if ((radius * radius) > d) {
			this.mouseX = x;
			this.mouseY = y;
			this.x = x - this.obj.offsetLeft;
			this.y = y - this.obj.offsetTop;
			res = true;
		}
		return res;
	};
	this.move = function(x, y, mouseX, mouseY) {
		this.obj.style.left = GroupEvent.getX(x) - this.x
				- GroupEvent.getX(mouseX) + this.mouseX;
		this.obj.style.top = GroupEvent.getY(y) - this.y
				- GroupEvent.getY(mouseY) + this.mouseY;
		this.left = parseInt(this.obj.style.left);
		this.top = parseInt(this.obj.style.top);
	};
	this.moveEnd = function() {
		this.x = 0;
		this.y = 0;
		this.mouseX = this.left;
		this.mouseY = this.top
	};
	this.setSelected = function() {
		this.shadowObj.on = 'T';
		if (this.textObj)
			this.textObj.style.color = 'green';
		this.selected = true;
	};
	this.clearSelected = function() {
		this.shadowObj.on = false;
		if (this.textObj)
			this.textObj.style.color = 'blue';
		this.selected = false;
	};
	this.remove = function() {
		var group = document.getElementById('group');
		group.removeChild(this.obj);
	};
	this.setLeft = function(n) {
		this.left = n;
		this.obj.style.left = n;
	};
	this.setTop = function(n) {
		this.top = n;
		this.obj.style.top = n;
	};
	this.setWidth = function(n) {
		this.width = n;
		this.obj.style.width = n;
	};
	this.setHeight = function(n) {
		this.height = n;
		this.obj.style.height = n;
	};
	this.getDots = function() {
		var l = this.left;
		var t = this.top;
		var w = this.width;
		var h = this.height;
		var dots = new Array();
		var dot;
		dots[dots.length] = {
			x : l,
			y : t + h / 2
		};
		dots[dots.length] = {
			x : l + w,
			y : t + h / 2
		};
		dots[dots.length] = {
			x : l + w / 2,
			y : t
		};
		dots[dots.length] = {
			x : l + w / 2,
			y : t + h
		};
		return dots;
	};
	this.setProperty = function(type) {
		Prop.clear();
		document.getElementById(type + '_p_id').innerHTML = this.id;
		document.getElementById(type + '_p_name').value = this.name;
		if (this.property) {
			var num = this.property.length;
			for ( var i = 0; i < num; i++) {
				switch (this.property[i].text) {
				case 'span':
					document.getElementById(this.property[i].id).innerHTML = this.property[i].value;
					break;
				default:
					document.getElementById(this.property[i].id).value = this.property[i].value;
					break;
				}
			}
		}
	};
	this.getProperty = function(property) {
		this.property = property;
		this.name = property.n_p_name;
		this.title = this.name;
	};
	this.toJson = function() {
		var json = {
			id : this.id,
			name : this.name,
			type : this.type,
			shape : this.shape,
			number : this.number,
			left : this.left,
			top : this.top,
			width : this.width,
			height : this.height,
			property : this.property
		};
		return json;
	};
	this.jsonTo = function(json) {
		this.id = json.id;
		this.name = json.name;
		this.type = json.type;
		this.shape = json.shape;
		this.number = json.number;
		this.left = json.left;
		this.top = json.top;
		this.width = json.width;
		this.height = json.height;
		this.property = json.property;
	}
}
function PolyLine() {
	this.id = 'line_';
	this.name = 'New Line';
	this.number = -1;
	this.type = 'line';
	this.shape = 'polyline';
	this.property = null;
	this.selected = false;
	this.fromX = -1;
	this.fromY = -1;
	this.toX = -1;
	this.toY = -1;
	this.polyDot = [];
	this.textFlag = false;
	this.mirrorFlag = false;
	this.obj = null;
	this.strokeObj = null;
	this.textObj = null;
	this.fromObj = null;
	this.toObj = null;
	this.init = function() {
		var groupObj = document.getElementById('group');
		var obj = document.createElement('v:polyline');
		groupObj.appendChild(obj);
		obj.title = this.name;
		obj.points.value = '0,20 50,0 100,20';
		obj.strokecolor = 'blue';
		obj.strokeweight = '1';
		obj.filled = 'false';
		obj.style.position = 'absolute';
		obj.style.zIndex = '2';
		obj.style.cursor = 'hand';
		this.obj = obj;
		var strokeObj = document.createElement('v:stroke');
		obj.appendChild(strokeObj);
		strokeObj.endArrow = "Classic";
		this.strokeObj = strokeObj;
		if (this.textFlag) {
			var textObj = document.createElement('v:textbox');
			textObj.inset = '10pt,1pt,5pt,5pt';
			textObj.style.textAlign = 'center';
			textObj.style.verticalAlign = 'bottom';
			textObj.style.color = 'blue';
			textObj.style.fontSize = '9pt';
			textObj.innerHTML = this.name;
			obj.appendChild(textObj);
			this.textObj = textObj;
		}
		if (!this.mirrorFlag) {
			var Love = groupObj.getAttribute('bindClass');
			if (this.number < 0) {
				this.number = Love.getObjectNum();
				this.id = this.id + this.number;
				obj.id = this.id;
				this.name = this.id;
				this.obj.title = this.id;
			}
			Love.lines[Love.lines.length] = this;
		}
	};
	this.setFrom = function(x, y, obj) {
		this.fromX = GroupEvent.getX(x);
		this.fromY = GroupEvent.getY(y);
		if (obj)
			this.fromObj = obj;
		this.polyDot = [];
		this.obj.points.value = this.getPointsValue();
	};
	this.setTo = function(x, y, obj) {
		this.toX = GroupEvent.getX(x);
		this.toY = GroupEvent.getY(y);
		if (obj)
			this.toObj = obj;
		this.polyDot = [];
		this.obj.points.value = this.getPointsValue();
	};
	this.setDisplay = function(flag) {
		this.obj.style.display = flag;
	};
	this.setShape = function(shape) {
		if (shape)
			this.shape = shape;
	};
	this.link = function(lineMirror) {
		this.fromObj = lineMirror.fromObj;
		this.toObj = lineMirror.toObj;
		this.relink();
		this.fromObj.clearSelected();
	};
	this.relink = function() {
		var fromDots = this.fromObj.getDots();
		var toDots = this.toObj.getDots();
		switch (this.shape) {
		case 'polyline':
			this.relinkPolyline(fromDots, toDots);
			break;
		case 'line':
			this.relinkLine(fromDots, toDots);
			break;
		default:
		}
	};
	this.relinkLine = function(fromDots, toDots) {
		var fromDotNum = fromDots.length;
		var toDotNum = toDots.length;
		var lineLen = -1;
		var fromDot;
		var toDot;
		for ( var i = 0; i < fromDotNum; i++) {
			for ( var j = 0; j < toDotNum; j++) {
				if (lineLen < 0) {
					lineLen = this.getLineLength(fromDots[i].x, fromDots[i].y,
							toDots[j].x, toDots[j].y);
					fromDot = fromDots[i];
					toDot = toDots[j];
				} else if (lineLen > this.getLineLength(fromDots[i].x,
						fromDots[i].y, toDots[j].x, toDots[j].y)) {
					lineLen = this.getLineLength(fromDots[i].x, fromDots[i].y,
							toDots[j].x, toDots[j].y);
					fromDot = fromDots[i];
					toDot = toDots[j];
				}
			}
		}
		this.fromX = fromDot.x;
		this.fromY = fromDot.y;
		this.toX = toDot.x;
		this.toY = toDot.y;
		this.obj.points.value = this.getPointsValue();
	};
	this.relinkPolyline = function(fromDots, toDots) {
		var fromDot;
		var toDot;
		this.polyDot = [];
		var xflag = -1;
		var yflag = -1;
		if ((this.fromObj.left + this.fromObj.width) < toDots[2].x) {
			fromDot = fromDots[1];
			toDot = toDots[0];
			xflag = 0;
		} else if (this.fromObj.left > toDots[2].x) {
			fromDot = fromDots[0];
			toDot = toDots[1];
			xflag = 1;
		} else {
			fromDot = fromDots[1];
			toDot = toDots[1];
			xflag = 2;
		}
		if (fromDots[0].y > toDots[3].y) {
			if (xflag == 2) {
				fromDot = fromDots[0];
				toDot = toDots[0];
				this.polyDot[0] = {
					x : Math.min(fromDot.x, toDot.x) - 30,
					y : fromDot.y
				};
				this.polyDot[1] = {
					x : Math.min(fromDot.x, toDot.x) - 30,
					y : toDot.y
				};
			} else {
				toDot = toDots[3];
				this.polyDot[0] = {
					x : toDot.x,
					y : fromDot.y
				};
			}
		} else if (fromDots[0].y < toDots[2].y) {
			if (xflag == 2) {
				this.polyDot[0] = {
					x : Math.max(fromDot.x, toDot.x) + 30,
					y : fromDot.y
				};
				this.polyDot[1] = {
					x : Math.max(fromDot.x, toDot.x) + 30,
					y : toDot.y
				};
			} else {
				toDot = toDots[2];
				this.polyDot[0] = {
					x : toDot.x,
					y : fromDot.y
				};
			}
		} else {
			if (xflag == 0) {
				fromDot = fromDots[2];
				toDot = toDots[2];
				this.polyDot[0] = {
					x : fromDot.x,
					y : Math.min(fromDot.y, toDot.y) - 10
				};
				this.polyDot[1] = {
					x : toDot.x,
					y : Math.min(fromDot.y, toDot.y) - 10
				};
			} else if (xflag == 1) {
				fromDot = fromDots[3];
				toDot = toDots[3];
				this.polyDot[0] = {
					x : fromDot.x,
					y : Math.max(fromDot.y, toDot.y) + 10
				};
				this.polyDot[1] = {
					x : toDot.x,
					y : Math.max(fromDot.y, toDot.y) + 10
				};
			}
		}
		this.fromX = fromDot.x;
		this.fromY = fromDot.y;
		this.toX = toDot.x;
		this.toY = toDot.y;
		this.obj.points.value = this.getPointsValue();
	};
	this.getPointsValue = function() {
		var res = this.fromX + ',' + this.fromY;
		for ( var i = 0; i < this.polyDot.length; i++) {
			res += ' ' + this.polyDot[i].x + ',' + this.polyDot[i].y;
		}
		res += ' ' + this.toX + ',' + this.toY;
		return res;
	};
	this.getLineLength = function(x1, y1, x2, y2) {
		return Math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
	};
	this.pointInObj = function(x, y) {
		var res = false;
		x = GroupEvent.getX(x);
		y = GroupEvent.getY(y);
		var x1 = this.fromX;
		var y1 = this.fromY;
		var x2 = this.toX;
		var y2 = this.toY;
		var x21 = x2 - x1;
		var y21 = y2 - y1;
		switch (this.shape) {
		case 'polyline':
			for ( var i = 0; i < this.polyDot.length; i++) {
				x2 = this.polyDot[i].x;
				y2 = this.polyDot[i].y;
				x21 = x2 - x1;
				y21 = y2 - y1;
				if (x21 == 0) {
					res = (Math.abs(x - x1) < 5) && (Math.min(y1, y2) <= y)
							&& (Math.max(y1, y2) >= y);
				} else if (y21 == 0) {
					res = (Math.abs(y - y1) < 5) && (Math.min(x1, x2) <= x)
							&& (Math.max(x1, x2) >= x);
				}
				if (res)
					break;
				x1 = x2;
				y1 = y2;
			}
			if (!res) {
				x2 = this.toX;
				y2 = this.toY;
				x21 = x2 - x1;
				y21 = y2 - y1;
				if (x21 == 0) {
					res = (Math.abs(x - x1) < 5) && (Math.min(y1, y2) <= y)
							&& (Math.max(y1, y2) >= y);
				} else if (y21 == 0) {
					res = (Math.abs(y - y1) < 5) && (Math.min(x1, x2) <= x)
							&& (Math.max(x1, x2) >= x);
				}
			}
			break;
		case 'line':
			if (x21 == 0) {
				res = (Math.abs(x - x1) < 5) && (Math.min(y1, y2) <= y)
						&& (Math.max(y1, y2) >= y);
			} else if (y21 == 0) {
				res = (Math.abs(y - y1) < 5) && (Math.min(x1, x2) <= x)
						&& (Math.max(x1, x2) >= x);
			} else {
				res = (Math.min(y1, y2) <= y)
						&& (Math.max(y1, y2) >= y)
						&& (Math.min(x1, x2) <= x)
						&& (Math.max(x1, x2) >= x)
						&& ((Math.abs(Math.floor((x21 / y21) * (y - y1) + x1
								- x)) < 5) || (Math.abs(Math.floor((y21 / x21)
								* (x - x1) + y1 - y)) < 5));
			}
			break;
		default:
		}
		return res;
	};
	this.pointInStroke = function(x, y) {
		var res = -1;
		x = GroupEvent.getX(x);
		y = GroupEvent.getY(y);
		var x1 = this.fromX;
		var x2 = this.toX;
		var y1 = this.fromY;
		var y2 = this.toY;
		if ((Math.abs(x2 - x) < 6) && (Math.abs(y2 - y) < 6))
			res = 0;
		if ((Math.abs(x1 - x) < 6) && (Math.abs(y1 - y) < 6))
			res = 1;
		return res;
	};
	this.setSelected = function() {
		this.obj.strokecolor = 'green';
		if (this.textObj)
			this.textObj.style.color = 'green';
		this.selected = true;
		this.obj.style.zIndex = '22';
	};
	this.move = function() {
	};
	this.moveEnd = function() {
	};
	this.setMoveSelected = function() {
		this.obj.strokecolor = 'red';
		if (this.textObj)
			this.textObj.style.color = 'green';
		this.selected = true;
		this.obj.style.zIndex = '22';
	};
	this.clearSelected = function() {
		this.obj.strokecolor = 'blue';
		if (this.textObj)
			this.textObj.style.color = 'blue';
		this.selected = false;
		this.obj.style.zIndex = '2';
	};
	this.remove = function() {
		var group = document.getElementById('group');
		group.removeChild(this.obj);
	};
	this.setProperty = function(type) {
		Prop.clear();
		document.getElementById(type + '_p_id').innerHTML = this.id;
		document.getElementById(type + '_p_name').value = this.name;
		document.getElementById(type + '_p_pre').innerHTML = this.fromObj.name;
		document.getElementById(type + '_p_next').innerHTML = this.toObj.name;
		if (this.property) {
			var num = this.property.length;
			for ( var i = 0; i < num; i++) {
				switch (this.property[i].text) {
				case 'span':
					document.getElementById(this.property[i].id).innerHTML = this.property[i].value;
					break;
				default:
					document.getElementById(this.property[i].id).value = this.property[i].value;
					break;
				}
			}
		}
	};
	this.getProperty = function(property) {
		this.property = property;
		this.name = property.l_p_name;
		this.title = this.name;
	};
	this.toJson = function() {
		var json = {
			id : this.id,
			name : this.name,
			type : this.type,
			shape : this.shape,
			number : this.number,
			from : this.fromObj.id,
			to : this.toObj.id,
			fromx : this.fromX,
			fromy : this.fromY,
			tox : this.toX,
			toy : this.toY,
			polydot : this.polyDot,
			property : this.property
		};
		return json;
	};
	this.jsonTo = function(json) {
		this.id = json.id;
		this.name = json.name;
		this.type = json.type;
		this.shape = json.shape;
		this.number = json.number;
		this.fromX = json.fromx;
		this.fromY = json.fromy;
		this.toX = json.tox;
		this.toY = json.toy;
		this.polyDot = json.polydot;
		this.property = json.property;
		var group = document.getElementById('group');
		var Love = group.getAttribute('bindClass');
		var nodes = Love.nodes;
		var nodeNum = nodes.length;
		var node = null;
		for ( var i = 0; i < nodeNum; i++) {
			node = nodes[i];
			if (node.id == json.from) {
				this.fromObj = node;
			} else if (node.id == json.to) {
				this.toObj = node;
			}
		}
	}
}
function Window() {
	this.id = 'propWin';
	this.left = 100;
	this.top = 3;
	this.height = 300;
	this.width = 400;
	this.title = '帮助';
	this.selected = false;
	this.x = -1;
	this.y = -1;
	this.obj = null;
	this.objBody = null;
	this.init = function() {
		var toolObj = document.getElementById('tool');
		var win = document.createElement('div');
		toolObj.appendChild(win);
		this.obj = win;
		win.setAttribute('bindClass', this);
		win.id = this.id;
		win.style.position = 'absolute';
		win.style.left = this.left;
		win.style.top = this.top;
		win.style.width = this.width;
		win.className = 'x-window';
		var s = '<div class="x-window-tl">';
		s += '<div class="x-window-tr"> ';
		s += '<div id="a1" class="x-window-tc"><div class="x-tool-close"></div><span>标题</span>';
		s += '</div> ';
		s += ' </div> ';
		s += '</div> ';
		s += '<div class="x-window-ml"> ';
		s += ' <div class="x-window-mr"> ';
		s += ' <div class="x-window-mc"> ';
		s += ' </div> ';
		s += ' </div> ';
		s += '</div> ';
		s += '<div class="x-window-bl"> ';
		s += '<div class="x-window-br"> ';
		s += '<div class="x-window-bc"> ';
		s += '</div> ';
		s += '</div> ';
		s += '</div>';
		win.appendChild(this.createTop());
		win.appendChild(this.createMiddle());
		win.appendChild(this.createBottom());
	};
	this.createTop = function() {
		var l = document.createElement('div');
		l.className = 'x-window-tl';
		var r = document.createElement('div');
		r.className = 'x-window-tr';
		l.appendChild(r);
		var c = document.createElement('div');
		c.className = 'x-window-tc';
		r.appendChild(c);
		c.setAttribute('pid', this.id);
		c.onmousedown = WindowEvent.mouseDown;
		c.onmousemove = WindowEvent.mouseMove;
		c.onmouseup = WindowEvent.mouseUp;
		var closeObj = document.createElement('div');
		closeObj.className = 'x-tool-close';
		c.appendChild(closeObj);
		closeObj.setAttribute('pid', this.id);
		closeObj.onclick = function() {
			var p = document.getElementById(this.pid);
			p.style.display = 'none';
		};
		var title = document.createElement('span');
		title.innerHTML = this.title;
		this.obj.t = title;
		c.appendChild(title);
		return l;
	};
	this.createMiddle = function() {
		var l = document.createElement('div');
		l.className = 'x-window-ml';
		var r = document.createElement('div');
		r.className = 'x-window-mr';
		l.appendChild(r);
		var c = document.createElement('div');
		c.className = 'x-window-mc';
		r.appendChild(c);
		for ( var i = 0; i < Prop.panels.length; i++) {
			var panel = document.createElement('div');
			panel.id = Prop.panels[i].id;
			if (i > 0)
				panel.style.display = 'none';
			c.appendChild(panel);
			if (Prop.panels[i].type == 1) {
				var tabs = new TabPanel();
				tabs.init();
				panel.appendChild(tabs.obj);
				panel.setAttribute('tabs', tabs);
				for ( var j = 0; j < Prop.panels[i].tabs.length; j++) {
					var tab = new Tab();
					tab
							.init(
									Prop.panels[i].tabs[j].id,
									Prop[Prop.panels[i].tabs[j].type][Prop.panels[i].tabs[j].val]);
					tabs.appendFuck(tab);
					panel.appendChild(tab.bObj);
					if (j == 0)
						tabs.setSelected(tab);
				}
			} else {
				panel.innerHTML = Prop.panels[i].body;
			}
		}
		return l;
	};
	this.createBottom = function() {
		var l = document.createElement('div');
		l.className = 'x-window-bl';
		var r = document.createElement('div');
		r.className = 'x-window-br';
		l.appendChild(r);
		var c = document.createElement('div');
		c.className = 'x-window-bc';
		r.appendChild(c);
		var ba = document.createElement('button');
		ba.setAttribute('pid', this.id);
		c.appendChild(ba);
		ba.className = 'btn';
		ba.value = '应用';
		ba.onclick = function() {
			var win = document.getElementById('propWin');
			var obj = win.selected;
			if (obj) {
				var type = win.type;
				if (obj) {
					obj.property = Prop.setProperty(type);
				}
				obj.name = document.getElementById(type + '_p_name').value;
				if (obj.textObj)
					obj.textObj.innerHTML = obj.name;
				obj.obj.title = obj.name;
			}
		};
		var b = document.createElement('button');
		b.setAttribute('pid', this.id);
		c.appendChild(b);
		b.className = 'btn';
		b.value = '关闭';
		b.onclick = function() {
			var p = document.getElementById(this.pid);
			p.style.display = 'none';
		};
		return l;
	};
	this.down = function() {
		var x = GroupEvent.getMouseX();
		var y = GroupEvent.getMouseY();
		x = GroupEvent.getX(x);
		y = GroupEvent.getY(y);
		this.x = x - this.obj.offsetLeft;
		this.y = y - this.obj.offsetTop;
		this.selected = true;
	};
	this.move = function() {
		if (this.selected) {
			var x = GroupEvent.getMouseX();
			var y = GroupEvent.getMouseY();
			this.left = GroupEvent.getX(x) - this.x;
			this.top = GroupEvent.getY(y) - this.y;
			this.obj.style.left = this.left + 'px';
			this.obj.style.top = this.top + 'px';
		}
	};
	this.up = function() {
		this.selected = false;
		if (this.left < 3) {
			this.left = 10;
			this.obj.style.left = this.left + 'px';
		}
		if (this.top < 3) {
			this.top = 3;
			this.obj.style.top = this.top + 'px';
		}
	}
};
var WindowEvent = {
	mouseDown : function() {
		var win = document.getElementById(this.pid);
		this.setCapture();
		var winClass = win.getAttribute('bindClass');
		winClass.down();
	},
	mouseMove : function() {
		var win = document.getElementById(this.pid);
		var winClass = win.getAttribute('bindClass');
		winClass.move();
		return false;
	},
	mouseUp : function() {
		var win = document.getElementById(this.pid);
		var winClass = win.getAttribute('bindClass');
		winClass.up();
		this.releaseCapture();
		document.getElementById('group').focus();
	}
}
function TabPanel() {
	this.tabs = [];
	this.obj = null;
	this.ulObj = null;
	this.selected = null;
	this.init = function() {
		var obj = document.createElement('div');
		obj.className = 'x-tab-panel-header';
		obj.setAttribute('bindClass', this);
		var wrapObj = document.createElement('div');
		wrapObj.className = 'x-tab-strip-top';
		obj.appendChild(wrapObj);
		var topObj = document.createElement('div');
		topObj.className = 'x-tab-strip-wrap';
		wrapObj.appendChild(topObj);
		var ulObj = document.createElement('ul');
		topObj.appendChild(ulObj);
		this.obj = obj;
		this.ulObj = ulObj;
	};
	this.appendFuck = function(tab) {
		this.ulObj.appendChild(tab.obj);
		tab.obj.pObj = this.obj;
		this.tabs[this.tabs.length] = tab;
	};
	this.setSelected = function(tab) {
		if (!tab) {
			tab = this.tabs[0];
		}
		if (this.selected) {
			this.selected.obj.className = '';
			this.selected.bObj.className = 'x-tab-panel-body';
		}
		this.selected = tab;
		tab.obj.className = 'x-tab-strip-active';
		tab.bObj.className = 'x-tab-panel-body-show';
	}
};
function Tab() {
	this.obj = null;
	this.bObj = null;
	this.init = function(title, content) {
		var obj = document.createElement('li');
		obj.setAttribute('bindClass', this);
		this.obj = obj;
		obj.onclick = function() {
			var tabsClass = this.pObj.getAttribute('bindClass');
			tabsClass.selected.obj.className = '';
			tabsClass.selected.bObj.className = 'x-tab-panel-body';
			tabsClass.selected = this.getAttribute('bindClass');
			this.className = 'x-tab-strip-active';
			this.bObj.className = 'x-tab-panel-body-show';
		};
		var l = document.createElement('div');
		l.className = 'x-tab-left';
		obj.appendChild(l);
		var r = document.createElement('div');
		r.className = 'x-tab-right';
		l.appendChild(r);
		var c = document.createElement('div');
		c.className = 'x-tab-middle';
		r.appendChild(c);
		c.innerHTML = title;
		var bObj = document.createElement('div');
		bObj.className = 'x-tab-panel-body';
		this.bObj = bObj;
		this.obj.bObj = bObj;
		this.createBody(bObj, content);
	};
	this.createBody = function(pobj, content) {
		for ( var i = 0; i < content.length; i++) {
			var json = content[i];
			var obj = document.createElement('div');
			pobj.appendChild(obj);
			var hObj = document.createElement('span');
			obj.appendChild(hObj);
			hObj.innerHTML = json.subject + '：';
			hObj.style.width = '120px';
			hObj.style.textAlign = 'center';
			var bObj = document.createElement(json.text);
			obj.appendChild(bObj);
			bObj.id = json.id;
			bObj.className = 'x-form-field';
			switch (json.text) {
			case 'select':
				for ( var j = 0; j < json.options.length; j++) {
					bObj.options[j] = new Option(json.options[j].text,
							json.options[j].id);
				}
				break;
			case 'textarea':
				bObj.rows = 10;
				break;
			default:
			}
			if (json.btn) {
				var btn = document.createElement('img');
				btn.src = 'img/drop-add.gif';
				btn.style.cursor = 'hand';
				btn.onclick = json.btn.click;
				obj.appendChild(btn);
			}
		}
	}
}

var g = new Group();
g.init();

g.setGroupArea();

var m = new Menu();
m.init();
var w = new Window();
w.left = screen.availWidth - 450;
w.init();

var jsonStr = '{"id":null,"name":null,"count":37,"nodes":[{"id":"node_1","name":"开始","type":"start","shape":"oval","number":1,"left":258,"top":63,"width":20,"height":20,"property":[{"id":"n_p_id","text":"span","value":"node_1"},{"id":"n_p_name","text":"input","value":"开始"},{"id":"n_p_desc","text":"textarea","value":""},{"id":"n_p_group","text":"input","value":""},{"id":"n_p_role","text":"input","value":""},{"id":"n_p_node","text":"input","value":""},{"id":"n_p_num","text":"input","value":""},{"id":"n_p_other","text":"input","value":""}]},{"id":"node_2","name":"结束","type":"end","shape":"oval","number":2,"left":612,"top":708,"width":20,"height":20,"property":[{"id":"n_p_id","text":"span","value":"node_2"},{"id":"n_p_name","text":"input","value":"结束"},{"id":"n_p_desc","text":"textarea","value":""},{"id":"n_p_group","text":"input","value":""},{"id":"n_p_role","text":"input","value":""},{"id":"n_p_node","text":"input","value":""},{"id":"n_p_num","text":"input","value":""},{"id":"n_p_other","text":"input","value":""}]},{"id":"node_3","name":"部门主任审批","type":"node","shape":"img","number":3,"left":230,"top":140,"width":75,"height":70,"property":[{"id":"n_p_id","text":"span","value":"node_3"},{"id":"n_p_name","text":"input","value":"部门主任审批"},{"id":"n_p_desc","text":"textarea","value":""},{"id":"n_p_group","text":"input","value":""},{"id":"n_p_role","text":"input","value":""},{"id":"n_p_node","text":"input","value":""},{"id":"n_p_num","text":"input","value":""},{"id":"n_p_other","text":"input","value":""}]},{"id":"node_4","name":"办公室主任审批","type":"node","shape":"img","number":4,"left":230,"top":255,"width":75,"height":70,"property":[{"id":"n_p_id","text":"span","value":"node_4"},{"id":"n_p_name","text":"input","value":"办公室主任审批"},{"id":"n_p_desc","text":"textarea","value":""},{"id":"n_p_group","text":"input","value":""},{"id":"n_p_role","text":"input","value":""},{"id":"n_p_node","text":"input","value":""},{"id":"n_p_num","text":"input","value":""},{"id":"n_p_other","text":"input","value":""}]},{"id":"node_5","name":"公司副总审批","type":"node","shape":"img","number":5,"left":230,"top":364,"width":75,"height":70,"property":[{"id":"n_p_id","text":"span","value":"node_5"},{"id":"n_p_name","text":"input","value":"公司副总审批"},{"id":"n_p_desc","text":"textarea","value":""},{"id":"n_p_group","text":"input","value":""},{"id":"n_p_role","text":"input","value":""},{"id":"n_p_node","text":"input","value":""},{"id":"n_p_num","text":"input","value":""},{"id":"n_p_other","text":"input","value":""}]},{"id":"node_9","name":"公司老总审批","type":"node","shape":"img","number":9,"left":384,"top":367,"width":75,"height":70,"property":[{"id":"n_p_id","text":"span","value":"node_9"},{"id":"n_p_name","text":"input","value":"公司老总审批"},{"id":"n_p_desc","text":"textarea","value":""},{"id":"n_p_group","text":"input","value":""},{"id":"n_p_role","text":"input","value":""},{"id":"n_p_node","text":"input","value":""},{"id":"n_p_num","text":"input","value":""},{"id":"n_p_other","text":"input","value":""}]},{"id":"node_11","name":"部门人员办理","type":"node","shape":"rect","number":11,"left":368,"top":177,"width":100,"height":40,"property":[{"id":"n_p_id","text":"span","value":"node_11"},{"id":"n_p_name","text":"input","value":"部门人员办理"},{"id":"n_p_desc","text":"textarea","value":""},{"id":"n_p_group","text":"input","value":""},{"id":"n_p_role","text":"input","value":""},{"id":"n_p_node","text":"input","value":""},{"id":"n_p_num","text":"input","value":""},{"id":"n_p_other","text":"input","value":""}]},{"id":"node_13","name":"相关部门领导办理","type":"node","shape":"img","number":13,"left":230,"top":501,"width":75,"height":70,"property":[{"id":"n_p_id","text":"span","value":"node_13"},{"id":"n_p_name","text":"input","value":"相关部门领导办理"},{"id":"n_p_desc","text":"textarea","value":""},{"id":"n_p_group","text":"input","value":""},{"id":"n_p_role","text":"input","value":""},{"id":"n_p_node","text":"input","value":""},{"id":"n_p_num","text":"input","value":""},{"id":"n_p_other","text":"input","value":""}]},{"id":"node_14","name":"相关部门人员办理","type":"node","shape":"img","number":14,"left":384,"top":504,"width":75,"height":70,"property":[{"id":"n_p_id","text":"span","value":"node_14"},{"id":"n_p_name","text":"input","value":"相关部门人员办理"},{"id":"n_p_desc","text":"textarea","value":""},{"id":"n_p_group","text":"input","value":""},{"id":"n_p_role","text":"input","value":""},{"id":"n_p_node","text":"input","value":""},{"id":"n_p_num","text":"input","value":""},{"id":"n_p_other","text":"input","value":""}]},{"id":"node_15","name":"部门人员办理","type":"node","shape":"img","number":15,"left":505,"top":213,"width":75,"height":70,"property":[{"id":"n_p_id","text":"span","value":"node_15"},{"id":"n_p_name","text":"input","value":"部门人员办理"},{"id":"n_p_desc","text":"textarea","value":""},{"id":"n_p_group","text":"input","value":""},{"id":"n_p_role","text":"input","value":""},{"id":"n_p_node","text":"input","value":""},{"id":"n_p_num","text":"input","value":""},{"id":"n_p_other","text":"input","value":""}]},{"id":"node_23","name":"相关人员办理","type":"node","shape":"img","number":23,"left":72,"top":277,"width":75,"height":70,"property":[{"id":"n_p_id","text":"span","value":"node_23"},{"id":"n_p_name","text":"input","value":"相关人员办理"},{"id":"n_p_desc","text":"textarea","value":""},{"id":"n_p_group","text":"input","value":""},{"id":"n_p_role","text":"input","value":""},{"id":"n_p_node","text":"input","value":""},{"id":"n_p_num","text":"input","value":""},{"id":"n_p_other","text":"input","value":""}]},{"id":"node_28","name":"财务部领导审批","type":"node","shape":"rect","number":28,"left":527,"top":437,"width":100,"height":40,"property":[{"id":"n_p_id","text":"span","value":"node_28"},{"id":"n_p_name","text":"input","value":"财务部领导审批"},{"id":"n_p_desc","text":"textarea","value":""},{"id":"n_p_group","text":"input","value":""},{"id":"n_p_role","text":"input","value":""},{"id":"n_p_node","text":"input","value":""},{"id":"n_p_num","text":"input","value":""},{"id":"n_p_other","text":"input","value":""}]},{"id":"node_30","name":"相关部门人员办理","type":"node","shape":"img","number":30,"left":309,"top":660,"width":75,"height":70,"property":[{"id":"n_p_id","text":"span","value":"node_30"},{"id":"n_p_name","text":"input","value":"相关部门人员办理"},{"id":"n_p_desc","text":"textarea","value":""},{"id":"n_p_group","text":"input","value":""},{"id":"n_p_role","text":"input","value":""},{"id":"n_p_node","text":"input","value":""},{"id":"n_p_num","text":"input","value":""},{"id":"n_p_other","text":"input","value":""}]},{"id":"node_31","name":"相关部门人员办理","type":"node","shape":"img","number":31,"left":526,"top":578,"width":75,"height":70,"property":[{"id":"n_p_id","text":"span","value":"node_31"},{"id":"n_p_name","text":"input","value":"相关部门人员办理"},{"id":"n_p_desc","text":"textarea","value":""},{"id":"n_p_group","text":"input","value":""},{"id":"n_p_role","text":"input","value":""},{"id":"n_p_node","text":"input","value":""},{"id":"n_p_num","text":"input","value":""},{"id":"n_p_other","text":"input","value":""}]}],"lines":[{"id":"line_6","name":"line_6","type":"line","shape":"line","number":6,"from":"node_1","to":"node_3","fromx":268,"fromy":83,"tox":267.5,"toy":140,"polydot":[],"property":null},{"id":"line_7","name":"line_7","type":"line","shape":"line","number":7,"from":"node_3","to":"node_4","fromx":267.5,"fromy":210,"tox":267.5,"toy":255,"polydot":[],"property":null},{"id":"line_10","name":"line_10","type":"line","shape":"polyline","number":10,"from":"node_4","to":"node_9","fromx":285,"fromy":272.5,"tox":421.5,"toy":367,"polydot":[{"x":421.5,"y":272.5}],"property":null},{"id":"line_12","name":"送办理","type":"line","shape":"polyline","number":12,"from":"node_3","to":"node_11","fromx":285,"fromy":157.5,"tox":418,"toy":177,"polydot":[{"x":418,"y":157.5}],"property":[{"id":"l_p_id","text":"span","value":"line_12"},{"id":"l_p_name","text":"input","value":"送办理"},{"id":"l_p_desc","text":"textarea","value":""},{"id":"l_p_pre","text":"span","value":"部门主任审批"},{"id":"l_p_next","text":"span","value":"部门人员办理"},{"id":"l_p_type","text":"select","value":"1"},{"id":"l_p_mp","text":"select","value":"0"},{"id":"l_p_mpsel","text":"select","value":"0"},{"id":"l_p_mptype","text":"select","value":"1"},{"id":"l_p_mplx","text":"select","value":"0"},{"id":"l_p_group","text":"input","value":""},{"id":"l_p_role","text":"input","value":""},{"id":"l_p_dgroup","text":"input","value":""},{"id":"l_p_drole","text":"input","value":""}]},{"id":"line_16","name":"line_16","type":"line","shape":"line","number":16,"from":"node_5","to":"node_13","fromx":267.5,"fromy":434,"tox":267.5,"toy":501,"polydot":[],"property":null},{"id":"line_17","name":"line_17","type":"line","shape":"line","number":17,"from":"node_13","to":"node_14","fromx":285,"fromy":518.5,"tox":404,"toy":521.5,"polydot":[],"property":null},{"id":"line_18","name":"line_18","type":"line","shape":"line","number":18,"from":"node_13","to":"node_9","fromx":285,"fromy":518.5,"tox":421.5,"toy":437,"polydot":[],"property":null},{"id":"line_19","name":"line_19","type":"line","shape":"line","number":19,"from":"node_9","to":"node_5","fromx":404,"fromy":384.5,"tox":285,"toy":381.5,"polydot":[],"property":null},{"id":"line_21","name":"line_21","type":"line","shape":"line","number":21,"from":"node_4","to":"node_5","fromx":267.5,"fromy":325,"tox":267.5,"toy":364,"polydot":[],"property":null},{"id":"line_22","name":"line_22","type":"line","shape":"polyline","number":22,"from":"node_5","to":"node_4","fromx":250,"fromy":381.5,"tox":250,"toy":272.5,"polydot":[{"x":220,"y":381.5},{"x":220,"y":272.5}],"property":null},{"id":"line_24","name":"line_24","type":"line","shape":"polyline","number":24,"from":"node_3","to":"node_23","fromx":250,"fromy":157.5,"tox":109.5,"toy":277,"polydot":[{"x":109.5,"y":157.5}],"property":null},{"id":"line_26","name":"line_26","type":"line","shape":"polyline","number":26,"from":"node_13","to":"node_23","fromx":250,"fromy":518.5,"tox":109.5,"toy":347,"polydot":[{"x":109.5,"y":518.5}],"property":null},{"id":"line_27","name":"line_27","type":"line","shape":"polyline","number":27,"from":"node_9","to":"node_15","fromx":439,"fromy":384.5,"tox":542.5,"toy":283,"polydot":[{"x":542.5,"y":384.5}],"property":null},{"id":"line_29","name":"line_29","type":"line","shape":"polyline","number":29,"from":"node_9","to":"node_28","fromx":439,"fromy":384.5,"tox":577,"toy":437,"polydot":[{"x":577,"y":384.5}],"property":null},{"id":"line_32","name":"line_32","type":"line","shape":"line","number":32,"from":"node_13","to":"node_30","fromx":267.5,"fromy":571,"tox":346.5,"toy":660,"polydot":[],"property":null},{"id":"line_33","name":"line_33","type":"line","shape":"line","number":33,"from":"node_14","to":"node_30","fromx":421.5,"fromy":574,"tox":346.5,"toy":660,"polydot":[],"property":null},{"id":"line_34","name":"line_34","type":"line","shape":"line","number":34,"from":"node_31","to":"node_30","fromx":546,"fromy":595.5,"tox":364,"toy":677.5,"polydot":[],"property":null},{"id":"line_36","name":"line_36","type":"line","shape":"polyline","number":36,"from":"node_14","to":"node_31","fromx":439,"fromy":521.5,"tox":563.5,"toy":578,"polydot":[{"x":563.5,"y":521.5}],"property":null},{"id":"line_37","name":"line_37","type":"line","shape":"polyline","number":37,"from":"node_30","to":"node_2","fromx":364,"fromy":677.5,"tox":622,"toy":708,"polydot":[{"x":622,"y":677.5}],"property":null}]}';
var j = JSON.decode(jsonStr);
g.jsonTo(j);
