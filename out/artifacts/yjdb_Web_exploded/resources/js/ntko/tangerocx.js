//ͨ�õ�js���ͺ���

var TANGER_OCX_bDocOpen = false;
var TANGER_OCX_strOp; //��ʶ��ǰ������1:�½���2:�򿪱༭��3:���Ķ�
var TANGER_OCX_attachName; //��ʶ�Ѿ����ڵ����߱༭�ĵ�����������
var TANGER_OCX_attachURL; //���߱༭�ĵ�������URL
var TANGER_OCX_actionURL; //���ύ����URL
var TANGER_OCX_OBJ; //�ؼ�����
var TANGER_OCX_key=""; //����ǩ��
var TANGER_OCX_Username="�����û�";


//�˺�������ҳװ��ʱ�����á�������ȡ�ؼ����󲢱��浽TANGER_OCX_OBJ
//ͬʱ���������ó�ʼ�Ĳ˵�״�����򿪳�ʼ�ĵ��ȵȡ�
function TANGER_OCX_Init(initdocurl)
{
	TANGER_OCX_OBJ = document.all.item("TANGER_OCX");
	var useUTF8 = (document.charset == "utf-8");
	TANGER_OCX_OBJ.IsUseUTF8Data = useUTF8;	
	TANGER_OCX_OBJ.FileNew = false;
	TANGER_OCX_OBJ.FileClose = false;
	try
	{
		//����ñ����ύurl���������ݸ��ؼ���SaveToURL����
		TANGER_OCX_actionURL = document.forms[0].action; 
		//��ȡ��ǰ��������
		TANGER_OCX_strOp = document.all.item("TANGER_OCX_op").innerHTML;
		//��ȡ�Ѿ����ڵĸ�������	
		TANGER_OCX_attachName = document.all.item("TANGER_OCX_attachName").innerHTML;
		//��ȡ�Ѿ����ڵĸ���URL
		TANGER_OCX_attachURL = document.all.item("TANGER_OCX_attachURL").innerHTML;
		try{
		   TANGER_OCX_key = document.all.item("TANGER_OCX_key").innerHTML;
		}catch(err){}finally{};
		TANGER_OCX_OBJ.SetAutoCheckSignKey(TANGER_OCX_key);

		switch(TANGER_OCX_strOp)
		{
			case "1":
				if(initdocurl!="")
				{
					TANGER_OCX_OBJ.BeginOpenFromURL(initdocurl,false,false);//������URL,�Ƿ���ʾ����,�Ƿ�ֻ��
				}
				break;
			case "2":
				if(TANGER_OCX_attachURL)
				{
					TANGER_OCX_OBJ.BeginOpenFromURL(TANGER_OCX_attachURL,true,false);
				}
				else
				{
					if(initdocurl!="")
					TANGER_OCX_OBJ.BeginOpenFromURL(initdocurl,true,false);
				}
				break;
			case "3":
				if(TANGER_OCX_attachURL)
				{
					TANGER_OCX_OBJ.BeginOpenFromURL(TANGER_OCX_attachURL,true,true);
				}				
				break;
			default: //ȥҪ��ָ����ģ���ļ�����ʱ��TANGER_OCX_strOpָ������url
				//����ʹ�õ�ǰ�ĵ���URL�����ģ���URL,Ҳ���Ǹ���?openform����Ĳ���
				var keystr = "?openform&".toUpperCase();
				var parastring = window.location.search;
				//alert(parastring);
				var urlbegin = parastring.toUpperCase().indexOf(keystr);
				if(-1 != urlbegin)
				{
					TANGER_OCX_strOp = parastring.substr(urlbegin+keystr.length);
					//alert(TANGER_OCX_strOp);
					//�ж��Ƿ���WPSģ��
					var wpsKey = "vwWpsTurl".toUpperCase();
					var isWpsTemplateURL = (-1 != parastring.toUpperCase().indexOf(wpsKey));
					if(!isWpsTemplateURL)
					{
						TANGER_OCX_OBJ.BeginOpenFromURL(TANGER_OCX_strOp,true,false);
					}
					else
					{
						TANGER_OCX_OBJ.BeginOpenFromURL(TANGER_OCX_strOp,true,false,"WPS.Document");
					}
				}
				break;
		}		
	}
	catch(err){
		alert("����" + err.number + ":" + err.description);
	}
	finally{
	}
}
//������ʾ�Զ���˵���Ŀ
function addMyMenuItems()
{
	try{
		TANGER_OCX_OBJ = document.all.item("TANGER_OCX");
	    //�����Զ����ļ��˵���Ŀ
	    TANGER_OCX_OBJ.AddFileMenuItem('���浽������-�û��Զ���˵�',false,true,1);
		TANGER_OCX_OBJ.AddFileMenuItem('');
		//�����Զ������˵���Ŀ
		TANGER_OCX_OBJ.AddCustomMenuItem('�ҵĲ˵�1:�л���ֹ����',false,false,1);
		TANGER_OCX_OBJ.AddCustomMenuItem('');
		TANGER_OCX_OBJ.AddCustomMenuItem('�ҵĲ˵�2',false,false,2);
		TANGER_OCX_OBJ.AddCustomMenuItem('');	
		TANGER_OCX_OBJ.AddCustomMenuItem('�ҵĲ˵�3',false,false,3);
		TANGER_OCX_OBJ.AddCustomMenuItem('');	
		TANGER_OCX_OBJ.AddCustomMenuItem('�˲˵���Ҫ�򿪵��ĵ�����ʹ��',false,true,4);	
	}
	catch(err)
	{
	}
}

