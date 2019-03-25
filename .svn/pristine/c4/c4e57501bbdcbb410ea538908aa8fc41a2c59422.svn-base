package com.kizsoft.commons.login;

import com.kizsoft.commons.commons.user.User;
import com.kizsoft.commons.commons.user.UserException;
import com.kizsoft.commons.commons.user.UserManager;
import com.kizsoft.commons.commons.user.UserManagerFactory;
import com.kizsoft.commons.commons.util.StringHelper;
import com.kizsoft.commons.util.MD5;
import com.kizsoft.commons.uum.pojo.Owner;
import com.kizsoft.commons.uum.service.IUUMService;
import com.kizsoft.commons.uum.utils.UUMContend;
import com.kizsoft.yjdb.xwfx.Impl;

import java.io.PrintStream;
import java.text.SimpleDateFormat;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

public class LoginAction extends Action
{
  public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)
  {
    String forward = "success";
    LoginForm loginForm = (LoginForm)form;
    String userName = loginForm.getUsername();
    String password = loginForm.getPassword();
    String isSavePassword = loginForm.getIssavepassword();
    String saveDeadLine = loginForm.getSavedeadline();
    String isAutoLogin = loginForm.getIsautologin();

    HttpSession session = request.getSession(true);
    UserManager userManager = UserManagerFactory.getUserManager();  
    try {
      MD5 md5 = new MD5();
      String md5password = md5.getMD5ofStr(password);
      User user = null;
      try {
        user = userManager.checkUser(userName, md5password);
      } catch (UserException ex) {
        try {
          user = userManager.checkUser(userName, password);
        } catch (UserException ex2) {
          user = null;
        }
        if ((user != null) && (user.getPassword().length() != 32))
          LoginEncrypt.EncryptUserPasswordById(user.getUserId(), user.getPassword());
      }
      boolean loginflag;
      if (user != null)
      {
    	System.out.println("aaaaaa:"+user);
        session.setAttribute("userInfo", user);
        session.setAttribute("templatename", user.getTemplatename());
        session.setAttribute("LogErrMsg", null);
        Cookie namecookie = new Cookie("username", userName);
        namecookie.setPath(request.getContextPath());
        namecookie.setMaxAge(31536000);
        response.addCookie(namecookie);

        Cookie issavepasswordcookie = new Cookie("issavepassword", isSavePassword);
        issavepasswordcookie.setPath(request.getContextPath());
        issavepasswordcookie.setMaxAge(31536000);
        response.addCookie(issavepasswordcookie);

        Cookie savedeadlinecookie = new Cookie("savedeadline", saveDeadLine);
        savedeadlinecookie.setPath(request.getContextPath());
        savedeadlinecookie.setMaxAge(31536000);
        response.addCookie(savedeadlinecookie);
        if ("1".equals(isSavePassword)) {
          Cookie passwordcookie = new Cookie("password", user.getPassword());
          passwordcookie.setPath(request.getContextPath());
          if (StringHelper.isInt(saveDeadLine))
            passwordcookie.setMaxAge(Integer.parseInt(saveDeadLine) * 24 * 60 * 60);
          else {
            passwordcookie.setMaxAge(31536000);
          }
          response.addCookie(passwordcookie);
          Cookie isautologincookie = new Cookie("isautologin", isAutoLogin);
          isautologincookie.setPath(request.getContextPath());
          isautologincookie.setMaxAge(31536000);
          response.addCookie(isautologincookie);
        } else {
          Cookie passwordcookie = new Cookie("password", "");
          passwordcookie.setPath(request.getContextPath());
          passwordcookie.setMaxAge(0);
          response.addCookie(passwordcookie);
          Cookie isautologincookie = new Cookie("isautologin", "");
          isautologincookie.setPath(request.getContextPath());
          isautologincookie.setMaxAge(0);
          response.addCookie(isautologincookie);
        }

        String userflag = loginForm.getUserflag();
        User userInfo = (User)session.getAttribute("userInfo");
        String userID = userInfo.getUserId();
        UserFlagManage userflagManage = new UserFlagManage();
        String ip = request.getRemoteAddr();
        IUUMService uumService = UUMContend.getUUMService();
        String trustIp = uumService.getOwnerByOwnerid(userInfo.getUserId()).getIp();
        try{
        	/*Impl.save("login",userInfo.getUserId(),ip);
        	Impl.save("Æô¶¯",userInfo.getUserId(),ip);*/
        }catch(Exception ex) {
        	
        }
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        SimpleDateFormat cursdf = new SimpleDateFormat("yyyy-MM-dd");
        if (userflag != null) {
          String UserFlagSql = userflagManage.getUserFlag(userID);
          UserFlagSql = (UserFlagSql == null) ? "0" : UserFlagSql;
          session.setAttribute("ip", ip);
          session.setAttribute("useragent", request.getHeader("User-Agent"));
          loginflag = userflagManage.insertUserLogin(userInfo, ip, "1", UserFlagSql);
        } else {
          String UserFlagSql = userflagManage.getUserFlag(userID);
          UserFlagSql = (UserFlagSql == null) ? "0" : UserFlagSql;
          session.setAttribute("ip", ip);
          session.setAttribute("useragent", request.getHeader("User-Agent"));
          loginflag = userflagManage.insertUserLogin(userInfo, ip, "1", UserFlagSql);
        }
      } else {
        session.setAttribute("LogErrMsg", "ÓÃ»§»òÃÜÂë´íÎó£¡ÇëÖØÐÂµÇÂ¼¡£");
        String ip = request.getRemoteAddr();
        UserFlagManage userflagManage = new UserFlagManage();
        userflagManage.insertUserLogin(null, loginForm.getUsername(), null, null, null, null, ip, "0", null);
        loginForm.setPassword("");
        request.setAttribute("loginForm", loginForm);
        forward = "loginerror";
      }
    } catch (Exception ex) {
      session.setAttribute("LogErrMsg", "µÇÂ¼Ê§°Ü£¡ÇëÖØÐÂµÇÂ¼¡£");
      String ip = request.getRemoteAddr();
      UserFlagManage userflagManage = new UserFlagManage();
      userflagManage.insertUserLogin(null, loginForm.getUsername(), null, null, null, null, ip, "0", null);
      loginForm.setPassword("");
      request.setAttribute("loginForm", loginForm);
      forward = "loginerror";
    }
    return mapping.findForward(forward);
  }
}