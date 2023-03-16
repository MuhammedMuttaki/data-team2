Task-2:

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