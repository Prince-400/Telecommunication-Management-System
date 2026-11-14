/* Advanced DBMS concepts
Advanced SQL & DBMS
Five important concepts:
1. Views
2. Stored Procedures
3. Functions
4. Triggers
5. Normalization */

USE telecom_management;

/* Part A – Views
What is a View?
A view is a virtual table created from the result of an SQL query. It allows us to retrieve frequently needed information without writing the same complex query repeatedly.
*/

-- Query 33 – Create a customer subscription view

CREATE VIEW customer_subscription_view AS
SELECT
    c.customer_id,
    c.name,
    c.phone_number,
    p.plan_name,
    p.price,
    s.start_date,
    s.end_date,
    s.status
FROM customers c
JOIN subscriptions s
    ON c.customer_id = s.customer_id
JOIN plans p
    ON s.plan_id = p.plan_id;

-- To display the view:
SELECT * FROM customer_subscription_view;

-- Explanation: This view combines customer, subscription, and plan information into one virtual table.


-- Query 34 – Create a payment summary view
CREATE VIEW payment_summary_view AS
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

-- Execute:
SELECT * FROM payment_summary_view;

-- Explanation: This view displays the total bill, amount paid, and remaining balance.


-- Query 35 – Create a complaint report view
CREATE VIEW complaint_report_view AS
SELECT
    c.customer_id,
    c.name,
    c.phone_number,
    cp.complaint_type,
    cp.description,
    cp.complaint_date,
    cp.complaint_status
FROM customers c
JOIN complaints cp
    ON c.customer_id = cp.customer_id;

-- Execute:
SELECT * FROM complaint_report_view;

-- Explanation: This view provides customer complaint information in one place.




/* Part B – Stored Procedures
What is a Stored Procedure?
A stored procedure is a group of SQL statements stored in the database that can be executed whenever required.
*/

-- Query 36 – Procedure to display all customers
DELIMITER //

CREATE PROCEDURE GetAllCustomers()
BEGIN
    SELECT * FROM customers;
END //

DELIMITER ;

-- Execute:
CALL GetAllCustomers();


-- Query 37 – Procedure to search for a customer by ID
DELIMITER //

CREATE PROCEDURE GetCustomerByID(
    IN cust_id INT
)
BEGIN
    SELECT *
    FROM customers
    WHERE customer_id = cust_id;
END //

DELIMITER ;

-- Execute:
CALL GetCustomerByID(1);


-- Query 38 – Procedure to display unpaid bills
DELIMITER //

CREATE PROCEDURE GetUnpaidBills()
BEGIN
    SELECT
        c.name,
        b.bill_id,
        b.total_amount,
        b.due_date
    FROM customers c
    JOIN subscriptions s
        ON c.customer_id = s.customer_id
    JOIN bills b
        ON s.subscription_id = b.subscription_id
    WHERE b.bill_status = 'Unpaid';
END //

DELIMITER ;

-- Execute:
CALL GetUnpaidBills();




/* Part C – SQL Functions
What is a Function?
A function is a reusable SQL program that returns a single value.
*/ 

-- Query 39 – Function to calculate remaining bill balance
DELIMITER //

CREATE FUNCTION CalculateBillBalance(
    p_bill_id INT
)
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE remaining DECIMAL(10,2);

    SELECT
        b.total_amount - COALESCE(SUM(p.amount), 0)
    INTO remaining
    FROM bills b
    LEFT JOIN payments p
        ON b.bill_id = p.bill_id
    WHERE b.bill_id = p_bill_id
    GROUP BY b.bill_id, b.total_amount;

    RETURN remaining;
END //

DELIMITER ;

-- Execute:
SELECT CalculateBillBalance(2) AS remaining_balance;

/* Expected result:
₹199.00
Explanation: Bill 2 is ₹399, and the customer has paid ₹200. 
Therefore, the remaining balance is ₹199.
*/





/*
Part D – Triggers
What is a Trigger?
A trigger is a database operation that automatically executes when an event such as INSERT, UPDATE, or DELETE occurs on a table.

We'll implement a useful telecom billing trigger.
*/

