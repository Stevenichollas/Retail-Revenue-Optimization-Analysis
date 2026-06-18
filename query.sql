-- ====================================================================
-- E-COMMERCE RETAIL REVENUE OPTIMIZATION DATABASE SETUP & ANALYTICS
-- ====================================================================

-- STEP 1: CREATE RELATIONAL TABLES WITH STRICT CONSTRAINT INTEGRITY
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_city VARCHAR(100),
    customer_state VARCHAR(50)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_category VARCHAR(100),
    unit_price DECIMAL(10, 2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    product_id INT REFERENCES products(product_id),
    order_date DATE,
    quantity INT,
    order_status VARCHAR(50)
);


-- STEP 2: STAKEHOLDER EXECUTIVE MASTER ANALYTICS PIPELINE
-- This query performs multi-table relational joins, isolates true realized revenue 
-- by dropping operational friction (cancelled orders), and serves as the backend 
-- data pipeline for the Excel Power Query reporting dashboard interface.

SELECT 
    o.order_id,
    o.order_date,
    o.order_status,
    o.quantity,
    p.product_id,
    p.product_category,
    p.unit_price,
    (o.quantity * p.unit_price) AS total_revenue, -- Computes true realized gross sales
    c.customer_id,
    c.customer_city,
    c.customer_state
FROM orders o
INNER JOIN products p ON o.product_id = p.product_id
INNER JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status <> 'Cancelled' -- Financial guardrail: Drops all cancelled entries
ORDER BY o.order_date ASC;