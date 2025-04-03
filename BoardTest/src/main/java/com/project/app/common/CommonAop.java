package com.project.app.common;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.stereotype.Component;

@Aspect
@Component // bean으로 등록
public class CommonAop {

	@Pointcut("execution(public * com.project.app..*Controller.requiredLogin_*(..))")
	public void requiredLogin() {}
	
	// 로그인 유무 검사 메소드
	@Before("requiredLogin()")
	public void loginCheck(JoinPoint joinpoint) {
		
		HttpServletRequest request = (HttpServletRequest)joinpoint.getArgs()[0]; // 주업무 메소드의 첫 번째 파라미터
		HttpServletResponse response = (HttpServletResponse)joinpoint.getArgs()[1]; // 주업무 메소드의 두 번째 파라미터
		
		HttpSession session = request.getSession();
		
		if(session.getAttribute("loginUser") == null) {
			
			String message = "로그인 후 이용 가능합니다.";
			String loc = request.getContextPath() + "/member/login.do";
			
			request.setAttribute("message", message);
			request.setAttribute("loc", loc);
			
			// 로그인 하기 전 페이지로 돌아가도록
			String url = CommonUtil.getCurrentURL(request);
			session.setAttribute("goBackURL", url);
			RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/msg.jsp");
			
			try {
				dispatcher.forward(request, response);
				
			} catch (ServletException | IOException e) {
				e.printStackTrace();
			}
		}
	} // end of public void loginCheck(JoinPoint joinpoint -------------------
	
}
