<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<% String ctxPath = request.getContextPath(); %>

<style type="text/css">

	@media screen and (max-width: 768px) {
	    div.infoContainer {
	        width: 100% !important;
	    }
	    
	    span#editDelBtn {
	    	position: relative;
	    }
	    
	    div.editDelDiv {
	    	position: absolute;
			width: 110px !important;
			margin-left: 20% !important;
	    }
	    
	    div#commentBtn {
	    	width: 120px !important;
	    }
	    
	    button.replyBtn {
	    	width: 45px !important;
	    }
	}
	
	div.container {
		border: solid 0px black;
		margin: 5% auto;
	}
	
	div.infoContainer {
		border: solid 0px red;
		width: 70%;
		margin: 0 auto;
	}
	
	div.titleDiv {
		border-bottom: solid 1px #d9d9d9;
		padding: 5% 0 7% 0;
	}
	
	div.titleDiv h4 {
		margin-bottom: 2%;
	}
	
	span#regDate,
	span#readCount {
		color: #999;
		font-size: 0.9em;
	}
	
	span#editDelBtn {
		border: solid 0px red;
		padding: 0.5% 0;
		padding-left: 1.5%;
		position: relative;
	}
	
	span#editDelBtn:hover,
	div#commentBtn:hover,
	div.commentOptionBtn:hover,
	div.commentOption span:hover {
		cursor: pointer;
	}
	
	div.editDelDiv {
		border: solid 1px #d9d9d9;
		border-radius: 10px;
		background-color: #fff;
		overflow: hidden;
	    display: flex;
	    flex-direction: column; /* 세로 방향으로 정렬 */
	    position: absolute;
	    margin-top: 0.5%;
	    margin-left: 14.3%;
	    width: 6%;
	    height: 85px;
	}
	
	a#editBtn,
	a#delBtn {
		width: 100%;
		padding: 7% 0;
		text-decoration: none;
	}
	
	div.contentDiv {
		padding: 7% 0;
		border-bottom: solid 1px #d9d9d9;
	}
	
	div.imgDiv img {
		width: 100%;
		margin: 2% auto;
	}
	
	div.commentDiv {
		margin: 7% 0;
	}
	
	div.BtnDiv {
		border: solid 0px blue;
		margin-bottom: 3%;
	}
	
	div#commentBtn {
		width: 16%;
		height: 40px;
		padding: 0 1%;
	}
	
	div#commentBtn:hover {
		cursor: pointer;
	}
	
	.commentToggleDown {
		border: solid 1px #999;
		color: #808080;
	}
	
	.commentToggleUp {
		border: solid 1px #0066ff;
		color: #0066ff;
	}
	
	div.comment {
		border-bottom: solid 1px #d9d9d9;
		padding: 3% 0;
	}
	
	i.fa-arrow-turn-up {
		transform: rotate(90deg);
	}
	
	span.cmt_name {
		font-weight: bold;
	}
	
	span.cmt_boardName {
		border: solid 1px #0066ff;
		border-radius: 15px;
		font-size: 0.8em;
		padding: 1px 4px;
		width: 7%;
		color: #0066ff;
	}
	
	div.cmt_content {
		margin: 2% 0 1% 0;
	}
	
	div.cmt_regDate {
		font-size: 0.8em;
		color: #999;
	}
	
	button.replyBtn {
		border: solid 1px #737373;
		border-radius: 10px;
		color: #737373;
		width: 5.5%;
		font-size: 0.9em;
		padding: 3px 2px;
		margin-top: 2%;
	}
	
	div.commentOption {
		border: solid 1px #d9d9d9;
		position: absolute;
		display: flex;
	    flex-direction: column;
	    right: 0;
	    top: 100%;
	    z-index: 10;
	    background-color: #fff;
	    border-radius: 5px;
	}
	
	div.commentOption span {
		width: 100%;
		padding: 3px 5px;
	}
	
	div#commentPageBar {
		margin: 3% 0 5% 0;
	}
	
	div#commentPageBar ul {
		border: solid 0px orange;
		list-style: none;
		width: 70%;
		margin: 0 auto;
		text-align: center;
		padding: 0;
	}
	
	div#commentPageBar li {
		border: solid 0px purple;
		display: inline-block;
		text-align: center;
		margin: 0 1%;
	}
	
	div#commentPageBar a {
		text-decoration: none;
		color: #666;
	}
	
	div#commentPageBar a:hover {
		font-weight: bold;
	}
	
	div#writeCommentDiv {
		border: solid 1px #bfbfbf;
		display: flex;
		flex-direction: column;
		padding: 1.5%;
	}
	
	input,
	textarea {
		border: none;
		resize: none;
	}
	
	input:focus,
	textarea:focus {
		outline: none;
	}
	
	button#writeCommentBtn,
	button#editCommentBtn,
	button#writeReplyBtn {
		border: solid 1px #737373;
		border-radius: 10px;
		color: #737373;
		padding: 0.5% 1%;
	}
	
	div.writeReply-area {
		border: solid 0px red;
		padding-top: 2%;
	}
	
	div#writeReplyDiv {
		border: solid 1px #bfbfbf;
		background-color: #f2f2f2;
		display: flex;
		flex-direction: column;
		padding: 1.5%;
		width: 95%;
	}
	
	div#writeReplyDiv input,
	div#writeReplyDiv textarea {
		background-color: transparent;
	}
	
	textarea#goLogin:hover {	
		cursor: pointer;
	}
	
	div#prevNextBoardDiv {
		margin-bottom: 7%;
	}
	
	div#prevBoard > span:first-child,
	div#nextBoard > span:first-child {
		border: solid 0px skyblue;
		padding-right: 2%;
	}
	
	span#prevSubject:hover,
	span#nextSubject:hover {
		cursor: pointer;
		color: #808080;
	}
