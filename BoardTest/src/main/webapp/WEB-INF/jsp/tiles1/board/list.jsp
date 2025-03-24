<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<% String ctxPath = request.getContextPath(); %>

<style>
	@media screen and (max-width: 768px) {
	    div.container {
	    	margin: 0 !important;
	    	width: 100vw !important;
	    }
	    
	    div#searchDiv {
	    	margin-top: 5% !important;
	        width: 100vw !important;
	    }
	    
	    div#searchDiv select {
	    	width: 70px;
	    }
	    
	    div.boardContainer {
	    	width: 100vw !important;
	    }
	    
	    div.content {
	    	overflow: hidden;
	    }
	    
	    div#pageBar {
	    	width: 100% !important;
	    	margin: 3% auto !important;
	    }
	    
	    div#pageBar li {
	    	width: 4% !important;
	    }
	}

	div.container {
		border: solid 0px red;
		margin: 5% auto;
	}
	
	div#searchDiv {
		border: solid 0px blue;
		width: 70%;
		margin: 0 auto 3% auto;
	}
	
	select#searchType {
		width: 10%;
		border: solid 1px #a6a6a6;
		border-radius: 5px;
	}
	
	input#searchWord {
		border: solid 1px #a6a6a6;
		border-radius: 5px;
	}
	
	div.boardContainer {
		border-top: solid 1px #ccc;
		width: 70%;
		margin: 0 auto;
	}
	
	div.InfoContainer {
		width: 75%;
	}
	
	div.regDate {
		font-size: 0.8em;
		color: #8c8c8c;
	}
	
	div.readCount {
		color: #8c8c8c;
		font-weight: bold;
		font-size: 0.9em;
	}
	
	div.subject {
		font-size: 1.2rem;
		font-weight: bold;
	}
	
	div.content {
		border: solid 0px blue;
		height: 70px;
		font-size: 0.9em;
		text-align: justify;
		margin: 2% 0;
	}
	
	div.commentCount {
		font-size: 0.9em;
		color: #8c8c8c;
	}
		
	div.imgContainer {
		margin: 2%;
		width: 185px;
	    height: 185px;
	    overflow: hidden;
	    position: relative;
	}
	
	div.imgContainer img {
		width: 100%;
	    height: 100%;
	    object-fit: cover;
	    object-position: center;
	}
	
	div.subject:hover,
	div.content:hover,
	div.imgContainer:hover {
		cursor: pointer;
	}
	
	div#pageBar {
		border: solid 0px blue;
		width: 70%;
		margin: 3% auto;
	}
	
	div#pageBar ul {
		border: solid 0px orange;
		list-style: none;
		text-align: center;
		padding: 0;
	}
	
	div#pageBar > ul li {
		border: solid 0px red;
		display: inline-block;
		text-align: center;
		width: 6%;
	}
	
	div#pageBar > ul li:hover {
		font-weight: bold;
		cursor: pointer;
	}
	
	div#pageBar a {
		text-decoration: none !important;
		color: #666666;
	}
	
</style>

<script type="text/javascript">

	$(document).ready(function() {
		
		$("input#searchWord").keyup(function(e) {
			if(e.keyCode == 13) {
				goSearch();
			}
		});
		
		if(${not empty requestScope.paraMap}) {
			$("select#searchType").val("${requestScope.paraMap.searchType}");
			$("input#searchWord").val("${requestScope.paraMap.searchWord}");
		}
		
	});
	
	function goSearch() {
		
		const searchWord = $("input#searchWord").val().trim();
		
		if(searchWord == "") {
			alert("검색어를 입력해 주세요.");
			$("input#searchWord").focus();
			return;
		}
		
		const frm = document.searchFrm;
		frm.submit();
	}
	
	// 글 상세페이지
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
		frm.action = "<%=ctxPath%>/board/detail.do";
		frm.submit();
	}
	
</script>

