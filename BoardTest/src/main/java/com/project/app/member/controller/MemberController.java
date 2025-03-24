package com.project.app.member.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.project.app.common.Sha256;
import com.project.app.member.domain.MemberVO;
import com.project.app.member.service.MemberService;

@Controller
@RequestMapping("/member")
public class MemberController {
	
	@Autowired
	private MemberService memberService;
	
	
	// 회원가입 페이지 띄우기
    @GetMapping("signUp.do")
    public String signUp() {
    	    	
        return "member/signUp.tiles1";
    }
    
    
    // 회원가입: 아이디 중복확인
    @ResponseBody
    @PostMapping(value="useridDuplicateCheck.do", produces="text/plain;charset=UTF-8")
    public String useridDuplicateCheck(HttpServletRequest request) {
    	
    	String userid = request.getParameter("userid");
    	
    	boolean isExist = memberService.useridDuplicateCheck(userid);
    	
    	JSONObject jsonObj = new JSONObject();
    	jsonObj.put("isExist", isExist);
    	
    	return jsonObj.toString();
    } // end of public String useridDuplicateCheck(HttpServletRequest request) -------------
    
    
    // 회원가입: 이메일 중복확인
    @ResponseBody
    @PostMapping(value="emailDuplicateCheck.do", produces="text/plain;charset=UTF-8")
    public String emailDuplicateCheck(HttpServletRequest request) {
    	
    	String email = request.getParameter("email");
    	
    	boolean isExist = memberService.emailDuplicateCheck(email);
    	
    	JSONObject jsonObj = new JSONObject();
    	jsonObj.put("isExist", isExist);
    	
    	return jsonObj.toString();
    } // end of public String emailDuplicateCheck(HttpServletRequest request) -------------
    
    
    // 회원가입 처리하기
    @ResponseBody
    @PostMapping(value="signUp.do", produces="text/plain;charset=UTF-8")
    public String signUpEnd(MemberVO mvo) {

    	int n = memberService.signUp(mvo);
    	
    	JSONObject jsonObj = new JSONObject();
    	jsonObj.put("n", n);
    	    	
        return jsonObj.toString();
    } // end of public String signUpEnd(MemberVO mvo) --------------------
    
    
    // 로그인 페이지
    @GetMapping("login.do")
    public String login() {
        return "member/login.tiles1";
    }
    
    
    // 로그인 처리하기
    @PostMapping("login.do")
    public ModelAndView loginEnd(ModelAndView mav, HttpServletRequest request) {
    	
    	String userid = request.getParameter("userid");
    	String password = Sha256.encrypt(request.getParameter("password"));
    	
    	Map<String, String> paraMap = new HashMap<>();
    	paraMap.put("userid", userid);
    	paraMap.put("password", password);
    	
    	mav = memberService.loginEnd(paraMap, mav, request);
    	
    	return mav;
    } // end of public ModelAndView loginEnd(ModelAndView mav, HttpServletRequest request) -----------
    
    
    // 로그아웃 처리
    @GetMapping("logout.do")
    public ModelAndView logout(ModelAndView mav, HttpServletRequest request) {
    	
    	HttpSession session = request.getSession();
    	session.invalidate();
    	
    	String message = "로그아웃 되었습니다.";
    	String loc = request.getContextPath() + "/";
    	
    	mav.addObject("message", message);
    	mav.addObject("loc", loc);
    	
    	mav.setViewName("msg");
    	
    	return mav;
    } // end of public ModelAndView logout(ModelAndView mav, HttpServletRequest request) -----------
    
    
    // 아이디찾기 페이지
    @GetMapping("idFind.do")
    public String idFind() {
    	return "member/idFind.tiles1";
    }
    
    
    // 아이디찾기 처리하기
    @ResponseBody
    @PostMapping(value="idFind.do", produces="text/plain;charset=UTF-8")
    public String idFindEnd(HttpServletRequest request) {
    	
    	String name = request.getParameter("name");
    	String phone = request.getParameter("phone");
    	
    	Map<String, String> paraMap = new HashMap<>();
    	paraMap.put("name", name);
    	paraMap.put("phone", phone);
    	
    	String userid = memberService.getUseridByNamePhone(paraMap);
    	
    	JSONObject jsonObj = new JSONObject();
    	jsonObj.put("userid", userid);
    	
    	return jsonObj.toString();
    } // end of public String idFindEnd(HttpServletRequest request) ------------
    
    
    // 비밀번호찾기 페이지
    @GetMapping("pwFind.do")
    public String pwFind() {
    	return "member/pwFind.tiles1";
    }
    
    
    // 비밀번호찾기 처리하기
    @ResponseBody
    @PostMapping(value="pwFind.do", produces="text/plain;charset=UTF-8")
    public String pwFindEnd(HttpServletRequest request) {
    	
    	String userid = request.getParameter("userid");
    	String name = request.getParameter("name");
    	String email = request.getParameter("email");
    	
    	Map<String, String> paraMap = new HashMap<>();
    	paraMap.put("userid", userid);
    	paraMap.put("name", name);
    	paraMap.put("email", email);
    	
    	boolean isExist = memberService.isExistUser(paraMap);
    	
    	if(isExist) {
    		HttpSession session = request.getSession();
    		session.setAttribute("userid", userid);
    	}
    	
    	JSONObject jsonObj = new JSONObject();
    	jsonObj.put("isExist", isExist);
    	
    	return jsonObj.toString();
    }
    
    
    // 비밀번호찾기: 비밀번호 변경 페이지
    @GetMapping("pwFind/pwUpdate.do")
    public String pwUpdate() {
    	return "member/pwUpdate.tiles1";
    }
    
    
    // 비밀번호찾기: 비밀번호 변경 처리하기
    @ResponseBody
    @PostMapping(value="pwFind/pwUpdate.do", produces="text/plain;charset=UTF-8")
    public String pwUpdateEnd(HttpServletRequest request) {
    	
    	HttpSession session = request.getSession();
    	String userid = (String)session.getAttribute("userid"); // 세션에 저장해놓은 아이디 불러오기
    	
    	String password = Sha256.encrypt(request.getParameter("password"));
    	
    	Map<String, String> paraMap = new HashMap<>();
    	paraMap.put("userid", userid);
    	paraMap.put("password", password);
    	
    	int n = memberService.pwUpdate(paraMap);
    	
    	JSONObject jsonObj = new JSONObject();
    	jsonObj.put("n", n);
    	
    	if(n == 1) {
    		session.removeAttribute("userid"); // 세션에 저장해놓은 아이디 삭제
    	}
    	
    	return jsonObj.toString();
    }
    
}
