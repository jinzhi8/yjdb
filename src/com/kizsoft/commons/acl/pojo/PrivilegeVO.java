package com.kizsoft.commons.acl.pojo;

import java.io.Serializable;

public class PrivilegeVO
  implements Serializable
{
  private String sourceid;
  private String privilegecode;
  private String sourcetype;
  private String sourcecode;

  public String getSourcecode()
  {
    return this.sourcecode;
  }

  public void setSourcecode(String sourcecode) {
    this.sourcecode = sourcecode;
  }

  public PrivilegeVO() {
  }

  public PrivilegeVO(String sourceid, String privilegecode, String sourcetype) {
    this.sourceid = sourceid;
    this.privilegecode = privilegecode;
    this.sourcetype = sourcetype;
  }

  public String getPrivilegecode() {
    return this.privilegecode;
  }

  public void setPrivilegecode(String privilegecode) {
    this.privilegecode = privilegecode;
  }

  public String getSourceid() {
    return this.sourceid;
  }

  public void setSourceid(String sourceid) {
    this.sourceid = sourceid;
  }

  public String getSourcetype() {
    return this.sourcetype;
  }

  public void setSourcetype(String sourcetype) {
    this.sourcetype = sourcetype;
  }
}