<div class="container">

	<form name="searchFrm">
		<div id="searchDiv" class="d-flex">
			<select id="searchType" name="searchType" class="mr-3">
				<option value="subject" selected>글제목</option>
				<option value="content">글내용</option>
				<option value="name">작성자</option>
			</select>
			<input type="text" name="searchWord" id="searchWord" class="mr-3" maxlength="15">
			<button type="button" id="searchBtn" onclick="goSearch()" class="btn btn-outline-primary"><i class="fa-solid fa-magnifying-glass mr-2"></i>검색</button>
		</div>
	</form>
	
	<div class="boardContainer">
		<c:forEach var="board" items="${requestScope.boardList}">
			<div class="board d-flex" style="border-bottom: solid 1px #ccc; padding: 1%;">
				<%-- 첨부파일 이미지가 있을 경우 --%>
				<c:if test="${not empty board.thumbnailImg}">
					<div class="InfoContainer">
						<div class="d-flex justify-content-between" style="margin: 2%">
							<div> <!-- 이름,날짜 -->
								<div class="name">${board.name}</div>
								<div class="regDate">${board.regDate}</div>
							</div>
							<div> <!-- 조회수 -->
								<div class="readCount">조회 ${board.readCount}</div>
							</div>
						</div>
						
						<div style="margin: 0 2% 2% 2%;"> <!-- 제목, 내용, 댓글 -->
							<div class="subject" onclick="goDetail(${board.boardSeq})">${board.subject}</div>
							<div class="content" onclick="goDetail(${board.boardSeq})">
								<c:choose>
									<c:when test="${fn:length(board.content) > 150}">  <%-- 150자 이상일 경우 자르기 --%>
										${fn:substring(board.content,0,150)}...
									</c:when>
									<c:otherwise>${board.content}</c:otherwise>
								</c:choose>
							</div>
							<div class="commentCount">댓글 ${board.commentCount}</div>
						</div>
					</div>
					
					<div class="imgContainer" onclick="goDetail(${board.boardSeq})"> <!-- 이미지 -->
						<img src="<%=ctxPath%>/resources/images/board/${board.thumbnailImg}" alt="Board Image">
					</div>
				</c:if>
				
				<%-- 첨부파일 이미지가 없을 경우 --%>
				<c:if test="${empty board.thumbnailImg}">
					<div class="InfoContainer" style="width: 100%;">
						<div class="d-flex justify-content-between" style="margin: 2%">
							<div> <!-- 이름,날짜 -->
								<div class="name">${board.name}</div>
								<div class="regDate">${board.regDate}</div>
							</div>
							<div> <!-- 조회수 -->
								<div class="readCount">조회 ${board.readCount}</div>
							</div>
						</div>
						
						<div style="margin: 0 2% 2% 2%;"> <!-- 제목, 내용, 댓글 -->
							<div class="subject" onclick="goDetail(${board.boardSeq})">${board.subject}</div>
							<div class="content" onclick="goDetail(${board.boardSeq})" style="height: 60px;">
								<c:choose>
									<c:when test="${fn:length(board.content) > 210}">  <%-- 210자 이상일 경우 자르기 --%>
										${fn:substring(board.content,0,210)}...
									</c:when>
									<c:otherwise>${board.content}</c:otherwise>
								</c:choose>
							</div>
							<div class="commentCount">댓글 ${board.commentCount}</div>
						</div>
					</div>
				</c:if>
			</div>
		</c:forEach>
		
	</div>
	
	<div id="pageBar">
		${requestScope.pageBar}
	</div>
</div>



<%-- 글 상세페이지에서 '검색된결과목록보기'를 클릭했을 경우 돌아갈 페이지를 알기 위함 --%>
<form name="goDetailFrm">
	<input type="hidden" name="boardSeq">
	<input type="hidden" name="goBackURL">
	<input type="hidden" name="searchType">
	<input type="hidden" name="searchWord">
</form>
