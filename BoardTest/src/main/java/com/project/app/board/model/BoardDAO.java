package com.project.app.board.model;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.project.app.board.domain.BoardVO;
import com.project.app.board.domain.CommentVO;

@Repository
public class BoardDAO {
	
	@Autowired
	@Qualifier("sqlSession") // bean의 id 값
	private SqlSessionTemplate sqlSession;

	
	// 게시판 글 작성 후 글번호 가져오기
	public String insertBoard(BoardVO boardvo) {
		sqlSession.insert("mapper.insertBoard", boardvo);
		return boardvo.getBoardSeq();
	}

	// 게시판 이미지 테이블 추가
	public int insertBoardImg(Map<String, String> paraMap) {
		return sqlSession.insert("mapper.insertBoardImg", paraMap);
	}

	// 총 게시물 수 가져오기
	public int getTotalCount(Map<String, Object> paraMap) {
		return sqlSession.selectOne("mapper.getTotalCount", paraMap);
	}

	// 글 목록 가져오기
	public List<BoardVO> getBoardList(Map<String, Object> paraMap) {
		return sqlSession.selectList("mapper.getBoardList", paraMap);
	}

	// 글 조회하기
	public BoardVO getBoard(Map<String, Object> paraMap) {
		return sqlSession.selectOne("mapper.getBoard", paraMap);
	}

	// 글 조회수 1 증가
	public int updateReadCount(String boardSeq) {
		return sqlSession.update("mapper.updateReadCount", boardSeq);
	}
	
	// 글에 대한 첨부파일 이미지 리스트 가져오기
	public List<Map<String, String>> getBoardImgList(String boardSeq) {
		return sqlSession.selectList("mapper.getBoardImgList", boardSeq);
	}

	// 글 수정하기 (tbl_board 테이블 수정)
	public int updateBoard(BoardVO boardvo) {
		return sqlSession.update("mapper.updateBoard", boardvo);
	}

	// tbl_board_img 테이블 이미지 삭제
	public int deleteBoardImg(String imgSeq) {
		return sqlSession.delete("mapper.deleteBoardImg", imgSeq);
	}
	
	// tbl_comment 테이블 groupno 최대값 구하기
	public int getGroupnoMax() {
		return sqlSession.selectOne("mapper.getGroupnoMax");
	}

	// 댓글 작성하기
	public int insertComment(CommentVO commentvo) {
		return sqlSession.insert("mapper.insertComment", commentvo);
	}

	// 게시판 테이블 댓글 개수 변경
	public int updateCommentCount(Map<String, Object> paraMap) {
		return sqlSession.update("mapper.updateCommentCount", paraMap);
	}

	// 댓글 목록 조회
	public List<CommentVO> getCommentList(Map<String, Object> paraMap) {
		return sqlSession.selectList("mapper.getCommentList", paraMap);
	}

	// 댓글 수정
	public int updateComment(CommentVO commentvo) {
		return sqlSession.update("mapper.updateComment", commentvo);
	}

	// 댓글 삭제 (status를 0으로 update)
	public int updateCommentStatus(String commentSeq) {
		return sqlSession.update("mapper.updateCommentStatus", commentSeq);
	}

	// 글번호에 대한 댓글 목록 불러오기
	public List<CommentVO> getCommentListNoPaging(String boardSeq) {
		return sqlSession.selectList("mapper.getCommentListNoPaging", boardSeq);
	}

	// 글 삭제 (status를 0으로 update)
	public int updateBoardStatus(String boardSeq) {
		return sqlSession.update("mapper.updateBoardStatus", boardSeq);
	}
	
}
