USE foodapp_db;
CREATE TABLE restaurants (
    restaurant_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(50)
);
CREATE TABLE menu_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT,
    item_name VARCHAR(100),
    price DECIMAL(10,2),
    category VARCHAR(50),
    FOREIGN KEY (restaurant_id)
        REFERENCES restaurants(restaurant_id)
);
INSERT INTO restaurants (name, city)
VALUES
('Spice Garden', 'Ahmedabad'),
('Pizza Palace', 'Mumbai'),
('Dragon Bowl', 'Surat'),
('Royal Thali', 'Jaipur'),
('Food Corner', 'Ahmedabad');
INSERT INTO menu_items
(restaurant_id, item_name, price, category)
VALUES
(1, 'Paneer Tikka', 250.00, 'Starter'),
(1, 'Veg Biryani', 200.00, 'Main Course'),
(1, 'Masala Dosa', 120.00, 'Breakfast'),
(2, 'Margherita Pizza', 300.00, 'Pizza'),
(2, 'Farmhouse Pizza', 450.00, 'Pizza'),
(2, 'Garlic Bread', 150.00, 'Starter'),
(3, 'Veg Manchurian', 180.00, 'Starter'),
(3, 'Hakka Noodles', 220.00, 'Main Course'),
(3, 'Fried Rice', 200.00, 'Main Course'),
(4, 'Gujarati Thali', 280.00, 'Thali'),
(4, 'Dal Baati', 240.00, 'Main Course'),
(4, 'Gulab Jamun', 80.00, 'Dessert');
SELECT
    r.name AS restaurant_name,
    m.item_name,
    m.price
FROM restaurants r
INNER JOIN menu_items m
    ON r.restaurant_id = m.restaurant_id;
SELECT
    r.name AS restaurant_name,
    m.item_name,
    m.price,
    m.category
FROM restaurants r
LEFT JOIN menu_items m
    ON r.restaurant_id = m.restaurant_id;
CREATE VIEW restaurant_menu_summary AS
SELECT
    r.name AS restaurant_name,
    COUNT(m.item_id) AS total_menu_items,
    AVG(m.price) AS average_item_price
FROM restaurants r
LEFT JOIN menu_items m
    ON r.restaurant_id = m.restaurant_id
GROUP BY r.restaurant_id, r.name;SELECT * FROM restaurant_menu_summary;