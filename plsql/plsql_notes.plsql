
Two blocks in PLSQL
	
	1. Anomymous block
	2. Named Block		-- Stored as object in DB
		
		PROCEDURE
		FUNCTION
		TRIGGER
		PACKAGE

1. 	Anomymous block	
==============================================================================

declare
	-- variable declaration 				-- optional
BEGIN
	
	-- Executable statements				-- mandatory
	
	EXCEPTION
	-- exception handling code 				-- optional
end;
/

==============================================================================

:= assignment OPERATOR

-- Anomymous block - very basic block
BEGIN
dbms_output.put_line('Welcome to Orable PLSQL');
end;

==============================================================================

declare
number1 constant number(10,2):=0;
number2 number(10,2) not null:=0;
result number(10,2);
BEGIN
-- number1:=20;
number2:=null;
result := (number1+number2);
dbms_output.put_line('The addition of '||number1||' and '||number2||' are: '||result);
end;

==============================================================================

-- how to get user input in anomymous block

declare
number1 number(10,2):=&number1;
number2 number(10,2):=&number2;
result number(10,2);
BEGIN
result := (number1+number2);
dbms_output.put_line('The addition of '||number1||' and '||number2||' are: '||result);
end;

==============================================================================

-- select operation in PLSQL

declare
v_ph_no varchar2(100);
v_job_id varchar2(100);
BEGIN
select phone_number, job_id INTO v_ph_no, v_job_id FROM employee WHERE employee_id = 102;
dbms_output.put_line('The phone number of the employee is '||v_ph_no|| ' and the job id is '||v_job_id);
end;

==============================================================================
-- DML statments in PLSQL block


BEGIN
INSERT INTO customer (cust_id, cust_name, mobile_no, age, city_id)
VALUES (100, 'NIC IT Academy', 9090909090, 32, 20);
COMMIT;
end;

==============================================================================

BEGIN
INSERT INTO customer
SELECT cust_id, cust_name, mobile_no, age, city_id FROM customer1 WHERE cust_id NOT IN (100);
COMMIT;
end;

==============================================================================

BEGIN
UPDATE customer
SET cust_name = 'Welcome'
WHERE cust_id = 100003;
end;

==============================================================================

CREATE TABLE customer
(
cust_id number(8),
cust_name VARCHAR2(40),
dob DATE,
mobile_no NUMBER(10),
city VARCHAR2(40)
);

INSERT INTO customer VALUES(1000, 'Arun', TO_DATE('12/09/1985', 'mm/dd/yyyy'), 9090909090, 'Chennai');
INSERT INTO customer VALUES(1001, 'John', TO_DATE('01/27/1982', 'mm/dd/yyyy'), 9090909093, 'Pune');
INSERT INTO customer VALUES(1002, 'Babu', TO_DATE('06/23/1995', 'mm/dd/yyyy'), 9090909089, 'Hyd');

COMMIT;

SELECT * FROM customer;

==============================================================================

DECLARE
v_mobile_no number(10);
BEGIN
SELECT mobile_no INTO v_mobile_no
FROM customer 
WHERE cust_id = 1002;
dbms_output.put_line('The mobile number is '||v_mobile_no);
end;

==============================================================================

ALTER TABLE customer MODIFY mobile_no VARCHAR2(40);  -- but table need to be empty

RENAME customer TO customer_bkp;

CREATE TABLE customer
(
cust_id number(8),
cust_name VARCHAR2(40),
dob DATE,
mobile_no VARCHAR2(10),
city VARCHAR2(40)
);

INSERT INTO customer
(
SELECT cust_id, cust_name, dob, '+91-'||mobile_no, city
FROM customer_bkp
);

COMMIT;

TRUNCATE TABLE customer;
SELECT * FROM customer;

==============================================================================

-- type and rowtype in PLSQL

DECLARE
v_mobile_no hr.customer.mobile_no%TYPE;
BEGIN
SELECT mobile_no INTO v_mobile_no
FROM customer 
WHERE cust_id = 1002;
dbms_output.put_line('The mobile number is '||v_mobile_no);
end;

DECLARE
v_customer hr.customer%ROWTYPE;
BEGIN
SELECT * INTO v_customer
FROM customer
WHERE cust_id = 1002;
dbms_output.put_line('The customer name is '||v_customer.cust_name);
dbms_output.put_line('The customer dob is '||v_customer.dob);
end;

==============================================================================

-- control statement
1. IF statement

	if condition
		then statement;
	elsif condition
		then statement;
	else
		statement;
	end if; 

2. CASE statement
	CASE
		WHEN condition THEN statement;
		WHEN condition THEN statement;
	ELSE statement;

==============================================================================

DECLARE
a number:=10;
b number:=20;
BEGIN
	if a > b then 
		dbms_output.put_line(a ||' is greater than ' || b);
	ELSE
		dbms_output.put_line(b ||' is greater than ' || a);
	end if;
END;

==============================================================================

DECLARE
	vsalary number(10);
	vlocal number(10):=&vemp_id;
BEGIN
	SELECT salary INTO vsalary FROM employees where employee_id=vlocal;
	CASE
		WHEN vsalary > 15000 THEN dbms_output.put_line('Fair salary');
		WHEN vsalary > 10000 and vsalary < 15000 THEN dbms_output.put_line('Avg salary');
	ELSE
		dbms_output.put_line(vsalary || ' Low Salary');
	end case;
end;

==============================================================================
-- looping statements in PLSQL

