select *
from dbo.retail_sales

--*********************************************
-- I. Data Cleaning: Handing null values

SELECT * FROM dbo.retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantiy IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM dbo.retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantiy IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

--*********************************************
 -- II. Data Exploring
  -- # 1. How many sales we have (count all transactionID)
select count(*) as total_sales
from dbo.retail_sales

  -- # 2. How many customers do we have? (count distinct customer_id)
select count(distinct customer_id) 
from dbo.retail_sales  

  -- # 3. How many category do we have?
select distinct category
from dbo.retail_sales 

--*********************************************
 -- III. EDA & Business Key Problems
  -- Q1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:
select * from dbo.retail_sales
where sale_date = '2022-11-05'

  -- Q2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

select *
from dbo.retail_sales
where category = 'Clothing' 
    and quantiy >=4 
    and FORMAT(sale_date, 'yyyy-MM') = '2022-11'

  -- Q3. Write a SQL query to calculate the total sales (total_sale) for each category.
select category,
    sum(total_sale) as net_sales,
    count(*) as total_orders
from dbo.retail_sales
group by category

  -- Q4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category:
SELECT round(avg(age),2) as avg_age
from dbo.retail_sales
where category = 'Beauty'

  -- Q5. Write a SQL query to find all transactions where the total_sale is greater than 1000:
select *
from dbo.retail_sales
where total_sale > 1000

  -- Q6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category:
select category,
    gender,
    count(*) as total_trans
from dbo.retail_sales
group by category, gender
order by category

  -- Q7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
select year, month, avg_sale
from 
(
select format(sale_date, 'yyyy') as year,
    format(sale_date, 'MM') as month,
    avg(total_sale) as avg_sale,
    RANK() over (PARTITION by format(sale_date, 'yyyy') order by avg(total_sale) desc) as rk
from dbo.retail_sales
group by format(sale_date, 'yyyy'), format(sale_date, 'MM')
) as t1
where rk = 1

  -- Q8. Write a SQL query to find the top 5 customers based on the highest total sales:
select top 5 customer_id,
    sum(total_sale) as total
from dbo.retail_sales
group by customer_id
order by total desc

  -- Q9. Write a SQL query to find the number of unique customers who purchased items from each category:
select category,
    count(distinct customer_id) as total_cus
from dbo.retail_sales
group by category

  -- Q10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

WITH shift_table AS 
(
    select *,
        case 
            when DATEPART(HOUR, sale_time) < 12 then 'Morning'
            when DATEPART(HOUR, sale_time) between 12 and 17 then 'Afternoon'
            else 'Evening'
        end as shift
    from dbo.retail_sales
)
select shift,
    count(*) as total_orders
from shift_table 
group by shift
order by shift 




