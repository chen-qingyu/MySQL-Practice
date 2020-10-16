-- 建表

create table card (
    id varchar(20),
    name varchar(20)
);

create table person (
    id varchar(20),
    name varchar(20),
    card_id varchar(20)
);


-- 插入数据

insert into card values(1, '饭卡');
insert into card values(2, '建行卡');
insert into card values(3, '农行卡');
insert into card values(4, '工商卡');
insert into card values(5, '邮政卡');

insert into person values(1, '张三', 1);
insert into person values(2, '李四', 3);
insert into person values(3, '王五', 6);


-- 连接练习

-- 1.内连接

select * from person inner join card on person.card_id = card.id;
select * from person join card on person.card_id = card.id;

-- +------+--------+---------+------+-----------+
-- | id   | name   | card_id | id   | name      |
-- +------+--------+---------+------+-----------+
-- | 1    | 张三   | 1       | 1    | 饭卡      |
-- | 2    | 李四   | 3       | 3    | 农行卡    |
-- +------+--------+---------+------+-----------+


-- 2.左外连接

select * from person left outer join card on person.card_id = card.id;
select * from person left join card on person.card_id = card.id;

-- +------+--------+---------+------+-----------+
-- | id   | name   | card_id | id   | name      |
-- +------+--------+---------+------+-----------+
-- | 1    | 张三   | 1       | 1    | 饭卡      |
-- | 2    | 李四   | 3       | 3    | 农行卡    |
-- | 3    | 王五   | 6       | NULL | NULL      |
-- +------+--------+---------+------+-----------+


-- 3.右外连接

select * from person right outer join card on person.card_id = card.id;
select * from person right join card on person.card_id = card.id;

-- +------+--------+---------+------+-----------+
-- | id   | name   | card_id | id   | name      |
-- +------+--------+---------+------+-----------+
-- | 1    | 张三   | 1       | 1    | 饭卡      |
-- | NULL | NULL   | NULL    | 2    | 建行卡    |
-- | 2    | 李四   | 3       | 3    | 农行卡    |
-- | NULL | NULL   | NULL    | 4    | 工商卡    |
-- | NULL | NULL   | NULL    | 5    | 邮政卡    |
-- +------+--------+---------+------+-----------+


-- 4.全外连接

select * from person left join card on person.card_id = card.id
union
select * from person right join card on person.card_id = card.id;

-- +------+--------+---------+------+-----------+
-- | id   | name   | card_id | id   | name      |
-- +------+--------+---------+------+-----------+
-- | 1    | 张三   | 1       | 1    | 饭卡      |
-- | 2    | 李四   | 3       | 3    | 农行卡    |
-- | 3    | 王五   | 6       | NULL | NULL      |
-- | NULL | NULL   | NULL    | 2    | 建行卡    |
-- | NULL | NULL   | NULL    | 4    | 工商卡    |
-- | NULL | NULL   | NULL    | 5    | 邮政卡    |
-- +------+--------+---------+------+-----------+

