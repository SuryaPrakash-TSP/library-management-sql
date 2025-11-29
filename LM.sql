-- ------------------------------------------------------
-- LIBRARY MANAGEMENT SYSTEM - SQL PROJECT
-- ------------------------------------------------------

-- 1. CREATE DATABASE
CREATE DATABASE IF NOT EXISTS LibraryDB;
USE LibraryDB;

-- 2. TABLES
----------------------------------------------------------

-- MEMBERS TABLE
CREATE TABLE Members (
    member_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    joined_date DATE
);

-- BOOKS TABLE
CREATE TABLE Books (
    book_id INT PRIMARY KEY,
    title VARCHAR(200),
    author VARCHAR(100),
    category VARCHAR(50),
    total_copies INT,
    available_copies INT
);

-- ISSUE TABLE
CREATE TABLE Issue (
    issue_id INT PRIMARY KEY,
    member_id INT,
    book_id INT,
    issue_date DATE,
    due_date DATE,
    return_date DATE,
    FOREIGN KEY (member_id) REFERENCES Members(member_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
);

-- 3. INSERT SAMPLE DATA
----------------------------------------------------------

INSERT INTO Members VALUES
(1, 'Arun Kumar', 'arun@gmail.com', '9876543210', '2023-01-01'),
(2, 'Divya R', 'divya@gmail.com', '9876500001', '2023-02-10'),
(3, 'Ravi Shankar', 'ravi@gmail.com', '9876512345', '2023-04-12');

INSERT INTO Books VALUES
(101, 'The Alchemist', 'Paulo Coelho', 'Fiction', 10, 10),
(102, 'Atomic Habits', 'James Clear', 'Self-Help', 8, 8),
(103, 'Clean Code', 'Robert C. Martin', 'Programming', 5, 5),
(104, 'Data Structures in C', 'Narasimha Karumanchi', 'Programming', 6, 6);

INSERT INTO Issue VALUES
(1, 1, 101, '2024-11-01', '2024-11-15', NULL),
(2, 2, 103, '2024-11-02', '2024-11-16', '2024-11-10'),
(3, 3, 102, '2024-11-05', '2024-11-19', NULL);

-- 4. IMPORTANT SQL QUERIES
----------------------------------------------------------

-- 1. List all books
SELECT * FROM Books;

-- 2. Members who joined recently
SELECT name, joined_date 
FROM Members 
ORDER BY joined_date DESC;

-- 3. Books that are currently issued (not returned)
SELECT m.name, b.title, i.issue_date 
FROM Issue i
JOIN Members m ON i.member_id = m.member_id
JOIN Books b ON i.book_id = b.book_id
WHERE i.return_date IS NULL;

-- 4. Count total books issued
SELECT COUNT(*) AS total_books_issued FROM Issue;

-- 5. Most issued books
SELECT b.title, COUNT(i.book_id) AS times_taken
FROM Issue i
JOIN Books b ON i.book_id = b.book_id
GROUP BY b.book_id
ORDER BY times_taken DESC;

-- 6. Members who have overdue books
SELECT m.name, b.title, i.due_date
FROM Issue i
JOIN Members m ON i.member_id = m.member_id
JOIN Books b ON i.book_id = b.book_id
WHERE i.return_date IS NULL AND i.due_date < CURDATE();

-- 7. Total books per category
SELECT category, COUNT(*) AS total_books
FROM Books
GROUP BY category;

-- 8. Members with most borrowings
SELECT m.name, COUNT(i.issue_id) AS total_issues
FROM Members m
JOIN Issue i ON m.member_id = i.member_id
GROUP BY m.member_id
ORDER BY total_issues DESC;

-- 9. Available books
SELECT title, available_copies 
FROM Books 
WHERE available_copies > 0;

-- 10. All overdue books count
SELECT COUNT(*) AS overdue_count
FROM Issue
WHERE due_date < CURDATE() AND return_date IS NULL;

-- 5. VIEW CREATION
----------------------------------------------------------
CREATE VIEW overdue_books AS
SELECT m.name AS member, b.title AS book, i.due_date
FROM Issue i
JOIN Members m ON i.member_id = m.member_id
JOIN Books b ON i.book_id = b.book_id
WHERE i.return_date IS NULL AND i.due_date < CURDATE();

-- 6. TRIGGER (When a book is issued, reduce available copies)
----------------------------------------------------------
DELIMITER $$
CREATE TRIGGER reduce_book_stock
AFTER INSERT ON Issue
FOR EACH ROW
BEGIN
    UPDATE Books
    SET available_copies = available_copies - 1
    WHERE book_id = NEW.book_id;
END $$
DELIMITER ;
