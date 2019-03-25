package com.kizsoft.yjdb.ding;


import java.io.File;
import java.util.UUID;

import com.oreilly.servlet.multipart.FileRenamePolicy;

//Referenced classes of package com.oreilly.servlet.multipart:
//         FileRenamePolicy

public class RandomFileRenamePolicy
 implements FileRenamePolicy
{

 public RandomFileRenamePolicy()
 {
 }

 public static String getUUID()
 {
     String s = UUID.randomUUID().toString();
     return (new StringBuilder(String.valueOf(s.substring(0, 8)))).append(s.substring(9, 13)).append(s.substring(14, 18)).append(s.substring(19, 23)).append(s.substring(24)).toString();
 }

 public File rename(File file)
 {
     String body = "";
     String ext = "";
     int pot = file.getName().lastIndexOf(".");
     if(pot != -1)
     {
         body = (new StringBuilder(String.valueOf(getUUID()))).toString();
         ext = file.getName().substring(pot);
     } else
     {
         body = (new StringBuilder(String.valueOf(getUUID()))).toString();
         ext = "";
     }
     String newName = (new StringBuilder(String.valueOf(body))).append(ext).toString();
     String filename=file.getName().substring(file.getName().lastIndexOf("/")+1);
     file = new File(file.getParent(), filename);
     return file;
 }
}


/*
	DECOMPILATION REPORT

	Decompiled from: D:\jj\yjdb\WebRoot\WEB-INF\lib\oa.jar
	Total time: 44 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/