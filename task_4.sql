USE foodapp_db;
CREATE TABLE IF NOT EXISTS customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    wallet_balance DECIMAL(10,2) NOT NULL
);
INSERT INTO customers (customer_id, customer_name, wallet_balance)
VALUES
(1, 'Aarav', 5000.00),
(2, 'Diya', 1000.00);
CREATE TABLE IF NOT EXISTS orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    restaurant_id INT,
    amount DECIMAL(10,2),
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP
);
DROP PROCEDURE IF EXISTS place_order;
DELIMITER //
CREATE PROCEDURE place_order(
    IN p_customer_id INT,
    IN p_restaurant_id INT,
    IN p_amount DECIMAL(10,2)
)
BEGIN
    DECLARE v_balance DECIMAL(10,2);
    DECLARE v_not_found BOOLEAN DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_not_found = TRUE;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    START TRANSACTION;
    SELECT wallet_balance
    INTO v_balance
    FROM customers
    WHERE customer_id = p_customer_id
    FOR UPDATE;
    IF v_not_found THEN
        ROLLBACK;
        SELECT 'Customer not found. Order cancelled.'
            AS result;
    ELSEIF p_amount <= 0 THEN
        ROLLBACK;
        SELECT 'Invalid amount. Order cancelled.'
            AS result;
    ELSEIF v_balance < p_amount THEN
        ROLLBACK;
        SELECT 'Insufficient wallet balance. Order cancelled.'
            AS result;
    ELSE
        UPDATE customers
        SET wallet_balance = wallet_balance - p_amount
        WHERE customer_id = p_customer_id;
        INSERT INTO orders
            (customer_id, restaurant_id, amount, order_date)
        VALUES
            (p_customer_id, p_restaurant_id, p_amount, NOW());
        COMMIT;
        SELECT 'Order placed successfully.' AS result;
    END IF;
END //
DELIMITER ;