</style>

<script type="text/javascript">
	$(document).ready(function() {
		
		// 댓글 목록 불러오기
		getCommentList(1);
		
		$("div.editDelDiv").hide();
		$("div.commentToggleDiv").hide();
		$("div.commentOption").hide();
		
		<%-- 댓글 토글 버튼 (댓글창 보이기/숨기기) --%>
		$("div#commentBtn").on("click", function() {
			$("div.commentToggleDiv").toggle();
			
			if ($("div.commentToggleDiv").is(":visible")) {
                $(this).removeClass("commentToggleDown");
                $(this).addClass("commentToggleUp");
                
                $("div#commentBtn > i").removeClass("fa-angle-down");
	            $("div#commentBtn > i").addClass("fa-angle-up");
            } else {
                $(this).removeClass("commentToggleUp");
                $(this).addClass("commentToggleDown");
                
                $("div#commentBtn > i").removeClass("fa-angle-up");
	            $("div#commentBtn > i").addClass("fa-angle-down");
            }
		});
		
		<%-- 글 상세 옵션 토글 버튼 (글 수정/삭제) --%>
		$(document).on("click", "span#editDelBtn", function(e) {
			e.stopPropagation(); // 이벤트 버블링 방지
        	$("div.editDelDiv").toggle();
		});
		
		<%-- 댓글 옵션 토글 버튼 (댓글 수정/삭제) --%>
		$(document).on("click", "div.commentOptionBtn", function(e) {
			e.stopPropagation(); // 이벤트 버블링 방지
        	$(this).next("div.commentOption").toggle();
		});
		
		<%-- 글 수정/삭제, 댓글 수정/삭제 메뉴 외부 클릭 시 숨기기 --%>
		$(document).click(function() {
			$("div.editDelDiv").hide();
	        $("div.commentOption").hide();
	    });
		
		<%-- 메뉴 내부를 클릭하면 메뉴가 닫히지 않도록 --%>
	    $("div.editDelDiv").click(function(e) {
	        e.stopPropagation();
	    });
	    $("div.commentOption").click(function(e) {
	        e.stopPropagation();
	    });
	    
	    <%-- 댓글 작성창에서 엔터 눌렀을 때 등록 함수 호출 --%>
	    $("textarea#cmtWriteContent").keydown(function(e) {
	    	if(e.keyCode == 13) {
	    		e.preventDefault();
	    		goWriteComment();
	    	}
	    });
	    
	    
	    // 댓글에서 '답글' 버튼을 누를 경우 답글 작성창 띄우기
	    $(document).on("click", "button.replyBtn", function() {
	    	
	    	if(${empty sessionScope.loginUser}) {
	    		alert("답글 작성은 로그인 후 이용해 주세요.");
				return;	    		
	    	}
	    	
	    	const writeReplyDiv = $(this).closest("div.comment").find("div.writeReplyDiv");
			
	    	
	    	if(writeReplyDiv.find("form[name='writeReplyFrm']").length > 0) { // 답글이 열려있는 상태일 때 버튼을 누르면 닫기
	    		writeReplyDiv.empty();
	    	
	    	} else {
	    		
	    		// 기존에 열려있는 답글 작성창이 있으면 제거
		        $("form[name='writeReplyFrm']").remove();
	    		
		    	const replyForm = `
		    		<form name="writeReplyFrm">
						<div class="writeReply-area d-flex justify-content-between">
							<span style="padding: 0 1%;"><i class="fa-solid fa-arrow-turn-up"></i></span>
								<div id="writeReplyDiv">
								<span>
									<input type="hidden" name="fk_userid" value="${sessionScope.loginUser.userid}" readonly>
									<input type="text" name="name" class="font-weight-bold" value="${sessionScope.loginUser.name}" readonly>
								</span>
								<textarea style="margin:1% 0;" rows="4" maxlength="1000" id="reply_content" name="content" placeholder="답글을 작성해 주세요."></textarea>
								<input type="hidden" name="fk_boardSeq" value="${requestScope.board.boardSeq}" readonly>
								<input type="hidden" name="groupno">
								<input type="hidden" name="fk_seq">
								<input type="hidden" name="depthno">
								<div style="text-align: right; margin-top: 2%;">
									<button id="writeReplyBtn" type="button" class="btn" onclick="goWriteReply(this)">등록</button>
								</div>
							</div>
						</div>
					</form>`;
					
				writeReplyDiv.html(replyForm);
				$("textarea#reply_content").focus();
	    	}
	    	
	    });
	    
	    
		// 답댓글 작성창에서 엔터를 눌렀을 경우 답댓글 작성 함수 호출
		$(document).on("keydown", "textarea#reply_content", function(e) {
			if(e.keyCode == 13) {
				e.preventDefault();
				
				const button = $(e.target).closest("div.writeReply-area").find("button#writeReplyBtn");
				goWriteReply(button);
			}
		});
		
		
		// 댓글 수정 버튼을 눌렀을 경우
		$(document).on("click", "span#editComment", function() {
			
			const commentAreaDiv = $(this).parent().parent().parent().parent();
			const originalHtml = commentAreaDiv.html(); // 댓글의 원래 html을 저장
			
			const commentSeq = commentAreaDiv.find("input#cmt_seq").val();
			const orgContent = commentAreaDiv.find("div.cmt_content").text();
			
			let v_html = `
				<div style="width: 100%;">
					<form name="editCommentFrm">
						<div class="d-block" style="border: solid 1px #808080; padding: 1.5%;">
							<div class="d-flex justify-content-between">
								<input type="hidden" name="commentSeq" value="\${commentSeq}" readonly>
								<input type="hidden" name="fk_userid" value="${sessionScope.loginUser.userid}" readonly>
								<input type="text" name="name" class="font-weight-bold" value="${sessionScope.loginUser.name}" style="border: none;" readonly>
								<button id="cancelEditCommentBtn" type="button" class="btn" style="padding: 0;">취소</button>
							</div>
							<textarea style="width: 100%; margin:1% 0; border: none;" rows="4" maxlength="1000" name="content" id="new_content" placeholder="댓글을 작성해 주세요.">\${orgContent}</textarea>
							<input type="hidden" name="fk_boardSeq" value="${requestScope.board.boardSeq}" readonly>
							<div style="text-align: right;">
								<button id="editCommentBtn" type="button" class="btn">수정</button>
							</div>
						</div>
					</form>
				</div>`;
			
			commentAreaDiv.html(v_html);
			
			// 댓글 수정창의 커서를 맨 끝으로 이동
			setTimeout(function() {
				const textarea = $("textarea#new_content");
				textarea.focus();
				const val = textarea.val();
				textarea.val("").val(val);
			}, 0);
			
			
			// 취소 버튼을 누를 경우
			$(document).on("click", "button#cancelEditCommentBtn", function() {
				commentAreaDiv.html(originalHtml);
			});
			
			
			// 댓글 수정창에서 엔터를 누를 경우 댓글 수정하기
			$(document).on("keydown", "textarea#new_content", function(e) {
				if(e.keyCode == 13) {
					e.preventDefault();
					$("button#editCommentBtn").click();
				}
			});
			
			
			// 댓글 수정하기
			$(document).on("click", "button#editCommentBtn", function() {
				
				const new_content = $("textarea#new_content").val().trim();
				
				if(new_content == "") {
					alert("댓글을 입력해 주세요.");
					return;
				}
				
				const queryString = $("form[name='editCommentFrm']").serialize();
				
				$.ajax({
					url: "editComment.do",
					type: "post",
					data: queryString,
					dataType: "json",
					success: function(json) {
						if(json.n == 1) {
							
							// 현재 수정한 댓글이 있는 페이지 보여주기
							const currentShowPageNo = commentAreaDiv.parent().find("input.currentShowPageNo").val();
//							console.log("currentShowPageNo : " + currentShowPageNo);

							getCommentList(currentShowPageNo);
							
						} else {
							alert("댓글 수정 중 오류가 발생했습니다.");
						}
					},
					error: function(request, status, error) {
		                alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
		            }
				});
				
			});
			
		}); // end of $(document).on("click", "span#editComment", function() {}) --------------------------
		
		
		// 댓글 삭제
		$(document).on("click", "span#delComment", function() {
			
			const commentSeq = $(this).parent().parent().find("input#cmt_seq").val();
//			console.log("commentSeq : " + commentSeq + ", boardSeq : ${requestScope.board.boardSeq}");
			
			if(confirm("댓글을 삭제하시겠습니까?")) {
 				$.ajax({
					url: "deleteComment.do",
					type: "post",
					data: {"commentSeq": commentSeq,
						   "boardSeq": "${requestScope.board.boardSeq}"},
					dataType: "json",
					success: function(json) {
						if(json.isOK) {
							
							// 댓글 개수 업데이트
			                updateCommentCount(-1);
			                
			                getCommentList(1);
			                
						} else {
							alert("댓글 삭제 중 오류가 발생했습니다.");
						}
					},
					error: function(request, status, error) {
		                alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
		            }
				});
			}
			
		});
		
		
		// 로그인을 하지 않았을 경우 댓글창 클릭 시
		$("textarea#goLogin").on("click", function() {
			$.ajax({
				url: "<%=ctxPath%>/board/saveGoBackURL.do",
				type: "post",
				data: {"boardSeq":"${requestScope.board.boardSeq}"},
				dataType: "json",
				success: function(json) {
					if(json.goBackURL != null) {
						location.href = "<%=ctxPath%>/member/login.do";
					}
				},
				error: function(request, status, error) {
	                alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
	            }
			});
		});
		
	}); // end of $(document).ready(function() {}) ---------------------------------
	
	
	// ==== 게시글 삭제 ====
	function goDeleteBoard() {
		if(confirm("게시글을 삭제하시겠습니까?")) {
			
			$.ajax({
				url: "delete.do",
				type: "post",
				data: {
					"fk_userid": "${requestScope.board.fk_userid}",
					"boardSeq": "${requestScope.board.boardSeq}"
				},
				dataType: "json",
				success: function(json) {
					if(json.isOK) {
						location.href = "<%=ctxPath%>/board/list.do";
						
					} else {
						alert("글 삭제 중 오류가 발생하였습니다.");
					}
				},
				error: function(request, status, error) {
	                alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
	            }
			});
		}
	} // end of function goDeleteBoard() ----------------------------
	
	
	// ==== 댓글 작성 ====
	function goWriteComment() {
		
		const content = $("textarea#cmtWriteContent").val().trim();
		
		if(content == "") {
			alert("댓글을 입력해 주세요.");
			$("textarea#cmtWriteContent").val("").focus();
			return;
		}
		
		const queryString = $("form[name='writeCommentFrm']").serialize();
		
		$.ajax({
			url: "writeComment.do",
			type: "post",
			data: queryString,
			dataType: "json",
			success: function(json) {
				if(json.isOK) {
					
					// 댓글 개수 업데이트
					updateCommentCount(1);

	                // 댓글 입력란 초기화
	                $("textarea#cmtWriteContent").val("");
	                
	                getCommentList(1);
	                
				} else {
					alert("댓글 등록 실패");
				}
			},
			error: function(request, status, error) {
                alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
            }
		});
	} // end of function goWriteComment() ----------------------------
	
	
	// ==== 댓글 목록 ====
	function getCommentList(currentShowPageNo) {
		$.ajax({
			url: "commentList.do",
			data: {
				"fk_boardSeq": "${requestScope.board.boardSeq}",
				"currentShowPageNo": currentShowPageNo
			},
			dataType: "json",
			success: function(json) {
				
				let v_html = ``;
				
				if(json.length > 0) {
//					console.log(JSON.stringify(json));
					
					$.each(json, function(index, item) {
						
						
						const isAuthor = item.fk_userid == item.board_id; // 게시글 작성자와 댓글 작성자가 같은지
						const isCurrentUser = ${sessionScope.loginUser != null} && ("${sessionScope.loginUser.userid}" == item.fk_userid); // 댓글 작성자와 현재 로그인한 사용자가 같은지
						const isAdmin = ${sessionScope.loginUser != null} && ("${sessionScope.loginUser.status}" == 0);
						const widthStyle = item.depthno > 0 ? '95%' : '100%';
						const isReply = item.depthno > 0; // 답글일 경우 
						
						if(item.status == 0) {

								let hasChild = json.some(innerItem => innerItem.fk_seq == item.commentSeq);
								
								if(hasChild) { // 자식 댓글이 있으면 '삭제된 댓글입니다.'로 표시
									v_html += `
										<div id="comment\${index}" class="comment">
										<div class="comment-area d-flex justify-content-between">
											<div style="width: \${widthStyle};">
												<div class="cmt_content">삭제된 댓글입니다.</div>
												<div class="cmt_regDate">\${item.regDate}</div>
											</div>
										</div>
										<input type="hidden" value="\${currentShowPageNo}" class="currentShowPageNo">
										<input type="hidden" value="\${item.groupno}" name="groupno">
										<input type="hidden" value="\${item.depthno}" name="depthno">
									</div>`;
								}
							
						} else {
							
							v_html += `
								<div id="comment\${index}" class="comment">
									<div class="comment-area d-flex justify-content-between">
										\${isReply ? `<span style="padding: 0 1%;"><i class="fa-solid fa-arrow-turn-up"></i></span>` : ""} <%-- 답글일 경우 화살표 표시 --%>
										<div style="width: \${widthStyle};">
											<div class="d-flex justify-content-between align-items-center position-relative">
												<div style="width: 50%;">
													<span class="cmt_name">\${item.name}</span>
													
													\${isAuthor ? `<span class="cmt_boardName ml-1">작성자</span>` : ''}
													
							 					</div>
												<input type="hidden" id="cmt_seq" value="\${item.commentSeq}">
												<input type="hidden" id="cmt_userid" value="\${item.fk_userid}">
												
											\${isCurrentUser ? `
												<div class="commentOptionBtn">
													<i class="fa-solid fa-ellipsis-vertical"></i>
												</div>
												<div class="commentOption">
													<span id="editComment" style="border-bottom: solid 1px #f2f2f2;">수정</span>
													<span id="delComment" style="color: #ff4d4d;">삭제</span>
												</div>
											` : ``}
											
											\${isAdmin ? `
												<div class="commentOptionBtn">
													<i class="fa-solid fa-ellipsis-vertical"></i>
												</div>
												<div class="commentOption">
													<span id="delComment" style="color: #ff4d4d;">삭제</span>
												</div>
											` : ``}
											
											</div>
											<div class="cmt_content">\${item.content}</div>
											<div class="cmt_regDate">\${item.regDate}</div>
											<%-- <button type="button" class="btn replyBtn">답글</button> --%>
											\${!isReply ? `<button type="button" class="btn replyBtn">답글</button>` : ""} <%-- 답글이 아닐 경우(최상위 댓글일 경우)에만 '답글' 버튼 표시 --%>
										</div>
									</div>
									<input type="hidden" value="\${currentShowPageNo}" class="currentShowPageNo">
									<input type="hidden" value="\${item.groupno}" name="groupno">
									<input type="hidden" value="\${item.depthno}" name="depthno">
									<div class="writeReplyDiv"></div>
								</div>`;
						
							
						}
						
					}); // end of $.each() ------------------
					
					$("div.commentContentDiv").html(v_html);
					$("div.commentOption").hide();
					
					const totalPage = Math.ceil(json[0].totalCount / json[0].countPerPage);
					
					createCommentPageBar(currentShowPageNo, totalPage);
					
				}
			},
			error: function(request, status, error) {
				
				if(request.status == 404) {
					location.href = "list.do";
					
				} else {
	                alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
				}
            }
		});
	} // end of function getCommentList(currentShowPageNo) --------------------------
		
	
	// 댓글 페이지바 만들기
	function createCommentPageBar(currentShowPageNo, totalPage) {
		
		const blockSize = 5;
		
		let loop = 1;
		
		let pageNo = Math.floor((currentShowPageNo - 1) / blockSize) * blockSize + 1;
		
		let pageBar_html = "<ul>";
		
		// [맨처음][이전] 만들기
		if(pageNo != 1) {
			pageBar_html += `<li style="font-size: 0.8em;"><a href="javascript:getCommentList(1)">◀◀</a></li>`;
			pageBar_html += `<li style="font-size: 0.8em;"><a href="javascript:getCommentList(` + (pageNo - 1) + `)">◀</a></li>`;
		}
		
		while(!(loop > blockSize || pageNo > totalPage)) {
			if(pageNo == currentShowPageNo) {
				pageBar_html += `<li style="color: #0066ff; font-weight: bold;">` + pageNo + `</li>`;
				
			} else {
				pageBar_html += `<li><a href="javascript:getCommentList(` + pageNo + `)">` + pageNo + `</a></li>`;
			}
			
			loop++;
			pageNo++;
		} // end of while() ------------------------------
		
		// [다음][마지막] 만들기
		if(pageNo <= totalPage) {
			pageBar_html += `<li style="font-size: 0.8em;"><a href="javascript:getCommentList(` + pageNo + `)">▶</a></li>`;
			pageBar_html += `<li style="font-size: 0.8em;"><a href="javascript:getCommentList(` + totalPage + `)">▶▶</a></li>`;
		}
		
		pageBar_html += "</ul>";
		
		$("div#commentPageBar").html(pageBar_html);
	} // end of function createCommentPageBar(currentShowPageNo, totalPage) --------------------
	
	
	// 답댓글 작성
	function goWriteReply(button) {
		
		const content = $("textarea#reply_content").val().trim();
		
		if(content == "") {
			alert("답글을 입력해 주세요.");
			$("textarea#reply_content").val("").focus();
			return;
		}
		
		const groupno = $(button).closest("div.comment").find("input[name=groupno]").val(); // 그룹번호 (원댓글과 답댓글은 같은 그룹번호를 가짐)
		const fk_seq = $(button).closest("div.comment").find("input#cmt_seq").val(); // 원댓글 번호
		const depthno = $(button).closest("div.comment").find("input[name=depthno]").val(); // 원댓글:0, 답댓글:원댓글의 depthno+1
		const currentShowPageNo = $(button).closest("div.comment").find("input.currentShowPageNo").val(); // 현재 페이지 번호
		
//		console.log("groupno : " + groupno + ", fk_seq : " + fk_seq + ", depthno : " + depthno + ", currentShowPageNo : " + currentShowPageNo);
		
		const frm = document.writeReplyFrm;
		frm.groupno.value = groupno;
		frm.fk_seq.value = fk_seq;
		frm.depthno.value = depthno;
		
		const queryString = $("form[name='writeReplyFrm']").serialize();
		
  		$.ajax({
			url: "writeComment.do",
			type: "post",
			data: queryString,
			dataType: "json",
			success: function(json) {
				if(json.isOK) {

					// 댓글 개수 업데이트
	                updateCommentCount(1);
					
	                getCommentList(currentShowPageNo);
				}
			},
			error: function(request, status, error) {
                alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
            }
		});
	} // end of function goWriteReply(button) ---------------------------
	
	
	// 댓글 개수 업데이트
	function updateCommentCount(count) {
		
		let currentCount = parseInt($("span#commentCount").text().match(/\d+/)) || 0; // 현재 댓글 수
		let newCount = currentCount + count;
		
		if (newCount <= 0) {
	        $("span#commentCount").text("댓글 쓰기"); // 댓글 수가 0 이하일 때
	        history.go(0);
	        
	    } else {
	        $("span#commentCount").text("댓글 " + newCount); // 댓글 수 업데이트
	    }
	} // end of function updateCommentCount(count) -------------------
	
	
	<%-- 이전글, 다음글 보기 클릭 시 --%>
	function goDetail(boardSeq) {

		const goBackURL = "${requestScope.goBackURL}";
		
		const frm = document.goDetailFrm;
		
		frm.boardSeq.value = boardSeq;
		frm.goBackURL.value = goBackURL;
		
		if(${not empty requestScope.paraMap}) { // 검색 조건이 있을 경우
			frm.searchType.value = "${requestScope.paraMap.searchType}";
			frm.searchWord.value = "${requestScope.paraMap.searchWord}";
		}
		
		frm.method = "post";
		frm.action = "<%=ctxPath%>/board/detail2.do";
		frm.submit();
	} // end of function goDetail(boardSeq) --------------------
	
