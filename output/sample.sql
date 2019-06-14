
SET NAMES utf8;
DROP DATABASE IF EXISTS `sample`;

-- create database
CREATE DATABASE IF NOT EXISTS sample
DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

-- use database
USE sample;

-- -------------------------------------------------------------------------

-- Sections Table

DROP TABLE IF EXISTS sample.Section;

CREATE TABLE sample.Sections
(
language TINYINT UNSIGNED NOT NULL DEFAULT 1,
section VARCHAR(25),
content TEXT,
starts_at TINYINT UNSIGNED NOT NULL DEFAULT 1,
PRIMARY KEY (language, section)
);
-- -------------------------------------------------------------------------
-- Questions-to-PageNumber (q2pn) Table
DROP TABLE IF EXISTS sample.q2pn;

CREATE TABLE sample.q2pn
(
page TINYINT UNSIGNED NOT NULL DEFAULT 1,
question VARCHAR(25),
PRIMARY KEY (page)
);
-- -------------------------------------------------------------------------
-- Questions Table
DROP TABLE IF EXISTS sample.Questions;

CREATE TABLE sample.Questions
(
language TINYINT UNSIGNED NOT NULL DEFAULT 1,
section VARCHAR(25),
page TINYINT UNSIGNED NOT NULL DEFAULT 1,
page_text VARCHAR(25),
instructions TEXT,
question TEXT,
responses TEXT,
PRIMARY KEY (language, page)
);
-- -------------------------------------------------------------------------
-- -------------------------------------------------------------------------
-- Sub Questions  Table
DROP TABLE IF EXISTS sample.SubQuestions;
CREATE TABLE sample.SubQuestions
(
language TINYINT UNSIGNED NOT NULL DEFAULT 1,
page TINYINT UNSIGNED NOT NULL DEFAULT 1,
part SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
part_text VARCHAR(10),
question TEXT,
function VARCHAR(33),
responses VARCHAR(24),
resp_table VARCHAR(50),
has_explain BOOLEAN NOT NULL DEFAULT FALSE,
has_other BOOLEAN NOT NULL DEFAULT FALSE, 
has_text_year BOOLEAN NOT NULL DEFAULT FALSE, 
response_date DATE DEFAULT 0,
PRIMARY KEY (part, language, page)
);
-- -------------------------------------------------------------------------
-- -------------------------------------------------------------------------
-- SingleQuestions Table
DROP TABLE IF EXISTS sample.SingleQuestions;
CREATE TABLE sample.SingleQuestions
(
language TINYINT UNSIGNED NOT NULL DEFAULT 1,
question VARCHAR(25) NOT NULL,
function TEXT,
response TEXT,
resp_table VARCHAR(255),
value SMALLINT NOT NULL DEFAULT 9999,
PRIMARY KEY (language, question, value)
);
-- -------------------------------------------------------------------------
-- -------------------------------------------------------------------------
-- Pipeline Table
DROP TABLE IF EXISTS sample.Pipeline;
CREATE TABLE sample.Pipeline
(
identifier VARCHAR(41),
question VARCHAR(25),
qsource VARCHAR(25),
text TEXT,
label TEXT,
value SMALLINT,
UNIQUE KEY id_value (identifier, question, value)
);
-- -------------------------------------------------------------------------
-- -------------------------------------------------------------------------
-- Stack Table
DROP TABLE IF EXISTS sample.Stack;
CREATE TABLE sample.Stack
(
identifier VARCHAR(41) NOT NULL,
position INT UNSIGNED AUTO_INCREMENT,
top TINYINT UNSIGNED NOT NULL,
PRIMARY KEY (position, identifier, top)
);
-- -------------------------------------------------------------------------
-- -------------------------------------------------------------------------

-- Access Table
DROP TABLE IF EXISTS sample.Access;
CREATE TABLE sample.Access
(
auto_id INT UNSIGNED AUTO_INCREMENT,
identifier VARCHAR(41),
pw_assigned TINYINT UNSIGNED NOT NULL DEFAULT '1',
answers_added TINYINT UNSIGNED NOT NULL DEFAULT '1',
saved TINYINT UNSIGNED NOT NULL DEFAULT '1',
language TINYINT UNSIGNED NOT NULL DEFAULT '1',
status ENUM('pending', 'pretest', 'verified', 'finished') NOT NULL DEFAULT 'pending',
initial_login TIMESTAMP DEFAULT 0,
last_update TIMESTAMP DEFAULT 0 ON UPDATE CURRENT_TIMESTAMP,
IP_address TEXT,
batch_number MEDIUMINT UNSIGNED NOT NULL DEFAULT '0',
PRIMARY KEY(auto_id),
INDEX (identifier)
);

-- -------------------------------------------------------------------------
-- -------------------------------------------------------------------------

INSERT INTO Access(identifier, status, pw_assigned) VALUES('default', 'finished', '1');

