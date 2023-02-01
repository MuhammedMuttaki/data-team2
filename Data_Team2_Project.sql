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

--------------------------------------------------------------------------------------------------------------

-- TASK 3: Listing the top 3 selling products - by M. Muttaqi

SELECT Products.productname AS Product,
ROUND(SUM(( 'Order Details'.unitprice -( 'Order Details'.unitprice *discount))*quantity), 3) AS Sale_Amount
FROM 'Order Details'

JOIN Products ON Products.productid = 'Order Details'.productid
GROUP BY Product
ORDER BY Sale_Amount DESC


-- As a result 'Côte de Blaye', 'Thüringer Rostbratwurst', and 'Raclette Courdavault'  
-- having each a sale amount of 141396.735, 80368.672, and 71155.7 respectively, are the top 3 selling products 

