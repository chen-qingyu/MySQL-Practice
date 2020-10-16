/*

ACID:数据库事务正确执行的四个基本要素的缩写

A:原子性（Atomicity）
原子性是指事务是一个不可分割的工作单位，事务中的操作要么都发生，要么都不发生。
C:一致性（Consistency）
事务前后数据的完整性必须保持一致。
I:隔离性（Isolation）
事务的隔离性是多个用户并发访问数据库时，数据库为每一个用户开启的事务，不能被其他事务的操作数据所干扰，多个并发事务之间要相互隔离。
D:持久性（Durability）
持久性是指一个事务一旦被提交，它对数据库中数据的改变就是永久性的，接下来即使数据库发生故障也不应该对其有任何影响


事务开启：
    a) set autocommit = 0;
    b) begin;
    c) start transaction;

事务提交：
    commit;

事务回滚：
    rollback;


事务隔离级别：
Read Uncommitted
读未提交：隔离级别最低的一种，会引发脏读、不可重复读和幻读。
Read Committed
读已提交：读到的都是别人提交后的值，会引发不可重复读和幻读，但避免了脏读。
Repeatable Read
可重复读：MySQL默认隔离级别，可能会引发幻读，但避免了脏读和不可重复读。
Serializable
串行化：最严格的隔离级别，所有事务按照次序依次执行，脏读、不可重复读、幻读都可以避免。

以上四种隔离级别，事务的隔离程度依次增加，性能依次降低。

*/


-- 1.查询自动提交状态（默认开启）
select @@autocommit;
-- +--------------+
-- | @@autocommit |
-- +--------------+
-- |            1 |
-- +--------------+


-- 2.测试回滚
-- 设置自动提交为关闭状态
set autocommit = 0;
select @@autocommit;
-- +--------------+
-- | @@autocommit |
-- +--------------+
-- |            0 |
-- +--------------+

-- 建表
create database bank;
use bank;

create table user (
    id varchar(20) primary key,
    name varchar(20) not null,
    balance decimal
);

desc user;
-- +---------+---------------+------+-----+---------+-------+
-- | Field   | Type          | Null | Key | Default | Extra |
-- +---------+---------------+------+-----+---------+-------+
-- | id      | varchar(20)   | NO   | PRI | NULL    |       |
-- | name    | varchar(20)   | NO   |     | NULL    |       |
-- | balance | decimal(10,0) | YES  |     | NULL    |       |
-- +---------+---------------+------+-----+---------+-------+

insert into user values('1', '张三', 1000);
insert into user values('2', '李四', 1000);

select * from user;
-- +----+--------+---------+
-- | id | name   | balance |
-- +----+--------+---------+
-- | 1  | 张三   |    1000 |
-- | 2  | 李四   |    1000 |
-- +----+--------+---------+

commit;

-- 转账之后没有commit
update user set balance = balance - 100 where id = '1';
update user set balance = balance + 100 where id = '2';

select * from user;
-- +----+--------+---------+
-- | id | name   | balance |
-- +----+--------+---------+
-- | 1  | 张三   |     900 |
-- | 2  | 李四   |    1100 |
-- +----+--------+---------+

rollback;

select * from user;
-- +----+--------+---------+
-- | id | name   | balance |
-- +----+--------+---------+
-- | 1  | 张三   |    1000 |
-- | 2  | 李四   |    1000 |
-- +----+--------+---------+

-- 转账之后commit
update user set balance = balance - 100 where id = '1';
update user set balance = balance + 100 where id = '2';

select * from user;
-- +----+--------+---------+
-- | id | name   | balance |
-- +----+--------+---------+
-- | 1  | 张三   |     900 |
-- | 2  | 李四   |    1100 |
-- +----+--------+---------+

commit;

rollback;

select * from user;
-- +----+--------+---------+
-- | id | name   | balance |
-- +----+--------+---------+
-- | 1  | 张三   |     900 |
-- | 2  | 李四   |    1100 |
-- +----+--------+---------+


-- 3.手动事务
-- 设置自动提交为开启状态
set autocommit = 1;
select @@autocommit;
-- +--------------+
-- | @@autocommit |
-- +--------------+
-- |            1 |
-- +--------------+

-- 初始化
update user set balance = 1000 where id = '1';
update user set balance = 1000 where id = '2';
select * from user;
-- +----+--------+---------+
-- | id | name   | balance |
-- +----+--------+---------+
-- | 1  | 张三   |    1000 |
-- | 2  | 李四   |    1000 |
-- +----+--------+---------+

-- 手动开启事务
begin; -- 或者start transaction;
update user set balance = balance - 100 where id = '1';
update user set balance = balance + 100 where id = '2';
rollback;
commit;
select * from user;
-- +----+--------+---------+
-- | id | name   | balance |
-- +----+--------+---------+
-- | 1  | 张三   |    1000 |
-- | 2  | 李四   |    1000 |
-- +----+--------+---------+


-- 4.查看隔离级别
-- MySQL 8.0

-- 系统级别
select @@global.transaction_isolation;
-- +--------------------------------+
-- | @@global.transaction_isolation |
-- +--------------------------------+
-- | REPEATABLE-READ                |
-- +--------------------------------+

