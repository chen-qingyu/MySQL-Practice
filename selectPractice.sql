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

-- 10.查询分数大于70但是小于90的s_no列
select s_no, sc_degree from score where sc_degree > 70 and sc_degree < 90;

-- 11.查询每门课的平均成绩
select c_no, avg(sc_degree) from score group by c_no;

-- 12.查询score表中的最高分数的学生号和课程号（最高分有多个的情况下用order by再limit可能会有问题）
select s_no, c_no from score where sc_degree = (select max(sc_degree) from score);

-- 13.查询所有的学生 s_name , c_no, sc_degree 列
select s_name, c_no, sc_degree from student, score where student.s_no = score.s_no;

-- 14.查询所有学生的 s_no, c_name, sc_degree 列
select s_no, c_name, sc_degree from course, score where course.c_no = score.c_no;

-- 15.查询所有的学生 s_name , c_name, sc_degree 列
select s_name, c_name, sc_degree from student, course, score where student.s_no = score.s_no and course.c_no = score.c_no;
