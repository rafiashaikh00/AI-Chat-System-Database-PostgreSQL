-----Table 1--------
create table users(

user_id serial primary key,
user_name varchar(50) not null unique,
email varchar(100) unique not null,
password text not null,
account_time timestamp default current_timestamp,
active_status boolean default True
);
------Table 2 ------
create table conversation(
-- es table ki apni id
unique_id serial  primary key,
-- can give column ame any then data type then references is f.K then table name then column name
user_id int REFERENCES  users(user_id),
-- timestamp gives datye and time 
conversation_start  timestamp default current_timestamp,
conversation_tittle varchar(100)

);
----table3---
create table ai_models(
unique_id serial primary key,
model_name varchar(50) unique not null,
model_company varchar(50) not null,
model_version text not null,
model_release_date date not null
);
----table 4---
create table messages(
unique_id serial primary key,
conversation_id int references conversation(unique_id),
model_id int references ai_models(unique_id),
-- sender ka type dekhan hn in keliye , aata hn
sender_type varchar(100) check (sender_type in ('user' ,'ai')),
message_text text not null,
sent_at timestamp default current_timestamp

);
----table 5-----
create table feedback(
unique_id serial primary key,
message_id int references messages(unique_id) ,
rating int check (rating between 1 and 5),
feedback_comment text ,
feedback_time timestamp default current_timestamp
);

INSERT INTO users (user_name, email, password)
VALUES
('Rafia', 'rafia@gmail.com', 'rafia123'),
('Ali', 'ali@gmail.com', 'ali123'),
('Sara', 'sara@gmail.com', 'sara123'),
('Ahmed', 'ahmed@gmail.com', 'ahmed123'),
('Ayesha', 'ayesha@gmail.com', 'ayesha123');


INSERT INTO ai_models
(model_name, model_company, model_version, model_release_date)
VALUES
('GPT', 'OpenAI', 'GPT-4.1', '2025-04-14'),
('Claude', 'Anthropic', 'Claude 4', '2025-05-22'),
('Gemini', 'Google', 'Gemini 2.5 Pro', '2025-03-25');


INSERT INTO conversation
(user_id, conversation_tittle)
VALUES
(1,'Learning PostgreSQL'),
(1,'Python Backend'),
(2,'Machine Learning'),
(3,'AI Chatbot'),
(5,'FastAPI Project');
INSERT INTO messages
(conversation_id, model_id, sender_type, message_text)
VALUES

(1, 2, 'user', 'What is PostgreSQL?'),
(1, 2, 'ai', 'PostgreSQL is an open-source relational database.'),

(2, 1, 'user', 'Explain FastAPI.'),
(2, 1, 'ai', 'FastAPI is a modern Python framework for building APIs.'),

(3, 3, 'user', 'What is Machine Learning?'),
(3, 3, 'ai', 'Machine Learning enables computers to learn from data.'),

(4, 2, 'user', 'What is an AI chatbot?'),
(4, 2, 'ai', 'An AI chatbot communicates with users using natural language.'),

(5, 1, 'user', 'How do I connect Python with PostgreSQL?'),
(5, 1, 'ai', 'You can connect using psycopg2 or SQLAlchemy.');
select unique_id from messages;
INSERT INTO feedback
(message_id, rating, feedback_comment)
VALUES
-- 2 ,4,6,8,10 cause these reposnse gen by ai 
(2, 5, 'Excellent explanation of PostgreSQL.'),
(4, 5, 'FastAPI explanation was very clear.'),
(6, 4, 'Good introduction to Machine Learning.'),
(8, 5, 'Chatbot explanation was easy to understand.'),
(10, 5, 'Python and PostgreSQL connection was very helpful.');
select unique_id from messages;
INSERT INTO feedback
(message_id, rating)
VALUES(2,2);
-- delete the conetent of table
TRUNCATE TABLE
feedback,
messages

RESTART IDENTITY CASCADE;
----SELECT_____
-- * mean all column
select * from users;
select user_id,password from users;
select * from messages;
select message_id from feedback;
--distinct duplicate ko hta deta hn (select distinct column name from table name)
select  distinct sender_type from  messages;
select distinct conversation_id from messages;
--alias measn as
select distinct user_id as new_user_id from conversation;
select user_name as name,email  as new_email from users;
---where is for condition syntax select column name from tablename where condition
select user_name from users where user_id=1;
select user_id from conversation where conversation_tittle ='Python Backend';
select *  from users where user_name='Rafia';
select  sender_type as sender ,
message_text as Ai_response 
from messages where sender_type='ai';
select * from feedback where rating !=5;

