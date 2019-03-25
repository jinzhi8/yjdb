package com.kizsoft.commons.commons.util;

import java.io.Serializable;
import java.util.Date;

public class ReadInfo
  implements Serializable
{
  private String id;
  private String readUnid;
  private String readManID;
  private String readManName;
  private String readDepartmentID;
  private String readDepartmentName;
  private Date readTime;
  private String replyContent;

  public String getReplyContent()
  {
    return this.replyContent;
  }

  public void setReplyContent(String replyContent) {
    this.replyContent = replyContent;
  }

  public String getReadDepartmentID()
  {
    return this.readDepartmentID;
  }

  public String getReadDepartmentName()
  {
    return this.readDepartmentName;
  }

  public String getReadManID()
  {
    return this.readManID;
  }

  public String getReadManName()
  {
    return this.readManName;
  }

  public Date getReadTime()
  {
    return this.readTime;
  }

  public String getReadUnid()
  {
    return this.readUnid;
  }

  public String getId()
  {
    return this.id;
  }

  public void setReadDepartmentID(String newReadDepartmentID) {
    this.readDepartmentID = ((newReadDepartmentID == null) ? "" : newReadDepartmentID);
  }

  public void setReadDepartmentName(String newReadDepartmentName) {
    this.readDepartmentName = ((newReadDepartmentName == null) ? "" : newReadDepartmentName);
  }

  public void setReadManID(String newReadManID) {
    this.readManID = ((newReadManID == null) ? "" : newReadManID);
  }

  public void setReadManName(String newReadManName) {
    this.readManName = ((newReadManName == null) ? "" : newReadManName);
  }

  public void setReadTime(Date newReadTime) {
    this.readTime = ((newReadTime == null) ? new Date() : newReadTime);
  }

  public void setReadUnid(String newReadUnid) {
    this.readUnid = ((newReadUnid == null) ? "" : newReadUnid);
  }

  public void setId(String newUnid) {
    this.id = ((newUnid == null) ? "" : newUnid);
  }

  public String toString() {
    return this.readManName;
  }
}