-- 1. Simple loop
LOOP ... end loop;

-- 2. While loop
while (condition) loop ... end loop;

-- 3. For loop
For ... loop ... end loop;

==============================================================================

DECLARE
	c number:=1;
BEGIN
	loop
		dbms_output.put_line('Welcome to PLSQL ' || c);
		c := c + 1;
		exit when c > 5;
	end loop;
end;

==============================================================================

DECLARE
c number:=0;
BEGIN
	while (c <= 5)
	loop
		dbms_output.put_line('Hello');
		c := c + 1;
	end loop;
END;

==============================================================================

DECLARE
c1 number;
BEGIN 
	for c1 in 1..5
	loop
		dbms_output.put_line('Hello');
	end loop;
END;

==============================================================================

set SERVEROUTPUT ON
DECLARE
	v_salary employees.salary%type;		-- scalar variable
BEGIN
	select salary into v_salary
	from employees 
	where employee_id = 100;
	dbms_output.put_line('The salary of the employee: ' || v_salary);
END;


------------------------------------------------------------------------------
instead of using scalar variable,
to get all values from base table we can go for 2 methods:

	1. composite variable
	2. cursor

-- 1. composite variable
=========================

set SERVEROUTPUT ON
DECLARE
	TYPE nt_salary_type is table of number(10);
	nt_salary nt_salary_type := nt_salary_type();
BEGIN
	select salary bulk collect into nt_salary from employees;

	for i in nt_salary.first..nt_salary.last
	loop
		dbms_output.put_line(nt_salary(i));
	end loop;
END;

-- 2. cursor - two types of cursor
===================================

Implicit cursor
Explicit cursor


Implicit cursor
===============
Implicit curosr is a session managed cursor. Oracle opens a cursor everytime you run a DML or select statement.

As a user we do not have control on implicit cursor but we can get information from its attributes.

Cursor attributes:
==================
cursor_name%isopen
cursor_name%found
cursor_name%notfound
cursor_name%rowcount

==============================================================================

BEGIN
	UPDATE customer set mobile_no='+91-'||mobile_no where cust_id=&cust_id;
	if sql%notfound then
		dbms_output.put_line('No rows are updated');
	else
		dbms_output.put_line(sql%rowcount||'- rows updated');
	end if;
END;

==============================================================================

Explicit cursor
===============
Explicit cursor is a user-defined cursor.
	1. Define the cursor
	2. Open the cursor
	3. Fetch the cursor
	4. Close the cursor

How to declare a cursor:
=========================
cursor C1							-- C1 is the cursor variable
is 
	select emp_name from employees; 

-------------------------------------------------------------------------------

DECLARE
	vemp_salary employees.salary%type;
	cursor c1 is select salary from employees;					-- cursor declaration
BEGIN
	open c1;
	loop
		fetch c1 into vemp_salary;
		exit when c1%notfound;
		dbms_output.put_line(vemp_salary);
	end loop;
	dbms_output.put_line('Total fetched records from base table-'||c1%rowcount);
	close c1;
end;

==============================================================================

-- Cursor for loop
===================

DECLARE
	cursor c1(no number) 
		is 
		select * from employees where department_id = no;
	tmp employees%rowtype;
BEGIN
	for tmp in c1(30) loop
		dbms_output.put_line('Emp_No:		'||tmp.employee_id);
		dbms_output.put_line('Emp_Name:		'||tmp.first_name);
		dbms_output.put_line('Emp_Dept:		'||tmp.department);
		dbms_output.put_line('Emp_Salary:	'||tmp.salary);
	end loop;
end;

==============================================================================

-- without parameter for cursor

DECLARE
	vemp_name employees.first_name%type;
	vemp_salary employees.salary%type;
	cursor c_dept30 is select first_name, salary from employees where dept_id = 30;
	cursor c_dept60 is select first_name, salary from employees where dept_id = 60;
BEGIN
	open c_dept30;
	loop
		fetch c_dept30 into vemp_name, vemp_salary;
		exit when c_dept30%notfound;
		dbms_output.put_line(vemp_line||vemp_salary);
	end loop;
	close c_dept30;

	open c_dept60;
	loop
		fetch c_dept60 into vemp_name, vemp_salary;
		exit when c_dept60%notfound;
		dbms_output.put_line(vemp_line||vemp_salary);
	end loop;
	close c_dept60;
end;

==============================================================================

-- parameterized cursor

DECLARE
	cursor c1(prm_dept_no number) is select salary from employees where dept_id = &prm_dept_no;
	vsalary number(10);
BEGIN
	open c1(30);
	loop
		fetch c1 into v_salary;
		exit when c1%notfound;
		dbms_output.put_line(vsalary);
	end loop;
	close c1(30);

	open c1(60);
	loop
		fetch c1 into v_salary;
		exit when c1%notfound;
		dbms_output.put_line(vsalary);
	end loop;
	close c1(60);
end;

==============================================================================

-- if we do not have ref cursor

DECLARE
	cursor c1_emp is select salary from employees;
	cursor c2_dept is select dept_name from departments;
	v_salary number(10);
	v_dept_name varchar2(100);
BEGIN
	open c1_emp;
	loop
		fetch c1_emp into v_salary;
		exit when c1_emp%notfound;
		dbms_output.put_line(v_salary);
	end loop;
	close c1_emp;

	open c2_dept;
	loop
		fetch c2_dept into v_dept_name;
		exit when c2_dept%notfound;
		dbms_output.put_line(v_dept_name);
	end loop;
	close c2_dept;
