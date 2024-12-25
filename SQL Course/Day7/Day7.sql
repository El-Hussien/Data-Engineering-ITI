--1.Create a view that displays student full name, course name if the student has a grade more than 50. 
USE ITI
CREATE VIEW StName
AS
	SELECT CONCAT_WS(' ',St_Fname,St_Lname) AS [Full Name], Crs_Name
	FROM Student S INNER JOIN Stud_Course SC
	ON S.St_Id = SC.St_Id
	INNER JOIN Course C
	ON C.Crs_Id = SC.Crs_Id
	WHERE SC.Grade > 50


--2.Create an Encrypted view that displays manager names and the topics they teach. 
CREATE VIEW manager
WITH ENCRYPTION 
AS
	SELECT I.Ins_name, T.Top_Name
	FROM Department D INNER JOIN Instructor I
	ON D.Dept_Manager = I.Ins_Id
	INNER JOIN Ins_Course IC
	On I.Ins_Id = IC.Ins_Id
	INNER JOIN Course C
	ON C.Crs_Id = IC.Crs_Id
	INNER JOIN Topic T
	ON T.Top_Id = C.Top_Id
	


--3.Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department 
CREATE VIEW InstName
AS
	SELECT Ins_Name, Dept_Name
	FROM Instructor I INNER JOIN Department D
	ON I.Dept_Id = D.Dept_Id
	WHERE Dept_Name = 'SD' OR Dept_Name = 'Java'


--4.Create a view “V1” that displays student data for student who lives in Alex or Cairo. 
--Note: Prevent the users to run the following query 
--Update V1 set st_address=’tanta’
--Where st_address=’alex’;
CREATE VIEW V1 
AS
	SELECT * FROM Student WHERE St_Address = 'Cairo' OR St_Address = 'Alex' WITH CHECK OPTION


--5.Create a view that will display the project name and the number of employees work on it. “Use Company DB”
USE Company_SD
CREATE VIEW projINfO
AS
	SELECT P.Pname, Count(E.SSN) AS Number_of_Employees
	FROM Employee E INNER JOIN Works_for W
	ON E.SSN = W.ESSn
	INNER JOIN Project P 
	ON P.Pnumber = W.Pno
	GROUP BY P.Pname



--6.“Use Company DB” Create the following schema and transfer the following tables to it 
--a.Company Schema 
--i.Department table (Programmatically)
--ii.Project table (by wizard)
--b.Human Resource Schema
--i.Employee table (Programmatically)
CREATE SCHEMA Company
ALTER SCHEMA Company TRANSFER Departments

CREATE SCHEMA HumanResource
ALTER SCHEMA HumanResource TRANSFER Employee



--7.Create index on column (manager_Hiredate) that allow u to cluster the data in table Department. What will happen?  - Use ITI DB
USE ITI
CREATE CLUSTERED INDEX i2 ON Department(Manager_hiredate) -- Error (Cant create more than one clustered index)
CREATE INDEX i2 ON Department(Manager_hiredate)


--8.Create index that allow u to enter unique ages in student table. What will happen?  - Use ITI DB
CREATE UNIQUE INDEX i3 ON Student(St_Age) -- Error (not all values are unique)
CREATE NONCLUSTERED INDEX i3 ON Student(St_Age) 


--9.Create a cursor for Employee table that increases Employee salary by 10% if Salary <3000 and increases it by 20% if Salary >=3000. Use company DB
USE Company_SD
DECLARE c1 CURSOR
FOR SELECT Salary
	FROM Employee
FOR UPDATE 
DECLARE @sal INT
OPEN C1
FETCH c1 INTO @sal
WHILE @@FETCH_STATUS=0
	BEGIN
		IF @sal < 3000
			UPDATE Employee
				SET Salary = @sal * 1.1
			WHERE CURRENT OF c1
		ELSE
			UPDATE Employee
				SET Salary = @sal * 1.2
			WHERE CURRENT OF c1
		FETCH c1 INTO @sal
	END
CLOSE c1
DEALLOCATE c1


--10.Display Department name with its manager name using cursor. Use ITI DB
USE ITI
DECLARE c1 CURSOR 
FOR SELECT D.Dept_Name, I.Ins_Name
FROM Department D INNER JOIN Instructor I 
ON D.Dept_Manager = I.Ins_Id
FOR READ ONLY

DECLARE @DeptName NVARCHAR(50)
DECLARE @MangName NVARCHAR(50)
OPEN c1;
FETCH c1 INTO @DeptName, @MangName
WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @DeptName, @MangName
		FETCH c1 INTO @DeptName, @MangName;
	END
CLOSE c1
DEALLOCATE c1

--11.Try to display all instructor names in one cell separated by comma. Using Cursor . Use ITI DB
USE ITI
DECLARE c1 CURSOR
FOR SELECT DISTINCT Ins_Name
	FROM Instructor
	WHERE Ins_Name IS NOT NULL
FOR READ ONLY

DECLARE @name VARCHAR(20),@all_names VARCHAR(300)=''
open c1
FETCH c1 INTO @name
WHILE @@FETCH_STATUS=0
	BEGIN
		SET @all_names=concat(@all_names,',',@name)
		FETCH c1 INTO @name
	END
SELECT @all_names
CLOSE c1
DEALLOCATE C1


--12.Try to generate script from DB ITI that describes all tables and views in this DB
-- Right click on ITI Database, >> Tasks >> Generate Script >> All running except the encripted view


--13.Using Merge statement between the following two tables [User ID, Transaction Amount]
USE Company_SD
CREATE TABLE Daily_Transactions (did int primary key, dvalue int)
CREATE TABLE Last_Transactions (lid int primary key, lvalue int)
INSERT INTO Daily_Transactions
VALUES (1,1000),(2,2000),(3,1000)
INSERT INTO Last_Transactions
VALUES (1, 4000),(4, 2000),(2, 10000)

MERGE INTO Last_Transactions AS T
USING Daily_Transactions AS S
ON T.lid = S.did
WHEN MATCHED THEN
	UPDATE
		SET T.lvalue = S.dvalue
WHEN NOT MATCHED THEN 
	INSERT 
		VALUES(s.did, s.dvalue);

SELECT * FROM Last_Transactions