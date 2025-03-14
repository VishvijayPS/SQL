-- CREATING EMPLOYEE5 TABLE
CREATE TABLE EMPLOYEE5( SSN INT PRIMARY KEY, NAME VARCHAR(20), ADDRESS VARCHAR(30), SEX VARCHAR(3), SALARY INT, SUPERSSN INT, FOREIGN KEY(SUPERSSN) REFERENCES EMPLOYEE5(SSN), DNO INT,FOREIGN KEY(DNO) REFERENCES DEPARTMENT5(DNO)); 

-- INSERTING TO IT
INSERT INTO EMPLOYEE5 VALUES(123456789, 'JOHN SMITH', 'HOUSTON','M', 25000, NULL,1);  

 
-- CREATING DEPARTMENT5 TABLE
CREATE TABLE DEPARTMENT5( DNO INT PRIMARY KEY, DNAME VARCHAR(20)); 

-- INSERTING TO IT
INSERT INTO DEPARTMENT5 VALUES( 1 ,'ACCOUNTS'); 

 
-- CREATING DLOCATION5 TABLE
CREATE TABLE DLOCATION5( DNO INT, DLOC VARCHAR(20), PRIMARY KEY (DNO,DLOC),FOREIGN KEY (DNO) REFERENCES DEPARTMENT5(DNO)); 

-- INSERTING TO IT
INSERT INTO DLOCATION5 VALUES( 1,'HOUSTON'); 

 
-- CREATING PROJECT5 TABLE
CREATE TABLE PROJECT5( PNO INT PRIMARY KEY, PNAME VARCHAR(20), PLOCATION VARCHAR(20), DNO INT, FOREIGN KEY (DNO)REFERENCES DEPARTMENT5(DNO)); 

-- INSERTING TO IT
INSERT INTO PROJECT5 VALUES(101,'IOT','HOUSTON', 1);


-- CREATING WORKS_ON5 TABLE
CREATE TABLE WORKS_ON5( SSN INT , PNO INT, FOREIGN KEY (SSN) REFERENCES EMPLOYEE5(SSN), FOREIGN KEY (PNO) REFERENCES PROJECT5(PNO), HOURS INT, PRIMARY KEY( SSN,PNO));

-- INSERTING TO IT
INSERT INTO WORKS_ON5 VALUES(123456789,101,10);


-- Query 1: 
 
select pno from employee5 e, works_on5 w where e.ssn=w.ssn and name='Scott' UNION select pno from employee5 e, department5 d, project5 p where e.ssn=d.mgrssn and d.dno=p.pno and name='Scott' ;


-- Query 2: 
 
select Name, Salary "Old Salary", Salary* 1.1 "New Salary" from employee5 e,works_on5 w, project5 p where e.ssn =w.ssn and w.pno= p.pno and pname = 'IoT'; 


-- Query 3: 
 
select sum(salary) "Total Salary", Max(Salary) "Maximum Salary" , Min(Salary) "Minimum Salary", Avg(Salary) "Average Salary" from employee5 e, department5 d where e.dno= d.dno and dname='Accounts';


-- Query 4: 
 
select e.name from employee5 e where not exists ((select pno from project5 where dno=5) except (select pno from works_on5 where e.ssn= ssn)); 


-- Query 5: 
select dno, (select count(*) from employee5 where salary>600000 and dno in (select dno from employee5 group by dno having count(*)>=5 )) as count_salary from employee5 group by dno having count(*)>=5; 