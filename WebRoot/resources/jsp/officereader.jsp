<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML xmlns="http://www.w3.org/1999/xhtml">
<%@page language="java" contentType="text/html;charset=utf-8" %>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.File"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.FileNotFoundException"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="java.io.StringReader"%>
<%@page import="java.io.UnsupportedEncodingException"%>
<%@page import="java.net.ConnectException"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.regex.Matcher"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="com.artofsolving.jodconverter.DocumentConverter"%>
<%@page import="com.artofsolving.jodconverter.openoffice.connection.OpenOfficeConnection"%>
<%@page import="com.artofsolving.jodconverter.openoffice.connection.SocketOpenOfficeConnection"%>
<%@page import="com.artofsolving.jodconverter.openoffice.converter.OpenOfficeDocumentConverter"%>
<%!
	String getExtension(File file)
	{
		String name = file.getName();
		
		if((name != null) && (name.length() > 0))
		{
			int i = name.lastIndexOf('.');
			if((i > -1)&&(i < name.length()- 1))
			{
				return name.substring(i + 1);
			}
		}
		return null;
	}
	//生成文件
	void createFile(File file, String str)
	{
		PrintWriter outFile = null;
		try
		{
			outFile = new PrintWriter(file);
			outFile.write(str);
			outFile.flush();
			outFile.close();
		}
		catch (FileNotFoundException e)
		{
			e.printStackTrace();
		}
		finally 
		{
			if (outFile != null)
			{
				outFile.close();
			}
		}
	}
	//html内容纵向排列
	String youhua(String str)
	{
		StringReader sRead = new StringReader(str);

		int d1;
		StringBuilder d = new StringBuilder();
		try 
		{
			while ((d1 = sRead.read()) != -1)
			{
				if (d1 == 62) 
				{
					d.append((char) d1);
					d.append('\n');
				} 
				else
					d.append((char) d1);

			}
		} 
		catch (IOException e) 
		{
			e.printStackTrace();
		}
		finally 
		{
			if (sRead != null)
			{
				sRead.close();
			}
		}
		return d.toString();
	}
	
	// 获取html前后的string
	String getQianHou(String str) 
	{
		FileReader fr = null;

		try 
		{
			fr = new FileReader(str);
			char[] buf = new char[2048];
			int len = 0;
			while ((len = fr.read(buf)) != -1) 
			{
				return new String(buf, 0, len);
			}
		} 
		catch (IOException e) 
		{
			System.out.println(e.toString());
		} 
		finally 
		{
			if (fr != null)
			{
				try 
				{
					fr.close();
				} 
				catch (IOException e) 
				{
					System.out.println("close:" + e.toString());
				}
			}
		}
		return null;
	}

	/**
	 * 
	 * 将word文档转换成html文档
	 * 
	 * 
	 * 
	 * @param docFile
	 * 
	 *            需要转换的word文档
	 * 
	 * @param filepath
	 * 
	 *            转换之后html的存放路径
	 * 
	 * @return 转换之后的html文件
	 */

	File convert(File docFile, String filepath) 
	{

		// 创建保存html的文件
		File htmlFile = new File(filepath + "/"+java.util.UUID.randomUUID().toString().replaceAll("-", "")+ "/index.html");

		// 创建Openoffice连接
		OpenOfficeConnection con = new SocketOpenOfficeConnection(8100);
		try 
		{
			// 连接
			con.connect();
		} 
		catch (ConnectException e)
		{
			System.out.println("获取OpenOffice连接失败...");
			e.printStackTrace();
		}
		// 创建转换器
		DocumentConverter converter = new OpenOfficeDocumentConverter(con);
		// 转换文档问html
		converter.convert(docFile, htmlFile);
		// 关闭openoffice连接
		con.disconnect();
		return htmlFile;

	}
	/**
	 * 
	 * 将word转换成html文件，并且获取html文件代码。
	 * 
	 * 
	 * 
	 * @param docFile
	 * 
	 *            需要转换的文档
	 * 
	 * @param filepath
	 * 
	 *            文档中图片的保存位置
	 * 
	 * @return 转换成功的html代码
	 * @throws UnsupportedEncodingException
	 */

	String toHtmlString(File docFile, String filepath)
			throws UnsupportedEncodingException 
	{
		// 转换word文档
		File htmlFile = convert(docFile, filepath);
		// 获取html文件流
		StringBuffer htmlSb = new StringBuffer();

		try 
		{	
			BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(htmlFile)));
	
			while (br.ready()) 
			{
				htmlSb.append(br.readLine());
			}
			br.close();
			// 删除临时文件
			//htmlFile.delete();
		} 
		catch (FileNotFoundException e) 
		{
			
			e.printStackTrace();
		} 
		catch (IOException e)
		{
			e.printStackTrace();
		}
		// HTML文件字符串
		String htmlStr = htmlSb.toString();
		// 返回经过清洁的html文本
		return clearFormat1(htmlStr, filepath);

	}
	String clearStyleFormat(String htmlStr)
			throws UnsupportedEncodingException 
	{

		String styleReg = "<STYLE .*</STYLE>";

		Pattern stylePattern = Pattern.compile(styleReg);

		Matcher styleMatcher = stylePattern.matcher(htmlStr);

		if (styleMatcher.find())
		{

			// 获取BODY内容，并转化BODY标签为DIV
			String htmlStr1 = styleMatcher.group().replaceFirst("<STYLE", "<STYLE").replaceAll("</STYLE>", "</STYLE>");

			return htmlStr1;
		}
		return null;
	}
	
	
	String clearFormat1(String htmlStr, String filepath)
			throws UnsupportedEncodingException 
	{
		// TODO Auto-generated method stub

		String bodyReg = "<BODY .*</BODY>";

		Pattern bodyPattern = Pattern.compile(bodyReg);

		Matcher bodyMatcher = bodyPattern.matcher(htmlStr);

		if (bodyMatcher.find())
		{

			// 获取BODY内容，并转化BODY标签为DIV
			String htmlStr1 = bodyMatcher.group().replaceFirst("<BODY", "<DIV").replaceAll("</BODY>", "</DIV>");

			htmlStr1 = htmlStr1.replaceAll("(<P)([^>]*)(>.*?)(<\\/P>)","<p$3</p>");

			// 删除不需要的标签
			htmlStr1 = htmlStr1.replaceAll("<[/]?(xml|XML|del|span|SPAN|DEL|ins|INS|meta|META|[ovwxpOVWXP]:\\w+)[^>]*?>","");

			// 删除不需要的属性

			htmlStr1 = htmlStr1.replaceAll("<([^>]*)(?:lang|LANG|class|CLASS|[ovwxpOVWXP]:\\w+)=(?:'[^']*'|\"\"[^\"\"]*\"\"|[^>]+)([^>]*)>","<$1$2>");
			htmlStr1 = htmlStr1.replaceAll("<IMG SRC=\"","<IMG SRC=\"/oa/attachment/temp/");
			return htmlStr1;
		}
		return null;
	}

