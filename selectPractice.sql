-- 建表

create table student(
    s_no varchar(20) primary key,
    s_name varchar(20) not null,
    s_sex varchar(1) not null,
    s_birthday date,
    s_class varchar(20)
);

create table teacher(
    t_no varchar(20) primary key,
    t_name varchar(20) not null,
    t_sex varchar(1) not null,
    t_birthday date,
    t_prof varchar(20) not null,
    t_depart varchar(20) not null
);

create table course(
    c_no varchar(20) primary key,
    c_name varchar(20) not null,
    t_no varchar(20) not null,
    foreign key(t_no) references teacher(t_no)
);

create table score (
    s_no varchar(20) not null,
    c_no varchar(20)  not null,
    sc_degree decimal,
    foreign key(s_no) references student(s_no),
    foreign key(c_no) references course(c_no),
    primary key(s_no, c_no)
);


-- 插入数据

insert into student values('101', '曾华', '男', '1977-09-01', '95033');
insert into student values('102', '匡明', '男', '1975-10-02', '95031');
insert into student values('103', '王丽', '女', '1976-01-23', '95033');
insert into student values('104', '李军', '男', '1976-02-20', '95033');
insert into student values('105', '王芳', '女', '1975-02-10', '95031');
insert into student values('106', '陆军', '男', '1974-06-03', '95031');
insert into student values('107', '王尼玛', '男', '1976-02-20', '95033');
insert into student values('108', '张全蛋', '男', '1975-02-10', '95031');
insert into student values('109', '赵铁柱', '男', '1974-06-03', '95031');

insert into teacher values('804', '李诚', '男', '1958-12-02', '副教授', '计算机系');
insert into teacher values('856', '张旭', '男', '1969-03-12', '讲师', '电子工程系');
insert into teacher values('825', '王萍', '女', '1972-05-05', '助教', '计算机系');
insert into teacher values('831', '刘冰', '女', '1977-08-14', '助教', '电子工程系');

insert into course values('3-105', '计算机导论', '825');
insert into course values('3-245', '操作系统', '804');
insert into course values('6-166', '数字电路', '856');
insert into course values('9-888', '高等数学', '831');

insert into score values('103', '3-245', 86);
insert into score values('105', '3-245', 75);
insert into score values('109', '3-245', 68);
insert into score values('103', '3-105', 92);
insert into score values('105', '3-105', 88);
insert into score values('109', '3-105', 76);
insert into score values('103', '6-166', 85);
insert into score values('105', '6-166', 79);
insert into score values('109', '6-166', 81);


-- 查询练习

-- 1.查询student表中所有的记录
select * from student;

-- 2.查询student表中所有记录的 s_no, s_name 和 s_class 列
select s_no, s_name, s_class from student;

-- 3.查询所有的教师单位即不重复的 t_depart 列
select distinct t_depart from teacher;

-- 4.查询score表中成绩在60-80之间所有的记录（注意 BETWEEN... AND... 是包含边界的）
select * from score where sc_degree between 60 and 80;

-- 5.查询score表中成绩为85, 86, 或者88的记录
select * from score where sc_degree in (85, 86, 88);

-- 6.查询student表中'95031'班或者性别为'女'的同学记录
select * from student where s_class='95031' or s_sex='女';

-- 7.以 s_no 降序查询 student 表中所有的记录
select * from student order by s_no desc;

-- 8.以c_no升序，sc_degree降序查询score表中所有的记录
select * from score order by c_no asc, sc_degree desc;

-- 9.查询'95031'班的学生人数
select count(*) from student where s_class = '95031';

-- 10.查询score表中的最高分数的学生号和课程号（最高分有多个的情况下用order by再limit可能会有问题）
select s_no, c_no from score where sc_degree = (select max(sc_degree) from score);

-- 11.查询每门课的平均成绩
select c_no, avg(sc_degree) from score group by c_no;

-- 12.查询score表中至少有2名学生选修的,并且以3开头的课程的平均分
select c_no, avg(sc_degree), count(*) from score group by c_no having count(c_no) >= 2 and c_no like '3%';

-- 13.查询分数大于70但是小于90的s_no列
select s_no, sc_degree from score where sc_degree > 70 and sc_degree < 90;

-- 14.查询所有的学生 s_name , c_no, sc_degree 列
select s_name, c_no, sc_degree from student, score where student.s_no = score.s_no;

-- 15.查询所有学生的 s_no, c_name, sc_degree 列
select s_no, c_name, sc_degree from course, score where course.c_no = score.c_no;

-- 16.查询所有的学生 s_name , c_name, sc_degree 列
select s_name, c_name, sc_degree from student, course, score where student.s_no = score.s_no and course.c_no = score.c_no;

-- 17.查询班级是'95031'班学生每门课的平均分
select c_no, avg(sc_degree) from score where s_no in (select s_no from student where s_class = '95031') group by c_no;

