select * from tbl_board order by boardSeq desc;
select * from tbl_board_img order by imgSeq DESC;
SELECT * FROM tbl_member ORDER BY registerday DESC;

UPDATE tbl_member
SET phone = '1yEZOCTPCofSKGB5Gv3A3w=='
WHERE userid = 'kimmy';
COMMIT;

-- 회원 테이블 생성
/*
CREATE TABLE tbl_member (
    userid VARCHAR(20) NOT NULL,
    name VARCHAR(20) NOT NULL,
    email VARCHAR(200) NOT NULL,
    password VARCHAR(200) NOT NULL,
    phone VARCHAR(200) NOT NULL,
    birthday VARCHAR(10),
    gender TINYINT(1),
    registerday DATETIME DEFAULT CURRENT_TIMESTAMP,
    status TINYINT(1) DEFAULT 1 NOT NULL,
    primary key (userid),
    CONSTRAINT UNIQUE_TBL_MEMBER_EMAIL unique(email),
    CONSTRAINT UNIQUE_TBL_MEMBER_PHONE unique(phone),
    CONSTRAINT CK_TBL_MEMBER_STATUS CHECK (status IN (0, 1))
);
*/

/*
-- email 컬럼 unique 제약조건 추가
alter table tbl_member
add constraint UNIQUE_TBL_MEMBER_EMAIL unique(email);

-- phone 컬럼 타입 varchar(11) -> varchar(200) 변경
ALTER TABLE tbl_member
MODIFY phone VARCHAR(200); 

-- phone 컬럼 unique 제약조건 추가
alter table tbl_member
add constraint UNIQUE_TBL_MEMBER_PHONE unique(phone);
*/




-- 게시판 테이블 생성
/*
CREATE TABLE tbl_board (
    boardSeq INT auto_increment NOT NULL,  -- 글번호
    fk_userid VARCHAR(20) NOT NULL, 	   -- 아이디
    name VARCHAR(20) NOT NULL,			   -- 작성자
    subject VARCHAR(200) NOT NULL,		   -- 글제목
    content TEXT NOT NULL,				   -- 글내용
    readCount INT DEFAULT 0 NOT NULL,	   -- 조회수
    regDate DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,  -- 작성일자
    status TINYINT DEFAULT 1 NOT NULL, -- 상태 (0: 삭제)
    commentCount INT DEFAULT 0 NOT NULL,   -- 댓글개수
    CONSTRAINT PK_TBL_BOARD_SEQ PRIMARY KEY (boardSeq),
    CONSTRAINT FK_TBL_BOARD_USERID FOREIGN KEY (fk_userid) REFERENCES tbl_member(userid) on delete cascade,
    CONSTRAINT CK_TBL_BOARD_STATUS CHECK (status IN (0, 1))
);
*/



### 게시판 이미지 테이블 생성
/*
CREATE TABLE tbl_board_img (
	imgSeq INT auto_increment NOT NULL,
    fk_boardSeq INT NOT NULL,
    filename varchar(255) NOT NULL,
    CONSTRAINT PK_TBL_BOARD_IMG_SEQ PRIMARY KEY(imgSeq),
    CONSTRAINT FK_TBL_BOARD_IMG_BOARDSEQ FOREIGN KEY(fk_boardSeq) REFERENCES tbl_board(boardSeq) on delete cascade
);
*/




