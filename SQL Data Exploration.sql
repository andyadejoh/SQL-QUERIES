-- THE QUERIES BELOW ARE WRITTEN FOR THE SQL_STORE DATABASE
-- the dataset for customers contains 7 rows so I took a quick glance and could find all possible errors in the data
-- i had to update a few columns and i did with the code below
update customers
set phone = '833-421-6509'
where customer_id = 5

-- had to rename the city for customer with id = 3
update customers
set city = 'Colorado'
where customer_id = 3

-- return customers born in February, March, April and assign an email to them to send birthday wishes.
select 
	customer_id, 
    concat(first_name, ' ', last_name) AS FullName,
    concat(lower(first_name), lower(last_name), '@', 'gmail.com' ) AS Email,
    birth_date
from customers
where monthname(birth_date) IN ('February', 'March', 'April')

-- to show expected shipped date (1 day after order)for customers whose orders haven't been shipped. 
select 
	concat(first_name, ' ', last_name) AS Customer_name,
    order_date,
    date_add(order_date, interval 1 day) AS Expected_ShippedDate
from customers
join orders USING (customer_id)
where shipped_date is null     


-- finding products that have never been ordered
select name 
from products p 
where not exists 
	(select product_id
    from order_items
    where product_id = p.product_id)

-- to show customers and their full names whose orders have not been shipped
select concat(first_name, ' ', last_name) AS FullName
from customers
where customer_id IN 
	(select customer_id
	from orders
	where shipped_date IS NULL)
    
-- to assign a value to customers whose orders haven't been shipped yet
select 
	concat(first_name, ' ', last_name) AS Customer,
    ifnull(shipped_date, 'Not Shipped Yet') AS Shipped_Date
from customers
join orders USING (customer_id)

-- to show customers who have placed more than 1 order
select customer_id, concat(first_name, ' ', last_name) AS FullName
from customers
join orders USING (customer_id)
GROUP BY customer_id, FullName
HAVING count(*) > 1
ORDER BY customer_id

-- to know the type of delivery for each customer's orders
select 
	customer_id,
    concat(first_name, ' ', last_name) AS FullName, 
    case 
		when datediff(shipped_date, order_date) > 1 then 'Normal Delivery'
        when datediff(shipped_date, order_date) = 1 then 'Express Delivery'
	END AS DeliveryType
from customers
join orders USING (customer_id)    
where shipped_date IS NOT NULL  
order by customer_id

-- to show how many orders where shipped in 2018
select count(*)
from orders
where YEAR(shipped_date) = 2018

-- another way of doing it
select count(*) AS AS No_of_2018Orders
from orders 
where shipped_date LIKE '%2018%'
-- OR
select count(*) AS No_of_2018Orders
from orders 
where shipped_date REGEXP '2018'

-- to know the order frequency of products

select 
		product_id, 
		name, 
		count(*) AS orders,
		IF(count(*)> 1, 'Once', 'Many Times') AS Frequency
	from products p
	join order_items USING (product_id)
	group by product_id, name 
    
-- THE QUERIES BELOW ARE WRITTEN FOR THE SQL_INVOICING DATABASE
-- from the invoicing database, this is s query to show the total invoice, average invoice and difference between both
select 
	invoice_id,
    invoice_total,
	(select avg(invoice_total) from invoices) AS Average_Invoice,
    invoice_total - (select Average_Invoice ) AS difference
from invoices i

-- query to display the customer with the highest invoice total
select client_id, name , sum(invoice_total) AS Total_Invoice
from clients 
join invoices USING (client_id)
group by client_id, name
order by Total_Invoice DESC
Limit 1

-- Repearting the above but using Subqueries
select 
	client_id, 
    name,
    (select sum(invoice_total) from invoices where client_id  = c.client_id) AS Total_Invoice
from clients c    
order by Total_Invoice DESC
Limit 1

-- to display invoices larger than all invoices of client 3
select *
from invoices
where invoice_total > all 
	(select invoice_total
	from invoices
	where client_id = 3)

-- to return clients having at least 2 invoices
select *
from clients
where client_id = any
		(select client_id
	from invoices
	group by client_id   
	having count(*) >= 2)

-- show the payment methods clients used (credit card, cash, paypal or wire transfer)
select c.name AS Name, pm.name AS Payment_Method
from clients c
join payments p USING (client_id)
join payment_methods pm ON p.payment_method = pm.payment_method_id