-- Insert New Section
INSERT INTO sample.Sections (section, content, starts_at, language)
VALUES ('I', 'Section Label', '1', '1');

INSERT INTO sample.q2pn (page, question)
VALUES ('1', 'SIQ1');

-- -- Insert New Question
INSERT INTO sample.Questions (page, section, page_text, question, responses, language)
VALUES ('1', 'I', 'SIQ1', 'Sample radio response question', '', '1');

-- -- -- Insert New Single Question
INSERT INTO sample.SingleQuestions (question, function, resp_table, language)
VALUES('SIQ1', 'DisplayRadioResponse', 'SIQ1_responses', '1');

-- -------------------------------------------------------------------------
-- Response Table SIQ1_responses
DROP TABLE IF EXISTS SIQ1_responses;
CREATE TABLE SIQ1_responses
(
sortindex SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
language TINYINT UNSIGNED NOT NULL DEFAULT 1,
text TEXT NOT NULL,
value SMALLINT NOT NULL DEFAULT 9999,
has_explain BOOLEAN NOT NULL DEFAULT FALSE,
has_other BOOLEAN NOT NULL DEFAULT FALSE,
has_text_year BOOLEAN NOT NULL DEFAULT FALSE, 
random BOOLEAN NOT NULL DEFAULT FALSE,
response_date DATE DEFAULT 0,
PRIMARY KEY (sortindex, language)
);
-- -------------------------------------------------------------------------
-- Response Table SIQ1_responses
INSERT INTO SIQ1_responses (text, value, has_other, has_explain, has_text_year, random, language)
VALUES ('Response option 1', '1', '0', '0', '0', '0', '1');

-- Response Table SIQ1_responses
INSERT INTO SIQ1_responses (text, value, has_other, has_explain, has_text_year, random, language)
VALUES ('Response option 2', '2', '0', '0', '0', '0', '1');

-- Response Table SIQ1_responses
INSERT INTO SIQ1_responses (text, value, has_other, has_explain, has_text_year, random, language)
VALUES ('Response option 3', '3', '0', '0', '0', '0', '1');

-- Response Table SIQ1_responses
INSERT INTO SIQ1_responses (text, value, has_other, has_explain, has_text_year, random, language)
VALUES ('Response option 4', '4', '0', '0', '0', '0', '1');

-- Response Table SIQ1_responses
INSERT INTO SIQ1_responses (text, value, has_other, has_explain, has_text_year, random, language)
VALUES ('Response option 5', '5', '0', '0', '0', '0', '1');

-- Response Table SIQ1_responses
INSERT INTO SIQ1_responses (text, value, has_other, has_explain, has_text_year, random, language)
VALUES ('Response option 6: Other; please explain:', '6', '1', '0', '0', '0', '1');

INSERT INTO sample.q2pn (page, question)
VALUES ('2', 'SIQ2');

-- -- Insert New Question
INSERT INTO sample.Questions (page, section, page_text, question, responses, language)
VALUES ('2', 'I', 'SIQ2', 'Sample checkbox question (select all that apply)', '', '1');

-- -- -- Insert New Single Question
INSERT INTO sample.SingleQuestions (question, function, resp_table, language)
VALUES('SIQ2', 'DisplayCheckboxResponse', 'SIQ2_responses', '1');

-- -------------------------------------------------------------------------
-- Response Table SIQ2_responses
DROP TABLE IF EXISTS SIQ2_responses;
CREATE TABLE SIQ2_responses
(
sortindex SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
language TINYINT UNSIGNED NOT NULL DEFAULT 1,
text TEXT NOT NULL,
value SMALLINT NOT NULL DEFAULT 9999,
has_explain BOOLEAN NOT NULL DEFAULT FALSE,
has_other BOOLEAN NOT NULL DEFAULT FALSE,
has_text_year BOOLEAN NOT NULL DEFAULT FALSE, 
random BOOLEAN NOT NULL DEFAULT FALSE,
response_date DATE DEFAULT 0,
PRIMARY KEY (sortindex, language)
);
-- -------------------------------------------------------------------------
-- Response Table SIQ2_responses
INSERT INTO SIQ2_responses (text, value, has_other, has_explain, has_text_year, random, language)
VALUES ('Checkbox 1', '1', '0', '0', '0', '0', '1');

-- Response Table SIQ2_responses
INSERT INTO SIQ2_responses (text, value, has_other, has_explain, has_text_year, random, language)
VALUES ('Checkbox 2', '2', '0', '0', '0', '0', '1');

-- Response Table SIQ2_responses
INSERT INTO SIQ2_responses (text, value, has_other, has_explain, has_text_year, random, language)
VALUES ('Checkbox 3', '3', '0', '0', '0', '0', '1');

-- Response Table SIQ2_responses
INSERT INTO SIQ2_responses (text, value, has_other, has_explain, has_text_year, random, language)
VALUES ('Checkbox 4', '4', '0', '0', '0', '0', '1');