### 댓글 테이블 생성
/*
CREATE TABLE tbl_comment (
    commentSeq INT auto_increment NOT NULL,
    fk_userid VARCHAR(20) NOT NULL,
    name VARCHAR(20) NOT NULL,
    content VARCHAR(1000) NOT NULL,
    regDate DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fk_boardSeq INT NOT NULL,
    status TINYINT DEFAULT 1 NOT NULL,  -- 0일 경우: 삭제
    groupno INT NOT NULL, -- 원댓글과 답댓글은 동일한 groupno를 가짐
    fk_seq INT DEFAULT 0 NOT NULL, -- (답댓글일 경우)원댓글의 seq번호
    CONSTRAINT PK_TBL_COMMENT_SEQ PRIMARY KEY (commentSeq),
    CONSTRAINT FK_TBL_COMMENT_USERID FOREIGN KEY (fk_userid) REFERENCES tbl_member(userid) on delete cascade,
    CONSTRAINT FK_TBL_COMMENT_BOARDSEQ FOREIGN KEY (fk_boardSeq) REFERENCES tbl_board(boardSeq) on delete cascade,
    CONSTRAINT CK_TBL_COMMENT_STATUS check(status in(0,1))
);
*/


ALTER TABLE tbl_comment
DROP COLUMN depthno;



### 게시판 총 게시물 수 ###
SELECT COUNT(*)
FROM tbl_board
WHERE STATUS = 1
		AND LOWER(subject) LIKE CONCAT('%', LOWER('안녕'), '%');



### 게시판 목록 (검색, 페이징, 각 게시물별 대표이미지) --- row_number() 사용
SELECT boardSeq, fk_userid, NAME, SUBJECT, content, readCount, regDate, commentCount, thumbnailImg
FROM
(
	SELECT boardSeq, fk_userid, NAME, SUBJECT, content, readCount, date_format(regDate, '%Y-%m-%d') AS regDate, commentCount, I.filename AS thumbnailImg,
			 ROW_NUMBER() OVER (ORDER BY boardSeq DESC) rno
	FROM tbl_board B
	LEFT JOIN (
	    SELECT fk_boardSeq, filename
	    FROM (
	        SELECT fk_boardSeq, filename, imgSeq,
	               ROW_NUMBER() OVER (PARTITION BY fk_boardSeq ORDER BY imgSeq) AS rownum  ### fk_boardSeq마다 그룹을 나누고 imgSeq 순으로 정렬하여 번호 매기기
	        FROM tbl_board_img
	    ) AS subquery
	    WHERE rownum = 1  ### imgSeq가 가장 작은 이미지(첫 번째 이미지)
	) I ON B.boardSeq = I.fk_boardSeq
	WHERE B.STATUS = 1
			AND LOWER(name) LIKE CONCAT('%', LOWER('다'), '%')
) V
WHERE V.rno BETWEEN 1 AND 5;




### 게시판 목록 --- limit offset 사용
SELECT boardSeq, fk_userid, NAME, SUBJECT, content, readCount, date_format(regDate, '%Y-%m-%d') AS regDate, commentCount, I.filename AS thumbnailImg
FROM tbl_board B
LEFT JOIN (
  SELECT fk_boardSeq, filename
  FROM (
      SELECT fk_boardSeq, filename, imgSeq,
             ROW_NUMBER() OVER (PARTITION BY fk_boardSeq ORDER BY imgSeq) AS rownum
      FROM tbl_board_img
  ) AS subquery
  WHERE rownum = 1
) I ON B.boardSeq = I.fk_boardSeq
WHERE B.STATUS = 1
	#AND LOWER(name) LIKE CONCAT('%', LOWER('다'), '%')
ORDER BY boardSeq DESC
LIMIT 5 OFFSET 0;





### 글 1개 조회하기 (검색 O)
SELECT prevSeq, prevSubject,
		 boardSeq, fk_userid, name, subject, content, readCount, regDate, commentCount,
		 nextSeq, nextSubject
FROM
(
	SELECT boardSeq, fk_userid, name, subject, content, readCount, date_format(regDate, '%Y-%m-%d %H:%i') AS regDate, commentCount,
			 LAG(boardSeq) OVER(ORDER BY boardSeq DESC) AS prevSeq,
			 LAG(subject) OVER(ORDER BY boardSeq DESC) AS prevSubject,
			 LEAD(boardSeq) OVER(ORDER BY boardSeq DESC) AS nextSeq,
			 LEAD(subject) OVER(ORDER BY boardSeq DESC) AS nextSubject
	FROM tbl_board
	WHERE STATUS = 1
	#AND LOWER(NAME) LIKE CONCAT('%', LOWER('다'), '%')
) V
WHERE V.boardSeq = 5;



