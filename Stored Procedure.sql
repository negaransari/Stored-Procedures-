
--DROP PROCEDURE Order_performance
--Create Store Procedure For total orders and total Revenue for each order ID
CREATE PROCEDURE Order_performance
    @start_date DATE,
    @end_date DATE
AS
BEGIN
    SELECT O.order_id, COUNT(O.order_id) AS Total_orders, 
           SUM(S.list_price * S.quantity) AS Total_revenue
    FROM sales.orders AS O
    INNER JOIN sales.order_items AS S ON O.order_id = S.order_id
    WHERE O.order_date BETWEEN @start_date AND @end_date
    GROUP BY O.order_id;
END;


EXEC Order_performance @start_date = '2016-01-01', @end_date = '2017-12-31';

--TOP FIVE CUSTOMER BASED ON TOTAL REVENUE
--DROP PROCEDURE Top_Five_Customer
CREATE PROCEDURE Top_Five_Customer
    @start_date DATE,
    @end_date DATE
AS
BEGIN
    SELECT TOP 5
        C.customer_id,
        CONCAT(C.first_name, ' ', C.last_name) AS Full_name,
        COUNT(O.order_id) AS Total_orders, 
        SUM(O.list_price * O.quantity) AS Total_revenue
    FROM [sales].[customers] AS C
    INNER JOIN [sales].[orders] AS S ON C.customer_id = S.customer_id
    INNER JOIN [sales].[order_items] AS O ON O.order_id = S.order_id
    WHERE S.order_date BETWEEN @start_date AND @end_date
    GROUP BY C.customer_id, CONCAT(C.first_name, ' ', C.last_name)
    ORDER BY Total_revenue DESC;
END;
EXEC Top_Five_Customer @start_date = '2017-01-01', @end_date = '2018-12-31';


--TOTAL DISCUNT OF EACH STAFF
--DROP PROCEDURE Total_Discunt_for_staff

CREATE PROCEDURE Total_Discount_for_staff
    @start_date DATE,
    @end_date DATE
AS
BEGIN
    SELECT
        F.staff_id,
        CONCAT(F.first_name, ' ', F.last_name) AS Full_name,
        COUNT(O.order_id) AS Total_orders,
        SUM(S.discount) AS All_discount
    FROM [sales].[staffs] AS F
    INNER JOIN [sales].[orders] AS O ON F.staff_id = O.staff_id 
    INNER JOIN [sales].[order_items] AS S ON O.order_id = S.order_id
    WHERE O.order_date BETWEEN @start_date AND @end_date
    GROUP BY F.staff_id, CONCAT(F.first_name, ' ', F.last_name)
    ORDER BY All_discount DESC;
END;
EXEC Total_Discount_for_staff @start_date = '2017-01-01', @end_date = '2018-12-31';

