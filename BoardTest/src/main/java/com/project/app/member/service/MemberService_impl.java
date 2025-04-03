package com.project.app.member.service;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import com.project.app.common.AES256;
import com.project.app.common.Sha256;
import com.project.app.member.domain.MemberVO;
import com.project.app.member.model.MemberDAO;

@Service
public class MemberService_impl implements MemberService {
	
	@Autowired
	private MemberDAO memberDao;
	
	// 양방향 복호화 알고리즘 AES256을 사용하여 복호화 하기 위한 클래스 의존객체 주입
	@Autowired
	private AES256 aes256;
	
	
	// 회원가입: 아이디 중복확인
	@Override
	public boolean useridDuplicateCheck(String userid) {
		
		boolean isExist = false;
		
		MemberVO member = memberDao.getMemberById(userid); // 아이디에 대한 회원정보 가져오기
		
		if(member != null)
			isExist = true;
		
		return isExist;
	}

	
	// 회원가입: 이메일 중복확인
	@Override
	public boolean emailDuplicateCheck(String email) {

		boolean isExist = false;
		
		try {
			email = aes256.encrypt(email);

//			System.out.println(email);
			MemberVO member = memberDao.getMemberByEmail(email); // 이메일에 대한 회원정보 가져오기
			
			if(member != null)
				isExist = true;
			
		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			e.printStackTrace();
		}
		
		return isExist;
	}

	
	// 회원가입: 휴대폰 중복확인
	@Override
	public boolean phoneDuplicateCheck(String phone) {
		
		boolean isExist = false;
		
		try {
			phone = aes256.encrypt(phone);
			
//			System.out.println(phone);
			MemberVO member = memberDao.getMemberByPhone(phone); // 휴대폰에 대한 회원정보 가져오기
			
			if(member != null)
				isExist = true;
			
		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			e.printStackTrace();
		}
		
		return isExist;
	}

	
	// 회원가입 처리하기
	@Override
	public int signUp(MemberVO mvo) {
		
		try {
			String password = Sha256.encrypt(mvo.getPassword());
			String email = aes256.encrypt(mvo.getEmail());
			String phone = aes256.encrypt(mvo.getPhone());
			
			mvo.setPassword(password);
			mvo.setEmail(email);
			mvo.setPhone(phone);
			
		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			e.printStackTrace();
		}
		
		int n = memberDao.signUp(mvo);
		
		return n;
	}

	
	// 로그인 처리하기
	@Override
	public ModelAndView loginEnd(Map<String, String> paraMap, ModelAndView mav, HttpServletRequest request) {
		
		MemberVO loginUser = memberDao.getLoginMember(paraMap);
		
		if(loginUser == null) { // 로그인 실패 시
			
			String message = "아이디 또는 비밀번호가 일치하지 않습니다.";
			String loc = "javascript:history.back()";
			
			mav.addObject("message", message);
			mav.addObject("loc", loc);
			
			mav.setViewName("msg");
			
		} else {
			
			try {
				String email = aes256.decrypt(loginUser.getEmail());
				String phone = aes256.decrypt(loginUser.getPhone());
				loginUser.setEmail(email);
				loginUser.setEmail(phone);
				
			} catch (UnsupportedEncodingException | GeneralSecurityException e) {
				e.printStackTrace();
			}
			
			HttpSession session = request.getSession();
			session.setAttribute("loginUser", loginUser);
			
			String goBackURL = (String)session.getAttribute("goBackURL");
//			System.out.println("goBackURL : " + goBackURL);
			
			if(goBackURL != null) { // 되돌아갈 페이지가 있을 경우
				mav.setViewName("redirect:" + goBackURL);
				session.removeAttribute("goBackURL");
				
			} else {
				mav.setViewName("redirect:/");
			}
		}
		
		return mav;
	}

	
	// 아이디찾기: 이름,휴대폰에 대한 아이디 가져오기
	@Override
	public String getUseridByNamePhone(String name, String phone) {
		
		String userid = null;
		
		try {
			phone = aes256.encrypt(phone); // 휴대폰 암호화
			
			Map<String, String> paraMap = new HashMap<>();
			paraMap.put("name", name);
			paraMap.put("phone", phone);
			
			userid = memberDao.getUseridByNamePhone(paraMap);
			
		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			e.printStackTrace();
		}
		
		return userid;
	}

	
	// 비밀번호찾기: 아이디,성명,이메일에 맞는 사용자가 있는지 확인 
	@Override
	public boolean isExistUser(Map<String, String> paraMap) {
		
		boolean isExist = false;
		
		try {
			String email = aes256.encrypt(paraMap.get("email"));
			paraMap.put("email", email);

		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			e.printStackTrace();
		}
		
		MemberVO user = memberDao.getMemberByIdNameEmail(paraMap);
		
		if(user != null) {
			isExist = true;
		}
		
		return isExist;
	}


	// 비밀번호찾기: 비밀번호 변경
	@Override
	public int pwUpdate(Map<String, String> paraMap) {
		
		int n = memberDao.pwUpdate(paraMap);
		
		return n;
	}


	
}
