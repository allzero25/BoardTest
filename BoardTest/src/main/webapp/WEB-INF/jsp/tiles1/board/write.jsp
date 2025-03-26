<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String ctxPath = request.getContextPath(); %>

<style type="text/css">

	@media screen and (max-width: 768px) {
	
		div.writeBoardDiv {
			width: 100% !important;
			margin: 0 auto;
		}
	
	    div.info {
	        width: 100% !important;
	    }
	    
	    table#writeBoardTable th {
	    	width: 20% !important;
	    }
	    
	    div#previewContainer {
	    	grid-template-columns: repeat(auto-fill, minmax(30%, 1fr));
	    }
	    
	    div#btnDiv {
	    	margin-top: 10% !important;
	    }
	    
	    div#btnDiv button {
	    	width: 100px !important;
	    }
	}

	div.writeBoardDiv {
		border: solid 0px red;
		width: 70%;
		margin: 0 auto;
	}
	
	div.info {
		width: 70%;
		margin: 5% auto;
	}
	
	table#writeBoardTable th {
		width: 10%;
		text-align: center;
		vertical-align: middle;
	}
	
	table#writeBoardTable td {
		vertical-align: middle;
		padding: 0 !important;
	}
	
	input#name {
		background-color: transparent;
	}
	
	.form-control {
		border: none;
	}
	
	.form-control:focus {
		outline: none !important;
	}
	
	textarea#content {
		resize: none;
	}
	
	div#previewContainer {
		margin: 1%;
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(20%, 1fr));
		/* 최소 20%, 최대 1fr의 너비를 가진 열을 자동으로 채움 */
		gap: 10px;
	}
	
	div.img-wrapper {
		position: relative;
	}
	
	div.img-wrapper img {
	    width: 100%;
	    border-radius: 5px;
	}
	
	button.close-button {
	    position: absolute;
	    top: 5px;
	    right: 5px;
	    background-color: rgba(255, 255, 255, 0.7);
	    border: none;
	    border-radius: 50%;
	    font-weight: bold;
	}
	
	div#btnDiv {
		text-align: center;
		margin: 5% 0;
	}
	div#btnDiv button {
		width: 10%;
	}
	
</style>