END;

------------------------------------------------------------------------------

DECLARE
	type ref_cursor is ref cursor;
	rc_employees_list ref_cursor;
	v_first_name varchar2(100);
	v_dept_name varchar2(100);
BEGIN
	dbms_output.put_line('--This is Employees details--');
	open rc_employees_list for select first_name from employees;
	loop
		fetch rc_employees_list into v_first_name;
		exit when rc_employees_list%notfound;
		dbms_output.put_line(v_first_name);
	end loop;
	close rc_employees_list;

	dbms_output.put_line('--This is Department details--');
	open rc_employees_list for select dept_name from departments;
	loop
		fetch rc_employees_list into v_dept_name;
		exit when rc_employees_list%notfound;
		dbms_output.put_line(v_dept_name);
	end loop;
	close rc_employees_list;
end;

==============================================================================

-- strong typed REF cursor

type ref_cursor is ref cursor return employees%rowtype;
rc_employees_list ref_cursor;
v_emp_row employees%rowtype;
BEGIN
	open rc_employees_list for select * from employees;
	loop
		fetch rc_employees_list into v_emp_row;
		exit when rc_employees_list%notfound;
		dbms_output.put_line('The employee name - '||v_emp_row.first_name);
		dbms_output.put_line('The employee salary - '||v_emp_row.salary);
	end loop;
	close rc_employees_list;
end;

==============================================================================

Stored Procedure:
=================

CREATE or REPLACE PROCEDURE greetings AS
BEGIN
	dbms_output.put_line('Welcome to PLSQL Session!');
end;

how to execute procedure:
-------------------------

exec greetings;
execute greetings;

BEGIN
	greetings;
end;

------------------------------------------------------------------------------
drop procedure greetings;
------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE greetings(p_name IN varchar2) AS
BEGIN
	dbms_output.put_line('Hello ', ||p_name);
end;

exec greetings('NIC IT Academy');

------------------------------------------------------------------------------

CREATE OR REPLCE PROCEDURE total1(N1 IN number, N2 IN number, total OUT number) AS
BEGIN
	total := n1 + n2;
END;

DECLARE
	x number;
BEGIN
	total1(123, 456, x);
	dbms_output.put_line('Total is '|| x);
END;

------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE total1(N1 IN number, N2 IN number) AS
addition number;
BEGIN
	addition := N1 + N2;
	dbms_output.put_line('Total is '|| addition);
end;

------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE inout_multiplication(x IN OUT number) AS
BEGIN
	x:= x * 5;
end;

DECLARE
	x number;
BEGIN
	x:=6;
	inout_multiplication(x);
	dbms_output.put_line('Multiplication: '||x);
END;

------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE total_salary(in_emp_id IN number) AS
v_salary number(10);
BEGIN
	select salary + salary * (nvl(commission_pct, 0)) into v_salary
	from employees
	where employee_id = in_emp_id;
	dbms_output.put_line('Total Salary of employee '||in_emp_id||' is: '||v_salary);
end;

exec total_salary(106);

------------------------------------------------------------------------------

DECLARE 
	vemp_salary employees.salary%type;
	cursor c1 is select salary from employees; 			-- cursor declaration
BEGIN
	open c1;
	fetch c1 into vemp_salary;
	dbms_output.put_line(vemp_salary);
	fetch c1 into vemp_salary;
	dbms_output.put_line(vemp_salary);
	fetch c1 into vemp_salary;
	dbms_output.put_line(vemp_salary);
	close c1;
END;

------------------------------------------------------------------------------

DECLARE
	vemp_salary employees.salary%type;
	cursor c1 is select salary from employees; 			-- cursor declaration
BEGIN
	open c1;
	loop
		fetch c1 into vemp_salary;
		exit when c1%notfound;
		dbms_output.put_line(vemp_salary);
	end loop;
	dbms_output.put_line('end of the loop');
	dbms_output.put_line('Total fetched records from base table: '|| c1%rowcount);
	close c1;
END;

------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE get_employees(in_dept_id IN employees.dept_id%type)
AS
	v_first_name employees.first_name%type;
	v_salary employees.salary%type;
	cursor c1 is 
		select first_name, salary 
		from employees 
		where dept_id = in_dept_id;

BEGIN
	open c1;
	loop
		fetch c1 into v_first_name, v_salary;
		exit when c1%notfound;
		dbms_output.put_line(v_first_name);
		dbms_output.put_line(v_salary);
	end loop;
	close c1;
end;


exec get_employees;

==============================================================================

-- How to find the source codes

data dictionary table:
User_procedures;
User_objects;
User_source;

select * from all_procedures where owner='HR';

select text from all_source where owner='HR' and type='PROCEDURE' and name='ADD_JOB_HISTORY';

==============================================================================

Functions
=========
Functions always return a value. 
Procedures may or may not return a value.
Functions can be used inside a select statement, while procedure cant.

Oracle predefined Functions
===========================
substr()
rank()
max()

------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION hello_function(p_name IN varchar2) 
return varchar2
AS
v_result varchar2(100);
BEGIN
	v_result := 'Hello '||p_name;
	return v_result;
end hello_function;

select hello_function('NIC') from dual;

------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION f_count
return number
AS
v_count number;
BEGIN
	SELECT count(*) into v_count
	from employees;
	return v_count;
END f_count;

select f_count() from dual;

