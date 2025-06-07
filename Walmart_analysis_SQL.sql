SELECT * FROM walmart
	LIMIT 5;

SELECT MIN(quantity) as min, MAX(quantity) as max
FROM walmart;

--count of all rows/transactions in the table
SELECT COUNT(*) FROM walmart;


--Q: Total number of stores per city
SELECT branch, city, 
COUNT (branch) as Total_branches
FROM walmart
GROUP BY branch,city
ORDER BY Total_branches desc;
--Ans: There are branches in 100 cities with Port Arthur having the most branches with 239

--what is the unit_price of invoice_id 9000
SELECT invoice_id, unit_price
FROM walmart
WHERE invoice_id = 9000;

-- Which branch make the most sales
SELECT branch, SUM(total) AS total_sales
FROM walmart
GROUP BY branch
ORDER BY total_sales desc;

--BUSINESS QUESTIONS

--Q.1 Calculate the number of braches per city and the total sales in each city
SELECT city, COUNT(branch)as no_branches, SUM(total) AS total_sales
FROM walmart
GROUP BY city
ORDER BY total_sales desc;

/* Q.2 Identify the highest-rated category in eacH branch, displaying the branch,
category and avg rating*/
SELECT *
FROM (
SELECT branch, 
		category, 
		AVG(rating) AS avg_rating,
		RANK() OVER(PARTITION BY branch ORDER BY AVG(rating) DESC) AS rank
FROM walmart
GROUP BY 1,2)
WHERE rank = 1;

-- Q.3 Identify the busiest day for each branch based on the number of transactions
SELECT *
FROM (SELECT branch,
			TO_CHAR(TO_DATE(date, 'DD/MM/YY'), 'Day') AS day_name,
			COUNT(*) as no_transactions,
			RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rank
	FROM walmart
	GROUP BY 1,2
	ORDER BY 1, 3 DESC)
WHERE rank = 1;

-- Q.4 Calculate the total quantity of items sold per payment method, list the payment method and the quantity
SELECT 
	payment_method, 
	COUNT(*) as no_payments,
	SUM(quantity) as qty_sold
FROM walmart
GROUP BY payment_method;

/* Q.5 Determine the average, minimum, and maximum rating of category
for each city. List the city, average_rating, min_rating, and max_rating.*/

SELECT city,
	category,
	AVG(rating) as avg_rating, 
	MIN(rating) as min_rating,
	MAX(rating) as max_rating
FROM walmart
GROUP BY 1, 2;

/* Q.6 Calculate the total profit for each category by considering 
total_profit as (unit_price * quantity * profit_margin).
List category and total_profit, ordered from highest to lowest profit */
SELECT category,
		SUM(total) as total_revenue,
		SUM(unit_price * quantity * profit_margin) as total_profit
FROM walmart
GROUP BY 1
ORDER BY 2 DESC;

/* Q.7 Determine the most common payment method for each branch,
display branch and preffered payment method*/
SELECT *
FROM (
	SELECT branch,
			payment_method,
			COUNT(*) as total_transactions,
			RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) as rank
	FROM walmart
	GROUP BY 1,2)
WHERE rank = 1;

/* Q.8 Categorize sales into 3 groups MORNING, AFTERNOON, EVENING. Find out
each of the shift and number of invoices.*/
SELECT branch,
	CASE 
		WHEN EXTRACT (HOUR FROM (time::time)) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM (time::time)) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END day_time,
	COUNT(*)
FROM walmart
GROUP BY 1, 2
ORDER BY 1, 3 DESC;

/* Q.9 Identify 5 branches with the highest decrease ratio in revenue,
compare to last year (current year is 2023 and last year 2022)*/
-- Formula = (Last year revenue - Current year revenue)/Last year revenue*100
WITH revenue_2022
AS
(
	SELECT 
		branch, 
		SUM(total) as revenue
	FROM walmart
	WHERE EXTRACT(YEAR FROM TO_DATE(date, 'DD/MM/YY')) = 2022
	GROUP BY 1
),

revenue_2023
AS
(	
	SELECT 
		branch, 
		SUM(total) as revenue
	FROM walmart
	WHERE EXTRACT(YEAR FROM TO_DATE(date, 'DD/MM/YY')) = 2023
	GROUP BY 1
) 

SELECT 
	ls.branch,
	ls.revenue as last_yr_revenue,
	cs.revenue as current_yr_revenue,
	ROUND((ls.revenue-cs.revenue)::numeric/ls.revenue::numeric*100, 2) AS RDR
FROM revenue_2022 as ls
JOIN 
revenue_2023 as cs
ON ls.branch = cs.branch
WHERE ls.revenue > cs.revenue
ORDER BY 4 DESC
LIMIT 5;