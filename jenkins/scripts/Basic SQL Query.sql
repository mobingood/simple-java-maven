Basic SQL Query 

#bad sql Query
SELECT * FROM employees WHERE name = 'John'; 

Better 
CREATE INDEX idx_employee_name ON employee(name);

-- Bad
SELECT * 
FROM customers, orders
WHERE customers.id = orders.customer_id;

-- Better (explicit join + indexed columns)
SELECT c.name, o.order_date 
FROM customers c
INNER JOIN orders o ON c.id = o.customer_id;


-- Bad (filters late)
SELECT * FROM orders
WHERE YEAR(order_date) = 2024;

-- Better (uses index)
SELECT * FROM orders
WHERE order_date BETWEEN '2024-01-01' AND '2024-12-31';
