
-- Database Creation
CREATE DATABASE interview_prep_system;
USE interview_prep_system;

-- Table Creation
CREATE TABLE User (
    UserID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255) NOT NULL,
    Role VARCHAR(100) NOT NULL,
    Interests TEXT,
    Program VARCHAR(100),
    Email VARCHAR(255) UNIQUE NOT NULL,
    Year YEAR
);

CREATE TABLE Company (
    CompanyID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255) NOT NULL,
    Location VARCHAR(255),
    Industry VARCHAR(100)
);

CREATE TABLE Interview_Data (
    InterviewID INT PRIMARY KEY AUTO_INCREMENT,
    Role VARCHAR(100),
    CompanyID INT,
    FOREIGN KEY (CompanyID) REFERENCES Company(CompanyID)
);

CREATE TABLE Peer_Story (
    StoryID INT PRIMARY KEY AUTO_INCREMENT,
    CompanyID INT,
    PrepMethod VARCHAR(255),
    Outcome VARCHAR(50),
    StoryText TEXT,
    Role VARCHAR(100),
    UserID INT,
    FOREIGN KEY (CompanyID) REFERENCES Company(CompanyID),
    FOREIGN KEY (UserID) REFERENCES User(UserID)
);

CREATE TABLE Question_Bank (
    QuestionID INT PRIMARY KEY AUTO_INCREMENT,
    Question_Type VARCHAR(50),
    Question_Text TEXT,
    Difficulty VARCHAR(20),
    Feedback TEXT,
    StoryID INT,
    InterviewID INT,
    CompanyID INT,
    FOREIGN KEY (StoryID) REFERENCES Peer_Story(StoryID),
    FOREIGN KEY (InterviewID) REFERENCES Interview_Data(InterviewID),
    FOREIGN KEY (CompanyID) REFERENCES Company(CompanyID)
);

CREATE TABLE Practice_Session (
    PracSessionID INT PRIMARY KEY AUTO_INCREMENT,
    Date DATETIME,
    Feedback TEXT,
    QuestionID INT,
    TAID INT,
    FOREIGN KEY (QuestionID) REFERENCES Question_Bank(QuestionID),
    FOREIGN KEY (TAID) REFERENCES User(UserID)
);

CREATE TABLE Advisor_Student_Relationship (
    AdvisorID INT,
    StudentID INT,
    PRIMARY KEY (AdvisorID, StudentID),
    FOREIGN KEY (AdvisorID) REFERENCES User(UserID),
    FOREIGN KEY (StudentID) REFERENCES User(UserID)
);

-- 1. Companies
INSERT INTO Company (Name, Location, Industry) VALUES
('Tech Corp', 'San Francisco, CA', 'Technology'),
('Data Systems', 'New York, NY', 'Data Analytics'),
('Cloud Solutions', 'Seattle, WA', 'Cloud Computing');

-- 2. Users
INSERT INTO User (Name, Role, Interests, Program, Email, Year) VALUES
('Ria Shah', 'Student', 'Software Development', 'Computer Science', 'ria.shah@university.edu', 2024),
('Bob Vu', 'Alumni', 'Career Mentoring', 'Information Systems', 'bob.vu@company.com', 2020),
('John Smith', 'Advisor', 'Student Mentoring', 'Computer Science', 'john.smith@university.edu', NULL);

-- 3. Interview Data
INSERT INTO Interview_Data (Role, CompanyID) VALUES
('Software Engineer', 1),
('Data Scientist', 2),
('Cloud Architect', 3);

-- 4. Peer Stories
INSERT INTO Peer_Story (CompanyID, PrepMethod, Outcome, StoryText, Role, UserID) VALUES
(1, 'LeetCode + System Design', 'Accepted', 'Detailed interview experience...', 'Software Engineer', 2),
(2, 'SQL Practice + Machine Learning', 'Accepted', 'Data Science interview experience...', 'Data Scientist', 2);

