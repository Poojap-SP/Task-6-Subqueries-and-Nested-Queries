-- =========================
-- Task 6: Subqueries & Nested Queries
-- =========================

-- 1. Create sample tables
CREATE TABLE Customers (
    customer_id INTEGER PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    country VARCHAR(100),
    age INTEGER
);

CREATE TABLE Orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    item VARCHAR(100),
    amount DECIMAL(10,2),
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Products (
    product_id INTEGER PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

-- 2. Insert sample data
INSERT INTO Customers VALUES
(1, 'John', 'Doe', 'USA', 28),
(2, 'Jane', 'Smith', 'Canada', 34),
(3, 'Michael', 'Brown', 'UK', 41),
(4, 'Emily', 'Davis', 'USA', 29);

INSERT INTO Orders VALUES
(101, 1, 'Laptop', 1200.00, '2024-01-15'),
(102, 2, 'Tablet', 600.00, '2024-02-12'),
(103, 1, 'Mouse', 25.00, '2024-02-20'),
(104, 3, 'Laptop', 1300.00, '2024-03-10'),
(105, 4, 'Keyboard', 45.00, '2024-03-15'),
(106, 2, 'Laptop', 1100.00, '2024-04-05');

INSERT INTO Products VALUES
(1, 'Laptop', 'Electronics', 1200.00),
(2, 'Tablet', 'Electronics', 600.00),
(3, 'Mouse', 'Accessories', 25.00),
(4, 'Keyboard', 'Accessories', 45.00);

-- 3. Query 1: Subquery in WHERE clause
-- Find customers who spent more than average order amount
SELECT first_name, last_name
FROM Customers
WHERE customer_id IN (
    SELECT customer_id
    FROM Orders
    GROUP BY customer_id
    HAVING SUM(amount) > (
        SELECT AVG(amount) FROM Orders
    )
);

-- 4. Query 2: Scalar subquery in SELECT clause
-- Show each customer's total spending
SELECT 
    first_name, 
    last_name,
    (SELECT SUM(amount) 
     FROM Orders 
     WHERE Orders.customer_id = Customers.customer_id) AS total_spent
FROM Customers;

-- 5. Query 3: Subquery in FROM clause (Derived Table)
-- Customers whose spending is above 500
SELECT first_name, last_name, total_spent
FROM (
    SELECT c.customer_id, c.first_name, c.last_name, SUM(o.amount) AS total_spent
    FROM Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id
) AS spending
WHERE total_spent > 500;

-- 6. Query 4: EXISTS example
-- Find customers who bought 'Laptop'
SELECT first_name, last_name
FROM Customers c
WHERE EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.customer_id = c.customer_id
    AND o.item = 'Laptop'
);

-- =========================
-- End of  Script
-- =========================