</script>

<div class="container">
	<div class="infoContainer">
		<%-- ===== 상단 ===== --%>
		<div class="titleDiv">
			<h4 id="subject">${requestScope.board.subject}</h4>
			<div class="d-flex justify-content-between">
				<div style="width: 50%;">
					<span id="name">${requestScope.board.name}</span>
					<span style="margin: 0 1%;">·</span>
					<span id="regDate">${requestScope.board.regDate}</span>
				</div>
				<div class="text-right" style="width: 50%;">
					<span id="readCount">조회 ${requestScope.board.readCount}</span>
					<%-- 본인이 쓴 글만 수정/삭제할 수 있도록 --%>
					<c:if test="${not empty sessionScope.loginUser && sessionScope.loginUser.userid == requestScope.board.fk_userid}">
						<span id="editDelBtn" class="ml-3"><i class="fa-solid fa-ellipsis-vertical"></i></span>
						<div class="editDelDiv text-center">
							<a id="editBtn" href="<%=ctxPath%>/board/edit.do?boardSeq=${requestScope.board.boardSeq}" style="border-bottom: solid 1px #f2f2f2; color: #333;">수정하기 <i class="fa-solid fa-pen ml-2"></i></a>
							<a id="delBtn" href="javascript:goDeleteBoard()" style="color: #ff4d4d;">삭제하기 <i class="fa-solid fa-trash-can ml-2"></i></a>
						</div>
					</c:if>
					<c:if test="${not empty sessionScope.loginUser && sessionScope.loginUser.status == 0}">
						<span id="editDelBtn" class="ml-3"><i class="fa-solid fa-ellipsis-vertical"></i></span>
						<div class="editDelDiv text-center" style="height: 42px;">
							<a id="delBtn" href="javascript:goDeleteBoard()" style="color: #ff4d4d;">삭제하기 <i class="fa-solid fa-trash-can ml-2"></i></a>
						</div>
					</c:if>
				</div>
			</div>
		</div>
		
		<%-- ===== 내용 ===== --%>
		<div class="contentDiv">
			<div id="content">
				${requestScope.board.content}
			</div>
			<c:if test="${not empty requestScope.boardImgList}">
				<div class="imgDiv">
					<c:forEach var="image" items="${requestScope.boardImgList}">
						<img src="<%=ctxPath%>/resources/images/board/${image.filename}" alt="boardImg">
					</c:forEach>
				</div>
			</c:if>
		</div>
		
		<%-- ===== 댓글 ===== --%>
		<div class="commentDiv">
			<div class="BtnDiv">
				<div id="commentBtn" class="commentToggleDown d-flex align-items-center justify-content-between">
					<div>
						<i class="fa-solid fa-comment-dots"></i>
						<c:if test="${requestScope.board.commentCount == 0}">
							<span id="commentCount">댓글 쓰기</span>
						</c:if>
						<c:if test="${requestScope.board.commentCount > 0}">
							<span id="commentCount">댓글 ${requestScope.board.commentCount}</span>
						</c:if>
					</div>
					<i class="fa-solid fa-angle-down"></i>
				</div>
			</div>
			<div class="commentToggleDiv">
				<div class="commentContentDiv">
				
					<%-- 댓글 반복 --%>
					
					<%--
					
					<div class="comment">
						<!-- ===== 댓글 수정 ===== -->
						<div class="comment-area">
							<form name="editCommentFrm">
								<div class="d-block" style="border: solid 1px #808080; padding: 1.5%;">
									<div class="d-flex justify-content-between">
										<input type="hidden" name="fk_userid" value="${sessionScope.loginUser.userid}" readonly>
										<input type="text" name="name" class="font-weight-bold" value="${sessionScope.loginUser.name}" style="border: none;" readonly>
										<button id="cancelEditCommentBtn" type="button" class="btn" style="padding: 0;">취소</button>
									</div>
									<textarea style="width: 100%; margin:1% 0; border: none;" rows="4" maxlength="1000" name="content" placeholder="댓글을 작성해 주세요."></textarea>
									<input type="hidden" name="fk_boardSeq" value="${requestScope.board.boardSeq}" readonly>
									<div style="text-align: right;">
										<button id="editCommentBtn" type="button" class="btn">수정</button>
									</div>
								</div>
							</form>
						</div>
					</div>
					
					<div class="comment">
						<!-- 댓글일 경우 -->
						<div class="comment-area">
							<div class="d-flex justify-content-between align-items-center position-relative">
								<div style="width: 50%;">
									<span class="cmt_name">김다영</span>
									<span class="cmt_boardName ml-1">작성자</span>
								</div>
								<div class="commentOptionBtn">
									<i class="fa-solid fa-ellipsis-vertical"></i>
								</div>
								<div class="commentOption">
									<span style="border-bottom: solid 1px #f2f2f2;">수정</span>
									<span style="color: #ff4d4d;">삭제</span>
								</div>
							</div>
							<div class="cmt_content">포스팅 잘 봤습니다.</div>
							<div class="cmt_regDate">2025-03-17 12:55</div>
							<button type="button" class="btn replyBtn">답글</button>
						</div>
					</div>
					
					<div class="comment">
						<!-- 댓글일 경우 -->
						<div class="comment-area">
							<div class="d-flex justify-content-between align-items-center position-relative">
								<div style="width: 50%;">
									<span class="cmt_name">김다영</span>
									<span class="cmt_boardName ml-1">작성자</span>
								</div>
								<div class="commentOptionBtn">
									<i class="fa-solid fa-ellipsis-vertical"></i>
								</div>
								<div class="commentOption">
									<span style="border-bottom: solid 1px #f2f2f2;">수정</span>
									<span style="color: #ff4d4d;">삭제</span>
								</div>
							</div>
							<div class="cmt_content">포스팅 잘 봤습니다.</div>
							<div class="cmt_regDate">2025-03-17 12:55</div>
							<button type="button" class="btn replyBtn">답글</button>
						</div>
						<!-- 답글 작성 화면 -->
						<form name="writeReplyFrm">
							<div class="writeReply-area d-flex justify-content-between">
								<span style="padding: 0 1%;"><i class="fa-solid fa-arrow-turn-up"></i></span>
									<div id="writeReplyDiv">
									<span>
										<input type="hidden" name="fk_userid" value="" readonly>
										<input type="text" name="name" class="font-weight-bold" value="김다영" readonly>
									</span>
									<textarea style="margin:1% 0;" rows="4" maxlength="1000" name="content" placeholder="답글을 작성해 주세요."></textarea>
									<input type="hidden" name="fk_boardSeq" value="${requestScope.board.boardSeq}" readonly>
									<input type="hidden" name="groupno">
									<input type="hidden" name="fk_seq">
									<input type="hidden" name="depthno">
									<div style="text-align: right; margin-top: 2%;">
										<button id="writeCommentBtn" type="button" class="btn">등록</button>
									</div>
								</div>
							</div>
						</form>
					</div>
					
					<div class="comment">
						<!-- 답댓글일 경우 -->
						<div class="reply-area d-flex justify-content-between">
							<span style="padding: 0 1%;"><i class="fa-solid fa-arrow-turn-up"></i></span>
							<div style="width: 95%;">
								<div class="d-flex justify-content-between align-items-center position-relative">
									<div style="width: 50%;">
										<span class="cmt_name">김다영</span>
										<span class="cmt_boardName ml-1">작성자</span>
									</div>
									<div class="commentOptionBtn">
										<i class="fa-solid fa-ellipsis-vertical"></i>
									</div>
									<div class="commentOption">
										<span style="border-bottom: solid 1px #f2f2f2;">수정</span>
										<span style="color: #ff4d4d;">삭제</span>
									</div>
								</div>
								<div class="cmt_content">포스팅 잘 봤습니다.</div>
								<div class="cmt_regDate">2025-03-17 12:55</div>
								<button type="button" class="btn replyBtn" style="width: 6%;">답글</button>
							</div>
						</div>
					</div>
					
					<div class="comment">
						<div class="comment-area">
							<div class="d-flex justify-content-between align-items-center position-relative">
								<div style="width: 50%;">
									<span class="cmt_name">김라영</span>
								</div>
								<div class="commentOptionBtn">
									<i class="fa-solid fa-ellipsis-vertical"></i>
								</div>
								<div class="commentOption">
									<span style="border-bottom: solid 1px #f2f2f2;">수정</span>
									<span style="color: #ff4d4d;">삭제</span>
								</div>
							</div>
							<div class="cmt_content">포스팅 잘 봤습니다.</div>
							<div class="cmt_regDate">2025-03-17 12:55</div>
							<button type="button" class="btn replyBtn">답글</button>
						</div>
					</div>
					
					--%>
					
					<%-- 댓글 반복 끝 --%>
				</div>
				
				
				<%-- 댓글 페이지바 --%>
				<div id="commentPageBar"></div>
				
				
				<form name="writeCommentFrm">
					<div id="writeCommentDiv">
						<c:if test="${not empty sessionScope.loginUser}">
							<span>
								<input type="hidden" name="fk_userid" value="${sessionScope.loginUser.userid}" readonly>
								<input type="text" name="name" class="font-weight-bold" value="${sessionScope.loginUser.name}" readonly>
							</span>
							<textarea style="margin:1% 0;" rows="5" maxlength="1000" name="content" id="cmtWriteContent" placeholder="댓글을 작성해 주세요."></textarea>
							<input type="hidden" name="fk_boardSeq" value="${requestScope.board.boardSeq}" readonly>
							<div style="text-align: right; margin-top: 2%;">
								<button id="writeCommentBtn" type="button" class="btn" onclick="goWriteComment()">등록</button>
							</div>
						</c:if>
						<c:if test="${empty sessionScope.loginUser}">
							<textarea id="goLogin" style="margin: 1% 0; resize: none;" rows="5" placeholder="댓글을 작성하려면 로그인하세요." readonly></textarea>
						</c:if>
					</div>
				</form>
			</div>
			
		</div>
		
		<%-- ===== 이전글,다음글 ===== --%>
		<div id="prevNextBoardDiv">
			<div id="prevBoard" class="mb-3">
				<span>이전글</span>
				<c:if test="${not empty requestScope.board.prevSubject}">
					<span id="prevSubject" class="font-weight-bold" onclick="goDetail('${requestScope.board.prevSeq}')">${requestScope.board.prevSubject}</span>
				</c:if>
				<c:if test="${empty requestScope.board.prevSubject}">
					<span style="color: #999;">이전 글이 없습니다.</span>
				</c:if>
			</div>
			<div id="nextBoard">
				<span>다음글</span>
				<c:if test="${not empty requestScope.board.nextSubject}">
					<span id="nextSubject" class="font-weight-bold" onclick="goDetail('${requestScope.board.nextSeq}')">${requestScope.board.nextSubject}</span>
				</c:if>
				<c:if test="${empty requestScope.board.nextSubject}">
					<span style="color: #999;">다음 글이 없습니다.</span>
				</c:if>
			</div>
		</div>
	</div>
	
	<%-- ===== 목록 버튼 ===== --%>
	<div id="listBtnDiv" class="text-center" style="width: 70%; margin: 10% auto 20% auto;">
		<button type="button" class="btn btn-primary mr-5" onclick="location.href='<%=ctxPath%>/board/list.do'">목록으로</button>
		<button type="button" class="btn btn-outline-primary" onclick="location.href='<%=ctxPath%>${requestScope.goBackURL}'">검색된 목록 보기</button>
	</div>
</div>


<%-- 이전글, 다음글 보기 클릭 시 전송할 폼 --%>
<form name="goDetailFrm">
	<input type="hidden" name="boardSeq">
	<input type="hidden" name="goBackURL">
	<input type="hidden" name="searchType">
	<input type="hidden" name="searchWord">
</form>