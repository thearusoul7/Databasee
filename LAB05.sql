CREATE TABLE employees(
    employee_id INTEGER,
    first_name TEXT,
    last_name TEXT,
    age INTEGER CHECK (age BETWEEN 18 AND 65),
    salary NUMERIC CHECK ( salary > 0 )
);
CREATE TABLE products_catalog(
    product_id INTEGER ,
    product_name TEXT,
    regular_price NUMERIC,
    discount_price NUMERIC,
    CONSTRAINT valid_discount
        CHECK (regular_price >0
                   AND discount_price>0
                   AND discount_price < regular_price)
);
CREATE TABLE bookings (
    booking_id INTEGER,
    check_in_date DATE,
    check_out_date DATE,
    num_guests INTEGER,
    CHECK ( num_guests BETWEEN 1 AND 10),
    CHECK ( check_out_date > check_in_date )
);
INSERT INTO employees VALUES
(1,'John','Smith',25,3000),
(2,'Anna','Brown',40,5000);

INSERT INTO employees VALUES
(3, 'Mike', 'Lee', 16, 2500);
INSERT INTO employees VALUES
(4, 'Tom', 'White', 30, 0);

INSERT INTO products_catalog VALUES
(1, 'Laptop', 1000, 900),
(2, 'Phone', 800, 700);
INSERT INTO products_catalog VALUES
(3, 'Tablet', 500, 600);
INSERT INTO products_catalog VALUES
(4, 'Watch', 0, 100);

INSERT INTO bookings VALUES
(1, '2026-10-10', '2026-10-15', 2),
(2, '2026-11-01', '2026-11-05', 5);
INSERT INTO bookings VALUES
(3, '2026-10-10', '2026-10-15', 11);
INSERT INTO bookings VALUES
(4, '2026-10-15', '2026-10-10', 2);

CREATE TABLE customers (
    customer_id  INTEGER NOT NULL,
    email TEXT    NOT NULL,
    phone TEXT,
    registration_date DATE NOT NULL
);

CREATE TABLE inventory (
    item_id      INTEGER   NOT NULL,
    item_name    TEXT      NOT NULL,
    quantity     INTEGER   NOT NULL CHECK (quantity >= 0),
    unit_price   NUMERIC   NOT NULL CHECK (unit_price > 0),
    last_updated TIMESTAMP NOT NULL
);
INSERT INTO customers (customer_id, email, phone, registration_date)
VALUES (1, 'alice@example.com', '+7-700-111-2233', '2025-01-15');

INSERT INTO customers (customer_id, email, phone, registration_date)
VALUES (2, 'bob@example.com', '+7-701-444-5566', '2025-02-20');

INSERT INTO inventory (item_id, item_name, quantity, unit_price, last_updated)
VALUES (1, 'Keyboard', 50, 25.99, '2025-03-01 10:00:00');

INSERT INTO inventory (item_id, item_name, quantity, unit_price, last_updated)
VALUES (2, 'Mouse', 0, 12.50, '2025-03-02 11:30:00');   -- quantity = 0 допустимо

INSERT INTO customers (customer_id, email, phone, registration_date)
VALUES (3, 'carol@example.com', NULL, '2025-03-10');

CREATE TABLE users (
    user_id INTEGER,
    username TEXT UNIQUE,
    email TEXT UNIQUE,
    created_at TIMESTAMP
);
CREATE TABLE course_enrollments (
    enrollment_id INTEGER,
    student_id INTEGER,
    course_code TEXT,
    semester TEXT,
    UNIQUE (student_id, course_code, semester)
);
INSERT INTO course_enrollments VALUES (1, 101, 'CS101', 'Fall 2025');
INSERT INTO course_enrollments VALUES (2, 101, 'CS102', 'Fall 2025');
INSERT INTO course_enrollments VALUES (3, 101, 'CS101', 'Spring 2026');
INSERT INTO course_enrollments VALUES (4, 102, 'CS101', 'Fall 2025');

ALTER TABLE users DROP CONSTRAINT users_username_key;
ALTER TABLE users DROP CONSTRAINT users_email_key;

ALTER TABLE users ADD CONSTRAINT unique_username UNIQUE (username);
ALTER TABLE users ADD CONSTRAINT unique_email    UNIQUE (email);

INSERT INTO users (user_id, username, email, created_at)
VALUES (1, 'alice', 'alice@example.com', NOW());
INSERT INTO users (user_id, username, email, created_at)
VALUES (2, 'bob', 'bob@example.com', NOW());