-- Response Table SIQ2_responses
INSERT INTO SIQ2_responses (text, value, has_other, has_explain, has_text_year, random, language)
VALUES ('Checkbox 5', '5', '0', '0', '0', '0', '1');

-- Response Table SIQ2_responses
INSERT INTO SIQ2_responses (text, value, has_other, has_explain, has_text_year, random, language)
VALUES ('Checkbox 6', '6', '0', '0', '0', '0', '1');

-- Response Table SIQ2_responses
INSERT INTO SIQ2_responses (text, value, has_other, has_explain, has_text_year, random, language)
VALUES ('Checkbox 7', '7', '0', '0', '0', '0', '1');

INSERT INTO sample.q2pn (page, question)
VALUES ('3', 'SIQ3');

-- -- Insert New Question
INSERT INTO sample.Questions (page, section, page_text, question, responses, language)
VALUES ('3', 'I', 'SIQ3', 'Sample matrix response question', 'DisplayMatrixResponse', '1');

-- -- -- Insert New SubQuestion
INSERT INTO sample.SubQuestions (page, part_text, question, function, responses, resp_table, has_explain, has_other, has_text_year, language)
VALUES ('3', 'a', 'Matrix sub-question 1', 'DisplayMatrixResponse', '', 'NoYes', '0', '0', '0', '1');

-- -- -- Insert New SubQuestion
INSERT INTO sample.SubQuestions (page, part_text, question, function, responses, resp_table, has_explain, has_other, has_text_year, language)
VALUES ('3', 'b', 'Matrix sub-question 2', 'DisplayMatrixResponse', '', 'NoYes', '0', '0', '0', '1');

-- -- -- Insert New SubQuestion
INSERT INTO sample.SubQuestions (page, part_text, question, function, responses, resp_table, has_explain, has_other, has_text_year, language)
VALUES ('3', 'c', 'Matrix sub-question 3', 'DisplayMatrixResponse', '', 'NoYes', '0', '0', '0', '1');

-- -- -- Insert New SubQuestion
INSERT INTO sample.SubQuestions (page, part_text, question, function, responses, resp_table, has_explain, has_other, has_text_year, language)
VALUES ('3', 'd', 'Matrix sub-question 4', 'DisplayMatrixResponse', '', 'NoYes', '0', '0', '0', '1');

-- Insert New Section
INSERT INTO sample.Sections (section, content, starts_at, language)
VALUES ('II', 'Label For: Section 2', '4', '1');

INSERT INTO sample.q2pn (page, question)
VALUES ('4', 'SIIQ1');

-- -- Insert New Question
INSERT INTO sample.Questions (page, section, page_text, question, responses, language)
VALUES ('4', 'II', 'SIIQ1', 'Sample open-ended response question', '', '1');

-- -- -- Insert New Single Question
INSERT INTO sample.SingleQuestions (question, function, resp_table, language)
VALUES('SIIQ1', 'DisplayTextAreaResponse', '', '1');

INSERT INTO sample.q2pn (page, question)
VALUES ('5', 'SIIQ2');

-- -- Insert New Question
INSERT INTO sample.Questions (page, section, page_text, question, responses, language)
VALUES ('5', 'II', 'SIIQ2', 'Final Sample question', 'DisplayRadioResponse', '1');

-- -- -- Insert New SubQuestion
INSERT INTO sample.SubQuestions (page, part_text, question, function, responses, resp_table, has_explain, has_other, has_text_year, language)
VALUES ('5', 'a', 'Radio sub-question 1', 'DisplayRadioResponse', '', 'SIIQ2_a_responses', '0', '0', '0', '1');

-- -------------------------------------------------------------------------
-- Response Table SIIQ2_a_responses
DROP TABLE IF EXISTS SIIQ2_a_responses;
CREATE TABLE SIIQ2_a_responses
(
sortindex SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
language TINYINT UNSIGNED NOT NULL DEFAULT 1,
text TEXT NOT NULL,
value SMALLINT NOT NULL DEFAULT 9999,
has_explain BOOLEAN NOT NULL DEFAULT FALSE,
has_other BOOLEAN NOT NULL DEFAULT FALSE,
has_text_year BOOLEAN NOT NULL DEFAULT FALSE, 
random BOOLEAN NOT NULL DEFAULT FALSE,
response_date DATE DEFAULT 0,
PRIMARY KEY (sortindex, language)
);
-- -------------------------------------------------------------------------
-- Response Table SIIQ2_a_responses
INSERT INTO SIIQ2_a_responses (text, value, has_other, has_explain, has_text_year, random, language)
VALUES ('Response option 1', '1', '0', '0', '0', '0', '1');