function ShowTitleBar(bShow)
{
	TANGER_OCX_OBJ.Titlebar = bShow;
}
function ShowMenubar(bShow)
{
	TANGER_OCX_OBJ.Menubar = bShow;
}
function ShowToolMenu(bShow)
{
	TANGER_OCX_OBJ.IsShowToolMenu = bShow;
}
//�ӱ�������ͼƬ���ĵ�ָ��λ��
function AddPictureFromLocal()
{
	if(TANGER_OCX_bDocOpen)
	{	
	    TANGER_OCX_OBJ.SetReadOnly(false);
        TANGER_OCX_OBJ.AddPicFromLocal(
        	"", //·��
        	true,//�Ƿ���ʾѡ���ļ�
        	true,//�Ƿ񸡶�ͼƬ
        	0,//����Ǹ���ͼƬ���������ߵ�Left ��λ��
        	0, //����Ǹ���ͼƬ������ڵ�ǰ����Top
        	1 //���λ��
    	);
	};	
}

//��URL����ͼƬ���ĵ�ָ��λ��
function AddPictureFromURL(URL)
{
	if(TANGER_OCX_bDocOpen)
	{
	    TANGER_OCX_OBJ.SetReadOnly(false);
        TANGER_OCX_OBJ.AddPicFromURL(
        	URL,//URL ע�⣻URL���뷵��Word֧�ֵ�ͼƬ���͡�
        	true,//�Ƿ񸡶�ͼƬ
        	0,//����Ǹ���ͼƬ���������ߵ�Left ��λ��
        	0,//����Ǹ���ͼƬ������ڵ�ǰ����Top
        	1 //���λ��
	    );
	};
}

//�ӱ�������ӡ���ĵ�ָ��λ��
function AddSignFromLocal()
{
//   alert(TANGER_OCX_key);
   if(TANGER_OCX_bDocOpen)
   {
      TANGER_OCX_OBJ.SetReadOnly(false);
      TANGER_OCX_OBJ.AddSignFromLocal
      (
    	TANGER_OCX_Username,//��ǰ��½�û�
    	"",//ȱʡ�ļ�
    	true,//��ʾѡ��
    	0,//left
    	0,
    	TANGER_OCX_key,
    	1,
    	100,
    	0
	  ) ;
   }
}

//��URL����ӡ���ĵ�ָ��λ��
function AddSignFromURL(URL)
{
//   alert(TANGER_OCX_key);
   if(TANGER_OCX_bDocOpen)
   {
        TANGER_OCX_OBJ.SetReadOnly(false);
        TANGER_OCX_OBJ.AddSignFromURL
        (
        	TANGER_OCX_Username,//��ǰ��½�û�
        	URL,//URL
        	0,//left
        	0,
        	TANGER_OCX_key,
        	1,
        	100,
        	0
        );  //top
   }
}

