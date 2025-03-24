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
	
	button#pwUpdateBtn {
	    width: 100%;
	    height: 50px;
	    margin: 1% auto;
	    border-radius: 8px;
	}
	
</style>

<script type="text/javascript">
	$(document).ready(function() {
		
		$("input#pwCheck").keyup(function(e) {
			if(e.keyCode == 13) {
				goPwUpdate();
			}
		});
		
	});
	
	function goPwUpdate() {
		
		const password = $("input#password").val().trim();
		const pwCheck = $("input#pwCheck").val().trim();
		
		if(password == "") {
			alert("비밀번호를 입력해주세요.");
			$("input#password").val("").focus();
			return;
		}
		
		if(pwCheck == "") {
			alert("비밀번호 확인을 입력해주세요.");
			$("input#pwCheck").val("").focus();
			return;
			
		}
		
		const regExp_password = new RegExp(/^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).*$/g);
		const bool = regExp_password.test(password);
		
		if(!bool) {
			alert("비밀번호는 8~15자 이내 영문, 숫자, 특수문자를 포함하여 입력해주세요.");
			$("input#password").val("").focus();
			return;
		}
		
		if(password != pwCheck) {
			alert("비밀번호가 일치하지 않습니다.");
			$("input#pwCheck").val("").focus();
			return;
		}
		
		$.ajax({
			url: "pwUpdate.do",
			type: "post",
			data: {"password":password},
			dataType: "json",
			success: function(json) {
				if(json.n == 1) {
					alert("비밀번호가 변경되었습니다.\n로그인 페이지로 이동합니다.");
					location.href = "<%=ctxPath%>/member/login.do";
					
				} else {
					alert("다시 시도해 주세요.");
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
	        <h5 class="mt-3">비밀번호 변경</h5>
	
			<div id="pwUpdateDiv">
		        <form name="pwUpdateFrm">
		        
		            <div class="info">
		                <input type="password" name="password" id="password" placeholder="비밀번호">
		                <input type="password" name="pwCheck" id="pwCheck" placeholder="비밀번호 확인">
		            </div>
		            
		            <div style="margin: 10% 0 20% 0;">
		                <button type="button" class="btn btn-primary" id="pwUpdateBtn" onclick="goPwUpdate()">비밀번호 변경</button>
		            </div>
		
		        </form>
			</div>
			
	    </div>

    </div>
