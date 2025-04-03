<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String ctxPath = request.getContextPath(); %>

<link rel="stylesheet" type="text/css" href="<%=ctxPath%>/resources/css/member/login.css" >

<script type="text/javascript">
	$(document).ready(function() {
		
		$("span#idFind").click(function() {
			location.href = "<%=ctxPath%>/member/idFind.do";
		});
		
		$("span#pwFind").click(function() {
			location.href = "<%=ctxPath%>/member/pwFind.do";
		})
		
		$("input#password").keyup(function(e) {
			if(e.keyCode == 13) {
				goLogin();
			}
		});
		
		// localStorage에 저장된 id 값 불러오기
		if(${empty sessionScope.loginUser}) {
			const loginId = localStorage.getItem("saveid");
			
			if(loginId != null) {
				$("input#userid").val(loginId);
				$("input:checkbox[id='saveid']").prop("checked", "true");
			}
		}
	});
	
	function goLogin() {
		
		const userid = $("input#userid").val().trim();
		const password = $("input#password").val().trim();
		
		if(userid == "") {
			alert("아이디를 입력해주세요.");
			$("input#userid").focus();
			return;
		}
		
		if(password == "") {
			alert("비밀번호를 입력해주세요.");
			$("input#password").focus();
			return;
		}
		
		// 아이디 저장 체크 시 localStorage에 저장
		if($("input:checkbox[id='saveid']").prop("checked")) {
			
			localStorage.setItem("saveid", userid);
			
		} else {
			localStorage.removeItem("saveid");
		}
		
		const frm = document.loginFrm;
		frm.action = "<%=ctxPath%>/member/login.do";
		frm.method = "post";
		frm.submit();
	}
</script>

    <div class="container">
	    <div style="width: 80%; margin: 7% auto;">
	        <h2 style="margin-top: 20%;" class="font-weight-bold">로그인</h2>
	
	        <form name="loginFrm">
	        
	            <div class="info">
	                <input type="text" name="userid" id="userid" placeholder="아이디" maxlength="20">
	                <input type="password" name="password" id="password" placeholder="비밀번호" maxlength="15">
	            </div>
	            <div style="margin: 0 0 1% 2%;">
	                <input type="checkbox" id="saveid">
	                <span class="checkbox_icon"></span>
	                &nbsp;&nbsp;<label for="saveid">아이디 저장</label>
	            </div>
	            <div class="mb-4">
	                <button type="button" class="btn btn-primary" id="loginBtn" onclick="goLogin()">로그인</button>
	            </div>
	
	            <div class="d-flex idPwFind" style="margin-bottom: 20%;">
		            <span id="idFind" style="margin-right: 4%;">아이디 찾기</span> | 
		            <span id="pwFind" style="margin-left: 4%;">비밀번호 찾기</span>
	            </div>
	        </form>
	    </div>

    </div>
