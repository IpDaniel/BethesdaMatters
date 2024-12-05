-- Database Creation
DROP DATABASE IF EXISTS interview_prep_system;
CREATE DATABASE interview_prep_system;
USE interview_prep_system;

-- Strong Entities

-- User Table (Strong Entity)
CREATE TABLE User (
    userID INT PRIMARY KEY AUTO_INCREMENT,
    userName VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    userType ENUM('Student', 'Alumni', 'TA', 'Advisor') NOT NULL
);


-- Company Table (Strong Entity)
CREATE TABLE Company (
    companyID INT PRIMARY KEY AUTO_INCREMENT,
    companyName VARCHAR(255) NOT NULL,
    location VARCHAR(255)
);


-- Question Table (Strong Entity)
CREATE TABLE Question (
    questionID INT PRIMARY KEY AUTO_INCREMENT,
    companyID INT,
    questionType VARCHAR(50) NOT NULL,
    userID INT,
    FOREIGN KEY (companyID) REFERENCES Company(companyID) ON DELETE CASCADE,
    FOREIGN KEY (userID) REFERENCES User(userID) ON DELETE CASCADE
);

-- InterviewPrep Table (Strong Entity)
CREATE TABLE InterviewPrep (
    interviewPrepID INT PRIMARY KEY AUTO_INCREMENT,
    userID INT,
    questionID INT,
    FOREIGN KEY (userID) REFERENCES User(userID) ON DELETE CASCADE,
    FOREIGN KEY (questionID) REFERENCES Question(questionID) ON DELETE CASCADE
);

-- PeerStory Table (Strong Entity)
CREATE TABLE PeerStory (
    peerStoryID INT PRIMARY KEY AUTO_INCREMENT,
    review TEXT,
    userID INT,
    companyID INT,
    FOREIGN KEY (userID) REFERENCES User(userID) ON DELETE CASCADE,
    FOREIGN KEY (companyID) REFERENCES Company(companyID) ON DELETE CASCADE
);

-- Relationship Tables (Bridge Tables)

-- User_question (Relationship: accesses)
CREATE TABLE User_question (
    userID INT,
    questionID INT,
    PRIMARY KEY (userID, questionID),
    FOREIGN KEY (userID) REFERENCES User(userID) ON DELETE CASCADE,
    FOREIGN KEY (questionID) REFERENCES Question(questionID) ON DELETE CASCADE
);

-- Stu_Iprep (Relationship: request)
CREATE TABLE Stu_Iprep (
    userID INT,
    interviewPrepID INT,
    date DATE,
    PRIMARY KEY (userID, interviewPrepID),
    FOREIGN KEY (userID) REFERENCES User(userID) ON DELETE CASCADE, 
    FOREIGN KEY (interviewPrepID) REFERENCES InterviewPrep(interviewPrepID) ON DELETE CASCADE
);

-- Ta_Iprep (Relationship: manages)
CREATE TABLE Ta_Iprep (
    userID INT,
    interviewPrepID INT,
    PRIMARY KEY (userID, interviewPrepID),
    FOREIGN KEY (userID) REFERENCES User(userID) ON DELETE CASCADE,
    FOREIGN KEY (interviewPrepID) REFERENCES InterviewPrep(interviewPrepID) ON DELETE CASCADE
);

-- Iprep_question (Relationship: contains)
CREATE TABLE Iprep_question (
    questionID INT,
    interviewPrepID INT,
    PRIMARY KEY (questionID, interviewPrepID),
    FOREIGN KEY (questionID) REFERENCES Question(questionID) ON DELETE CASCADE,
    FOREIGN KEY (interviewPrepID) REFERENCES InterviewPrep(interviewPrepID) ON DELETE CASCADE
);

-- User_story (Relationship: accesses)
CREATE TABLE User_story (
    userID INT,
    peerStoryID INT,
    PRIMARY KEY (userID, peerStoryID),
    FOREIGN KEY (userID) REFERENCES User(userID) ON DELETE CASCADE, 
    FOREIGN KEY (peerStoryID) REFERENCES PeerStory(peerStoryID) ON DELETE CASCADE
);

-- Question_comp (Relationship: is about)
CREATE TABLE Question_comp (
    questionID INT,
    companyID INT,
    PRIMARY KEY (questionID, companyID),
    FOREIGN KEY (questionID) REFERENCES Question(questionID) ON DELETE CASCADE,
    FOREIGN KEY (companyID) REFERENCES Company(companyID) ON DELETE CASCADE
);

-- Story_comp (Relationship: is about)
CREATE TABLE Story_comp (
    peerStoryID INT,
    companyID INT,
    PRIMARY KEY (peerStoryID, companyID),
    FOREIGN KEY (peerStoryID) REFERENCES PeerStory(peerStoryID) ON DELETE CASCADE,
    FOREIGN KEY (companyID) REFERENCES Company(companyID) ON DELETE CASCADE
);

-- User
insert into User (userID, userName, email, userType) values (1, 'John Smith', 'jsmith@csmonitor.com', 'Student');
insert into User (userID, userName, email, userType) values (2, 'Sarah Mitchell', 'smitchell@bluehost.com', 'Advisor');
insert into User (userID, userName, email, userType) values (3, 'Dredi Dargie', 'ddargie2@rambler.ru', 'Advisor');
insert into User (userID, userName, email, userType) values (4, 'Ada MacKessock', 'amackessock3@si.edu', 'Student');
insert into User (userID, userName, email, userType) values (5, 'Arhat Shah', 'shazam4@dion.ne.jp', 'TA');
insert into User (userID, userName, email, userType) values (6, 'Charisse Southan', 'csouthan5@qq.com', 'Advisor');
insert into User (userID, userName, email, userType) values (7, 'Merwyn Ormshaw', 'mormshaw6@narod.ru', 'Advisor');
insert into User (userID, userName, email, userType) values (8, 'Kirstin Haythornthwaite', 'khaythornthwaite7@google.fr', 'Student');
insert into User (userID, userName, email, userType) values (9, 'Laura Dimitrescu', 'ldimitrescu8@booking.com', 'Alumni');
insert into User (userID, userName, email, userType) values (10, 'BOb Vu', 'bobby9@linkedin.com', 'Alumni');
insert into User (userID, userName, email, userType) values (11, 'Merrile Gorger', 'mgorgera@netvibes.com', 'Advisor');
insert into User (userID, userName, email, userType) values (12, 'Johnnie MacLennan', 'jmaclennanb@sbwire.com', 'Advisor');
insert into User (userID, userName, email, userType) values (13, 'Frasco Duddan', 'fduddanc@photobucket.com', 'Student');
insert into User (userID, userName, email, userType) values (14, 'Helenka Wiffen', 'hwiffend@earthlink.net', 'Advisor');
insert into User (userID, userName, email, userType) values (15, 'Ulrick Deeney', 'udeeneye@twitter.com', 'Student');
insert into User (userID, userName, email, userType) values (16, 'Carmencita Tull', 'ctullf@geocities.jp', 'Alumni');
insert into User (userID, userName, email, userType) values (17, 'Rabbi Spitaro', 'rspitarog@state.tx.us', 'Alumni');
insert into User (userID, userName, email, userType) values (18, 'Skelly Snaddin', 'ssnaddinh@digg.com', 'Alumni');
insert into User (userID, userName, email, userType) values (19, 'Mona Alishoner', 'malishoneri@ycombinator.com', 'Advisor');
insert into User (userID, userName, email, userType) values (20, 'Raina Kroll', 'rkrollj@examiner.com', 'TA');
insert into User (userID, userName, email, userType) values (21, 'Minetta End', 'mendk@google.es', 'TA');
insert into User (userID, userName, email, userType) values (22, 'Gram Whittuck', 'gwhittuckl@marriott.com', 'TA');
insert into User (userID, userName, email, userType) values (23, 'Murray Braycotton', 'mbraycottonm@comsenz.com', 'TA');
insert into User (userID, userName, email, userType) values (24, 'Amory Ziemsen', 'aziemsenn@ihg.com', 'Advisor');
insert into User (userID, userName, email, userType) values (25, 'Welsh Alessandretti', 'walessandrettio@trellian.com', 'TA');
insert into User (userID, userName, email, userType) values (26, 'Selia Blundon', 'sblundonp@un.org', 'Advisor');
insert into User (userID, userName, email, userType) values (27, 'Tony Kiwitz', 'tkiwitzq@tripadvisor.com', 'Student');
insert into User (userID, userName, email, userType) values (28, 'Reeva Fanning', 'rfanningr@ow.ly', 'Alumni');
insert into User (userID, userName, email, userType) values (29, 'Verile Kier', 'vkiers@tiny.cc', 'Advisor');
insert into User (userID, userName, email, userType) values (30, 'Vicky Hollibone', 'vhollibonet@berkeley.edu', 'Advisor');
insert into User (userID, userName, email, userType) values (31, 'Emmerich Seawright', 'eseawrightu@noaa.gov', 'Student');
insert into User (userID, userName, email, userType) values (32, 'Karlan Louis', 'klouisv@msu.edu', 'Student');
insert into User (userID, userName, email, userType) values (33, 'Susanna Gages', 'sgagesw@tiny.cc', 'Student');
insert into User (userID, userName, email, userType) values (34, 'Benedetta Tatum', 'btatumx@globo.com', 'Student');
insert into User (userID, userName, email, userType) values (35, 'Carmine Johnston', 'cjohnstony@goodreads.com', 'Alumni');
insert into User (userID, userName, email, userType) values (36, 'Pammi Lotze', 'plotzez@fda.gov', 'Advisor');
insert into User (userID, userName, email, userType) values (37, 'Lonnard McManamen', 'lmcmanamen10@webeden.co.uk', 'Student');
insert into User (userID, userName, email, userType) values (38, 'Bili O''Haire', 'bohaire11@ucoz.ru', 'Advisor');
insert into User (userID, userName, email, userType) values (39, 'Annadiane Pohling', 'apohling12@berkeley.edu', 'Alumni');
insert into User (userID, userName, email, userType) values (40, 'Launce Munroe', 'lmunroe13@gizmodo.com', 'Student');
insert into User (userID, userName, email, userType) values (100, 'Administrator', 'admin@admin.com', 'Admin');