-- -- -- Insert New SubQuestion
INSERT INTO sample.SubQuestions (page, part_text, question, function, responses, resp_table, has_explain, has_other, has_text_year, language)
VALUES ('5', 'b', 'Radio sub-question 2', 'DisplayRadioResponse', '', 'SIIQ2_b_responses', '0', '0', '0', '1');

-- -------------------------------------------------------------------------
-- Response Table SIIQ2_b_responses
DROP TABLE IF EXISTS SIIQ2_b_responses;
CREATE TABLE SIIQ2_b_responses
(
sortindex SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
language TINYINT UNSIGNED NOT NULL DEFAULT 1,
text TEXT NOT NULL,
value SMALLINT NOT NULL DEFAULT 9999,
has_explain BOOLEAN NOT NULL DEFAULT FALSE,
has_other BOOLEAN NOT NULL DEFAULT FALSE,
has_text_year BOOLEAN NOT NULL DEFAULT FALSE, 
random BOOLEAN NOT NULL DEFAULT FALSE,
response_date DATE DEFAULT 0,
PRIMARY KEY (sortindex, language)
);
-- -------------------------------------------------------------------------
-- Response Table SIIQ2_b_responses
INSERT INTO SIIQ2_b_responses (text, value, has_other, has_explain, has_text_year, random, language)
VALUES ('Response option 2', '2', '0', '0', '0', '0', '1');

-- -- -- Insert New SubQuestion
INSERT INTO sample.SubQuestions (page, part_text, question, function, responses, resp_table, has_explain, has_other, has_text_year, language)
VALUES ('5', 'c', 'Radio sub-question 3', 'DisplayRadioResponse', '', 'SIIQ2_c_responses', '0', '0', '0', '1');

-- -------------------------------------------------------------------------
-- Response Table SIIQ2_c_responses
DROP TABLE IF EXISTS SIIQ2_c_responses;
CREATE TABLE SIIQ2_c_responses
(
sortindex SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
language TINYINT UNSIGNED NOT NULL DEFAULT 1,
text TEXT NOT NULL,
value SMALLINT NOT NULL DEFAULT 9999,
has_explain BOOLEAN NOT NULL DEFAULT FALSE,
has_other BOOLEAN NOT NULL DEFAULT FALSE,
has_text_year BOOLEAN NOT NULL DEFAULT FALSE, 
random BOOLEAN NOT NULL DEFAULT FALSE,
response_date DATE DEFAULT 0,
PRIMARY KEY (sortindex, language)
);
-- -------------------------------------------------------------------------
-- Response Table SIIQ2_c_responses
INSERT INTO SIIQ2_c_responses (text, value, has_other, has_explain, has_text_year, random, language)
VALUES ('Response option 3', '3', '0', '0', '0', '0', '1');

-- -- -- Insert New SubQuestion
INSERT INTO sample.SubQuestions (page, part_text, question, function, responses, resp_table, has_explain, has_other, has_text_year, language)
VALUES ('5', 'd', 'Radio sub-question 4', 'DisplayRadioResponse', '', 'SIIQ2_d_responses', '0', '0', '0', '1');

-- -------------------------------------------------------------------------
-- Response Table SIIQ2_d_responses
DROP TABLE IF EXISTS SIIQ2_d_responses;
CREATE TABLE SIIQ2_d_responses
(
sortindex SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
language TINYINT UNSIGNED NOT NULL DEFAULT 1,
text TEXT NOT NULL,
value SMALLINT NOT NULL DEFAULT 9999,
has_explain BOOLEAN NOT NULL DEFAULT FALSE,
has_other BOOLEAN NOT NULL DEFAULT FALSE,
has_text_year BOOLEAN NOT NULL DEFAULT FALSE, 
random BOOLEAN NOT NULL DEFAULT FALSE,
response_date DATE DEFAULT 0,
PRIMARY KEY (sortindex, language)
);
-- -------------------------------------------------------------------------
-- Response Table SIIQ2_d_responses
INSERT INTO SIIQ2_d_responses (text, value, has_other, has_explain, has_text_year, random, language)
VALUES ('Response option 4', '4', '0', '0', '0', '0', '1');

