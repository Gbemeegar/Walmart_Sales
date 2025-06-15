# Walmart Data Analysis: End-to-End SQL + Python Project

## Project Overview

![Project Pipeline](https://github.com/Gbemeegar/Walmart_Sales/blob/main/Walmart_Project_picture.png)


This project is an end-to-end data analysis solution designed to extract critical business insights from Walmart sales data. We utilize Python for data processing and analysis, SQL for advanced querying, and structured problem-solving techniques to solve key business questions. This project demonstrates my skill in data manipulation, SQL querying, and data pipeline creation.

---

## Project Steps

### 1. Set Up the Environment
   - **Tools Used**: Visual Studio Code (VS Code), Python and SQL (PostgreSQL)
   - **Goal**: I created a structured workspace within VS Code and organized project folders for smooth development and data handling.

### 2. Set Up Kaggle API
   - **API Setup**: Obtained Kaggle API token from [Kaggle](https://www.kaggle.com/) 
   - **Configure Kaggle**: Pulled dataset directly into VS Code directly from kaggle.

### 3. Download Walmart Sales Data
   - **Data Source**: The Walmart sales dataset can be found on Kaggle.
   - **Dataset Link**: [Walmart Sales Dataset](https://www.kaggle.com/najir0123/walmart-10k-sales-datasets)

### 4. Install Required Libraries and Load Data
   - **Libraries**: Install necessary Python libraries using:
     ```bash
     pip install pandas numpy sqlalchemy mysql-connector-python psycopg2
     ```
   - **Loading Data**: Read the data into a Pandas DataFrame for initial analysis and transformations.

### 5. Explore the Data
   - **Goal**: Conducted an initial data exploration to understand data distribution, checked column names, types, and identify potential issues.
   - **Analysis**: Used functions like `.info()`, `.describe()`, and `.head()` to get a quick overview of the data structure and statistics.

### 6. Data Cleaning
   - **Removed Duplicates**: Identified and removed duplicate entries to avoid skewed results.
   - **Handle Missing Values**: Dropped rows or columns with missing values when they are insignificant.
   - **Fix Data Types**: Ensure all columns have consistent data types (e.g., dates as `datetime`, prices as `float`).
   - **Currency Formatting**: Used `.replace()` to handle and format currency values for analysis.
   - **Validation**: Check for any remaining inconsistencies and verify the cleaned data.

### 7. Feature Engineering
   - **Create New Columns**: Calculated the `Total Amount` for each transaction by multiplying `unit_price` by `quantity` and adding this as a new column.
   - **Enhance Dataset**: Adding this calculated field will streamline further SQL analysis and aggregation tasks.

### 8. Load Data into PostgreSQL
   - **Set Up Connections**: Connected to PostgreSQL using `sqlalchemy` and `psycopg2` to load the cleaned data into a database.
   - **Table Creation**: I set up tables in PostgreSQL using Python SQLAlchemy to automate table creation and data insertion.
   - **Verification**: I ran initial SQL queries to confirm that the data has been loaded accurately.

### 9. SQL Analysis: Complex Queries and Business Problem Solving
   - **Business Problem-Solving**: Wrote and executed complex SQL queries to answer critical business questions, such as:
     - Revenue trends across branches and categories.
     - Identifying best-selling product categories.
     - Identifying the most profitable product categories.

	'''sql
	SELECT category,
			SUM(total) as total_revenue,
			SUM(unit_price * quantity * profit_margin) as total_profit
	FROM walmart
	GROUP BY 1
	ORDER BY 2 DESC;
 '''
     - Sales performance by time, city, and payment method.
     - Analyzing peak sales periods and customer buying patterns.

    '''sql
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
 	'''
  -  Profit margin analysis by branch and category.
  -  Calculated and compared revenue decrease ratio in branches 

    '''sql
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
	'''
 All queries can be found in the SQL query script attached in this project file (Walmart_analysis_SQL)
 
   - **Documentation**: Kept clear notes of each query's objective, approach, and results.

### 10. Project Publishing and Documentation
   - **Documentation**: Maintained well-structured documentation of the entire process in Markdown.
   - **Project Files**: Published the completed project on GitHub, including:
     - The `README.md` file (this document).
     - Jupyter Notebook ([Main Python script for data loading, cleaning, and processing](https://github.com/Gbemeegar/Walmart_Sales/blob/main/Walmart_data_cleaning.ipynb))
     - SQL query scripts ([Walmart_analysis_SQL.sql](https://github.com/Gbemeegar/Walmart_Sales/blob/main/Walmart_analysis_SQL.sql))
     - Data files ([Walmart raw data](https://github.com/Gbemeegar/Walmart_Sales/blob/main/Walmart.csv) and
       [Walmart cleaned data](https://github.com/Gbemeegar/Walmart_Sales/blob/main/Walmart_cleaned.csv)


---

## Requirements

- **Python 3.8+**
- **SQL Databases**: PostgreSQL
- **Python Libraries**:
  - `pandas`, `numpy`, `sqlalchemy`, `mysql-connector-python`, `psycopg2`
- **Kaggle API Key** (for data downloading)


## Project Structure

```plaintext
|-- data/                     # Raw data and transformed data
|-- sql_queries/              # SQL scripts for analysis and queries
|-- notebooks/                # Jupyter notebooks for Python analysis
|-- README.md                 # Project documentation
|-- requirements.txt          # List of required Python libraries
|-- main.py                   # Main script for loading, cleaning, and processing data
```
---

## Results and Insights

This section will include your analysis findings:
- **Sales Insights**: Key categories, branches with highest sales, and preferred payment methods.
- **Profitability**: Insights into the most profitable product categories and locations.
- **Customer Behavior**: Trends in ratings, payment preferences, and peak shopping hours.

## Future Enhancements

Possible extensions to this project:
- Integration with a dashboard tool (e.g., Power BI or Tableau) for interactive visualization.
- Additional data sources to enhance analysis depth.
- Automation of the data pipeline for real-time data ingestion and analysis.

---

## Acknowledgments

- **Data Source**: Kaggle’s Walmart Sales Dataset
- **Inspiration**: Walmart’s business case studies on sales and supply chain optimization.

---
