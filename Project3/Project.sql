create database project;
use project;

create table dept(
	depno int not null primary key default 0,
    dname varchar(14),
    loc varchar(13) 
);

insert into dept values
	(10,"Accounting","New Work"),
    (20,"research","Dallas"),
    (30,"sales","Chicago"),
    (40,"operations","Boston");
    
select * from dept;


create table student(
	rno int not null primary key default 0,
    sname varchar(14),
    city varchar(20),
    state varchar(20)
);

create table emp_log(
	emp_id int not null primary key,
    log_date date,
    new_salary int,
    action varchar(20)
); 

create table emp(
	empno int not null primary key default 0,
    ename varchar(10),
    job varchar(9),
    mgr int,
    hiredate date,
    sal decimal(7,2),
    comm decimal(7,2),
    deptno int,
    foreign key (deptno) references dept (depno)
);

INSERT INTO emp VALUES 
(7369, 'SMITH', 'CLERK', 7902, '1980-12-17', 800.00, NULL, 20),
(7499, 'ALLEN', 'SALESMAN', 7698, '1981-02-20', 1600.00, 300.00, 30),
(7521, 'WARD', 'SALESMAN', 7698, '1981-02-22', 1250.00, 500.00, 30),
(7566, 'JONES', 'MANAGER', 7839, '1981-04-02', 2975.00, NULL, 20),
(7654, 'MARTIN', 'SALESMAN', 7698, '1981-09-28', 1250.00, 1400.00, 30),
(7698, 'BLAKE', 'MANAGER', 7839, '1981-05-01', 2850.00, NULL, 30),
(7782, 'CLARK', 'MANAGER', 7839, '1981-06-09', 2450.00, NULL, 10),
(7788, 'SCOTT', 'ANALYST', 7566, '1987-06-11', 3000.00, NULL, 20),
(7839, 'KING', 'PRESIDENT', NULL, '1981-11-17', 5000.00, NULL, 10),
(7844, 'TURNER', 'SALESMAN', 7698, '1981-08-09', 1500.00, 0.00, 30),
(7876, 'ADAMS', 'CLERK', 7788, '1987-07-13', 1100.00, NULL, 20),
(7900, 'JAMES', 'CLERK', 7698, '1981-03-12', 950.00, NULL, 30),
(7902, 'FORD', 'ANALYST', 7566, '1981-03-12', 3000.00, NULL, 20),
(7934, 'MILLER', 'CLERK', 7782, '1982-01-23', 1300.00, NULL, 10);

select * from emp;

#1
select job 
from emp
group by
	job;
    
#2
select * from emp
ORDER BY 
	deptno, 
	job desc;
    
#3
select distinct job from emp
order by 
	job desc;

#4
select * from emp
where hiredate < '1981-01-01';

#5
select empno, ename, sal, sal/30 as daily_sal
from emp
order by 
	(sal*12);

#6
select empno, ename, sal, year(CURDATE()) - year(hiredate) as exp
from emp
where empno = 7369;

#7
SELECT * FROM emp
WHERE comm > sal;

#8
select * from emp
where job in ('CLERK', 'ANALYST')
order by 
	job desc;

#9
select * from emp
where (sal*12) between 22000 and 45000;

#10
select ename from emp
where ename like 'S____';

#11
SELECT * FROM emp
WHERE empno NOT LIKE '78%';

#12
select * from emp
where job = 'CLERK' and deptno = 20;

#13
select e.*
from emp e
join emp m 
on e.mgr = m.empno
where e.hiredate < m.hiredate;

#14
select * from emp
where deptno = 20 and job in (select distinct job from emp where deptno = 10);

#15
select * from emp
where sal in (select sal from emp where ename in ('FORD', 'SMITH'))
order by 
	sal desc;

#16
select * from emp
where job in (select job from emp where ename in ('SMITH', 'ALLEN'));

#17
select distinct job
from emp
where deptno = 10
and job not in (select distinct job from emp where deptno = 20);

#18
select MAX(sal) as highest_sal from emp;

#19
select * from emp
where sal = (select MAX(sal) from emp);

#20
select SUM(sal) as total_mgr_sal from emp
where job = 'MANAGER';

#21
select * from emp
where ename like '%A%';

#22
select * from emp e
where sal = (select MIN(sal) from emp where job = e.job)
order by 
	job;

#23
select * from emp
where sal > (select sal from emp where ename = 'BLAKE');

#24
CREATE VIEW v1 AS
SELECT emp.ename, emp.job, dept.dname, dept.loc
FROM emp
JOIN dept 
ON emp.deptno = dept.depno;

select * from v1;

#25
DELIMITER $$
CREATE PROCEDURE get_emp_dept(IN dno INT)
BEGIN
    SELECT emp.ename, dept.dname
    FROM emp
    JOIN dept ON emp.deptno = dept.depno
    WHERE emp.deptno = dno;
END $$
DELIMITER ;

call get_emp_dept(20);

#26
alter table student add pin bigint;

#27
alter table student modify sname varchar(40);

DELIMITER $$
create trigger trg_salary_update
after update on emp
for each row
begin
    if new.sal <> old.sal then
        insert into emp_log(emp_id, log_date, new_salary, action)
        values(new.empno, CURDATE(), new.sal, 'New Salary');
    end if;
end $$
DELIMITER ;

update emp 
set sal = 900 
where ename = 'SMITH';

select * from emp_log;