-- Company
insert into Company (companyID, companyName, location) values (1, 'Quinu', '10 Anhalt Avenue');
insert into Company (companyID, companyName, location) values (2, 'Wordware', '9 Shelley Plaza');
insert into Company (companyID, companyName, location) values (3, 'Skajo', '103 3rd Center');
insert into Company (companyID, companyName, location) values (4, 'Dabtype', '9101 Wayridge Circle');
insert into Company (companyID, companyName, location) values (5, 'Skimia', '50 Birchwood Court');
insert into Company (companyID, companyName, location) values (6, 'Realbuzz', '737 Carberry Lane');
insert into Company (companyID, companyName, location) values (7, 'Skinix', '58892 Hanson Trail');
insert into Company (companyID, companyName, location) values (8, 'Yadel', '344 Vernon Road');
insert into Company (companyID, companyName, location) values (9, 'Yotz', '2198 Charing Cross Plaza');
insert into Company (companyID, companyName, location) values (10, 'Minyx', '2067 Ludington Trail');
insert into Company (companyID, companyName, location) values (11, 'Zooveo', '843 Fuller Trail');
insert into Company (companyID, companyName, location) values (12, 'Devcast', '2691 Cascade Alley');
insert into Company (companyID, companyName, location) values (13, 'Skimia', '2663 Meadow Valley Trail');
insert into Company (companyID, companyName, location) values (14, 'Skinix', '3 Forest Run Road');
insert into Company (companyID, companyName, location) values (15, 'Avavee', '846 Paget Avenue');
insert into Company (companyID, companyName, location) values (16, 'Edgeify', '92780 Esker Center');
insert into Company (companyID, companyName, location) values (17, 'Innotype', '51477 Novick Point');
insert into Company (companyID, companyName, location) values (18, 'Divanoodle', '37 Manley Trail');
insert into Company (companyID, companyName, location) values (19, 'Trudeo', '7689 Rusk Drive');
insert into Company (companyID, companyName, location) values (20, 'Skiba', '22466 Brentwood Terrace');
insert into Company (companyID, companyName, location) values (21, 'Jatri', '33 Bunker Hill Avenue');
insert into Company (companyID, companyName, location) values (22, 'Npath', '868 Glendale Road');
insert into Company (companyID, companyName, location) values (23, 'Yodel', '0 Manufacturers Point');
insert into Company (companyID, companyName, location) values (24, 'Zoovu', '35202 Bellgrove Pass');
insert into Company (companyID, companyName, location) values (25, 'Youspan', '92 Evergreen Hill');
insert into Company (companyID, companyName, location) values (26, 'Bubblebox', '015 Eliot Center');
insert into Company (companyID, companyName, location) values (27, 'Tagopia', '4165 Debra Circle');
insert into Company (companyID, companyName, location) values (28, 'Voomm', '71 Loomis Circle');
insert into Company (companyID, companyName, location) values (29, 'Yambee', '19947 Mariners Cove Plaza');
insert into Company (companyID, companyName, location) values (30, 'Flipbug', '2383 Kipling Way');
insert into Company (companyID, companyName, location) values (31, 'Edgeblab', '989 Oxford Pass');
insert into Company (companyID, companyName, location) values (32, 'Livepath', '51 Hansons Alley');
insert into Company (companyID, companyName, location) values (33, 'Midel', '02562 Carpenter Lane');
insert into Company (companyID, companyName, location) values (34, 'Kazio', '91892 Mockingbird Street');
insert into Company (companyID, companyName, location) values (35, 'Voonyx', '97431 John Wall Avenue');
insert into Company (companyID, companyName, location) values (36, 'Eabox', '8907 Daystar Plaza');
insert into Company (companyID, companyName, location) values (37, 'Innotype', '9889 Sugar Way');
insert into Company (companyID, companyName, location) values (38, 'Tazzy', '826 Truax Lane');
insert into Company (companyID, companyName, location) values (39, 'Flashdog', '35288 Dayton Terrace');
insert into Company (companyID, companyName, location) values (40, 'Photolist', '546 Shasta Way');

-- Question
insert into Question (questionID, companyID, questionType, userID) values (1, 34, 'Behavioral', 19);
insert into Question (questionID, companyID, questionType, userID) values (2, 17, 'System Design', 23);
insert into Question (questionID, companyID, questionType, userID) values (3, 11, 'Technical', 14);
insert into Question (questionID, companyID, questionType, userID) values (4, 18, 'Technical', 25);
insert into Question (questionID, companyID, questionType, userID) values (5, 21, 'Technical', 4);
insert into Question (questionID, companyID, questionType, userID) values (6, 33, 'System Design', 11);
insert into Question (questionID, companyID, questionType, userID) values (7, 34, 'Technical', 25);
insert into Question (questionID, companyID, questionType, userID) values (8, 32, 'Technical', 9);
insert into Question (questionID, companyID, questionType, userID) values (9, 37, 'System Design', 13);
insert into Question (questionID, companyID, questionType, userID) values (10, 11, 'System Design', 14);
insert into Question (questionID, companyID, questionType, userID) values (11, 4, 'System Design', 16);
insert into Question (questionID, companyID, questionType, userID) values (12, 2, 'System Design', 26);
insert into Question (questionID, companyID, questionType, userID) values (13, 20, 'System Design', 2);
insert into Question (questionID, companyID, questionType, userID) values (14, 36, 'System Design', 16);
insert into Question (questionID, companyID, questionType, userID) values (15, 34, 'Technical', 21);
insert into Question (questionID, companyID, questionType, userID) values (16, 29, 'Technical', 7);
insert into Question (questionID, companyID, questionType, userID) values (17, 9, 'Technical', 35);
insert into Question (questionID, companyID, questionType, userID) values (18, 12, 'Behavioral', 21);
insert into Question (questionID, companyID, questionType, userID) values (19, 9, 'Behavioral', 33);
insert into Question (questionID, companyID, questionType, userID) values (20, 30, 'Technical', 8);
insert into Question (questionID, companyID, questionType, userID) values (21, 38, 'System Design', 8);
insert into Question (questionID, companyID, questionType, userID) values (22, 23, 'System Design', 36);
insert into Question (questionID, companyID, questionType, userID) values (23, 34, 'System Design', 22);
insert into Question (questionID, companyID, questionType, userID) values (24, 21, 'Technical', 17);
insert into Question (questionID, companyID, questionType, userID) values (25, 37, 'System Design', 36);
insert into Question (questionID, companyID, questionType, userID) values (26, 15, 'Technical', 19);
insert into Question (questionID, companyID, questionType, userID) values (27, 5, 'Behavioral', 18);
insert into Question (questionID, companyID, questionType, userID) values (28, 30, 'System Design', 4);
insert into Question (questionID, companyID, questionType, userID) values (29, 28, 'System Design', 28);
insert into Question (questionID, companyID, questionType, userID) values (30, 26, 'Technical', 34);
insert into Question (questionID, companyID, questionType, userID) values (31, 6, 'System Design', 10);
insert into Question (questionID, companyID, questionType, userID) values (32, 36, 'Technical', 29);
insert into Question (questionID, companyID, questionType, userID) values (33, 29, 'System Design', 18);
insert into Question (questionID, companyID, questionType, userID) values (34, 27, 'Behavioral', 10);
insert into Question (questionID, companyID, questionType, userID) values (35, 36, 'Behavioral', 15);
insert into Question (questionID, companyID, questionType, userID) values (36, 36, 'Technical', 11);
insert into Question (questionID, companyID, questionType, userID) values (37, 9, 'System Design', 38);
insert into Question (questionID, companyID, questionType, userID) values (38, 3, 'Behavioral', 8);
insert into Question (questionID, companyID, questionType, userID) values (39, 10, 'System Design', 28);
insert into Question (questionID, companyID, questionType, userID) values (40, 17, 'Behavioral', 25);

-- Interview Prep

