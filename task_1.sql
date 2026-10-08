CREATE DATABASE foodapp_db;
USE foodapp_db;

CREATE TABLE restaurants (
    restaurant_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(50),
    cuisine_type VARCHAR(50),
    rating DECIMAL(3,1)
);
INSERT INTO restaurants (name, city, cuisine_type, rating)
VALUES
('Spice Garden', 'Ahmedabad', 'Indian', 4.5),
('Pizza Palace', 'Mumbai', 'Italian', 4.2),
('Dragon Bowl', 'Surat', 'Chinese', 4.0),
('Burger Hub', 'Ahmedabad', 'Fast Food', 3.8),
('Royal Thali', 'Jaipur', 'Indian', 4.7),
('Sushi World', 'Mumbai', 'Japanese', 4.3);
UPDATE restaurants
SET rating = 4.8
WHERE restaurant_id = 1;
DELETE FROM restaurants
WHERE restaurant_id = 4;
SELECT *
FROM restaurants
ORDER BY rating DESC;