package com.project.app.board.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.servlet.ModelAndView;

import com.project.app.board.domain.BoardRequestDTO;
import com.project.app.board.domain.BoardVO;
import com.project.app.board.domain.CommentVO;

public interface BoardService {

	// 글 작성 처리하기
	ModelAndView writeBoard(ModelAndView mav, BoardRequestDTO bdto);

	// 글 목록 페이지
	ModelAndView list(ModelAndView mav, Map<String, Object> paraMap);

	// 조회수 1 증가 + 해당 글 조회
	BoardVO getBoard(Map<String, Object> paraMap);

	// 조회수 증가 없이 글만 조회
	BoardVO getBoardNoReadCount(Map<String, Object> paraMap);

	// 글에 대한 첨부파일 이미지 리스트 가져오기
	List<Map<String, String>> getBoardImgList(String boardSeq);

	// 글 수정 처리하기
	ModelAndView editBoard(ModelAndView mav, BoardRequestDTO bdto) throws Throwable;

	// 댓글 작성 + 게시물 댓글 개수 1 증가
	boolean writeComment(CommentVO commentvo) throws Throwable;

	// 댓글 목록 조회
	List<CommentVO> getCommentList(Map<String, Object> paraMap);

	// 댓글 수정
	int editComment(CommentVO commentvo);

	// 댓글 삭제 + 게시판 테이블 댓글 개수 1 감소
	boolean deleteComment(String commentSeq, String boardSeq) throws Throwable;
	
	// 글번호에 대한 댓글 목록 불러오기
	List<CommentVO> getCommentListNoPaging(String boardSeq);

	// 글 삭제
	int deleteBoard(String boardSeq);

	// 첨부파일 삭제
	int deleteBoardImg(String imgSeq);
	
}
