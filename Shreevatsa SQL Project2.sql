/*Task 1- Understanding the Data

-------------------1. Describe the data in hand in your own words.--------------

This database contains Sales details of transaction of a superstore. 
The database has 5 tables. They are:
A. cust_dimen (containing details about customer and their respective locations)
	    

B. prod_dimen (containing product category and their subcategories)
		
        
C. orders_dimen (with order no, date, and priority)
		
        
D. shipping_dimen (with ship date, order and shipping mode)
		
        
E. market_fact (orderwise customerwise marketwise orderquantity, sales value, discount profit and shipping cost details).
		
        
----------------------2. Identify and list the Primary Keys and Foreign Keys for this dataset provided to ----------------------
you(In case you don’t find either primary or foreign key, then specially mention 
this in your answer)


	A. cust_dimen
		Primary Key: Cust_id
        Foreign Key: NA
        
	B. prod_dimen
		Primary Key: Prod_id, Product_Sub_Category
        Foreign Key: NA
	
    C. orders_dimen
		Primary Key: Ord_id
        Foreign Key: NA
        
	D. shipping_dimen
		Primary Key: Ship_id
        Foreign Key: NA
        
    E. market_fact
		Primary Key: NA
        Foreign Key: Ord_id, Prod_id, Ship_id, Cust_id
	
*/

/* #Task 2:- Basic & Advanced Analysis */

-----#1. Write a query to display the Customer_Name and Customer Segment using alias name “Customer Name", "Customer Segment" from table Cust_dimen. -----
   
   select Customer_Name as 'Customer Name', Customer_Segment as 'Customer Segment' from superstore.cust_dimen;
	
-----#2. Write a query to find all the details of the customer from the table cust_dimen order by desc.-----

select * from superstore.cust_dimen order by Customer_Name desc;

------#3. Write a query to get the Order ID, Order date from table orders_dimen where ‘Order Priority’ is high.------

select Ord_id as 'Order ID', Order_Date as 'Order Date', Order_Priority from superstore.orders_dimen where Order_Priority like 'HIGH';

-----#4. Find the total and the average sales (display total_sales and avg_sales)-----

select round(sum(Sales),2) as 'Total Sales', round(avg(Sales),2) as 'Average Sales'  from superstore.market_fact;

------#5. Write a query to get the maximum and minimum sales from maket_fact table.------

select max(Sales) as 'Maximum Sales', min(Sales) as 'Minimum Sales' from superstore.market_fact;

-----#6. Display the number of customers in each region in decreasing order of no_of_customers. The result should contain columns Region, no_of_customers.------
select Region, count(*) as 'No_of_customers' from superstore.cust_dimen group by Region order by No_of_customers  desc;

-----#7. Find the region having maximum customers (display the region name and max(no_of_customers)-----
select Region, count(*) as 'No_of_customers' from superstore.cust_dimen group by Region order by No_of_customers  desc limit 1;

-----#8. Find all the customers from Atlantic region who have ever purchased ‘TABLES’ and the number of tables purchased (display the customer name, no_of_tables purchased)-----

select Customer_Name, count(*) as 'No_of_tables' from superstore.cust_dimen c, superstore.market_fact m, superstore.prod_dimen p where c.Cust_id=m.Cust_id and m.Prod_id=p.Prod_id and Region like 'ATLANTIC' and Product_Sub_Category like 'TABLES' group by Customer_Name;

-----#9. Find all the customers from Ontario province who own Small Business. (display the customer name, no of small business owners)------

select Customer_Name as 'Customer Name', Customer_Segment as 'No. of Customer Segment',  Province  from superstore.cust_dimen where Province like 'Ontario' and Customer_Segment like 'small business';


-----#10. Find the number and id of products sold in decreasing order of products sold (display product id, no_of_products sold)-----
select Prod_id, sum(Order_Quantity) as "no_of_products sold" from superstore.market_fact group by Prod_id order by sum(Order_Quantity) DESC;

------#11. Display product Id and product sub category whose produt category belongs to Furniture and Technlogy. The result should contain columns product id, product sub category.------
select Prod_id as 'Product ID', Product_Sub_Category as 'Product Sub Category', Product_Category as 'Product Category' from superstore.prod_dimen where Product_Category like 'TECHNOLOGY' or Product_Category like 'FURNITURE';

------#12. Display the product categories in descending order of profits (display the product category wise profits i.e. product_category, profits)?-----
select Product_Category as 'Product Category', round(sum(Profit),2) as 'Profits' from superstore.prod_dimen p, superstore.market_fact m where m.Prod_id = p.Prod_id group by Product_Category order by sum(Profit) desc;

------#13. Display the product category, product sub-category and the profit within each subcategory in three columns. -----
select Product_Category as 'Product Category', Product_Sub_Category as 'Product Sub Category', round(sum(Profit),2) as 'Profits' from superstore.prod_dimen p, superstore.market_fact m where m.Prod_id = p.Prod_id group by Product_Sub_Category order by Product_Category;

-----#14. Display the order date, order quantity and the sales for the order-----
select Order_Date, Order_Quantity, Sales from superstore.orders_dimen o, superstore.market_fact m where m.Ord_id = o.Ord_id order by order_quantity desc;

#15. Display the names of the customers whose name contains the
 #i) Second letter as ‘R’
 select Customer_Name from superstore.cust_dimen where Customer_Name like '_r%';

#ii) Fourth letter as ‘D’
select Customer_Name from superstore.cust_dimen where Customer_Name like '___d%';

-----#16. Write a SQL query to to make a list with Cust_Id, Sales, Customer Name and their region where sales are between 1000 and 5000.-----
select c.Cust_id, Sales, Customer_Name as 'Customer Name', Region from superstore.cust_dimen c, superstore.market_fact m where m.Cust_id = c.Cust_id and Sales between 1000 and 5000;

------#17. Write a SQL query to find the 3rd highest sales.------
select Sales as 'Third Highest Salary' from superstore.market_fact order by Sales desc limit 2,1;

-----#18. Where is the least profitable product subcategory shipped the most? For the least 
profitable product sub-category, display the region-wise no_of_shipments and the profit made in each region in decreasing order of profits (i.e. region, 
no_of_shipments, profit_in_each_region)
 → Note: You can hardcode the name of the least profitable product subcategory------
 
select c.Region as "Region",count(m.Ship_id) as "No of Shipments", round(sum(m.Profit),2) as "Profit in each region"
from superstore.market_fact m 
		join superstore.cust_dimen c on m.Cust_id = c.Cust_id
        join superstore.prod_dimen p on m.Prod_id = p.Prod_id
Where Product_Sub_Category = (Select p.Product_Sub_Category from superstore.market_fact m join superstore.prod_dimen p on m.Prod_id = p.Prod_id group by Product_Sub_Category order by sum(m.Profit) LIMIT 1) 
group by c.Region
order by sum(m.Profit);