-- Answers Table
DROP TABLE IF EXISTS sample.Answers;
CREATE TABLE sample.Answers
(
auto_id INT UNSIGNED AUTO_INCREMENT,
identifier VARCHAR(41) NOT NULL DEFAULT 'no-passcode',
batch_number MEDIUMINT UNSIGNED NOT NULL DEFAULT 0,
last_update TIMESTAMP DEFAULT 0 ON UPDATE CURRENT_TIMESTAMP,
L TINYINT UNSIGNED NOT NULL DEFAULT 1,
SIQ1 SMALLINT NOT NULL DEFAULT 9999,
SIQ1_6_other TEXT,
SIQ2_cb_1 SMALLINT NOT NULL DEFAULT 9999,
SIQ2_cb_2 SMALLINT NOT NULL DEFAULT 9999,
SIQ2_cb_3 SMALLINT NOT NULL DEFAULT 9999,
SIQ2_cb_4 SMALLINT NOT NULL DEFAULT 9999,
SIQ2_cb_5 SMALLINT NOT NULL DEFAULT 9999,
SIQ2_cb_6 SMALLINT NOT NULL DEFAULT 9999,
SIQ2_cb_7 SMALLINT NOT NULL DEFAULT 9999,
SIQ3_a SMALLINT NOT NULL DEFAULT 9999,
SIQ3_b SMALLINT NOT NULL DEFAULT 9999,
SIQ3_c SMALLINT NOT NULL DEFAULT 9999,
SIQ3_d SMALLINT NOT NULL DEFAULT 9999,
SIIQ1 TEXT,
SIIQ2_a SMALLINT NOT NULL DEFAULT 9999,
SIIQ2_b SMALLINT NOT NULL DEFAULT 9999,
SIIQ2_c SMALLINT NOT NULL DEFAULT 9999,
SIIQ2_d SMALLINT NOT NULL DEFAULT 9999,
PRIMARY KEY (auto_id),
INDEX(identifier)
);

-- Populate Answers table for default user -------------------------------

INSERT INTO sample.Answers (identifier) VALUES ('default');
-- -------------------------------------------------------------------------

-- Mandatory Answers Table
DROP TABLE IF EXISTS sample.MandatoryAnswers;
CREATE TABLE sample.MandatoryAnswers
(
auto_id SMALLINT NOT NULL AUTO_INCREMENT,
page_number SMALLINT,
answer VARCHAR(25) NOT NULL,
PRIMARY KEY(auto_id)
);
-- -------------------------------------------------------------------------

SET NAMES utf8;

-- use database
USE sample;
DROP TABLE IF EXISTS Skips;

CREATE TABLE Skips
(
skip_from SMALLINT UNSIGNED NOT NULL,
because_of TEXT,
forward_to SMALLINT UNSIGNED NOT NULL,
reason TEXT,
PRIMARY KEY(skip_from, forward_to)
);

INSERT INTO Skips VALUES
(
'5',
'4=SIQ4',
'7',
'(SIQ4 != 5)'
);

INSERT INTO Skips VALUES
(
'8',
'7=SIQ7',
'9',
'(SIQ7 == 3)'
);

INSERT INTO Skips VALUES
(
'11',
'10=SIQ10_a',
'16',
'(((SIQ10_a == 0) CompareAND (SIQ10_b == 0)) CompareAND ((SIQ10_c == 0) CompareAND (SIQ10_d == 0)))'
);

INSERT INTO Skips VALUES
(
'16',
'10=SIQ10_a',
'18',
'(((SIQ10_a ==1) CompareOR (SIQ10_b == 1)) CompareOR ((SIQ10_c == 1) CompareOR (SIQ10_d == 1)))'
);

INSERT INTO Skips VALUES
(
'23',
'22=SIQ22',
'24',
'(SIQ22 == 0)'
);

INSERT INTO Skips VALUES
(
'28',
'27=SIIQ26_cb_254',
'33',
'(SIIQ26_cb_254 == 254)'
);

INSERT INTO Skips VALUES
(
'34',
'33=SIIIQ30',
'45',
'((SIIIQ30 == 4) CompareOR (SIIIQ30 == 5))'
);

INSERT INTO Skips VALUES
(
'36',
'35=SIVQ32_cb_254',
'40',
'(SIVQ32_cb_254 == 254)'
);

INSERT INTO Skips VALUES
(
'41',
'40=SVQ35_a_pcb_254',
'45',
'(SVQ35_a_pcb_254 == 254)'
);

SET NAMES utf8;

-- create database
CREATE DATABASE IF NOT EXISTS GeneralContent
DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

-- use database
USE GeneralContent;
DROP TABLE IF EXISTS sample;

CREATE TABLE IF NOT EXISTS sample
(
survey_title VARCHAR(255) NOT NULL, -- survey id
survey_email VARCHAR(255) NOT NULL,
language TINYINT UNSIGNED NOT NULL DEFAULT 0,
start VARCHAR(20) NOT NULL,
login VARCHAR(40) NOT NULL,
previous VARCHAR(20) NOT NULL,
save VARCHAR(30) NOT NULL,
disposition VARCHAR(30) NOT NULL,
next VARCHAR(20) NOT NULL,
kontinue VARCHAR(20) NOT NULL,
finish VARCHAR(20) NOT NULL, 
survey_logout_text VARCHAR(210) NOT NULL,
intro TEXT,
intropost TEXT,
interviewer TEXT, 
login_text TEXT,
login_error TEXT,
survey_complete TEXT, 
partial_logout TEXT,
full_logout TEXT, 
interviewer_logout TEXT,
confidentiality TEXT, 
instructions TEXT, 
abbr_guide VARCHAR(40) NOT NULL, 
page VARCHAR(40) NOT NULL, 
of VARCHAR(10) NOT NULL, 
need_answer TEXT,
age TEXT,
years TEXT,
months TEXT,
introduction_link TEXT,
privacy_link TEXT,
instructions_link TEXT,
PRIMARY KEY(language)
);

