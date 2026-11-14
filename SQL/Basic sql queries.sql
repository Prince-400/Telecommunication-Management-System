/* SQL query implementation
Part A – Basic SQL queries
These queries demonstrate SELECT, WHERE, ORDER BY, and DISTINCT.
*/

USE telecom_management;

-- Query 1: Display all customers
SELECT * FROM customers;
-- Purpose: Displays all customer records.


-- Query 2: Display customer names and phone numbers
SELECT name, phone_number
FROM customers;
-- Purpose: Retrieves selected columns from a table.


-- Query 3: Find all prepaid plans
SELECT *
FROM plans
WHERE plan_type = 'Prepaid';
-- Purpose: Filters prepaid mobile plans.


-- Query 4: Find plans costing more than ₹300
SELECT plan_name, price
FROM plans
WHERE price > 300;
-- Purpose: Uses a comparison operator.


-- Query 5: Display customers from Delhi
SELECT *
FROM customers
WHERE address = 'Delhi';


-- Query 6: Display all unique customer locations
SELECT DISTINCT address
FROM customers;
-- Purpose: Removes duplicate locations from the result.


-- Query 7: Display plans in ascending order of price
SELECT plan_name, price
FROM plans
ORDER BY price ASC;


-- Query 8: Find customers whose names start with 'A'
SELECT *
FROM customers
WHERE name LIKE 'A%';
-- Purpose: Demonstrates pattern matching using LIKE.




/* Part B – SQL JOIN queries
These are especially important 
because they demonstrate relationships between your database tables. */

-- Query 9: Display customer names with their subscribed plans
SELECT
    c.customer_id,
    c.name,
    p.plan_name,
    p.price,
    s.status
FROM customers c
INNER JOIN subscriptions s
    ON c.customer_id = s.customer_id
INNER JOIN plans p
    ON s.plan_id = p.plan_id;

-- Purpose: Combines three tables using INNER JOIN.


-- Query 10: Display active subscriptions
SELECT
    c.name,
    c.phone_number,
    p.plan_name,
    s.start_date,
    s.end_date
FROM subscriptions s
JOIN customers c
    ON s.customer_id = c.customer_id
JOIN plans p
    ON s.plan_id = p.plan_id
WHERE s.status = 'Active';


-- Query 11: Display customer call history
SELECT
    c.name,
    cr.receiver_number,
    cr.call_date,
    cr.duration_minutes,
    cr.call_type
FROM customers c
JOIN subscriptions s
    ON c.customer_id = s.customer_id
JOIN call_records cr
    ON s.subscription_id = cr.subscription_id;


-- Query 12: Display customer complaints
SELECT
    c.name,
    c.phone_number,
    cp.complaint_type,
    cp.description,
    cp.complaint_status
FROM customers c
JOIN complaints cp
    ON c.customer_id = cp.customer_id;


-- Query 13: Display unpaid bills with customer details
SELECT
    c.name,
    c.phone_number,
    b.bill_id,
    b.total_amount,
    b.due_date
FROM customers c
JOIN subscriptions s
    ON c.customer_id = s.customer_id
JOIN bills b
    ON s.subscription_id = b.subscription_id
WHERE b.bill_status = 'Unpaid';


-- Query 14: Display payments with customer names
SELECT
    c.name,
    b.bill_id,
    p.amount,
    p.payment_method,
    p.payment_date
FROM customers c
JOIN subscriptions s
    ON c.customer_id = s.customer_id
JOIN bills b
    ON s.subscription_id = b.subscription_id
JOIN payments p
    ON b.bill_id = p.bill_id;
    
    

/* Part C – Aggregate functions
These queries demonstrate COUNT(), SUM(), AVG(), MAX(), and MIN(). */

-- Query 15: Count total customers
SELECT COUNT(*) AS total_customers
FROM customers;


-- Query 16: Calculate total revenue received
SELECT SUM(amount) AS total_revenue
FROM payments;


-- Query 17: Calculate average mobile plan price
SELECT AVG(price) AS average_plan_price
FROM plans;