-- Query 40 – Automatically update bill status after payment
-- Whenever a new payment is inserted, MySQL will automatically check the total amount paid and update the bill status.

DELIMITER //

CREATE TRIGGER update_bill_status
AFTER INSERT ON payments
FOR EACH ROW
BEGIN

    UPDATE bills
    SET bill_status =
        CASE
            WHEN (
                SELECT COALESCE(SUM(amount), 0)
                FROM payments
                WHERE bill_id = NEW.bill_id
            ) >= total_amount
            THEN 'Paid'

            WHEN (
                SELECT COALESCE(SUM(amount), 0)
                FROM payments
                WHERE bill_id = NEW.bill_id
            ) > 0
            THEN 'Partially Paid'

            ELSE 'Unpaid'
        END
    WHERE bill_id = NEW.bill_id;

END //

DELIMITER ;
/*
Explanation:
- If the complete bill amount is received, status becomes Paid.
- If only part of the amount is received, status becomes Partially Paid.
- If no payment is received, status remains Unpaid.
*/

-- Test the trigger safely
-- We can test this using a transaction so that the test payment doesn't permanently change your sample data.
START TRANSACTION;
INSERT INTO payments
(bill_id, payment_date, amount,
 payment_method, transaction_id)
VALUES
(4, NOW(), 199, 'UPI', 'TRIGGER_TEST_01');

SELECT bill_id, total_amount, bill_status
FROM bills
WHERE bill_id = 4;

ROLLBACK;

-- During the test, bill 4 should show Paid. After rollback, its original status will be restored.


-- Query 41 – Trigger to validate payment amounts
-- We should also prevent a payment from making the total amount paid exceed the bill amount.
DELIMITER //

CREATE TRIGGER validate_payment
BEFORE INSERT ON payments
FOR EACH ROW
BEGIN
    DECLARE bill_total DECIMAL(10,2);
    DECLARE already_paid DECIMAL(10,2);

    SELECT total_amount
    INTO bill_total
    FROM bills
    WHERE bill_id = NEW.bill_id;

    SELECT COALESCE(SUM(amount), 0)
    INTO already_paid
    FROM payments
    WHERE bill_id = NEW.bill_id;

    IF already_paid + NEW.amount > bill_total THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Payment exceeds bill amount';
    END IF;
END //

DELIMITER ;

/* 
This trigger prevents overpayment.
Create both triggers before performing the test payment. 
The validation trigger and status trigger work together on future payment insertions.
*/

-- Verify your triggers:
SHOW TRIGGERS;


/*
You should see:
- update_bill_status
- validate_payment
*/



/*
Part E – Database Normalization
This is an important theoretical and practical topic for your DBMS project and viva.

What is Normalization?
Normalization is the process of organizing database tables to reduce data redundancy and improve data integrity.

We'll explain the three main normal forms using our telecom database.
1NF – First Normal Form
Rules:
- Every column must contain atomic (single) values.
- No repeating groups.
- Each row must be uniquely identifiable.
Example:

Incorrect design:
Customer ID	Name	Phone numbers
1	Rahul	9876543210, 9876501234

Correct design:
Customer ID	Name	Phone number
1	Rahul	9876543210
2	Rahul	9876501234

Our customer table stores one phone number per row, satisfying 1NF.
2NF – Second Normal Form
Rules:
- The table must already satisfy 1NF.
- Every non-key attribute must depend on the entire candidate key, not just part of a composite key.
Our tables use single-column primary keys, so they do not have partial dependencies on composite primary keys.

For example, in subscriptions, customer and plan information is represented through foreign keys, rather than repeating customer names and plan names in every subscription record.
3NF – Third Normal Form
Rules:
- The table must satisfy 2NF.
- There must be no transitive dependency of non-key attributes on the primary key.
For example, we maintain separate tables:
- customers – customer information.
- plans – plan information.
- subscriptions – relationship between customers and plans.
This prevents unnecessary repetition of customer and plan details.

*/