### 글 1개 조회하기 ★최종★ (검색, 정렬 O)
SELECT prevSeq, prevSubject,
       boardSeq, fk_userid, name, subject, content, readCount, regDate, commentCount,
       nextSeq, nextSubject
FROM
(
    SELECT boardSeq, fk_userid, name, subject, content, readCount, 
           date_format(regDate, '%Y-%m-%d %H:%i') AS regDate, commentCount,
           LAG(boardSeq) OVER(ORDER BY 
               CASE 
                   WHEN 'readCount' = 'readCount' THEN readCount
                   WHEN 'readCount' = 'commentCount' THEN commentCount
                   ELSE boardSeq
               END DESC) AS prevSeq,
           LAG(subject) OVER(ORDER BY 
               CASE 
                   WHEN 'readCount' = 'readCount' THEN readCount
                   WHEN 'readCount' = 'commentCount' THEN commentCount
                   ELSE boardSeq
               END DESC) AS prevSubject,
           LEAD(boardSeq) OVER(ORDER BY 
               CASE 
                   WHEN 'readCount' = 'readCount' THEN readCount
                   WHEN 'readCount' = 'commentCount' THEN commentCount
                   ELSE boardSeq
               END DESC) AS nextSeq,
           LEAD(subject) OVER(ORDER BY 
               CASE 
                   WHEN 'readCount' = 'readCount' THEN readCount
                   WHEN 'readCount' = 'commentCount' THEN commentCount
                   ELSE boardSeq
               END DESC) AS nextSubject
    FROM tbl_board
    WHERE STATUS = 1
    AND LOWER(NAME) LIKE CONCAT('%', LOWER('다영'), '%')
) V
WHERE V.boardSeq = 11;






select imgSeq, fk_boardSeq, filename
from tbl_board_img
-- WHERE filename LIKE '%휴애리%'
ORDER BY imgSeq;



SELECT *
FROM tbl_board
ORDER BY boardSeq DESC;

SELECT *
FROM tbl_comment
ORDER BY commentSeq DESC;




### 댓글 테이블 groupno 최대값 구하기
SELECT IFNULL(MAX(groupno), 0)
from tbl_comment;


### 댓글 목록 조회 (대댓글X, 페이징O)
SELECT commentSeq, fk_userid, name, content, date_format(regDate, '%Y-%m-%d %H:%i') AS regDate, fk_boardSeq, status, groupno, fk_seq, depthno
FROM tbl_comment
WHERE fk_boardSeq = 15
ORDER BY commentSeq DESC
LIMIT 5 OFFSET 0;



### 댓글 목록 조회 (대댓글O, 페이징O, 삭제된댓글X)
WITH RECURSIVE comment_tree AS (
    SELECT commentSeq, fk_userid, name, content, 
           DATE_FORMAT(regDate, '%Y-%m-%d %H:%i') AS regDate, 
           fk_boardSeq, status, groupno, fk_seq, depthno
    FROM tbl_comment
    WHERE fk_seq = 0   ### 루트 댓글 선택(fk_seq가 0인 댓글) = 계층 구조의 최상위에 해당

    UNION ALL

    SELECT c.commentSeq, c.fk_userid, c.name, c.content, 
           DATE_FORMAT(c.regDate, '%Y-%m-%d %H:%i'), 
           c.fk_boardSeq, c.status, c.groupno, c.fk_seq, c.depthno
    FROM tbl_comment c
    INNER JOIN comment_tree ct ON ct.commentSeq = c.fk_seq  ### 자식 댓글 선택 : 부모(ct.commentSeq)와 자식(c.fk_seq)을 연결하여 답글 가져오기 (INNER JOIN을 사용하여 연결)
)
SELECT * FROM comment_tree
WHERE fk_boardSeq = 14
ORDER BY groupno DESC, commentSeq ASC
LIMIT 5 OFFSET 0;




