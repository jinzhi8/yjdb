package com.kizsoft.commons.component.dao;

import com.kizsoft.commons.acl.ACLManager;
import com.kizsoft.commons.acl.ACLManagerFactory;
import com.kizsoft.commons.commons.db.ConnectionProvider;
import com.kizsoft.commons.commons.sql.SQLHelper;
import com.kizsoft.commons.component.entity.ConfigEntity;
import com.kizsoft.commons.component.entity.FieldEntity;
import com.kizsoft.commons.component.entity.SelectEntity;
import com.kizsoft.commons.component.entity.ValueLabelEntity;
import com.kizsoft.commons.util.UUIDGenerator;
import java.io.StringReader;
import java.io.Writer;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import oracle.sql.CLOB;
import org.apache.log4j.Logger;

public class BaseDAO
{
  final Logger log;

  public BaseDAO()
  {
    this.log = Logger.getLogger(super.getClass().getName());
  }

  public ArrayList getAppByUnid(ConfigEntity entity, String unid)
  {
    Connection conn = null;
    ResultSet rs = null;
    PreparedStatement pstat = null;
    ArrayList list = new ArrayList();
    try {
      conn = ConnectionProvider.getConnection();
      String sql = entity.getSql();
      pstat = conn.prepareStatement(sql);
      pstat.setString(1, unid);
      rs = pstat.executeQuery();
      if (rs.next()) {
        ArrayList fields = entity.getFieldEntities();
        for (int i = 0; i < fields.size(); ++i) {
          FieldEntity fieldEntity = (FieldEntity)fields.get(i);
          if ((fieldEntity.getType() != null) && (fieldEntity.getDbColumn() != null))
          {
            String type = fieldEntity.getType().trim();
            if (type.equalsIgnoreCase("string")) {
              fieldEntity.setValue(rs.getString(fieldEntity.getDbColumn().trim()));
            }
            else if (type.equalsIgnoreCase("date")) {
              fieldEntity.setValue(rs.getDate(fieldEntity.getDbColumn()));
            }
            else if (type.equalsIgnoreCase("time")) {
              SimpleDateFormat tformat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
              if (rs.getTimestamp(fieldEntity.getDbColumn()) != null)
                fieldEntity.setValue(tformat.format(rs.getTimestamp(fieldEntity.getDbColumn())));
              else {
                fieldEntity.setValue("");
              }
            }
            else if ((type.equalsIgnoreCase("long")) || (type.equalsIgnoreCase("int")) || (type.equalsIgnoreCase("number")))
            {
              fieldEntity.setValue(new Long(rs.getLong(fieldEntity.getDbColumn())));
            }
            else if (type.equalsIgnoreCase("float")) {
              fieldEntity.setValue(new Float(rs.getFloat(fieldEntity.getDbColumn())));
            }
            else if (type.equalsIgnoreCase("checkbox")) {
              String value = rs.getString(fieldEntity.getDbColumn());

              if (fieldEntity.getCheckOn().equals(value))
                fieldEntity.setValue("1");
              else
                fieldEntity.setValue("0");
            }
            else if (type.equalsIgnoreCase("clob"))
            {
              fieldEntity.setValue(SQLHelper.ClobToString((CLOB)rs.getClob(fieldEntity.getDbColumn().trim())));
            }
          }
          list.add(fieldEntity);
        }
      }
    } catch (SQLException e) {
      e.printStackTrace();
    } finally {
      ConnectionProvider.close(conn, pstat, rs);
    }
    return list;
  }

  public ArrayList selectOptions(ConfigEntity entity, String userid)
  {
    Connection conn = null;
    ResultSet rs = null;
    PreparedStatement pstat = null;
    ArrayList list = new ArrayList();
    try {
      conn = ConnectionProvider.getConnection();
      String sql = "";
      ArrayList selects = new ArrayList();
      selects = entity.getSelectEntities();
      for (int j = 0; j < selects.size(); ++j) {
        SelectEntity selectEntity = new SelectEntity();
        selectEntity = (SelectEntity)selects.get(j);
        sql = selectEntity.getSql();

        if ((selectEntity.getFilter() != null) && (!"".equals(selectEntity.getFilter())))
        {
          sql = ACLManagerFactory.getACLManager().getACLSql(sql, selectEntity.getFilter(), userid);
        }

        pstat = conn.prepareStatement(sql);
        rs = pstat.executeQuery();
        ArrayList valueLabel = new ArrayList();
        while (rs.next()) {
          ValueLabelEntity valueLabelEntity = new ValueLabelEntity();
          valueLabelEntity.setLabel(rs.getString(selectEntity.getLabel()));

          valueLabelEntity.setValue(rs.getString(selectEntity.getValue()));

          valueLabel.add(valueLabelEntity);
        }
        selectEntity.setValueLabelEntities(valueLabel);
        list.add(selectEntity);
      }
    } catch (SQLException e) {
      this.log.error(e);
    } finally {
      ConnectionProvider.close(conn, pstat, rs);
    }
    return list;
  }

