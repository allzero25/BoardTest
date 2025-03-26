package com.project.app.common;

import javax.servlet.http.HttpServletRequest;

public class CommonUtil {

	// 쿼리스트링을 포함한 현재 URL 주소 가져오기
	public static String getCurrentURL(HttpServletRequest request) {
		
		String currentURL = request.getRequestURL().toString();
		// 예) http://localhost:8080/BoardTest/board/list.do
		
		String queryString = request.getQueryString();
		// POST일 경우 queryString = null
		
		if(queryString != null) {
			currentURL += "?" + queryString;
		}
		
		String ctxPath = request.getContextPath();
		// 예) /BoardTest
		
		int beginIndex = currentURL.indexOf(ctxPath) + ctxPath.length();
		// Context Path 이후의 URL 시작 인덱스
		
		currentURL = currentURL.substring(beginIndex);
		// 예) /board/list.do
		
		return currentURL;
	} // end of public static String getCurrentURL(HttpServletRequest request) ------------------
	
	
	// 게시판 내용에서 html 태그 입력 방지
	public static String changeEtcTag(String content) {
		
		content = content.replaceAll("<", "&lt");
		content = content.replaceAll(">", "&gt");
		content = content.replaceAll("\r\n", "<br>"); // 엔터를 <br>로 변환
		
		return content;
	}
	
	
	// 쿼리스트링을 포함한 이전페이지 URL 주소 가져오기
	public static String getPreviousURL(HttpServletRequest request) {
		
		String prevURL = request.getHeader("Referer");
		
		String queryString = request.getQueryString();
		// POST일 경우 queryString = null
		
		if(queryString != null) {
			prevURL += "?" + queryString;
		}
		
		String ctxPath = request.getContextPath();
		
		int beginIndex = prevURL.indexOf(ctxPath) + ctxPath.length();
		
		prevURL = prevURL.substring(beginIndex);
		
		if(prevURL == null) {
			prevURL = ctxPath + "/";
		}
		
		return prevURL;
	}
	
	
}
