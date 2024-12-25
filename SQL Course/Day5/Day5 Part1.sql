USE ITI
--1.Retrieve number of students who have a value in their age. 
SELECT COUNT(St_Age) FROM Student where St_Age IS NOT NULL


--2.Get all instructors Names without repetition
SELECT DISTINCT Ins_Name FROM Instructor 



--3.Display student with the following Format (use isNull function)
SELECT St_Id AS 'Student ID', CONCAT_WS(' ',ISNULL(St_Fname,'NULL'),ISNULL(St_Lname,'NULL')) AS 'Student Full Name', ISNULL(D.Dept_name,'No Dept') AS [Department name]
FROM Student S INNER JOIN Department D 
ON S.Dept_Id = D.Dept_Id



--4.Display instructor Name and Department Name 
--Note: display all the instructors if they are attached to a department or not
SELECT I.Ins_Name, D.Dept_Name
FROM Instructor I LEFT OUTER JOIN Department D
ON I.Dept_Id = D.Dept_Id


--5.Display student full name and the name of the course he is taking
--For only courses which have a grade  
SELECT CONCAT_WS(' ',S.St_Fname,S.St_Lname) AS [Full Name], C.Crs_Name
FROM Student S INNER JOIN Stud_Course SC 
ON S.St_Id = SC.St_Id
INNER JOIN Course C
ON SC.Crs_Id = C.Crs_Id
WHERE SC.Grade IS NOT NULL
ORDER BY [Full Name]


--6.Display number of courses for each topic name
SELECT T.Top_Name , COUNT(C.Crs_Id)
FROM Topic T INNER JOIN Course C 
ON T.Top_Id = C.Top_Id
GROUP BY T.Top_Name


--7.Display max and min salary for instructors
SELECT Max(ISNULL(Salary,0)), Min(ISNULL(Salary,0)) FROM Instructor


--8.Display instructors who have salaries less than the average salary of all instructors.
SELECT Ins_Id, Ins_Name FROM Instructor WHERE Salary < (SELECT AVG(Salary) FROM Instructor)



--9.Display the Department name that contains the instructor who receives the minimum salary.
SELECT D.Dept_Name FROM Department D INNER JOIN Instructor I ON D.Dept_Id = I.Dept_Id WHERE I.Salary = (SELECT MIN(Salary) FROM Instructor)

--10.Select max two salaries in instructor table. 
SELECT TOP(2) Ins_Name, Salary 
FROM Instructor
ORDER BY Salary DESC


--11.Select instructor name and his salary but if there is no salary display instructor bonus keyword. “use coalesce Function”
SELECT Ins_Name, COALESCE(CAST(Salary AS VARCHAR),'Bonus') FROM Instructor


--12.Select Average Salary for instructors 
Select AVG(Salary) From Instructor


--13.Select Student first name and the data of his supervisor 
SELECT y.St_Fname , x.*
FROM Student x, Student y
WHERE x.St_Id = y.St_super


--14.Write a query to select the highest two salaries in Each Department for instructors who have salaries. “using one of Ranking Functions”
SELECT * 
FROM (
		SELECT Dept_Id, Salary, DENSE_RANK() OVER(PARTITION BY Dept_Id ORDER BY Salary DESC) AS DR
		FROM Instructor ) AS NewTable
WHERE DR <= 2


--15.Write a query to select a random student from each department.  “using one of Ranking Functions”
SELECT * 
FROM (
		SELECT Dept_Id, Salary, ROW_NUMBER() OVER(PARTITION BY Dept_Id ORDER BY NEWID()) AS RN
		FROM Instructor ) AS NewTable
WHERE RN=1
