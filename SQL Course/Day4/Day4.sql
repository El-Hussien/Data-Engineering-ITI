--1.Display (Using Union Function)
--a.The name and the gender of the dependence that's gender is Female and depending on Female Employee.
--b.And the male dependence that depends on Male Employee.
SELECT D.Dependent_name, D.Sex 
FROM Dependent D inner join Employee E 
ON E.SSN = D.ESSN
Where D.Sex = 'F' AND E.Sex = 'F'
UNION ALL
SELECT D.Dependent_name, D.Sex 
FROM Dependent D inner join Employee E 
ON E.SSN = D.ESSN
Where D.Sex = 'M' AND E.Sex = 'M'


--2.For each project, list the project name and the total hours per week (for all employees) spent on that project.
SELECT P.Pname, SUM(W.Hours) AS Total_Hours
FROM Project P inner join Works_for W
ON W.Pno = P.Pnumber
GROUP BY P.Pname


--3.Display the data of the department which has the smallest employee ID over all employees' ID.
SELECT D.*
FROM Departments D INNER JOIN Employee E
ON E.Dno = D.Dnum
WHERE E.SSN = (SELECT min(SSN) FROM Employee)


--4.For each department, retrieve the department name and the maximum, minimum and average salary of its employees.
SELECT D.Dname, Max(E.Salary), Min(E.Salary), AVG(E.Salary)
FROM Departments D INNER JOIN Employee E 
ON E.Dno = D.Dnum
Group BY D.Dname


--5.List the full name of all managers who have no dependents.
SELECT CONCAT_WS(' ',E.Fname,E.Lname) AS Full_Name 
FROM Employee E LEFT JOIN Dependent D
ON E.SSN = D.ESSN 
WHERE D.Dependent_name IS NULL 
AND E.SSN in (SELECT MGRSSN FROM Departments)


--6.For each department-- if its average salary is less than the average salary of all employees-- display its number, name and number of its employees.
SELECT D.Dnum, D.Dname, COUNT(E.SSN) AS 'number of employees'
FROM Departments D INNER JOIN Employee E
ON E.Dno = D.Dnum
GROUP BY D.Dnum, D.Dname
Having AVG(E.Salary) < (SELECT AVG(Salary) FROM Employee)



--7.Retrieve a list of employee’s names and the projects names they are working on ordered by department number and within each department, ordered alphabetically by last name, first name.
SELECT E.Fname, E.Lname, P.Pname
FROM Employee E INNER JOIN Works_for W
ON E.SSN = W.ESSn
INNER JOIN Project P
ON P.Pnumber = W.Pno
ORDER BY P.Dnum, E.Lname, E.Fname


--8.Try to get the max 2 salaries using sub query
SELECT MAX(Salary), (SELECT MAX(Salary) FROM Employee WHERE Salary < (SELECT MAX(Salary)FROM Employee)) FROM Employee


--9.Get the full name of employees that is similar to any dependent name
SELECT CONCAT_WS(' ',E.Fname,E.Lname) AS FULL_NAME 
FROM Employee E FULL OUTER JOIN Dependent D
ON E.SSN = D.ESSN
WHERE CONCAT_WS(' ',E.Fname,E.Lname) in (SELECT Dependent_name FROM Dependent)


--10.Display the employee number and name if at least one of them have dependents (use exists keyword) 
SELECT SSN, Fname
FROM Employee E
WHERE EXISTS (
	SELECT 1
	FROM Dependent D
	WHERE D.ESSN = E.SSN
)
SELECT * FROM Employee

--11.In the department table insert new department called "DEPT IT”, with id 100, employee with SSN = 112233 as a manager for this department. The start date for this manager is '1-11-2006'
INSERT INTO Departments (Dname,Dnum,MGRSSN,[MGRStart Date])
VALUES('DEPT IT',100,112233,'1/11/2006')


--12.Do what is required if you know that : Mrs.Noha Mohamed(SSN=968574)  moved to be the manager of the new department (id = 100), and they give you(your SSN =102672) her position (Dept. 20 manager) 
--a.First try to update her record in the department table
BEGIN TRY
	BEGIN TRANSACTION 
		UPDATE Departments
		SET MGRSSN = 968574, [MGRStart Date] = GETDATE()
		WHERE Dnum = 100
		COMMIT
END TRY
BEGIN CATCH 
	ROLLBACK

	SELECT ERROR_MESSAGE()
END CATCH
--b.Update your record to be department 20 manager.
BEGIN TRY
	BEGIN TRANSACTION 
		UPDATE Departments
		SET MGRSSN = 102672, [MGRStart Date] = GETDATE()
		WHERE Dnum = 20
		COMMIT
END TRY
BEGIN CATCH 
	ROLLBACK
	SELECT ERROR_MESSAGE()
END CATCH
--c.Update the data of employee number=102660 to be in your teamwork (he will be supervised by you) (your SSN =102672)
BEGIN TRY
	BEGIN TRANSACTION
	UPDATE Employee
	SET Superssn = 102660
	WHERE SSN = 102672
	COMMIT
END TRY
BEGIN CATCH
	ROLLBACK
	SELECT ERROR_MESSAGE()
END CATCH


--13.Unfortunately the company ended the contract with Mr. Kamel Mohamed (SSN=223344) so try to delete his data from your database in case you know that you will be temporarily in his position.
BEGIN TRY
	BEGIN TRANSACTION
	UPDATE Employee
	SET Superssn = 102672
	WHERE Superssn = 223344
	UPDATE Departments
	SET MGRSSN = 102672 
	WHERE MGRSSN = 223344
	DELETE Employee
	WHERE SSN = 223344
	COMMIT
END TRY
BEGIN CATCH
	ROLLBACK
	SELECT ERROR_MESSAGE()
END CATCH


--14.Try to update all salaries of employees who work in Project ‘Al Rabwah’ by 30%
BEGIN TRY
	BEGIN TRANSACTION
	UPDATE E
	SET E.Salary = E.Salary*1.3
	FROM Employee E INNER JOIN Works_for W 
	ON E.SSN = W.ESSn
	INNER JOIN Project P
	ON P.Pnumber = W.Pno
	WHERE P.Pname = 'Al Rawdah'
	COMMIT
END TRY
BEGIN CATCH
	ROLLBACK
	SELECT ERROR_MESSAGE()
END CATCH



SELECT * FROM Employee
SELECT * FROM Departments