-- 会话级别
select @@transaction_isolation;
-- +-------------------------+
-- | @@transaction_isolation |
-- +-------------------------+
-- | REPEATABLE-READ         |
-- +-------------------------+


-- 5.修改隔离级别

set global transaction isolation level read uncommitted;

select @@global.transaction_isolation;
-- +--------------------------------+
-- | @@global.transaction_isolation |
-- +--------------------------------+
-- | READ-UNCOMMITTED               |
-- +--------------------------------+


-- 6.脏读
insert into user values('3', '小明', 1000);
insert into user values('4', '淘宝店', 1000);
select * from user;
-- +----+-----------+---------+
-- | id | name      | balance |
-- +----+-----------+---------+
-- | 1  | 张三      |    1000 |
-- | 2  | 李四      |    1000 |
-- | 3  | 小明      |    1000 |
-- | 4  | 淘宝店    |    1000 |
-- +----+-----------+---------+

-- 转账
-- 小明在淘宝店买鞋子，800块钱。
-- 小明在成都，淘宝店在广州
begin;
update user set balance = balance - 800 where id = '3';
update user set balance = balance + 800 where id = '4';

-- 小明告诉淘宝店，钱到账了，淘宝店一查，发现确实到账了
select * from user;
-- +----+-----------+---------+
-- | id | name      | balance |
-- +----+-----------+---------+
-- | 1  | 张三      |    1000 |
-- | 2  | 李四      |    1000 |
-- | 3  | 小明      |     200 |
-- | 4  | 淘宝店    |    1800 |
-- +----+-----------+---------+

-- 发货
-- 晚上请女朋友吃好吃的
-- 消费1800

-- 小明在成都这边操作一下
rollback;

-- 淘宝店主结账的时候发现钱不够，哦豁
select * from user;
-- +----+-----------+---------+
-- | id | name      | balance |
-- +----+-----------+---------+
-- | 1  | 张三      |    1000 |
-- | 2  | 李四      |    1000 |
-- | 3  | 小明      |    1000 |
-- | 4  | 淘宝店    |    1000 |
-- +----+-----------+---------+


-- 7.不可重复读
set global transaction isolation level read committed;
select @@global.transaction_isolation;
-- +--------------------------------+
-- | @@global.transaction_isolation |
-- +--------------------------------+
-- | READ-COMMITTED                 |
-- +--------------------------------+

-- 小张：银行会计
-- 做报表，算平均值
begin;
select * from user;
-- +----+-----------+---------+
-- | id | name      | balance |
-- +----+-----------+---------+
-- | 1  | 张三      |    1000 |
-- | 2  | 李四      |    1000 |
-- | 3  | 小明      |    1000 |
-- | 4  | 淘宝店    |    1000 |
-- +----+-----------+---------+
-- 小张这时候出去上个厕所

-- 小王
-- 到银行新开一个账户
begin;
insert into user values('5', '小王', 100);
commit;
select * from user;
-- +----+-----------+---------+
-- | id | name      | balance |
-- +----+-----------+---------+
-- | 1  | 张三      |    1000 |
-- | 2  | 李四      |    1000 |
-- | 3  | 小明      |    1000 |
-- | 4  | 淘宝店    |    1000 |
-- | 5  | 小王      |     100 |
-- +----+-----------+---------+

-- 小张
-- 上完厕所回来，算平均值
select avg(balance) from user;
-- +--------------+
-- | avg(balance) |
-- +--------------+
-- |     820.0000 |
-- +--------------+
-- 平均值不是1000，变少了？


-- 8.幻读
set global transaction isolation level repeatable read;
select @@global.transaction_isolation;
-- +--------------------------------+
-- | @@global.transaction_isolation |
-- +--------------------------------+
-- | REPEATABLE-READ                |
-- +--------------------------------+

-- Alice 成都
begin;

-- Bob 北京
begin;

-- Alice 成都
insert into user values('6', 'saya', 10000);
select * from user;
-- +----+-----------+---------+
-- | id | name      | balance |
-- +----+-----------+---------+
-- | 1  | 张三      |    1000 |
-- | 2  | 李四      |    1000 |
-- | 3  | 小明      |    1000 |
-- | 4  | 淘宝店    |    1000 |
-- | 5  | 小王      |     100 |
-- | 6  | saya      |   10000 |
-- +----+-----------+---------+

-- Bob 北京
select * from user;
-- +----+-----------+---------+
-- | id | name      | balance |
-- +----+-----------+---------+
-- | 1  | 张三      |    1000 |
-- | 2  | 李四      |    1000 |
-- | 3  | 小明      |    1000 |
-- | 4  | 淘宝店    |    1000 |
-- | 5  | 小王      |     100 |
-- +----+-----------+---------+
insert into user values('6', 'saya', 10000);
ERROR 1062 (23000): Duplicate entry '6' for key 'user.PRIMARY'


-- 9.串行化
set global transaction isolation level serializable;
select @@global.transaction_isolation;
-- +--------------------------------+
-- | @@global.transaction_isolation |
-- +--------------------------------+
-- | SERIALIZABLE                   |
-- +--------------------------------+

-- 隔离级别最高，脏读、不可重复读、幻读都可以避免，但是性能最差。

