<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.net.InetAddress" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
	String ctxPath = request.getContextPath();
%>

<style type="text/css">

	@media screen and (max-width: 768px) {
	    nav.navbar {
	        width: 100% !important;
	    }
	}

	nav.navbar {
		border: solid 0px red;
		width: 70%;
		margin: 0 auto;
	}
</style>

<script type="text/javascript">
	
</script>

<div style="background-color: #F5F5F5;">

	<nav class="navbar navbar-expand-lg navbar-light">
		<a class="navbar-brand" href="<%=ctxPath%>/">Board</a>
		<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavDropdown" aria-controls="navbarNavDropdown" aria-expanded="false" aria-label="Toggle navigation">
			<span class="navbar-toggler-icon"></span>
		</button>
		<div class="collapse navbar-collapse" id="navbarNavDropdown">
			<ul class="navbar-nav">
			
				<c:if test="${empty sessionScope.loginUser}">
					<li class="nav-item">
						<a class="nav-link" href="<%=ctxPath%>/member/login.do">로그인</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="<%=ctxPath%>/member/signUp.do">회원가입</a>
					</li>
				</c:if>
				
				<c:if test="${not empty sessionScope.loginUser}">
					<li class="nav-item">
						<a class="nav-link" href="#">${sessionScope.loginUser.name} 님</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="<%=ctxPath%>/member/logout.do">로그아웃</a>
					</li>
				</c:if>
				
				<li class="nav-item dropdown">
					<a class="nav-link dropdown-toggle" href="#" role="button" data-toggle="dropdown" aria-expanded="false">
					 게시판
					</a>
					<div class="dropdown-menu">
					  <a class="dropdown-item" href="<%=ctxPath%>/board/write.do">글 작성하기</a>
					  <a class="dropdown-item" href="<%=ctxPath%>/board/list.do">글 목록 보기</a>
					</div>
				</li>
			</ul>
		</div>
	</nav>

</div>