-- 5. Question Bank
INSERT INTO Question_Bank (Question_Type, Question_Text, Difficulty, Feedback, StoryID, InterviewID, CompanyID) VALUES
('Technical', 'Implement a binary search tree', 'Medium', NULL, 1, 1, 1),
('System Design', 'Design a URL shortening service', 'Hard', NULL, 1, 1, 1),
('Behavioral', 'Describe a challenging project', 'Medium', NULL, 2, 2, 2);

-- Now we can safely insert Practice Sessions
INSERT INTO Practice_Session (Date, QuestionID, TAID, Feedback) VALUES
(NOW(), 1, 3, 'Need more practice on implementation'),
(NOW(), 2, 3, 'Good system design approach'),
(NOW(), 3, 3, 'Work on STAR method');

-- CRUD Queries for Different Personas

-- Persona 1 - Ria Shah (Graduate Student)
-- 1.1 - Access field-specific interview questions:

SELECT qb.Question_Text, qb.Question_Type, qb.Difficulty, c.Name as Company
FROM Question_Bank qb
JOIN Company c ON qb.CompanyID = c.CompanyID
JOIN Interview_Data id ON qb.InterviewID = id.InterviewID
WHERE id.Role LIKE '%Data Scientist%' OR id.Role LIKE '%Machine Learning%'
ORDER BY qb.Difficulty;
-- 1.2 - Quick access to relevant resources:

SELECT ps.StoryText, c.Name as Company, ps.PrepMethod, ps.Role
FROM Peer_Story ps
JOIN Company c ON ps.CompanyID = c.CompanyID
WHERE ps.Role LIKE '%Data%'
  AND ps.Outcome = 'Accepted'
ORDER BY c.Name;
-- 1.3 - Latest interview trends:

SELECT qb.Question_Type, COUNT(*) as Frequency,
       c.Name as Company, id.Role
FROM Question_Bank qb
JOIN Interview_Data id ON qb.InterviewID = id.InterviewID
JOIN Company c ON qb.CompanyID = c.CompanyID
WHERE id.Role LIKE '%Data%'
GROUP BY qb.Question_Type, c.Name, id.Role
ORDER BY Frequency DESC;
-- 1.4 - Company-specific interview processes:

SELECT c.Name as Company, id.Role,
       COUNT(DISTINCT qb.Question_Type) as Question_Types,
       ps.PrepMethod, ps.StoryText
FROM Company c
JOIN Interview_Data id ON c.CompanyID = id.CompanyID
JOIN Question_Bank qb ON c.CompanyID = qb.CompanyID
JOIN Peer_Story ps ON c.CompanyID = ps.CompanyID
WHERE c.Industry = 'Data Analytics'
GROUP BY c.Name, id.Role, ps.PrepMethod, ps.StoryText;
-- 1.5 - Access peer testimonials:

SELECT u.Name as Alumni, ps.StoryText, ps.PrepMethod,
       ps.Outcome, c.Name as Company
FROM Peer_Story ps
JOIN User u ON ps.UserID = u.UserID
JOIN Company c ON ps.CompanyID = c.CompanyID
WHERE ps.Role LIKE '%Data%'
  AND ps.Outcome = 'Accepted'
ORDER BY u.Year DESC;
-- Persona 2 - John Smith (Undergraduate Student)
-- 2.1 - Sample interview questions for beginners:

SELECT qb.Question_Text, qb.Question_Type, qb.Difficulty,
       c.Name as Company
FROM Question_Bank qb
JOIN Company c ON qb.CompanyID = c.CompanyID
WHERE qb.Difficulty = 'Easy'
  AND qb.Question_Type = 'Technical'
ORDER BY c.Name;
-- 2.2 - Typical co-op interview insights:

SELECT DISTINCT ps.PrepMethod, ps.StoryText, c.Name as Company,
       u.Role as Shared_By
FROM Peer_Story ps
JOIN Company c ON ps.CompanyID = c.CompanyID
JOIN User u ON ps.UserID = u.UserID
WHERE ps.Role LIKE '%Software Engineer%'
  AND u.Role = 'Alumni';
-- 2.3 - Success stories and preparation methods:

SELECT ps.StoryText, ps.PrepMethod, u.Name as Shared_By,
       c.Name as Company
