-- DATA CLEANING
USE sql_blinkit;

-- check table once
select *
from `sql_blinkit`.`blinkit_sales`;
-- Count of Records
select count(*)
from `sql_blinkit`.`blinkit_sales`;


-- first thing we want to do is create a staging table. This is the one we will work in and clean the data.
--  We want a table with the raw data in case something happens
CREATE TABLE blinkit_sales_staging
LIKE blinkit_sales;
-- check Staging table 
select *
from `sql_blinkit`.`blinkit_sales_staging`;
-- Insert DATA into staging table
INSERT `sql_blinkit`.`blinkit_sales_staging` 
SELECT * FROM `sql_blinkit`.`blinkit_sales`;
-- check Staging table once again
select *
from `sql_blinkit`.`blinkit_sales_staging`;
-- Count records in staging table
select count(*)
from `sql_blinkit`.`blinkit_sales_staging`;

-- Good to go to next phase

-- now when we are data cleaning we usually follow a few steps
-- 1. check for duplicates and remove any
-- 2. standardize data and fix errors
-- 3. Look at null values and see what 
-- 4. remove any columns and rows that are not necessary - few ways



-- 1. Remove Duplicates
select *
from `blinkit_sales_staging`;

# First let's check for duplicates
-- Inititla build up
SELECT Item_Fat_Content, Item_Identifier,Item_Type, Outlet_Establishment_Year,Outlet_Identifier,Outlet_Location_Type,Outlet_Size,
    Outlet_Type,Item_Visibility,Item_Weight,Total_Sales,Rating,
		ROW_NUMBER() OVER (
			PARTITION BY Item_Fat_Content, Item_Identifier, Item_Type, Outlet_Establishment_Year,Outlet_Identifier,Outlet_Location_Type,Outlet_Size,
    Outlet_Type,Item_Visibility,Item_Weight,Total_Sales,Rating
			) AS row_num
FROM  `blinkit_sales_staging`;

-- these are our real duplicates
SELECT *
FROM (
	SELECT Item_Fat_Content, Item_Identifier,Item_Type, Outlet_Establishment_Year,Outlet_Identifier,Outlet_Location_Type,Outlet_Size,
    Outlet_Type,Item_Visibility,Item_Weight,Total_Sales,Rating,
		ROW_NUMBER() OVER (
			PARTITION BY Item_Fat_Content, Item_Identifier, Item_Type, Outlet_Establishment_Year,Outlet_Identifier,Outlet_Location_Type,Outlet_Size,
    Outlet_Type,Item_Visibility,Item_Weight,Total_Sales,Rating
			) AS row_num
	FROM  `blinkit_sales_staging`
) duplicates
WHERE 
	row_num > 1;
    
-- No duplicates found so move to 2nd step

-- 2. Standardize Data
-- We have 4 unique values
-- Regular, Low Fat, LF, and reg
-- reg means regular and LF means Low Fat, so make these upadtes into table
select distinct Item_Fat_Content
from `blinkit_sales_staging`

UPDATE `blinkit_sales_staging`
SET Item_Fat_Content = "Low Fat"
WHERE Item_Fat_Content = "LF"

UPDATE `blinkit_sales_staging`
SET Item_Fat_Content = "Regular"
WHERE Item_Fat_Content = "reg"
-- Check whether update has worked or not
select distinct Item_Fat_Content
from `blinkit_sales_staging`

-- These are our cols
-- Item_Fat_Content, Item_Identifier,Item_Type, Outlet_Establishment_Year,Outlet_Identifier,Outlet_Location_Type,Outlet_Size,
 -- Outlet_Type,Item_Visibility,Item_Weight,Total_Sales,Rating
 
 -- KPIs requirements:
 -- PRPOJECT KEY REQUIREMENTS and ANSWERS
 -- Q1: TOTAL SALES:
select ROUND(SUM(Total_Sales),2) AS sum_of_sales
from `blinkit_sales_staging`

 -- Q2: AVERAGE SALES:
select ROUND(avg(Total_Sales),2) AS avg_of_sales
from `blinkit_sales_staging`

 -- Q3: NO OF ITEMS:
select COUNT(*) AS count_of_items
from `blinkit_sales_staging`

 -- Q4: AVG RATING:
select ROUND(AVG(Rating),2) AS average_rating
from `blinkit_sales_staging`


 -- Q5: Total Sales by Fat Content:
select Item_Fat_Content,ROUND(SUM(Total_Sales),2) AS sales_by_fat
from `blinkit_sales_staging`
group by Item_Fat_Content
order by sales_by_fat desc

 -- Q6: Total Sales by Item Type:
select Item_Type,ROUND(SUM(Total_Sales),2) AS sales_by_item_type
from `blinkit_sales_staging`
group by Item_Type
order by sales_by_item_type desc


-- Q7: Fat Content by Outlet for Total Sales:
select Outlet_Location_Type, Item_Fat_Content, ROUND(SUM(Total_Sales),2) AS sales_by_Outlet_Location_Type
from `blinkit_sales_staging`
group by Outlet_Location_Type,Item_Fat_Content
order by Outlet_Location_Type asc

-- Q8: Total Sales by Outlet Establishment year:
select Outlet_Establishment_Year, ROUND(SUM(Total_Sales),2) AS sales_by_Outlet_Establishment_Year
from `blinkit_sales_staging`
group by Outlet_Establishment_Year
order by Outlet_Establishment_Year asc

-- Q9: Percentage of Sales by Outlet Size:
-- 1st way
select Outlet_Size, ROUND(SUM(Total_Sales),2) AS sales_by_Outlet_Size, 
		ROUND((SUM(Total_Sales) / (SELECT SUM(Total_Sales) FROM blinkit_sales_staging))*100,2) AS percenatge_sales_by_Outlet_Size
from  blinkit_sales_staging
group by Outlet_Size
order by percenatge_sales_by_Outlet_Size desc
    
-- 2nd way
WITH cte as (
SELECT Outlet_Size, ROUND(SUM(Total_Sales), 2) AS sales_by_Outlet_Size
FROM blinkit_sales_staging
GROUP BY Outlet_Size
)
select  Outlet_Size,sales_by_Outlet_Size,
		ROUND((SUM(sales_by_Outlet_Size) / (SELECT SUM(sales_by_Outlet_Size) FROM  cte))*100,2) AS percenatge_sales_by_Outlet_Size
from cte
GROUP BY Outlet_Size,sales_by_Outlet_Size

-- Q10: Sales by Outlet Location:
select Outlet_Location_Type, ROUND(SUM(Total_Sales),2) AS sales_by_Outlet_Location_Type 
from  blinkit_sales_staging
group by Outlet_Location_Type
order by sales_by_Outlet_Location_Type desc

-- Q11: All Metrics by Outlet Type:
select Outlet_Type, 
		ROUND(SUM(Total_Sales),2) AS total_sales_by_Outlet_Location_Type ,
        ROUND(COUNT(Total_Sales),2) AS count_sales_by_Outlet_Location_Type ,
        ROUND(AVG(Total_Sales),2) AS average_sales_by_Outlet_Location_Type,
        ROUND(AVG(Rating),2) AS avg_rating_by_Outlet_Location_Type ,
        ROUND(AVG(Item_Visibility),2) AS avg_item_visibility_by_Outlet_Location_Type
from  blinkit_sales_staging
group by Outlet_Type
order by total_sales_by_Outlet_Location_Type desc


-- END of PROJECT