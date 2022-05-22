-- CREATE
  -- CREATE TABLE AS SELECT : 테이블 복사하여 생성
    CREATE TABLE city2 AS SELECT * FROM city;
    -- city로 city2 복사하여 생성

  -- CREATE DATABASE
    CREATE DATABASE suan;
    -- suan DATABASE 생성

    USE suan;
    -- suan DATABASE 사용

  -- GUI 활용하여 자동으로 sql문을 작성하여 table 생성 가능함
  CREATE TABLE test2 (
    id INT NOT NULL PRIMARY KEY,
    col1 INT NULL,
    col2 FLOAT NULL,
    col3 VARCHAR(45) NULL
  )


-- ALTER
  -- ALTER TABLE과 ADD 사용시 테이블에 column 추가 가능함
  ALTER TABLE test2 ADD col4 INT NULL;
  -- test2 테이블에 col4라는 null을 허용하는 int형 column이 추가 됨

  -- ALTER TABLE과 MODIFY 사용 시 테이블의 column 타입을 변경할 수 있음
  ALTER TABLE test2 MODIFY col4 VARCHAR(20) NULL;
  -- test2 테이블에 col4을 null을 허용하는 VARCHAR(20)형 column이 수정 됨

  -- ALTER TABLE과 DROP 사용 시 테이블의 colunm 제거 가능
  ALTER TABLE test2 DROP col4;
  -- test2 테이블에 col4 colunm 삭제


-- INDEX
  -- 테이블에서 원하는 데이터를 빠르게 찾기 위해 사용
  -- 일반적으로 데이터 검색 시 순서대로 테이블을 검색하기 때문에 데이터 양이 많을수록 탐색시간이 늘어남
  -- INDEX를 활용하면 검색시 테이블 전체를 읽지 않기 때문에 빠름
  -- 설정된 컬럼 값을 포함한 데이터의 삽입, 삭제, 수정이 원본 테이블에서 이뤄질 경우 인덱스도 함께 수정되어야 함
  -- 인덱스가 있는 테이블은 처리 속도가 느려질 수 있으므로 수정보다는 검색이 자주 사용되는 테이블에서 사용하는 것이 좋음

  -- INDEX 생성
  CREATE INDEX Col1Idx ON test2 (col1);
  -- test2의 col1를 가져온 INDEX를 생성

  CREATE UNIQUE INDEX Col2Index ON test2 (col2);
  -- 중복값이 없는 INDEX 생성, 조회 시 Non_unique가 0인 즉 unique한 index가 생성됨
  

  -- INDEX 조회
  SHOW INDEX FROM test2;

  -- FULLTEXT INDEX : 테이블의 모든 텍스트 컬럼을 매우 빠르게 검색
  ALTER TABLE test2 ADD FULLTEXT Col3Idx(col3);
  -- INDEX 타입이 FULLTEXT로 나온다

  -- INDEX 삭제
  -- ALTER 사용
    ALTER TABLE test2 DROP INDEX Col3Idx; 
  -- DROP 사용
    DROP INDEX Col2Index ON test2; -- table 명을 꼭 써줘야함


-- VIEW
  -- 데이터베이스에 존재하는 일종의 가상 테이블
  -- 실제 테이블처럼 행과 열으라 가지고 있지 않지만, 실제로 데이터를 저장하지 않음
  -- MySQL에서 뷰는 다른 테이블이나 다른 뷰에 저장되어 있는 데이터를 보여주는 역할만 수행
  -- 뷰를 사용하면 여러 테이블이나 뷰를 하나의 테이블처럼 볼 수 있음
  -- 장점 :
    -- 특정 사용자에게 테이블 전체가 아닌 필요한 컬럼만 보여줄 수 있음
    -- 복잡한 쿼리를 단순화해서 사용
    -- 쿼리 재사용 가능
  -- 단점 :
    -- 한번 정의된 뷰는 변경 불가능
    -- 삽입, 삭제, 갱신 작업에 많은 제한 사항을 가짐
    -- 자신만의 인덱스를 가질 수 없음

  -- VIEW 생성
  CREATE VIEW testView AS SELECT Col1, Col2 FROM test2;
  -- test2의 col1, col2를 담는 testView 반환

  -- VIEW 조회
  SELECT * FROM testView;

  -- VIEW 수정
  ALTER VIEW testView AS SELECT Col1, Col2, Col3 FROM test2;
  -- 생성된 testView에 Col3 컬럼 추가

  -- VIEW 삭제
  DROP VIEW testView;

  CREATE VIEW allView AS
  SELECT city.NAME, country.SurfaceArea, city.Population, countrylanguage.Language
  FROM city
  JOIN country ON city.CountryCode = country.code
  JOIN countrylanguage ON city.countryCode = countrylanguage.CountryCode;
  WHERE city.countryCode = 'KOR'
  -- city, country, countrylanguage 테이블을 JOIN하고 한국에 대한 정보만 뷰 생성

  SELECT * FROM allView;


-- INSERT
  --테이블 이름 다음에 나오는 열 생략 가능, 생략하는 경우 VALUE 다음에 나오는 값들의 순서 및 개수가 테이블이 정의된 열 순서 및 개수와 동일해야함
  INSERT INTO test
  VALUE(1, 11, 1.1, "Text");

  -- INSERT INTO SELECT : 복사
  INSERT INTO test2 SELECT * FROM test;
  -- test 테이블에 있는 내용을 test2 테이블에 삽입


-- UPDATE
  -- 기존에 입력되어 있는 값을 변경함, WHERE 절은 생략가능하지만 안쓰는 경우 테이블의 전체 행의 내용이 변경됨!
  UPDATE test SET col1=1, col2=1.0, col3='test' WHERE id=1;
  -- id가 1인 데이터의 값을 SET 내용처럼 변경


-- DELETE
  -- 행 단위로 삭제함 WHERE을 사용하지 않으면 전체 행이 삭제 됨.
  -- 데이터는 지워지지만 테이블 용량은 줄어들지 않음 : 데이터가 복구되기 떄문
  -- 원하는 데이터만 WHERE을 사용해 지울 수 있음
  -- 삭제 후 잘못 삭제한 것을 되돌릴 수 있음

  DELETE FROM test WHERE id=1;

-- TRUNCATE 완전삭제!!!
  -- 용량이 줄어들고, 인덱스 등도 모두 삭제됨
  -- 테이블만 남고 데이터가 모두 삭제됨
  -- 한꺼번에 다 지우는 기능
  -- 삭제 후 !절대! 되돌릴 수 없음
  TRUNCATE TABLE test;


-- DROP TABLE
  -- 테이블 전체를 삭제, 공간, 객체를 삭제함
  -- 삭제 후 절대 되돌릴 수 없음
  DROP TABLE test;

-- DROP DATABASE
  -- 해당 데이터베이스를 삭제
  DROP DATABASE test;
  
