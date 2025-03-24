package com.project.app.board.domain;

public class CommentVO {
	
	private String commentSeq;	// 댓글 번호
	private String fk_userid;  	// 사용자 ID
	private String name;	   	// 성명
	private String content;	   	// 댓글내용
	private String regDate;	   	// 작성일자
	private String fk_boardSeq; // 게시물 글번호
	private String status;		// 댓글삭제여부 (0:삭제, 1:기본값)
	private String groupno;		// 그룹번호 (원댓글과 답댓글은 동일한 groupno 를 가짐)
	private String fk_seq;		// 기본값 0(원댓글일 경우), 원댓글 번호(답댓글일 경우)
	private String depthno;		// 기본값 0(원댓글일 경우), 원댓글의 depthno + 1(답댓글일 경우)
	
	
	public String getCommentSeq() {
		return commentSeq;
	}
	
	public void setCommentSeq(String commentSeq) {
		this.commentSeq = commentSeq;
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
	
	public String getContent() {
		return content;
	}
	
	public void setContent(String content) {
		this.content = content;
	}
	
	public String getRegDate() {
		return regDate;
	}
	
	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}
	
	public String getFk_boardSeq() {
		return fk_boardSeq;
	}
	
	public void setFk_boardSeq(String fk_boardSeq) {
		this.fk_boardSeq = fk_boardSeq;
	}
	
	public String getStatus() {
		return status;
	}
	
	public void setStatus(String status) {
		this.status = status;
	}
	
	public String getGroupno() {
		return groupno;
	}
	
	public void setGroupno(String groupno) {
		this.groupno = groupno;
	}
	
	public String getFk_seq() {
		return fk_seq;
	}
	
	public void setFk_seq(String fk_seq) {
		this.fk_seq = fk_seq;
	}
	
	public String getDepthno() {
		return depthno;
	}
	
	public void setDepthno(String depthno) {
		this.depthno = depthno;
	}
	
}
