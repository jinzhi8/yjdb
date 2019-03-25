//���ڶԿؼ��е�Word�ĵ����в�����ʵ�ú�����������Ҫ��������tangerocx.js�еĺ���

//������ֹ��ʾ�޶��������͹��߲˵��������޶���
function WPSEnterRevisionMode(BoolValue)
{
    var doc = TANGER_OCX_OBJ.ActiveDocument;
    var app = doc.Application;
    var doctype = TANGER_OCX_OBJ.DocType;
    if( 6 != doctype)
    {
	    alert("�˹�����Ҫʹ��WPS��");
	    return;
    }
    var cmdbars = app.CommandBars; 
    TANGER_OCX_OBJ.IsShowToolMenu = !BoolValue;	//�رջ�򿪹��߲˵�
    doc.TrackRevisions = BoolValue;    
	cmdbars("Reviewing").Enabled = !BoolValue;
	cmdbars("Reviewing").Visible = !BoolValue;
	//RevisionTextPopupMenuOntbShortcutMenus ��ֹ�Ҽ��˵��������ʹ���ַ������С�
	cmdbars(40).Enabled = !BoolValue; 
	cmdbars(40).Visible = !BoolValue;
}

function TANGER_OCX_EnableReviewBar(boolvalue)
{
    try{
	TANGER_OCX_OBJ.ActiveDocument.CommandBars("Reviewing").Enabled = boolvalue;
	TANGER_OCX_OBJ.ActiveDocument.CommandBars("Track Changes").Enabled = boolvalue;
	TANGER_OCX_OBJ.IsShowToolMenu = boolvalue;	//�رջ�򿪹��߲˵�
	}catch(E){}finally{};
}

//�򿪻��߹ر��޶�ģʽ
function TANGER_OCX_SetReviewMode(boolvalue)
{
    try{
    TANGER_OCX_OBJ.SetReadOnly(false);
	TANGER_OCX_OBJ.ActiveDocument.TrackRevisions = boolvalue;
	}catch(E){}finally{};
}

//������˳��ۼ�����״̬�������������������
function TANGER_OCX_SetMarkModify(boolvalue)
{
    try{TANGER_OCX_OBJ.SetReadOnly(false);}catch(E){}finally{};
    if( 6 == TANGER_OCX_OBJ.doctype)
    {
    	WPSEnterRevisionMode(boolvalue);
    }
	else
	{
		TANGER_OCX_SetReviewMode(boolvalue);
		TANGER_OCX_EnableReviewBar(!boolvalue);
	}
}

//��ʾ/����ʾ�޶�����
function TANGER_OCX_ShowRevisions(boolvalue)
{
    try{TANGER_OCX_OBJ.SetReadOnly(false);}catch(E){}finally{};
	TANGER_OCX_OBJ.ActiveDocument.ShowRevisions = boolvalue;
}

//��ӡ/����ӡ�޶�����
function TANGER_OCX_PrintRevisions(boolvalue)
{
    try{TANGER_OCX_OBJ.SetReadOnly(false);}catch(E){}finally{};
	TANGER_OCX_OBJ.ActiveDocument.PrintRevisions = boolvalue;
}
//���������޶�
function TANGER_OCX_AcceptAllRevisions()
{
    try{TANGER_OCX_OBJ.SetReadOnly(false);}catch(E){}finally{};
	TANGER_OCX_OBJ.ActiveDocument.AcceptAllRevisions();
}


//�˺�����������һ���Զ�����ļ�ͷ��
function TANGER_OCX_AddDocHeader( strHeader )
{
	var i,cNum = 30;
	var lineStr = "";
	try
	{
		for(i=0;i<cNum;i++) lineStr += "_";  //�����»���
		with(TANGER_OCX_OBJ.ActiveDocument.Application)
		{
			Selection.HomeKey(6,0); // go home
			Selection.TypeText(strHeader);
			Selection.TypeParagraph(); 	//����
			Selection.TypeText(lineStr);  //�����»���
			// Selection.InsertSymbol(95,"",true); //�����»���
			Selection.TypeText("��");
			Selection.TypeText(lineStr);  //�����»���
			Selection.TypeParagraph();
			//Selection.MoveUp(5, 2, 1); //�������У��Ұ�סShift�����൱��ѡ������
			Selection.HomeKey(6,1);  //ѡ���ļ�ͷ�������ı�
			Selection.ParagraphFormat.Alignment = 1; //���ж���
			with(Selection.Font)
			{
				NameFarEast = "����";
				Name = "����";
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
			Selection.MoveDown(5, 3, 0); //����3��
		}
	}
	catch(err){
		//alert("����" + err.number + ":" + err.description);
	}
	finally{
	}
}
//��html form����ֵ������Word�ĵ��ı�ǩ��
function CopyTextToBookMark(inputname,BookMarkName)
{
	try
	{	
		var inputValue="";
		var j,elObj,optionItem;
		var elObj = document.forms[0].elements(inputname);		 
		if (!elObj)
		{
			alert("HTML��FORM��û�д�������"+ inputname);
			return;
		}
		switch(elObj.type)
		{
				case "select-one":
					inputValue = elObj.options[elObj.selectedIndex].text;
					break;
				case "select-multiple":
					var isFirst = true;
					for(j=0;j<elObj.options.length;j++)
					{
						optionItem = elObj.options[j];					
						if (optionItem.selected)
						{
							if(isFirst)
							{
								inputValue = optionItem.text;
								isFirst = false;
							}
							else
							{
								inputValue += "  " + optionItem.text;
							}
						}
					}
					
					break;
				default: // text,Areatext,selecte-one,password,submit,etc.
					inputValue = elObj.value;
					break;
		}
		//do copy
		//DEBUG
		//alert(inputname+"="+inputValue+" Bookmarkname="+BookMarkName);
		var bkmkObj = TANGER_OCX_OBJ.ActiveDocument.BookMarks(BookMarkName);	
		if(!bkmkObj)
		{
			alert("Word ģ���в���������Ϊ��\""+BookMarkName+"\"����ǩ��");
		}
		var saverange = bkmkObj.Range
		saverange.Text = inputValue;
		TANGER_OCX_OBJ.ActiveDocument.Bookmarks.Add(BookMarkName,saverange);
	}
	catch(err){
		
	}
	finally{
	}		
}