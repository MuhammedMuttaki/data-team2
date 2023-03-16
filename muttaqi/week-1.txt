SELECT Orders.shipcountry as Country,
GROUP_CONCAT( DISTINCT Categories.categoryname) AS Categories,
count (DISTINCT Categories.CategoryName) as number_of_categories from Orders

JOIN 'Order Details' on 'Order Details'.orderid = Orders.OrderID
JOIN Products ON Products.productid = 'Order Details'.productid
JOIN Categories on Categories.CategoryID = Products.CategoryID

GROUP by Orders.shipcountry
