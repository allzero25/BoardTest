package com.project.app.board.domain;

import org.springframework.web.multipart.MultipartFile;

public class BoardVO {

	private String boardSeq;     // 글번호 
	private String fk_userid; 	 // 사용자ID
	private String name; 		 // 글쓴이
	private String subject; 	 // 글제목
	private String content; 	 // 글내용
	private String readCount; 	 // 조회수
	private String regDate; 	 // 작성일자
	private String status; 		 // 글삭제여부  1:사용가능, 0:삭제

	private String commentCount; // 댓글개수
	
	private MultipartFile[] attach;

	// select 용
	private String prevSeq;  	// 이전글번호
	private String prevSubject; // 이전글제목
	private String nextSeq; 	// 다음글번호
	private String nextSubject; // 다음글제목
	
	private String thumbnailImg; // 게시판 목록에 보일 사진
	
	
	public BoardVO() {}
	
	public BoardVO(String boardSeq, String fk_userid, String name, String subject, String content, String readCount,
			String regDate, String status) {

		this.boardSeq = boardSeq;
		this.fk_userid = fk_userid;
		this.name = name;
		this.subject = subject;
		this.content = content;
		this.readCount = readCount;
		this.regDate = regDate;
		this.status = status;
	}

	public String getBoardSeq() {
		return boardSeq;
	}

	public void setBoardSeq(String boardSeq) {
		this.boardSeq = boardSeq;
	}

	public String getFk_userid() {
		return fk_userid;
	}

	public void setFk_userid(String fk_userid) {
		this.fk_userid = fk_userid;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getSubject() {
		return subject;
	}

	public void setSubject(String subject) {
		this.subject = subject;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getReadCount() {
		return readCount;
	}

	public void setReadCount(String readCount) {
		this.readCount = readCount;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getPrevSeq() {
		return prevSeq;
	}

	public void setPrevSeq(String prevSeq) {
		this.prevSeq = prevSeq;
	}

	public String getPrevSubject() {
		return prevSubject;
	}

	public void setPrevSubject(String prevSubject) {
		this.prevSubject = prevSubject;
	}

	public String getNextSeq() {
		return nextSeq;
	}

	public void setNextSeq(String nextSeq) {
		this.nextSeq = nextSeq;
	}

	public String getNextSubject() {
		return nextSubject;
	}

	public void setNextSubject(String nextSubject) {
		this.nextSubject = nextSubject;
	}

	public String getCommentCount() {
		return commentCount;
	}

	public void setCommentCount(String commentCount) {
		this.commentCount = commentCount;
	}

	public MultipartFile[] getAttach() {
		return attach;
	}

	public void setAttach(MultipartFile[] attach) {
		this.attach = attach;
	}
	
	public String getThumbnailImg() {
		return thumbnailImg;
	}

	public void setThumbnailImg(String thumbnailImg) {
		this.thumbnailImg = thumbnailImg;
	}

	
}
