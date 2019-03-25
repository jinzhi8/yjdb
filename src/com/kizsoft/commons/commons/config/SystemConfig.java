package com.kizsoft.commons.commons.config;

import java.io.File;
import java.net.URL;
import org.dom4j.Document;
import org.dom4j.Node;
import org.dom4j.io.SAXReader;

public class SystemConfig
{
  protected static String confXmlName = File.separator + "config" + File.separator + "systemconfig.xml";
  
  protected static String getConfXmlName()
  {
    return confXmlName;
  }
  
  protected void setConfXmlName(String confXmlName)
  {
    confXmlName = confXmlName;
  }
  
  public static String getFieldValue(String fieldPath)
  {
    String strFileName = new File(SystemConfig.class.getResource("/").getPath()).getParent() + getConfXmlName();
    try
    {
      File xmlFile = new File(strFileName);
      if (xmlFile.exists())
      {
        SAXReader reader = new SAXReader();
        Document xmlDoc = reader.read(xmlFile);
        Node node = xmlDoc.selectSingleNode(fieldPath);
        return node == null ? "" : node.getText();
      }
      return "";
    }
    catch (Exception e)
    {
      e.printStackTrace();
    }
    return "";
  }
  
  public static String getFieldValue(String xmlPath, String fieldPath)
  {
    String strFileName = new File(SystemConfig.class.getResource("/").getPath()).getParent() + xmlPath;
    try
    {
      File xmlFile = new File(strFileName);
      if (xmlFile.exists())
      {
        SAXReader reader = new SAXReader();
        Document xmlDoc = reader.read(xmlFile);
        Node node = xmlDoc.selectSingleNode(fieldPath);
        return node == null ? "" : node.getText();
      }
      return "";
    }
    catch (Exception e)
    {
      e.printStackTrace();
    }
    return "";
  }
}
