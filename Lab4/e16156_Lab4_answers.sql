-- Question 1
USE company;

-- Question 1.1
SELECT * FROM departments;

-- Question 1.2
 START TRANSACTION;
 
-- Question 1.3
INSERT INTO departments
VALUES ('d010', 'Mechanical');

-- Question 1.4
-- Question 1.5

-- Question 3
CREATE DATABASE book_shop;

USE book_shop;

CREATE TABLE books (
book_ID int,
book_code char(4),
book_name varchar(40),
book_price DECIMAL(10,2),
primary key (bookID)
);

INSERT INTO books VALUES 
(001,'NOVEL',"Pilgrim's Progress",500.00),
(002,'NOVEL','Robinson Crusoe',1500.00),
(003,'NOVEL','Clarissa',1300.00),
(004,'NOVEL','Tom Jones',2500.00);

SELECT * FROM books;

update books set book_price = 1.5*book_price where book_ID=001;

select * from books where book_ID=001;

update books set book_price = 1.7*book_price where book_ID=002;

select * from books where book_ID=002;

