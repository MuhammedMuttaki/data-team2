-- Exploratory analysis
-- Task 1: Find out countries of customers, and categories sold to each one.
SELECT COUNT(DISTINCT Country)
FROM Customers AS c;

SELECT COUNT(DISTINCT ShipCountry)
FROM Orders AS o;

SELECT c.Country, c2.CategoryName, COUNT(od.OrderID)
FROM Customers AS c
INNER JOIN Orders AS o
USING (CustomerID)
INNER JOIN "Order Details" AS od
USING (OrderID)
INNER JOIN Products AS p 
USING (ProductID)
INNER JOIN Categories AS c2
USING (CategoryID)
GROUP BY 1, 2;

SELECT o.ShipCountry AS Countries, GROUP_CONCAT(DISTINCT c2.CategoryName) AS Categories
FROM Orders AS o
INNER JOIN "Order Details" AS od
USING (OrderID)
INNER JOIN Products AS p 
USING (ProductID)
INNER JOIN Categories AS c2
USING (CategoryID)
GROUP BY 1;

--------------------------------------------------------------------------------------------------------------

-- Task 2: Yearly sales amounts for years 2016, 2017, and 2018; categorized as high, mid, and low, by country.

SELECT o.ShipCountry, 
	   CASE WHEN SUM((od.UnitPrice - (od.UnitPrice * od.Discount)) * od.Quantity) < 7000 THEN "Low"
			WHEN SUM((od.UnitPrice - (od.UnitPrice * od.Discount)) * od.Quantity) < 18000 THEN "Mid"
			ELSE "High" END AS sales_amount
FROM "Order Details" as od
INNER JOIN Orders as o
USING(OrderID)
WHERE o.OrderDate BETWEEN '2016-01-01' AND '2016-12-31'
GROUP BY 1
ORDER BY SUM((od.UnitPrice - (od.UnitPrice * od.Discount)) * od.Quantity) DESC;

SELECT o.ShipCountry, 
	   CASE WHEN SUM((od.UnitPrice - (od.UnitPrice * od.Discount)) * od.Quantity) < 7000 THEN "Low"
			WHEN SUM((od.UnitPrice - (od.UnitPrice * od.Discount)) * od.Quantity) < 18000 THEN "Mid"
			ELSE "High" END AS sales_amount
FROM "Order Details" as od
INNER JOIN Orders as o
USING(OrderID)
WHERE o.OrderDate BETWEEN '2017-01-01' AND '2017-12-31'
GROUP BY 1
ORDER BY SUM((od.UnitPrice - (od.UnitPrice * od.Discount)) * od.Quantity) DESC;

SELECT o.ShipCountry, 
	   CASE WHEN SUM((od.UnitPrice - (od.UnitPrice * od.Discount)) * od.Quantity) < 7000 THEN "Low"
			WHEN SUM((od.UnitPrice - (od.UnitPrice * od.Discount)) * od.Quantity) < 18000 THEN "Mid"
			ELSE "High" END AS sales_amount
FROM "Order Details" as od
INNER JOIN Orders as o
USING(OrderID)
WHERE o.OrderDate BETWEEN '2018-01-01' AND '2018-12-31'
GROUP BY 1
ORDER BY SUM((od.UnitPrice - (od.UnitPrice * od.Discount)) * od.Quantity) DESC;


-- TASK 3: Listing the top 3 selling products

SELECT p.productname AS Product,
ROUND(SUM((od.unitprice - (od.unitprice * od.discount)) * od.quantity), 2) AS Sale_Amount
FROM 'Order Details' AS od
INNER JOIN Products AS p
ON p.productid = od.productid
GROUP BY Product
ORDER BY Sale_Amount DESC
LIMIT 3;

-- As a result 'Côte de Blaye', 'Thüringer Rostbratwurst', and 'Raclette Courdavault'  
-- having each a sale amount of 141396.74, 80368.672, and 71155.7 respectively, are the top 3 selling products 

-- Task 4:

-- 1- generate a report for the number of territories each employee responsible for

SELECT et.EmployeeID, e.FirstName || ' ' || e.LastName AS name, e.Title,  COUNT(DISTINCT TerritoryID) AS territory_count
FROM EmployeeTerritories as et
INNER JOIN Employees as e 
USING(EmployeeID)
GROUP BY et.EmployeeID 
ORDER BY 4 DESC;

--2- generate a report for employee's performance according to sales amount and order them decreasely

SELECT e.EmployeeID, e.FirstName || ' ' || e.LastName AS name, e.Title, ROUND(SUM((od.UnitPrice - (od.UnitPrice * od.Discount)) * od.Quantity), 2) AS Sales 
FROM Employees as e
INNER JOIN Orders as o
USING(EmployeeID)
INNER JOIN "Order Details" as od
USING(OrderID)
GROUP BY 1
ORDER BY 4 DESC;

-- 3- for low-sales regions what is the shipped category there?
	-- For individual years
SELECT o.ShipCountry, GROUP_CONCAT(DISTINCT c.CategoryName)
FROM Orders as o 
INNER JOIN "Order Details" as od 
USING(OrderID)
INNER JOIN Products as p 
USING(ProductID)
INNER JOIN Categories as c 
USING(CategoryID)
WHERE o.OrderDate BETWEEN '2016-01-01' AND '2016-12-31'
GROUP BY 1
HAVING SUM((od.UnitPrice - (od.UnitPrice * od.Discount)) * od.Quantity) < 7000
ORDER BY 1;

SELECT o.ShipCountry, GROUP_CONCAT(DISTINCT c.CategoryName)
FROM Orders as o 
INNER JOIN "Order Details" as od 
USING(OrderID)
INNER JOIN Products as p 
USING(ProductID)
INNER JOIN Categories as c 
USING(CategoryID)
WHERE o.OrderDate BETWEEN '2017-01-01' AND '2017-12-31'
GROUP BY 1
HAVING SUM((od.UnitPrice - (od.UnitPrice * od.Discount)) * od.Quantity) < 7000
ORDER BY 1;

SELECT o.ShipCountry, GROUP_CONCAT(DISTINCT c.CategoryName)
FROM Orders as o 
INNER JOIN "Order Details" as od 
USING(OrderID)
INNER JOIN Products as p 
USING(ProductID)
INNER JOIN Categories as c 
USING(CategoryID)
WHERE o.OrderDate BETWEEN '2018-01-01' AND '2018-12-31'
GROUP BY 1
HAVING SUM((od.UnitPrice - (od.UnitPrice * od.Discount)) * od.Quantity) < 7000
ORDER BY 1;

	-- For all years combined:
SELECT o.ShipCountry, GROUP_CONCAT(DISTINCT c.CategoryName)
FROM Orders as o 
INNER JOIN "Order Details" as od 
USING(OrderID)
INNER JOIN Products as p 
USING(ProductID)
INNER JOIN Categories as c 
USING(CategoryID)
GROUP BY 1
HAVING SUM((od.UnitPrice - (od.UnitPrice * od.Discount)) * od.Quantity) < 21000
ORDER BY 1;