------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION emp_func(v_emp__id IN number)
return number
AS
v_salary number(8);
v_new_sal number(10);
BEGIN
	select salary into v_salary
	from employees
	where employee_id = v_emp_id;
	if (v_salary) > 10000 then
		v_new_sal := v_salary + (v_salary * 0.1);
	else
		v_new_sal := v_salary + (v_salary * 0.2);
	end if;
	return v_new_sal;
END;

select emp_func(120) from dual;

select employee_id, name, salary, emp_func(employee_id) incr_salary from employees;

------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION salary_hike(p_emp_id IN number)
return number
AS
v_job employees.job_id%type;
v_sal employees.salary%type;
v_raise number(3,2);
v_new_sal number(6);
BEGIN
	SELECT job_id, salary into v_job, v_sal
	from employees
	where employee_id = p_emp_id;
	CASE 
		WHEN v_job='AD_VP' THEN
			IF v_sal < 20000 THEN v_raise := 0.5;
			else v_raise := 0;
			end if;
		WHEN v_job='clerk' THEN
			IF v_sal < 1500 THEN v_raise := 0.2;
			else v_raise := 0;
			end if;
	end case;
	IF v_raise > 0 then 
		v_new_sal := v_sal + v_sal * v_raise;
	ELSE
		v_new_sal := v_sal;
	end if;
	return v_new_sal;
END salary_hike;

select
	employee_id,
	first_name,
	salary,
	job_id,
	salary_hike(employee_id)
from employees;

------------------------------------------------------------------------------

leap_year or non_leap_year
--------------------------

CREATE OR REPLACE FUNCTION is_leap_year(nYr in number)
return varchar2
AS
v_day varchar2(2);
BEGIN
	select to_char(last_day(to_date('01-FEB-'||to_char(nYr), 'DD-MON-YYYY')), 'DD') into v_day
	from dual;
	IF v_day = '29' then
		return 'leap year';
	else
		return 'non leap year';
	end if;
END is_leap_year;

select is_leap_year(2023) from dual;

------------------------------------------------------------------------------

CREATE TABLE employee_info
(
	emp_id number(5) primary key,
	first_name varchar2(20),
	last_name varchar2(20)
);

CREATE TABLE emp_address_details
(
	emp_address_id number(5) primary key,
	emp_id number(5) references employee_info(emp_id),
	city varchar2(15),
	state varchar2(15),
	country varchar2(20),
	zip_code varchar2(10)
);

INSERT INTO employee_info VALUES (10, 'Rakesh', 'Sharma');
INSERT INTO employee_info VALUES (20, 'John', 'Paul');

INSERT INTO employee_address_details VALUES (101, 10, 'Vegas', 'Nevada', 'US', '88901');
INSERT INTO employee_address_details VALUES (102, 20, 'Carson', 'Nevada', 'US', '90220');

commit;


-- create function get_complete_address
CREATE OR REPLACE FUNCTION get_complete_address(in_emp_id in number) return varchar2
AS 
emp_details varchar2(130);
BEGIN
	select 
		'Name-'||emp.first_name||' '||emp.last_name||
		', City-'||address.city||', State-'||address.state||
		', Country-'||address.country||', Zip Code-'||address.zip_code
	into emp_details
	from employee_info emp, emp_address_details address
	where emp.emp_id = in_emp_id
	and address.emp_id = emp.emp_id;

	return emp_details;
END get_complete_address;


select emp_id, first_name, get_complete_address(emp_id) address from employee_info;

==============================================================================

Packages
========

CREATE OR REPLACE PACKAGE first_package AS
	procedure greetings1(p_name IN varchar2);
	function hello_function(p_name IN varchar2) return varchar2;
END first_package;

CREATE OR REPLACE PACKAGE BODY first_package AS
	PROCEDURE greetings1(p_name IN varchar2) As
	BEGIN
		dbms_output.put_line('Hello '||p_name);
	end greetings1;

	FUNCTION hello_function(p_name IN varchar2) return varchar2 AS
	v_result varchar2(100);
	BEGIN
		v_result:='Hello '||p_name;
		return v_result;
	end hello_function;
end first_package;


execute first_package.greetings1('chandrasekar');

-------------------------------------------------------------------------------

CREATE OR REPLACE PACKAGE pkg_overload_add_numbers AS
	PROCEDURE add_num(A number, B number);
	PROCEDURE add_num(A number, B number, C number);
end pkg_overload_add_numbers;

CREATE OR REPLACE PACKAGE BODY pkg_overload_add_numbers AS
	PROCEDURE add_num(A number, B number) AS
		BEGIN
			dbms_output.put_line('Sum of two numbers is:'||to_char(A + B));
		end add_num;
	PROCEDURE add_num(A number, B number, C number) AS
		BEGIN
			dbms_output.put_line('Sum of three numbers is:'||to_char(A + B + C));
		end add_num;
end pkg_overload_add_numbers;

-------------------------------------------------------------------------------

comparing procedure and Function
================================

CREATE OR REPLACE PROCEDURE cal_new_sal(in_emp_id IN number, in_comm_pct IN number, new_sal OUT number) AS
BEGIN
	if in_emp_id is null then
		return;
	end if;
	update employees_bkp set salary = salary + salary * in_comm_pct where employee_id = in_emp_id;
	returning salary into new_sal;
end cal_new_sal;

DECLARE
x number;
BEGIN
	cal_new_sal(102, 0.1, x);
	dbms_output.put_line(x);
END;

-------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION addition (num1 number, num2 number) return number AS
add1 number;
BEGIN
	add1 := num1 + num2;
	return add1;