INSERT INTO sample VALUES
(
'Sample Survey',
'sample@sample.com',
'1',
'Start Survey',
'Login',
'Previous',
'Save and Exit',
'Disposition',
'Next',
'Continue',
'Finish',
'Click <a class="resource_button" href="[SURVEY_ROOT_PATH]/index.php">Next</a> for the next case or <a class="resource_button" href="[SURVEY_ROOT_PATH]/logout.php?interviewer_logout">Logout</a> to logout.',
'
<div class="welcome">
<h1>
Welcome to the <br />[SURVEY_TITLE]
</h1>
</div>
<div class="intro2">
<p>
Introductory text coming soon!
</p>
</div>
<br />
<br />
',
'
<div class="welcome">
Welcome to the <br />[SURVEY_TITLE]
</div>
<br />
<br />
<p>
</p>
',
'
<div class="welcome">
Welcome to the <br />[SURVEY_TITLE]
</div>
<br />
<br />
Interviewers please enter your <b>Interviewer ID</b> and <b>Passcode</b> below to access the SRG WebCATI system.
<br />
<br />
ID: <input name="interviewer" type="text" maxlength="20" class="prominent" alt="Enter Interviewer ID">
Passcode: <input name="passcode" type="password" maxlength="20" class="prominent" alt="Enter password">
<br />
<br />
',
'
<div class="welcome">
Welcome to the <br />[SURVEY_TITLE]
</div>
<br />
<br />
<br />
<br />
Please enter your passcode:
<br />
<br />
<input name="pword" type="text" maxlength="20" class="prominent" alt="enter Respondent Patient ID">
<br />
<br />
',
'
<div class="warning">Login failed. Please try again.</div>
<br />
<br />
For help with your passcode or difficulties viewing the survey, please call Strategic Research Group at 1-800-341-3660 or email marinersurvey@websrg.com.
<br />
<br />
If you think you may have entered your passcode incorrectly, please try again:
<br />
<input name="pword" type="text" maxlength="20" class="prominent" alt="enter Respondent Patient ID">
<br />
<br />
',
'
<h2 class="warning">Passcode expired</h2>
<p>
Our records indicate that this passcode has already been used. This message appears if you have already completed the survey. If you think this is an error, please call Strategic Research Group at 1-800-341-3660 or email marinersurvey@websrg.com.
</p>
<p>
If you think you may have entered your passcode incorrectly, please click
<a class="resource_button" href="[SURVEY_ROOT_PATH]/index.php">Try Again</a> to attempt to login again.
</p>
',
'
<br />
<br />
<br />
<br />
<div class="thankyou">
Thank you for your time.  Please do not forget to return to complete the survey.
<br />
<br />
To continue the survey now, click [RETURN_TO_SURVEY].
</div>
<br />
<br />
<br />
<br />
<div class="warning">
[SURVEY_LOGOUT_TEXT]
</div>
',
'
<div class="thankyou">
<p>
Thank you for completing the [SURVEY_TITLE].
</p>
<p>
If you have questions about this survey, please call 1-800-341-3660 or e-mail [SURVEY_EMAIL].
</p>
</div>
<br />
<br />
<br />
<br />
<div class="warning">
[SURVEY_LOGOUT_TEXT]
</div>
',
'
<div class="thankyou">
<p>
Thank you for using the SRG WebCATI System!
</p>
</div>
<br />
<br />
<br />
<br />

<div class="warning">
Please close your browser window or click <a class="resource_button" href="[SURVEY_ROOT_PATH]/">Interviewer Login</a> for the login screen.
</div>
',
'
<div id="intro">
<p><b> Paperwork Reduction Act Information </b></p>
<p>
A federal agency may not conduct or sponsor, and a person is not required to respond to, nor shall a person be subject to a penalty for failure to comply with a collection of information subject to the requirements of the Paperwork Reduction Act unless that collection of information displays a current valid OMB Control Number. The OMB Control Number for this information collection is <mark>2133-NEW</mark>. Public reporting for this collection of information is estimated to be approximately <mark>30 minutes</mark> per response, including the time for reviewing instructions, completing and reviewing the collection of information. All responses to this collection of information are voluntary. Send comments regarding this burden estimate or any other aspect of this collection of information, including suggestions for reducing this burden to: Information Collection Clearance Officer, Maritime Administration, MAR-390, W26-494, 1200 New Jersey Avenue, SE, Washington, DC 20590.
</p>
<p>
OMB No. <mark>2133-NEW</mark>. Approval Expires <mark>MM-DD-YYYY</mark>
</p>
</div>
<p></p>
',
'
<div id="intro">
 <p>  <b> Survey instructions: </b>  </p> 
<p>
Note: 
</p>
<ul>
<li>  For each question, please select the one answer that best applies to your situation, unless you are asked to "check all that apply". 
</li>
<li>  If you would like to change your response, simply click the button or box next to your new response.   
</li>
<li> When you have made your answer selections, please click the "Finish" button to submit your responses to our server.  
</li>
<li> At the bottom of each page are 3 options:     
<ul>       
<li>  "<b>Next</b>" saves your answers and takes you to the next page.       
</li>
<li>  "<b>Previous</b>" takes you back to the previous page.       
</li>
<li>  "<b>Save and Exit</b>" enables you to exit the survey and finish at a later time. When you return to the survey, simply enter your passcode again on the main page and you will be taken to the last question that you answered.        
</li>
</ul>
</li>
<li> Several questions include the term "National Need." This refers to war, armed conflict, national emergency, or maritime mobilization need.
</li>
<li> There are several questions that ask for a specific year. For these, please answer as accurately as possible, but provide your best guess when you are unsure about the exact year.
</li>
</ul>
<p style="font-weight: bold">
If you have any questions about the survey, please call Strategic Research Group at 1-800-341-3660 Monday-Thursday between 9:00am-9:30pm Eastern Standard Time (EST), Friday between 9:00am-5:00pm EST or email us at [SURVEY_EMAIL].   <br /> <br />
</p>
</div>
',
'See abbreviation guide',
'You are on page',
'of',
'Please provide an answer to this question.',
'Age',
'Years',
'Months',
'Introduction',
'Privacy',
'Instructions'
);
-- Matrix Tables ----------------------------------------------------------
SET NAMES utf8;

