-- FINANCE DOMAIN DATABASE
-- Mimics real banking systems used at JPMorgan, Goldman, Stripe, PayPal, Visa

DROP DATABASE IF EXISTS sql_finance;
CREATE DATABASE sql_finance;
USE sql_finance;

CREATE TABLE customers (
  customer_id INT PRIMARY KEY AUTO_INCREMENT,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  phone VARCHAR(20),
  date_of_birth DATE,
  country VARCHAR(50) NOT NULL DEFAULT 'USA',
  city VARCHAR(50),
  state CHAR(2),
  created_at DATE NOT NULL,
  kyc_verified TINYINT(1) DEFAULT 0
);

CREATE TABLE accounts (
  account_id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT NOT NULL,
  account_type ENUM('checking','savings','credit','investment') NOT NULL,
  balance DECIMAL(15,2) NOT NULL DEFAULT 0.00,
  currency CHAR(3) DEFAULT 'USD',
  opened_date DATE NOT NULL,
  status ENUM('active','frozen','closed') DEFAULT 'active',
  interest_rate DECIMAL(5,4) DEFAULT 0.0000,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE transactions (
  transaction_id INT PRIMARY KEY AUTO_INCREMENT,
  account_id INT NOT NULL,
  transaction_type ENUM('deposit','withdrawal','transfer','payment','refund') NOT NULL,
  amount DECIMAL(15,2) NOT NULL,
  transaction_date DATETIME NOT NULL,
  description VARCHAR(200),
  status ENUM('completed','pending','failed','reversed') DEFAULT 'completed',
  merchant_id INT,
  FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

CREATE TABLE loans (
  loan_id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT NOT NULL,
  loan_type ENUM('personal','mortgage','auto','student','business') NOT NULL,
  principal_amount DECIMAL(15,2) NOT NULL,
  outstanding_balance DECIMAL(15,2) NOT NULL,
  interest_rate DECIMAL(5,4) NOT NULL,
  monthly_payment DECIMAL(10,2) NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  status ENUM('active','paid_off','defaulted','delinquent') DEFAULT 'active',
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE loan_payments (
  payment_id INT PRIMARY KEY AUTO_INCREMENT,
  loan_id INT NOT NULL,
  payment_date DATE NOT NULL,
  amount_paid DECIMAL(10,2) NOT NULL,
  principal_paid DECIMAL(10,2) NOT NULL,
  interest_paid DECIMAL(10,2) NOT NULL,
  remaining_balance DECIMAL(15,2) NOT NULL,
  FOREIGN KEY (loan_id) REFERENCES loans(loan_id)
);

CREATE TABLE merchants (
  merchant_id INT PRIMARY KEY AUTO_INCREMENT,
  merchant_name VARCHAR(100) NOT NULL,
  category VARCHAR(50) NOT NULL,
  country VARCHAR(50) DEFAULT 'USA',
  is_active TINYINT(1) DEFAULT 1
);

CREATE TABLE cards (
  card_id INT PRIMARY KEY AUTO_INCREMENT,
  account_id INT NOT NULL,
  card_type ENUM('debit','credit','prepaid') NOT NULL,
  card_number_last4 CHAR(4) NOT NULL,
  expiry_date DATE NOT NULL,
  credit_limit DECIMAL(10,2),
  current_balance DECIMAL(10,2) DEFAULT 0.00,
  status ENUM('active','blocked','expired') DEFAULT 'active',
  issued_date DATE NOT NULL,
  FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

CREATE TABLE branches (
  branch_id INT PRIMARY KEY AUTO_INCREMENT,
  branch_name VARCHAR(100) NOT NULL,
  city VARCHAR(50) NOT NULL,
  state CHAR(2),
  country VARCHAR(50) DEFAULT 'USA',
  manager_name VARCHAR(100)
);

CREATE TABLE employees (
  employee_id INT PRIMARY KEY AUTO_INCREMENT,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  department ENUM('retail','loans','investments','risk','compliance','tech') NOT NULL,
  salary DECIMAL(10,2) NOT NULL,
  branch_id INT,
  hire_date DATE NOT NULL,
  reports_to INT,
  FOREIGN KEY (branch_id) REFERENCES branches(branch_id),
  FOREIGN KEY (reports_to) REFERENCES employees(employee_id)
);

-- SEED DATA
INSERT INTO customers VALUES
(1,'James','Wilson','james.w@email.com','555-0101','1985-03-15','USA','New York','NY','2020-01-10',1),
(2,'Sarah','Johnson','sarah.j@email.com','555-0102','1990-07-22','USA','Los Angeles','CA','2020-03-05',1),
(3,'Michael','Brown','mike.b@email.com','555-0103','1978-11-08','USA','Chicago','IL','2019-06-20',1),
(4,'Emily','Davis','emily.d@email.com','555-0104','1995-04-30','USA','Houston','TX','2021-02-14',0),
(5,'Robert','Miller','rob.m@email.com','555-0105','1982-09-17','USA','Phoenix','AZ','2020-08-01',1),
(6,'Jessica','Taylor','jess.t@email.com','555-0106','1988-12-05','USA','Philadelphia','PA','2019-11-30',1),
(7,'David','Anderson','david.a@email.com','555-0107','1975-06-25','USA','San Antonio','TX','2018-04-15',1),
(8,'Ashley','Thomas','ash.t@email.com','555-0108','1993-02-14','USA','San Diego','CA','2021-07-08',0),
(9,'Christopher','Jackson','chris.j@email.com','555-0109','1987-08-19','USA','Dallas','TX','2020-05-22',1),
(10,'Amanda','White','amanda.w@email.com','555-0110','1991-01-28','USA','San Jose','CA','2021-01-15',1),
(11,'Daniel','Harris','dan.h@email.com','555-0111','1980-10-12','USA','Austin','TX','2019-09-10',1),
(12,'Stephanie','Martin','steph.m@email.com','555-0112','1994-05-07','USA','Jacksonville','FL','2022-03-01',0),
(13,'Kevin','Garcia','kevin.g@email.com','555-0113','1986-03-23','USA','San Francisco','CA','2018-12-20',1),
(14,'Nicole','Martinez','nicole.m@email.com','555-0114','1992-11-16','USA','Columbus','OH','2021-06-18',1),
(15,'Brian','Robinson','brian.r@email.com','555-0115','1979-07-04','USA','Charlotte','NC','2020-02-28',1);

INSERT INTO branches VALUES
(1,'Manhattan HQ','New York','NY','USA','Robert Chen'),
(2,'Beverly Hills Branch','Los Angeles','CA','USA','Linda Park'),
(3,'Chicago Loop Branch','Chicago','IL','USA','Tom Walsh'),
(4,'Houston Branch','Houston','TX','USA','Maria Santos'),
(5,'Phoenix Branch','Phoenix','AZ','USA','John Kim');

INSERT INTO employees VALUES
(1,'Alice','Morgan','retail',95000.00,1,'2018-01-15',NULL),
(2,'Bob','Stevens','loans',87000.00,1,'2019-03-20',1),
(3,'Carol','Hughes','investments',112000.00,2,'2017-06-10',1),
(4,'David','Price','risk',98000.00,2,'2018-09-05',1),
(5,'Eva','Collins','compliance',91000.00,3,'2019-11-12',1),
(6,'Frank','Ward','tech',125000.00,3,'2016-04-18',1),
(7,'Grace','Bell','retail',78000.00,4,'2020-07-22',1),
(8,'Henry','Cook','loans',83000.00,4,'2020-01-30',1),
(9,'Iris','Murphy','investments',105000.00,5,'2019-05-14',1),
(10,'Jack','Bailey','risk',94000.00,5,'2021-02-08',1);

INSERT INTO accounts VALUES
(1,1,'checking',15420.50,'USD','2020-01-10','active',0.0100,NULL),
(2,1,'savings',48750.00,'USD','2020-01-10','active',0.0450,NULL),
(3,2,'checking',3280.75,'USD','2020-03-05','active',0.0100,NULL),
(4,2,'credit',0.00,'USD','2020-06-15','active',0.1899,NULL),
(5,3,'checking',22100.00,'USD','2019-06-20','active',0.0100,NULL),
(6,3,'savings',95000.00,'USD','2019-06-20','active',0.0450,NULL),
(7,3,'investment',280000.00,'USD','2019-06-20','active',0.0000,NULL),
(8,4,'checking',1250.00,'USD','2021-02-14','active',0.0100,NULL),
(9,5,'checking',8900.25,'USD','2020-08-01','active',0.0100,NULL),
(10,5,'savings',32000.00,'USD','2020-08-01','active',0.0450,NULL),
(11,6,'checking',5600.00,'USD','2019-11-30','active',0.0100,NULL),
(12,7,'checking',18750.50,'USD','2018-04-15','active',0.0100,NULL),
(13,7,'savings',125000.00,'USD','2018-04-15','active',0.0450,NULL),
(14,7,'investment',520000.00,'USD','2018-04-15','active',0.0000,NULL),
(15,8,'checking',890.00,'USD','2021-07-08','frozen',0.0100,NULL),
(16,9,'checking',11200.00,'USD','2020-05-22','active',0.0100,NULL),
(17,10,'checking',6750.00,'USD','2021-01-15','active',0.0100,NULL),
(18,10,'savings',28000.00,'USD','2021-01-15','active',0.0450,NULL),
(19,11,'checking',33400.00,'USD','2019-09-10','active',0.0100,NULL),
(20,13,'investment',890000.00,'USD','2018-12-20','active',0.0000,NULL);

INSERT INTO merchants VALUES
(1,'Amazon','E-commerce','USA',1),
(2,'Walmart','Retail','USA',1),
(3,'Shell','Gas Station','USA',1),
(4,'McDonald''s','Restaurant','USA',1),
(5,'Netflix','Subscription','USA',1),
(6,'Uber','Transportation','USA',1),
(7,'Starbucks','Restaurant','USA',1),
(8,'Apple','Electronics','USA',1),
(9,'Delta Airlines','Travel','USA',1),
(10,'CVS Pharmacy','Healthcare','USA',1);

INSERT INTO transactions VALUES
(1,1,'deposit',5000.00,'2024-01-05 09:15:00','Payroll deposit','completed',NULL),
(2,1,'withdrawal',200.00,'2024-01-06 14:30:00','ATM withdrawal','completed',NULL),
(3,1,'payment',85.99,'2024-01-08 10:20:00','Netflix subscription','completed',5),
(4,1,'payment',150.00,'2024-01-10 16:45:00','Amazon purchase','completed',1),
(5,2,'deposit',1000.00,'2024-01-15 11:00:00','Transfer from checking','completed',NULL),
(6,3,'deposit',4500.00,'2024-01-03 08:30:00','Payroll deposit','completed',NULL),
(7,3,'payment',45.50,'2024-01-07 12:15:00','McDonald''s','completed',4),
(8,3,'payment',60.00,'2024-01-09 18:30:00','Uber ride','completed',6),
(9,4,'payment',299.99,'2024-01-12 15:00:00','Apple purchase','completed',8),
(10,5,'deposit',8000.00,'2024-01-02 09:00:00','Payroll deposit','completed',NULL),
(11,5,'payment',120.00,'2024-01-05 11:30:00','Shell gas','completed',3),
(12,5,'payment',75.25,'2024-01-08 13:00:00','Walmart groceries','completed',2),
(13,6,'deposit',2000.00,'2024-01-20 10:00:00','Savings transfer','completed',NULL),
(14,7,'deposit',10000.00,'2024-01-15 09:00:00','Investment contribution','completed',NULL),
(15,8,'deposit',1500.00,'2024-01-10 10:30:00','Payroll deposit','completed',NULL),
(16,8,'withdrawal',500.00,'2024-01-12 15:00:00','ATM withdrawal','completed',NULL),
(17,9,'deposit',3500.00,'2024-01-04 08:45:00','Payroll deposit','completed',NULL),
(18,9,'payment',200.00,'2024-01-06 17:00:00','Delta Airlines','completed',9),
(19,10,'deposit',5000.00,'2024-01-01 09:00:00','Payroll deposit','completed',NULL),
(20,11,'payment',35.00,'2024-01-09 08:00:00','Starbucks','completed',7),
(21,12,'deposit',6000.00,'2024-01-03 09:00:00','Payroll deposit','completed',NULL),
(22,13,'deposit',15000.00,'2024-01-10 09:00:00','Investment contribution','completed',NULL),
(23,16,'deposit',4000.00,'2024-01-05 09:00:00','Payroll deposit','completed',NULL),
(24,16,'payment',150.00,'2024-01-08 12:00:00','Amazon purchase','completed',1),
(25,17,'deposit',3800.00,'2024-01-03 09:00:00','Payroll deposit','completed',NULL),
(26,17,'payment',55.00,'2024-01-07 19:00:00','CVS Pharmacy','completed',10),
(27,18,'deposit',800.00,'2024-01-15 10:00:00','Savings transfer','completed',NULL),
(28,19,'deposit',7500.00,'2024-01-02 09:00:00','Payroll deposit','completed',NULL),
(29,19,'payment',480.00,'2024-01-06 14:00:00','Apple purchase','completed',8),
(30,20,'deposit',50000.00,'2024-01-08 09:00:00','Investment contribution','completed',NULL),
(31,1,'payment',320.00,'2024-02-01 10:00:00','Amazon purchase','completed',1),
(32,1,'deposit',5000.00,'2024-02-05 09:00:00','Payroll deposit','completed',NULL),
(33,3,'withdrawal',300.00,'2024-02-03 14:00:00','ATM withdrawal','completed',NULL),
(34,5,'deposit',8000.00,'2024-02-02 09:00:00','Payroll deposit','completed',NULL),
(35,5,'payment',95.00,'2024-02-04 11:00:00','Netflix subscription','completed',5),
(36,16,'payment',75.00,'2024-02-06 13:00:00','Starbucks','completed',7),
(37,1,'payment',500.00,'2024-02-10 16:00:00','Delta Airlines','completed',9),
(38,9,'deposit',3500.00,'2024-02-04 08:45:00','Payroll deposit','completed',NULL),
(39,12,'payment',200.00,'2024-02-05 11:00:00','Walmart groceries','completed',2),
(40,19,'deposit',7500.00,'2024-02-02 09:00:00','Payroll deposit','completed',NULL);

INSERT INTO loans VALUES
(1,1,'mortgage',450000.00,420000.00,0.0375,2100.00,'2020-03-01','2050-03-01','active'),
(2,2,'auto',28000.00,18500.00,0.0499,520.00,'2021-01-15','2026-01-15','active'),
(3,3,'personal',15000.00,8200.00,0.0899,350.00,'2022-06-01','2025-06-01','active'),
(4,5,'mortgage',320000.00,290000.00,0.0425,1650.00,'2020-09-01','2050-09-01','active'),
(5,7,'mortgage',850000.00,780000.00,0.0350,3800.00,'2019-05-01','2049-05-01','active'),
(6,9,'auto',22000.00,12000.00,0.0550,420.00,'2021-08-01','2025-08-01','active'),
(7,11,'student',45000.00,38000.00,0.0450,480.00,'2020-09-01','2030-09-01','active'),
(8,13,'business',200000.00,165000.00,0.0625,2200.00,'2019-01-01','2029-01-01','active'),
(9,4,'personal',5000.00,5000.00,0.1299,150.00,'2023-01-01','2026-01-01','delinquent'),
(10,14,'auto',18000.00,14500.00,0.0475,380.00,'2022-03-01','2027-03-01','active');

INSERT INTO loan_payments VALUES
(1,1,'2024-01-01',2100.00,487.50,1612.50,419512.50),
(2,1,'2024-02-01',2100.00,489.32,1610.68,419023.18),
(3,2,'2024-01-15',520.00,443.00,77.00,18057.00),
(4,2,'2024-02-15',520.00,444.85,75.15,17612.15),
(5,3,'2024-01-01',350.00,288.00,62.00,7912.00),
(6,3,'2024-02-01',350.00,290.16,59.84,7621.84),
(7,4,'2024-01-01',1650.00,621.25,1028.75,289378.75),
(8,5,'2024-01-01',3800.00,1525.00,2275.00,778475.00),
(9,6,'2024-01-01',420.00,365.00,55.00,11635.00),
(10,7,'2024-01-01',480.00,337.50,142.50,37662.50),
(11,8,'2024-01-01',2200.00,1156.25,1043.75,163843.75),
(12,10,'2024-01-01',380.00,309.25,70.75,14190.75);

INSERT INTO cards VALUES
(1,1,'debit','4521','2026-12-31',NULL,0.00,'active','2020-01-10'),
(2,4,'credit','7823','2025-06-30',5000.00,1250.00,'active','2020-06-15'),
(3,3,'debit','2190','2026-12-31',NULL,0.00,'active','2020-03-05'),
(4,9,'debit','8834','2025-12-31',NULL,0.00,'active','2020-08-01'),
(5,11,'credit','5567','2024-12-31',10000.00,3200.00,'active','2019-11-30'),
(6,15,'debit','3341','2025-06-30',NULL,0.00,'blocked','2021-07-08'),
(7,12,'debit','9920','2027-06-30',NULL,0.00,'active','2018-04-15'),
(8,16,'debit','1145','2026-12-31',NULL,0.00,'active','2020-05-22'),
(9,17,'debit','6672','2026-06-30',NULL,0.00,'active','2021-01-15'),
(10,19,'credit','4489','2025-12-31',15000.00,4800.00,'active','2019-09-10');