END addition;

CREATE OR REPLACE FUNCTION welcome return varchar2 AS
pragma autonomous_transaction;
BEGIN
	update employees_bkp set salary = salary;
	commit;
	return 'welcome to plsql function';
end welcome;


CREATE OR REPLACE FUNCTION function_ddl return number AS
pragma autonomous_transaction;
BEGIN
	execute immediate 'create table hr.customer(cust_id number)';
	execute immediate 'drop table hr_customer1';
	commit;
	return 0;
end function_ddl;

-------------------------------------------------------------------------------

CREATE OR REPLACE PACKAGE sample_package AS
	PROCEDURE procedure1;
	PROCEDURE procedure2;
end sample_package;

CREATE OR REPLACE PACKAGE BODY sample_package AS
	PROCEDURE procedure3 AS
	BEGIN
		dbms_output.put_line('This is procedure 3 - private procedure');
	end procedure3;
	PROCEDURE procedure1 AS
	BEGIN
		dbms_output.put_line('This is procedure 1 - public procedure');
	end procedure1;
	PROCEDURE procedure2 AS
	BEGIN
		dbms_output.put_line('This is procedure 2 - public procedure');
	end procedure2;
end sample_package;

=================================================================================

autonomous_transaction
=======================

INSERT INTO customer values (1000);
INSERT INTO customer values (1001);

DECLARE
	PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
	for i in 1002...1010 loop
		INSERT INTo customer values (i);
	end loop;
	commit;
END;

ROLLBACK;
SELECT * FROM customer;

-------------------------------------------------------------------------------

CREATE TABLE test (no1 number(3), no2 number(3));

INSERT INTO test VALUES (1,2);

DECLARE
	PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
	INSERT INTO test VALUES(3,4);
	COMMIT;
END;

INSERT INTO test VALUES(5,6);

ROLLBACK;

=================================================================================

TRIGGER
=======

DML: insert, update, delete
DDL: alter, drop, truncate, rename, grant, revoke, audit
System: login, log-out, start-up, shutdown
Instead of: Triggers on complex views
Compound: Combined DML

-------------------------------------------------------------------------------

types of DML Triggers
=====================
Row level and statement level trigger

======================
firing point: BEFORE
======================
BEFORE INSERT TRIGGER
BEFORE UPDATE TRIGGER
BEFORE DELETE TRIGGER

======================
firing point: After
======================
AFTER INSERT TRIGGER
AFTER UPDATE TRIGGER
AFTER DELETE TRIGGER

-------------------------------------------------------------------------------

DROP TRIGGER trigger_name;
ALTER TRIGGER trigger_name DISABLE;
ALTER TRIGGER trigger_name ENABLE;
ALTER TABLE table_name DISABLE ALL TRIGGERS;
ALTER TABLE table_name ENABLE ALL TRIGGERS;

-------------------------------------------------------------------------------

CREATE TABLE customer_details as select * from s_customer_scd;
CREATE TABLE customer_bkp_trig as select * from s_customer_scd where 1=2;		-- empty backup table

ALTER TABLE customer_bkp_trig ADD date_of_deletion DATE;
ALTER TABLE customer_bkp_trig ADD who_deleted varchar2(30);

CREATE OR REPLACE TRIGGER customer_trigger
BEFORE DELETE ON customer_details
FOR EACH ROW
BEGIN
	INSERT INTO customer_bkp_trig VALUES
	(:old.customer_id, :old.first_name, :old.mobile, :old.address, :old.zipcode, :old.country, sysdate, user);
END customer_trigger;

DELETE FROM customer_details WHERE customer_id = 100003;

-------------------------------------------------------------------------------

CREATE TABLE ddl_trigger_table_log
(
	oracle_obj_name varchar2(50),
	oracle_user varchar2(50),
	ddl_execution_date date,
	oracle_system_event varchar2(50),
	oracle_obj_type varchar2(50),
	oracle_obj_owner varchar2(50)
);

CREATE OR REPLACE TRIGGER ddl_trigger
AFTER DDL ON SCHEMA
BEGIN
	INSERT INTO ddl_trigger_table_log VALUES			-- this table couldnt be deleted without removing the trigger
	(
		ora_dict_obj_name, 
		ora_login_user, 
		sysdate, 
		ora_sysevent, 
		ora_dict_obj_type, 
		ora_dict_obj_owner
	);
END ddl_trigger;

DROP TABLE customer_bkp;
select * from ddl_trigger_table_log;

-------------------------------------------------------------------------------

logon / logoff TRIGGER
======================

CREATE TABLE user_event_log
(
	ora_login_user varchar2(30),
	ora_sysevent varchar2(30),
	creation_date date
);

CREATE OR REPLACE TRIGGER logon_ddl_trigger
AFTER LOGON ON SCHEMA
BEGIN
	INSERT INTO hr.user_event_log VALUES
	(ora_login_user, sysdate, ora_sysevent);
END logon_ddl_trigger;

select * from user_event_log;

-------------------------------------------------------------------------------

Order of Trigger execution
===========================

CREATE TABLE student
(
	sno number,
	sname varchar2(50),
	sdoj date,
	sresult varchar2(30)
);

CREATE SEQUENCE log_seq;

CREATE OR REPLACE TRIGGER st_bf_ins
before insert on student
begin
	dbms_output.put_line('Statement level - before insert: '||log_seq.nextval);
end st_bf_ins;

