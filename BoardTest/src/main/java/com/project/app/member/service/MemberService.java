package com.project.app.member.service;

import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import com.project.app.member.domain.MemberVO;

public interface MemberService {

	// 회원가입: 아이디 중복확인
	boolean useridDuplicateCheck(String userid);

	// 회원가입: 이메일 중복확인
	boolean emailDuplicateCheck(String email);

	// 회원가입: 휴대폰 중복확인
	boolean phoneDuplicateCheck(String phone);
	
	// 회원가입 처리하기
	int signUp(MemberVO mvo);

	// 로그인 처리하기
	ModelAndView loginEnd(Map<String, String> paraMap, ModelAndView mav, HttpServletRequest request);

	// 아이디찾기: 성명,휴대폰에 대한 아이디 가져오기
	String getUseridByNamePhone(String name, String phone);

	// 비밀번호찾기: 아이디,성명,이메일에 맞는 사용자가 있는지 확인 
	boolean isExistUser(Map<String, String> paraMap);

	// 비밀번호찾기: 비밀번호 변경
	int pwUpdate(Map<String, String> paraMap);

}
