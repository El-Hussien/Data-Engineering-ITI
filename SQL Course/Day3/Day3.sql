use Company_SD
-- 1.Display the Department id, name and id and the name of its manager.
SELECT D.Dnum, D.Dname, E.SSN, E.Fname
FROM Departments D INNER JOIN Employee E
ON E.SSN = D.MGRSSN


-- 2.Display the name of the departments and the name of the projects under its control.
SELECT Dname, Pname
FROM Departments D Inner JOIN Project P
ON D.Dnum = P.Dnum


-- 3.Display the full data about all the dependence associated with the name of the employee they depend on him/her
SELECT E.Fname, D.* 
FROM Employee E Inner Join Dependent D
ON E.SSN = D.ESSN


--4.Display the Id, name and location of the projects in Cairo or Alex city.
SELECT Pname, Pnumber, Plocation
FROM Project
WHERE City in ('Cairo','Alex')


--5.Display the Projects full data of the projects with a name starts with "a" letter.
SELECT * FROM Project WHERE Pname like 'a%'


-- 6.display all the employees in department 30 whose salary from 1000 to 2000 LE monthly
SELECT * FROM Employee WHERE Dno = 30 AND Salary between 1000 AND 2000


-- 7.Retrieve the names of all employees in department 10 who works more than or equal10 hours per week on "AL Rabwah" project.
SELECT E.* 
FROM Employee E Inner Join Works_for W 
ON E.SSN = W.ESSn 
INNER JOIN Project P
ON W.Pno = P.Pnumber
WHERE E.Dno = 10 AND W.Hours >= 10 AND P.Pname = 'AL Rabwah'


--8.Find the names of the employees who directly supervised with Kamel Mohamed.
SELECT y.Fname 
FROM Employee x, Employee y
WHERE x.SSN = y.Superssn AND x.Fname = 'Kamel' AND x.Lname = 'Mohamed'


--9.Retrieve the names of all employees and the names of the projects they are working on, sorted by the project name
SELECT E.Fname, P.Pname 
FROM Employee E INNER JOIN Works_for W 
ON E.SSN = W.ESSn 
INNER JOIN Project P
ON W.Pno = P.Pnumber
ORDER BY P.Pname 


--10.For each project located in Cairo City , find the project number, the controlling department name ,the department manager last name ,address and birthdate.
SELECT P.Pnumber, D.Dname, E.Lname, E.Address, E.Bdate
FROM Employee E INNER JOIN Departments D
ON E.SSN = D.MGRSSN
INNER JOIN Project P
ON D.Dnum = P.Dnum
WHERE P.City = 'Cairo'


--11.Display All Data of the managers
SELECT E.*
FROM Departments D INNER JOIN Employee E
ON D.MGRSSN = E.SSN 


--12.Display All Employees data and the data of their dependents even if they have no dependents
SELECT * 
FROM Employee E LEFT OUTER JOIN Dependent D
ON E.SSN = D.ESSN


--13.Insert your personal data to the employee table as a new employee in department number 30, SSN = 102672, Superssn = 112233, salary=3000.
INSERT INTO Employee
VALUES('Hussien','Ahmed',102672,1/4/2003,'51 faisal city alex','M',3000,112233,30)


--14.Insert another employee with personal data your friend as new employee in department number 30, SSN = 102660, but don’t enter any value for salary or supervisor number to him.
INSERT INTO Employee (SSN,Dno,Fname,Lname)
VALUES(102660,30,'Ali','saad')


--15.Upgrade your salary by 20 % of its last value.
UPDATE Employee
SET Salary = Salary + (Salary * 0.2)
WHERE SSN = 102672

