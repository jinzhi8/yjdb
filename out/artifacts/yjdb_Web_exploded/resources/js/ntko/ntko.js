var NTKOJS = {};
NTKOJS.scriptPath = (function() {var elements = document.getElementsByTagName('script');for (var i = 0, len = elements.length; i < len; i++) {if (elements[i].src && elements[i].src.match(/ntko[\w\-\.]*\.js/)) {return elements[i].src.substring(0, elements[i].src.lastIndexOf('/') + 1);}}return "";})();
function LoadWebOffice(height,width) {
	height = typeof(height)=='undefined'?'640':height;
	width = typeof(width)=='undefined'?'100%':width;
	var s ='<object id="TANGER_OCX" classid="clsid:C9BC4DFF-4248-4a3c-8A49-63A7D317F404" ';
	s+=' codebase="'+NTKOJS.scriptPath+'OfficeControl.cab#version=5,0,2,1" width="'+width+'" height="'+height+'"> ';
	s+='<param name="IsUseUTF8URL" value="-1">';
	s+='<param name="IsUseUTF8Data" value="-1">';
	s+='<param name="BorderStyle" value="1">';
	s+='<param name="BorderColor" value="14402205">';
	s+='<param name="TitlebarColor" value="15658734">';
	s+='<param name="TitlebarTextColor" value="0">';
	s+='<param name="MenubarColor" value="14402205">';
	s+='<param name="MenuButtonColor" VALUE="16180947">';
	s+='<param name="MenuBarStyle" value="3">';
	s+='<param name="MenuButtonStyle" value="7">';
	s+='<param name="WebUserName" value="NTKO">';
	s+='<param name="ProductCaption" value="浙江索思科技有限公司">';
	s+='<param name="ProductKey" value="110DE020610D585434807DD6159B4BFC646B720E">';
	s+='<SPAN >系统控件已经更新，不能装载最新版本文档控件。<a STYLE="color:red" href="'+NTKOJS.scriptPath+'soa.exe">点击下载控件</a>并安装。如果安装后还不能显示，请在检查浏览器的选项中检查浏览器的安全设置。</SPAN>';
	s+='</object>';
	document.write(s);
}

function TANGER_OCX_SaveDoc()
{
	if(!TANGER_OCX_bDocOpen)
	{
		alert("您没有正在编辑的文档。");
		return;
	}
	var retHTML = TANGER_OCX_OBJ.SaveToURL
		(
			document.forms[0].action,  //此处为uploadedit.asp
			"EDITFILE",	//文件输入域名称,可任选,不与其他<input type=file name=..>的name部分重复即可
			"", //可选的其他自定义数据－值对，以&分隔。如：myname=tanger&hisname=tom,一般为空
			document.forms[0].filename.value, //文件名,此处从表单输入获取，也可自定义
			"myForm" //控件的智能提交功能可以允许同时提交选定的表单的所有数据.此处可使用id或者序号
		); //此函数会读取从服务器上返回的信息并保存到返回值中。
	document.open();
	document.write("<html><head><title>返回的数据</title></head><body>")
	document.write(retHTML+"<hr>");
	document.write('<br><a href="javascript:window.history.back()">返回</a></body>');
	document.close();
}
//允许或禁止显示修订工具栏和工具菜单（保护修订）
function TANGER_OCX_EnableReviewBar(boolvalue)
{
	if(!TANGER_OCX_bDocOpen)return;
	TANGER_OCX_OBJ.ActiveDocument.CommandBars("Reviewing").Enabled = boolvalue;
	TANGER_OCX_OBJ.ActiveDocument.CommandBars("Track Changes").Enabled = boolvalue;
	TANGER_OCX_OBJ.IsShowToolMenu = boolvalue;	//关闭或打开工具菜单
}

//打开或者关闭修订模式
function TANGER_OCX_SetReviewMode(boolvalue)
{
	if(!TANGER_OCX_bDocOpen)return;
	TANGER_OCX_OBJ.ActiveDocument.TrackRevisions = boolvalue;
}

//进入或退出痕迹保留状态，调用上面的两个函数
function TANGER_OCX_SetMarkModify(boolvalue)
{
	if(!TANGER_OCX_bDocOpen)return;
	TANGER_OCX_SetReviewMode(boolvalue);
	TANGER_OCX_EnableReviewBar(!boolvalue);
}

//显示/不显示修订文字
function TANGER_OCX_ShowRevisions(boolvalue)
{
	if(!TANGER_OCX_bDocOpen)return;
	TANGER_OCX_OBJ.ActiveDocument.ShowRevisions = boolvalue;
}

//打印/不打印修订文字
function TANGER_OCX_PrintRevisions(boolvalue)
{
	if(!TANGER_OCX_bDocOpen)return;
	TANGER_OCX_OBJ.ActiveDocument.PrintRevisions = boolvalue;
}
//设置页面布局
function TANGER_OCX_ChgLayout()
{
 	try
	{
		TANGER_OCX_OBJ.showdialog(5); //设置页面布局
	}
	catch(err){
		alert("错误：" + err.number + ":" + err.description);
	}
	finally{
	}
}

