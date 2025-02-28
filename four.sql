CREATE TABLE STUDENT(USN CHAR( 10) PRIMARY KEY, SNAME VARCHAR(20), ADDRESS VARCHAR(20), PHONE VARCHAR( 10), GENDER CHAR); 
INSERT INTO STUDENT VALUES('4MT15CS001','ABHIRAM','KERALA',7658475647,'M');  

 
CREATE TABLE SEMSEC(SSID INT PRIMARY KEY, SEM INT, SEC CHAR); 
INSERT INTO SEMSEC VALUES( 1 ,5,'A');  

 
CREATE TABLE CLASS(USN CHAR(10) PRIMARY KEY, SSID INT REFERENCES SEMSEC(SSID), FOREIGN KEY(USN) REFERENCES STUDENT(USN)); 
INSERT INTO CLASS VALUES('4MT15CS001',L);  
 
 
CREATE TABLE SUBJECT(SUBCODE VARCHAR(8) PRIMARY KEY, TITLE VARCHAR(20), SEM INT, CREDITS INT); 
INSERT INTO SUBJECT VALUES('15CS51','ME',5,4);  
 
 
CREATE TABLE IAMARKS(USN CHAR( 10) REFERENCES STUDENT(USN), SUBCODE VARCHAR(8) REFERENCES SUBJECT(SUBCODE), SSID INT REFERENCES SEMSEC(SSID), TEST1 INT, TEST2 INT, TEST3 INT, FINALIA INT, PRIMARY KEY(USN,SUBCODE,SSID));
INSERT INTO IAMARKS VALUES('4MT15CS001','15CS51',1,17,18,15,NULL); 


-- Query 1:
select s.usn,s.sname,address,phone,gender from student s, semsec ss, class c where s.usn = c.usn and c.ssid = ss.ssid and sem =5 and sec ='B'; 


-- Query 2: 
select ss.sem, ss.sec,s.gender,count(s.gender) as count from student s, semsec ss,class c where s.usn=c.usn and    ss.ssid=c.ssid group by ss.sem,ss.sec,s.gender order by sem; 


-- Query 3: 
create view stu_test1_marks_view as select test1, subcode from iamarks where usn='4MT15CS005';
select * from stu_test1_marks_view; 

-- Query 4: 
CREATE OR REPLACE PROCEDURE AVGMARKS IS CURSOR C_IAMARKS IS 
SELECT GREATEST(TEST1,TEST2) AS A, GREATEST(TEST1,TEST3) AS B, 
GREATEST(TEST3,TEST2) AS C FROM IAMARKS WHERE FINALIA IS NULL FOR UPDATE 
C_A NUMBER; 
C_B NUMBER; 
C_C NUMBER; 
C_SM NUMBER; 
C_AV NUMBER; 
 
 
BEGIN 
OPEN C_IAMARKS; LOOP 
FETCH C_IAMARKS INTO C_A, C_B, C_C; EXIT WHEN C_IAMARKS%NOTFOUND; --DBMS_OUTPUT.PUT_LINE(C_A || ' ' || C_B || ' ' ||C_C); IF (C_A != C_B) 
THEN C_SM:=C_A+C_B; ELSE C_SM:=C_A+C_C; END IF; 
C_AV:=C_SM/2; --DBMS_OUTPUT.PUT_LINE('SUM = '||C_SM); --DBMS_OUTPUT.PUT_LINE('AVERAGE = '||C_AV); 
UPDATE IAMARKS SET FINALIA=C_AV WHERE CURRENT OF C_IAMARKS; END LOOP; 
CLOSE C_IAMARKS; 
END; 
/ 

  
-- Query 5: 
select s.usn,sname,finalia, (CASE WHEN finalia>=17 and finalia<=20 then 'Outstanding' WHEN finalia>=12 and finalia<17 then 'Average' WHEN finalia<12 then 'Weak' END) CAT from student s, iamarks ia where s.usn=ia.usn; 