//��ʼ��дǩ��
function DoHandSign()
{
//   alert(TANGER_OCX_key);
    if(TANGER_OCX_bDocOpen)
    {	
        TANGER_OCX_OBJ.SetReadOnly(false);
    	TANGER_OCX_OBJ.DoHandSign2(TANGER_OCX_Username,TANGER_OCX_key); 
    }  
}
//��ʼ�ֹ���ͼ���������ֹ���ʾ
function DoHandDraw()
{
	if(TANGER_OCX_bDocOpen)
	{	
	    TANGER_OCX_OBJ.SetReadOnly(false);
    	TANGER_OCX_OBJ.DoHandDraw2();
	}
}
//���ǩ�����
function DoCheckSign()
{
//   alert(TANGER_OCX_key);
   if(TANGER_OCX_bDocOpen)
   {	
	var ret = TANGER_OCX_OBJ.DoCheckSign
	(
	false,/*��ѡ���� IsSilent ȱʡΪFAlSE����ʾ������֤�Ի���,����ֻ�Ƿ�����֤���������ֵ*/
	TANGER_OCX_key
	);//����ֵ����֤����ַ���
	//alert(ret);
   }	
}
//�ӷ������Ӹǰ�ȫӡ��
function addServerSecSign()
{
	var signUrl=document.all("secSignFileUrl").options[document.all("secSignFileUrl").selectedIndex].value;
		if(TANGER_OCX_OBJ.doctype==1||TANGER_OCX_OBJ.doctype==2||TANGER_OCX_OBJ.doctype==6)
		{
			try
			{
				alert("��ʽ�汾�û������EKEY��\r\n\r\n��Ϊ����ӡ��ϵͳ��ʾ���ܣ��빺����ʽ�汾��");
				TANGER_OCX_OBJ.AddSecSignFromURL("ntko",signUrl);}
			catch(error){}
		}
		else
		{alert("�����ڸ������ĵ���ʹ�ð�ȫǩ��ӡ��.");}
}
//�ӱ����Ӹǰ�ȫӡ��
function addLocalSecSign()
{
		if(TANGER_OCX_OBJ.doctype==1||TANGER_OCX_OBJ.doctype==2||TANGER_OCX_OBJ.doctype==6)
		{
			try
			{
				alert("��ʽ�汾�û������EKEY��\r\n\r\n��Ϊ����ӡ��ϵͳ��ʾ���ܣ��빺����ʽ�汾��");
				TANGER_OCX_OBJ.AddSecSignFromLocal("ntko","");}
			catch(error){}
		}
		else
		{alert("�����ڸ������ĵ���ʹ�ð�ȫǩ��ӡ��.");}
}
//��EKEY�Ӹǰ�ȫӡ��
function addEkeySecSign()
{
		if(TANGER_OCX_OBJ.doctype==1||TANGER_OCX_OBJ.doctype==2||TANGER_OCX_OBJ.doctype==6)
		{
			try
			{
				alert("��ʽ�汾�û������EKEY��\r\n\r\n��Ϊ����ӡ��ϵͳ��ʾ���ܣ��빺����ʽ�汾��");
				TANGER_OCX_OBJ.Activate(true);
				TANGER_OCX_OBJ.AddSecSignFromEkey("ntko");}
			catch(error){}
		}
		else
		{alert("�����ڸ������ĵ���ʹ�ð�ȫǩ��ӡ��.");}
}
//������д��ȫǩ��
function addHandSecSign()
{
		
		if(TANGER_OCX_OBJ.doctype==1||TANGER_OCX_OBJ.doctype==2||TANGER_OCX_OBJ.doctype==6)
		{
			try
			{
				alert("��ʽ�汾�û������EKEY��\r\n\r\n��Ϊ����ӡ��ϵͳ��ʾ���ܣ��빺����ʽ�汾��");
				TANGER_OCX_OBJ.AddSecHandSign("ntko");}
			catch(error){}
		}
		else
		{alert("�����ڸ������ĵ���ʹ�ð�ȫǩ��ӡ��.");}
}


//���ԭ�ȵı�������OnSubmit�¼��������ĵ�ʱ���Ȼ����ԭ�ȵ��¼���
function TANGER_OCX_doFormOnSubmit()
{
	var form = document.forms[0];
  	if (form.onsubmit)
	{
    	var retVal = form.onsubmit();
     	if (typeof retVal == "boolean" && retVal == false)
       	return false;
	}
	return true;
}


//������ֹ�û��ӿؼ���������
function TANGER_OCX_SetNoCopy(boolvalue)
{
	TANGER_OCX_OBJ.IsNoCopy = boolvalue;
}

//�����û���
function TANGER_OCX_SetDocUser(cuser)
{
    TANGER_OCX_Username = cuser;
	with(TANGER_OCX_OBJ.ActiveDocument.Application)
	{
		UserName = cuser;		
	}	
}

//����ҳ�沼��
function TANGER_OCX_ChgLayout()
{
 	try
	{
		TANGER_OCX_OBJ.showdialog(5); //����ҳ�沼��
	}
	catch(err){
		alert("����" + err.number + ":" + err.description);
	}
	finally{
	}
}