-- create database 
CREATE DATABASE IF NOT EXISTS MatrixResponses
DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

USE MatrixResponses;

DROP TABLE IF EXISTS NoYes;
CREATE TABLE NoYes
(
sortindex TINYINT(3) UNSIGNED NOT NULL AUTO_INCREMENT,
language TINYINT(3) UNSIGNED NOT NULL DEFAULT '1',
label VARCHAR(63) NOT NULL,
text VARCHAR(42) NOT NULL,
value TINYINT(3) UNSIGNED NOT NULL DEFAULT '99',
PRIMARY KEY (sortindex, language, text)
);
INSERT INTO MatrixResponses.NoYes (label, text, value) VALUES ('No', 'No', '0');
INSERT INTO MatrixResponses.NoYes (label, text, value) VALUES ('Yes', 'Yes', '1');

-- -------------------------------------------------------------------------
-- Granting the survey proper rights

GRANT SELECT ON sample.*
TO 'sample_work'@'localhost' IDENTIFIED BY 'm@st3r_0f_fubar';

GRANT SELECT ON sample.Access
TO 'SRGdata'@'%';

GRANT UPDATE (identifier, saved, status) on sample.Access
TO 'SRGdata'@'%';

GRANT SELECT ON sample.Answers
TO 'SRGdata'@'%';

GRANT SELECT, UPDATE ON sample.Access
TO 'athena'@'localhost';

GRANT SELECT, UPDATE ON sample.Answers
TO 'athena'@'localhost';

GRANT SELECT, UPDATE ON sample.Access
TO 'heimdal'@'localhost';

GRANT SELECT, UPDATE ON sample.Answers
TO 'heimdal'@'localhost';

GRANT SELECT, UPDATE ON GeneralContent.sample
TO 'athena'@'localhost';

GRANT SELECT, UPDATE ON GeneralContent.sample
TO 'heimdal'@'localhost';

GRANT UPDATE ON sample.Answers
TO 'sample_work'@'localhost' IDENTIFIED BY 'm@st3r_0f_fubar';

GRANT UPDATE (pw_assigned, saved, status) ON sample.Access
TO 'sample_work'@'localhost' IDENTIFIED BY 'm@st3r_0f_fubar';

GRANT INSERT, DELETE ON sample.Stack
TO 'sample_work'@'localhost' IDENTIFIED BY 'm@st3r_0f_fubar';

GRANT INSERT, UPDATE ON sample.Pipeline
TO 'sample_work'@'localhost' IDENTIFIED BY 'm@st3r_0f_fubar';

GRANT SELECT ON MatrixResponses.*
TO 'sample_work'@'localhost' IDENTIFIED BY 'm@st3r_0f_fubar';

