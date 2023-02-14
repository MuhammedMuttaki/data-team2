-- Exploratory analysis
-- Week-1: Find out countries of customers, and categories sold to each one.
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

-- Week-2: Yearly sales amounts for years 2016, 2017, and 2018; categorized as high, mid, and low, by country.

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


-- Week-3: Listing the top 3 selling products

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


-- Week-4:
--Task-1: Generate a report for the number of territories each employee responsible for

SELECT e.FirstName || ' ' || e.LastName AS Employee, 
COUNT(DISTINCT TerritoryID) AS Territory_Count
FROM EmployeeTerritories as et

INNER JOIN Employees as e 
USING(EmployeeID)
GROUP BY et.EmployeeID 
ORDER BY 2 DESC;

--Task-2: Generate a report for employee's performance according to sales amount and order them decreasely

SELECT firstname || ' ' || lastname as Employee,
ROUND(SUM((od.unitprice - (od.unitprice * od.discount)) * od.quantity), 2) AS Sale_Amount 
from Employees

JOIN Orders on Orders.EmployeeID = Employees.EmployeeID
JOIN 'Order Details' as od on od.orderid = Orders.OrderID

GROUP by firstname
order by Sale_Amount DESC

--Task-3: for low-sales regions what is the shipped category there?
--Part-1 finding the low sale regions:
SELECT shipcountry AS Country,
ROUND(SUM((od.unitprice-(od.unitprice*od.discount))*od.quantity), 2) AS Sale_Amount,
ntile(3) over (order by ROUND(SUM((od.unitprice-(od.unitprice*od.discount))*od.quantity), 2)) Sale_Range
FROM Orders

JOIN 'Order Details' AS od ON od.orderid = Orders.orderid
GROUP by Country

--Part-2: Task-3:
SELECT shipcountry AS Country,
ROUND(SUM((od.unitprice-(od.unitprice*od.discount))*od.quantity), 2) AS Sale_Amount,
GROUP_CONCAT(DISTINCT Categories.CategoryName) AS Category
From Orders

JOIN Categories on Categories.CategoryID = Products.CategoryID
JOIN 'Order Details' as od ON od.orderid = Orders.orderid
Join Products ON Products.ProductID = od.productid

GROUP BY Country
HAVING Sale_Amount < 20000
order by Sale_Amount ASC

