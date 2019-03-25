package com.kizsoft.yjdb.utils;   
import java.io.BufferedWriter;   
import java.io.File;  
import java.io.FileOutputStream;  
import java.io.IOException;   
import java.io.OutputStreamWriter;  
import java.io.Writer;  
import java.util.HashMap;   
import java.util.Map;  

import freemarker.cache.FileTemplateLoader;
import freemarker.cache.TemplateLoader;
import freemarker.template.Configuration;  
import freemarker.template.Template;   
import freemarker.template.TemplateException;  
 
public class DocUtil {  
   private Configuration configuration = null;  
   public DocUtil() {  
      configuration = new Configuration();  
      configuration.setDefaultEncoding("utf-8");  
   }  
   public void createDoc(String lj,Map dataMap,String tzdlj) {  
      // 设置模本装置方法和路径,FreeMarker支持多种模板装载方法。可以重servlet，classpath，数据库装载，   
      // 这里我们的模板是放在com.havenliu.document.template包下面   
      Template t = null;  
      try {  
         // test.ftl为要装载的模板      
        String path="";  
        //使用FileTemplateLoader  
        TemplateLoader templateLoader=null; 
        templateLoader=new FileTemplateLoader(new File(DocUtil.class.getResource("/").getPath()));  
        path=File.separator + "configprop"+File.separator+tzdlj;              
        configuration.setTemplateLoader(templateLoader);  
        t=configuration.getTemplate(path,"UTF-8"); 
      } catch (IOException e) {  
         e.printStackTrace();  
      }  
      // 输出文档路径及名称   
      File outFile = new File(lj);  
      Writer out = null;  
      try {  
         out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(outFile), "utf-8"));  
      } catch (Exception e1) {  
         e1.printStackTrace();  
      }  
      try {  
         t.process(dataMap, out);  
         out.close();  
      } catch (TemplateException e) {  
         e.printStackTrace();  
      } catch (IOException e) {  
         e.printStackTrace();  
      }  
   }  
  
   /** 
    * 注意dataMap里存放的数据Key值要与模板中的参数相对应 
    *  
    * @param dataMap 
    */  
   private void getData(Map dataMap) {  
      dataMap.put("bh", "用户信息");  
      dataMap.put("qfr", "用户信息"); 
      dataMap.put("dbsx", "用户信息"); 
      dataMap.put("cbdw", "用户信息"); 
      dataMap.put("jzsj", "用户信息"); 
      dataMap.put("fklx", "张三");  
      dataMap.put("dbnr", "微软公司");  
      dataMap.put("createtime", "事业部");  
      dataMap.put("phdw", "事业部");  
   }  
   public static void main(String[] args) {
	  
   }
  
} 