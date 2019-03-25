package com.kizsoft.commons.component.taglib.attachment;

import com.kizsoft.commons.Constant;
import com.kizsoft.commons.commons.attachment.AttachmentEntity;
import com.kizsoft.commons.commons.attachment.AttachmentManager;
import com.kizsoft.commons.component.entity.FieldEntity;
import java.util.ArrayList;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.TagSupport;
import org.apache.log4j.Logger;

public class AttachmentTag extends TagSupport
{
  final Logger log = Logger.getLogger(super.getClass().getName());
  private String table;
  private String attnum;
  private String moduleid;
  private String unid;
  private String type;
  private String target = "_self";
  private String showdelete;

  public void setTable(String table)
  {
    this.table = table;
  }

  public void setAttnum(String attnum) {
    this.attnum = attnum;
  }

  public void setShowdelete(String showdelete) {
    this.showdelete = showdelete;
  }

  public void setModuleid(String moduleid) {
    this.moduleid = moduleid;
  }

  public void setUnid(String unid) {
    this.unid = unid;
  }

  public void setType(String type) {
    this.type = type;
  }

  public void setTarget(String string) {
    this.target = string;
  }

  public int doEndTag()
  {
    int rowAttNum = 8;
    try
    {
      HttpServletRequest req = (HttpServletRequest)this.pageContext.getRequest();

      String docUnid = (String)this.pageContext.getAttribute(this.unid);
      if (docUnid == null) {
        docUnid = ((FieldEntity)req.getAttribute(this.unid)).getValue().toString();
      }

      ArrayList attList = new AttachmentManager().getAttachmentListByUNID(this.moduleid, docUnid, this.type);

      Vector vec = new Vector();

      if (attList != null) {
        for (int i = 0; i < attList.size(); ++i) {
          AttachmentEntity fileAttachment = (AttachmentEntity)attList.get(i);
          String[] tmpStr = new String[3];
          tmpStr[0] = fileAttachment.getAttachmentPath();

          tmpStr[1] = fileAttachment.getAttachmentName();
          if (tmpStr[1].equals(Constant.SENDDOC_FILENAME)) {
            tmpStr[1] = Constant.GETDOC_FILENAME;
          }

          tmpStr[2] = fileAttachment.getAttachmentId();
          vec.add(tmpStr);
        }
      }

      StringBuffer buffer = new StringBuffer();
      String attachmentIcon = "/resources/images/text.gif";

      if ((this.attnum != null) && (!"".equals(this.attnum))) {
        rowAttNum = Integer.parseInt(this.attnum);
      }

      int j = 0;
      for (int i = 0; i < vec.size(); ++i) {
        if (j == rowAttNum)
        {
          j = 0;
        }

        buffer.append("<table width=\"100%\"><tr>");
        String[] tmpStr = (String[])vec.get(i);
        if ((this.showdelete == null) || (!this.showdelete.equalsIgnoreCase("false"))) {
          buffer.append("<td width=\"30px\" align=\"right\" valign=\"bottom\"><input type=\"checkbox\" name=\"checkboxattach\" value=\"").append(tmpStr[2]).append("\"></td>");
        }

        if (("doc".equals(tmpStr[1].substring(tmpStr[1].lastIndexOf(".") + 1))) || ("docx".equals(tmpStr[1].substring(tmpStr[1].lastIndexOf(".") + 1)))) {
          buffer.append("<td width=\"30px\" align=\"right\">");
          buffer.append("<a target=\"").append("_blank").append("\" title=\"" + tmpStr[1] + "\" href=\"").append(req.getContextPath() + "/resources/jsp/docreader.jsp?view=office&uuid=" + tmpStr[2]).append("\">");
          buffer.append("<img src=\"").append(req.getContextPath() + attachmentIcon).append("\"></a></td>");
          buffer.append("<td align=\"left\" valign=\"bottom\">");
        }
        else
        {
          buffer.append("<td width=\"30px\" align=\"right\">");
          buffer.append("<a target=\"").append("_blank").append("\" title=\"" + tmpStr[1] + "\" href=\"").append(req.getContextPath() + "/DownloadAttach?uuid=" + tmpStr[2]).append("\">");
          buffer.append("<img src=\"").append(req.getContextPath() + attachmentIcon).append("\"></a></td>");
          buffer.append("<td align=\"left\" valign=\"bottom\">");
        }

        buffer.append(tmpStr[1]);
        buffer.append("&nbsp;<a style=\"color:red;\" target=\"_blank\" href=\"").append(req.getContextPath() + "/DownloadAttach?uuid=" + tmpStr[2]).append("\">附件下载</a>");
        buffer.append("&nbsp;<a style=\"color:red;\"").append(" href=\"javascript:void(0);\"").append(" onclick=\"showAttach('" + tmpStr[2] + "');\" >").append("附件预览</a>");
        buffer.append("</td>");
        buffer.append("</tr></table>");
        ++j;
      }
      if ((vec.size() > 0) && ((
        (this.showdelete == null) || (!this.showdelete.equalsIgnoreCase("false"))))) {
        buffer.append("<table width=\"100%\"><tr>");
        buffer.append("<td width=\"600px\" align=\"right\"><input type=\"button\" name=\"delattachbutton\"  class=\"formbutton\"  onclick=\"deleteattach()\" value=\"删除附件\"></td>");
        buffer.append("</tr></table>");
      }

      this.pageContext.getOut().print(buffer.toString());
    } catch (Exception ex) {
      this.log.info("attachment tag false.");
      ex.printStackTrace();
    }
    return 6;
  }
}