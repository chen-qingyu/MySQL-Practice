-- 0.如何以管理员身份登录数据库服务器？（终端操作）
mysql -u root -p

-- 1.如何查看有哪些数据库？
show databases;

-- 2.如何在数据库服务器中创建自己的数据库？(以下操作皆假定数据库名是test)
create database test;

-- 3.如何选择数据库？
use test;

-- 4.如何查看该数据库中有哪些表？
show tables;

-- 5.如何创建一个数据表？(以下操作皆假定表名是student)
create table student(
    s_no varchar(20),
    s_name varchar(20),
    s_sex varchar(1),
    s_birthday date,
    s_class varchar(20)
);

-- 6.如何查看数据表的结构？
desc student;
/* describe student; */

-- 7.如何插入数据？
insert into student values('101', '张三', '男', '1990-09-01', '一班');

-- 8.如何查询表中的所有数据？
select * from student;

-- 9.如何修改数据？
update student set s_class='二班' where s_no='101';

-- 10.如何删除数据？
delete from student where s_no='101';

-- 11.如何建表之后增加主键约束？（其他约束同理）
alter table student add primary key(s_no);

-- 12.如何建表之后修改非空约束？（其他约束同理）
alter table student modify s_name varchar(20) not null;

-- 13.如何建表之后删除主键约束？（其他约束同理）
alter table student drop primary key;

-- 14.如何删除数据表？
drop table student;

-- 15.如何删除数据库？
drop database test;

-- 16.如何退出数据库服务器？
exit;


/*

约束总结


1.主键约束
它能够唯一确定一张表中的一条记录,增加主键约束之后,就可以使得字段不重复而且不为空


2.复合主键
说明了复合主键只要所有的字段都不是相同的情况下可以允许其中的字段重复
示例:表中有班级号以及学生座位号,我们可以用班级号+学生的座位号可以准确的定位一个学生,如:(1班5号可以准确的确定一个学生)


3.自增约束
配合主键约束使用，没有自定义id值也可以自动生成id


4.非空约束
字段不能为NULL


5.唯一约束
主键约束(primary key)中包含了唯一约束
示例：设计一张用户注册表,包括id,name,phone_number三个字段。
用户必须用手机号来注册,而且三个字段都不能为空。

mysql> create table user (
    ->     id int primary key auto_increment,
    ->     name varchar(20) not null,
    ->     phone_number varchar(20) unique not null
    -> );
Query OK, 0 rows affected (0.07 sec)

mysql> desc user;
+--------------+-------------+------+-----+---------+----------------+
| Field        | Type        | Null | Key | Default | Extra          |
+--------------+-------------+------+-----+---------+----------------+
| id           | int         | NO   | PRI | NULL    | auto_increment |
| name         | varchar(20) | NO   |     | NULL    |                |
| phone_number | varchar(20) | NO   | UNI | NULL    |                |
+--------------+-------------+------+-----+---------+----------------+
3 rows in set (0.01 sec)

这样的话就达到了用户名可以重复，但每个手机号只能被注册一次，也就是说手机号不能重复，符合正常的逻辑需求。


6.默认约束
不设置带有默认约束字段的值，就会给我们创建默认值


7.外键约束
  1.主表中没有的数据,在附表中是不可以使用的
  2.主表中记录的数据如果被附表所引用,那么主表中正在被引用的数据不可以被删除
  3.若要想删除,先将附表中的数据删除再删除主表数据
  4.可以用“省市”来进行联想：
    市必须依赖于省,只要省还有一个市在引用,那么就不可以删除省,要不然市就没有省了。
    那么我们如果想删除省,必须要将该省下所有的市全部删除之后,才可以删除这个省。

*/
