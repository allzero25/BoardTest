<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String ctxPath = request.getContextPath(); %>

<style type="text/css">
	
	@media screen and (min-width: 768px) and (max-width: 1024px) {
	    div.container {
	        width: 70vw !important;
	    }
	}
	
	@media screen and (max-width: 768px) {
	    div.container {
	        width: 80vw !important;
	    }
	}
	
	@media screen and (max-width: 425px) {
	    div.container {
	        width: 100vw !important;
	        margin-top: 0 !important;
	    }
	
	    h2 {
	        font-size: 1.4rem !important;
	    }
	
	    div.info input {
	        font-size: 0.8rem !important;
	    }
	}
	
	
	div.container {
	    width: 35%;
	    margin: 5% auto;
	    border: solid 1px rgba(0, 0, 0, 0.15);
	    border-radius: 40px;
	    box-shadow: 0px 8px 20px 0px rgba(0, 0, 0, 0.15);
	}
	
	div.info {
	    border: solid 0px red;
	    width: 100%;
	    margin: 5% 0;
	}
	
	div.info input {
	    display: block;
	    width: 100%;
	    max-width: 680px;
	    height: 50px;
	    margin: 0 auto;
	    margin-bottom: 4%;
	    border-radius: 8px;
	    border: solid 1px rgba(15, 19, 42, .1);
	    padding: 0 0 0 15px;
	    font-size: 16px;
	}
	
	button#idFindBtn {
	    width: 100%;
	    height: 50px;
	    margin: 1% auto;
	    border-radius: 8px;
	}
	
</style>

<script type="text/javascript">
	$(document).ready(function() {
		
		$("input#phone").keyup(function(e) {
			if(e.keyCode == 13) {
				goIdFind();
			}
		});
		
		$(document).on("click", "button#loginBtn", function() {
			location.href = "<%=ctxPath%>/member/login.do";
		});
		
		$(document).on("click", "button#pwFindBtn", function() {
			location.href = "<%=ctxPath%>/member/pwFind.do";
		});
		
	});
	
	function goIdFind() {
		
		const name = $("input#name").val().trim();
		const phone = $("input#phone").val().trim();

		if(name == "" && phone == "") {
			alert("정보를 입력해주세요.");
			$("input#name").val("").focus();
			return;
			
		}
		
		if(name == "") {
			alert("성명을 입력해주세요.");
			$("input#name").val("").focus();
			return;
			
		}
		
		if(phone == "") {
			alert("휴대폰 번호를 입력해주세요.");
			$("input#phone").val("").focus();
			return;
			
		} 
		
		const regExp_name = new RegExp(/^[가-힣]{2,6}$/);
		const bool_name = regExp_name.test(name);
		
		if(!bool_name) {
			alert("성명은 2~6자 이내 한글만 입력 가능합니다.");
			$("input#name").val("").focus();
			return;
		}
		
		
		const regExp_phone = new RegExp(/^01[016789]{1}[0-9]{3,4}[0-9]{4}$/);
		const bool_phone = regExp_phone.test(phone);
		
		if(!bool_phone) {
			alert("유효하지 않은 연락처입니다.");
			$("input#phone").val("").focus();
			return;
		}
		
		const formData = $("form[name='idFindFrm']").serialize();
		
		$.ajax({
			url: "<%=ctxPath%>/member/idFind.do",
			type: "post",
			data: formData,
			dataType: "json",
			success: function(json) {
				
				if(json.userid) {
					
					let v_html = `<div class="text-center" style="padding: 7% 0;">
			        	<span style="margin: 5% 0 3% 0; font-size: 1.2em;"><span class="font-weight-bold">\${name}</span>님의 아이디</span>
			        	<div style="border: solid 1px rgba(0, 0, 0, 0.15); border-radius: 20px; width: 70%; margin: 5% auto; padding: 10% 0;">
			        		<span class="font-weight-bold" style="font-size: 1.5em;">\${json.userid}</span>
			        	</div>
			        	<div class="text-center" style="width: 80%; margin: 0 auto;">
				        	<button id="loginBtn" type="button" class="btn btn-success mr-3">로그인하러 가기</button>
				        	<button id="pwFindBtn" type="button" class="btn btn-outline-success">비밀번호 찾기</button>
			        	</div>
			        </div>`;
			        
			        $("div#idFindDiv").html(v_html);
					
				} else {
					alert("일치하는 사용자 아이디가 없습니다.");
					$("input#name").val("").focus();
					$("input#phone").val("");
				}
			},
			error: function(request, status, error) {
                alert("code: " + request.status + "\n" + "message: " + request.responseText + "\n" + "error: " + error);
            }
		});
	}
</script>

    <div class="container">
	    <div style="width: 80%; margin: 7% auto;">
	        <h2 style="margin-top: 20%;" class="font-weight-bold">아이디 찾기</h2>
	
			<div id="idFindDiv">
		        <form name="idFindFrm">
		        
		            <div class="info">
		                <input type="text" name="name" id="name" placeholder="성명">
		                <input type="text" name="phone" id="phone" placeholder="휴대폰 번호 ('-' 제외 11자리 입력)">
		            </div>
		            
		            <div style="margin: 10% 0 20% 0;">
		                <button type="button" class="btn btn-primary" id="idFindBtn" onclick="goIdFind()">아이디 찾기</button>
		            </div>
		
		        </form>
			</div>
			
	    </div>

    </div>
