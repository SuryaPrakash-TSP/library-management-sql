Library Management System — SQL Project

This project is a straightforward SQL-based Library Management System.
It is designed mainly for learning, practicing SQL, and adding to your GitHub portfolio for placements.
The project shows how to design tables, link them using foreign keys, write useful queries, create views, and work with triggers.

⭐ Features

Store and manage information about library members

Maintain book details, categories, and stock

Track which member has taken which book

Identify overdue books

A trigger that updates the available book stock whenever a book is issued

Several SQL queries that help analyse the data (most issued book, recent members, etc.)

🗂️ Database Structure
Tables Used

Members
Stores basic details of each member such as name, email, phone, and joining date.

Books
Contains information about each book including title, author, category, and the number of copies.

Issue
Records the books issued to members with dates and return status.

🔗 Relationships (Simple Explanation)

Each entry in the Issue table is linked to:

A Member (via member_id)

A Book (via book_id)

This means:

One member can borrow many books

One book can be borrowed multiple times

But every issue record always belongs to one member and one book