CREATE OR REPLACE TRIGGER row_bf_ins
before insert on student
for each row
BEGIN
	dbms_output.put_line('Row level - before insert: '||log_seq.nextval);
end row_bf_ins;

CREATE OR REPLACE TRIGGER row_af_ins
after insert on student
for each row
BEGIN
	dbms_output.put_line('Row level - after insert: '||log_seq.nextval);
END row_af_ins;

CREATE OR REPLACE TRIGGER st_af_ins
after insert on student
BEGIN
	dbms_output.put_line('Statement level - after insert: '||log_seq.nextval);
end st_af_ins;

-------------------------------------------------------------------------------

instead of Triggers
=====================

select * from employees;
select * from departments;

CREATE OR REPLACE VIEW emp_v AS
SELECT employee_id, first_name, last_name, email, hire_date, job_id
FROM employees
WHERE department_id = 30;

select * from emp_v;

INSERT INTO emp_v VALUES
(300, 'Arun', 'Kumar', 'arun@gmail.com', sysdate, 'PU clerk');

CREATE OR REPLACE VIEW emp_dept_v AS
SELECT 
	e.employee_id,
	e.first_name,
	e.last_name,
	e.email,
	e.hire_date,
	e.job_id,
	e.salary,
	e.department_id,
	d.department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id

INSERT INTO emp_dept_v VALUES
(300, 'Arun', 'Kumar', 'arun@gmail.com', sysdate, 'SA_REP', 50000, 20, 'Purchasing');     -- fail to insert into complex views

CREATE OR REPLACE TRIGGER tr_emp_dept_vw_instead
INSTEAD OF INSERT ON emp_dept_v
DECLARE
check_exist number;
BEGIN
	select count(*) 
	into check_exist 
	from departments 
	where department_id = :new.department_id;

	if check_exist=0 then
		insert into departments(department_id, department_name) VALUES
		(:new.department_id, :new.department_name);
	end if;

	select count(*)
	into check_exist
	from employees
	where employee_id=:new.employee_id;

	if check_exist=0 then
		insert into employees(employee_id, first_name, last_name, email, hire_date, job_id, salary, department_id) VALUES
		(:new.employee_id, :new.first_name, :new.last_name, :new.email, :new.hire_date, :new.job_id, :new.salary, :new.department_id);
	end if;
END tr_emp_dept_vw_instead;

-------------------------------------------------------------------------------

Mutating table error
=====================

CREATE TABLE customer1
(cust_id number, cust_name varchar2(100));

CREATE TABLE customer2
(cust_id number, cust_name varchar2(100));

INSERT INTO customer1 VALUES (200, 'NIC IT Academy');
Commit;

CREATE OR REPLACE TRIGGER mutate_trigger
AFTER INSERT ON customer2
FOR EACH ROW
DECLARE
	PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
	UPDATE customer1 
	SET cust_id = (select max(cust_id) from customer2);
	COMMIT;
END mutate_trigger;

================================================================================

RECORDS and COLLECTIONS IN PLSQL  -- composite data types
================================

Record 		- %type, %rowtype
Collection 	- varray, nested table, associative array

---------------------------------------------------------------------------------

DECLARE
TYPE emp_record_type AS RECORD(first_name varchar2(30), salary number(8));
emp_rec emp_record_type;
BEGIN
	emp_rec.first_name := 'John';
	emp_rec.salary := '20000';
	dbms_output.put_line(emp_rec.first_name||', '||emp_rec.salary);
end;

---------------------------------------------------------------------------------

Varray - variable-sized array 
===============================

DECLARE
	TYPE v_array_type AS varray(7) of varchar2(30);
	address v_array_type := v_array_type(null, null, null, null, null, null, null);
BEGIN
	address(1) := 'G2';
	address(2) := 'ABC Flat';
	address(3) := 'Kalyan';
	address(4) := 'Mumbai New';
	address(5) := 'Mumbai';
	address(6) := 'India';
	address(7) := '546354';
	dbms_output.put_line('The city of customer is: '||address(4));
END;

---------------------------------------------------------------------------------

DECLARE
	TYPE v_array_type AS varray(12) of varchar2(40);
	v_color v_array_type := v_array_type(null, null, null);
BEGIN
	v_color(1) := 'Red';
	v_color(2) := 'Black';
	v_color(3) := 'Blue';

	dbms_output.put_line('v_color(1) '||v_color(1));				-- Red
	dbms_output.put_line('v_color.limit '|| v_color.limit);			-- 12
	dbms_output.put_line('v_color.count '|| v_color.count);			-- 3
	dbms_output.put_line('v_color.first '|| v_color.first);			-- 1
	dbms_output.put_line('v_color.last '|| v_color.last);			-- 3
	dbms_output.put_line('v_color.prior '|| v_color.prior(3));		-- 2
	dbms_output.put_line('v_color.next '|| v_color.next(3));		-- null

	v_color.extend(5);
	dbms_output.put_line('v_color.count '|| v_color.count);			-- 8
	dbms_output.put_line('v_color.next '|| v_color.next(3));		-- 4

	v_color.trim();
	dbms_output.put_line('v_color.count '|| v_color.count);			-- 7

	v_color.delete();
	dbms_output.put_line('v_color.count '|| v_color.count);			-- 0
END;

---------------------------------------------------------------------------------

Nested table		-- nested tables do not have limit
============

DECLARE
	TYPE v_nested_table_type AS TABLE OF varchar2(40);
	v_color v_nested_table_type := v_nested_table_type(null, null, null);
