package com.project.app.common;

import java.io.File;
import java.io.FileOutputStream;
import java.util.Calendar;

import org.springframework.stereotype.Component;

@Component
public class FileManager {
	
	// 파일 업로드하기
	public String uploadFile(byte[] bytes, String originalFileName, String path) throws Exception {
		
		String newFileName = null;
		
		if(bytes == null)
			return null;
		
		if("".equals(originalFileName) || originalFileName == null)
			return null;
		
		newFileName = originalFileName.substring(0, originalFileName.lastIndexOf(".")); // 확장자를 뺀 파일명
		newFileName += "_" + String.format("%1$tY%1$tm%1$td%1$tH%1$tM%1$tS", Calendar.getInstance()); // 년월일시분초
		newFileName += System.nanoTime(); // 나노초
        newFileName += originalFileName.substring(originalFileName.lastIndexOf(".")); // 확장자 붙이기
        
//		System.out.println(originalFileName);
		// 눈슉슉이.png
		// 맑음슉슉이.png
		// 번개슉슉이.png
		
//		System.out.println(newFileName);
		// 눈슉슉이_2025031314275919098214242400.png
		// 맑음슉슉이_2025031314275919098214337700.png
		// 번개슉슉이_2025031314275919098214401300.png
		
        File dir = new File(path);
        
        // 업로드할 경로가 존재하지 않는 경우 폴더 생성
        if(!dir.exists()) {
        	dir.mkdirs();
        }
		
        String pathName = path + File.separator + newFileName;
        
        FileOutputStream fos = new FileOutputStream(pathName);
        // FileOutputStream = pathName에 실제 데이터 내용(bytes)을 기록
        
        fos.write(bytes);
        
        fos.close();
        
        return newFileName;
	}
	
	
	// 파일 삭제하기
	public void deleteFile(String filename, String path) throws Exception {
		String pathName = path + File.separator + filename;
		File file = new File(pathName);
		
		if(file.exists()) {
			file.delete();
		}
	}
	
	
	
}
