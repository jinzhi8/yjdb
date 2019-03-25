package com.kizsoft.commons.util.view;

import java.util.HashMap;

public class ViewColumn
{
  private String title;
  private String property;
  private String width;
  private int length = 0;
  private String align;
  private String link;
  private String filedtype;
  private HashMap map;

  public String getAlign()
  {
    return this.align;
  }

  public void setAlign(String align) {
    this.align = align;
  }

  public int getLength() {
    return this.length;
  }

  public void setLength(int length) {
    this.length = length;
  }

  public String getLink() {
    return this.link;
  }

  public void setLink(String link) {
    this.link = link;
  }

  public String getProperty() {
    return this.property;
  }

  public void setProperty(String property) {
    this.property = property;
  }

  public String getTitle() {
    return this.title;
  }

  public void setTitle(String title) {
    this.title = title;
  }

  public String getWidth() {
    return this.width;
  }

  public void setWidth(String width) {
    this.width = width;
  }

  public String getFiledtype()
  {
    return this.filedtype;
  }

  public void setFiledtype(String filedtype)
  {
    this.filedtype = filedtype;
  }

  public void setMap(HashMap map) {
    this.map = map;
  }

  public HashMap getMap() {
    return this.map;
  }

  public String getShowLabel(String label) {
    String value = null;
    if (this.map != null)
      value = this.map.get(label).toString();
    if (value == null)
      value = label;
    return value;
  }
}