Create Database DBCompany;
USE DBCompany ;

--SQL Table Creation (DDL)

-- Trainee Table
CREATE TABLE Trainee (
    trainee_id INT PRIMARY KEY,
    name NVARCHAR(50),
    gender NVARCHAR(10),
    email NVARCHAR(100),
    background NVARCHAR(50)
);

-- Trainer Table
CREATE TABLE Trainer (
    trainer_id INT PRIMARY KEY,
    name NVARCHAR(50),
    specialty NVARCHAR(50),
    phone VARCHAR(20),
    email NVARCHAR(100)
);

-- Course Table
CREATE TABLE Course (
    course_id INT PRIMARY KEY,
    title NVARCHAR(100),
    category NVARCHAR(50),
    duration_hours INT,
    level NVARCHAR(20)
);

-- Schedule Table
CREATE TABLE Schedule (
    schedule_id INT PRIMARY KEY,
    course_id INT,
    trainer_id INT,
    start_date DATE,
    end_date DATE,
    time_slot NVARCHAR(20),
    FOREIGN KEY (course_id) REFERENCES Course(course_id),
    FOREIGN KEY (trainer_id) REFERENCES Trainer(trainer_id)
);

-- Enrollment Table
CREATE TABLE Enrollment (
    enrollment_id INT PRIMARY KEY,
    trainee_id INT,
    course_id INT,
    enrollment_date DATE,
    FOREIGN KEY (trainee_id) REFERENCES Trainee(trainee_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id)
);

--- Sample Data Insertion (DML) 
-- Trainee Data
INSERT INTO Trainee VALUES 
(1, 'Aisha Al-Harthy', 'Female', 'aisha@example.com', 'Engineering'),
(2, 'Sultan Al-Farsi', 'Male', 'sultan@example.com', 'Business'),
(3, 'Mariam Al-Saadi', 'Female', 'mariam@example.com', 'Marketing'),
(4, 'Omar Al-Balushi', 'Male', 'omar@example.com', 'Computer Science'),
(5, 'Fatma Al-Hinai', 'Female', 'fatma@example.com', 'Data Science');

-- Trainer Data
INSERT INTO Trainer VALUES 
(1, 'Khalid Al-Maawali', 'Databases', '96891234567', 'khalid@example.com'),
(2, 'Noura Al-Kindi', 'Web Development', '96892345678', 'noura@example.com'),
(3, 'Salim Al-Harthy', 'Data Science', '96893456789', 'salim@example.com');

-- Course Data
INSERT INTO Course VALUES 
(1, 'Database Fundamentals', 'Databases', 20, 'Beginner'),
(2, 'Web Development Basics', 'Web', 30, 'Beginner'),
(3, 'Data Science Introduction', 'Data Science', 25, 'Intermediate'),
(4, 'Advanced SQL Queries', 'Databases', 15, 'Advanced');

-- Schedule Data
INSERT INTO Schedule VALUES 
(1, 1, 1, '2025-07-01', '2025-07-10', 'Morning'),
(2, 2, 2, '2025-07-05', '2025-07-20', 'Evening'),
(3, 3, 3, '2025-07-10', '2025-07-25', 'Weekend'),
(4, 4, 1, '2025-07-15', '2025-07-22', 'Morning');

-- Enrollment Data
INSERT INTO Enrollment VALUES 
(1, 1, 1, '2025-06-01'),
(2, 2, 1, '2025-06-02'),
(3, 3, 2, '2025-06-03'),
(4, 4, 3, '2025-06-04'),
(5, 5, 3, '2025-06-05'),
(6, 1, 4, '2025-06-06');

----------------------------------
--Query Challenges :
----------------------------------

--Trainee Perspective :
-----------------------
--1)Showing all available courses (title, level, category)

SELECT c.title, c.level, c.category
FROM Course AS c;

--2)View beginner-level Data Science courses 
-- Filter to show beginner courses in Data Science track
SELECT
    title, category, level
FROM
    Course
WHERE
    category = 'Data Science'
    AND level IN ('Beginner');

--3) Show courses this trainee is enrolled in 
-- List the names of all courses trainee ID 1 is signed up for
SELECT
    Course.title
FROM
    Enrollment
    INNER JOIN Course ON Enrollment.course_id = Course.course_id
WHERE
    Enrollment.trainee_id = 1;

--4)View the schedule (start_date, time_slot) for the trainee's enrolled courses
-- Get time and date details for trainee ID 1's enrolled courses
SELECT
    s.start_date,
    s.time_slot
FROM
    Schedule s
    JOIN Enrollment e ON s.course_id = e.course_id
WHERE
    e.trainee_id = 1;
--5) Count how many courses the trainee is enrolled in 
-- Total courses taken by trainee 1
SELECT
    trainee_id,
    COUNT(course_id) AS total_courses
FROM
    Enrollment
GROUP BY
    trainee_id
HAVING
    trainee_id = 1;

--6) Show course titles, trainer names, and time slots the trainee is attending 
-- Show trainee 1's attended courses with trainer and schedule slot
SELECT
    co.title AS course,
    tr.name AS instructor,
    sc.time_slot
