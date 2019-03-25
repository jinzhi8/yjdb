package com.kizsoft.oa.wcoa.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.Reader;
import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.sql.Clob;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.beanutils.BeanUtils;

import com.kizsoft.commons.commons.db.ConnectionProvider;
import com.kizsoft.commons.util.UUIDGenerator;
import com.kizsoft.oa.wcoa.util.IdName;


public class SimpleORMUtils {
	public static final String PREFIX="kzm_";
	private static final SimpleORMUtils instance=new SimpleORMUtils();
	
	public static SimpleORMUtils getInstance(){
		return instance;
	}
	

//	public <T> boolean insert(T t){
//		StringBuffer sql=new StringBuffer("insert into "+PREFIX+t.getClass().getSimpleName().toLowerCase() +"(");
//		StringBuffer values=new StringBuffer(") values(");
//		Field[] fields=t.getClass().getDeclaredFields();
//		for(int i=0;i<fields.length;i++){
//			Field field=fields[i];
//			if(i==0){
//				sql.append(field.getName());
//				values.append("?");
//			}else{
//				sql.append(","+field.getName());
//				values.append(",?");
//			}
//		}
//		sql.append(values).append(")");
//		return false;
//	}
	
	public <T> boolean saveList(Class<T> clazz,HttpServletRequest request){
		List<T> list=this.bindList(clazz, request);
		boolean flag=true;
		for(T t :list){
			flag&=(this.save(t)!=null);
		}
		return flag;
	}
	
	public boolean deleteByIds(String sql,String ids){
		String[] idArr=ids.split(",");
		boolean flag=true;
		for(String id:idArr){
			int result=executeUpdate(sql, id);
			flag&=(result==1);
		}
		return flag;
	}

	public <T> T bind(Class<T> clazz,HttpServletRequest request){
		return this.bind(clazz, request, "");
	}
	
