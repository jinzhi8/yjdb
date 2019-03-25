package com.kizsoft.commons.acl.pojo;

import java.io.Serializable;
import java.util.Date;

public class Aclprivilelist
  implements Serializable
{
  private int hashValue;
  private String confid;
  private String workid;
  private String ownerid;
  private Long ownertype;
  private String purview;
  private Long agentsign;
  private Date agentstart;
  private Date agentend;
  private String worktype;
  private String workcode;

  public String getWorkcode()
  {
    return this.workcode;
  }

  public void setWorkcode(String workcode) {
    this.workcode = workcode;
  }

  public Aclprivilelist() {
    this.hashValue = 0;
  }

  public Aclprivilelist(String confid) {
    this.hashValue = 0;
    setConfid(confid);
  }

  public String getConfid() {
    return this.confid;
  }

  public void setConfid(String confid) {
    this.hashValue = 0;
    this.confid = confid;
  }

  public String getWorkid() {
    return this.workid;
  }

  public void setWorkid(String workid) {
    this.workid = workid;
  }

  public String getOwnerid() {
    return this.ownerid;
  }

  public void setOwnerid(String ownerid) {
    this.ownerid = ownerid;
  }

  public Long getOwnertype() {
    return this.ownertype;
  }

  public void setOwnertype(Long ownertype) {
    this.ownertype = ownertype;
  }

  public String getPurview() {
    return this.purview;
  }

  public void setPurview(String purview) {
    this.purview = purview;
  }

  public Long getAgentsign() {
    return this.agentsign;
  }

  public void setAgentsign(Long agentsign) {
    this.agentsign = agentsign;
  }

  public Date getAgentstart() {
    return this.agentstart;
  }

  public void setAgentstart(Date agentstart) {
    this.agentstart = agentstart;
  }

  public Date getAgentend() {
    return this.agentend;
  }

  public void setAgentend(Date agentend) {
    this.agentend = agentend;
  }

  public String getWorktype() {
    return this.worktype;
  }

  public void setWorktype(String worktype) {
    this.worktype = worktype;
  }

  public boolean equals(Object rhs) {
    if (rhs == null)
      return false;
    if (!(rhs instanceof Aclprivilelist))
      return false;
    Aclprivilelist that = (Aclprivilelist)rhs;
    return (getConfid() == null) || (that.getConfid() == null) || (getConfid().equals(that.getConfid()));
  }

  public int hashCode() {
    if (this.hashValue == 0) {
      int result = 17;
      int confidValue = (getConfid() != null) ? getConfid().hashCode() : 0;
      result = result * 37 + confidValue;
      this.hashValue = result;
    }
    return this.hashValue;
  }
}