BEGIN
	v_color(1) := 'Red';
	v_color(2) := 'Black';
	v_color(3) := 'Blue';

	dbms_output.put_line('v_count '||v_color.count);				-- 3
	v_color.extend(4);
	v_color(4) := 'Green';
	dbms_output.put_line('v_color(4) '||v_color(4));				-- Green
	dbms_output.put_line('v_color.limit '|| v_color.limit);			-- null
	dbms_output.put_line('v_color.count '|| v_color.count);			-- 7
	dbms_output.put_line('v_first_index '|| v_color.first);			-- 1
	dbms_output.put_line('v_last_index '|| v_color.last);			-- 7
	dbms_output.put_line('v_color.prior '|| v_color.prior(3));		-- 2
	v_color.delete(2);												-- delete removes specific element
	v_color.trim(2);												-- trim away the last 2 elements
END;

---------------------------------------------------------------------------------

Associative array			-- this is kinda like dictionary / hashmap
==================

DECLARE
	TYPE v_array_type AS TABLE OF varchar2(40) INDEX BY varchar2(10);
	v_color v_array_type;
BEGIN
	v_color('color1') := 'Red';
	v_color('color2') := 'Black';
	v_color('color3') := 'Blue';
	v_color('color4') := 'Green';

	dbms_output.put_line('v_color(3) '||v_color('color3'));
end;

===================================================================================

BULK COLLECT
=============

To reduce IO, data are loaded in batch instead of row by row.
Usually have to pair with datatype collection (varray, nested table or associative array) we discussed above.

syntax
------
SELECT <column1> BULK COLLECT INTO bulk_variable FROM <table name>;
FETCH <cursor name> BULK COLLECT INTO bulk_variable;

FORALL		-- similar idea but for FOR loop
======
FOR ALL <looping_variable> IN <LOWER_RANGE>...<HIGHER_RANGE>

LIMIT		-- another keyword we can usually use with BULK COLLECT
=====
LIMIT <cursor_name> BULK COLLECT INTO <bulk_variable> LIMIT <size>;

----------------------------------------------------------------------------------

CREATE TABLE bulk_table(id number);
CREATE TABLE bulk_bind(id number);

BEGIN
	for i in 1..1000000
	loop
		INSERT INTO bulk_table values(i);
	end loop;
	COMMIT;
END;
-- task completed in 26s.

SELECT COUNT(*) FROM bulk_table;		-- 1000000


-- bulk collect to avoid context switching
DECLARE
	TYPE rt AS TABLE OF bulk_table%rowtype;
	vt rt; 
BEGIN
	select * BULK COLLECT INTO vt
	from bulk_table;
	forall i IN 1..vt.count
		INSERT INTO bulk_bind VALUES vt(i);
	COMMIT;
END;
-- task completed in 1s.

----------------------------------------------------------------------------------

-- select statement in plsql block

set serveroutput on;
clear screen;
DECLARE
	v_first_name hr.employees.first_name%type;
	v_emp_salary hr.employees.salary%type;
BEGIN
	select first_name, salary into v_first_name, v_emp_salary
	from employees
	where employee_id=120;
	dbms_output.put_line('The first name of the employee is '||v_first_name);
	dbms_output.put_line('The salary of the employee is '||v_emp_salary);
exception
	when no_data_found then
		dbms_output.put_line('No data found for this employee.');
	when too_many_rows then
		dbms_output.put_line('Many rows are returned from base table.');
END;


-- using cursor
DECLARE
	vemp_name employees.first_name%type;
	vemp_salary employees.salary%type
	cursor c1 AS SELECT first_name, salary from employees;
BEGIN
	open c1;
	loop
		fetch c1 into vemp_name, vemp_salary;
		exit when c1%notfound;
		dbms_output.put_line(vemp_name||vemp_salary);
	end loop;
	close c1;
END;


-- bulk collect and composite variable
SET SERVEROUTPUT ON;
DECLARE
	type nt_salary_type AS TABLE OF NUMBER(10);
	nt_salary nt_salary_type := nt_salary_type();
BEGIN
	select salary bulk collect into nt_salary from employees;
	for i in nt_salary.first..nt_salary.last
	loop
		dbms_output.put_line(nt_salary(i));
	end loop;
END; 

----------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE increase_salary(
	department_id_in IN employees.department_id%type,
	increase_pct_in IN number
) AS
BEGIN
	for employee_rec IN (
		select employee_id 
		from employees 
		where department_id = increase_salary.department_id_in
		)
	loop
		UPDATE employees emp
		SET emp.salary = emp.salary + emp.salary * increase_salary.increase_pct_in
		WHERE emp.employee_id = employee_rec.employee_id;
		dbms_output.put_line('updated '||SQL%rowcount);
	end loop;
END increase_salary;

----------------------------------------------------------------------------------

DECLARE
	type employees_t AS TABLE OF employees%rowtype;
	l_employees employees_t;
BEGIN
	select * bulk collect into l_employees
	from employees;
	dbms_output.put_line('Total count: '||l_employees.count);
	for indx IN 1..l_employees.count
	loop
		dbms_output.put_line(l_employees(indx).last_name);
	end loop;
END;

----------------------------------------------------------------------------------

DECLARE
	c_limit CONSTANT PLS_INTEGER DEFAULT 100;
	cursor emp_cur AS SELECT * FROM employees;

	TYPE employee_aat AS TABLE OF employees%rowtype INDEX BY binary_integer;
	l_employee employee_aat;