FROM Peer_Story ps
JOIN User u ON ps.UserID = u.UserID
JOIN Company c ON ps.CompanyID = c.CompanyID
WHERE ps.Outcome = 'Accepted'
ORDER BY u.Year DESC;
-- 2.4 - Recent graduate experiences:

SELECT u.Name, ps.PrepMethod, ps.StoryText, c.Name as Company
FROM Peer_Story ps
JOIN User u ON ps.UserID = u.UserID
JOIN Company c ON ps.CompanyID = c.CompanyID
WHERE u.Role = 'Alumni'
  AND u.Year >= YEAR(CURDATE()) - 2
ORDER BY u.Year DESC;
-- 2.5 - Practice session history:

SELECT ps.Date, qb.Question_Text, qb.Question_Type,
       ps.Feedback, u.Name as TA_Name
FROM Practice_Session ps
JOIN Question_Bank qb ON ps.QuestionID = qb.QuestionID
JOIN User u ON ps.TAID = u.UserID
ORDER BY ps.Date DESC;
-- Persona 3 - Bob Vu (Alumni)
-- 3.1 - Access current interview experiences:

SELECT ps.StoryText, c.Name as Company, ps.Role,
       ps.PrepMethod, u.Year as Grad_Year
FROM Peer_Story ps
JOIN Company c ON ps.CompanyID = c.CompanyID
JOIN User u ON ps.UserID = u.UserID
WHERE u.Year >= YEAR(CURDATE()) - 2
ORDER BY u.Year DESC;
-- 3.2 - Condensed company-specific preparation:

SELECT c.Name as Company,
       COUNT(DISTINCT qb.Question_Type) as Question_Types,
       GROUP_CONCAT(DISTINCT ps.PrepMethod) as Prep_Methods
FROM Company c
JOIN Question_Bank qb ON c.CompanyID = qb.CompanyID
JOIN Peer_Story ps ON c.CompanyID = ps.CompanyID
GROUP BY c.Name;
-- 3.3 - Access to recent resources:

SELECT qb.Question_Text, qb.Question_Type, c.Name as Company, ps.PrepMethod
FROM Question_Bank qb
JOIN Company c ON qb.CompanyID = c.CompanyID
JOIN (
    SELECT * FROM Peer_Story
    ORDER BY StoryID DESC LIMIT 50
) ps ON qb.StoryID = ps.StoryID;

-- 3.4 - Role-specific preparation materials:

SELECT qb.Question_Text, qb.Question_Type, qb.Difficulty,
       c.Name as Company
FROM Question_Bank qb
JOIN Company c ON qb.CompanyID = c.CompanyID
JOIN Interview_Data id ON qb.InterviewID = id.InterviewID
WHERE id.Role = 'Senior Developer'
ORDER BY qb.Difficulty;
-- 3.5 - Share interview experiences:

INSERT INTO Peer_Story (CompanyID, PrepMethod, Outcome,
                       StoryText, Role, UserID)
VALUES (1, 'LeetCode + System Design', 'Accepted',
        'Detailed senior dev interview experience...',
        'Senior Developer', 2);
-- Persona 4 - Sarah Mitchell (Career Service Advisor)
-- 4.1 - Access Northeastern-specific insights:

SELECT c.Name as Company,
       COUNT(ps.StoryID) as Success_Stories,
       AVG(CASE WHEN ps.Outcome = 'Accepted' THEN 1 ELSE 0 END) as Success_Rate
FROM Company c
JOIN Peer_Story ps ON c.CompanyID = ps.CompanyID
GROUP BY c.Name
ORDER BY Success_Stories DESC;
-- 4.2 - Verify interview experience authenticity:

SELECT ps.StoryText, u.Name, u.Email, u.Program,
       c.Name as Company, ps.Outcome
FROM Peer_Story ps
JOIN User u ON ps.UserID = u.UserID
JOIN Company c ON ps.CompanyID = c.CompanyID
WHERE u.Email LIKE '%university.edu';
-- 4.3 - Company and role-specific data:

SELECT c.Name as Company, id.Role,
       COUNT(DISTINCT qb.QuestionID) as Total_Questions,
       COUNT(DISTINCT ps.StoryID) as Success_Stories
