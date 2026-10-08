USE foodapp_db;
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT,
    customer_name VARCHAR(100),
    total_amount DECIMAL(10,2),
    order_date DATETIME,
    FOREIGN KEY (restaurant_id)
        REFERENCES restaurants(restaurant_id)
);
INSERT INTO orders
(restaurant_id, customer_name, total_amount, order_date)
VALUES
(1, 'Aarav', 1200.00, '2026-10-01 10:30:00'),
(1, 'Diya', 1800.00, '2026-10-02 12:00:00'),
(1, 'Rohan', 2500.00, '2026-10-03 14:15:00'),
(2, 'Priya', 2200.00, '2026-10-04 11:00:00'),
(2, 'Krish', 1500.00, '2026-10-05 13:30:00'),
(2, 'Neha', 2800.00, '2026-10-06 19:00:00'),
(3, 'Arjun', 900.00, '2026-10-07 12:15:00'),
(3, 'Meera', 1600.00, '2026-10-08 15:00:00'),
(3, 'Ishaan', 2100.00, '2026-10-09 18:30:00'),
(5, 'Ananya', 3000.00, '2026-10-10 13:00:00'),
(5, 'Vivaan', 2500.00, '2026-10-11 16:45:00'),
(5, 'Kavya', 1800.00, '2026-10-12 20:00:00');
SELECT
    r.restaurant_id,
    r.name AS restaurant_name,
    SUM(o.total_amount) AS total_revenue,
    AVG(o.total_amount) AS average_order_value
FROM restaurants r
JOIN orders o
    ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_id, r.name;
SELECT
    r.restaurant_id,
    r.name AS restaurant_name,
    SUM(o.total_amount) AS total_revenue
FROM restaurants r
JOIN orders o
    ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_id, r.name
HAVING SUM(o.total_amount) > 5000;
SELECT *
FROM orders
ORDER BY order_date DESC
LIMIT 5;