### 댓글 목록 조회 ★최종★ (대댓글O, 페이징O, 삭제된댓글O)
WITH RECURSIVE comment_tree AS (
    SELECT commentSeq, fk_userid, name, content, 
           DATE_FORMAT(regDate, '%Y-%m-%d %H:%i') AS regDate, 
           fk_boardSeq, status, groupno, fk_seq, depthno
    FROM tbl_comment
    WHERE fk_seq = 0 AND (STATUS = 1 
	 		OR (STATUS = 0 AND EXISTS (
			 		SELECT 1
			 		FROM tbl_comment sub
			 		WHERE sub.fk_seq = tbl_comment.commentSeq
			 		AND sub.status = 1
			 ))
		)   ### 루트 댓글 선택(fk_seq가 0인 댓글 중 status = 1인 건 모두, status = 0인 건 자식 댓글이 있는 댓글만) = 계층 구조의 최상위에 해당
		
    UNION ALL

    SELECT c.commentSeq, c.fk_userid, c.name, c.content, 
           DATE_FORMAT(c.regDate, '%Y-%m-%d %H:%i'), 
           c.fk_boardSeq, c.status, c.groupno, c.fk_seq, c.depthno
    FROM tbl_comment c
    INNER JOIN comment_tree ct ON ct.commentSeq = c.fk_seq
    WHERE c.status = 1   ### 자식 댓글 선택 : 부모(ct.commentSeq)와 자식(c.fk_seq)을 연결하여 status = 1인 답글 가져오기 (INNER JOIN 사용하여 연결)
)
SELECT * FROM comment_tree
WHERE fk_boardSeq = 11
ORDER BY groupno DESC, commentSeq ASC
LIMIT 5 OFFSET 0;





### 댓글 목록 조회 ★최최종★ (대댓글O, 페이징O, 삭제된댓글O)
WITH RECURSIVE comment_tree AS (
    SELECT commentSeq, fk_userid, name, content, 
           DATE_FORMAT(regDate, '%Y-%m-%d %H:%i') AS regDate, 
           fk_boardSeq, status, groupno, fk_seq, depthno
    FROM tbl_comment
    WHERE fk_seq = 0 AND (STATUS = 1 
	 		OR (STATUS = 0 AND EXISTS (
			 		SELECT 1
			 		FROM tbl_comment sub
			 		WHERE sub.fk_seq = tbl_comment.commentSeq
			 		AND sub.status IN (0,1)
			 ))
		)   ### 루트 댓글 선택(fk_seq가 0인 댓글 중 status = 1인 건 모두, status = 0인 건 자식 댓글이 있는 댓글만) = 계층 구조의 최상위에 해당
		
    UNION ALL

    SELECT c.commentSeq, c.fk_userid, c.name, c.content, 
           DATE_FORMAT(c.regDate, '%Y-%m-%d %H:%i'), 
           c.fk_boardSeq, c.status, c.groupno, c.fk_seq, c.depthno
    FROM tbl_comment c
    INNER JOIN comment_tree ct ON ct.commentSeq = c.fk_seq
    WHERE c.status = 1   ### 자식 댓글 선택 : 부모(ct.commentSeq)와 자식(c.fk_seq)을 연결하여 status = 1인 답글 가져오기 (INNER JOIN 사용하여 연결)
)
SELECT * FROM comment_tree
WHERE fk_boardSeq = 11
ORDER BY groupno DESC, commentSeq ASC
LIMIT 5 OFFSET 0;


SELECT *
FROM tbl_comment
#WHERE fk_boardSeq = 19
ORDER BY commentSeq DESC;


SELECT *
FROM tbl_board_img
ORDER BY fk_boardSeq DESC;


SELECT *
FROM tbl_board
ORDER BY boardSeq DESC;