INSERT INTO users (user_id, username, email, created_at) VALUES (4, NULL, NULL, NOW());
INSERT INTO users (user_id, username, email, created_at) VALUES (5, NULL, NULL, NOW());

CREATE TABLE departments (
    dept_id INTEGER PRIMARY KEY,
    dept_name TEXT NOT NULL,
    location TEXT
);

INSERT INTO departments (dept_id, dept_name, location) VALUES (1, 'Engineering', 'Almaty');
INSERT INTO departments (dept_id, dept_name, location) VALUES (2, 'Marketing',   'Astana');
INSERT INTO departments (dept_id, dept_name, location) VALUES (3, 'Finance',     'Shymkent');

CREATE TABLE student_courses (
    student_id INTEGER,
    course_id  INTEGER,
    enrollment_date DATE,
    grade  TEXT,
    PRIMARY KEY (student_id, course_id)
);

INSERT INTO student_courses VALUES (1, 10, '2025-09-01', 'A');
INSERT INTO student_courses VALUES (1, 11, '2025-09-01', 'B');
INSERT INTO student_courses VALUES (2, 10, '2025-09-02', 'A-');

CREATE TABLE employees_dept (
    emp_id    INTEGER PRIMARY KEY,
    emp_name  TEXT NOT NULL,
    dept_id   INTEGER REFERENCES departments,
    hire_date DATE
);

INSERT INTO employees_dept VALUES (1, 'John Smith', 1, '2024-03-15');
INSERT INTO employees_dept VALUES (2, 'Jane Doe',   2, '2024-06-01');

CREATE TABLE authors (
    author_id INTEGER PRIMARY KEY,
    author_name TEXT NOT NULL,
    country TEXT
);

CREATE TABLE publishers (
    publisher_id INTEGER PRIMARY KEY,
    publisher_name TEXT NOT NULL,
    city  TEXT
);

CREATE TABLE books (
    book_id INTEGER PRIMARY KEY,
    title  TEXT NOT NULL,
    author_id  INTEGER REFERENCES authors,
    publisher_id  INTEGER REFERENCES publishers,
    publication_year INTEGER,
    isbn             TEXT UNIQUE
);
INSERT INTO authors (author_id, author_name, country) VALUES
    (1, 'Leo Tolstoy',     'Russia'),
    (2, 'Abai Kunanbayev', 'Kazakhstan'),
    (3, 'George Orwell',   'United Kingdom'),
    (4, 'Mukhtar Auezov',  'Kazakhstan');

INSERT INTO publishers (publisher_id, publisher_name, city) VALUES
    (1, 'Penguin Books', 'London'),
    (2, 'Zhazushy',      'Almaty'),
    (3, 'Vintage',       'New York');

INSERT INTO books (book_id, title, author_id, publisher_id, publication_year, isbn) VALUES
    (1, 'War and Peace', 1, 1, 1869, '978-0-14-044793-4'),
    (2, 'Words of Abai', 2, 2, 1995, '978-601-00-0001-1'),
    (3, '1984',          3, 1, 1949, '978-0-452-28423-4'),
    (4, 'Abai Zholy',    4, 2, 1947, '978-601-00-0002-8'),
    (5, 'Animal Farm',   3, 3, 1945, '978-0-452-28424-1');

CREATE TABLE categories (
    category_id INTEGER PRIMARY KEY,
    category_name TEXT NOT NULL
);

CREATE TABLE products_fk (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT NOT NULL,
    category_id  INTEGER REFERENCES categories ON DELETE RESTRICT
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    order_date DATE NOT NULL
);


CREATE TABLE order_items (
    item_id INTEGER PRIMARY KEY,
    order_id INTEGER REFERENCES orders ON DELETE CASCADE,
    product_id INTEGER REFERENCES products_fk,
    quantity  INTEGER CHECK (quantity > 0)
);
INSERT INTO categories VALUES (1, 'Electronics');
INSERT INTO categories VALUES (2, 'Books');
INSERT INTO categories VALUES (3, 'Toys');            -- без товаров

INSERT INTO products_fk VALUES (1, 'Laptop',     1);
INSERT INTO products_fk VALUES (2, 'Smartphone', 1);
INSERT INTO products_fk VALUES (3, 'Novel',      2);

