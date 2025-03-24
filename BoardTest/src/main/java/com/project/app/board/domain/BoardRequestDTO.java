package com.project.app.board.domain;

public class BoardRequestDTO {

    private BoardVO boardvo; // 게시글 정보
    private String[] fileNameArr; // 첨부파일 이름 배열

    
    public BoardVO getBoardvo() {
        return boardvo;
    }

    public void setBoardvo(BoardVO boardvo) {
        this.boardvo = boardvo;
    }

    public String[] getFileNameArr() {
        return fileNameArr;
    }

    public void setFileNameArr(String[] fileNameArr) {
        this.fileNameArr = fileNameArr;
    }
    
}
