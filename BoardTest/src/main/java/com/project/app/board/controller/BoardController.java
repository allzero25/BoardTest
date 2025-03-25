package com.project.app.board.controller;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.support.RequestContextUtils;

import com.project.app.board.domain.BoardRequestDTO;
import com.project.app.board.domain.BoardVO;
import com.project.app.board.domain.CommentVO;
import com.project.app.board.service.BoardService;
import com.project.app.common.CommonUtil;
import com.project.app.common.FileManager;
import com.project.app.member.domain.MemberVO;

@Controller
@RequestMapping("/board")
public class BoardController {
	
	@Autowired
	private BoardService boardService;
	
	@Autowired
	private FileManager fileManager;
	
	
	// 글 작성 페이지 띄우기 (AOP)
	@GetMapping("write.do")
	public String requiredLogin_writeBoard(HttpServletRequest request, HttpServletResponse response) {
		
		return "board/write.tiles1";
	} // end of public String requiredLogin_write(HttpServletRequest request, HttpServletResponse response) ----------
	
	
	// 글 작성 처리
	@PostMapping("write.do")
	public ModelAndView writeBoardEnd(ModelAndView mav, BoardVO boardvo, MultipartHttpServletRequest mrequest) {
		
		BoardRequestDTO bdto = new BoardRequestDTO();
		
		HttpSession session = mrequest.getSession();
		
		// 파일 업로드 경로 설정
		String root = session.getServletContext().getRealPath("/");
//			System.out.println(root);
		// C:\eclipse-workspace\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\BoardTest\
		
		String path = root + "resources" + File.separator + "images" + File.separator + "board";
//			System.out.println(path);
		// C:\eclipse-workspace\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\BoardTest\resources\images\board
		
		MultipartFile[] attachArr = boardvo.getAttach();
		
		if(attachArr != null) {
			
			String[] fileNameArr = new String[attachArr.length]; // 첨부파일명들을 저장시키는 용도
			int attachIdx = 0;
			
			List<MultipartFile> files = new ArrayList<>();
			
			// files 리스트에 첨부파일 추가
			for(int i=0; i<attachArr.length; i++) {
				MultipartFile file = attachArr[i];
				if(file != null) {
					files.add(file);
				}
			}
			
			for(MultipartFile file : files) {
				
				if(!file.isEmpty()) {
					
					try {
						String originalFileName = file.getOriginalFilename(); //원래 파일명

						byte[] bytes = file.getBytes();
						
						// 파일 업로드 후 업로드된 파일명 가져오기
						String newFileName = fileManager.uploadFile(bytes, originalFileName, path);
						
						fileNameArr[attachIdx++] = newFileName; // 업로드 된 파일명을 배열에 저장
						bdto.setFileNameArr(fileNameArr);
						
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
				
			} // end of for -----------------------------------
			
		}
		
		String content = CommonUtil.changeEtcTag(boardvo.getContent());
		boardvo.setContent(content);
		bdto.setBoardvo(boardvo);
		
		mav = boardService.writeBoard(mav, bdto); // 글 작성 처리
		
		return mav;
	} // end of public ModelAndView writeEnd(ModelAndView mav, BoardVO boardvo, MultipartHttpServletRequest mrequest) --------
	
	
	// 글 목록 페이지 띄우기
	@GetMapping("list.do")
	public ModelAndView list(ModelAndView mav, HttpServletRequest request) {
		
		HttpSession session = request.getSession();
		
		// 상세페이지에서 새로고침(F5)할 때 조회수 증가 방지를 위해 세션에 readCountPermission 저장
		session.setAttribute("readCountPermission", "yes");
		
		String searchType = request.getParameter("searchType");
		String searchWord = request.getParameter("searchWord");
		String str_currentShowPageNo = request.getParameter("currentShowPageNo");
		
		mav = boardService.list(mav, searchType, searchWord, str_currentShowPageNo);
		
		// 게시판 검색->글 상세페이지 본 이후 <검색된 결과 목록 보기> 클릭 시 현재 페이지를 알기 위함
		String goBackURL = CommonUtil.getCurrentURL(request);
		mav.addObject("goBackURL", goBackURL);
		
		return mav;
	} // end of public ModelAndView list(ModelAndView mav, HttpServletRequest request) ---------------
	
	
	// 글 상세 페이지 띄우기
	@RequestMapping("detail.do")
	public ModelAndView detail(ModelAndView mav, HttpServletRequest request) {
		
		String boardSeq = request.getParameter("boardSeq");
		String goBackURL = request.getParameter("goBackURL");
		String searchType = request.getParameter("searchType");
		String searchWord = request.getParameter("searchWord");
		
		// === 이전 글, 다음 글 보기 ===
		Map<String, ?> inputFlashMap = RequestContextUtils.getInputFlashMap(request);
		// redirect 되어 넘어온 데이터가 있는지 확인
		
		if(inputFlashMap != null) {
			Map<String, String> redirectMap = (Map<String, String>)inputFlashMap.get("redirectMap");
			
			boardSeq = redirectMap.get("boardSeq");
			searchType = redirectMap.get("searchType");
			
			try {
				goBackURL = URLDecoder.decode(redirectMap.get("goBackURL"), "UTF-8");
				searchWord = URLDecoder.decode(redirectMap.get("searchWord"), "UTF-8");
				
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
		}
		// === 이전 글, 다음 글 보기 end. ===
		
		mav.addObject("goBackURL", goBackURL);
		
		
		try {
			Integer.parseInt(boardSeq);
			
			HttpSession session = request.getSession();
			MemberVO loginUser = (MemberVO)session.getAttribute("loginUser");
			
			String loginId = null;
			
			if(loginUser != null) {
				loginId = loginUser.getUserid();
			}
			
			Map<String, Object> paraMap = new HashMap<>();
			paraMap.put("boardSeq", boardSeq);
			paraMap.put("loginId", loginId);
			
			// 검색->상세페이지를 들어간 경우 검색된 결과 내의 이전글,다음글을 보이게 하기 위함
			paraMap.put("searchType", searchType);
			paraMap.put("searchWord", searchWord);
			
			BoardVO board = null;
			
			String readCountPermission = (String)session.getAttribute("readCountPermission");
			// 글 목록 페이지에서 yes로 설정
			
			if("yes".equals(readCountPermission)) {
				// 글 목록에서 클릭한 경우
				
				board = boardService.getBoard(paraMap);
				// 조회수 1 증가 + 해당 글 조회
				
				session.removeAttribute("readCountPermission"); // 세션에 있는 readCountPermission 삭제
				
			} else {
				// 상세페이지에서 새로고침(F5)한 경우
				
				board = boardService.getBoardNoReadCount(paraMap);
				// 조회수 증가 없이 해당 글 조회
			}
			
			List<Map<String, String>> boardImgList = new ArrayList<>();
			
			// 글에 대한 첨부파일 이미지 리스트 가져오기
			if(board != null) {
				boardImgList = boardService.getBoardImgList(boardSeq);
			}
			
			mav.addObject("board", board);
			mav.addObject("boardImgList", boardImgList);
			mav.addObject("paraMap", paraMap); // 이전글, 다음글 보기
			
			mav.setViewName("board/detail.tiles1");
			
		} catch (NumberFormatException e) {
			e.printStackTrace();
			mav.setViewName("redirect:/board/list.do");
		}
		
		return mav;
	} // end of public ModelAndView detail(ModelAndView mav, HttpServletRequest request) ---------------------
	
	
	// 이전글, 다음글 보기
	@PostMapping("detail2.do")
	public ModelAndView detail2(ModelAndView mav, HttpServletRequest request, RedirectAttributes redirectAttr) {
		
		String boardSeq = request.getParameter("boardSeq");
		String goBackURL = request.getParameter("goBackURL");
		String searchType = request.getParameter("searchType");
		String searchWord = request.getParameter("searchWord");
		
		try {
			goBackURL = URLEncoder.encode(goBackURL, "UTF-8");
			searchWord = URLEncoder.encode(searchWord, "UTF-8");
			
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		
		HttpSession session = request.getSession();
		session.setAttribute("readCountPermission", "yes");
		
		// redirect(GET 방식) 시 POST 방식으로 데이터를 넘길 때 RedirectAttributes 사용 
		Map<String, String> redirectMap = new HashMap<>();
		redirectMap.put("boardSeq", boardSeq);
		redirectMap.put("goBackURL", goBackURL);
		redirectMap.put("searchType", searchType);
		redirectMap.put("searchWord", searchWord);
		
		redirectAttr.addFlashAttribute("redirectMap", redirectMap);
		
		mav.setViewName("redirect:/board/detail.do");
		
		return mav;
	} // end of public ModelAndView detail2(ModelAndView mav, HttpServletRequest request, RedirectAttributes redirectAttr) ----
	
	
	
	// 글 수정 페이지 띄우기
	@GetMapping("edit.do")
	public ModelAndView requiredLogin_editBoard(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) {
		
		String boardSeq = request.getParameter("boardSeq");
		
		try {
			Integer.parseInt(boardSeq);
		
			Map<String, Object> paraMap = new HashMap<>();
			paraMap.put("boardSeq", boardSeq);
			
			// 글 조회하기
			BoardVO board = boardService.getBoardNoReadCount(paraMap);
			
			HttpSession session = request.getSession();
			MemberVO loginUser = (MemberVO)session.getAttribute("loginUser");
			
			String loginId = loginUser.getUserid();
			
			if(board != null && loginId.equals(board.getFk_userid())) {
				// 게시글이 존재하고, 로그인한 사용자의 글일 경우
				
				List<Map<String, String>> boardImgList = boardService.getBoardImgList(boardSeq);
				// 글에 대한 첨부파일 이미지 리스트 가져오기
				
				mav.addObject("board", board);
				mav.addObject("boardImgList", boardImgList);
				mav.setViewName("board/edit.tiles1");
				
				return mav;
			}
			
		} catch (NumberFormatException e) {
			
		}
		
		String message = "잘못된 접근입니다.";
		String loc = "javascript:history.back()";
		
		mav.addObject("message", message);
		mav.addObject("loc", loc);
		
		mav.setViewName("msg");
		
		return mav;
	} // end of public ModelAndView requiredLogin_editBoard(HttpServletRequest request, HttpServletResponse response, ModelAndView mav) -----
	
	
	// 글 수정 처리
	@PostMapping("edit.do")
	public ModelAndView editBoardEnd(ModelAndView mav, BoardVO boardvo, MultipartHttpServletRequest mrequest) {
		
		BoardRequestDTO bdto = new BoardRequestDTO();
		
		HttpSession session = mrequest.getSession();
		
		// 파일 업로드 경로 설정
		String root = session.getServletContext().getRealPath("/");
		String path = root + "resources" + File.separator + "images" + File.separator + "board";
		
		MultipartFile[] attachArr = boardvo.getAttach();
		
		if(attachArr != null && attachArr.length > 0) {

			// 새로 첨부된 파일이 있는 경우 원래 있던 파일을 서버에서 삭제하기
			try {
				List<Map<String, String>> boardImgList = boardService.getBoardImgList(boardvo.getBoardSeq());
				
				if(boardImgList != null) {
					for(Map<String, String> boardImgMap : boardImgList) {
						fileManager.deleteFile(boardImgMap.get("filename"), path);
					}
				}
			
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			String[] fileNameArr = new String[attachArr.length]; // 첨부파일명을 저장시키는 용도
			int attachIdx = 0;
			
			List<MultipartFile> files = new ArrayList<>();
			
			// files 리스트에 첨부파일 추가
			for(int i=0; i<attachArr.length; i++) {
				
				MultipartFile file = attachArr[i];
				
				if(file != null)
					files.add(file);
			} // end of for ------------------------
			
			
			// 파일 업로드
			try {
				for(MultipartFile file : files) {
					if(!file.isEmpty()) {
						
						String originalFileName = file.getOriginalFilename(); //원래 파일명
						
						byte[] bytes = file.getBytes();
						
						// 파일 업로드 후 업로드된 파일명 가져오기
						String newFileName = fileManager.uploadFile(bytes, originalFileName, path);
						
						fileNameArr[attachIdx++] = newFileName; // 업로드 된 파일명을 배열에 저장
						bdto.setFileNameArr(fileNameArr);
						
					}
				} // end of for(MultipartFile file : files) --------------------------
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		String content = CommonUtil.changeEtcTag(boardvo.getContent());
		boardvo.setContent(content);
		bdto.setBoardvo(boardvo);
		
		try {
			mav = boardService.editBoard(mav, bdto); // 글 수정 처리
			
		} catch (Throwable e) {
//			System.out.println("트랜잭션 처리 오류");
			e.printStackTrace();
		}
		
		return mav;
	} // end of public ModelAndView editBoardEnd(ModelAndView mav, BoardVO boardvo, MultipartHttpServletRequest mrequest) ----------
	
	
	// 댓글 작성 처리
	@ResponseBody
	@PostMapping(value="writeComment.do", produces="text/plain;charset=UTF-8")
	public String writeComment(CommentVO commentvo) {
		
		boolean isOK = false;
		
		try {
			
			// 댓글 작성 + 게시물 댓글 개수 1 증가
			isOK = boardService.writeComment(commentvo);
			
		} catch (Throwable e) {
			e.printStackTrace();
		}
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("isOK", isOK);
		
		return jsonObj.toString();
	} // end of public String writeComment(CommentVO commentvo) -----------------------
	
	
	// 댓글 목록 불러오기
	@ResponseBody
	@GetMapping(value="commentList.do", produces="text/plain;charset=UTF-8")
	public String commentList(@RequestParam(defaultValue = "") String fk_boardSeq,
							  @RequestParam(defaultValue = "") String currentShowPageNo) {
		
		if("".equals(currentShowPageNo))
			currentShowPageNo = "1";
		
		int countPerPage = 5; // 한 페이지당 보여줄 댓글 수
		
		// offset 추가
		int offset = (Integer.parseInt(currentShowPageNo) - 1) * countPerPage; // 0일 경우: 1페이지, 5일 경우: 2페이지
		
		Map<String, Object> paraMap = new HashMap<>();
		paraMap.put("fk_boardSeq", fk_boardSeq);
		paraMap.put("countPerPage", countPerPage);
		paraMap.put("offset", offset);
		
		List<CommentVO> commentList = boardService.getCommentList(paraMap); // 댓글 목록 조회

		paraMap.put("searchType", "");
		paraMap.put("searchWord", "");
		paraMap.put("boardSeq", fk_boardSeq);
		BoardVO boardvo = boardService.getBoardNoReadCount(paraMap); // 게시글 작성자 아이디를 알기 위함
		
		int totalCount = Integer.parseInt(boardvo.getCommentCount());
		
		JSONArray jsonArr = new JSONArray();
		
		if(commentList != null) {
			
			for(CommentVO comment : commentList) {
				
				JSONObject jsonObj = new JSONObject();
				
				jsonObj.put("commentSeq", comment.getCommentSeq());
				jsonObj.put("fk_userid", comment.getFk_userid());
				jsonObj.put("name", comment.getName());
				jsonObj.put("content", comment.getContent());
				jsonObj.put("regDate", comment.getRegDate());
				jsonObj.put("fk_boardSeq", comment.getFk_boardSeq());
				jsonObj.put("status", comment.getStatus());
				jsonObj.put("groupno", comment.getGroupno());
				jsonObj.put("fk_seq", comment.getFk_seq());
				jsonObj.put("depthno", comment.getDepthno());
				
				jsonObj.put("totalCount", totalCount);
				jsonObj.put("countPerPage", countPerPage);
				jsonObj.put("board_id", boardvo.getFk_userid()); // 게시글 작성자와 댓글 작성자가 일치한지 확인하기 위함
				
				jsonArr.put(jsonObj);
			}
		}
		
		return jsonArr.toString();
		
	} // end of public String commentList(@RequestParam(defaultValue = "") String fk_boardSeq, @RequestParam(defaultValue = "") String currentShowPageNo) -------
	
	
	// 댓글 수정 처리
	@ResponseBody
	@PostMapping(value="editComment.do", produces="text/plain;charset=UTF-8")
	public String editComment(CommentVO commentvo, HttpServletRequest request) {
		
		HttpSession session = request.getSession();
		MemberVO loginUser = (MemberVO)session.getAttribute("loginUser");

		int n = 0;
		
		if(loginUser != null && loginUser.getUserid().equals(commentvo.getFk_userid())) {
			n = boardService.editComment(commentvo);
		}
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("n", n);
		
		return jsonObj.toString();
		
	} // end of public String editComment(CommentVO commentvo, HttpServletRequest request) -----------------
	
	
	// 댓글 삭제 처리
	@ResponseBody
	@PostMapping(value="deleteComment.do", produces="text/plain;charset=UTF-8")
	public String deleteComment(@RequestParam(defaultValue = "") String commentSeq,
								@RequestParam(defaultValue = "") String boardSeq) {
		
		boolean isOK = false;
		
		try {
			// 댓글 삭제 + 게시판 테이블 댓글 개수 1 감소
			isOK = boardService.deleteComment(commentSeq, boardSeq);
			
		} catch (Throwable e) {
			e.printStackTrace();
		}
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("isOK", isOK);
		
		return jsonObj.toString();
		
	} // end of public String deleteComment(@RequestParam(defaultValue = "") String commentSeq,	@RequestParam(defaultValue = "") String boardSeq) ------
	
	
	// 글 삭제 처리
	@ResponseBody
	@PostMapping(value="delete.do", produces="text/plain;charset=UTF-8")
	public String deleteBoard(HttpServletRequest request, @RequestParam String fk_userid,
														  @RequestParam String boardSeq) {
		
		boolean isOK = false;
		boolean allCommentsDeleted = true;
		boolean allImagesDeleted = true;
		int boardDeleted = 0;
		
		HttpSession session = request.getSession();
		MemberVO loginUser = (MemberVO)session.getAttribute("loginUser");
		
		try {
			if(loginUser != null && (loginUser.getUserid().equals(fk_userid) || "0".equals(loginUser.getStatus()))) {
				
				// 글번호에 대한 댓글목록 불러오기
				List<CommentVO> commentList = boardService.getCommentListNoPaging(boardSeq);
				
				// 댓글이 있으면 댓글 삭제 (status를 0으로 update)
				if(commentList != null) {
					for(CommentVO comment : commentList) {
						boolean deleted = boardService.deleteComment(comment.getCommentSeq(), boardSeq);
//						System.out.println("댓글번호 " + comment.getCommentSeq() + " 삭제 => " + deleted);
						
						if(!deleted) {
							allCommentsDeleted = false;
							break;
						}
					}
				}
				
				// 글번호에 대한 첨부파일 목록 불러오기
				List<Map<String, String>> boardImgList = boardService.getBoardImgList(boardSeq);
				
				// 사진이 있으면 사진 삭제
				if(boardImgList != null) {
					String root = session.getServletContext().getRealPath("/");
					String path = root + "resources" + File.separator + "images" + File.separator + "board";
					
					for(Map<String, String> boardImgMap : boardImgList) {
						
						fileManager.deleteFile(boardImgMap.get("filename"), path); // 서버에 올라간 사진 삭제
						
						int imgDeleted = boardService.deleteBoardImg(boardImgMap.get("imgSeq")); // DB에서 삭제
//						System.out.println("이미지 " + boardImgMap.get("filename") + " 삭제 => " + imgDeleted);
						
						if(imgDeleted != 1) {
							allImagesDeleted = false;
							break;
						}
					}
				}
				
				// 글 삭제
				boardDeleted = boardService.deleteBoard(boardSeq);
			}
			
			// 댓글, 첨부파일, 글 삭제가 모두 완료되었다면
			if(allCommentsDeleted && allImagesDeleted && boardDeleted==1) {
				
				isOK = true;
			}
			
		} catch (Throwable e) {
			e.printStackTrace();
		}
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("isOK", isOK);
		
		return jsonObj.toString();
		
	} // end of public String deleteBoard(HttpServletRequest request, @RequestParam String fk_userid, @RequestParam String boardSeq) ---------
	
}
