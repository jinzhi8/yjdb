<%@page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" import="java.io.BufferedReader,java.io.IOException,java.io.InputStreamReader,java.net.MalformedURLException,java.net.URL,java.net.URLConnection" %>
<% String contentURL = null;
	String CONTENT_URL_NAME = "url";

	//浠岩equest銮峰缑鎸囧畾镄勮璁块棶镄刄RL:

	if (contentURL == null) {

		contentURL = (String) request.getAttribute(CONTENT_URL_NAME);
	}

	if (contentURL == null) {

		contentURL = (String) request.getParameter(CONTENT_URL_NAME);
	}

	if (contentURL == null) {

		throw new ServletException("A content URL must be provided, as a '" + CONTENT_URL_NAME + "' request attribute or request parameter.");
	}

	URL url = null;

	try {

		//銮峰缑鍒拌鍐呭镄勮繛鎺ワ细

		url = new URL(contentURL);

		URLConnection urlConn = url.openConnection();

		//鍚戝鎴风灞旷ず鏂囨。鍐呭:

		String contentType = urlConn.getContentType();
		//response.setContentType(contentType);

		// 銮峰缑杈揿叆娴?

		BufferedReader in = null;
		try {
			in = new BufferedReader(new InputStreamReader(urlConn.getInputStream()));
		} catch (IOException e) {
			e.printStackTrace();
		}

		String contentString = "";

		String inputLine;
		try {
			while ((inputLine = in.readLine()) != null) {
				contentString = contentString + inputLine;
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		try {
			in.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		if (contentString.indexOf("<?xml") > -1) {
			response.setContentType("text/xml");
		}
		out.print(contentString);
		in.close();
	}

	catch (MalformedURLException me) {

		// 鏂扮殑URL鍒版潵镄勬椂链?

		throw new ServletException("URL: '" + contentURL + "' is malformed.");
	}

	catch (IOException ioe) {

		//鍦ㄥ垱寤烘柊镄勮繛鎺ョ殑镞跺€?

		throw new ServletException("Exception while opening '" + contentURL + "'': " + ioe.getMessage());
	}

	catch (Exception e) {

		//鍦ㄨ鍏ヨ緭鍏ョ殑镞跺€?

		throw new ServletException("Exception during proxy request: " + e.getMessage());
	}%><!--索思奇智版权所有-->