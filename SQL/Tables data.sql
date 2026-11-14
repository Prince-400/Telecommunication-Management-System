USE telecom_management;

INSERT INTO customers
(name, phone_number, email, address, registration_date)
VALUES
('Rahul Sharma', '9876543210', 'rahul@gmail.com', 'Delhi', '2026-01-10'),
('Priya Verma', '9876501234', 'priya@gmail.com', 'Mumbai', '2026-01-12'),
('Aman Gupta', '9876512345', 'aman@gmail.com', 'Jaipur', '2026-01-15'),
('Sneha Singh', '9876523456', 'sneha@gmail.com', 'Chandigarh', '2026-01-18'),
('Rohit Kumar', '9876534567', 'rohit@gmail.com', 'Bhiwani', '2026-01-20'),
('Anjali Mehta', '9876545678', 'anjali@gmail.com', 'Pune', '2026-01-22'),
('Vikas Yadav', '9876556789', 'vikas@gmail.com', 'Gurgaon', '2026-01-25'),
('Neha Jain', '9876567890', 'neha@gmail.com', 'Kolkata', '2026-01-28'),
('Karan Malhotra', '9876578901', 'karan@gmail.com', 'Lucknow', '2026-02-01'),
('Pooja Agarwal', '9876589012', 'pooja@gmail.com', 'Bangalore', '2026-02-05');

SELECT * FROM customers;



INSERT INTO plans
(plan_name, plan_type, price, validity_days,
 data_limit_gb, calling_limit_minutes, description)
VALUES
('Basic 28 Days', 'Prepaid', 199, 28, 2.00, 500,
 'Basic calling and internet plan'),

('Smart 56 Days', 'Prepaid', 399, 56, 3.00, 1000,
 'Standard internet and calling plan'),

('Premium 84 Days', 'Prepaid', 599, 84, 5.00, 1500,
 'Premium internet and unlimited calling'),

('Postpaid Silver', 'Postpaid', 499, 30, 4.00, 1200,
 'Monthly postpaid plan'),

('Postpaid Gold', 'Postpaid', 799, 30, 6.00, 2000,
 'Premium monthly postpaid plan');
 
 SELECT * FROM plans;
 
 
 
 INSERT INTO subscriptions
(customer_id, plan_id, start_date, end_date, status)
VALUES
(1, 1, '2026-10-01', '2026-10-28', 'Expired'),
(2, 2, '2026-10-01', '2026-11-25', 'Active'),
(3, 3, '2026-10-15', '2027-01-07', 'Active'),
(4, 1, '2026-10-10', '2026-11-07', 'Expired'),
(5, 4, '2026-10-01', '2026-10-30', 'Expired'),
(6, 5, '2026-10-20', '2026-11-19', 'Active'),
(7, 2, '2026-10-25', '2026-12-20', 'Active'),
(8, 3, '2026-10-15', '2027-01-07', 'Active'),
(9, 4, '2026-10-05', '2026-11-04', 'Expired'),
(10, 5, '2026-10-25', '2026-11-24', 'Active');

SELECT * FROM subscriptions;



INSERT INTO call_records
(subscription_id, receiver_number, call_date,
 duration_minutes, call_type)
VALUES
(1, '9811111111', '2026-10-02 10:30:00', 15, 'Outgoing'),
(2, '9822222222', '2026-10-03 11:45:00', 20, 'Incoming'),
(3, '9833333333', '2026-10-04 14:20:00', 10, 'Outgoing'),
(4, '9844444444', '2026-10-05 09:15:00', 25, 'Outgoing'),
(5, '9855555555', '2026-10-06 16:30:00', 12, 'Incoming'),
(6, '9866666666', '2026-10-07 12:00:00', 30, 'Outgoing'),
(7, '9877777777', '2026-10-08 18:20:00', 8, 'Incoming'),
(8, '9888888888', '2026-10-09 13:10:00', 18, 'Outgoing'),
(9, '9899999999', '2026-10-10 15:45:00', 22, 'Incoming'),
(10, '9800000000', '2026-10-11 17:30:00', 14, 'Outgoing');



