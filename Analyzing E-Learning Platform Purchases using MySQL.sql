-- CREATE DATABASE
create database elearning;
use elearning;
-- CREATE TABLE learners
create table learners (
    learner_id int primary key auto_increment,
    full_name varchar(100),
    country varchar(50)
);
-- CREATE TABLE courses
create table courses (
    course_id int primary key auto_increment,
    course_name varchar(150),
    category varchar(100),
    unit_price decimal(10,2)
);
-- CREATE TABLE purchases
create table purchases (
    purchase_id int primary key auto_increment,
    learner_id int,
    course_id int,
    quantity int,
    purchase_date date,
    foreign key (learner_id) references learners(learner_id),
    foreign key (course_id) references courses(course_id)
);

-- INSERT SAMPLE DATE
insert into learners (full_name, country)
values
('arun kumar', 'india'),
('priya sharma', 'india'),
('john smith', 'usa'),
('sara lee', 'uk'),
('david miller', 'canada');
insert into courses (course_name, category, unit_price)
values
('power bi masterclass', 'data analytics', 5000),
('python for beginners', 'programming', 4000),
('aws cloud basics', 'cloud computing', 6000),
('seo fundamentals', 'digital marketing', 3000),
('advanced sql', 'data analytics', 4500);
insert into purchases
(learner_id, course_id, quantity, purchase_date)
values
(1, 1, 1, '2025-04-01'),
(1, 5, 1, '2025-04-05'),
(2, 2, 2, '2025-04-10'),
(3, 3, 1, '2025-04-12'),
(4, 4, 3, '2025-04-15'),
(5, 2, 1, '2025-04-18'),
(2, 1, 1, '2025-04-20'),
(3, 5, 2, '2025-04-22');

-- Data Exploration Using Joins
-- ●	Format currency values to 2 decimal places.
select
    p.purchase_id,
    l.full_name,
    c.course_name,
    c.category,
    p.quantity,
    format(c.unit_price, 2) as unit_price,
    format(c.unit_price * p.quantity, 2) as total_amount,
    p.purchase_date
from purchases p
join learners l
on p.learner_id = l.learner_id
join courses c
on p.course_id = c.course_id;
-- ●	Use aliases for column names (e.g., AS total_revenue).
select
    l.full_name as learner_name,
    c.course_name as purchased_course,
    c.category as course_category,
    p.quantity as quantity_bought,
    format(c.unit_price, 2) as unit_price,
    format(c.unit_price * p.quantity, 2) 
    as total_revenue,
    p.purchase_date as purchase_date
from purchases p
join learners l
on p.learner_id = l.learner_id
join courses c
on p.course_id = c.course_id;

-- ●	Sort results appropriately (e.g., highest total_spent first).
select
    l.full_name as learner_name,
    c.course_name as purchased_course,
    c.category as course_category,
    p.quantity as quantity_bought,
    format(c.unit_price, 2) as unit_price,
    format(c.unit_price * p.quantity, 2)
    as total_spent,
    p.purchase_date
from purchases p
join learners l
on p.learner_id = l.learner_id
join courses c
on p.course_id = c.course_id
order by (c.unit_price * p.quantity) desc;

-- Use SQL INNER JOIN, LEFT JOIN, and RIGHT JOIN to:
-- •	Combine learner, course, and purchase data.
-- INNER JOIN
select
    l.full_name as learner_name,
    c.course_name,
    c.category,
    p.quantity,
    p.purchase_date
from purchases p
inner join learners l
on p.learner_id = l.learner_id
inner join courses c
on p.course_id = c.course_id;
-- LEFT JOIN
select
    l.full_name as learner_name,
    c.course_name,
    p.quantity,
    p.purchase_date
from learners l
left join purchases p
on l.learner_id = p.learner_id
left join courses c
on p.course_id = c.course_id;
-- RIGHT JOIN
select
    l.full_name as learner_name,
    c.course_name,
    c.category,
    p.quantity
from purchases p
right join courses c
on p.course_id = c.course_id
left join learners l
on p.learner_id = l.learner_id;



-- ●	Display each learner’s purchase details (course name, category, quantity, total amount, and purchase date).
-- INNER JOIN
select
    l.full_name as learner_name,
    c.course_name,
    c.category,
    p.quantity,
    format(c.unit_price * p.quantity, 2)
    as total_amount,
    p.purchase_date
from purchases p
inner join learners l
on p.learner_id = l.learner_id
inner join courses c
on p.course_id = c.course_id;

-- LEFT JOIN
select
    l.full_name as learner_name,
    c.course_name,
    c.category,
    p.quantity,
    format(c.unit_price * p.quantity, 2)
    as total_amount,
    p.purchase_date
from learners l
left join purchases p
on l.learner_id = p.learner_id
left join courses c
on p.course_id = c.course_id;

-- RIGHT JOIN
select
    l.full_name as learner_name,
    c.course_name,
    c.category,
    p.quantity,
    format(c.unit_price * p.quantity, 2)
    as total_amount,
    p.purchase_date
from purchases p
right join courses c
on p.course_id = c.course_id
left join learners l
on p.learner_id = l.learner_id;

-- Analytical Queries
-- Q1. Display each learner’s total spending (quantity × unit_price) along with their country.
select
    l.full_name as learner_name,
    l.country,
    format(sum(p.quantity * c.unit_price), 2)
    as total_spending
from learners l
join purchases p
on l.learner_id = p.learner_id
join courses c
on p.course_id = c.course_id
group by l.full_name, l.country
order by sum(p.quantity * c.unit_price) desc;
-- Q2. Find the top 3 most purchased courses based on total quantity sold.
select
    c.course_name,
    c.category,
    sum(p.quantity) as total_quantity_sold
from purchases p
join courses c
on p.course_id = c.course_id
group by c.course_name, c.category
order by total_quantity_sold desc
limit 3;
-- Q3. Show each course category’s total revenue and the number of unique learners who purchased from that category.
select
    c.category,
    format(sum(p.quantity * c.unit_price), 2)
    as total_revenue,
    count(distinct p.learner_id)
    as unique_learners
from purchases p
join courses c
on p.course_id = c.course_id
group by c.category
order by sum(p.quantity * c.unit_price) desc;
-- Q4. List all learners who have purchased courses from more than one category.
select
    l.full_name as learner_name,
    l.country,
    count(distinct c.category)
    as categories_purchased
from learners l
join purchases p
on l.learner_id = p.learner_id
join courses c
on p.course_id = c.course_id
group by l.full_name, l.country
having count(distinct c.category) > 1;
-- Q5. Identify courses that have not been purchased at all.
select
    c.course_name,
    c.category,
    format(c.unit_price, 2) as unit_price
from courses c
left join purchases p
on c.course_id = p.course_id
where p.purchase_id is null;














