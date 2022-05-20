-- 현재 서버 DB List 조회  // SHOW
  SHOW DATABASES;


-- 사용할 DB 선택  // USE
  USE sample;


-- 선택한 데이터베이스의 테이블 정보 조회  // SHOW
  SHOW TABLE STATAUS;


-- 테이블에 무슨 열이 있는지 확인  // DESC
  -- 정식표현
    DESCRIBE sample;
  -- 약어
    DESC sample;


-- 요구하는 데이터를 가져옴  // SELECT
  -- 전체 정보를 불러올 때
    SELECT * FROM sample;
  
  -- 일부 정보(조건1, 조건2)의 정보의 전체 행을 불러올 때
    SELECT 조건1, 조건2 FROM sample;

  -- 일부 정보(조건1, 조건2)의 정보의 일부 조건(조건3)만 불러올 때 /
    SELECT 조건1, 조건2 FROM sample WHERE 조건3;

  -- 관계 연산자를 사용한 SELECT 문법
    -- OR
      SELECT * FROM sample WHERE 조건1 OR 조건2

    -- AND
      SELECT * FROM sample WHERE 조건1 AND 조건2

    -- 조건 연산자(=, <, >, <=, >=, <>, != 등)
      SELECT * FROM sample WHERE 조건 > 10 AND 조건 < 5;

    -- 관계 연산자(NOT, AND, OR 등 조합하여 활용
      SELECT * FROM sample WHERE CountryCode = 'KOR';
      SELECT * FROM sample WHERE CountryCode = 'KOR' AND Population >= 100000;

    -- BETWEEN... AND : 데이터가 숫자로 구성되어 있을 때 연속적인 값을 사용 가능
      SELECT * FROM sample WHERE Population BETWEEN 700 AND 800;
    -- IN : 이산적인 값의 조건에서 사용
      SELECT * FROM sample WHERE NAME IN ('Seoul', 'New York', 'Tokyo')
      SELECT * FROM sample WHERE CountryCode IN ('KOR', 'USA', 'JPN')

    -- LIKE : 문자열의 내용 검색
      -- 문자열% : 무엇이든 허용
      -- '_' 한글자와 매치하는 경우
      SELECT * FROM sample WHERE CountryCode LIKE 'KO_';
      SELECT * FROM sample WHERE name LIKE 'Tel %';

    -- 서브쿼리 SubQuery
      -- 쿼리문 안에 또 쿼리문이 들어 있는 것 / 서브쿼리의 결과가 둘 이상이 되면 에러 발생
        SELECT * FROM city WHERE CountryCode = (SELECT CountryCode FROM city WHERE NAME = 'Seoul')
        -- (city name이 'Seoul'인 CountryCode)
        -- 을 갖고 있는 city를 모두 출력

      -- ANY : 서브쿼리의 여러 개의 결과 중 한 가지만 만족해도 가능, ANY구문은 IN과 동일한 의미
      -- SOME : ANY와 동일한 의미로 사용
        SELECT * FROM city WHERE Population > ANY (SELECT Population FROM city WHERE District = 'New York')
        SELECT * FROM city WHERE Population > SOME (SELECT Population FROM city WHERE District = 'New York')
        -- ( city의 District가 'New York'인 Population) // 123, 543, 567
        -- 의 값들 중 하나라도 (123 or 543 or 567)보다 큰 Population을 갖고 있는 행을 모두 출력

      -- ALL : 서브쿼리의 여러 개의 결과를 모두 만족시켜야 함
        SELECT * FROM city WHERE Population > ALL (SELECT Population FROM city WHERE District = 'New York')
        -- ( city의 District가 'New York'인 Population) // 123, 543, 567
        -- 의 값들 전부(123 and 543 and 567)보다 큰 Population을 갖고 있는 행을 모두 출력

      -- ORDER BY : 결과가 출력되는 순서를 조절하는 구문
        -- 기본적으로 오름차순 (ASCENFING)으로 정렬 약어 : ASC // 기본값이라 생략가능
        -- 내림차순 (DESENDING)으로 정렬시 열이름 뒤에 DESC(약어)를 적어줘야함
        SELECT * FROM city ORDER BY Population DESC;
        -- 인구수를 내림차순으로 출력

        SELECT * FROM city ORDER BY CountyCode ASC, Population DESC;
        -- CountyCode는 오름차순, Population는 내림차순

        SELECT * FROM city WHERE CountyCode = "KOR" ORDER BY Population DESC;
        -- 인구수로 내림차순하여 한국에 있는 도시 조회

        SELECT * FROM country ORDER BY SurfaseArea DESC;
        -- 국가면적 크기로 내림차순하여 나라 조회


      -- DISTINCT : 중복된 것은 1개씩만 출력, 테이블의 크기가 클수록 효율적
        SELECT DISTINCT CountryCode FROM city;

      -- LIMIT : 출력 개수를 제한 / 상위 N개만 출력 = LIMIT N // 서버의 처리량을 많이 사용해 서버의 전반적인 성능을 나쁘게하는 악성 쿼리문 개선시 사용
        SELECT * FROM city ORDER BY Population DECS LIMIT 10;
        -- 인구수 내림차순 기준 상위 10개의 도시 조회

      -- GROUP BY : 그룹으로 묶어주는 역할, 집계함수를 함께 사용
        -- AVG() : 평균
        -- MIN() : 최소값
        -- MAX() : 최대값
        -- COUNT() : 행의 개수
        -- COUNT(DISTINCT) : 중복제외 행의 개수
        -- STDEV : 표준편차
        -- VARIANCE() : 분산
      
        SELECT CountryCode, MAX(Population) AS'Max' FROM city GROUP BY CountryCode;
        -- CountryCode로 묶고, Population가 가장 MAX한 city 출력하되 명칭을 'Max'로 변경하여 출력
        SELECT COUNT(*) FROM city
        -- city 의 전체의 개수를 조회
        SELECT AVG(Population) * FROM city
        -- city의 평균 인구수 조회

      -- HAVING : WHERE과 비슷한 개념, 집계함수에 대해 조건제한, !반드시 GROUP BY 바로 뒤에 사용해야함!
        SELECT CountryCode, MAX(Population) FROM city GROUP BY CountryCode HAVING MAX(Population) > 80000000;
        -- Population이 800만 이상인 도시의 국가코드를 조회 (MAX(Population) 같이 출력됨

      -- ROLLUP : 총합 또는 중간합계가 필요할 경우 사용
      -- GROUP BY절과 함께 WHITH ROLLUP문 사용
        SELECT CountryCode, NAME,  SUM(Population) FROM city GROUP BY CountryCode, NAME WHIT ROLLUP;
        -- 인구수의 합계를 계산하는 표(국가코드, 도시이름, 인구수)를 그려, 값의 총계를 각 그룹코드마다 표시

      -- JOIN : 데이터베이스 내 여러테이블에서 가져온 레코드를 조합해 하나의 테이블 혹은 결과로 표현
        SELECT * FROM city JOIN country ON city.CountryCode = country.code;
        -- city의 CountryCode와 country의 code가 같은 것을 기준으로 JOIN하여 출력

        SELECT * FROM city JOIN country ON city.CountryCode = country.code JOIN countrylanguage ON city.countryCode = countrylanguage.CountryCode;
        -- city의 CountryCode와 country의 code가, 그리고 city의 CountryCode와 countrylanguage의 CountryCode가 같은 것을 기준으로 JOIN하여 출력

-- MySQL 내장함수
  -- 문자열 함수
    -- LENGTH() : 문자열의 갯수 조회
    SELECT LENGHT('12345678'); -- 8

    -- CONCAT() : 전달받은 문자열을 모두 결합하여 하나의 문자열로 반환 / 전달받은 문자열 중 하나라도 NULL이 존재하면 NULL을 반환함
    SELECT CONCAT('My', 'Sql'); --'MySql'

    -- LOCATE() : 문자열 내에서 찾는 문자열이 처음으로 나타나는 위치를 찾아 반환 / 찾는 문자열이 없으면 0 반환 / 시작 인덱스를 1부터 계산
    SELECT LOCATE('abc', 'abababABCDabab'); -- 
    
    -- LEGT(), RIGHT() : 문자열의 왼(오른)쪽부터 지정한 값만큼의 문자를 반환
    SELECT
    LEFT('MySQL is an open souce relational batabase management system', 5),
    RIGHT('MySQL is an open souce relational batabase management system', 5); -- MySQL, system 출력

    -- LOWER(), UPPER() : 문자열의 문자를 소/대문자로 변경
    SELECT
    LOWER('MySQL is an open souce relational batabase management system', 5),
    UPPER('MySQL is an open souce relational batabase management system', 5);

    -- REPLACE() : 문자열에서 특정 문자열을 대체 문자열로 교체
    SELECT REPLACE('MSSQL', 'MS', 'My'); -- 'MySQL' // 'MYSQL'이라는 문자열 중 'MS'를 'MY'로 변경

    -- TRIM() : 문자열의 앞이나 뒤 또는 양쪽 모두에 있는 특정 문자를 제거
      -- TRIM()함수에서 사용할 수 있는 지정자 종류
        -- BOTH : 전달받은 문자열의 양 끝에 존재하는 특정 문자를 제거 ( 기본설정 ) // 지정자 없을 시 자동지정 됨
        SELECT TRIM('      MySQL       '); -- 'MySQL'

        -- LEADING  : 전달받은 문자열 앞에 존재하는 특정 문자를 제거
        SELECT TRIM(LEADING '#' FROM '####MySQL####'); -- 'MySQL####'

        -- TRAILING : 전달받은 문자열 뒤에 존재하는 특정 문자를 제거
        SELECT TRIM(TRAILING '#' FROM '####MySQL####'); -- '####MySQL'

    -- FORMAT() : 숫자 타입의 데이터를 세자리마다 쉼표를 사용하는' #,###,###.##' 형식으로 변환
        -- 반환되는 데이터의 형식은 문자열 타입이며 두번째 인수는 반올림할 소수 자릿수 입력
    SELECT FOMAT(123456789.123456, 3); -- '123,456,789.123'
    
    -- FLOOR() : 내림 / CEIL() : 올림 / ROUND() : 반올림
    SELECT FLOOR(10.95), CEIL(10.95), ROUNG(10.95) -- 10, 11, 11

  -- 수학 함수
    -- SQRT() : 양의 제곱근
    -- POW() : 첫번째 인수로는 밑수를 전달하고, 두번째 인수로는 지수를 전달하여 거듭제곱 계산
    -- EXP() : 인수로 지수를 전달받아, e의 거듭제곱을 계산
    -- LOG() : 자연로그 값을 계산

    SELECT SQRT(4), POW(2,3), EXP(3), LOG(3); -- 2, 8, 20.0855.., 1.0986... 출력

    -- SIN() : 사인값 반환
    -- COS() : 코사인값 반환
    -- TAN() : 탄젠트값 반환
    SELECT SIN(PI()/2), COS(PI()), TAN(PI()/4); -- 1, -1, 0.99999.... 출력

    -- ABS() : 절대값 반환
    -- RAND() : 0.0보다 크거나 같고 1.0보다 작은 하나의 실수를 무작위로 생성
    SELECT ABS(-3), RAND(), ROUND(RAND()*100, 0); -- 3, 0.42045435(랜덤값), 58(랜덤값) 출력 됨

  -- 날짜 / 시간 함수
    -- NOW() : 현재 날짜와 시간을 반환, 'YYYY-MM-DD HH:MM:SS' 형식 또는 YYYYMMDDHHMMSS형태로 반환
    -- CURDATE() : 현재 날짜를 반환, 'YYYY-MM-DD' 또는 YYYYMMDD 형태로 반환
    -- CURTIME() : 현재 시각을 반환, 'HH:MM:SS' 또는 HHMMSS 형태로 반환
    SELECT NOW(), CURDATE(), CURTIME(); --2022-05-19 12:44:12, 2022-05-19, 12:44:12 반환

    -- DATE() : 전달받은 값에 해당하는 날짜정보 반환
    -- MONTH() : 월에 해당하는 값을 반환, 0~12 사이 값을 가짐
    -- DAY() : 일에 해당하는 값을 반환, 0~31 사이 값을 가짐
    -- HOUR() : 시간에 해당하는 값 반환, 0~23 사이 값을 가짐
    -- MINUTE() : 분에 해당하는 값 반환, 0~59 사이 값을 가짐
    SELECT DATE(NOW()), MONTH(NOW()), DAY(NOW()), HOUR(NOW()), MINUTE(NOW()); -- 2022-05-19, 5, 19, 12, 44, 12

    -- MONTHNAME() : 월에 해당하는 이름 반환
    -- DAYNAME() : 요일에 해당하는 이름 반환
    SELECT NOW(), MONTHNAME(NOW()), DAYNAME(NOW()); -- -- 2022-05-20, May, Friday

    -- DAYOFMONTH() : 일자가 해당 주에서 몇번째 날인지를 반환, 1~7 반환, (일=1 토=7)
    -- DAYOFWEEK() : 일자가 해당 월에서 몇 번째 날인지 반환, 0~31 반환
    -- DAYOFYEAR() : 일자가 해당 연도에서 몇번째 날인지를 반환, 1~366 반환
    SELECT NOW(), DAYOFMONTH(NOW()), DAYOFWEEK(NOW()), DAYOFYEAR(NOW()); -- '2022-05-20 09:23:04', '20', '6', '140'

    -- DATE_FORMAT() : 전달받은 형식에 맞춰 날짜와 숫자 정보를 문자열로 반환
    SELECT DATE_FORMAT(NOW(), '%D %y %a %d %n %j'); -- 20th 22 Fri 20 n 140

    