INSERT INTO data_usage
(subscription_id, usage_date, data_used_gb)
VALUES
(1, '2026-10-02', 1.250),
(2, '2026-10-03', 2.500),
(3, '2026-10-04', 3.750),
(4, '2026-10-05', 1.800),
(5, '2026-10-06', 2.200),
(6, '2026-10-07', 4.500),
(7, '2026-10-08', 2.750),
(8, '2026-10-09', 4.000),
(9, '2026-10-10', 3.200),
(10, '2026-10-11', 5.500);



INSERT INTO bills
(subscription_id, bill_date, due_date,
 total_amount, bill_status)
VALUES
(1, '2026-10-01', '2026-10-15', 199, 'Paid'),
(2, '2026-10-01', '2026-10-15', 399, 'Partially Paid'),
(3, '2026-10-15', '2026-10-30', 599, 'Paid'),
(4, '2026-10-10', '2026-10-25', 199, 'Unpaid'),
(5, '2026-10-01', '2026-10-15', 499, 'Paid'),
(6, '2026-10-20', '2026-11-04', 799, 'Partially Paid'),
(7, '2026-10-25', '2026-11-09', 399, 'Paid'),
(8, '2026-10-15', '2026-10-30', 599, 'Unpaid'),
(9, '2026-10-05', '2026-10-20', 499, 'Paid'),
(10, '2026-10-25', '2026-11-09', 799, 'Partially Paid');



INSERT INTO payments
(bill_id, payment_date, amount,
 payment_method, transaction_id)
VALUES
(1, '2026-10-05 10:30:00', 199, 'UPI', 'TXN1001'),
(2, '2026-10-06 11:00:00', 200, 'Card', 'TXN1002'),
(3, '2026-10-16 12:00:00', 599, 'UPI', 'TXN1003'),
(5, '2026-10-05 14:00:00', 499, 'Cash', 'TXN1004'),
(6, '2026-10-25 15:30:00', 500, 'Net Banking', 'TXN1005'),
(7, '2026-10-28 16:00:00', 399, 'UPI', 'TXN1006'),
(9, '2026-10-08 17:00:00', 499, 'Card', 'TXN1007'),
(10, '2026-10-28 18:00:00', 400, 'UPI', 'TXN1008');



INSERT INTO complaints
(customer_id, complaint_type, description,
 complaint_date, complaint_status)
VALUES
(1, 'Network Issue', 'Poor network connectivity',
 '2026-10-03 10:00:00', 'Resolved'),

(2, 'Billing Issue', 'Incorrect billing amount',
 '2026-10-04 11:00:00', 'Open'),

(3, 'Internet Issue', 'Slow internet speed',
 '2026-10-05 12:00:00', 'In Progress'),

(4, 'Call Drop', 'Frequent call disconnections',
 '2026-10-06 13:00:00', 'Resolved'),

(5, 'SIM Issue', 'SIM card not working',
 '2026-10-07 14:00:00', 'Open'),

(6, 'Network Issue', 'Weak network signals',
 '2026-10-08 15:00:00', 'In Progress'),

(7, 'Billing Issue', 'Payment not reflected',
 '2026-10-09 16:00:00', 'Resolved'),

(8, 'Internet Issue', 'Data connection unavailable',
 '2026-10-10 17:00:00', 'Open'),

(9, 'Call Drop', 'Calls disconnect frequently',
 '2026-10-11 18:00:00', 'Resolved'),

(10, 'Network Issue', 'Poor network coverage',
 '2026-10-12 19:00:00', 'Open');
 
 
 
 
 -- Verify all your sample records
 SELECT COUNT(*) AS total_customers FROM customers;

SELECT COUNT(*) AS total_plans FROM plans;

SELECT COUNT(*) AS total_subscriptions FROM subscriptions;

SELECT COUNT(*) AS total_calls FROM call_records;

SELECT COUNT(*) AS total_data_records FROM data_usage;

SELECT COUNT(*) AS total_bills FROM bills;

SELECT COUNT(*) AS total_payments FROM payments;

SELECT COUNT(*) AS total_complaints FROM complaints;