Use ITI 
--1.Create a scalar function that takes date and returns Month name of that date.
CREATE FUNCTION monthname(@date date)
RETURNS NVARCHAR(20)
	BEGIN 
		declare @month VARCHAR(20)
			SELECT @month = format(@date,'MMMM')
		RETURN @month
	END

SELECT dbo.monthname('6/12/2020') AS "month"


--2.Create a multi-statements table-valued function that takes 2 integers and returns the values between them.
CREATE FUNCTION MidValues(@start int, @end int)
RETURNS @midValues TABLE
(
	mid INT
)
AS
BEGIN
	IF @start < @end
	BEGIN
		
		DECLARE @counter INT = @start +1
		WHILE @counter < @end

		BEGIN
			INSERT INTO @midValues (mid)
			VALUES (@counter)
			SET @counter = @counter + 1
		END
	END
	RETURN
END
SELECT * FROM MidValues(10,20)


--3.Create inline function that takes Student No and returns Department Name with Student full name.
CREATE FUNCTION getdept (@st_id int)
RETURNS TABLE
AS 
	RETURN
	(
	SELECT D.Dept_Name, CONCAT_WS(' ',S.st_fname,S.st_lname) AS [Full Name]
	FROM Department D INNER JOIN Student S ON D.Dept_Id = S.Dept_Id
	WHERE S.st_id = @st_id
	)

SELECT * FROM getdept(10)


--4.Create a scalar function that takes Student ID and returns a message to user
--a. If first name and Last name are null then display 'First name & last name are null'
--b. If First name is null then display 'first name is null'
--c. If Last name is null then display 'last name is null'
--d. Else display 'First name & last name are not null'

CREATE FUNCTION getstudentname(@id int)
RETURNS varchar(50)
	BEGIN
		DECLARE @msg varchar(50), @fname varchar(20), @lname varchar(20)

		SELECT @fname = ST_Fname, @lname = ST_Lname FROM Student WHERE St_Id = @id
		IF @fname IS NULL AND @lname IS NULL
			SELECT @msg = 'First name & last name are null'
		ELSE IF @fname IS NULL 
			SELECT @msg = 'First name is null'
		ELSE IF @lname IS NULL
			SELECT @msg = 'Last name is null'
		ELSE
			SELECT @msg = 'First name and Last name are not null'
		RETURN @msg
	END

SELECT dbo.getstudentname(13)


--5.Create inline function that takes integer which represents manager ID and displays department name, Manager Name and hiring date
CREATE FUNCTION getmanager(@id int)
RETURNS TABLE
	RETURN
	(
	SELECT D.Dept_name, I.Ins_name AS [Manager Name], D.Manager_hiredate 
	FROM Department D INNER JOIN Instructor I
	ON D.Dept_Manager = I.Ins_Id 
	WHERE D.Dept_Manager = @id
	)

SELECT * FROM getmanager(9)


--6.Create multi-statements table-valued function that takes a string
--If string='first name' returns student first name
--If string='last name' returns student last name
--If string='full name' returns Full Name from student table
--Note: Use “ISNULL” function

CREATE FUNCTION getname(@format varchar(20))
RETURNS @t TABLE (Student_name Varchar(50))
AS
	BEGIN
		IF @format = 'first name'
		INSERT INTO @t
		SELECT St_Fname FROM Student
		ELSE IF @format = 'last name'
		INSERT INTO @t
		SELECT St_Lname FROM Student
		ELSE IF @format = 'Full name'
		INSERT INTO @t
		SELECT CONCAT_WS(' ',St_Fname,St_Lname) FROM Student
		RETURN
	END


SELECT * FROM getname('full name')



--7.Write a query that returns the Student No and Student first name without the last char
SELECT st_id, SUBSTRING(st_fname, 1, LEN(st_fname)-1) FROM student


--8.Write query to delete all grades for the students Located in SD Department
DELETE Stud_Course
FROM Stud_Course SC INNER JOIN Student S
ON S.St_Id = SC.St_Id
INNER JOIN Department D
ON D.Dept_Id = S.Dept_Id
WHERE D.Dept_Name = 'SD'



--9.Try to Create Login Named(ITIStud) who can access Only student and 
--Course tablesfrom ITI DB then allow him to select and insert data into
--tables and deny Delete and update
CREATE SCHEMA ST

ALTER SCHEMA ST TRANSFER Student
ALTER SCHEMA ST TRANSFER Course

SELECT * FROM ST.Student

DELETE FROM ST.Student
WHERE ST_id = 1

















--10.Bonus: Give one Example about Hierarchyid datatype

--The hierarchyid data type in SQL Server is used to represent hierarchical data in a tree-like structure. 
--It is particularly useful for scenarios like organizational charts, file systems, or category trees.

CREATE TABLE Organization (
    EmployeeID INT PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL,
    Position NVARCHAR(50) NOT NULL,
    HierarchyNode HIERARCHYID NOT NULL,
    ManagerID INT NULL
)

INSERT INTO Organization (EmployeeID, Name, Position, HierarchyNode, ManagerID)
VALUES
    (1, 'Alice', 'CEO', hierarchyid::GetRoot(), NULL),
    (2, 'Bob', 'CTO', hierarchyid::Parse('/1/'), 1),  
    (3, 'Charlie', 'CFO', hierarchyid::Parse('/2/'), 1),
    (4, 'David', 'Engineer', hierarchyid::Parse('/1/1/'), 2),
    (5, 'Eve', 'Accountant', hierarchyid::Parse('/2/1/'), 3)


SELECT 
    EmployeeID, 
    Name, 
    Position, 
    HierarchyNode.ToString() AS HierarchyPath
FROM Organization
ORDER BY HierarchyNode

--Built-in Functions:
--GetAncestor(n): Finds the ancestor at level n.
--GetDescendant(child1, child2): Generates a child node.
--GetLevel(): Determines the depth of a node.
--ToString(): Converts the hierarchy ID to a readable format.

