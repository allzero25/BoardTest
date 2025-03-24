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
	
	button#pwFindBtn {
	    width: 100%;
	    height: 50px;
	    margin: 1% auto;
	    border-radius: 8px;
	}
	
</style>

<script type="text/javascript">
	$(document).ready(function() {
		
		$("input#email").keyup(function(e) {
			if(e.keyCode == 13) {
				goPwFind();
			}
		});
		
	});
	
	function goPwFind() {
		
		const userid = $("input#userid").val().trim();
		const name = $("input#name").val().trim();
		const email = $("input#email").val().trim();

		if(userid == "" && name == "" && email == "") {
			alert("정보를 입력해주세요.");
			$("input#userid").val("").focus();
			return;
			
		}
		
		if(userid == "") {
			alert("아이디를 입력해주세요.");
			$("input#userid").val("").focus();
			return;
		}
		
		if(name == "") {
			alert("성명을 입력해주세요.");
			$("input#name").val("").focus();
			return;
			
		}
		
		if(email == "") {
			alert("이메일을 입력해주세요.");
			$("input#email").val("").focus();
			return;
			
		}
		
		const regExp_userid = new RegExp(/^(?=.*[A-Za-z])[A-Za-z0-9]{5,20}$/);
		const bool_userid = regExp_userid.test(userid);
		
		if(!bool_userid) {
			alert("아이디는 5~20자 이내의 영문, 숫자만 입력 가능합니다.");
			$("input#userid").val("").focus();
			return;
		}
		
		const regExp_name = new RegExp(/^[가-힣]{2,6}$/);
		const bool_name = regExp_name.test(name);
		
		if(!bool_name) {
			alert("성명은 2~6자 이내 한글만 입력 가능합니다.");
			$("input#name").val("").focus();
			return;
		}
		
		const regExp_email = new RegExp(/^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i);
		const bool_email = regExp_email.test(email);
		
		if(!bool_email) {
			alert("올바른 이메일 형식이 아닙니다.\n이메일을 다시 입력해주세요.");
			$("input#email").val("").focus();
			return;
		}

		const formData = $("form[name='pwFindFrm']").serialize();
		
		$.ajax({
			url: "<%=ctxPath%>/member/pwFind.do",
			type: "post",
			data: formData,
			dataType: "json",
			success: function(json) {
				
				if(json.isExist) {
					alert("사용자 인증이 완료되었습니다.\n비밀번호 변경 페이지로 이동합니다.");
					location.href = "<%=ctxPath%>/member/pwFind/pwUpdate.do";
					
				} else {
					alert("일치하는 사용자 정보가 없습니다.");
					$("input#userid").val("").focus();
					$("input#name").val("");
					$("input#email").val("");
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
	        <h2 style="margin-top: 20%;" class="font-weight-bold">비밀번호 찾기</h2>
	
			<div id="pwFindDiv">
		        <form name="pwFindFrm">
		        
		            <div class="info">
		                <input type="text" name="userid" id="userid" placeholder="아이디">
		                <input type="text" name="name" id="name" placeholder="성명">
		                <input type="text" name="email" id="email" placeholder="이메일">
		            </div>
		            
		            <div style="margin: 10% 0 20% 0;">
		                <button type="button" class="btn btn-primary" id="pwFindBtn" onclick="goPwFind()">비밀번호 찾기</button>
		            </div>
		
		        </form>
			</div>
			
	    </div>

    </div>