insert into InterviewPrep (userID, questionID) values (1, 34);
insert into InterviewPrep (userID, questionID) values (2, 39);
insert into InterviewPrep (userID, questionID) values (3, 35);
insert into InterviewPrep (userID, questionID) values (4, 29);
insert into InterviewPrep (userID, questionID) values (5, 15);
insert into InterviewPrep (userID, questionID) values (6, 1);
insert into InterviewPrep (userID, questionID) values (7, 33);
insert into InterviewPrep (userID, questionID) values (8, 35);
insert into InterviewPrep (userID, questionID) values (9, 36);
insert into InterviewPrep (userID, questionID) values (10, 34);
insert into InterviewPrep (userID, questionID) values (11, 28);
insert into InterviewPrep (userID, questionID) values (12, 16);
insert into InterviewPrep (userID, questionID) values (13, 21);
insert into InterviewPrep (userID, questionID) values (14, 31);
insert into InterviewPrep (userID, questionID) values (15, 2);
insert into InterviewPrep (userID, questionID) values (16, 4);
insert into InterviewPrep (userID, questionID) values (17, 10);
insert into InterviewPrep (userID, questionID) values (18, 4);
insert into InterviewPrep (userID, questionID) values (19, 32);
insert into InterviewPrep (userID, questionID) values (20, 22);
insert into InterviewPrep (userID, questionID) values (21, 1);
insert into InterviewPrep (userID, questionID) values (22, 7);
insert into InterviewPrep (userID, questionID) values (23, 20);
insert into InterviewPrep (userID, questionID) values (24, 9);
insert into InterviewPrep (userID, questionID) values (25, 17);
insert into InterviewPrep (userID, questionID) values (26, 13);
insert into InterviewPrep (userID, questionID) values (27, 2);
insert into InterviewPrep (userID, questionID) values (28, 19);
insert into InterviewPrep (userID, questionID) values (29, 7);
insert into InterviewPrep (userID, questionID) values (30, 34);
insert into InterviewPrep (userID, questionID) values (31, 32);
insert into InterviewPrep (userID, questionID) values (32, 10);
insert into InterviewPrep (userID, questionID) values (33, 31);
insert into InterviewPrep (userID, questionID) values (34, 33);
insert into InterviewPrep (userID, questionID) values (35, 19);
insert into InterviewPrep (userID, questionID) values (36, 38);
insert into InterviewPrep (userID, questionID) values (37, 22);
insert into InterviewPrep (userID, questionID) values (38, 38);
insert into InterviewPrep (userID, questionID) values (39, 12);
insert into InterviewPrep (userID, questionID) values (40, 8);