BEGIN
	open emp_cur;
	loop
		fetch emp_cur bulk collect into l_employee limit c_limit;
		exit when l_employee.count = 0;
		dbms_output.put_line('Retrieved '||l_employee.count);

		for indx in 1..l_employee.count
		loop
			dbms_output.put_line(
				l_employee(indx).employee_id||'-'||l_employee(indx).last_name
			);
		end loop;
	end loop;
	close emp_cur;
END;
/

================================================================================

dynamic SQL
============

implementation methods
-----------------------
1. execute immediate
2. using a package dbms_sql

1. dynamic dml - insert / update / delete
2. dynamic ddl - drop and create table
3. dynamic plsql block
-------------------------------------------------------------------------------

BEGIN
	for rec IN (select table_name from all_tables where owner='HR' and upper(table_name) LIKE '%bkp')
	loop
		execute immediate 'drop table '||rec.table_name;
	end loop;
END;

==================================================================================

exception handling
==================

1. predefined exceptions
	- named exception
	- unnamed exception
2. user-defined exception


1. predefined exceptions
--------------------------
ZERO_DIVIDE 			-- division by zero
VALUE_ERROR 			-- value do not match the datatype specified, including exceeding size limit
INVALID_NUMBER 			-- value is not a number
NO_DATA_FOUND 			-- return no rows or the data is deleted
TOO_MANY_ROWS 			-- query return more than the expected one row result.
DUP_VAL_ON_INDEX 		-- violate PK or unique constraint
SUBSCRIPT_BEYOND_COUNT 	-- using a bigger-than-max index on a nested table / varray
SUBSCRIPT_OUTSIDE_LIMIT -- using a illegal index (e.g. -1) on a nested table / varray
COLLECTION_IS_NULL 		-- collection is not yet initialized
CURSOR_ALREADY_OPEN 	-- cursor is open for a 2nd time
INVALID_CURSOR 			-- illegal cursor operation (e.g. fetch before open)
CASE_NOT_FOUND 			-- all case when are false and no else provided
ACCESS_INTO_NULL 		-- object accessed is not initialized
ROWTYPE_MISMATCH		-- row datatype not match
LOGIN_DENIED 			-- invalid login user / password
NOT_LOGGED_ON 			-- have not login and connected to a DB
PROGRAM_ERROR 			-- rare bug on Oracle side
STORAGE_ERROR			-- memory allocation error, e.g. out of memory
TIMEOUT_ON_RESOURCE		-- waited to long for a locked resource

---------------------------------------------------------------------------------------

DECLARE
	v_salary number;
BEGIN
	v_salary := 10000 / 0;
	exception
	when zero_divide then					-- predefined named
		dbms_output.put_line('Divisor is equal to zero. Operation is not allowed.');
	when others then						-- predefined unnamed
		dbms_output.put_line('Exception happened, check the code');
END;

---------------------------------------------------------------------------------------

-- provide a name for unnamed exception - PRAGMA EXCEPTION_INIT

DECLARE
	v_salary number;
	ex_cust_id_value_limit exception;
	PRAGMA EXCEPTION_INIT(ex_cust_id_value_limit, -01438); 			-- some error code do not have name
BEGIN
	INSERT INTO cust(cust_id)
	VALUES (897463895676529479743982742);
	v_salary := 10000 / 0;

	exception
	when ex_cust_id_value_limit then
		dbms_output.put_line('Exception happened and it has been handled.');
END;

---------------------------------------------------------------------------------------

-- user-defined exception

CREATE TABLE emp_excep
(
	emp_id number(6);
	emp_name varchar2(40);
);

ALTER TABLE emp_excep ADD PRIMARY KEY (emp_id);

CREATE OR REPLACE PROCEDURE add_new_employee (employee_id_in IN number, first_name_in IN varchar2) AS
BEGIN
	INSERT INTO emp_excep(emp_id, emp_name)
	VALUES (employee_id_in, first_name_in);
	COMMIT;
	EXCEPTION
	WHEN DUP_VAL_ON_INDEX THEN
		raise_application_error(-20001, 'You are trying to insert a duplicate emp_id.');
	WHEN OTHERS THEN
		raise_application_error(-20002, 'An error has occured inserting an employee.')
END add_new_employee;

---------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE emp_union_exceptn(in_emp_id IN number, in_first_name IN varchar2) AS
invalid_emp_id exception;
BEGIN
	IF in_emp_id < 100 then 
		raise invalid_emp_id;
	else
		insert into hr.emp_excep(employee_id, first_name)
		values (in_emp_id, in_first_name);
	end if;
	exception
	when invalid_emp_id then
		raise application_error(-20001, 'Please enter the emp_id that is greater than 100')
END emp_union_exceptn;

---------------------------------------------------------------------------------------

SQLCODE = return the number code of the most recent exception
SQLERRM = return the error message of the most recent exception

======================================================================================

Temporary table
==============

/* 
oracle support 2 types of temp tables 
	- global temp table - avail since oracle 8i
	- private temp table  - avail since oracle 18c

	- data only lasts for a single session
*/

CREATE GLOBAL TEMPORARY TABLE my_temp_table (
	id number,
	description varchar2(20)
)
ON COMMIT DELETE ROWS;						-- ON COMMIT PRESERVE ROWS;

-- insert, but do not commit, then check the content of GTT

INSERT INTO my_temp_table VALUES (1, 'ONE');

SELECT COUNT(*) FROM my_temp_table;