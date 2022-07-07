-- 1. 박지성의 총 구매액
SELECT SUM(saleprice) FROM Orders WHERE custid = (
SELECT custid FROM Customer WHERE name = "박지성" );

2. 박지성이 구매한 도서의 수

SELECT COUNT(bookid) FROM Orders WHERE custid = (
SELECT custid FROM Customer WHERE name = "박지성" );

3. 박지성이 구매한 도서의 출판사 총 수~ 
  [조건] 중복된 출판사가 있다면 중복은 제거하고 계산합니다.
  ( A출판사,B출판사,B출판사 책을 산 경우는 총 2개!)

SELECT COUNT(DISTINCT publisher) FROM Book WHERE bookid IN ( 
SELECT bookid FROM Orders WHERE custid = (
SELECT custid FROM Customer WHERE name = "박지성"));

4. 박지성이 구매한 도서의 이름, 가격, 정가와 판매가격의 차이 
SELECT Book.bookname, Book.price, (Book.price - Orders.saleprice) AS margin
FROM Customer, Orders, Book
WHERE Customer.custid = Orders.custid
AND Orders.bookid = Book.bookid
AND Customer.name = "박지성";

5. 박지성이 구매하지 않은 도서의 이름
SELECT DISTINCT Book.bookname
FROM Customer, Orders, Book
WHERE Customer.custid = Orders.custid
AND Orders.bookid = Book.bookid
AND Customer.name != "박지성"

6. 2014년 7월 4일 ~ 7월 7일 사이에 주문 받은 도서의 주문번호
SELECT Orders.orderid FROM Orders
WHERE orderdate BETWEEN "2014-07-04" AND "2014-07-07";

7. 2014년 7월 4일 ~ 7월 7일 사이에 주문받은 도서를 제외한 도서의 주문번호
SELECT Orders.orderid FROM Orders
WHERE orderdate NOT BETWEEN "2014-07-04" AND "2014-07-07";
  

8. 성이 '김'씨인 고객의 이름과 주소
SELECT name, address FROM Customer WHERE name LIKE "김%";


9. 성이 '김'씨이고 이름이 '아'로 끝나는 고객의 이름과 주소
SELECT name, address FROM Customer WHERE name LIKE "김%아";
  

10. 주문하지 않는 고객의 이름  
SELECT name FROM Customer WHERE custid NOT IN (SELECT custid FROM Orders);


11. 박지성 고객의 2014년도의 주문 총금액의 평균금액을 출력
SELECT AVG(saleprice) FROM Orders, Customer
WHERE Orders.custid = Customer.custid
AND Customer.name = "박지성"
AND YEAR(Orders.orderdate)="2014";
 

12. 고객의 이름과 고객별 구매액 

    [조건] 구매내역이 없는사람은 0으로 출력 
    구매액이 높은순으로 정렬 

SELECT name, ifnull(sum(saleprice),0) FROM Customer
LEFT JOIN Orders
ON Customer.custid = Orders.custid
GROUP BY Customer.name
ORDER BY 2 DESC;

  
13. 고객의 이름과 고객별 구매액 중 상위 2개의 데이터만 보입니다.

( 고객별로 구매액을 산출하여 구매액이 가장 많은 상위 2명에 대한 데이터를 구하는 문제입니다 ) 
SELECT name, ifnull(sum(saleprice),0) FROM Customer
LEFT JOIN Orders
ON Customer.custid = Orders.custid
GROUP BY Customer.name
ORDER BY 2 DESC LIMIT 2;


14. 2번 이상 구매를 한 이력이 있는 고객 명단을 구하세요. 

[조건] 고객번호, 이름, 구매 횟수를 나열합니다. 
구매 횟수가 많은 사람이 제일 위에 보이게 합니다. 
SELECT Customer.custid, name, COUNT(name) AS "구매횟수"
FROM Customer
INNER JOIN Orders
ON Customer.custid = Orders.custid
GROUP BY custid
ORDER BY 3 DESC;


15. 정가가 가장 비싼 책을 산 고객 이름

-- 정가 중 가장 비싼 책이 35000원 골프바이블이나
-- 구매가 이뤄지지 않았음


16.  도서의 가격(Book 테이블)과 판매가격(Orders 테이블)의 차이가 가장 많은 주문,
주문번호, 도서가격-판매가격을 검색
SELECT Orderid, price, saleprice, (price-saleprice) AS "도서가격-판매가격"
FROM Book, Orders
WHERE Book.bookid = Orders.bookid
AND Book.price-Orders.saleprice = (
SELECT max(Book.price-Orders.saleprice)
FROM Book, Orders
WHERE Book.bookid = Orders.bookid
);
    

17. 도서의 판매액 평균보다 자신의 구매액 평균이 더 높은 고객의 이름
select name
from customer t1, orders t2
where t1.custid = t2.custid
group by name
having avg(saleprice) > (select avg(t3.saleprice) from orders t3);
     

18. 박지성이 구매한 도서의 출판사와 같은 출판사에서 도서를 구매한 고객의 이름

           

19. 두 개 이상의 서로 다른 출판사에서 도서를 구매한 고객의 이름
SELECT DISTINCT Customer.name
FROM Customer, Orders, Book
WHERE Customer.custid =Orders.custid
AND Book.bookid = Orders.bookid
GROUP BY Customer.NAME
HAVING COUNT(DISTINCT publisher) >= 2;
 

20. 전체 고객의 30% 이상이 구매한 도서