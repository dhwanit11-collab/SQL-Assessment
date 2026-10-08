CREATE DATABASE IF NOT EXISTS foodapp_db;
USE foodapp_db;
CREATE TABLE restaurants (
    restaurant_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    cuisine_type VARCHAR(50) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE menu_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    category VARCHAR(50) NOT NULL,
    FOREIGN KEY (restaurant_id)
        REFERENCES restaurants(restaurant_id)
);
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    restaurant_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (restaurant_id)
        REFERENCES restaurants(restaurant_id),
    FOREIGN KEY (item_id)
        REFERENCES menu_items(item_id)
);
INSERT INTO restaurants
(name, city, cuisine_type)
VALUES
('Spice Garden', 'Ahmedabad', 'Indian'),
('Pizza Palace', 'Mumbai', 'Italian'),
('Dragon Bowl', 'Surat', 'Chinese');
INSERT INTO menu_items
(restaurant_id, item_name, price, category)
VALUES
(1, 'Paneer Tikka', 250.00, 'Starter'),
(1, 'Veg Biryani', 200.00, 'Main Course'),
(1, 'Gulab Jamun', 80.00, 'Dessert'),
(1, 'Masala Chai', 40.00, 'Beverage'),
(2, 'Margherita Pizza', 300.00, 'Main Course'),
(2, 'Garlic Bread', 150.00, 'Starter'),
(2, 'Chocolate Brownie', 120.00, 'Dessert'),
(2, 'Cold Coffee', 100.00, 'Beverage'),
(3, 'Veg Manchurian', 180.00, 'Starter'),
(3, 'Hakka Noodles', 220.00, 'Main Course'),
(3, 'Ice Cream', 90.00, 'Dessert'),
(3, 'Lemon Soda', 60.00, 'Beverage');
INSERT INTO orders
(customer_name, restaurant_id, item_id, quantity, total_amount, order_date)
VALUES
('Aarav', 1, 1, 2, 500.00, '2026-10-01 10:00:00'),
('Diya', 1, 2, 1, 200.00, '2026-10-01 11:00:00'),
('Rohan', 1, 3, 3, 240.00, '2026-10-02 12:00:00'),
('Priya', 1, 4, 2, 80.00, '2026-10-02 13:00:00'),
('Krish', 1, 1, 1, 250.00, '2026-10-03 14:00:00'),
('Neha', 2, 5, 2, 600.00, '2026-10-03 15:00:00'),
('Arjun', 2, 6, 2, 300.00, '2026-10-04 16:00:00'),
('Meera', 2, 7, 1, 120.00, '2026-10-04 17:00:00'),
('Ishaan', 2, 8, 3, 300.00, '2026-10-05 18:00:00'),
('Kavya', 2, 5, 1, 300.00, '2026-10-05 19:00:00'),
('Vivaan', 3, 9, 2, 360.00, '2026-10-06 10:00:00'),
('Ananya', 3, 10, 1, 220.00, '2026-10-06 11:00:00'),
('Rahul', 3, 11, 2, 180.00, '2026-10-07 12:00:00'),
('Sneha', 3, 12, 3, 180.00, '2026-10-07 13:00:00'),
('Dev', 3, 10, 2, 440.00, '2026-10-08 14:00:00');
CREATE VIEW restaurant_sales_summary AS
SELECT
    r.name AS restaurant_name,
    COUNT(o.order_id) AS total_orders,
    COALESCE(SUM(o.total_amount), 0) AS total_revenue
FROM restaurants r
LEFT JOIN orders o
    ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_id, r.name;
SELECT * FROM restaurant_sales_summary;
DROP PROCEDURE IF EXISTS add_order;
DELIMITER //
CREATE PROCEDURE add_order(
    IN p_customer_name VARCHAR(100),
    IN p_restaurant_id INT,
    IN p_item_id INT,
    IN p_quantity INT
)
BEGIN
    DECLARE v_price DECIMAL(10,2);
    DECLARE v_total DECIMAL(10,2);
    DECLARE v_restaurant_count INT DEFAULT 0;
    DECLARE v_item_restaurant_id INT DEFAULT NULL;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    START TRANSACTION;
    SELECT COUNT(*)
    INTO v_restaurant_count
    FROM restaurants
    WHERE restaurant_id = p_restaurant_id;
    IF v_restaurant_count = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Restaurant does not exist';
    END IF;
    IF p_quantity <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Quantity must be greater than zero';
    END IF;
    SET v_price = NULL;
    SELECT price, restaurant_id
    INTO v_price, v_item_restaurant_id
    FROM menu_items
    WHERE item_id = p_item_id;
    IF v_item_restaurant_id IS NULL
       OR v_item_restaurant_id <> p_restaurant_id THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid menu item for this restaurant';
    END IF;
    SET v_total = v_price * p_quantity;
    INSERT INTO orders
        (customer_name, restaurant_id, item_id,
         quantity, total_amount, order_date)
    VALUES
        (p_customer_name, p_restaurant_id, p_item_id,
         p_quantity, v_total, NOW());
    COMMIT;
END //
DELIMITER ;
CREATE TABLE order_audit (
    order_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    action VARCHAR(10) NOT NULL,
    log_time DATETIME NOT NULL
);
DROP TRIGGER IF EXISTS after_order_insert;
DELIMITER //
CREATE TRIGGER after_order_insert
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    INSERT INTO order_audit
        (order_id, restaurant_id, action, log_time)
    VALUES
        (NEW.order_id, NEW.restaurant_id, 'INSERT', NOW());
END //
DELIMITER ;
CALL add_order('Dhruv', 1, 1, 2);
SELECT *
FROM orders
ORDER BY order_id DESC
LIMIT 1;
SELECT *
FROM order_audit
ORDER BY log_time DESC
LIMIT 1;
SELECT *
FROM restaurant_sales_summary;