//打印文档
function TANGER_OCX_PrintDoc()
{
	try
	{
		TANGER_OCX_OBJ.printout(true);
	}
	catch(err){
		alert("错误：" + err.number + ":" + err.description);
	}
	finally{
	}
}
//允许或禁止文件－>新建菜单
function TANGER_OCX_EnableFileNewMenu(boolvalue)
{
	TANGER_OCX_OBJ.EnableFileCommand(0) = boolvalue;
}
//允许或禁止文件－>打开菜单
function TANGER_OCX_EnableFileOpenMenu(boolvalue)
{
	TANGER_OCX_OBJ.EnableFileCommand(1) = boolvalue;
}
//允许或禁止文件－>关闭菜单
function TANGER_OCX_EnableFileCloseMenu(boolvalue)
{
	TANGER_OCX_OBJ.EnableFileCommand(2) = boolvalue;
}
//允许或禁止文件－>保存菜单
function TANGER_OCX_EnableFileSaveMenu(boolvalue)
{
	TANGER_OCX_OBJ.EnableFileCommand(3) = boolvalue;
}
//允许或禁止文件－>另存为菜单
function TANGER_OCX_EnableFileSaveAsMenu(boolvalue)
{
	TANGER_OCX_OBJ.EnableFileCommand(4) = boolvalue;
}
//允许或禁止文件－>打印菜单
function TANGER_OCX_EnableFilePrintMenu(boolvalue)
{
	TANGER_OCX_OBJ.EnableFileCommand(5) = boolvalue;
}
//允许或禁止文件－>打印预览菜单
function TANGER_OCX_EnableFilePrintPreviewMenu(boolvalue)
{
	TANGER_OCX_OBJ.EnableFileCommand(6) = boolvalue;
}
//此函数用来加入一个自定义的文件头部
function TANGER_OCX_AddDocHeader( strHeader )
{
	var i,cNum = 30;
	var lineStr = "";
	try
	{
		for(i=0;i<cNum;i++) lineStr += "_";  //生成下划线
		with(TANGER_OCX_OBJ.ActiveDocument.Application)
		{
			Selection.HomeKey(6,0); // go home
			Selection.TypeText(strHeader);
			Selection.TypeParagraph(); 	//换行
			Selection.TypeText(lineStr);  //插入下划线
			// Selection.InsertSymbol(95,"",true); //插入下划线
			Selection.TypeText("★");
			Selection.TypeText(lineStr);  //插入下划线
			Selection.TypeParagraph();
			//Selection.MoveUp(5, 2, 1); //上移两行，且按住Shift键，相当于选择两行
			Selection.HomeKey(6,1);  //选择到文件头部所有文本
			Selection.ParagraphFormat.Alignment = 1; //居中对齐
			with(Selection.Font)
			{
				NameFarEast = "宋体";
				Name = "宋体";
				Size = 12;
				Bold = false;
				Italic = false;
				Underline = 0;
				UnderlineColor = 0;
				StrikeThrough = false;
				DoubleStrikeThrough = false;
				Outline = false;
				Emboss = false;
				Shadow = false;
				Hidden = false;
				SmallCaps = false;
				AllCaps = false;
				Color = 255;
				Engrave = false;
				Superscript = false;
				Subscript = false;
				Spacing = 0;
				Scaling = 100;
				Position = 0;
				Kerning = 0;
				Animation = 0;
				DisableCharacterSpaceGrid = false;
				EmphasisMark = 0;
			}
			Selection.MoveDown(5, 3, 0); //下移3行
		}
	}
	catch(err){
		//alert("错误：" + err.number + ":" + err.description);
	}
	finally{
	}
}
//从本地增加图片到文档指定位置
function AddPictureFromLocal()
{
	if(TANGER_OCX_bDocOpen)
	{	
    TANGER_OCX_OBJ.AddPicFromLocal(
	"", //路径
	true,//是否提示选择文件
	true,//是否浮动图片
	100,//如果是浮动图片，相对于左边的Left 单位磅
	100); //如果是浮动图片，相对于当前段落Top
	};	
}

//从URL增加图片到文档指定位置
function AddPictureFromURL(URL)
{
	if(TANGER_OCX_bDocOpen)
	{
    TANGER_OCX_OBJ.AddPicFromURL(
	URL,//URL 注意；URL必须返回Word支持的图片类型。
	true,//是否浮动图片
	150,//如果是浮动图片，相对于左边的Left 单位磅
	150);//如果是浮动图片，相对于当前段落Top
	};
}

//从本地增加印章文档指定位置
function AddSignFromLocal()
{

   if(TANGER_OCX_bDocOpen)
   {
      TANGER_OCX_OBJ.AddSignFromLocal(
	"匿名用户",//当前登陆用户
	"",//缺省文件
	true,//提示选择
	0,//left
	0)  //top
   }
}

//从URL增加印章文档指定位置
function AddSignFromURL(URL)
{
   if(TANGER_OCX_bDocOpen)
   {
      TANGER_OCX_OBJ.AddSignFromURL(
	"匿名用户",//当前登陆用户
	URL,//URL
	50,//left
	50)  //top
   }
}

//开始手写签名
function DoHandSign()
{
   if(TANGER_OCX_bDocOpen)
   {	
	TANGER_OCX_OBJ.DoHandSign(
	"匿名用户",//当前登陆用户 必须
	0,//笔型0－实线 0－4 //可选参数
	0x000000ff, //颜色 0x00RRGGBB//可选参数
	2,//笔宽//可选参数
	100,//left//可选参数
	50); //top//可选参数
	}
}
//开始手工绘图，可用于手工批示
function DoHandDraw()
{
	if(TANGER_OCX_bDocOpen)
	{	
	TANGER_OCX_OBJ.DoHandDraw(
	0,//笔型0－实线 0－4 //可选参数
	0x00ff0000,//颜色 0x00RRGGBB//可选参数
	3,//笔宽//可选参数
	200,//left//可选参数
	50);//top//可选参数
	}
}
//检查签名结果
function DoCheckSign()
{
	if(TANGER_OCX_bDocOpen)
	{		
	var ret = TANGER_OCX_OBJ.DoCheckSign
	(
	/*可选参数 IsSilent 缺省为FAlSE，表示弹出验证对话框,否则，只是返回验证结果到返回值*/
	);//返回值，验证结果字符串
	//alert(ret);
	}	
}