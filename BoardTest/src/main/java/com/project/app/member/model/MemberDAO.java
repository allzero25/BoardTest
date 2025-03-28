package com.project.app.member.model;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.project.app.member.domain.MemberVO;

@Repository
public class MemberDAO {
	
	@Autowired
	@Qualifier("sqlSession") // bean의 id 값
	private SqlSessionTemplate sqlSession;
	
	// 아이디에 대한 회원정보 가져오기
	public MemberVO getMemberById(String userid) {
		return sqlSession.selectOne("mapper.getMemberById", userid);
	}

	// 이메일에 대한 회원정보 가져오기
	public MemberVO getMemberByEmail(String email) {
		return sqlSession.selectOne("mapper.getMemberByEmail", email);
	}
	
	// 휴대폰에 대한 회원정보 가져오기
	public MemberVO getMemberByPhone(String phone) {
		return sqlSession.selectOne("mapper.getMemberByPhone", phone);
	}

	// 회원가입 처리 (tbl_member 테이블 insert)
	public int signUp(MemberVO mvo) {
		return sqlSession.insert("mapper.signUp", mvo);
	}

	// 로그인 처리
	public MemberVO getLoginMember(Map<String, String> paraMap) {
		return sqlSession.selectOne("mapper.getLoginMember", paraMap);
	}

	// 아이디찾기: 성명,휴대폰에 대한 아이디 가져오기
	public String getUseridByNamePhone(Map<String, String> paraMap) {
		return sqlSession.selectOne("mapper.getUseridByNamePhone", paraMap);
	}

	// 비밀번호찾기: 아이디,성명,이메일에 맞는 사용자 select
	public MemberVO getMemberByIdNameEmail(Map<String, String> paraMap) {
		return sqlSession.selectOne("mapper.getMemberByIdNameEmail", paraMap);
	}

	// 비밀번호찾기: 비밀번호 변경
	public int pwUpdate(Map<String, String> paraMap) {
		return sqlSession.update("mapper.pwUpdate", paraMap);
	}
	
}