//��ӡ�ĵ�
function TANGER_OCX_PrintDoc(isBackground)
{
	var oldOption;	
	try
	{
		var objOptions =  TANGER_OCX_OBJ.ActiveDocument.Application.Options;
		oldOption = objOptions.PrintBackground;
		objOptions.PrintBackground = isBackground;
	}
	catch(err){};

	TANGER_OCX_OBJ.printout(!isBackground);

	try
	{
		var objOptions =  TANGER_OCX_OBJ.ActiveDocument.Application.Options;
		objOptions.PrintBackground = oldOption;
	}
	catch(err){};	
}

//�˺������ĵ��ر�ʱ�����á�
function TANGER_OCX_OnDocumentClosed()
{
	TANGER_OCX_bDocOpen = false;
}
//�˺����������浱ǰ�ĵ�����Ҫʹ���˿ؼ���SaveToURL������
//�йش˺�������ϸ�÷�������ı���ֲᡣ
function TANGER_OCX_SaveDoc(fileName)
{
	var retStr=new String;
	var newwin,newdoc;
	if(fileName=="")
	{
		alert("��ָ����������!");
		return;
	}
	try
	{
	 	if(!TANGER_OCX_doFormOnSubmit())return;
		if(!TANGER_OCX_bDocOpen)
		{
			alert("û�д򿪵��ĵ���");
			return;
		}
		//�ڱ༭״̬����Ҫɾ���ĸ�������
		var deleteFile = "";
		//����Ҫ����ĸ����ļ���		
		document.all.item("TANGER_OCX_filename").value = fileName;
		switch(TANGER_OCX_strOp)
		{			
			case "3":
				alert("�ĵ������Ķ�״̬�������ܱ��浽��������");
				break;	
			case "2": //��Ҫ����ɾ����ǰ���ĵ�����
				deleteFile = (TANGER_OCX_attachName=="")?"":"%%Detach="+escape(TANGER_OCX_attachName);
			case "1": 	
				//�½��ĵ�						
			default:
				retStr = TANGER_OCX_OBJ.SaveToURL(TANGER_OCX_actionURL,
				document.all.item("NTKO_UPLOADFIELD").name, //�ӱ����ļ����ؿؼ�������
				deleteFile,
				fileName,
				0 //ͬʱ�ύforms[0]����Ϣ
				);
				newwin = window.open("","_blank","left=200,top=200,width=400,height=200,status=0,toolbar=0,menubar=0,location=0,scrollbars=0,resizable=0",false);
				newdoc = newwin.document;
				newdoc.open();
				newdoc.write("<center><hr>"+retStr+"<hr><input type=button VALUE='�رմ���' onclick='window.close()'></center>");
				newdoc.close();				
				//window.alert(retStr);
				window.opener.location.reload();
			   window.close();
				break;
		}
	}
	catch(err){
		alert("���ܱ��浽URL��" + err.number + ":" + err.description);
	}
	finally{
	}
}

//�˺������ĵ���ʱ�����á�
function TANGER_OCX_OnDocumentOpened(str, obj)
{
	try
	{
		TANGER_OCX_bDocOpen = true;	
		//�����û���
		TANGER_OCX_SetDocUser(TANGER_OCX_Username);		
		if(obj)
		{
			switch(TANGER_OCX_strOp)
			{
				case "1":
				case "2":				    
				    TANGER_OCX_OBJ.SetReadOnly(false);
					break;
				case "3":
					TANGER_OCX_OBJ.SetReadOnly(true);
					break;
				default:
					break;
			}
		}	
	}
	catch(err){
		
	}
	finally{
	}
}
function SaveAsHTML(URL,uploadfield,fileName)
{
	try
	{
		var retStr = TANGER_OCX_OBJ.PublishAsHTMLToURL(
						URL,uploadfield,
						"__Click=0&subject="+escape(document.forms(0).Subject.value)+
						"&filename="+fileName,
						fileName
					);
		var newwin = window.open("","_blank","left=200,top=200,width=400,height=200,status=0,toolbar=0,menubar=0,location=0,scrollbars=0,resizable=0",false);
			var newdoc = newwin.document;
			newdoc.open();
			newdoc.write("<center><hr>"+retStr+"<hr><input type=button VALUE='�رմ���' onclick='window.close()'></center>");
			newdoc.close();	
	}
	catch(err){
		alert("���ܱ��浽URL��" + err.number + ":" + err.description);
	}
	finally{
	}
}