FROM Company c
JOIN Interview_Data id ON c.CompanyID = id.CompanyID
LEFT JOIN Question_Bank qb ON c.CompanyID = qb.CompanyID
LEFT JOIN Peer_Story ps ON c.CompanyID = ps.CompanyID
GROUP BY c.Name, id.Role;
-- 4.4 - Track student preparation trends:

SELECT u.Program, c.Name as Company,
       COUNT(DISTINCT ps.PracSessionID) as Practice_Sessions,
       AVG(CASE WHEN peer.Outcome = 'Accepted' THEN 1 ELSE 0 END) as Success_Rate
FROM User u
JOIN Practice_Session ps ON u.UserID = ps.TAID
JOIN Question_Bank qb ON ps.QuestionID = qb.QuestionID
JOIN Company c ON qb.CompanyID = c.CompanyID
LEFT JOIN Peer_Story peer ON c.CompanyID = peer.CompanyID
GROUP BY u.Program, c.Name;
-- 4.5 - Popular companies and roles analysis:

SELECT c.Name as Company, id.Role,
       COUNT(DISTINCT ps.StoryID) as Interview_Stories,
       COUNT(DISTINCT prac.PracSessionID) as Practice_Sessions
FROM Company c
JOIN Interview_Data id ON c.CompanyID = id.CompanyID
LEFT JOIN Peer_Story ps ON c.CompanyID = ps.CompanyID
LEFT JOIN Question_Bank qb ON c.CompanyID = qb.CompanyID
LEFT JOIN Practice_Session prac ON qb.QuestionID = prac.QuestionID
GROUP BY c.Name, id.Role
ORDER BY Interview_Stories DESC;
-- Persona 5 - Arhat Shah (Teaching Assistant)
-- 5.1 - Access recent interview questions:

SELECT qb.Question_Text, qb.Question_Type, qb.Difficulty,
       c.Name as Company, id.Role
FROM Question_Bank qb
JOIN Company c ON qb.CompanyID = c.CompanyID
JOIN Interview_Data id ON qb.InterviewID = id.InterviewID
ORDER BY qb.QuestionID DESC;
-- 5.2 - Track practice session planning:

SELECT c.Name as Company, COUNT(ps.PracSessionID) as Sessions,
       AVG(CASE WHEN peer.Outcome = 'Accepted' THEN 1 ELSE 0 END) as Success_Rate
FROM Practice_Session ps
JOIN Question_Bank qb ON ps.QuestionID = qb.QuestionID
JOIN Company c ON qb.CompanyID = c.CompanyID
LEFT JOIN Peer_Story peer ON c.CompanyID = peer.CompanyID
GROUP BY c.Name
ORDER BY Sessions DESC;
-- 5.3 - Monitor student progress:

SELECT u.Name as Student,
       COUNT(ps.PracSessionID) as Total_Sessions,
       MAX(ps.Date) as Latest_Session,
       ps.Feedback
FROM User u
JOIN Practice_Session ps ON u.UserID = ps.TAID
GROUP BY u.Name, ps.Feedback
ORDER BY Latest_Session DESC;
-- 5.4 - Track feedback patterns:

SELECT qb.Question_Type, qb.Difficulty,
       COUNT(ps.PracSessionID) as Times_Asked,
       GROUP_CONCAT(DISTINCT ps.Feedback) as Feedback_Patterns
FROM Question_Bank qb
JOIN Practice_Session ps ON qb.QuestionID = ps.QuestionID
GROUP BY qb.Question_Type, qb.Difficulty;
-- 5.5 - Advisor collaboration tracking:

SELECT u.Name as Advisor,
       COUNT(DISTINCT asr.StudentID) as Students_Advised,
       COUNT(DISTINCT ps.PracSessionID) as Practice_Sessions
FROM User u
JOIN Advisor_Student_Relationship asr ON u.UserID = asr.AdvisorID
LEFT JOIN Practice_Session ps ON asr.StudentID = ps.TAID
WHERE u.Role = 'Advisor'
GROUP BY u.Name;