-- Peer Story
insert into PeerStory (review, userID, companyID) values ('Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.

Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 1, 26);
insert into PeerStory (review, userID, companyID) values ('Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.

In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 2, 26);
insert into PeerStory (review, userID, companyID) values ('Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.

Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 3, 3);
insert into PeerStory (review, userID, companyID) values ('Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 4, 19);
insert into PeerStory (review, userID, companyID) values ('Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.

Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 5, 8);
insert into PeerStory (review, userID, companyID) values ('Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 6, 1);
insert into PeerStory (review, userID, companyID) values ('Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.

Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 7, 21);
insert into PeerStory (review, userID, companyID) values ('Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.

Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 8, 30);
insert into PeerStory (review, userID, companyID) values ('Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.

Sed ante. Vivamus tortor. Duis mattis egestas metus.', 9, 38);
insert into PeerStory (review, userID, companyID) values ('Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.

Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 10, 34);
insert into PeerStory (review, userID, companyID) values ('Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 11, 19);
insert into PeerStory (review, userID, companyID) values ('Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.

Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 12, 40);
insert into PeerStory (review, userID, companyID) values ('In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.

Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 13, 26);
insert into PeerStory (review, userID, companyID) values ('Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 14, 13);
insert into PeerStory (review, userID, companyID) values ('Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.

Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 15, 29);
insert into PeerStory (review, userID, companyID) values ('In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 16, 31);
insert into PeerStory (review, userID, companyID) values ('Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 17, 11);
insert into PeerStory (review, userID, companyID) values ('Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.

In congue. Etiam justo. Etiam pretium iaculis justo.', 18, 38);
insert into PeerStory (review, userID, companyID) values ('Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.

Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 19, 12);
insert into PeerStory (review, userID, companyID) values ('Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.

Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 20, 2);
insert into PeerStory (review, userID, companyID) values ('Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 21, 26);
insert into PeerStory (review, userID, companyID) values ('Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.

Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 22, 21);
insert into PeerStory (review, userID, companyID) values ('Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 23, 24);
insert into PeerStory (review, userID, companyID) values ('Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.

Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 24, 36);
insert into PeerStory (review, userID, companyID) values ('Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 25, 33);
insert into PeerStory (review, userID, companyID) values ('Phasellus in felis. Donec semper sapien a libero. Nam dui.', 26, 24);
insert into PeerStory (review, userID, companyID) values ('Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 27, 32);
insert into PeerStory (review, userID, companyID) values ('Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.

Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 28, 18);
insert into PeerStory (review, userID, companyID) values ('Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.

Sed ante. Vivamus tortor. Duis mattis egestas metus.', 29, 5);
insert into PeerStory (review, userID, companyID) values ('Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 30, 7);
insert into PeerStory (review, userID, companyID) values ('Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 31, 13);
insert into PeerStory (review, userID, companyID) values ('Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', 32, 31);
insert into PeerStory (review, userID, companyID) values ('Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 33, 21);
insert into PeerStory (review, userID, companyID) values ('Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.

Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 34, 29);
insert into PeerStory (review, userID, companyID) values ('Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.

Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 35, 35);
insert into PeerStory (review, userID, companyID) values ('Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 36, 18);
insert into PeerStory (review, userID, companyID) values ('In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 37, 28);
insert into PeerStory (review, userID, companyID) values ('In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.

Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 38, 25);
insert into PeerStory (review, userID, companyID) values ('Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.

Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 39, 19);
insert into PeerStory (review, userID, companyID) values ('Sed ante. Vivamus tortor. Duis mattis egestas metus.', 40, 34);
-- User_Question

insert into User_question (userID, questionID) values (3, 12);
insert into User_question (userID, questionID) values (25, 18);
insert into User_question (userID, questionID) values (7, 6);
insert into User_question (userID, questionID) values (22, 24);
insert into User_question (userID, questionID) values (29, 3);
insert into User_question (userID, questionID) values (14, 37);
insert into User_question (userID, questionID) values (32, 19);
insert into User_question (userID, questionID) values (17, 11);
insert into User_question (userID, questionID) values (19, 27);
insert into User_question (userID, questionID) values (21, 39);
insert into User_question (userID, questionID) values (22, 5);
insert into User_question (userID, questionID) values (10, 25);
insert into User_question (userID, questionID) values (34, 7);
insert into User_question (userID, questionID) values (27, 16);
insert into User_question (userID, questionID) values (18, 35);
insert into User_question (userID, questionID) values (16, 27);
insert into User_question (userID, questionID) values (16, 22);
insert into User_question (userID, questionID) values (13, 39);
insert into User_question (userID, questionID) values (2, 12);
insert into User_question (userID, questionID) values (31, 37);
insert into User_question (userID, questionID) values (5, 38);
insert into User_question (userID, questionID) values (3, 23);
insert into User_question (userID, questionID) values (35, 23);
insert into User_question (userID, questionID) values (17, 24);
insert into User_question (userID, questionID) values (36, 15);
insert into User_question (userID, questionID) values (22, 15);
insert into User_question (userID, questionID) values (18, 33);
insert into User_question (userID, questionID) values (29, 17);
insert into User_question (userID, questionID) values (20, 26);
insert into User_question (userID, questionID) values (24, 8);
insert into User_question (userID, questionID) values (37, 26);
insert into User_question (userID, questionID) values (36, 6);
insert into User_question (userID, questionID) values (38, 33);
insert into User_question (userID, questionID) values (3, 1);
insert into User_question (userID, questionID) values (13, 24);
insert into User_question (userID, questionID) values (39, 33);
insert into User_question (userID, questionID) values (1, 15);
insert into User_question (userID, questionID) values (2, 38);
insert into User_question (userID, questionID) values (13, 6);
insert into User_question (userID, questionID) values (32, 37);
insert into User_question (userID, questionID) values (11, 26);
insert into User_question (userID, questionID) values (38, 21);
insert into User_question (userID, questionID) values (12, 17);
insert into User_question (userID, questionID) values (34, 38);
insert into User_question (userID, questionID) values (13, 36);
insert into User_question (userID, questionID) values (18, 17);
insert into User_question (userID, questionID) values (10, 13);
insert into User_question (userID, questionID) values (6, 8);
insert into User_question (userID, questionID) values (36, 37);
insert into User_question (userID, questionID) values (33, 38);
insert into User_question (userID, questionID) values (40, 22);
insert into User_question (userID, questionID) values (28, 21);
insert into User_question (userID, questionID) values (19, 26);
insert into User_question (userID, questionID) values (22, 13);
insert into User_question (userID, questionID) values (1, 26);
insert into User_question (userID, questionID) values (2, 39);
insert into User_question (userID, questionID) values (38, 32);
insert into User_question (userID, questionID) values (7, 13);
insert into User_question (userID, questionID) values (20, 30);
insert into User_question (userID, questionID) values (1, 29);
insert into User_question (userID, questionID) values (31, 32);
insert into User_question (userID, questionID) values (11, 12);
insert into User_question (userID, questionID) values (13, 8);
insert into User_question (userID, questionID) values (13, 17);
insert into User_question (userID, questionID) values (18, 22);
insert into User_question (userID, questionID) values (19, 30);
insert into User_question (userID, questionID) values (34, 16);
insert into User_question (userID, questionID) values (17, 2);
insert into User_question (userID, questionID) values (34, 24);
insert into User_question (userID, questionID) values (25, 34);
insert into User_question (userID, questionID) values (18, 25);
insert into User_question (userID, questionID) values (3, 38);
insert into User_question (userID, questionID) values (15, 4);
insert into User_question (userID, questionID) values (20, 37);
insert into User_question (userID, questionID) values (2, 29);
insert into User_question (userID, questionID) values (15, 16);
insert into User_question (userID, questionID) values (28, 7);
insert into User_question (userID, questionID) values (5, 14);
insert into User_question (userID, questionID) values (1, 9);
insert into User_question (userID, questionID) values (39, 21);
insert into User_question (userID, questionID) values (39, 37);
insert into User_question (userID, questionID) values (7, 12);
insert into User_question (userID, questionID) values (36, 11);
insert into User_question (userID, questionID) values (11, 25);
insert into User_question (userID, questionID) values (20, 36);
insert into User_question (userID, questionID) values (21, 5);
insert into User_question (userID, questionID) values (19, 17);
insert into User_question (userID, questionID) values (13, 10);
insert into User_question (userID, questionID) values (26, 8);
insert into User_question (userID, questionID) values (25, 30);
insert into User_question (userID, questionID) values (13, 13);
insert into User_question (userID, questionID) values (19, 31);
insert into User_question (userID, questionID) values (23, 38);
insert into User_question (userID, questionID) values (23, 22);
insert into User_question (userID, questionID) values (2, 16);
insert into User_question (userID, questionID) values (17, 29);
insert into User_question (userID, questionID) values (36, 20);
insert into User_question (userID, questionID) values (9, 28);
insert into User_question (userID, questionID) values (18, 40);
insert into User_question (userID, questionID) values (15, 34);
-- Stu_Iprep

insert into Stu_Iprep (userID, interviewPrepID, date) values (5, 40, '2024-12-25');
insert into Stu_Iprep (userID, interviewPrepID, date) values (35, 30, '2024-04-17');
insert into Stu_Iprep (userID, interviewPrepID, date) values (6, 27, '2024-01-18');
insert into Stu_Iprep (userID, interviewPrepID, date) values (8, 14, '2025-02-26');
insert into Stu_Iprep (userID, interviewPrepID, date) values (24, 33, '2025-11-25');
insert into Stu_Iprep (userID, interviewPrepID, date) values (3, 16, '2024-12-16');
insert into Stu_Iprep (userID, interviewPrepID, date) values (5, 3, '2024-11-22');
insert into Stu_Iprep (userID, interviewPrepID, date) values (36, 27, '2024-03-14');
insert into Stu_Iprep (userID, interviewPrepID, date) values (37, 6, '2024-07-01');
insert into Stu_Iprep (userID, interviewPrepID, date) values (31, 33, '2025-10-29');
insert into Stu_Iprep (userID, interviewPrepID, date) values (6, 30, '2024-03-27');
insert into Stu_Iprep (userID, interviewPrepID, date) values (39, 16, '2024-07-08');
insert into Stu_Iprep (userID, interviewPrepID, date) values (18, 16, '2024-09-19');
insert into Stu_Iprep (userID, interviewPrepID, date) values (31, 1, '2024-11-09');
insert into Stu_Iprep (userID, interviewPrepID, date) values (34, 34, '2024-12-26');
insert into Stu_Iprep (userID, interviewPrepID, date) values (4, 40, '2024-12-06');
insert into Stu_Iprep (userID, interviewPrepID, date) values (11, 33, '2024-05-25');
insert into Stu_Iprep (userID, interviewPrepID, date) values (14, 26, '2025-11-18');
insert into Stu_Iprep (userID, interviewPrepID, date) values (24, 14, '2024-06-28');
insert into Stu_Iprep (userID, interviewPrepID, date) values (4, 23, '2025-09-25');
insert into Stu_Iprep (userID, interviewPrepID, date) values (34, 11, '2025-06-17');
insert into Stu_Iprep (userID, interviewPrepID, date) values (33, 39, '2024-11-26');
insert into Stu_Iprep (userID, interviewPrepID, date) values (6, 14, '2024-09-17');
insert into Stu_Iprep (userID, interviewPrepID, date) values (2, 21, '2024-05-13');
insert into Stu_Iprep (userID, interviewPrepID, date) values (34, 36, '2024-01-10');
insert into Stu_Iprep (userID, interviewPrepID, date) values (6, 3, '2025-08-19');
insert into Stu_Iprep (userID, interviewPrepID, date) values (4, 21, '2024-06-13');
insert into Stu_Iprep (userID, interviewPrepID, date) values (16, 1, '2025-03-06');
insert into Stu_Iprep (userID, interviewPrepID, date) values (32, 25, '2024-07-31');
insert into Stu_Iprep (userID, interviewPrepID, date) values (12, 7, '2024-08-05');
insert into Stu_Iprep (userID, interviewPrepID, date) values (17, 5, '2025-04-08');
insert into Stu_Iprep (userID, interviewPrepID, date) values (22, 23, '2025-01-13');
insert into Stu_Iprep (userID, interviewPrepID, date) values (40, 28, '2025-03-04');
insert into Stu_Iprep (userID, interviewPrepID, date) values (6, 11, '2024-04-15');
insert into Stu_Iprep (userID, interviewPrepID, date) values (35, 24, '2025-05-27');
insert into Stu_Iprep (userID, interviewPrepID, date) values (18, 3, '2025-10-06');
insert into Stu_Iprep (userID, interviewPrepID, date) values (33, 37, '2025-07-14');
insert into Stu_Iprep (userID, interviewPrepID, date) values (17, 1, '2025-12-09');
insert into Stu_Iprep (userID, interviewPrepID, date) values (36, 22, '2025-09-20');
insert into Stu_Iprep (userID, interviewPrepID, date) values (40, 31, '2024-01-05');
insert into Stu_Iprep (userID, interviewPrepID, date) values (30, 39, '2025-08-28');
insert into Stu_Iprep (userID, interviewPrepID, date) values (17, 23, '2024-12-15');
insert into Stu_Iprep (userID, interviewPrepID, date) values (33, 2, '2024-09-17');
insert into Stu_Iprep (userID, interviewPrepID, date) values (39, 32, '2024-08-29');
insert into Stu_Iprep (userID, interviewPrepID, date) values (25, 5, '2024-06-26');
insert into Stu_Iprep (userID, interviewPrepID, date) values (24, 7, '2025-09-20');
insert into Stu_Iprep (userID, interviewPrepID, date) values (23, 5, '2024-09-02');
insert into Stu_Iprep (userID, interviewPrepID, date) values (28, 32, '2025-09-03');
insert into Stu_Iprep (userID, interviewPrepID, date) values (39, 18, '2025-09-14');
insert into Stu_Iprep (userID, interviewPrepID, date) values (5, 37, '2025-12-28');
insert into Stu_Iprep (userID, interviewPrepID, date) values (15, 29, '2025-08-17');
insert into Stu_Iprep (userID, interviewPrepID, date) values (13, 38, '2025-07-17');
insert into Stu_Iprep (userID, interviewPrepID, date) values (36, 23, '2024-03-07');
insert into Stu_Iprep (userID, interviewPrepID, date) values (33, 3, '2025-11-19');
insert into Stu_Iprep (userID, interviewPrepID, date) values (15, 6, '2025-12-27');
insert into Stu_Iprep (userID, interviewPrepID, date) values (6, 33, '2025-04-10');
insert into Stu_Iprep (userID, interviewPrepID, date) values (36, 32, '2025-04-25');
insert into Stu_Iprep (userID, interviewPrepID, date) values (7, 23, '2025-04-18');
insert into Stu_Iprep (userID, interviewPrepID, date) values (35, 28, '2025-01-23');
insert into Stu_Iprep (userID, interviewPrepID, date) values (13, 6, '2025-01-07');
insert into Stu_Iprep (userID, interviewPrepID, date) values (33, 25, '2024-12-14');
insert into Stu_Iprep (userID, interviewPrepID, date) values (13, 22, '2024-10-08');
insert into Stu_Iprep (userID, interviewPrepID, date) values (4, 37, '2025-10-07');
insert into Stu_Iprep (userID, interviewPrepID, date) values (34, 29, '2025-08-09');
insert into Stu_Iprep (userID, interviewPrepID, date) values (23, 35, '2025-08-08');
insert into Stu_Iprep (userID, interviewPrepID, date) values (39, 6, '2025-11-17');
insert into Stu_Iprep (userID, interviewPrepID, date) values (33, 34, '2024-10-12');
insert into Stu_Iprep (userID, interviewPrepID, date) values (39, 21, '2024-04-20');
insert into Stu_Iprep (userID, interviewPrepID, date) values (38, 5, '2025-03-25');
insert into Stu_Iprep (userID, interviewPrepID, date) values (36, 29, '2025-04-23');
insert into Stu_Iprep (userID, interviewPrepID, date) values (8, 38, '2024-09-12');
insert into Stu_Iprep (userID, interviewPrepID, date) values (35, 6, '2025-08-03');
insert into Stu_Iprep (userID, interviewPrepID, date) values (34, 39, '2025-08-13');
insert into Stu_Iprep (userID, interviewPrepID, date) values (29, 22, '2024-05-24');
insert into Stu_Iprep (userID, interviewPrepID, date) values (8, 34, '2025-08-21');
insert into Stu_Iprep (userID, interviewPrepID, date) values (17, 3, '2025-03-31');
insert into Stu_Iprep (userID, interviewPrepID, date) values (34, 9, '2025-04-19');
insert into Stu_Iprep (userID, interviewPrepID, date) values (13, 27, '2025-12-24');
insert into Stu_Iprep (userID, interviewPrepID, date) values (31, 36, '2024-08-03');
insert into Stu_Iprep (userID, interviewPrepID, date) values (15, 28, '2025-06-18');
insert into Stu_Iprep (userID, interviewPrepID, date) values (33, 33, '2024-04-07');
insert into Stu_Iprep (userID, interviewPrepID, date) values (20, 36, '2024-03-19');
insert into Stu_Iprep (userID, interviewPrepID, date) values (8, 30, '2025-06-04');
insert into Stu_Iprep (userID, interviewPrepID, date) values (19, 25, '2024-04-12');
insert into Stu_Iprep (userID, interviewPrepID, date) values (37, 39, '2024-03-01');
insert into Stu_Iprep (userID, interviewPrepID, date) values (28, 3, '2025-04-08');
insert into Stu_Iprep (userID, interviewPrepID, date) values (9, 17, '2025-10-11');
insert into Stu_Iprep (userID, interviewPrepID, date) values (37, 40, '2024-12-12');
insert into Stu_Iprep (userID, interviewPrepID, date) values (25, 18, '2025-03-10');
insert into Stu_Iprep (userID, interviewPrepID, date) values (40, 7, '2024-08-01');
insert into Stu_Iprep (userID, interviewPrepID, date) values (36, 18, '2025-05-09');
insert into Stu_Iprep (userID, interviewPrepID, date) values (17, 11, '2024-03-02');
insert into Stu_Iprep (userID, interviewPrepID, date) values (15, 32, '2024-10-26');
insert into Stu_Iprep (userID, interviewPrepID, date) values (10, 16, '2024-05-09');
insert into Stu_Iprep (userID, interviewPrepID, date) values (30, 8, '2025-01-16');
insert into Stu_Iprep (userID, interviewPrepID, date) values (10, 37, '2024-08-15');
insert into Stu_Iprep (userID, interviewPrepID, date) values (23, 36, '2025-01-31');
insert into Stu_Iprep (userID, interviewPrepID, date) values (1, 1, '2024-05-23');
insert into Stu_Iprep (userID, interviewPrepID, date) values (39, 24, '2025-11-18');
insert into Stu_Iprep (userID, interviewPrepID, date) values (22, 17, '2024-10-18');
-- TA_Iprep

insert into Ta_Iprep (userID, interviewPrepID) values (27, 29);
insert into Ta_Iprep (userID, interviewPrepID) values (19, 16);
insert into Ta_Iprep (userID, interviewPrepID) values (28, 38);
insert into Ta_Iprep (userID, interviewPrepID) values (24, 23);
insert into Ta_Iprep (userID, interviewPrepID) values (26, 7);
insert into Ta_Iprep (userID, interviewPrepID) values (29, 39);
insert into Ta_Iprep (userID, interviewPrepID) values (21, 26);
insert into Ta_Iprep (userID, interviewPrepID) values (32, 10);
insert into Ta_Iprep (userID, interviewPrepID) values (31, 15);
insert into Ta_Iprep (userID, interviewPrepID) values (22, 31);
insert into Ta_Iprep (userID, interviewPrepID) values (6, 24);
insert into Ta_Iprep (userID, interviewPrepID) values (15, 15);
insert into Ta_Iprep (userID, interviewPrepID) values (33, 25);
insert into Ta_Iprep (userID, interviewPrepID) values (32, 13);
insert into Ta_Iprep (userID, interviewPrepID) values (19, 29);
insert into Ta_Iprep (userID, interviewPrepID) values (26, 27);
insert into Ta_Iprep (userID, interviewPrepID) values (18, 21);
insert into Ta_Iprep (userID, interviewPrepID) values (20, 22);
insert into Ta_Iprep (userID, interviewPrepID) values (13, 11);
insert into Ta_Iprep (userID, interviewPrepID) values (34, 23);
insert into Ta_Iprep (userID, interviewPrepID) values (7, 10);
insert into Ta_Iprep (userID, interviewPrepID) values (6, 1);
insert into Ta_Iprep (userID, interviewPrepID) values (19, 8);
insert into Ta_Iprep (userID, interviewPrepID) values (16, 29);
insert into Ta_Iprep (userID, interviewPrepID) values (17, 18);
insert into Ta_Iprep (userID, interviewPrepID) values (30, 14);
insert into Ta_Iprep (userID, interviewPrepID) values (3, 7);
insert into Ta_Iprep (userID, interviewPrepID) values (19, 31);
insert into Ta_Iprep (userID, interviewPrepID) values (34, 29);
insert into Ta_Iprep (userID, interviewPrepID) values (26, 39);
insert into Ta_Iprep (userID, interviewPrepID) values (22, 1);
insert into Ta_Iprep (userID, interviewPrepID) values (12, 27);
insert into Ta_Iprep (userID, interviewPrepID) values (37, 6);
insert into Ta_Iprep (userID, interviewPrepID) values (5, 40);
insert into Ta_Iprep (userID, interviewPrepID) values (28, 40);
insert into Ta_Iprep (userID, interviewPrepID) values (18, 6);
insert into Ta_Iprep (userID, interviewPrepID) values (21, 24);
insert into Ta_Iprep (userID, interviewPrepID) values (10, 26);
insert into Ta_Iprep (userID, interviewPrepID) values (29, 14);
insert into Ta_Iprep (userID, interviewPrepID) values (12, 40);
insert into Ta_Iprep (userID, interviewPrepID) values (22, 14);
insert into Ta_Iprep (userID, interviewPrepID) values (38, 7);
insert into Ta_Iprep (userID, interviewPrepID) values (38, 38);
insert into Ta_Iprep (userID, interviewPrepID) values (26, 23);
insert into Ta_Iprep (userID, interviewPrepID) values (39, 20);
insert into Ta_Iprep (userID, interviewPrepID) values (39, 28);
insert into Ta_Iprep (userID, interviewPrepID) values (4, 1);
insert into Ta_Iprep (userID, interviewPrepID) values (21, 11);
insert into Ta_Iprep (userID, interviewPrepID) values (15, 33);
insert into Ta_Iprep (userID, interviewPrepID) values (27, 15);
insert into Ta_Iprep (userID, interviewPrepID) values (23, 12);
insert into Ta_Iprep (userID, interviewPrepID) values (8, 20);
insert into Ta_Iprep (userID, interviewPrepID) values (9, 36);
insert into Ta_Iprep (userID, interviewPrepID) values (9, 27);
insert into Ta_Iprep (userID, interviewPrepID) values (18, 28);
insert into Ta_Iprep (userID, interviewPrepID) values (33, 29);
insert into Ta_Iprep (userID, interviewPrepID) values (1, 13);
insert into Ta_Iprep (userID, interviewPrepID) values (19, 21);
insert into Ta_Iprep (userID, interviewPrepID) values (29, 33);
insert into Ta_Iprep (userID, interviewPrepID) values (7, 9);
insert into Ta_Iprep (userID, interviewPrepID) values (37, 15);
insert into Ta_Iprep (userID, interviewPrepID) values (4, 15);
insert into Ta_Iprep (userID, interviewPrepID) values (2, 35);
insert into Ta_Iprep (userID, interviewPrepID) values (36, 6);
insert into Ta_Iprep (userID, interviewPrepID) values (3, 28);
insert into Ta_Iprep (userID, interviewPrepID) values (25, 16);
insert into Ta_Iprep (userID, interviewPrepID) values (10, 32);
insert into Ta_Iprep (userID, interviewPrepID) values (26, 30);
insert into Ta_Iprep (userID, interviewPrepID) values (8, 39);
insert into Ta_Iprep (userID, interviewPrepID) values (36, 11);
insert into Ta_Iprep (userID, interviewPrepID) values (14, 4);
insert into Ta_Iprep (userID, interviewPrepID) values (16, 16);
insert into Ta_Iprep (userID, interviewPrepID) values (33, 10);
insert into Ta_Iprep (userID, interviewPrepID) values (30, 35);
insert into Ta_Iprep (userID, interviewPrepID) values (40, 31);
insert into Ta_Iprep (userID, interviewPrepID) values (40, 19);
insert into Ta_Iprep (userID, interviewPrepID) values (14, 9);
insert into Ta_Iprep (userID, interviewPrepID) values (22, 34);
insert into Ta_Iprep (userID, interviewPrepID) values (29, 8);
insert into Ta_Iprep (userID, interviewPrepID) values (40, 2);
insert into Ta_Iprep (userID, interviewPrepID) values (3, 30);
insert into Ta_Iprep (userID, interviewPrepID) values (5, 1);
insert into Ta_Iprep (userID, interviewPrepID) values (40, 28);
insert into Ta_Iprep (userID, interviewPrepID) values (21, 37);
insert into Ta_Iprep (userID, interviewPrepID) values (8, 2);
insert into Ta_Iprep (userID, interviewPrepID) values (4, 19);
insert into Ta_Iprep (userID, interviewPrepID) values (12, 21);
insert into Ta_Iprep (userID, interviewPrepID) values (30, 8);
insert into Ta_Iprep (userID, interviewPrepID) values (38, 40);
insert into Ta_Iprep (userID, interviewPrepID) values (38, 29);
insert into Ta_Iprep (userID, interviewPrepID) values (30, 26);
insert into Ta_Iprep (userID, interviewPrepID) values (5, 12);
insert into Ta_Iprep (userID, interviewPrepID) values (8, 37);
insert into Ta_Iprep (userID, interviewPrepID) values (7, 6);
insert into Ta_Iprep (userID, interviewPrepID) values (10, 29);
insert into Ta_Iprep (userID, interviewPrepID) values (10, 8);
insert into Ta_Iprep (userID, interviewPrepID) values (9, 31);
insert into Ta_Iprep (userID, interviewPrepID) values (10, 38);
insert into Ta_Iprep (userID, interviewPrepID) values (34, 3);
insert into Ta_Iprep (userID, interviewPrepID) values (22, 11);
-- Iprep_question

insert into Iprep_question (questionID, interviewPrepID) values (7, 39);
insert into Iprep_question (questionID, interviewPrepID) values (31, 15);
insert into Iprep_question (questionID, interviewPrepID) values (16, 19);
insert into Iprep_question (questionID, interviewPrepID) values (38, 6);
insert into Iprep_question (questionID, interviewPrepID) values (21, 10);
insert into Iprep_question (questionID, interviewPrepID) values (2, 15);
insert into Iprep_question (questionID, interviewPrepID) values (19, 4);
insert into Iprep_question (questionID, interviewPrepID) values (23, 13);
insert into Iprep_question (questionID, interviewPrepID) values (12, 23);
insert into Iprep_question (questionID, interviewPrepID) values (10, 14);
insert into Iprep_question (questionID, interviewPrepID) values (24, 1);
insert into Iprep_question (questionID, interviewPrepID) values (28, 16);
insert into Iprep_question (questionID, interviewPrepID) values (40, 13);
insert into Iprep_question (questionID, interviewPrepID) values (32, 26);
insert into Iprep_question (questionID, interviewPrepID) values (23, 33);
insert into Iprep_question (questionID, interviewPrepID) values (36, 26);
insert into Iprep_question (questionID, interviewPrepID) values (25, 33);
insert into Iprep_question (questionID, interviewPrepID) values (4, 17);
insert into Iprep_question (questionID, interviewPrepID) values (7, 3);
insert into Iprep_question (questionID, interviewPrepID) values (10, 3);
insert into Iprep_question (questionID, interviewPrepID) values (1, 24);
insert into Iprep_question (questionID, interviewPrepID) values (28, 12);
insert into Iprep_question (questionID, interviewPrepID) values (24, 10);
insert into Iprep_question (questionID, interviewPrepID) values (23, 9);
insert into Iprep_question (questionID, interviewPrepID) values (20, 16);
insert into Iprep_question (questionID, interviewPrepID) values (33, 33);
insert into Iprep_question (questionID, interviewPrepID) values (14, 14);
insert into Iprep_question (questionID, interviewPrepID) values (32, 36);
insert into Iprep_question (questionID, interviewPrepID) values (13, 15);
insert into Iprep_question (questionID, interviewPrepID) values (18, 21);
insert into Iprep_question (questionID, interviewPrepID) values (15, 3);
insert into Iprep_question (questionID, interviewPrepID) values (27, 37);
insert into Iprep_question (questionID, interviewPrepID) values (39, 8);
insert into Iprep_question (questionID, interviewPrepID) values (3, 10);
insert into Iprep_question (questionID, interviewPrepID) values (6, 38);
insert into Iprep_question (questionID, interviewPrepID) values (28, 5);
insert into Iprep_question (questionID, interviewPrepID) values (10, 12);
insert into Iprep_question (questionID, interviewPrepID) values (16, 24);
insert into Iprep_question (questionID, interviewPrepID) values (40, 14);
insert into Iprep_question (questionID, interviewPrepID) values (18, 36);
insert into Iprep_question (questionID, interviewPrepID) values (28, 13);
insert into Iprep_question (questionID, interviewPrepID) values (36, 32);
insert into Iprep_question (questionID, interviewPrepID) values (17, 26);
insert into Iprep_question (questionID, interviewPrepID) values (1, 3);
insert into Iprep_question (questionID, interviewPrepID) values (36, 18);
insert into Iprep_question (questionID, interviewPrepID) values (33, 40);
insert into Iprep_question (questionID, interviewPrepID) values (23, 17);
insert into Iprep_question (questionID, interviewPrepID) values (1, 6);
insert into Iprep_question (questionID, interviewPrepID) values (38, 21);
insert into Iprep_question (questionID, interviewPrepID) values (34, 22);
insert into Iprep_question (questionID, interviewPrepID) values (19, 27);
insert into Iprep_question (questionID, interviewPrepID) values (37, 33);
insert into Iprep_question (questionID, interviewPrepID) values (12, 3);
insert into Iprep_question (questionID, interviewPrepID) values (27, 35);
insert into Iprep_question (questionID, interviewPrepID) values (19, 15);
insert into Iprep_question (questionID, interviewPrepID) values (4, 1);
insert into Iprep_question (questionID, interviewPrepID) values (34, 7);
insert into Iprep_question (questionID, interviewPrepID) values (15, 26);
insert into Iprep_question (questionID, interviewPrepID) values (13, 17);
insert into Iprep_question (questionID, interviewPrepID) values (25, 17);
insert into Iprep_question (questionID, interviewPrepID) values (3, 34);
insert into Iprep_question (questionID, interviewPrepID) values (18, 8);
insert into Iprep_question (questionID, interviewPrepID) values (40, 15);
insert into Iprep_question (questionID, interviewPrepID) values (37, 10);
insert into Iprep_question (questionID, interviewPrepID) values (25, 35);
insert into Iprep_question (questionID, interviewPrepID) values (27, 7);
insert into Iprep_question (questionID, interviewPrepID) values (17, 5);
insert into Iprep_question (questionID, interviewPrepID) values (33, 38);
insert into Iprep_question (questionID, interviewPrepID) values (18, 22);
insert into Iprep_question (questionID, interviewPrepID) values (24, 34);
insert into Iprep_question (questionID, interviewPrepID) values (15, 15);
insert into Iprep_question (questionID, interviewPrepID) values (19, 17);
insert into Iprep_question (questionID, interviewPrepID) values (9, 38);
insert into Iprep_question (questionID, interviewPrepID) values (16, 38);
insert into Iprep_question (questionID, interviewPrepID) values (31, 26);
insert into Iprep_question (questionID, interviewPrepID) values (26, 40);
insert into Iprep_question (questionID, interviewPrepID) values (25, 31);
insert into Iprep_question (questionID, interviewPrepID) values (25, 3);
insert into Iprep_question (questionID, interviewPrepID) values (29, 27);
insert into Iprep_question (questionID, interviewPrepID) values (16, 26);
insert into Iprep_question (questionID, interviewPrepID) values (2, 21);
insert into Iprep_question (questionID, interviewPrepID) values (37, 40);
insert into Iprep_question (questionID, interviewPrepID) values (21, 20);
insert into Iprep_question (questionID, interviewPrepID) values (13, 26);
insert into Iprep_question (questionID, interviewPrepID) values (13, 11);
insert into Iprep_question (questionID, interviewPrepID) values (17, 14);
insert into Iprep_question (questionID, interviewPrepID) values (32, 25);
insert into Iprep_question (questionID, interviewPrepID) values (20, 1);
insert into Iprep_question (questionID, interviewPrepID) values (18, 25);
insert into Iprep_question (questionID, interviewPrepID) values (9, 30);
insert into Iprep_question (questionID, interviewPrepID) values (17, 20);
insert into Iprep_question (questionID, interviewPrepID) values (16, 17);
insert into Iprep_question (questionID, interviewPrepID) values (17, 4);
insert into Iprep_question (questionID, interviewPrepID) values (35, 36);
insert into Iprep_question (questionID, interviewPrepID) values (28, 24);
insert into Iprep_question (questionID, interviewPrepID) values (18, 7);
insert into Iprep_question (questionID, interviewPrepID) values (28, 8);
insert into Iprep_question (questionID, interviewPrepID) values (17, 13);
insert into Iprep_question (questionID, interviewPrepID) values (22, 28);
insert into Iprep_question (questionID, interviewPrepID) values (23, 2);

-- User_story

insert into User_story (userID, peerStoryID) values (6, 39);
insert into User_story (userID, peerStoryID) values (32, 12);
insert into User_story (userID, peerStoryID) values (1, 11);
insert into User_story (userID, peerStoryID) values (30, 5);
insert into User_story (userID, peerStoryID) values (9, 35);
insert into User_story (userID, peerStoryID) values (5, 22);
insert into User_story (userID, peerStoryID) values (21, 37);
insert into User_story (userID, peerStoryID) values (27, 7);
insert into User_story (userID, peerStoryID) values (28, 23);
insert into User_story (userID, peerStoryID) values (40, 15);
insert into User_story (userID, peerStoryID) values (7, 13);
insert into User_story (userID, peerStoryID) values (7, 38);
insert into User_story (userID, peerStoryID) values (1, 38);
insert into User_story (userID, peerStoryID) values (38, 12);
insert into User_story (userID, peerStoryID) values (22, 24);
insert into User_story (userID, peerStoryID) values (30, 23);
insert into User_story (userID, peerStoryID) values (37, 29);
insert into User_story (userID, peerStoryID) values (19, 22);
insert into User_story (userID, peerStoryID) values (21, 12);
insert into User_story (userID, peerStoryID) values (36, 9);
insert into User_story (userID, peerStoryID) values (6, 37);
insert into User_story (userID, peerStoryID) values (29, 16);
insert into User_story (userID, peerStoryID) values (12, 1);
insert into User_story (userID, peerStoryID) values (21, 10);
insert into User_story (userID, peerStoryID) values (17, 16);
insert into User_story (userID, peerStoryID) values (17, 23);
insert into User_story (userID, peerStoryID) values (4, 26);
insert into User_story (userID, peerStoryID) values (17, 15);
insert into User_story (userID, peerStoryID) values (29, 40);
insert into User_story (userID, peerStoryID) values (17, 11);
insert into User_story (userID, peerStoryID) values (37, 16);
insert into User_story (userID, peerStoryID) values (20, 32);
insert into User_story (userID, peerStoryID) values (14, 26);
insert into User_story (userID, peerStoryID) values (29, 21);
insert into User_story (userID, peerStoryID) values (13, 30);
insert into User_story (userID, peerStoryID) values (19, 23);
insert into User_story (userID, peerStoryID) values (36, 10);
insert into User_story (userID, peerStoryID) values (10, 3);
insert into User_story (userID, peerStoryID) values (12, 13);
insert into User_story (userID, peerStoryID) values (2, 6);
insert into User_story (userID, peerStoryID) values (14, 15);
insert into User_story (userID, peerStoryID) values (39, 7);
insert into User_story (userID, peerStoryID) values (26, 25);
insert into User_story (userID, peerStoryID) values (12, 8);
insert into User_story (userID, peerStoryID) values (20, 31);
insert into User_story (userID, peerStoryID) values (3, 20);
insert into User_story (userID, peerStoryID) values (27, 15);
insert into User_story (userID, peerStoryID) values (10, 38);
insert into User_story (userID, peerStoryID) values (8, 26);
insert into User_story (userID, peerStoryID) values (24, 22);
insert into User_story (userID, peerStoryID) values (30, 24);
insert into User_story (userID, peerStoryID) values (12, 9);
insert into User_story (userID, peerStoryID) values (5, 26);
insert into User_story (userID, peerStoryID) values (30, 6);
insert into User_story (userID, peerStoryID) values (17, 8);
insert into User_story (userID, peerStoryID) values (18, 17);
insert into User_story (userID, peerStoryID) values (34, 18);
insert into User_story (userID, peerStoryID) values (27, 4);
insert into User_story (userID, peerStoryID) values (2, 3);
insert into User_story (userID, peerStoryID) values (39, 17);
insert into User_story (userID, peerStoryID) values (28, 22);
insert into User_story (userID, peerStoryID) values (40, 1);
insert into User_story (userID, peerStoryID) values (28, 29);
insert into User_story (userID, peerStoryID) values (14, 11);
insert into User_story (userID, peerStoryID) values (14, 21);
insert into User_story (userID, peerStoryID) values (36, 11);
insert into User_story (userID, peerStoryID) values (35, 17);
insert into User_story (userID, peerStoryID) values (38, 8);
insert into User_story (userID, peerStoryID) values (21, 2);
insert into User_story (userID, peerStoryID) values (15, 38);
insert into User_story (userID, peerStoryID) values (39, 28);
insert into User_story (userID, peerStoryID) values (6, 33);
insert into User_story (userID, peerStoryID) values (3, 7);
insert into User_story (userID, peerStoryID) values (4, 21);
insert into User_story (userID, peerStoryID) values (37, 24);
insert into User_story (userID, peerStoryID) values (12, 10);
insert into User_story (userID, peerStoryID) values (27, 5);
insert into User_story (userID, peerStoryID) values (35, 23);
insert into User_story (userID, peerStoryID) values (20, 20);
insert into User_story (userID, peerStoryID) values (3, 14);
insert into User_story (userID, peerStoryID) values (26, 31);
insert into User_story (userID, peerStoryID) values (1, 35);
insert into User_story (userID, peerStoryID) values (34, 25);
insert into User_story (userID, peerStoryID) values (7, 4);
insert into User_story (userID, peerStoryID) values (1, 37);
insert into User_story (userID, peerStoryID) values (18, 26);
insert into User_story (userID, peerStoryID) values (8, 19);
insert into User_story (userID, peerStoryID) values (20, 40);
insert into User_story (userID, peerStoryID) values (18, 32);
insert into User_story (userID, peerStoryID) values (10, 17);
insert into User_story (userID, peerStoryID) values (11, 32);
insert into User_story (userID, peerStoryID) values (7, 14);
insert into User_story (userID, peerStoryID) values (26, 1);
insert into User_story (userID, peerStoryID) values (15, 9);
insert into User_story (userID, peerStoryID) values (35, 1);
insert into User_story (userID, peerStoryID) values (5, 9);
insert into User_story (userID, peerStoryID) values (20, 24);
insert into User_story (userID, peerStoryID) values (11, 2);
insert into User_story (userID, peerStoryID) values (40, 23);
insert into User_story (userID, peerStoryID) values (30, 3);
-- Question_comp

insert into Question_comp (questionID, companyID) values (29, 25);
insert into Question_comp (questionID, companyID) values (14, 8);
insert into Question_comp (questionID, companyID) values (19, 14);
insert into Question_comp (questionID, companyID) values (25, 3);
insert into Question_comp (questionID, companyID) values (19, 12);
insert into Question_comp (questionID, companyID) values (24, 33);
insert into Question_comp (questionID, companyID) values (31, 4);
insert into Question_comp (questionID, companyID) values (35, 2);
insert into Question_comp (questionID, companyID) values (32, 34);
insert into Question_comp (questionID, companyID) values (4, 1);
insert into Question_comp (questionID, companyID) values (2, 9);
insert into Question_comp (questionID, companyID) values (16, 11);
insert into Question_comp (questionID, companyID) values (4, 36);
insert into Question_comp (questionID, companyID) values (3, 10);
insert into Question_comp (questionID, companyID) values (29, 35);
insert into Question_comp (questionID, companyID) values (30, 30);
insert into Question_comp (questionID, companyID) values (6, 3);
insert into Question_comp (questionID, companyID) values (37, 12);
insert into Question_comp (questionID, companyID) values (18, 33);
insert into Question_comp (questionID, companyID) values (5, 18);
insert into Question_comp (questionID, companyID) values (22, 1);
insert into Question_comp (questionID, companyID) values (17, 25);
insert into Question_comp (questionID, companyID) values (28, 38);
insert into Question_comp (questionID, companyID) values (31, 19);
insert into Question_comp (questionID, companyID) values (38, 9);
insert into Question_comp (questionID, companyID) values (25, 12);
insert into Question_comp (questionID, companyID) values (13, 11);
insert into Question_comp (questionID, companyID) values (35, 12);
insert into Question_comp (questionID, companyID) values (33, 8);
insert into Question_comp (questionID, companyID) values (9, 2);
insert into Question_comp (questionID, companyID) values (9, 20);
insert into Question_comp (questionID, companyID) values (3, 30);
insert into Question_comp (questionID, companyID) values (38, 7);
insert into Question_comp (questionID, companyID) values (38, 20);
insert into Question_comp (questionID, companyID) values (17, 15);
insert into Question_comp (questionID, companyID) values (31, 31);
insert into Question_comp (questionID, companyID) values (31, 11);
insert into Question_comp (questionID, companyID) values (8, 19);
insert into Question_comp (questionID, companyID) values (38, 39);
insert into Question_comp (questionID, companyID) values (26, 37);
insert into Question_comp (questionID, companyID) values (7, 14);
insert into Question_comp (questionID, companyID) values (36, 27);
insert into Question_comp (questionID, companyID) values (27, 18);
insert into Question_comp (questionID, companyID) values (35, 1);
insert into Question_comp (questionID, companyID) values (31, 13);
insert into Question_comp (questionID, companyID) values (39, 40);
insert into Question_comp (questionID, companyID) values (16, 12);
insert into Question_comp (questionID, companyID) values (29, 9);
insert into Question_comp (questionID, companyID) values (28, 16);
insert into Question_comp (questionID, companyID) values (40, 6);
insert into Question_comp (questionID, companyID) values (35, 23);
insert into Question_comp (questionID, companyID) values (24, 5);
insert into Question_comp (questionID, companyID) values (22, 34);
insert into Question_comp (questionID, companyID) values (23, 20);
insert into Question_comp (questionID, companyID) values (25, 32);
insert into Question_comp (questionID, companyID) values (25, 19);
insert into Question_comp (questionID, companyID) values (40, 12);
insert into Question_comp (questionID, companyID) values (34, 34);
insert into Question_comp (questionID, companyID) values (5, 20);
insert into Question_comp (questionID, companyID) values (22, 4);
insert into Question_comp (questionID, companyID) values (25, 8);
insert into Question_comp (questionID, companyID) values (1, 40);
insert into Question_comp (questionID, companyID) values (8, 26);
insert into Question_comp (questionID, companyID) values (15, 19);
insert into Question_comp (questionID, companyID) values (32, 27);
insert into Question_comp (questionID, companyID) values (35, 28);
insert into Question_comp (questionID, companyID) values (21, 10);
insert into Question_comp (questionID, companyID) values (15, 11);
insert into Question_comp (questionID, companyID) values (22, 29);
insert into Question_comp (questionID, companyID) values (24, 19);
insert into Question_comp (questionID, companyID) values (30, 26);
insert into Question_comp (questionID, companyID) values (22, 12);
insert into Question_comp (questionID, companyID) values (5, 26);
insert into Question_comp (questionID, companyID) values (12, 12);
insert into Question_comp (questionID, companyID) values (5, 14);
insert into Question_comp (questionID, companyID) values (12, 2);
insert into Question_comp (questionID, companyID) values (39, 23);
insert into Question_comp (questionID, companyID) values (14, 17);
insert into Question_comp (questionID, companyID) values (2, 35);
insert into Question_comp (questionID, companyID) values (40, 23);
insert into Question_comp (questionID, companyID) values (35, 38);
insert into Question_comp (questionID, companyID) values (20, 4);
insert into Question_comp (questionID, companyID) values (12, 39);
insert into Question_comp (questionID, companyID) values (5, 39);
insert into Question_comp (questionID, companyID) values (6, 17);
insert into Question_comp (questionID, companyID) values (26, 19);
insert into Question_comp (questionID, companyID) values (3, 37);
insert into Question_comp (questionID, companyID) values (8, 33);
insert into Question_comp (questionID, companyID) values (18, 14);
insert into Question_comp (questionID, companyID) values (24, 25);
insert into Question_comp (questionID, companyID) values (40, 34);
insert into Question_comp (questionID, companyID) values (27, 32);
insert into Question_comp (questionID, companyID) values (27, 35);
insert into Question_comp (questionID, companyID) values (15, 38);
insert into Question_comp (questionID, companyID) values (1, 2);
insert into Question_comp (questionID, companyID) values (2, 15);
insert into Question_comp (questionID, companyID) values (10, 11);
insert into Question_comp (questionID, companyID) values (40, 39);
insert into Question_comp (questionID, companyID) values (31, 3);
insert into Question_comp (questionID, companyID) values (13, 1);
-- Story_comp

insert into Story_comp (peerStoryID, companyID) values (17, 22);
insert into Story_comp (peerStoryID, companyID) values (9, 25);
insert into Story_comp (peerStoryID, companyID) values (8, 35);
insert into Story_comp (peerStoryID, companyID) values (5, 38);
insert into Story_comp (peerStoryID, companyID) values (2, 25);
insert into Story_comp (peerStoryID, companyID) values (33, 14);
insert into Story_comp (peerStoryID, companyID) values (37, 9);
insert into Story_comp (peerStoryID, companyID) values (35, 36);
insert into Story_comp (peerStoryID, companyID) values (7, 32);
insert into Story_comp (peerStoryID, companyID) values (25, 2);
insert into Story_comp (peerStoryID, companyID) values (29, 7);
insert into Story_comp (peerStoryID, companyID) values (9, 26);
insert into Story_comp (peerStoryID, companyID) values (12, 2);
insert into Story_comp (peerStoryID, companyID) values (20, 16);
insert into Story_comp (peerStoryID, companyID) values (12, 38);
insert into Story_comp (peerStoryID, companyID) values (9, 16);
insert into Story_comp (peerStoryID, companyID) values (24, 25);
insert into Story_comp (peerStoryID, companyID) values (36, 25);
insert into Story_comp (peerStoryID, companyID) values (14, 40);
insert into Story_comp (peerStoryID, companyID) values (9, 6);
insert into Story_comp (peerStoryID, companyID) values (34, 9);
insert into Story_comp (peerStoryID, companyID) values (32, 40);
insert into Story_comp (peerStoryID, companyID) values (5, 1);
insert into Story_comp (peerStoryID, companyID) values (31, 8);
insert into Story_comp (peerStoryID, companyID) values (33, 34);
insert into Story_comp (peerStoryID, companyID) values (15, 38);
insert into Story_comp (peerStoryID, companyID) values (6, 25);
insert into Story_comp (peerStoryID, companyID) values (27, 1);
insert into Story_comp (peerStoryID, companyID) values (31, 5);
insert into Story_comp (peerStoryID, companyID) values (28, 35);
insert into Story_comp (peerStoryID, companyID) values (6, 29);
insert into Story_comp (peerStoryID, companyID) values (34, 16);
insert into Story_comp (peerStoryID, companyID) values (39, 18);
insert into Story_comp (peerStoryID, companyID) values (11, 23);
insert into Story_comp (peerStoryID, companyID) values (22, 4);
insert into Story_comp (peerStoryID, companyID) values (35, 1);
insert into Story_comp (peerStoryID, companyID) values (18, 11);
insert into Story_comp (peerStoryID, companyID) values (35, 24);
insert into Story_comp (peerStoryID, companyID) values (5, 40);
insert into Story_comp (peerStoryID, companyID) values (21, 14);
insert into Story_comp (peerStoryID, companyID) values (40, 6);
insert into Story_comp (peerStoryID, companyID) values (32, 17);
insert into Story_comp (peerStoryID, companyID) values (19, 24);
insert into Story_comp (peerStoryID, companyID) values (27, 23);
insert into Story_comp (peerStoryID, companyID) values (15, 8);
insert into Story_comp (peerStoryID, companyID) values (4, 32);
insert into Story_comp (peerStoryID, companyID) values (12, 27);
insert into Story_comp (peerStoryID, companyID) values (13, 19);
insert into Story_comp (peerStoryID, companyID) values (14, 31);
insert into Story_comp (peerStoryID, companyID) values (22, 2);
insert into Story_comp (peerStoryID, companyID) values (18, 28);
insert into Story_comp (peerStoryID, companyID) values (34, 27);
insert into Story_comp (peerStoryID, companyID) values (8, 3);
insert into Story_comp (peerStoryID, companyID) values (30, 2);
insert into Story_comp (peerStoryID, companyID) values (39, 14);
insert into Story_comp (peerStoryID, companyID) values (1, 24);
insert into Story_comp (peerStoryID, companyID) values (28, 3);
insert into Story_comp (peerStoryID, companyID) values (39, 32);
insert into Story_comp (peerStoryID, companyID) values (7, 30);
insert into Story_comp (peerStoryID, companyID) values (12, 40);
insert into Story_comp (peerStoryID, companyID) values (27, 28);
insert into Story_comp (peerStoryID, companyID) values (25, 6);
insert into Story_comp (peerStoryID, companyID) values (1, 12);
insert into Story_comp (peerStoryID, companyID) values (7, 20);
insert into Story_comp (peerStoryID, companyID) values (18, 3);
insert into Story_comp (peerStoryID, companyID) values (26, 32);
insert into Story_comp (peerStoryID, companyID) values (8, 19);
insert into Story_comp (peerStoryID, companyID) values (5, 22);
insert into Story_comp (peerStoryID, companyID) values (10, 36);
insert into Story_comp (peerStoryID, companyID) values (7, 9);
insert into Story_comp (peerStoryID, companyID) values (23, 6);
insert into Story_comp (peerStoryID, companyID) values (9, 37);
insert into Story_comp (peerStoryID, companyID) values (6, 20);
insert into Story_comp (peerStoryID, companyID) values (30, 38);
insert into Story_comp (peerStoryID, companyID) values (3, 28);
insert into Story_comp (peerStoryID, companyID) values (38, 7);
insert into Story_comp (peerStoryID, companyID) values (14, 4);
insert into Story_comp (peerStoryID, companyID) values (32, 35);
insert into Story_comp (peerStoryID, companyID) values (11, 9);
insert into Story_comp (peerStoryID, companyID) values (39, 28);
insert into Story_comp (peerStoryID, companyID) values (19, 29);
insert into Story_comp (peerStoryID, companyID) values (5, 30);
insert into Story_comp (peerStoryID, companyID) values (16, 26);
insert into Story_comp (peerStoryID, companyID) values (6, 18);
insert into Story_comp (peerStoryID, companyID) values (34, 22);
insert into Story_comp (peerStoryID, companyID) values (8, 7);
insert into Story_comp (peerStoryID, companyID) values (37, 34);
insert into Story_comp (peerStoryID, companyID) values (39, 12);
insert into Story_comp (peerStoryID, companyID) values (10, 30);
insert into Story_comp (peerStoryID, companyID) values (6, 5);
insert into Story_comp (peerStoryID, companyID) values (20, 38);
insert into Story_comp (peerStoryID, companyID) values (15, 13);
insert into Story_comp (peerStoryID, companyID) values (30, 36);
insert into Story_comp (peerStoryID, companyID) values (20, 9);
insert into Story_comp (peerStoryID, companyID) values (16, 13);
insert into Story_comp (peerStoryID, companyID) values (20, 36);
insert into Story_comp (peerStoryID, companyID) values (36, 37);
insert into Story_comp (peerStoryID, companyID) values (40, 33);
insert into Story_comp (peerStoryID, companyID) values (11, 18);
insert into Story_comp (peerStoryID, companyID) values (31, 11);