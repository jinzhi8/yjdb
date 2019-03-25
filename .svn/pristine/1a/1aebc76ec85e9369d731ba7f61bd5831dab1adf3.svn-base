package com.kizsoft.webThread;

import java.lang.Thread.UncaughtExceptionHandler;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;


public class yjdbServlet extends HttpServlet{
	ExecutorService cachedThreadPool = Executors.newCachedThreadPool(); 
	@Override
	public void init() throws ServletException {
		String path = this.getServletContext().getRealPath("");

		System.out.println("------------(周期反馈)Thread init()-------------");
		cachedThreadPool.execute(new fkThread(path));
		
		
		System.out.println("------------(消息发送)Thread init()-------------");
		cachedThreadPool.execute(new dingThread(path));
		
		System.out.println("------------(自动设置蜗牛件)Thread init()-------------");
		cachedThreadPool.execute(new wnThread(path));

	
	}
}
