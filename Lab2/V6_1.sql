--Вывести на экран самую раннюю дату начала работы сотрудника в каждом отделе. Дату вывести для каждого отдела.
SELECT d.Name, MIN(edh.StartDate) as StartDate
FROM HumanResources.Employee e
JOIN HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
JOIN HumanResources.Department d ON edh.DepartmentID = d.DepartmentID
GROUP BY d.Name;

--Вывести на экран название смены сотрудников, работающих на позиции ‘Stocker’. Замените названия смен цифрами (Day — 1; Evening — 2; Night — 3).
SELECT e.BusinessEntityID, e.JobTitle, CASE s.Name
										 WHEN 'Day' THEN 1
										 WHEN 'Evening' THEN 2
										 WHEN 'Night' THEN 3
									   END AS ShiftName
FROM HumanResources.Employee e
JOIN HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
JOIN HumanResources.Shift s ON edh.ShiftID = s.ShiftID
WHERE e.JobTitle = 'Stocker';

--Вывести на экран информацию обо всех сотрудниках, с указанием отдела, в котором они работают в настоящий момент. В названии позиции каждого сотрудника заменить слово ‘and’ знаком & (амперсанд).
SELECT e.BusinessEntityID, REPLACE(e.JobTitle, 'and', '&') AS JobTitle, d.Name
FROM HumanResources.Employee e
JOIN HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
JOIN HumanResources.Department d ON edh.DepartmentID = d.DepartmentID;