CREATE DATABASE telecom_management;

USE telecom_management;
SHOW DATABASES;

USE telecom_management;

-- 1. CUSTOMERS TABLE
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(15) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE,
    address VARCHAR(255),
    registration_date DATE NOT NULL
);

-- 2. PLANS TABLE
CREATE TABLE plans (
    plan_id INT AUTO_INCREMENT PRIMARY KEY,
    plan_name VARCHAR(100) NOT NULL,
    plan_type ENUM('Prepaid', 'Postpaid') NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    validity_days INT NOT NULL,
    data_limit_gb DECIMAL(8,2),
    calling_limit_minutes INT,
    description VARCHAR(255),
    CHECK (price >= 0),
    CHECK (validity_days > 0)
);

-- 3. SUBSCRIPTIONS TABLE
CREATE TABLE subscriptions (
    subscription_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    plan_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status ENUM('Active', 'Expired', 'Cancelled')
        DEFAULT 'Active',

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    FOREIGN KEY (plan_id)
        REFERENCES plans(plan_id),

    CHECK (end_date >= start_date)
);

-- 4. CALL RECORDS TABLE
CREATE TABLE call_records (
    call_id INT AUTO_INCREMENT PRIMARY KEY,
    subscription_id INT NOT NULL,
    receiver_number VARCHAR(15) NOT NULL,
    call_date DATETIME NOT NULL,
    duration_minutes INT NOT NULL,
    call_type ENUM('Incoming', 'Outgoing') NOT NULL,

    FOREIGN KEY (subscription_id)
        REFERENCES subscriptions(subscription_id),

    CHECK (duration_minutes >= 0)
);

-- 5. DATA USAGE TABLE
CREATE TABLE data_usage (
    usage_id INT AUTO_INCREMENT PRIMARY KEY,
    subscription_id INT NOT NULL,
    usage_date DATE NOT NULL,
    data_used_gb DECIMAL(8,3) NOT NULL,

    FOREIGN KEY (subscription_id)
        REFERENCES subscriptions(subscription_id),

    CHECK (data_used_gb >= 0)
);

-- 6. BILLS TABLE
CREATE TABLE bills (
    bill_id INT AUTO_INCREMENT PRIMARY KEY,
    subscription_id INT NOT NULL,
    bill_date DATE NOT NULL,
    due_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    bill_status ENUM('Paid', 'Unpaid', 'Partially Paid')
        DEFAULT 'Unpaid',

    FOREIGN KEY (subscription_id)
        REFERENCES subscriptions(subscription_id),

    CHECK (total_amount >= 0),
    CHECK (due_date >= bill_date)
);

-- 7. PAYMENTS TABLE
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    bill_id INT NOT NULL,
    payment_date DATETIME NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_method ENUM('UPI', 'Card', 'Net Banking', 'Cash')
        NOT NULL,
    transaction_id VARCHAR(100) UNIQUE,

    FOREIGN KEY (bill_id)
        REFERENCES bills(bill_id),

    CHECK (amount > 0)
);

-- 8. COMPLAINTS TABLE
CREATE TABLE complaints (
    complaint_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    complaint_type VARCHAR(100) NOT NULL,
    description TEXT,
    complaint_date DATETIME NOT NULL,
    complaint_status ENUM('Open', 'In Progress', 'Resolved')
        DEFAULT 'Open',

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

-- Display all created tables
SHOW TABLES;