%>


<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<TITLE>正文</TITLE>
<%
//输入的文件
	File fileInput = new File("c:" + File.separator + "test1.doc");
	
	String htmlString = toHtmlString(fileInput, request.getSession().getServletContext().getRealPath("/attachment/temp"));
	//优化html格式
	String youhua = youhua(htmlString);
	//获取输入文件扩展名
	String kuozhan = getExtension(fileInput);
	out.print(clearStyleFormat(youhua));
%>
<style type="text/css"> 
html,body{background:#999; font-size:16px;line-height:1.5;}
div p{line-height:1.5;}
.word{width:650px;; background:#fff; border:1px solid #333; min-height:600px; margin-left:auto; margin-right:auto; padding-left:72px; padding-right:72px; 
padding-top:35px;}
.word .header{font-size:12px; border-bottom: 1px solid #999; text-align:right; color:#999}
.word .body{}
.word .body .title{ text-align:center; color:#f00; font-size:22px;}
.word .body .content{min-height:600px; /*高度最小值设置为：100px*/ height:auto !important; /*兼容FF,IE7也支持 !important标签*/ height:600px; /*兼容ie6*/ overflow:visible;}
.word .body .content p{ text-indent:2em;} 
.word .footer{font-size:12px; border-top: 1px solid #999; text-align:right; color:#999; position:relative; top:0px; left:0px; padding-top:5px; margin-
bottom:70px;}
#thumb {text-align:center;}
p{text-indent:2em;}
.excel{
border-collapse:collapse;
border-spacing:0;
border:1px solid #000000;
}
.excel td {
padding: 0;
border:1px solid #000000;
}
</style>
</HEAD>
<BODY>
<div class="word">
	
	<div class="header">您正在以纯文本预览文件！<!--&nbsp;<a style="color:red;text-decoration:none;" href="/oa/resources/jsp/docreader.jsp?view=html&uuid=65cb346378ed4f508defdeb8463e444c">使用HTML预览</a>-->&nbsp;<a style="color:red;text-decoration:none;" href="/oa/resources/jsp/docreader.jsp?view=office&uuid=65cb346378ed4f508defdeb8463e444c">使用OFFICE预览</a><br/>&nbsp;原文件下载：<a style="color:red;text-decoration:none;" href="/oa/DownloadAttach?uuid=65cb346378ed4f508defdeb8463e444c">文件头 .doc</a></div>
	
    <div class="body">
    	<h1 class="title">&nbsp;<!--文件头 文统筹办4号.doc--></h1>
        <div class="content">
		<div id="thumb"></div>
        	<p>&nbsp;<p>
<%
	
	if( kuozhan.equals("doc"))
	{
		String htmlString1 = youhua.toString();
		out.print(htmlString1);
		//String htmlString2 = new String(htmlString1.getBytes("utf-8"),"gbk");
		
		//File file1 = new File("c:" + File.separator + "test55.html");
		//createFile(file1, htmlString1);
		//htmlString1 = null;
	}
	else
	{
		//File file1 = new File("c:" + File.separator + "test55.html");
		//createFile(file1, youhua);
		//youhua = null;
		out.print(youhua);
	}
%>
        
		</div>
    </div>
    <div class="footer"><div class="info">附件大小：90.00KB&nbsp;<br/>&nbsp;<br/>&nbsp;<br/></div></div>
</div>
</BODY>
</HTML>