-- Query 18: Find the most expensive mobile plan
SELECT MAX(price) AS highest_plan_price , 
FROM plans;


-- Query 19: Find the cheapest mobile plan
SELECT MIN(price) AS lowest_plan_price
FROM plans;


-- Query 20: Count customers according to their location
SELECT
    address,
    COUNT(*) AS total_customers
FROM customers
GROUP BY address;


-- Query 21: Calculate revenue by payment method
SELECT
    payment_method,
    SUM(amount) AS total_revenue
FROM payments
GROUP BY payment_method;


-- Query 22: Count subscriptions for each plan
SELECT
    p.plan_name,
    COUNT(s.subscription_id) AS total_subscriptions
FROM plans p
LEFT JOIN subscriptions s
    ON p.plan_id = s.plan_id
GROUP BY p.plan_id, p.plan_name;


-- Query 23: Find plans having prices above the average price
SELECT plan_name, price
FROM plans
WHERE price > (
    SELECT AVG(price)
    FROM plans
);
-- Purpose: Demonstrates a nested query (subquery).


-- Query 24: Find complaint counts by status
SELECT
    complaint_status,
    COUNT(*) AS total_complaints
FROM complaints
GROUP BY complaint_status;




# Part D – GROUP BY and HAVING

-- Query 25: Find customers who have made calls longer than 15 minutes
SELECT
    s.customer_id,
    c.name,
    SUM(cr.duration_minutes) AS total_call_minutes
FROM call_records cr
JOIN subscriptions s
    ON cr.subscription_id = s.subscription_id
JOIN customers c
    ON s.customer_id = c.customer_id
GROUP BY s.customer_id, c.name
HAVING SUM(cr.duration_minutes) > 15;


-- Query 26: Find payment methods with total collections above ₹500
SELECT
    payment_method,
    SUM(amount) AS collection
FROM payments
GROUP BY payment_method
HAVING SUM(amount) > 500;


-- Query 27: Find customers using more than 2 GB of data in recorded usage
SELECT
    c.name,
    SUM(d.data_used_gb) AS total_data_used
FROM customers c
JOIN subscriptions s
    ON c.customer_id = s.customer_id
JOIN data_usage d
    ON s.subscription_id = d.subscription_id
GROUP BY c.customer_id, c.name
HAVING SUM(d.data_used_gb) > 2;

-- These queries will help demonstrate data analysis capabilities in your database.




# Part E – Subqueries and advanced retrieval

-- Query 28: Find customers who have unpaid bills using a subquery
SELECT name, phone_number
FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM subscriptions
    WHERE subscription_id IN (
        SELECT subscription_id
        FROM bills
        WHERE bill_status = 'Unpaid'
    )
);


-- Query 29: Find the customer with the highest recorded data usage
SELECT
    c.name,
    d.data_used_gb
FROM customers c
JOIN subscriptions s
    ON c.customer_id = s.customer_id
JOIN data_usage d
    ON s.subscription_id = d.subscription_id
ORDER BY d.data_used_gb DESC
LIMIT 1;


-- Query 30: Find the longest recorded call
SELECT
    c.name,
    cr.receiver_number,
    cr.duration_minutes
FROM call_records cr
JOIN subscriptions s
    ON cr.subscription_id = s.subscription_id
JOIN customers c
    ON s.customer_id = c.customer_id
ORDER BY cr.duration_minutes DESC
LIMIT 1;


-- Query 31: Display all bills and their payment details
SELECT
    b.bill_id,
    b.total_amount,
    b.bill_status,
    p.amount AS paid_amount,
    p.payment_method
FROM bills b
LEFT JOIN payments p
    ON b.bill_id = p.bill_id;


-- Query 32: Calculate the remaining balance for each bill
SELECT
    b.bill_id,
    b.total_amount,
    COALESCE(SUM(p.amount), 0) AS amount_paid,
    b.total_amount - COALESCE(SUM(p.amount), 0)
        AS remaining_balance
FROM bills b
LEFT JOIN payments p
    ON b.bill_id = p.bill_id
GROUP BY b.bill_id, b.total_amount;

-- This is particularly useful for demonstrating real-world telecom billing.