FROM
    Enrollment AS en
    JOIN Course AS co ON en.course_id = co.course_id
    JOIN Schedule AS sc ON sc.course_id = co.course_id
    JOIN Trainer AS tr ON tr.trainer_id = sc.trainer_id
WHERE
    en.trainee_id = 1;
-----------------------------------------------

--Trainer Perspective :
----------------------
 
--1. List all courses the trainer is assigned to 
-- Get names of all courses the trainer is currently assigned to teach
SELECT 
    crs.title AS assigned_course
FROM 
    Schedule sch,
    Course crs
WHERE 
    sch.course_id = crs.course_id
    AND sch.trainer_id = 1;

--2. Show upcoming sessions (with dates and time slots)
-- Show session schedules for trainer 1 starting after today
SELECT 
    start_date AS begins_on,
    end_date AS ends_on,
    time_slot
FROM 
    Schedule
WHERE 
    trainer_id = 1
    AND start_date > CAST(GETDATE() AS DATE);
--3. See how many trainees are enrolled in each of your courses 
-- Number of trainees per course assigned to trainer 1
SELECT 
    co.title,
    COUNT(DISTINCT en.trainee_id) AS trainee_count
FROM 
    Course co
JOIN Schedule sc ON co.course_id = sc.course_id
LEFT JOIN Enrollment en ON co.course_id = en.course_id
WHERE 
    sc.trainer_id = 1
GROUP BY 
    co.title;

--4. List names and emails of trainees in each of your courses 

-- Show enrolled trainee details for the trainer's courses
SELECT 
    trn.name AS trainee_name,
    trn.email AS trainee_email,
    cr.title AS course_name
FROM 
    Trainer t
JOIN Schedule s ON t.trainer_id = s.trainer_id
JOIN Course cr ON cr.course_id = s.course_id
JOIN Enrollment en ON en.course_id = cr.course_id
JOIN Trainee trn ON trn.trainee_id = en.trainee_id
WHERE 
    t.trainer_id = 1;

--5. Show the trainer's contact info and assigned courses 
-- Provide trainer's contact and list of assigned courses
SELECT 
    t.phone AS mobile,
    t.email AS contact_email,
    c.title AS course_assigned
FROM 
    Course c
JOIN Schedule s ON c.course_id = s.course_id
JOIN Trainer t ON s.trainer_id = t.trainer_id
WHERE 
    t.trainer_id = 1;
--6. Count the number of courses the trainer teaches 
-- Count the number of unique courses trainer 1 teaches
SELECT 
    s.trainer_id,
    COUNT(DISTINCT s.course_id) AS total_courses_assigned
FROM 
    Schedule s
WHERE 
    s.trainer_id = 1
GROUP BY 
    s.trainer_id;

-------------------------------------
--Admin Perspective 
 -----------------------------------

--1. Add a new course (INSERT statement) 
-- Add a new course titled 'AI Foundations' in the 'AI' category

INSERT INTO Course (course_id, title, category, duration_hours, level)
VALUES (5, 'AI Foundations', 'AI', 25, 'Intermediate');

--2. Create a new schedule for a trainer 
-- Schedule 'AI Foundations' for trainer 2 in the morning
INSERT INTO Schedule 
VALUES (5, 5, 2, '2025-08-01', '2025-08-10', 'Morning');

--3. View all trainee enrollments with course title and schedule info 
-- Get details of all enrollments, including course name and schedule info
SELECT 
    e.enrollment_id,
    t.name AS trainee,
    c.title AS course,
    s.start_date,
    s.end_date,
    s.time_slot
FROM 
    Schedule s
JOIN Course c ON c.course_id = s.course_id
JOIN Enrollment e ON e.course_id = c.course_id
JOIN Trainee t ON t.trainee_id = e.trainee_id;

--4. Show how many courses each trainer is assigned to 
-- Total distinct courses scheduled for each trainer
SELECT 
    s.trainer_id,
    COUNT(DISTINCT s.course_id) AS total_courses
FROM 
    Schedule s
GROUP BY 
    s.trainer_id;

--5. List all trainees enrolled in "Data Basics" 
-- List of trainees registered in 'Database Fundamentals'
SELECT 
    tr.name,
    tr.email
FROM 
    Course cr
JOIN Enrollment en ON cr.course_id = en.course_id
JOIN Trainee tr ON en.trainee_id = tr.trainee_id
WHERE 
    cr.title = 'Database Fundamentals';

--6. Identify the course with the highest number of enrollments 
-- Course with maximum enrollment using subquery
SELECT 
    course_title, total_enrollments
FROM (
    SELECT 
        c.title AS course_title,
        COUNT(e.enrollment_id) AS total_enrollments
    FROM 
        Course c
    JOIN Enrollment e ON c.course_id = e.course_id
    GROUP BY c.title
) AS ranked
ORDER BY 
    total_enrollments DESC
OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY;

--7. Display all schedules sorted by start date 
-- Show session plans sorted by earliest start date
SELECT 
    *
FROM 
    Schedule
ORDER BY 
    start_date;
	----------------------------------
	---Finally Done!!!!1:)))
	--I Enjoyed DATABASE !!:)))
	---Thankyou Supper Ms Fatma 