DROP TABLE IF EXISTS `author`;
CREATE TABLE `author` (
  `aid` int(11) NOT NULL,
  `name` varchar(10) DEFAULT NULL,
  `city` varchar(10) DEFAULT NULL,
  `profile_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`aid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT INTO `author` VALUES (1,'egoing','seoul',1),(2,'leezche','jeju',2),(3,'blackdew','namhae',3);
 
DROP TABLE IF EXISTS `profile`;
CREATE TABLE `profile` (
  `pid` int(11) NOT NULL,
  `title` varchar(10) DEFAULT NULL,
  `description` tinytext,
  PRIMARY KEY (`pid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT INTO `profile` VALUES (1,'developer','developer is ...'),(2,'designer','designer is ..'),(3,'DBA','DBA is ...');
 
DROP TABLE IF EXISTS `topic`;
CREATE TABLE `topic` (
  `tid` int(11) NOT NULL,
  `title` varchar(45) DEFAULT NULL,
  `description` tinytext,
  `author_id` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`tid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT INTO `topic` VALUES (1,'HTML','HTML is ...','1'),(2,'CSS','CSS is ...','2'),(3,'JavaScript','JavaScript is ..','1'),(4,'Database','Database is ...',NULL);

-- LEFT OUTER JOIN --

-- (1) 2개 테이블 JOIN --
SELECT * FROM topic
LEFT JOIN author ON
topic.author_id = author.aid;

-- (2) 3개 테이블 JOIN --
SELECT * FROM topic
LEFT JOIN author ON
topic.author_id = author.aid
LEFT JOIN profile ON
author.aid = profile.pid;

-- (3) 2에서 원하는 Column을 별명으로 출력 --
SELECT tid, topic.title, author_id, name, profile.title AS job_title FROM topic
LEFT JOIN author ON
topic.author_id = author.aid
LEFT JOIN profile ON
author.aid = profile.pid;


-- (4) 3에서 원하는 값의 Row만 출력 --
SELECT tid, topic.title, author_id, name, profile.title AS job_title FROM topic
LEFT JOIN author ON
topic.author_id = author.aid
LEFT JOIN profile ON
author.aid = profile.pid
WHERE aid = 1;

-- INNER JOIN --

-- (1) 2개 테이블 JOIN --
SELECT * FROM topic
INNER JOIN author ON
topic.author_id = author.aid;

-- (2) 3개 테이블 JOIN
SELECT * FROM topic
INNER JOIN author ON
topic.author_id = author.aid
INNER JOIN profile ON
author.aid = profile.pid;

-- FULL OUTER JOIN --

(
SELECT * FROM topic
LEFT JOIN author ON
topic.author_id = author.aid
)
UNION DISTINCT
(
SELECT * FROM topic
RIGHT JOIN author ON
topic.author_id = author.aid
);

-- EXCLUSIVE JOIN --
SELECT * FROM topic
LEFT JOIN author
ON topic.author_id = author.aid
WHERE author_id is NULL;


-- CROSS JOIN --
SELECT Atable, Btable     
FROM NewAtable     
CROSS JOIN NewBtable


SELECT *
FROM TableA107
CROSS JOIN TableB27;

