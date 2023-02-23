-- Task-1: finding the average shipping date for each category for low sales region and comparing it with the Required date of the order
SELECT categoryname as Category,
shipcountry as Country, 
ROUND( AVG(JULIANDAY(requireddate) - JULIANDAY(orderdate)), 2) as RequiredDuration,
ROUND( AVG(JULIANDAY(shippeddate) - JULIANDAY(orderdate)), 2) AS ActualDuration
from Orders


JOIN 'Order Details' AS od on od.orderid = Orders.OrderID
JOIN Products on Products.productid = od.productid
Join Categories on Categories.CategoryID = Products.CategoryID

WHERE Country IN (
	SELECT ShipCountry AS Country FROM Orders
	JOIN 'Order Details' as od on od.orderid = Orders.OrderID
	GROUP BY Country
	HAVING ROUND(SUM((od.unitprice-(od.unitprice*od.discount))*od.quantity), 2) < 20000 )

GROUP BY Category, Country

-- Task-2: finding the effects of the discount on the low sales region by comparing it with high sales regions discount
-- Table-1: Low sales regions
SELECT shipcountry as Country, 
ROUND(AVG(discount), 2) AS AverageDiscount from Orders
join 'Order Details' as od on od.orderid = Orders.OrderID
WHERE Country IN (
	SELECT ShipCountry AS Country FROM Orders
	JOIN 'Order Details' as od on od.orderid = Orders.OrderID
	GROUP BY Country
	HAVING ROUND(SUM((od.unitprice-(od.unitprice*od.discount))*od.quantity), 2) < 20000 )
GROUP by Country
Order by AverageDiscount DESC

-- Table-2: High sales regions 

SELECT shipcountry as Country, 
ROUND(AVG(discount), 2) AS AverageDiscount from Orders
join 'Order Details' as od on od.orderid = Orders.OrderID
WHERE Country IN (
	SELECT ShipCountry AS Country FROM Orders
	JOIN 'Order Details' as od on od.orderid = Orders.OrderID
	GROUP BY Country
	HAVING ROUND(SUM((od.unitprice-(od.unitprice*od.discount))*od.quantity), 2) > 55000 )
GROUP by Country
Order by AverageDiscount DESC