  public String add(ConfigEntity entity)
  {
    Connection conn = null;
    PreparedStatement pstat = null;

    int ret = 0;
    String unid = null;
    boolean hasClob = false;
    String clobStr = "";
    try {
      conn = ConnectionProvider.getConnection();
      String sql = entity.getSql();
      pstat = conn.prepareStatement(sql);
      ArrayList fields = new ArrayList();
      ArrayList clobList = new ArrayList();
      fields = entity.getFieldEntities();
      for (int j = 0; j < fields.size(); ++j) {
        FieldEntity fieldEntity = new FieldEntity();
        fieldEntity = (FieldEntity)fields.get(j);
        if (fieldEntity.getFormField().equalsIgnoreCase(entity.getPrimaryKey())) {
          if ((fieldEntity.getValue() == null) || (fieldEntity.getValue().equals("")))
          {
            unid = UUIDGenerator.getUUID();
            pstat.setString(j + 1, unid);
          } else {
            unid = fieldEntity.getValue().toString();
            pstat.setString(j + 1, fieldEntity.getValue().toString());
          }
        }
        else if (fieldEntity.getType().equalsIgnoreCase("long")) {
          if (fieldEntity.getValue() != null)
            pstat.setLong(j + 1, Long.parseLong(fieldEntity.getValue().toString()));
          else
            pstat.setLong(j + 1, 0L);
        }
        else if ((fieldEntity.getType().equalsIgnoreCase("date")) || (fieldEntity.getType().equalsIgnoreCase("time"))) {
          if ((fieldEntity.getValue() != null) && (!"".equals(fieldEntity.getValue()))) {
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

            if (fieldEntity.getValue().toString().indexOf(":") > -1)
              pstat.setTimestamp(j + 1, new Timestamp(df.parse(fieldEntity.getValue().toString()).getTime()));
            else
              pstat.setDate(j + 1, new java.sql.Date(sdf.parse(fieldEntity.getValue().toString()).getTime()));
          }
          else {
            pstat.setDate(j + 1, null);
          }
        } else if (fieldEntity.getType().equalsIgnoreCase("checkbox")) {
          if ((fieldEntity.getValue() != null) && (fieldEntity.getValue().toString().equalsIgnoreCase("1")))
            pstat.setString(j + 1, fieldEntity.getCheckOn());
          else
            pstat.setString(j + 1, fieldEntity.getCheckOff());
        }
        else if (fieldEntity.getType().equalsIgnoreCase("sql")) {
          if (fieldEntity.getSql() != null)
            pstat.setString(j + 1, particularValue(fieldEntity.getSql(), conn));
          else
            pstat.setString(j + 1, null);
        }
        else if (fieldEntity.getType().equalsIgnoreCase("sysdate")) {
          pstat.setDate(j + 1, new java.sql.Date(System.currentTimeMillis()));
        } else if (fieldEntity.getType().equalsIgnoreCase("clob")) {
          pstat.setClob(j + 1, CLOB.empty_lob());
          if (hasClob)
            clobStr = clobStr + "," + fieldEntity.getDbColumn();
          else {
            clobStr = fieldEntity.getDbColumn();
          }
          hasClob = true;
          clobList.add(fieldEntity);
        }
        else if (fieldEntity.getValue() != null) {
          if (fieldEntity.getValue().toString().length() > 500) {
            StringReader rd = new StringReader(fieldEntity.getValue().toString());
            pstat.setCharacterStream(j + 1, rd, fieldEntity.getValue().toString().length());
          } else {
            pstat.setString(j + 1, fieldEntity.getValue().toString());
          }
        }
        else {
          pstat.setString(j + 1, "");
        }

      }

      conn.setAutoCommit(false);
      ret = pstat.executeUpdate();
      if (ret > 0) {
        if (hasClob) {
          String fieldTable = "";
          if ("insert".equals(entity.getXmlType()))
            fieldTable = entity.getSql().toLowerCase().substring(entity.getSql().toLowerCase().indexOf("into") + 5, entity.getSql().toLowerCase().indexOf("(")).trim();
          else {
            fieldTable = entity.getSql().toLowerCase().substring(entity.getSql().toLowerCase().indexOf("update") + 7, entity.getSql().toLowerCase().indexOf("set")).trim();
          }
          String clobSql = "";
          clobSql = "select " + clobStr + " from " + fieldTable + " where " + entity.getPrimaryKey() + "=? for update";
          pstat = conn.prepareStatement(clobSql);
          pstat.setString(1, unid);
          ResultSet rs = pstat.executeQuery();
          if (rs.next()) {
            for (int j = 0; j < clobList.size(); ++j) {
              if (((FieldEntity)clobList.get(j)).getValue() == null)
                continue;
              CLOB messageClob = (CLOB)rs.getClob(((FieldEntity)clobList.get(j)).getDbColumn());
              Writer messageOutStream = messageClob.getCharacterOutputStream();

              char[] messageChar = ((FieldEntity)clobList.get(j)).getValue().toString().toCharArray();
              messageOutStream.write(messageChar, 0, messageChar.length);
              messageOutStream.flush();
              messageOutStream.close();
            }
          }
        }

        conn.commit();
      } else {
        conn.rollback();
      }
    } catch (Exception e) {
      e.printStackTrace();
      this.log.error(e.getMessage());
    } finally {
      ConnectionProvider.close(conn, pstat);
    }

    return unid;
  }

  public String particularValue(String sql, Connection conn) {
    ResultSet rs = null;
    PreparedStatement pstat = null;
    String value = null;
    try {
      pstat = conn.prepareStatement(sql);
      rs = pstat.executeQuery();
      if (rs.next())
        value = rs.getString(1);
    }
    catch (SQLException e) {
      e.printStackTrace();
    } finally {
      try {
        if (rs != null) {
          rs.close();
        }
        if (pstat != null)
          pstat.close();
      }
      catch (SQLException e) {
        this.log.error(e.getMessage());
      }
    }
    return value;
  }
}