select model_release_date from ai_models where model_release_date >='2025-04-15';
select model_name ,model_company  from ai_models where model_name !='Gpt';
select * from feedback where rating!=5;
select * from ai_models where not model_release_date ='2025-04-14';
select model_name ,model_company  from ai_models where model_name='GPT' and model_company='OpenAI';
select * from users where user_name ='Rafia' or user_name='ALi'
--start A
select user_name from users  where user_name  Like 'A%';
--mid e
SELECT user_name
FROM users
WHERE user_name LIKE '%e%';

select conversation_tittle from conversation where conversation_tittle like'Python%';
select user_name from users order by  user_name DESC;
-- count rows
select count(*) from messages;
select sum(rating) from feedback;
select count(user_name) from users;
-- other func max min
select max(rating) from feedback;
select upper(user_name) from users;
select message_text,length(message_text) from messages;
--select user_name,email,length(user_name,email) from  users;
--phly concate huga then us ki andr lnegth
select length(concat(user_name,'-',email)) from users;
--select concat(user_name,'-',email) as new_details, length(new_detals) from users;
--this is wrong alias cant be resuse length func cant take 2 values
select substring(message_text,1,10) as short_messages from messages; -- only take 1 se 10 letter tak
select replace(message_text,'PostgreSQL', 'Postgres') as updated_text from messages;
-- current date and time
select now();
--age basically waqt bate ga us feed back ko ktn time huwa hn
select feedback_time, age(now() ,feedback_time) as time_since_feedback from feedback;
--select feedback_time,extract(month from age(now(),feedback_time)) as days from feedback;
SELECT feedback_time, (CURRENT_DATE - feedback_time::date) AS total_days FROM feedback;
SELECT feedback_time, 
       EXTRACT(YEAR FROM  feedback_time) AS year,
       EXTRACT(MONTH FROM feedback_time) AS month,
       EXTRACT(DAY FROM feedback_time) AS day
FROM feedback;
select sender_type,
case
      when sender_type='user' then 'human'
       when sender_type='ai '  then 'robot'
       else 'unknown'
end as sender_label
from messages;
--ye wlaa null ki jagh 0 dekhae ga
SELECT message_text, model_id, COALESCE(model_id, 0) AS model_id_fixed FROM messages;
select feedback_comment,coalesce(feedback_comment,'till now nothing present') as new_feedback from feedback;
select count(*) as total_conversation from conversation group by user_id;
-- sender type ke sath hum batae gein ke kis k kitni conversation hugei
select count(*) as sender_conversation from messages group by sender_type having count(*) >3;
SELECT *
FROM users
LIMIT 5
OFFSET 1; --offset skip the first 1 roiws retirn next 5 riows
-- where filter indivial rows but group by create group separete then count  group by me esoecfuiacl 
-- having me wia func dete
select length(user_name) from users group by user_id having length(user_name)>4;
update users set email='user@gmail.com' where user_name='Ali';
update users set active_status='False' where user_id=1;
select user_id,active_status from users;
delete from users where user_name='Ali';
delete from users; -- sari table dleet
delete from users where active_status=False;
alter table users add column phone_number varchar(50);
alter table users drop column phone_number;
alter table users rename column user_name to user_fullname;
alter table users alter column active_status type varchar(20);
select u.user_fullname,u.email,c.conversation_tittle from  users as u
inner join conversation as  c 
on c.user_id =u.user_id;
SELECT
c.conversation_tittle,
m.sender_type,
m.message_text
FROM conversation c
INNER JOIN messages m
ON c.unique_id = m.conversation_id;
SELECT
m.message_text,
f.rating,
f.feedback_comment
FROM messages m
INNER JOIN feedback f
ON m.unique_id = f.message_id;
select u.user_fullname,c.conversation_tittle,m.message_text from users as u
inner join conversation as c
on u.user_id=c.user_id
inner join messages as m
on c.unique_id=m.conversation_id;
---
SELECT
u.user_fullname,
c.conversation_tittle,
m.message_text,
a.model_name
FROM users u
INNER JOIN conversation c
ON u.user_id = c.user_id
INNER JOIN messages m
ON c.unique_id = m.conversation_id
INNER JOIN ai_models a
ON m.model_id = a.unique_id;

--left join shows match of both tables and unmatc
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    age INT CHECK(age >= 18),
 department VARCHAR(50),
    salary NUMERIC(10,2)
);
	
	
   
INSERT INTO employees(name, age, department, salary)
VALUES ('Rafia', 21, 'IT', 50000);
select * from employees;