GRANT SELECT ON GeneralContent.sample
TO 'sample_work'@'localhost' IDENTIFIED BY 'm@st3r_0f_fubar';

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test001', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test001', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test002', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test002', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test003', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test003', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test004', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test004', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test005', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test005', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test006', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test006', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test007', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test007', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test008', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test008', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test009', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test009', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test010', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test010', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test011', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test011', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test012', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test012', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test013', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test013', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test014', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test014', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test015', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test015', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test016', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test016', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test017', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test017', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test018', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test018', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test019', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test019', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test020', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test020', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test021', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test021', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test022', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test022', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test023', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test023', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test024', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test024', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test025', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test025', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test026', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test026', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test027', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test027', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test028', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test028', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test029', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test029', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test030', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test030', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test031', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test031', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test032', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test032', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test033', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test033', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test034', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test034', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test035', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test035', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test036', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test036', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test037', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test037', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test038', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test038', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test039', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test039', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test040', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test040', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test041', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test041', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test042', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test042', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test043', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test043', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test044', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test044', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test045', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test045', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test046', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test046', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test047', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test047', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test048', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test048', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test049', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test049', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test050', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test050', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test051', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test051', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test052', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test052', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test053', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test053', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test054', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test054', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test055', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test055', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test056', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test056', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test057', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test057', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test058', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test058', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test059', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test059', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test060', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test060', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test061', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test061', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test062', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test062', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test063', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test063', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test064', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test064', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test065', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test065', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test066', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test066', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test067', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test067', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test068', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test068', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test069', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test069', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test070', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test070', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test071', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test071', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test072', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test072', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test073', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test073', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test074', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test074', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test075', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test075', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test076', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test076', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test077', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test077', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test078', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test078', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test079', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test079', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test080', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test080', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test081', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test081', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test082', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test082', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test083', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test083', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test084', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test084', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test085', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test085', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test086', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test086', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test087', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test087', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test088', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test088', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test089', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test089', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test090', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test090', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test091', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test091', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test092', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test092', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test093', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test093', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test094', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test094', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test095', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test095', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test096', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test096', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test097', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test097', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test098', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test098', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test099', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test099', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test100', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test100', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test101', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test101', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test102', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test102', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test103', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test103', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test104', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test104', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test105', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test105', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test106', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test106', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test107', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test107', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test108', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test108', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test109', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test109', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test110', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test110', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test111', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test111', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test112', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test112', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test113', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test113', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test114', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test114', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test115', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test115', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test116', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test116', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test117', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test117', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test118', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test118', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test119', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test119', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test120', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test120', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test121', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test121', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test122', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test122', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test123', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test123', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test124', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test124', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test125', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test125', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test126', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test126', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test127', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test127', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test128', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test128', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test129', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test129', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test130', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test130', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test131', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test131', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test132', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test132', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test133', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test133', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test134', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test134', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test135', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test135', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test136', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test136', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test137', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test137', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test138', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test138', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test139', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test139', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test140', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test140', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test141', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test141', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test142', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test142', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test143', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test143', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test144', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test144', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test145', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test145', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test146', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test146', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test147', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test147', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test148', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test148', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test149', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test149', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test150', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test150', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test151', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test151', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test152', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test152', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test153', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test153', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test154', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test154', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test155', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test155', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test156', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test156', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test157', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test157', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test158', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test158', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test159', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test159', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test160', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test160', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test161', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test161', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test162', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test162', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test163', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test163', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test164', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test164', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test165', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test165', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test166', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test166', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test167', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test167', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test168', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test168', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test169', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test169', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test170', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test170', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test171', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test171', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test172', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test172', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test173', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test173', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test174', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test174', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test175', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test175', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test176', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test176', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test177', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test177', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test178', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test178', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test179', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test179', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test180', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test180', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test181', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test181', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test182', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test182', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test183', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test183', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test184', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test184', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test185', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test185', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test186', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test186', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test187', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test187', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test188', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test188', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test189', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test189', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test190', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test190', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test191', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test191', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test192', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test192', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test193', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test193', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test194', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test194', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test195', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test195', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test196', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test196', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test197', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test197', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test198', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test198', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test199', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test199', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test200', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test200', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test201', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test201', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test202', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test202', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test203', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test203', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test204', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test204', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test205', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test205', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test206', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test206', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test207', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test207', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test208', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test208', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test209', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test209', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test210', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test210', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test211', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test211', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test212', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test212', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test213', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test213', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test214', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test214', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test215', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test215', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test216', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test216', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test217', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test217', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test218', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test218', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test219', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test219', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test220', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test220', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test221', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test221', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test222', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test222', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test223', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test223', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test224', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test224', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test225', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test225', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test226', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test226', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test227', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test227', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test228', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test228', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test229', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test229', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test230', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test230', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test231', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test231', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test232', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test232', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test233', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test233', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test234', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test234', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test235', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test235', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test236', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test236', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test237', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test237', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test238', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test238', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test239', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test239', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test240', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test240', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test241', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test241', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test242', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test242', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test243', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test243', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test244', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test244', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test245', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test245', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test246', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test246', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test247', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test247', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test248', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test248', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test249', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test249', '190614');

INSERT INTO sample.Access (identifier, batch_number)
VALUES ('test250', '190614');
INSERT INTO sample.Answers (identifier, batch_number)
VALUES ('test250', '190614');

