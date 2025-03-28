package com.project.app.board.service;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.servlet.ModelAndView;

import com.project.app.board.domain.BoardRequestDTO;
import com.project.app.board.domain.BoardVO;
import com.project.app.board.domain.CommentVO;
import com.project.app.board.model.BoardDAO;

@Service
public class BoardService_impl implements BoardService {

	@Autowired
	private BoardDAO boardDao;

	
	// 글 작성 처리하기
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor={Throwable.class})
	public ModelAndView writeBoard(ModelAndView mav, BoardRequestDTO bdto) {
		
		String message = "", loc = "";
		
		String boardSeq = boardDao.insertBoard(bdto.getBoardvo()); // 게시판 글 작성 후 글번호 가져오기
		
		if(boardSeq != null && !boardSeq.isEmpty()) {
			
			String[] fileNameArr = bdto.getFileNameArr();
			boolean allImagesInserted = true; // 모든 이미지 삽입 성공 여부
			
			if(fileNameArr != null && fileNameArr.length > 0) {
				
				Map<String, String> paraMap = new HashMap<>();
				paraMap.put("fk_boardSeq", boardSeq);
				
				for (String filename : fileNameArr) {
					
					paraMap.put("filename", filename);
	                int n = boardDao.insertBoardImg(paraMap); // 게시판 이미지 테이블 추가

	                // 이미지 삽입이 실패한 경우
	                if (n != 1) {
	                    allImagesInserted = false;
	                    break;
	                }
	            }
				
			} else {
				allImagesInserted = true; // fileNameArr가 null인 경우 이미지 삽입 필요없음
			}
			
			if(allImagesInserted) {
//				message = "글 작성이 완료되었습니다.";
//	            loc = "list.do";
	            
	            mav.addObject("boardSeq", boardSeq);
	            mav.setViewName("redirect:/board/detail.do");
	            
	            return mav;
	            
			} else {
				message = "이미지 삽입 중 오류가 발생하였습니다.";
				loc = "write.do";
			}
			
		} else {
			message = "게시글 작성 중 오류가 발생하였습니다.";
			loc = "write.do";
		}
		
		mav.addObject("message", message);
		mav.addObject("loc", loc);
		
		mav.setViewName("msg");
		
		return mav;
	}


	// 글 목록 페이지
	@Override
	public ModelAndView list(ModelAndView mav, Map<String, Object> paraMap) {
		
		String searchType = (String)paraMap.get("searchType");
		String searchWord = (String)paraMap.get("searchWord");
		String sortType = (String)paraMap.get("sortType");
		String str_currentShowPageNo = (String)paraMap.get("str_currentShowPageNo");
		
		int totalCount = 0,	   // 총 게시물 수
			countPerPage = 5,  // 한 페이지당 게시물 수
			currentShowPageNo = 0, // 현재 페이지 번호
			totalPage = 0; 	   // 총 페이지 수
		
		// 총 게시물 수 가져오기
		totalCount = boardDao.getTotalCount(paraMap);
//		System.out.println("totalCount : " + totalCount);
		
		// 총 페이지 수 계산
		totalPage = (int)Math.ceil((double)totalCount/countPerPage);
		
		if(str_currentShowPageNo == null) { // 현재 페이지 번호가 null일 때(페이지를 처음 로드할 때)
			currentShowPageNo = 1;
			
		} else {
			try {
				currentShowPageNo = Integer.parseInt(str_currentShowPageNo);
				
				if(currentShowPageNo < 1 || currentShowPageNo > totalPage) // url에 페이지에 없는 숫자를 입력했을 경우
					currentShowPageNo = 1;
				
			} catch (NumberFormatException e) { // url에 숫자가 아닌 문자를 입력했을 경우 
				currentShowPageNo = 1;
			}
		}
		
		paraMap.put("countPerPage", countPerPage);
		
		int offset = (currentShowPageNo - 1) * countPerPage; // 0일 경우: 1페이지, 5일 경우: 2페이지
		paraMap.put("offset", offset);
		
		// 글 목록 가져오기
		List<BoardVO> boardList = boardDao.getBoardList(paraMap);
		mav.addObject("boardList", boardList);
		
		// 검색 시 검색타입, 검색어, 정렬조건 유지하기 위함
		if(("subject".equals(searchType) || "content".equals(searchType) || "name".equals(searchType)) && 
			("boardSeq".equals(sortType) || "readCount".equals(sortType) || "commentCount".equals(sortType))) {
			
			mav.addObject("paraMap", paraMap);
		}
		
		// 페이지 바 만들기
		int blockSize = 10;
		
		int loop = 1;
		
		int pageNo = ((currentShowPageNo - 1)/blockSize) * blockSize + 1;
		
		String pageBar = "<ul>";
		String url = "list.do";
		
		// 맨처음, 이전
		if(pageNo != 1) {
			pageBar += "<li style='width: 5%; font-size: 0.8em;'><a href='" + url + "?searchType=" + searchType + "&searchWord=" + searchWord + "&sortType=" + sortType + "&currentShowPageNo=1'>◀◀</a></li>";
			pageBar += "<li style='width: 5%; font-size: 0.8em;'><a href='" + url + "?searchType=" + searchType + "&searchWord=" + searchWord + "&sortType=" + sortType + "&currentShowPageNo=" + (pageNo - 1) + "'>◀</a></li>";
		}
		
		while(!(loop > blockSize || pageNo > totalPage)) {
			if(pageNo == currentShowPageNo) {
				pageBar += "<li class='font-weight-bold' style='width: 3%; color: #0066ff;'>" + pageNo + "</li>";
				
			} else {
				pageBar += "<li style='width: 3%;'><a href='" + url + "?searchType=" + searchType + "&searchWord=" + searchWord + "&sortType=" + sortType + "&currentShowPageNo=" + pageNo + "'>" + pageNo + "</a></li>";
			}
			
			loop++;
			pageNo++;
		}
		
		// 다음, 마지막
		if(pageNo <= totalPage) {
			pageBar += "<li style='width: 5%; font-size: 0.8em;'><a href='" + url + "?searchType=" + searchType + "&searchWord=" + searchWord + "&sortType=" + sortType + "&currentShowPageNo=" + pageNo + "'>▶</a></li>";
			pageBar += "<li style='width: 5%; font-size: 0.8em;'><a href='" + url + "?searchType=" + searchType + "&searchWord=" + searchWord + "&sortType=" + sortType + "&currentShowPageNo=" + totalPage + "'>▶▶</a></li>";
		}
		
		pageBar += "</ul>";
		
		mav.addObject("pageBar", pageBar);
		
		// 페이징 처리 시 순번에 필요한 변수들 mav에 넣어주기
		mav.addObject("totalCount", totalCount);
		mav.addObject("currentShowPageNo", currentShowPageNo);
		mav.addObject("countPerPage", countPerPage);

		mav.setViewName("board/list.tiles1");
		
		return mav;
	}


	// 조회수 1 증가 + 해당 글 조회
	@Override
	public BoardVO getBoard(Map<String, Object> paraMap) {
		
		// 글 조회하기
		BoardVO board = boardDao.getBoard(paraMap);
		
		String loginId = (String)paraMap.get("loginId");
		
		if(loginId != null &&
		   board != null &&
		   !loginId.equals(board.getFk_userid())) {
			// 로그인한 사용자가 다른 사람의 글을 읽을 때만 조회수 증가
			
			int n = boardDao.updateReadCount(board.getBoardSeq()); // 조회수 1 증가하기
			
			if(n == 1) {
				board.setReadCount(String.valueOf(Integer.parseInt(board.getReadCount()) + 1));
				// board.getReadCount()가 String이므로 형 변환
			}
		}
		
		return board;
	}


	// 조회수 증가 없이 글만 조회
	@Override
	public BoardVO getBoardNoReadCount(Map<String, Object> paraMap) {
		
		BoardVO board = boardDao.getBoard(paraMap);
		
		return board;
	}


	// 글에 대한 첨부파일 이미지 리스트 가져오기
	@Override
	public List<Map<String, String>> getBoardImgList(String boardSeq) {
		
		List<Map<String, String>> boardImgList = boardDao.getBoardImgList(boardSeq);
		
		return boardImgList;
	}


	// 글 수정 처리하기
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor={Throwable.class})
	public ModelAndView editBoard(ModelAndView mav, BoardRequestDTO bdto) throws Throwable {
		
		String message = "", loc = "";
		String boardSeq = bdto.getBoardvo().getBoardSeq();
		
		// 1. 글 수정
		int n1 = boardDao.updateBoard(bdto.getBoardvo());
		
		if(n1 == 1) {
			
			// 2. 새로 첨부된 파일이 있고, 기존에 이미지가 있으면 삭제
			String[] fileNameArr = bdto.getFileNameArr();
			List<Map<String, String>> boardImgList = boardDao.getBoardImgList(boardSeq);
			
			boolean allImagesDeleted = true; // 기존 이미지 삭제 여부
			
			if(fileNameArr != null && fileNameArr.length > 0 && boardImgList != null) {
				for(Map<String, String> boardImgMap : boardImgList) {
					
					int n2 = boardDao.deleteBoardImg(boardImgMap.get("imgSeq"));
					
					if(n2 != 1) {
						allImagesDeleted = false;
						break;
					}
				}
			}
			
			// 3. 이미지테이블 새 이미지 추가
			boolean allImagesInserted = true;
			
			if(allImagesDeleted && fileNameArr != null && fileNameArr.length > 0) {
				Map<String, String> paraMap = new HashMap<>();
				paraMap.put("fk_boardSeq", boardSeq);
				
				for(String filename : fileNameArr) {
					paraMap.put("filename", filename);
					int n3 = boardDao.insertBoardImg(paraMap);
					
					if(n3 != 1) {
						allImagesInserted = false;
						break;
					}
				}
			}
			
			if(allImagesDeleted && allImagesInserted) { // 글 수정 완료
				mav.addObject("boardSeq", boardSeq);
				mav.setViewName("redirect:/board/detail.do");
				
				return mav;
				
			} else {
				message = "이미지 처리 중 오류가 발생하였습니다.";
				loc = "edit.do?boardSeq=" + boardSeq;
			}
			
		} else {
			message = "게시글 수정 중 오류가 발생하였습니다.";
			loc = "edit.do?boardSeq=" + boardSeq;
		}
		
		mav.addObject("message", message);
		mav.addObject("loc", loc);
		
		mav.setViewName("msg");
		
		return mav;
	}


	// 댓글 작성 + 게시물 댓글 개수 1 증가
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor={Throwable.class})
	public boolean writeComment(CommentVO commentvo) throws Throwable {
		
		boolean isOK = false;
		
		if(commentvo.getFk_seq() == null) { // 원댓글일 경우
			
			int groupno = boardDao.getGroupnoMax() + 1;
			// groupno 값은 'groupno 컬럼의 최대값 + 1로 해야 한다.
			
			commentvo.setGroupno(String.valueOf(groupno));
		}
		
		int n1 = boardDao.insertComment(commentvo);
		
		if(n1 == 1) {
			
			String boardSeq = commentvo.getFk_boardSeq();
			
			Map<String, Object> paraMap = new HashMap<>();
			paraMap.put("boardSeq", boardSeq);
			paraMap.put("count", 1);
			
			int n2 = boardDao.updateCommentCount(paraMap);
			
			if(n2 == 1) {
				isOK = true;
			}
		}
		
		return isOK;
	}


	// 댓글 목록 조회
	@Override
	public List<CommentVO> getCommentList(Map<String, Object> paraMap) {
		
		List<CommentVO> commentList = boardDao.getCommentList(paraMap);
		
		return commentList;
	}


	// 댓글 수정
	@Override
	public int editComment(CommentVO commentvo) {
		
		int n = boardDao.updateComment(commentvo);
		
		return n;
	}


	// 댓글 삭제 + 게시판 테이블 댓글 개수 1 감소
	@Override
	@Transactional(propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor={Throwable.class})
	public boolean deleteComment(String commentSeq, String boardSeq) throws Throwable {
		
		boolean isOK = false;
		
		// 댓글 삭제 (status를 0으로 update)
		int n1 = boardDao.updateCommentStatus(commentSeq);
		
		if(n1 == 1) {
			Map<String, Object> paraMap = new HashMap<>();
			paraMap.put("boardSeq", boardSeq);
			paraMap.put("count", -1);
			
			int n2 = 0;
			
			paraMap.put("searchType", "");
			paraMap.put("searchWord", "");
			BoardVO boardvo = boardDao.getBoard(paraMap);
			
			int commentCount = Integer.parseInt(boardvo.getCommentCount());
			
			if(commentCount > 0) {
				// 게시판 테이블 댓글 개수 1 감소
				n2 = boardDao.updateCommentCount(paraMap);
			}
			
			if(n2 == 1)
				isOK = true;
		}
		
		return isOK;
	}


	// 글번호에 대한 댓글 목록 불러오기
	@Override
	public List<CommentVO> getCommentListNoPaging(String boardSeq) {
		
		List<CommentVO> commentList = boardDao.getCommentListNoPaging(boardSeq);
		
		return commentList;
	}


	// 글 삭제 (게시글의 status를 0으로 update)
	@Override
	public int deleteBoard(String boardSeq) {
		
		int n = boardDao.updateBoardStatus(boardSeq);
		
		return n;
	}


	// 첨부파일 삭제
	@Override
	public int deleteBoardImg(String imgSeq) {
		
		int n = boardDao.deleteBoardImg(imgSeq);
		
		return n;
	}
	
	
}