<script type="text/javascript">

	$(document).ready(function() {
		
		// 이미지 미리보기
	    $("input#attachInput").on("change", function(event) {
	    	
	        const files = event.target.files; // 선택된 파일들
	        const previewContainer = $("div#previewContainer");
	        previewContainer.empty(); // 미리보기 초기화
	        
	        let selectedImages = []; // 선택된 이미지 파일 목록 초기화
	        const validFiles = []; // 유효한 이미지 파일을 저장할 배열
	        
	        $.each(files, function(index, file) {
	        	
	        	if(validFiles.length >= 10) {
	        		alert("파일은 10개까지만 첨부 가능합니다.");
	        		return false;
	        	}

	        	if(file.type !== "image/jpeg" && file.type !== "image/png") {
	        		alert("jpg 또는 png 파일만 첨부 가능합니다.");
	        		return;
	        	}
	        	
	        	validFiles.push(file); // 유효한 파일을 배열에 추가
	        	
	            const reader = new FileReader();
	            reader.readAsDataURL(file); // 파일을 읽어 Data URL로 변환
	            
	            reader.onload = function(e) {
	            	
	            	const imgWrapper = $('<div class="img-wrapper"></div>'); // 이미지 래퍼 생성
	                const img = $('<img>').attr('src', e.target.result); // 이미지 미리보기 소스 설정
	                const closeButton = $('<button class="close-button btn"><i class="fa-solid fa-xmark"></i></button>'); // 닫기 버튼 생성
	            	
	             	// 닫기 버튼 클릭 시 이미지 제거
	                closeButton.on("click", function() {
	                    imgWrapper.remove(); // 이미지 래퍼 제거
	                    selectedImages = selectedImages.filter(item => item !== file); // 파일 목록에서 제거
	                    
	                 	// 파일 input의 파일 목록 업데이트
	                    const dataTransfer = new DataTransfer();
	                    selectedImages.forEach(img => dataTransfer.items.add(img)); // 선택된 파일들을 DataTransfer에 추가
	                    document.getElementById('attachInput').files = dataTransfer.files; // input의 파일 목록 업데이트
	                });
	                
	                imgWrapper.append(img).append(closeButton); // 래퍼에 이미지, 닫기 버튼 추가
	                previewContainer.append(imgWrapper); // 미리보기 컨테이너에 이미지 래퍼 추가
	            }
	        });
	        
	        selectedImages = validFiles; // 유효한 파일 목록 업데이트
	        
	        // 파일 input의 파일 목록 업데이트 (유효한 파일만)
	        const dataTransfer = new DataTransfer();
	        selectedImages.forEach(img => dataTransfer.items.add(img)); // 선택된 파일들을 DataTransfer에 추가
	        document.getElementById('attachInput').files = dataTransfer.files; // input의 파일 목록 업데이트
	    });
		
	    
		// 취소 버튼 클릭 시
		$("button#goBackBtn").click(function() {
			if(confirm("작성하던 내용이 저장되지 않습니다.\n글 작성을 취소하시겠습니까?")) {
				history.back();
			}
		});
		
	});
	
	function goWriteBoard() {
		
		const subject = $("input#subject").val().trim();
		const content = $("textarea#content").val().trim();
		
		if(subject == "" && content == "") {
			alert("내용을 모두 입력하세요.");
			$("input#subject").focus();
			return;
		}
		
		if(subject == "") {
			alert("제목을 입력하세요.");
			$("input#subject").focus();
			return;
		}
		
		if(content == "") {
			alert("내용을 입력하세요.");
			$("textarea#content").focus();
			return;
		}
		
		if(content.length < 5) {
			alert("내용은 5자 이상 입력하세요.");
			$("textarea#content").val("").focus();
			return;
		}
		
		// 첨부파일 크기 검사
		const files = $("input#attachInput").get(0).files; // jQuery -> DOM 요소로 변환
		let totalSize = 0;
		
		for(let i=0; i<files.length; i++) {
			totalSize += files[i].size;
		}
		
		if(totalSize >= 10*1024*1024) {
			alert("첨부파일의 총 크기는 10MB를 초과할 수 없습니다.");
			return;
		}
		
		const frm = document.writeBoardFrm;
		frm.method = "post";
		frm.action = "<%=ctxPath%>/board/write.do";
		frm.submit();
	}
	
</script>

<div class="writeBoardDiv">
	<div class="info">
		<div class="mb-4">
			<h2>글 작성</h2>
		</div>
		
		<form name="writeBoardFrm" enctype="multipart/form-data">
			<div>
				<table id="writeBoardTable" class="table table-bordered">
					<tr>
						<th>작성자</th>
						<td>
							<input type="hidden" name="fk_userid" value="${sessionScope.loginUser.userid}">
							<input type="text" id="name" name="name" class="form-control" value="${sessionScope.loginUser.name}" readonly>
						</td>
					</tr>
					<tr>
						<th>제목</th>
						<td><input type="text" id="subject" name="subject" class="form-control" size="100" maxlength="200"></td>
					</tr>
					<tr>
						<th>내용</th>
						<td><textarea id="content" name="content" class="form-control" rows="15"></textarea></td>
					</tr>
					<tr>
						<th>첨부파일</th>
						<td><input type="file" name="attach" id="attachInput" multiple accept="image/*" class="form-control"></td>
					</tr>
					<tr>
						<th>이미지<br>미리보기</th>
						<td><div id="previewContainer"></div></td>
					</tr>
				</table>
			</div>
			
			<div id="btnDiv">
				<button type="button" id="writeBoardBtn" class="btn btn-primary mr-4" onclick="goWriteBoard()">등록하기</button>
				<button type="button" id="goBackBtn" class="btn btn-secondary">취소</button>
			</div>
		</form>
	</div>
</div>