-- Вывести на экран список отделов, названия которых начинаются на букву ‘F’ и заканчиваются на букву ‘е’.
SELECT DepartmentID, Name 
FROM HumanResources.Department 
WHERE Name LIKE 'F%e';

-- Вывести на экран среднее количество часов отпуска и среднее количество больничных часов у сотрудников. Назовите столбцы с результатами ‘AvgVacationHours’ и ‘AvgSickLeaveHours’ для отпусков и больничных соответственно.
SELECT AVG(VacationHours)AS 'AvgVacationHours', AVG(SickLeaveHours) AS 'AvgSickLeaveHours'  
FROM HumanResources.Employee; 


--Вывести на экран сотрудников, которым больше 65-ти лет на настоящий момент. Вывести также количество лет, прошедших с момента трудоустройства, в столбце с именем ‘YearsWorked’.
SELECT BusinessEntityID, JobTitle, Gender, DATEDIFF(year, HireDate, GETDATE()) AS YearsWorked
FROM HumanResources.Employee
WHERE DATEDIFF(year, BirthDate, GETDATE()) > 65; 