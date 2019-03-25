package com.kizsoft.commons.util.view;

import java.io.InputStream;
import java.util.StringTokenizer;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class ViewDefine
{
  private String type;
  private String moduleid;
  private String viewName;
  private String unid;
  private String tables;
  private String order;
  private String morelink;
  private String[] filters;
  private String sql;
  private int rows = 15;
  private ViewColumn[] columns;

  public ViewDefine(InputStream xmlstream)
    throws Exception
  {
    DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
    DocumentBuilder parser = factory.newDocumentBuilder();
    Document doc = parser.parse(xmlstream);

    this.type = doc.getElementsByTagName("type").item(0).getFirstChild()
      .getNodeValue();

    if ((doc.getElementsByTagName("moduleid") != null) && 
      (doc.getElementsByTagName("moduleid").getLength() > 0)) {
      String moduleidStr = (doc.getElementsByTagName("moduleid").item(0).getFirstChild() == null) ? "" : doc.getElementsByTagName("moduleid").item(0).getFirstChild().getNodeValue();
      StringTokenizer tokens = new StringTokenizer(moduleidStr, ",");
      StringBuffer buffer = new StringBuffer();
      while (tokens.hasMoreTokens()) {
        String token = "'" + tokens.nextToken() + "'";
        if ("".equals(buffer.toString()))
          buffer.append(token);
        else {
          buffer.append("," + token);
        }
      }
      this.moduleid = buffer.toString();
    }

    if ((doc.getElementsByTagName("viewname") != null) && 
      (doc.getElementsByTagName("viewname").getLength() > 0)) {
      this.viewName = doc.getElementsByTagName("viewname").item(0)
        .getFirstChild().getNodeValue();
    }

    if ((doc.getElementsByTagName("unid") != null) && 
      (doc.getElementsByTagName("unid").getLength() > 0)) {
      this.unid = doc.getElementsByTagName("unid").item(0).getFirstChild()
        .getNodeValue();
    }

    if ((doc.getElementsByTagName("tables") != null) && 
      (doc.getElementsByTagName("tables").getLength() > 0)) {
      this.tables = doc.getElementsByTagName("tables").item(0).getFirstChild()
        .getNodeValue();
    }

    if ((doc.getElementsByTagName("order") != null) && 
      (doc.getElementsByTagName("order").getLength() > 0)) {
      this.order = doc.getElementsByTagName("order").item(0).getFirstChild()
        .getNodeValue();
    }

    if ((doc.getElementsByTagName("sql") != null) && 
      (doc.getElementsByTagName("sql").getLength() > 0)) {
      this.sql = doc.getElementsByTagName("sql").item(0).getFirstChild()
        .getNodeValue();
    }

    if ((doc.getElementsByTagName("morelink") != null) && 
      (doc.getElementsByTagName("morelink").getLength() > 0)) {
      this.morelink = doc.getElementsByTagName("morelink").item(0).getFirstChild()
        .getNodeValue();
    }

    this.rows = Integer.parseInt(doc.getElementsByTagName("rows").item(0)
      .getFirstChild().getNodeValue());

    if (doc.getElementsByTagName("filters") != null) {
      NodeList filternodes = doc.getElementsByTagName("filter");
      this.filters = new String[filternodes.getLength()];

      for (int i = 0; i < filternodes.getLength(); ++i) {
        Node filter = filternodes.item(i);
        this.filters[i] = filter.getFirstChild().getNodeValue();
      }

    }

    NodeList columnnodes = doc.getElementsByTagName("column");
    this.columns = new ViewColumn[columnnodes.getLength()];

    for (int i = 0; i < columnnodes.getLength(); ++i) {
      Node column = columnnodes.item(i);
      NodeList childs = column.getChildNodes();
      ViewColumn vc = new ViewColumn();
      for (int j = 0; j < childs.getLength(); ++j) {
        Node node = childs.item(j);
        String tag = node.getNodeName();
        String value = null;
        if (node.getFirstChild() != null)
          value = node.getFirstChild().getNodeValue();
        if ("title".equalsIgnoreCase(tag)) {
          vc.setTitle(value);
        }
        if ("property".equalsIgnoreCase(tag)) {
          vc.setProperty(value);
        }
        if ("filedtype".equalsIgnoreCase(tag)) {
          vc.setFiledtype(value);
        }
        if ("width".equalsIgnoreCase(tag)) {
          vc.setWidth(value);
        }
        if ("length".equalsIgnoreCase(tag)) {
          vc.setLength(Integer.parseInt(value));
        }
        if ("align".equalsIgnoreCase(tag)) {
          vc.setAlign(value);
        }
        if ("link".equalsIgnoreCase(tag)) {
          vc.setLink(value);
        }
      }
      this.columns[i] = vc;
    }
  }

  public String getViewName()
  {
    return this.viewName;
  }

  public void setViewName(String viewName)
  {
    this.viewName = viewName;
  }

  public ViewColumn[] getColumns()
  {
    return this.columns;
  }

  public void setColumns(ViewColumn[] columns)
  {
    this.columns = columns;
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

  public String getUnid()
  {
    return this.unid;
  }

  public void setUnid(String unid)
  {
    this.unid = unid;
  }

  public String getModuleid()
  {
    return this.moduleid;
  }

  public void setModuleid(String moduleId)
  {
    this.moduleid = moduleId;
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

  public String getMorelink()
  {
    return this.morelink;
  }

  public void setMorelink(String morelink)
  {
    this.morelink = morelink;
  }
}