INSERT INTO orders VALUES (1, '2025-04-01');
INSERT INTO orders VALUES (2, '2025-04-02');

INSERT INTO order_items VALUES (1, 1, 1, 1);
INSERT INTO order_items VALUES (2, 1, 3, 2);
INSERT INTO order_items VALUES (3, 2, 2, 1);

DELETE FROM categories WHERE category_id = 3;

SELECT * FROM order_items WHERE order_id = 1;
DELETE FROM orders WHERE order_id = 1;
SELECT * FROM order_items WHERE order_id = 1;
DROP TABLE IF EXISTS order_details CASCADE;
DROP TABLE IF EXISTS order_items   CASCADE;
DROP TABLE IF EXISTS orders        CASCADE;
DROP TABLE IF EXISTS products      CASCADE;
DROP TABLE IF EXISTS customers     CASCADE;

CREATE TABLE customers (
    customer_id  SERIAL PRIMARY KEY,
    name   TEXT NOT NULL,
    email   TEXT NOT NULL UNIQUE,
    phone TEXT,
    registration_date DATE NOT NULL DEFAULT CURRENT_DATE
);
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name  TEXT NOT NULL,
    description TEXT,
    price NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    stock_quantity INTEGER NOT NULL CHECK (stock_quantity >= 0)
);

CREATE TABLE orders (
    order_id  SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES customers ON DELETE RESTRICT,
    order_date DATE    NOT NULL DEFAULT CURRENT_DATE,
    total_amount NUMERIC(12,2) NOT NULL CHECK (total_amount >= 0),
    status TEXT NOT NULL DEFAULT 'pending'
            CHECK (status IN ('pending','processing','shipped','delivered','cancelled'))
);

CREATE TABLE order_details (
    order_detail_id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES orders   ON DELETE CASCADE,
    product_id  INTEGER NOT NULL REFERENCES products ON DELETE RESTRICT,
    quantity  INTEGER NOT NULL CHECK (quantity > 0),
    unit_price  NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0)
);

INSERT INTO customers (name, email, phone, registration_date) VALUES
    ('Aigerim Nurlan', 'aigerim@example.com', '+7-701-111-1111', '2025-01-10'),
    ('Dmitry Ivanov',  'dmitry@example.com',  '+7-702-222-2222', '2025-02-05'),
    ('Sara Johnson',   'sara@example.com',    NULL,              '2025-02-18'),
    ('Timur Bekov',    'timur@example.com',   '+7-705-444-4444', '2025-03-03'),
    ('Maria Petrova',  'maria@example.com',   '+7-707-555-5555', '2025-03-21');

INSERT INTO products (name, description, price, stock_quantity) VALUES
    ('Laptop',      '15-inch laptop, 16GB RAM',   899.99, 25),
    ('Smartphone',  '128GB, dual SIM',            499.50, 60),
    ('Headphones',  'Wireless, noise cancelling',  79.90, 120),
    ('USB-C Cable', '1 meter braided cable',        9.99, 500),
    ('Backpack',    'Water-resistant, 25L',        39.00, 80);

INSERT INTO orders (customer_id, order_date, total_amount, status) VALUES
    (1, '2025-04-01', 979.89, 'delivered'),
    (2, '2025-04-03', 499.50, 'shipped'),
    (3, '2025-04-05',  89.89, 'processing'),
    (4, '2025-04-07',  78.00, 'pending'),
    (5, '2025-04-08',  79.90, 'cancelled');

INSERT INTO order_details (order_id, product_id, quantity, unit_price) VALUES
    (1, 1, 1, 899.99),
    (1, 3, 1,  79.90),
    (2, 2, 1, 499.50),
    (3, 3, 1,  79.90),
    (3, 4, 1,   9.99),
    (4, 5, 2,  39.00),
    (5, 3, 1,  79.90);

SELECT COUNT(*) FROM order_details WHERE order_id = 5;
DELETE FROM orders WHERE order_id = 5;
SELECT COUNT(*) FROM order_details WHERE order_id = 5;
INSERT INTO products (name, description, price, stock_quantity)
VALUES ('Free Sample', 'Promo item', 0, 0);

SELECT o.order_id, c.name AS customer, o.status, o.total_amount
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
ORDER BY o.order_id;

SELECT od.order_id, p.name AS product, od.quantity, od.unit_price
FROM order_details od
JOIN products p ON p.product_id = od.product_id
ORDER BY od.order_id, od.order_detail_id;



