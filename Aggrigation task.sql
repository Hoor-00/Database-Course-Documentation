Create Database USchool;
USE USchool;
--Instructors
CREATE TABLE Instructors (
    InstructorID INT PRIMARY KEY,
    FullName VARCHAR(100),
    Email VARCHAR(100),
    JoinDate DATE
);
--categories
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50)
);
--Courses 
CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    Title VARCHAR(100),
    InstructorID INT,
    CategoryID INT,
    Price DECIMAL(6,2),
    PublishDate DATE,
    FOREIGN KEY (InstructorID) REFERENCES Instructors(InstructorID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);
--student
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FullName VARCHAR(100),
    Email VARCHAR(100),
    JoinDate DATE
);
--Enrollments
CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    EnrollDate DATE,
    CompletionPercent INT,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

--inserting info (instructors)
INSERT INTO Instructors VALUES 
(1, 'Sarah Ahmed', 'sarah@learnhub.com', '2023-01-10'),
(2, 'Mohammed Al-Busaidi', 'mo@learnhub.com', '2023-05-21');
--inserting info categories
INSERT INTO Categories VALUES 
(1, 'Web Development'),
(2, 'Data Science'),
(3, 'Business');
--courses
INSERT INTO Courses VALUES 
(101, 'HTML & CSS Basics', 1, 1, 29.99, '2023-02-01'),
(102, 'Python for Data Analysis', 2, 2, 49.99, '2023-03-15'),
(103, 'Excel for Business', 2, 3, 19.99, '2023-04-10'),
(104, 'JavaScript Advanced', 1, 1, 39.99, '2023-05-01');
--students
INSERT INTO Students VALUES 
(201, 'Ali Salim', 'ali@student.com', '2023-04-01'),
(202, 'Layla Nasser', 'layla@student.com', '2023-04-05'),
(203, 'Ahmed Said', 'ahmed@student.com', '2023-04-10');
--Enrolment
INSERT INTO Enrollments VALUES 
(1, 201, 101, '2023-04-10', 100, 5),
(2, 202, 102, '2023-04-15', 80, 4),
(3, 203, 101, '2023-04-20', 90, 4),
(4, 201, 102, '2023-04-22', 50, 3),
(5, 202, 103, '2023-04-25', 70, 4),
(6, 203, 104, '2023-04-28', 30, 2),
(7, 201, 104, '2023-05-01', 60, 3);
--Aggrigation : 
--COUNT() → number of rows

--SUM() → total

--AVG() → average

--MAX() → highest

--MIN() → lowest
-- Beginner level : 
--Count total number of students
SELECT COUNT(StudentID)
FROM Students;
-- Count total number of enrollments
SELECT COUNT(EnrollmentID)
FROM Enrollments;
-- average rating of each course
SELECT CourseID, AVG(Rating) AS AverageRating
FROM Enrollments
GROUP BY CourseID;
--Total number of courses per instructor
SELECT InstructorID, COUNT(*) AS CourseCount
FROM Courses
GROUP BY InstructorID;
--Number of courses in each category
SELECT CategoryID, COUNT(*) AS CourseCount
FROM Courses
GROUP BY CategoryID;
--Number of students enrolled in each course
SELECT CourseID, COUNT(*) AS StudentCount
FROM Enrollments
GROUP BY CourseID;
--Average course price per category
SELECT CategoryID, AVG(Price) AS AvgPrice
FROM Courses
GROUP BY CategoryID;
--Maximum course price
SELECT MAX(Price) AS MaxPrice
FROM Courses;
-- Min, Max, and Avg rating per course
SELECT CourseID, 
       MIN(Rating) AS MinRating,
       MAX(Rating) AS MaxRating,
       AVG(Rating) AS AvgRating
FROM Enrollments
GROUP BY CourseID;

-- Count how many students gave rating = 5
SELECT COUNT(*) AS FiveStarRatings
FROM Enrollments
WHERE Rating = 5;

------Intermidate :
-- Average completion percent per course
SELECT CourseID, AVG(CompletionPercent) AS AvgCompletion
FROM Enrollments
GROUP BY CourseID;

--Find students enrolled in more than 1 course
SELECT StudentID, COUNT(*) AS CourseCount
FROM Enrollments
GROUP BY StudentID
HAVING COUNT(*) > 1;

-- Calculate revenue per course (Price × Number of Enrollments)
SELECT c.CourseID, c.Title, c.Price, 
       COUNT(e.EnrollmentID) AS Enrollments,
       c.Price * COUNT(e.EnrollmentID) AS Revenue
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.CourseID, c.Title, c.Price;

--Instructor name + distinct student count
SELECT i.FullName, COUNT(DISTINCT e.StudentID) AS StudentCount
FROM Instructors i
JOIN Courses c ON i.InstructorID = c.InstructorID
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY i.FullName;

--Average enrollments per category
SELECT cat.CategoryName, AVG(course_enrolls.EnrollCount) AS AvgEnrollments
FROM (
    SELECT c.CategoryID, c.CourseID, COUNT(e.EnrollmentID) AS EnrollCount
    FROM Courses c
    JOIN Enrollments e ON c.CourseID = e.CourseID
    GROUP BY c.CategoryID, c.CourseID
) AS course_enrolls
JOIN Categories cat ON course_enrolls.CategoryID = cat.CategoryID
GROUP BY cat.CategoryName;


--Average course rating by instructor
SELECT i.FullName, AVG(e.Rating) AS AvgRating
FROM Instructors i
JOIN Courses c ON i.InstructorID = c.InstructorID
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY i.FullName;

-- Top 3 courses by enrollment count
SELECT TOP 3 CourseID, COUNT(*) AS Enrollments
FROM Enrollments
GROUP BY CourseID
ORDER BY Enrollments DESC;

--Average days students take to complete 100%
SELECT CourseID, 
       AVG(DATEDIFF(DAY, EnrollDate, '2023-06-01')) AS AvgDaysToComplete
FROM Enrollments
WHERE CompletionPercent = 100
GROUP BY CourseID;

--Percentage of students who completed each course
SELECT CourseID,
       COUNT(CASE WHEN CompletionPercent = 100 THEN 1 END) * 100.0 / COUNT(*) AS CompletionRate
FROM Enrollments
GROUP BY CourseID;


--Count courses published each year
SELECT YEAR(PublishDate) AS PublishYear, COUNT(*) AS CourseCount
FROM Courses
GROUP BY YEAR(PublishDate);




