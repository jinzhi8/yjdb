<%@page language="java" contentType="text/html;charset=UTF-8" %>

<TABLE cellSpacing=0 cellPadding=0 border=0 align="center" width="100%" style="border-right:1px solid #7D7D7D;">
	<TBODY>
	<TR>
		<%String imgPath = "<img src='" + request.getContextPath() + "/resources/images/folder_16_pad.gif'>";

			int pagesNum = 5;
			String[] pagesName = new String[pagesNum];
			pagesName[0] = "moduleDefine.jsp";
			pagesName[1] = "moduleApplications.jsp";
			pagesName[2] = "moduleViews.jsp";
			pagesName[3] = "moduleActions.jsp";
			pagesName[4] = "moduleConfigs.jsp";

			String[] pagesTitle = new String[pagesNum];
			pagesTitle[0] = "模块信息";
			pagesTitle[1] = "应用管理";
			pagesTitle[2] = "视图管理";
			pagesTitle[3] = "操作管理";
			pagesTitle[4] = "配置管理";

			String[] pagesID = new String[pagesNum];
			pagesID[0] = "define";
			pagesID[1] = "applications";
			pagesID[2] = "views";
			pagesID[3] = "actions";
			pagesID[4] = "configs";

			String pageIndex = request.getParameter("pageidx");
			String docUNID = request.getParameter("unid");

			if (docUNID == null || "".equals(docUNID)) {
				out.print("<TD class=" + "'tab-on' onclick='return false;' >");
				out.print("&nbsp;" + imgPath + "&nbsp;" + pagesTitle[0] + "</TD>");
				out.print("\n");
			} else {
				if (pageIndex == null || "".equals(pageIndex)) pageIndex = "1";

				int idx = Integer.parseInt(pageIndex);
				for (int i = 1; i <= pagesNum; i++) {
					out.print("<TD class=" + (i == idx ? "'tab-on' onclick='return false;' " : "'tab-off' onclick='window.location=\"editModuleAction.do?action=" + pagesID[i - 1] + "&unid=" + docUNID + "\"'") + " >");
					//out.print("<TD class=" + (i==idx?"'tab-on' onclick='return false;' ":"'tab-off' onclick='window.location=\"" + pagesName[i-1] + "\"'") + " >");
					out.print("&nbsp;" + imgPath + "&nbsp;" + pagesTitle[i - 1] + "</TD>");
					out.print("\n");
				}
			}

		%>
	</TR>
	</TBODY>
</TABLE><!--索思奇智版权所有-->