	public <T> List<T> bindList(Class<T> clazz,HttpServletRequest request){
		List<T> list=new ArrayList<T>();
		int itemNum=Integer.parseInt(request.getParameter("itemNum"));
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
				BeanUtils.setProperty(t, field.getName(), request.getParameter(field.getName()+suffix));
			}
			return t;
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}
	
	
	
	
	public <T> T save(T t){
		try{
			String id=getIdColumn(t);
			String idValue=BeanUtils.getProperty(t, id);
			if(idValue==null||"".equals(idValue)){
				return insert(t,id);
			}else{
				return update(t,id);
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	} 
	
	public <T> T insert(T t) throws Exception{
		String id=getIdColumn(t);
		return insert(t,id);
	}
	
	public <T> T insert(T t,String id) throws Exception{
		StringBuffer sql=new StringBuffer("insert into "+PREFIX+t.getClass().getSimpleName().toLowerCase() +"(");
		StringBuffer values=new StringBuffer(") values(");
		Field[] fields=t.getClass().getDeclaredFields();
		List<Object> list=new ArrayList<Object>();
		for(int i=0;i<fields.length;i++){
			Field field=fields[i];
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
				BeanUtils.setProperty(t, field.getName(), unid);
			}else{
				list.add(BeanUtils.getProperty(t, field.getName()));
			}
		}
		sql.append(values).append(")");
		//System.out.println(sql.toString()+"               "+list.size());
		int result=executeUpdate(sql.toString(), list.toArray(new Object[list.size()]));
		return result==1?t:null;
	}
	
	
	public <T> T update(T t) throws Exception{
		String id=getIdColumn(t);
		return update(t,id);
	}
	
	public <T> T update(T t,String id) throws Exception{
		StringBuffer sql=new StringBuffer("update "+PREFIX+t.getClass().getSimpleName().toLowerCase() +" set ");
		Field[] fields=t.getClass().getDeclaredFields();
		List<Object> list=new ArrayList<Object>();
		for(int i=0;i<fields.length;i++){
			Field field=fields[i];
			if(!field.getName().equals(id)){
				if(list.size()==0){
					sql.append(" "+field.getName()+"=? ");
				}else{
					sql.append(", "+field.getName()+"=? ");
				}
				list.add(BeanUtils.getProperty(t, field.getName()));
			}
		}
		sql.append(" where "+id+"=? ");
		list.add(BeanUtils.getProperty(t, id));
		System.out.println(sql.toString()+"               "+list.size());
		int result=executeUpdate(sql.toString(), list.toArray(new Object[list.size()]));
		return result==1?t:null;
	}
	
	public <T> String getIdColumn(T t){
		String id="";
		Annotation[] as=t.getClass().getDeclaredAnnotations();
		for(Annotation a:as){
			if(a instanceof IdName){
				return ((IdName)a).value();
			}
		}
		return "";
	}
	
	
	//查总数
	public int queryForInt(String sql,Object... objs){
		return execute(sql,new StatementCallBack<Integer>() {
			 public Integer execute(PreparedStatement ps) throws SQLException{
				 	ResultSet rs=ps.executeQuery();
				 	if(rs.next()){
					 	int result=rs.getInt(1);
					 	ConnectionProvider.close(rs);
					 	return result;
				 	}
				 	return 0;
				}
			},objs);
	}
	
	
	public String queryForString(String sql,Object... objs){
		return execute(sql,new StatementCallBack<String>() {
			 public String execute(PreparedStatement ps) throws SQLException{
				 	ResultSet rs=ps.executeQuery();
				 	if(rs.next()){
				 		String result=rs.getString(1);
					 	ConnectionProvider.close(rs);
					 	return result;
				 	}
				 	return "";
				}
			},objs);
	}
	
	//查结果绑定到对象
	public <T> T queryForObject(final Class<T> clazz,String sql,Object... objs){
		return execute(sql,new StatementCallBack<T>() {
			 public T execute(PreparedStatement ps) throws Exception{
					T t=clazz.getDeclaredConstructor(null).newInstance(null);
				 	ResultSet rs=ps.executeQuery();
				 	ResultSetMetaData rsmd=rs.getMetaData();
				 	int count=rsmd.getColumnCount();
				 	if(rs.next()){
					 	for(int i=1;i<=count;i++){
					 		String name=rsmd.getColumnName(i).toLowerCase();
					 		Object o=rs.getObject(name)==null?"":rs.getObject(name);
					 		o=change(o);
					 		try{
					 			BeanUtils.setProperty(t, name, o);
					 		}catch(Exception e){
					 			e.printStackTrace();
					 		}
					 	}
				 	}
				 	return t;
				}
			},objs);
	}
	
	//查结果绑定到List
	public <T> List<T> queryForList(final Class<T> clazz,String sql,Object... objs){
		return execute(sql,new StatementCallBack<List<T>>() {
			 public List<T> execute(PreparedStatement ps) throws Exception{
				 	List<T> list=new ArrayList<T>();
				 	ResultSet rs=ps.executeQuery();
				 	ResultSetMetaData rsmd=rs.getMetaData();
				 	int count=rsmd.getColumnCount();
				 	while(rs.next()){
				 		T t=clazz.getDeclaredConstructor(null).newInstance(null);
					 	for(int i=1;i<=count;i++){
					 		String name=rsmd.getColumnName(i).toLowerCase();
					 		Object o=rs.getObject(name)==null?"":rs.getObject(name);
					 		o=change(o);
					 		try{
					 			BeanUtils.setProperty(t, name, o);
					 		}catch(Exception e){
					 			e.printStackTrace();
					 		}
					 	}
					 	list.add(t);
				 	}
				 	return list;
				}
			},objs);
	}
	
	
	public List<Object[]>queryForList(String sql,Object... objs){
		return execute(sql,new StatementCallBack<List<Object[]>>() {
				List<Object[]> execute(PreparedStatement ps) throws Exception {
					List<Object[]> list=new ArrayList<Object[]>();
					ResultSet rs=ps.executeQuery();
				 	ResultSetMetaData rsmd=rs.getMetaData();
				 	int count=rsmd.getColumnCount();
				 	while(rs.next()){
				 		List<Object> olist=new ArrayList<Object>();
					 	for(int i=1;i<=count;i++){
					 		String name=rsmd.getColumnName(i).toLowerCase();
					 		Object o=rs.getObject(name)==null?"":rs.getObject(name);
					 		o=change(o);
					 		olist.add(o);
					 	}
					 	Object[] os=olist.toArray(new Object[olist.size()]);
					 	list.add(os);
				 	}
				 	return list;
				}
			},objs);
	}
	
	public Map<String,Object> queryForUniqueMap(String sql,Object... objs){
		List<Map<String,Object>> list=queryForMap(sql,objs);
		if(list.size()>0)
			return list.get(0);
		return new HashMap<String,Object>(){
			@Override
			public Object get(Object key) {
				Object o=super.get(key);
				if(o==null)
					o="";
				return o;
			}
		};
	}
	
	public List<Map<String,Object>>queryForMap(String sql,Object... objs){
		return execute(sql,new StatementCallBack<List<Map<String,Object>>>() {
			List<Map<String,Object>> execute(PreparedStatement ps) throws Exception {
					List<Map<String,Object>> list=new ArrayList<Map<String,Object>>();
					ResultSet rs=ps.executeQuery();
				 	ResultSetMetaData rsmd=rs.getMetaData();
				 	int count=rsmd.getColumnCount();
				 	while(rs.next()){
				 		Map<String,Object> map=new HashMap<String,Object>();
					 	for(int i=1;i<=count;i++){
					 		String name=rsmd.getColumnName(i).toLowerCase();
					 		//System.out.println("map" +name);
					 		Object o=rs.getObject(name)==null?"":rs.getObject(name);
					 		o=change(o);
					 		map.put(name, o);
					 	}
					 	list.add(map);
				 	}
				 	return list;
				}
			},objs);
	}
	
	public Object change(Object o){
		if(o==null)
			return "";
		
		if(o instanceof Clob){
			Clob c=(Clob) o;
			try {
				o=readOracleLong(c.getCharacterStream());
			} catch (SQLException e) {
				e.printStackTrace();
				o="";
			}
		}else if(o instanceof Timestamp){
			Timestamp t=(Timestamp) o;
			SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			o=sdf.format(new Date(t.getTime()));
		}
		return o;
	}
	
	private String readOracleLong(Reader reader) {
		if (reader == null) {
			return "";
		}
		BufferedReader bufReader = new BufferedReader(reader);
		StringBuffer strBuf = new StringBuffer();
		String line;
		try {
			while ((line = bufReader.readLine()) != null) {
				strBuf.append(line);
				strBuf.append("\r\n");
			}
			bufReader.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return strBuf.toString();
	}
	
	
	//增删改方法
	public int executeUpdate(String sql,Object... objs){
		return execute(sql,new StatementCallBack<Integer>() {
		 public Integer execute(PreparedStatement ps) throws SQLException{
				return ps.executeUpdate();
			}
		},objs);
	}
	
	private <T> T execute(String sql,StatementCallBack<T> callBack,Object... objs){
		Connection conn=null;
		PreparedStatement ps=null;
		T t=null;
		try {
			conn=ConnectionProvider.getConnection();
			ps=conn.prepareStatement(sql);
			for(int i=0;i<objs.length;i++){
				ps.setObject(i+1, objs[i]);
			}
			t=callBack.execute(ps);
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			ConnectionProvider.close(conn, ps);
		}
		return t;
	}
	
	//回调方法
	abstract class StatementCallBack<R>{
		abstract R execute(PreparedStatement ps) throws Exception;
	}
	
}
