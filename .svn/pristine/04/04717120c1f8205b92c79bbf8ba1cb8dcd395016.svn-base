package com.kizsoft.yjdb.ding;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.dingtalk.api.DefaultDingTalkClient;
import com.dingtalk.api.DingTalkClient;
import com.dingtalk.api.request.OapiMediaUploadRequest;
import com.dingtalk.api.request.OapiMessageCorpconversationAsyncsendV2Request;
import com.dingtalk.api.response.OapiMediaUploadResponse;
import com.dingtalk.api.response.OapiMessageCorpconversationAsyncsendV2Response;
import com.kizsoft.commons.commons.attachment.AttachmentEntity;
import com.kizsoft.commons.commons.attachment.AttachmentManager;
import com.kizsoft.commons.commons.orm.MyDBUtils;
import com.kizsoft.yjdb.utils.GsonHelp;
import com.kizsoft.yjdb.utils.JsoupUtil;
import com.kizsoft.yjdb.utils.PropertiesUtil;
import com.kizsoft.yjdb.xwfx.Impl;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.UploadedFile;
import com.kizsoft.yjdb.ding.RandomFileRenamePolicy;
import com.taobao.api.ApiException;
import com.taobao.api.FileItem;

public class SendDocByDing {
	 
    //附件上传,钉钉推送
    public static void doDingAction(HttpServletRequest request) throws IOException, ApiException{
    	SimpleDateFormat sdfym = new SimpleDateFormat("yyyyMM");
        SimpleDateFormat sdfd = new SimpleDateFormat("dd");
        int attachmentMaxSize = 1073741824;
    	String attachmentDir = "/attachment/ding/" + sdfym.format(new Date()) + "/" + sdfd.format(new Date()) + "/";
        String attachmentBaseDir = request.getSession().getServletContext().getRealPath(attachmentDir);
    	RandomFileRenamePolicy rfrp = new RandomFileRenamePolicy();
    	MultipartRequest req = new MultipartRequest(request, attachmentBaseDir, attachmentMaxSize, "UTF-8", rfrp);
    	String ryname=req.getParameter("ryname");
    	String rynameid=req.getParameter("rynameid");
    	rynameid=rynameid.replace(",","','");
    	List<Map<String,Object>> list=MyDBUtils.queryForMapToUC("select * from owner where id in('"+rynameid+"')");
    	String show="";
    	for(Map<String,Object> map:list){
    		String duserid=(String)map.get("duserid");
    		show+=duserid+",";
    	}
    	if(show.length()>2){
    		show=show.substring(0,show.length()-1);
    	}
    	String[] idStr=rynameid.split(",");
    	Enumeration files = req.getFileListNames();
        while (files.hasMoreElements()) {
          String name = (String)files.nextElement();
          List fileList = new ArrayList();
          fileList = req.getFileList(name);
          for (int i = 0; i < fileList.size(); ++i) {
            UploadedFile uf = (UploadedFile)fileList.get(i);
            AttachmentEntity entity = new AttachmentEntity();
            entity.setAttachmentName("（"+ryname+"）"+uf.getOriginalFileName());
            entity.setAttachmentPath(attachmentDir + uf.getOriginalFileName());
            entity.setDocunid("钉钉推送附件上传");
            entity.setModuleId("ddfjsc");
            entity.setType(name);
            new AttachmentManager().saveAttach(entity);
            String path=attachmentBaseDir+uf.getFilesystemName();
            try{
            	String mediaid=upload(path);
            	sendDoc(show,mediaid);
            }catch(Exception e){
            	e.printStackTrace();
            }
          }
        }
       
        
	}
    
  	//上传到钉钉媒体库
  	public static String  upload(String path) throws ApiException{
		String access_token=UserServlet.getNewAccessToken();
		DingTalkClient  client = new DefaultDingTalkClient("https://oapi.dingtalk.com/media/upload");
		OapiMediaUploadRequest request = new OapiMediaUploadRequest();
		request.setType("file");
		request.setMedia(new FileItem(path));
		OapiMediaUploadResponse response = client.execute(request,access_token);
		System.out.println(response.getBody());
		return response.getMediaId();
	}
  	
  	//通过钉钉推送
  	public static void sendDoc(String toUser,String mediaid) throws ApiException{
		String access_token=UserServlet.getNewAccessToken();
		DingTalkClient client = new DefaultDingTalkClient("https://oapi.dingtalk.com/topapi/message/corpconversation/asyncsend_v2");
		OapiMessageCorpconversationAsyncsendV2Request request = new OapiMessageCorpconversationAsyncsendV2Request();
		request.setUseridList(toUser);
		request.setAgentId((long)191083238);
		request.setToAllUser(false);
		OapiMessageCorpconversationAsyncsendV2Request.Msg msg = new OapiMessageCorpconversationAsyncsendV2Request.Msg();
		msg.setMsgtype("file");
		msg.setFile(new OapiMessageCorpconversationAsyncsendV2Request.File());
		msg.getFile().setMediaId(mediaid);
		request.setMsg(msg);
		OapiMessageCorpconversationAsyncsendV2Response response = client.execute(request,access_token);
		System.out.println(response.getBody());
	}
}
