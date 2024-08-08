/*cerating tables*/
use bill_buddy;

CREATE TABLE `groups` (
    group_id INT AUTO_INCREMENT,
    group_name VARCHAR(255) NOT NULL,
    created_by INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (group_id),
    FOREIGN KEY (created_by) REFERENCES users(user_id) ON DELETE SET NULL
);


SHOW TABLES;
SELECT VERSION();

CREATE TABLE members (
    user_id INT,
    group_id INT,
    PRIMARY KEY (user_id, group_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (group_id) REFERENCES `groups`(group_id) ON DELETE CASCADE
);

CREATE TABLE expenses (
    expense_id INT AUTO_INCREMENT,
    group_id INT,
    payer_id INT,
    amount DECIMAL(10, 2) NOT NULL,
    description VARCHAR(255),
    date DATE,
    PRIMARY KEY (expense_id),
    FOREIGN KEY (group_id) REFERENCES `groups`(group_id) ON DELETE CASCADE,
    FOREIGN KEY (payer_id) REFERENCES users(user_id) ON DELETE SET NULL
);

CREATE TABLE expense_members (
    expense_id INT,
    user_id INT,
    amount_owed DECIMAL(10, 2),
    PRIMARY KEY (expense_id, user_id),
    FOREIGN KEY (expense_id) REFERENCES expenses(expense_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS `groups`;




/*inserting records in each table*/


INSERT INTO users (firstname, lastname, email, password, dob, phno, gender, address) VALUES
('Dhanush', 'Ramadoss', 'dhanush@example.com', 'password123', '1999-04-13', '7169398230', 'male', '15 Englewood Avenue, Buffalo, NY, 14214'),
('Manish', 'Ramadoss', 'manish@example.com', 'password456', '2004-06-23', '1234567890', 'male', '15 Englewood Avenue, Buffalo, NY, 14214'),
('Ravi', 'Kumar', 'ravi.kumar@example.com', 'password789', '1990-12-01', '9876543210', 'male', '23 Elm Street, Buffalo, NY, 14215'),
('Sita', 'Devi', 'sita.devi@example.com', 'password321', '1995-08-20', '5556667777', 'female', '45 Maple Street, Buffalo, NY, 14216'),
('Gita', 'Singh', 'gita.singh@example.com', 'password654', '1988-11-10', '8889990000', 'female', '78 Oak Avenue, Buffalo, NY, 14217');


INSERT INTO `groups` (group_name, created_by) VALUES
('Family Trip', 1),
('Work Project', 2),
('Book Club', 3),
('Gym Buddies', 4),
('Travel Enthusiasts', 5);


INSERT INTO members (user_id, group_id) VALUES
(1, 1),  
(2, 1),  
(3, 2),  
(4, 3),  
(5, 4);  



INSERT INTO expenses (group_id, payer_id, amount, description, date) VALUES
(1, 1, 100.00, 'Hotel booking', '2024-07-01'),
(1, 2, 50.00, 'Dinner', '2024-07-02'),
(2, 3, 200.00, 'Office supplies', '2024-07-05'),
(3, 4, 30.00, 'Book purchase', '2024-07-10'),
(4, 5, 75.00, 'Gym membership', '2024-07-15');




INSERT INTO expense_members (expense_id, user_id, amount_owed) VALUES
(1, 1, 50.00),
(1, 2, 50.00);


INSERT INTO expense_members (expense_id, user_id, amount_owed) VALUES
(2, 1, 25.00),
(2, 2, 25.00);


INSERT INTO expense_members (expense_id, user_id, amount_owed) VALUES
(3, 3, 100.00),
(3, 4, 100.00);


INSERT INTO expense_members (expense_id, user_id, amount_owed) VALUES
(4, 4, 15.00),
(4, 5, 15.00);


INSERT INTO expense_members (expense_id, user_id, amount_owed) VALUES
(5, 5, 37.50),
(5, 1, 37.50);

