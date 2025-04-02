# Blinkit Data Analytics Project

## Tables of Contents: 
- [Project Overview](#project-overview)  
- [Tools Used](#tools-used)  
- [Data Sources](#data-sources)  
- [Data Cleaning/Preparation](#data-cleaningpreparation)  
- [Key Business Questions Answered](#key-business-questions-answered)  
- [Project Files](#project-files)  
- [How to Use](#how-to-use)  
- [Insights & Findings](#insights--findings)  
- [Recommendations](#recommendations)  
- [Conclusion](#conclusion)
  
### Project Overview
The Blinkit Data Analytics Project focuses on analyzing order patterns, delivery efficiency, customer preferences, and sales trends to optimize operations. The project aims to derive insights that improve service speed, inventory management, and customer satisfaction.

### Tools Used
- MySQL

### Data Sources
The "BlinkIT Grocery Data.csv file" contains data related to online grocery orders, including product details, order timestamps, customer demographics, delivery times, and transaction values. This dataset helps analyze sales trends, customer behavior, and operational efficiency.

### Data Cleaning/Preparation
- In the initial data preparation phase, we performed the following tasks:

1. Imported data into the MySQL database and conducted an inspection.
2. checked for duplicate, none found
3. checked for null and blank values, none found
4. Standardize data by Correcting spelling errors, typos, and inconsistencies.

### Key Business Questions Answered
- Q1: TOTAL SALES
- Q2: AVERAGE SALES
- Q3: NO OF ITEMS
- Q4: AVG RATING
- Q5: Total Sales by Fat Content
- Q6: Total Sales by Item Type
- Q7: Fat Content by Outlet for Total Sales
- Q8: Total Sales by Outlet Establishment
- Q9: Percentage of Sales by Outlet Size
- Q10: Sales by Outlet Location
- Q11: All Metrics by Outlet Type
 

### Project Files
- 📊 "BlinkIT Grocery Data" (CSV File) - Contains all data.
- 📝 Problem Statement (Word File) - Outlines the business questions and objectives.

 ### How to Use
1. Review the Problem Statement Word file  to understand the key objectives.
2. Use the Readme file to get answers

### Insights & Findings

-- Q1: TOTAL SALES:?
````sql
select ROUND(SUM(Total_Sales),2) AS sum_of_sales
from `blinkit_sales_staging`
````
**Results:**

TOTAL SALES|
---------------------|
1.2 Million   |

  
-- Q2: AVERAGE SALES?

````sql
select ROUND(avg(Total_Sales),2) AS avg_of_sales
from `blinkit_sales_staging`
````
**Results:**
AVERAGE SALES|
---------------------|
140.99     |

  
-- Q3: NO OF ITEMS?
````sql
-select COUNT(*) AS count_of_items
from `blinkit_sales_staging`
````
**Results:**
NO OF ITEMS|
---------------------|
8523     |

--  Q4: AVG RATING?
````sql
select ROUND(AVG(Rating),2) AS average_rating
from `blinkit_sales_staging`
````
**Results:**
AVG RATING|
---------------------|
3.97    |
 
--  Q5: Total Sales by Fat Content?
````sql
select Item_Fat_Content,ROUND(SUM(Total_Sales),2) AS sales_by_fat
from `blinkit_sales_staging`
group by Item_Fat_Content
order by sales_by_fat desc
````
**Results:**
| Item Fat Content | Sales by Fat |
|------------------|-------------|
| Low Fat         | 776,319.68   |
| Regular        | 425,361.80   |
  
-- Q6: Total Sales by Item Type?
````sql
select Item_Type,ROUND(SUM(Total_Sales),2) AS sales_by_item_type
from `blinkit_sales_staging`
group by Item_Type
order by sales_by_item_type desc
````
**Results:**
| Item Type            | Sales by Item Type |
|----------------------|-------------------|
| Fruits and Vegetables | 178,124.08       |
| Snack Foods          | 175,433.92       |
| Household           | 135,976.53       |
| Frozen Foods        | 118,558.88       |
| Dairy               | 101,276.46       |
| Canned              | 90,706.73        |
| Baking Goods        | 81,894.74        |
| Health and Hygiene  | 68,025.84        |
| Meat                | 59,449.86        |
| Soft Drinks         | 58,514.16        |
| Breads              | 35,379.12        |
| Hard Drinks         | 29,334.68        |
| Others              | 22,451.89        |
| Starchy Foods       | 21,880.03        |
| Breakfast           | 15,596.70        |
| Seafood            | 9,077.87         |
  
-- Q7: Fat Content by Outlet for Total Sales?
````sql
select Outlet_Location_Type, Item_Fat_Content, ROUND(SUM(Total_Sales),2) AS sales_by_Outlet_Location_Type
from `blinkit_sales_staging`
group by Outlet_Location_Type,Item_Fat_Content
order by Outlet_Location_Type asc
````
**Results:**
  
| Outlet Location Type | Item Fat Content | Sales by Outlet Location Type |
|----------------------|------------------|------------------------------|
| Tier 1              | Low Fat          | 215,047.91                  |
| Tier 1              | Regular          | 121,349.90                  |
| Tier 2              | Low Fat          | 254,464.77                  |
| Tier 2              | Regular          | 138,685.87                  |
| Tier 3              | Low Fat          | 306,806.99                  |
| Tier 3              | Regular          | 165,326.03                  |

-- Q8: Total Sales by Outlet Establishment Year?
````sql
select Outlet_Establishment_Year, ROUND(SUM(Total_Sales),2) AS sales_by_Outlet_Establishment_Year
from `blinkit_sales_staging`
group by Outlet_Establishment_Year
order by Outlet_Establishment_Year asc
````
**Results:**

| Outlet Establishment Year | Sales by Outlet Establishment Year |
|--------------------------|-----------------------------------|
| 1998                     | 204,522.26                       |
| 2000                     | 131,809.02                       |
| 2010                     | 132,113.37                       |
| 2011                     | 78,131.56                        |
| 2012                     | 130,476.86                       |
| 2015                     | 130,942.78                       |
| 2017                     | 133,103.91                       |
| 2020                     | 129,103.96                       |
| 2022                     | 131,477.77                       |
 
-- Q9: Percentage of Sales by Outlet Size?
````sql
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
````
**Results:**
| Outlet Size | Sales by Outlet Size | Percentage Sales by Outlet Size |
|-------------|----------------------|---------------------------------|
| Medium      | 507,895.73           | 42.27                           |
| Small       | 444,794.17           | 37.01                           |
| High        | 248,991.58           | 20.72                           |
  
-- Q10: Sales by Outlet Location?
````sql
select Outlet_Location_Type, ROUND(SUM(Total_Sales),2) AS sales_by_Outlet_Location_Type 
from  blinkit_sales_staging
group by Outlet_Location_Type
order by sales_by_Outlet_Location_Type desc
````
**Results:**
| Outlet Location Type | Sales by Outlet Location Type |
|----------------------|------------------------------|
| Tier 3               | 472,133.03                   |
| Tier 2               | 393,150.64                   |
| Tier 1               | 336,397.81                   |

-- Q11: All Metrics by Outlet Type?
````sql
select Outlet_Type, 
		ROUND(SUM(Total_Sales),2) AS total_sales_by_Outlet_Location_Type ,
        ROUND(COUNT(Total_Sales),2) AS count_sales_by_Outlet_Location_Type ,
        ROUND(AVG(Total_Sales),2) AS average_sales_by_Outlet_Location_Type,
        ROUND(AVG(Rating),2) AS avg_rating_by_Outlet_Location_Type ,
        ROUND(AVG(Item_Visibility),2) AS avg_item_visibility_by_Outlet_Location_Type
from  blinkit_sales_staging
group by Outlet_Type
order by total_sales_by_Outlet_Location_Type desc

````
**Results:**
| Outlet Type          | Total Sales by Outlet Type | Count of Sales | Average Sales | Average Rating | Average Item Visibility |
|----------------------|--------------------------|---------------|---------------|----------------|--------------------------|
| Supermarket Type1   | 787,549.89               | 5,577         | 141.21        | 3.96           | 0.06                     |
| Grocery Store       | 151,939.15               | 1,083         | 140.29        | 3.99           | 0.10                     |
| Supermarket Type2   | 131,477.77               | 928           | 141.68        | 3.97           | 0.06                     |
| Supermarket Type3   | 130,714.67               | 935           | 139.80        | 3.95           | 0.06                     |
  


### Recommendations
- Increase marketing focus on "Low Fat" items: The total sales for Low Fat items are significantly higher than Regular items. Tailor promotions and marketing strategies around health-conscious consumers.

- Boost product variety in "Fruits and Vegetables" and "Snack Foods": These categories are top performers. Expand the range of products or introduce seasonal promotions to further drive sales.

- Focus on Tier 3 outlets: Sales in Tier 3 locations are the highest. Invest in enhancing these outlets and potentially expand more in these areas.

- Expand customer base in "Small" outlets: Despite smaller sales, Small outlets represent a significant portion of the market. Consider offering tailored products and promotions to attract more customers.

- Review Outlet Establishment Years: For older establishments (1998, 2000), consider renovations or product refreshment strategies to re-engage customers and increase sales.

- Monitor sales in Supermarket Type1: As the highest-performing outlet type, continue to innovate and maintain strong sales strategies for this category.

- Increase visibility of high-rated items: Items with higher ratings (around 3.97) should be highlighted more across all outlets to drive increased consumer trust and sales.

- Leverage "Medium" outlet size: Medium-sized outlets contribute the most sales, suggesting a balanced approach in stock and space allocation in such stores could optimize performance.

### Conclusion
In conclusion, the analysis reveals key areas for growth, with a strong focus on Low Fat items, Tier 3 outlets, and high-performing categories like Fruits and Vegetables. By enhancing product offerings and marketing strategies in these segments, as well as optimizing sales strategies for different outlet sizes and types, Blinkit can drive further growth. Additionally, attention to customer engagement in older outlets and maintaining visibility of highly-rated items will support sustained performance and customer loyalty.

### Author
- Prasannagoud Patil

### Email
- Prasannpatil31@gmail.com
