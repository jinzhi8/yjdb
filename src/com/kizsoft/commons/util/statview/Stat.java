package com.kizsoft.commons.util.statview;

import java.io.InputStream;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class Stat
{
  private String type;
  private String moduleid;
  private String unid;
  private String tables;
  private String order;
  private String[] filters;
  private String sql;
  private int rows;
  private StatViewColumn[] viewColumns;
  private StatItemColumn[] itemColumns;
  
  private void initSearch() {}
  
  public Stat(InputStream xmlstream)
    throws Exception
  {
    this.rows = 15;
    DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
    DocumentBuilder parser = factory.newDocumentBuilder();
    Document doc = parser.parse(xmlstream);
    Element root = doc.getDocumentElement();
    for (Node rootChild = root.getFirstChild(); rootChild != null; rootChild = rootChild.getNextSibling()) {
      if ("search".equalsIgnoreCase(rootChild.getNodeName()))
      {
        Element se = (Element)rootChild;
        Element items = (Element)se.getElementsByTagName("items").item(0);
        NodeList itemList = items.getElementsByTagName("item");
        this.itemColumns = new StatItemColumn[itemList.getLength()];
        for (int i = 0; i < itemList.getLength(); i++)
        {
          Element item = (Element)itemList.item(i);
          Node itemChild = item.getFirstChild();
          StatItemColumn itemColumn = new StatItemColumn();
          for (; itemChild != null; itemChild = itemChild.getNextSibling())
          {
            String itemValue = null;
            String itemName = itemChild.getNodeName();
            if (itemChild.getFirstChild() != null) {
              itemValue = itemChild.getFirstChild().getNodeValue();
            }
            if ("name".equalsIgnoreCase(itemName)) {
              itemColumn.setName(itemValue);
            } else if ("pageid".equalsIgnoreCase(itemName)) {
              itemColumn.setPageid(itemValue);
            } else if ("dbid".equalsIgnoreCase(itemName)) {
              itemColumn.setDbid(itemValue);
            } else if ("type".equalsIgnoreCase(itemName)) {
              itemColumn.setType(itemValue);
            } else if ("exp".equalsIgnoreCase(itemName)) {
              itemColumn.setExp(itemValue);
            }
          }
          this.itemColumns[i] = itemColumn;
        }
      }
      else if ("view".equalsIgnoreCase(rootChild.getNodeName()))
      {
        Element ve = (Element)rootChild;
        if ((ve.getElementsByTagName("type") != null) && (ve.getElementsByTagName("type").getLength() > 0)) {
          this.type = ve.getElementsByTagName("type").item(0).getFirstChild().getNodeValue();
        }
        if ((ve.getElementsByTagName("moduleid") != null) && (ve.getElementsByTagName("moduleid").getLength() > 0)) {
          this.moduleid = ve.getElementsByTagName("moduleid").item(0).getFirstChild().getNodeValue();
        }
        if ((ve.getElementsByTagName("unid") != null) && (ve.getElementsByTagName("unid").getLength() > 0)) {
          this.unid = ve.getElementsByTagName("unid").item(0).getFirstChild().getNodeValue();
        }
        if ((ve.getElementsByTagName("sql") != null) && (ve.getElementsByTagName("sql").getLength() > 0)) {
          this.sql = ve.getElementsByTagName("sql").item(0).getFirstChild().getNodeValue();
        }
        if ((ve.getElementsByTagName("order") != null) && (ve.getElementsByTagName("order").getLength() > 0)) {
          this.order = ve.getElementsByTagName("order").item(0).getFirstChild().getNodeValue();
        }
        this.rows = Integer.parseInt(ve.getElementsByTagName("rows").item(0).getFirstChild().getNodeValue());
        if (ve.getElementsByTagName("filters") != null)
        {
          NodeList filternodes = ve.getElementsByTagName("filter");
          this.filters = new String[filternodes.getLength()];
          for (int i = 0; i < filternodes.getLength(); i++)
          {
            Node filter = filternodes.item(i);
            if (filter.getFirstChild() != null) {
              this.filters[i] = filter.getFirstChild().getNodeValue();
            }
          }
        }
        Element columns = (Element)ve.getElementsByTagName("columns").item(0);
        NodeList columnList = columns.getElementsByTagName("column");
        this.viewColumns = new StatViewColumn[columnList.getLength()];
        for (int i = 0; i < columnList.getLength(); i++)
        {
          Element column = (Element)columnList.item(i);
          Node columnChild = column.getFirstChild();
          StatViewColumn viewColumn = new StatViewColumn();
          for (; columnChild != null; columnChild = columnChild.getNextSibling())
          {
            String columnValue = null;
            String columnName = columnChild.getNodeName();
            if (columnChild.getFirstChild() != null) {
              columnValue = columnChild.getFirstChild().getNodeValue();
            }
            if ("title".equalsIgnoreCase(columnName)) {
              viewColumn.setTitle(columnValue);
            } else if ("property".equalsIgnoreCase(columnName)) {
              viewColumn.setProperty(columnValue);
            } else if ("filedtype".equalsIgnoreCase(columnName)) {
              viewColumn.setFieldtype(columnValue);
            } else if ("width".equalsIgnoreCase(columnName)) {
              viewColumn.setWidth(columnValue);
            } else if ("length".equalsIgnoreCase(columnName)) {
              viewColumn.setLength(Integer.parseInt(columnValue));
            } else if ("align".equalsIgnoreCase(columnName)) {
              viewColumn.setAlign(columnValue);
            } else if ("link".equalsIgnoreCase(columnName)) {
              viewColumn.setLink(columnValue);
            }
          }
          this.viewColumns[i] = viewColumn;
        }
      }
    }
  }
  
  public StatViewColumn[] getViewColumns()
  {
    return this.viewColumns;
  }
  
  public void setViewColumns(StatViewColumn[] viewColumns)
  {
    this.viewColumns = viewColumns;
  }
  
  public int getRows()
  {
    return this.rows;
  }
  
  public void setRows(int rows)
  {
    this.rows = rows;
  }
  
  public String getSql()
  {
    return this.sql;
  }
  
  public void setSql(String sql)
  {
    this.sql = sql;
  }
  
  public String getModuleid()
  {
    return this.moduleid;
  }
  
  public void setModuleid(String moduleId)
  {
    this.moduleid = moduleId;
  }
  
  public String getUnid()
  {
    return this.unid;
  }
  
  public void setUnid(String unid)
  {
    this.unid = unid;
  }
  
  public String getType()
  {
    return this.type;
  }
  
  public void setType(String type)
  {
    this.type = type;
  }
  
  public String[] getFilters()
  {
    return this.filters;
  }
  
  public void setFilters(String[] filters)
  {
    this.filters = filters;
  }
  
  public String getTables()
  {
    return this.tables;
  }
  
  public void setTables(String tables)
  {
    this.tables = tables;
  }
  
  public String getOrder()
  {
    return this.order;
  }
  
  public void setOrder(String order)
  {
    this.order = order;
  }
  
  public StatItemColumn[] getItemColumns()
  {
    return this.itemColumns;
  }
  
  public void setItemColumns(StatItemColumn[] itemColumns)
  {
    this.itemColumns = itemColumns;
  }
}
