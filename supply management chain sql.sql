use mahendra;
select * from `=calendar`;
select * from calendar;
select * from customer;
select * from d_geojson_us_counties;
select * from d_store;
select * from f_inventory_adjusted;
select * from f_sales;
select * from f_point_of_sale;



create table f_point_of_Sale
(Order_number int,
Product_key int,
Sale_quantity int,
Sales_amount int,
Cost_amount int
);

LOAD DATA INFILE'C:\ProgramData\F_point_of_sale.csv'
INTO TABLE f_point_of_sale
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/f_point_of_sale.csv'
INTO TABLE F_point_of_sale
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;









show variables like'secure_file_priv';
select @@secure_file_priv;


#Total Inventory

select  sum(`Quantity on Hand`) AS Total_Inventory
from  f_inventory_adjusted;

#Inventory Value

select round(sum(`quantity on hand` * `cost amount`),2) as Inventory_Value from f_inventory_adjusted;

#Inventory Health

select `quantity on hand` from f_inventory_adjusted;
select 
case
    when `quantity on hand` < 0 then "Out of Stock"
    when `quantity on hand` < 2 then "Under Stock"
    when `quantity on hand` >= 2 then "Instock"
end as Inventory_Health,
count(*) as Total_Value
 from f_inventory_adjusted
 group by inventory_health;
 
 #Region wise customer
 
 select `cust region` ,count(*) as total_customer from customer
 group by `cust region`;
 
 -- region wise sales
 
 
SELECT
    c.`cust region`,
    c.total_customer,
    s.total_sales
FROM
    (
        SELECT
            `cust region`,
            COUNT(*) AS total_customer
        FROM customer
        GROUP BY `cust region`
    ) c
CROSS JOIN
    (
        SELECT
            SUM(`Sales_amount`) AS total_sales
        FROM f_point_of_sale
    ) s;



 #Store wise total rent
 
 select * from D_store;
 
 SELECT 
  `store name`,
  ANY_VALUE(`store address`) AS `store address`,
  ANY_VALUE(`store city`) AS `store city`,
  ANY_VALUE(`store state`) AS `store state`,
  MAX(`monthly rent cost`) AS Highest_Monthly_Rent
FROM D_Store
GROUP BY `store name`
ORDER BY Highest_Monthly_Rent DESC
LIMIT 5;


#Total_Sales

SELECT 
    SUM(Sales_amount) AS total_sales_amount
FROM f_point_of_sale;



SELECT 
  `store name`,
  ANY_VALUE(`store address`) AS `store address`,
  ANY_VALUE(`store city`) AS `store city`,
  ANY_VALUE(`store state`) AS `store state`,
  MAX(`monthly rent cost`) AS Highest_Monthly_Rent
FROM D_Store
GROUP BY `store name`
ORDER BY Highest_Monthly_Rent DESC
LIMIT 5;




/*
SELECT 
    product_name,
    SUM(sales_amount) AS total_sales
FROM f_sales
GROUP BY product_name
ORDER BY total_sales DESC;

SELECT 
    state_name,
    SUM(sales_amount) AS total_sales
FROM f_sales
GROUP BY state_name
ORDER BY total_sales DESC; */

SELECT
    `Product Key`,
    `Product Name`,
    `Price`
FROM f_inventory_adjusted
ORDER BY `Price` DESC;




-- product wise sales

SELECT
    ia.`Product Key`,
    ia.`Product Name`,
    ia.`Price`,
    SUM(ps.`Sales_amount`) AS total_sales_amount
FROM f_inventory_adjusted ia
LEFT JOIN f_point_of_sale ps
    ON ia.`Product Key` = ps.`Product_key`
GROUP BY
    ia.`Product Key`,
    ia.`Product Name`,
    ia.`Price`
ORDER BY ia.`Price` DESC;

SELECT
    ds.`Store Name`,
    SUM(ps.`Sales_amount`) AS total_sales_amount
FROM f_point_of_sale ps
JOIN d_store ds
    ON ps.`Store_key` = ds.`Store_key`
GROUP BY ds.`Store Name`
ORDER BY total_sales_amount DESC
LIMIT 5;


-- State Wise Sales:

SELECT
    c.`cust state`,
    c.total_customer,
    s.total_sales
FROM
    (
        SELECT
            `cust state`,
            COUNT(*) AS total_customer
        FROM customer
        GROUP BY `cust state`
    ) c
CROSS JOIN
    (
        SELECT
            SUM(`Sales_amount`) AS total_sales
        FROM f_point_of_sale
    ) s;

-- Purchase Method Wise Sales:   

SELECT
    fs.`Purchase Method`,
    SUM(pos.`Sale_quantity`) AS total_quantity,
    SUM(pos.`Sales_amount`) AS total_sales
FROM f_sales fs
JOIN f_point_of_sale pos
    ON fs.`Order Number` = pos.`Order_number`
GROUP BY fs.`Purchase Method`
ORDER BY total_sales DESC;


DESC f_sales;
desc f_point_of_sale;


