package com.kizsoft.commons.commons.orm;

import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.dbutils.QueryRunner;
import org.apache.commons.dbutils.ResultSetHandler;
import org.apache.commons.dbutils.handlers.ArrayListHandler;
import org.apache.commons.dbutils.handlers.BeanHandler;
import org.apache.commons.dbutils.handlers.BeanListHandler;
import org.apache.commons.dbutils.handlers.MapHandler;
import org.apache.commons.dbutils.handlers.MapListHandler;

import com.kizsoft.commons.commons.db.ConnectionProvider;
import com.kizsoft.commons.commons.util.StringHelper;
import com.kizsoft.commons.util.UUIDGenerator;
import com.oreilly.servlet.MultipartRequest;


public class MyDBUtils {
	private static QueryRunner qRunner = new QueryRunner(); 
	
	public <T> T bind(Class<T> clazz,HttpServletRequest request){
		return this.bind(clazz, request, "");
	}
	public <T> List<T> bindList(Class<T> clazz,HttpServletRequest request){
		return this.bindList(clazz, request, "itemNum");
	}
	public <T> List<T> bindList(Class<T> clazz,HttpServletRequest request,String itemName){
		List<T> list=new ArrayList<T>();
		int itemNum=Integer.parseInt(request.getParameter(itemName));
		for(int i=1;i<=itemNum;i++){
			T t=bind(clazz, request, "_"+i);
			if(t!=null)list.add(t);
		}
		return list;
	}
	
	
	public <T> T bind(Class<T> clazz,HttpServletRequest request,String suffix){
		try{
			T t=clazz.getDeclaredConstructor(null).newInstance(null);
			Field[] fields=clazz.getDeclaredFields();
			for(Field field:fields){
				String type = t.getClass().getDeclaredField(field.getName()).getType().toString();
				String value = request.getParameter(field.getName()+suffix);
				Object o = changeStr(type,value); 
				PropertyUtils.setProperty(t, field.getName(), o);
			}
			return t;
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}
	
	public <T> T bind(Class<T> clazz,MultipartRequest request){
		return this.bind(clazz, request, "");
	}
	
	public <T> List<T> bindList(Class<T> clazz,MultipartRequest request){
		return this.bindList(clazz, request, "itemNum");
	}
	public <T> List<T> bindList(Class<T> clazz,MultipartRequest request,String itemName){
		List<T> list=new ArrayList<T>();
		int itemNum=Integer.parseInt(request.getParameter(itemName));
		for(int i=1;i<=itemNum;i++){
			T t=bind(clazz, request, "_"+i);
			if(t!=null)list.add(t);
		}
		return list;
	}
	
	
	public  <T> T bind(Class<T> clazz,MultipartRequest request,String suffix){
		try{
			T t=clazz.getDeclaredConstructor(null).newInstance(null);
			Field[] fields=clazz.getDeclaredFields();
			for(Field field:fields){
				String type = t.getClass().getDeclaredField(field.getName()).getType().toString();
				String value = request.getParameter(field.getName()+suffix);
				Object o = changeStr(type,value); 
				PropertyUtils.setProperty(t, field.getName(), o);
			}
			return t;
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}
	
	public Object changeStr(String type,String value){
		//System.out.println("class:"+type);
		Object o = null;
		try{
			if("class java.sql.Timestamp".equals(type)){
				o = Timestamp.valueOf(value);
			}else if("class java.util.Date".equals(type)){
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd ");
				o = sdf.parse(value); 
			}else if("int".equals(type)){
				try{
					o = Integer.parseInt(value);
				}catch (Exception e){
					o=0;
				}
			}else{
				o=value;
			}
		}catch (Exception e){
			return null;
		}
		return o;
	}
	//批量删除
	public static boolean deleteByIds(String sql,String ids){
		String[] idArr=ids.split(",");
		boolean flag=true;
		for(String id:idArr){
			int result = 0;
			try {
				result = executeUpdate(sql, id);
			} catch (SQLException e) {
				e.printStackTrace();
			}
			flag&=(result==1);
		}
		return flag;
	}
	
	public static <T> T saveOrUpdate(T t){
		try{
			String id=getIdColumn(t);
			String idValue=BeanUtils.getProperty(t, id);
			String tablename=getTableName(t);
			if(idValue==null||"".equals(idValue)){
				return insert(t,id);
			}else{
				int count=queryForInt("select count(1) from "+tablename+" where "+id+"=?", idValue);
				if(count>0)
					return update(t,id);
				else
					return insert(t,id);
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return t;
	}
	

	public static <T> T save(T t){
		String tablename=getTableName(t);
		return save(t,tablename);
	} 
	
	public static <T> T save(T t,String tablename){
		try{
			String id=getIdColumn(t);
			String idValue=BeanUtils.getProperty(t, id);
			if(idValue==null||"".equals(idValue)){
				return insert(t,id,tablename);
			}else{
				return update(t,id,tablename);
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	} 
	
	
	public static <T> T insert(T t) throws Exception{
		String id=getIdColumn(t);
		return insert(t,id);
	}
	
	public static <T> T insert(T t,String id) throws Exception{
		return insert(t,id,getTableName(t));
	}
	
	
	public static <T> T insert(T t,String id,String tabname) throws Exception{
		StringBuffer sql=new StringBuffer("insert into "+tabname +"(");
		StringBuffer values=new StringBuffer(") values(");
		Field[] fields=t.getClass().getDeclaredFields();
		List<Object> list=new ArrayList<Object>();
		for(int i=0;i<fields.length;i++){
			Field field=fields[i];
			
			IngoreField f=field.getAnnotation(IngoreField.class);
			if(f!=null)
				continue;
			
			if(i==0){
				sql.append(field.getName());
				values.append("?");
			}else{
				sql.append(","+field.getName());
				values.append(",?");
			}
			if(field.getName().equals(id)){
				String unid=BeanUtils.getProperty(t, field.getName());
				if(unid==null||"".equals(unid)){
					unid=UUIDGenerator.getUUID();
				}
				list.add(unid);
				PropertyUtils.setProperty(t, field.getName(), unid);
			}else{
				list.add(PropertyUtils.getProperty(t, field.getName()));
			}
		}
		sql.append(values).append(")");
		System.out.println(sql.toString()+"               "+list.size());
		int result=executeUpdate(sql.toString(), list.toArray(new Object[list.size()]));
//		int result=qRunner.update(getConn(),sql.toString(), list.toArray(new Object[list.size()]));
		return result==1?t:null;
	}
	
	public static <T> T insert(T t,String id,String tabname,String[] arr) throws Exception{
		StringBuffer sql=new StringBuffer("insert into "+tabname +"(");
		StringBuffer values=new StringBuffer(") values(");
		Field[] fields=t.getClass().getDeclaredFields();
		List<Object> list=new ArrayList<Object>();
		List<String> remove=Arrays.asList(arr);
		for(int i=0;i<fields.length;i++){
			Field field=fields[i];
			
			IngoreField f=field.getAnnotation(IngoreField.class);
			if(f!=null)
				continue;
			if(remove.contains(field.getName()))
				continue;
			if(i==0){
				sql.append(field.getName().replaceAll("([a-zA-Z]+)(?=[A-Z])", "$1_"));
				values.append("?");
			}else{
				sql.append(","+field.getName().replaceAll("([a-zA-Z]+)(?=[A-Z])", "$1_"));
				values.append(",?");
			}
			if(field.getName().equals(id)){
				String unid=BeanUtils.getProperty(t, field.getName());
				if(unid==null||"".equals(unid)){
					unid=UUIDGenerator.getUUID();
				}
				list.add(unid);
				PropertyUtils.setProperty(t, field.getName(), unid);
			}else{
				list.add(PropertyUtils.getProperty(t, field.getName()));
			}
		}
		sql.append(values).append(")");
		System.out.println(list.size());
		int result=executeUpdate(sql.toString(), list.toArray(new Object[list.size()]));
		return result==1?t:null;
	}
	
	public static <T> T update(T t) throws Exception{
		String id=getIdColumn(t);
		return update(t,id);
	}
	
	public static <T> T update(T t,String id) throws Exception{
		return update(t,id,getTableName(t));
	}
	
	public static <T> T update(T t,String id,String tablename) throws Exception{
		StringBuffer sql=new StringBuffer("update "+tablename+" set ");
		Field[] fields=t.getClass().getDeclaredFields();
		List<Object> list=new ArrayList<Object>();
		for(int i=0;i<fields.length;i++){
			Field field=fields[i];
			
			IngoreField f=field.getAnnotation(IngoreField.class);
			if(f!=null)
				continue;
			
			if(!field.getName().equals(id)){
				if(list.size()==0){
					sql.append(" "+field.getName()+"=? ");
				}else{
					sql.append(", "+field.getName()+"=? ");
				}
				
				list.add(PropertyUtils.getProperty(t, field.getName()));
			}
		}
		sql.append(" where "+id+"=? ");
		list.add(PropertyUtils.getProperty(t, id));
		System.out.println(sql.toString()+"               "+list.size());
		int result=executeUpdate(sql.toString(), list.toArray(new Object[list.size()]));
//		int result=qRunner.update(getConn(), sql.toString(), list.toArray(new Object[list.size()]));
		return result==1?t:null;
	}
	

	private static <T> String getIdColumn(T t){
		Annotation[] as=t.getClass().getDeclaredAnnotations();
		for(Annotation a:as){
			if(a instanceof OaTable){
				return ((OaTable)a).id();
			}
		}
		return "";
	}
	
	private static <T> String getTableName(T t){
		Annotation[] as=t.getClass().getDeclaredAnnotations();
		for(Annotation a:as){
			if(a instanceof OaTable){
				if(!StringHelper.isEmpty(((OaTable)a).value()))
					return ((OaTable)a).value();
			}
		}
		return t.getClass().getSimpleName().toLowerCase();
	}
	
	
	
	// 查总数
	public static int queryForInt(String sql, Object... objs) {
		Connection conn=null;
		try {
			conn=getConn();
			return qRunner.query(conn, sql, new ResultSetHandler<Integer>(){
				public Integer handle(ResultSet rs) throws SQLException {
					if(rs.next())
						return rs.getInt(1);
					return 0;
				}
			}, objs);
		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			closeConn(conn);
		}
		return 0;
	}

	// 查结果绑定到对象
	public static <T> T queryForObject(final Class<T> clazz, String sql,
			Object... objs){
		Connection conn=null;
		try {
			conn=getConn();
			return (T) qRunner.query(conn,sql,new BeanHandler(clazz),objs);
		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			closeConn(conn);
		}
		return null;
	}

	// 查结果绑定到List
	public static <T> List<T> queryForList(final Class<T> clazz, String sql,
			Object... objs) {
		Connection conn=null;
		try {
			conn=getConn();
			return (List<T>) qRunner.query(conn,sql,new BeanListHandler(clazz),objs);
		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			closeConn(conn);
		}
		return new ArrayList<T>();
	}

	public List<Object[]> queryForList(String sql, Object... objs) {
		Connection conn=null;
		try {
			conn=getConn();
			return  qRunner.query(conn,sql,new ArrayListHandler(),objs);
		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			closeConn(conn);
		}
		return new ArrayList<Object[]>();
	}
	
	
	public static Map<String, Object> queryForUniqueMap(String sql, Object... objs) {
		Connection conn=null;
		try {
			conn=getConn();
			return qRunner.query(conn,sql,new MapHandler(),objs);
		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			closeConn(conn);
		}
		return null;
	}
	
	public static Map<String, Object> queryForUniqueMapToUC(String sql, Object... objs) {
		Connection conn=null;
		try {
			conn=getConn();
			Map<String, Object> map = qRunner.query(conn,sql,new MapHandler(),objs);
			if(map!=null){
				return MaptoUpperCase(map);
			}
			return map;
		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			closeConn(conn);
		}
		return null;
	}
	
	public static List<Map<String, Object>> queryForMap(String sql, Object... objs) {
		Connection conn=null;
		try {
			conn=getConn();
			return qRunner.query(conn,sql,new MapListHandler(),objs);
		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			closeConn(conn);
		}
		return new ArrayList<Map<String,Object>>();
	}
	
	public static List<Map<String, Object>> queryForMapToUC(String sql, Object... objs) {
		Connection conn=null;
		try {
			conn=getConn();
			List<Map<String, Object>> mlist = qRunner.query(conn,sql,new MapListHandler(),objs);
			if(mlist!=null){
				mlist = qRunner.query(conn,sql,new MapListHandler(),objs);
				List<Map<String, Object>> rlist  = new ArrayList<Map<String,Object>>(); 
				for(Map<String, Object> rmap : mlist){
					rlist.add(MaptoUpperCase(rmap));
				}
				return rlist;
			}
			return mlist;
		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			closeConn(conn);
		}
		return new ArrayList<Map<String,Object>>();
	}
	
	//增删改方法
	public static int executeUpdate(String sql,Object... objs) throws SQLException{
		Connection conn=null;
		try{
			conn=getConn();
			return qRunner.update(conn, sql, objs);
		}finally{
			closeConn(conn);
		}
	}
	
	public static Connection getConn() throws SQLException{
		return ConnectionProvider.getConnection();
	}
	
	public static void closeConn(Connection conn){
		try{
			if(conn!=null)
				conn.close();
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	/**
	 * Map大写转小写
	 * @param map
	 * @return
	 */
	public static Map<String,Object>  MaptoUpperCase(Map<String,Object> map){
		 Map<String,Object> rmap = new HashMap<String, Object>(); 
		 Set<String> se = map.keySet();                                      
         for(String set :se){  
       	  	 //在循环将小写的KEY和VALUE 放到新的Map                      
             rmap.put(set.toLowerCase(), map.get(set));
         } 
         return rmap;
	}
	
}
