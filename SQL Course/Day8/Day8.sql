--1.Create a stored procedure without parameters to show the number of students per department name.[use ITI DB] 
USE ITI
CREATE PROC numbst
AS
	SELECT COUNT(S.St_Id) AS [Number of Students], D.Dept_Name
	FROM Student S INNER JOIN Department D
	ON D.Dept_Id = S.Dept_Id
	GROUP BY D.Dept_Name
numbst

--2.Create a stored procedure that will check for the # of employees in the project p1 
--if they are more than 3 print message to the user 
--“'The number of employees in the project p1 is 3 or more'” 
--if they are less display a message to the user “'The following employees work for the project p1'” 
--in addition to the first name and last name of each one. [Company DB] 
USE Company_SD
Create PROC projectnum @num int
AS
	BEGIN
		DECLARE @count int
		SELECT @count = COUNT(ESSn) FROM Works_for WHERE Pno = @num
		IF @count >= 3 
		BEGIN
			SELECT 'The number of employees in the project p1 is 3 or more'
			SELECT Fname, Lname FROM HumanResource.Employee E INNER JOIN Works_for W ON W.ESSn = E.SSN WHERE W.pno = @num
		END
		ELSE
		BEGIN
			SELECT 'The following employees work for the project p1'
			SELECT Fname, Lname FROM HumanResource.Employee E INNER JOIN Works_for W ON W.ESSn = E.SSN WHERE W.pno = @num
		END
	END

projectnum 300


--3.Create a stored procedure that will be used in case there is an old employee has left the project 
--and a new one become instead of him.
--The procedure should take 3 parameters (old Emp. number, new Emp. number and the project number) 
--and it will be used to update works_on table. [Company DB]
USE Company_SD

CREATE PROC updateEmp @oldid int, @newid int, @pnum int
AS
	BEGIN TRY
		UPDATE Works_for
		SET ESSn = @newid, Pno = @pnum
		WHERE ESSn = @oldid
	END TRY
	BEGIN CATCH
		SELECT 'Something Went Wrong',ERROR_MESSAGE()
	END CATCH


--4.add column budget in project table and insert any draft values in it then then Create an Audit table with the following structure 
--ProjectNo 	UserName 	ModifiedDate 	Budget_Old 	Budget_New 
--p2 	Dbo 	2008-01-31	95000 	200000 
--This table will be used to audit the update trials on the Budget column (Project table, Company DB)
--Example:
--If a user updated the budget column then the project number, user name that made that update, 
--the date of the modification and the value of the old and the new budget will be inserted into the Audit table
--Note: This process will take place only if the user updated the budget column
ALTER TABLE Company.Project
ADD budget INT
UPDATE Company.Project
SET budget = 1000

CREATE TABLE Audit(
ProjectNo INT,
UserName VARCHAR(50),
ModifiedDate DATE,
Budget_Old INT,
Budget_New INT)

INSERT INTO Audit
VALUES(2,'Dbo','2008-01-31',95000,200000)

CREATE TRIGGER T1 
ON Company.Project
AFTER UPDATE 
AS
	IF UPDATE(budget)
		BEGIN
			DECLARE @pno INT, @old INT, @new INT
			SELECT @pno = Pnumber FROM inserted
			SELECT @old = budget FROM deleted
			SELECT @new = budget FROM inserted
			INSERT INTO Audit
			VALUES(@pno,SUSER_NAME(),GETDATE(),@old,@new)
		END

UPDATE Company.Project
SET budget = 120000
WHERE pnumber = 100


--5.	Create a trigger to prevent anyone from inserting a new record in the Department table [ITI DB]
--“Print a message for user to tell him that he can’t insert a new record in that table”
USE ITI
CREATE TRIGGER T1 ON Department
INSTEAD OF INSERT 
AS
	SELECT 'you can’t insert a new record in that table'

INSERT INTO Department (Dept_Id,Dept_Name)
VALUES(1,'aa')

--6.Create a trigger that prevents the insertion Process for Employee table in March [Company DB].
USE Company_SD
CREATE TRIGGER T2 ON Employee
AFTER INSERT
AS
	IF FORMAT(GETDATE(),'MMMM')='March'
		rollback


--7.Create a trigger on student table after insert to add Row in Student Audit table (Server User Name , Date, Note) 
--where note will be “[username] Insert New Row with Key=[Key Value] in table [table name]”
USE ITI
CREATE TABLE Audit
(
Server_username VARCHAR(50),
Date DATE,
Note VARCHAR(100)
)

CREATE TRIGGER T2 ON Student
AFTER INSERT 
AS
	DECLARE @id INT, @note VARCHAR(100)
	SELECT @id = St_Id FROM inserted
	SET @note = CONCAT_WS(' ',SUSER_NAME(),'Insert New Row with Key=',@id)
	INSERT INTO Audit
	VALUES(SUSER_NAME(),GETDATE(),@note)
	
INSERT INTO Student(St_Id, St_Age)
Values(100,15)
SELECT * FROM Audit


--8.Create a trigger on student table instead of delete to add Row in Student Audit table (Server User Name, Date, Note)
--where note will be“ try to delete Row with Key=[Key Value]”
CREATE TRIGGER T3 ON Student
INSTEAD OF DELETE
AS
	DECLARE @id INT, @note VARCHAR(100)
	SELECT @id = St_Id FROM deleted
	SET @note = CONCAT_WS(' ',SUSER_NAME(),'try to delete Row with Key=',@id)
	INSERT INTO Audit
	VALUES(SUSER_NAME(),GETDATE(),@note)

DELETE FROM Student
WHERE St_Id = 100

