-- Create a new user
CREATE USER rentaluser WITH PASSWORD 'rentalpassword';
-- Revoke all permissions in case a rentaluser has...
REVOKE ALL PRIVILEGES ON DATABASE dvdrental FROM rentaluser;
-- Grant CONNECT permission to a dvdrental database
GRANT CONNECT ON DATABASE dvdrental TO rentaluser;


-- Grant SELECT permission on the 'customer' table to 'rentaluser'
GRANT SELECT ON customer TO rentaluser;
-- Select all records from the 'customer' table
SELECT * FROM customer;


-- Create a new role/group called 'rental'
CREATE ROLE rental;
-- Add 'rentaluser' to the 'rental' group
GRANT rental TO rentaluser;


-- Grant INSERT and UPDATE permissions on the 'rental' table to the 'rental' group
GRANT INSERT, UPDATE ON rental TO rental;
-- Log in as a rentaluser (I used values in comments. Instead of them we can use any values we want)
-- insert a new row into the "rental" table
INSERT INTO rental (rental_id, rental_date, inventory_id, customer_id, return_date, staff_id, last_update)
VALUES ( next rental_id value */, /* rental_date */, /* inventory_id */, /* customer_id */, /* return_date */, /* staff_id */, CURRENT_TIMESTAMP);
-- update an existing row in the "rental" table
UPDATE rental
SET /* column_name */ = /* new_value */
WHERE /* condition to identify the row */;


-- Revoke INSERT permission from the 'rental' group on the 'rental' table
REVOKE INSERT ON rental FROM rental;
-- insert a new row into the "rental" table for checking purposes
INSERT INTO rental (rental_id, rental_date, inventory_id, customer_id, return_date, staff_id, last_update)
VALUES (/* values */);


--  Choose a customer
SELECT c.customer_id, c.first_name, c.last_name
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id
HAVING COUNT(p.payment_id) > 0 AND COUNT(r.rental_id) > 0
LIMIT 1;

-- Create a personalized role
-- You can replace 'John' and 'Doe' with your customer's first and last names
-- I have John Doe since I changed my customer table before
CREATE ROLE client_john_doe;

-- Grant usage on the schema (if necessary)
GRANT USAGE ON SCHEMA public TO client_john_doe;

-- Grant select on the necessary tables
GRANT SELECT ON payment, rental TO client_john_doe;

-- Set up row level security on these tables
ALTER TABLE payment ENABLE ROW LEVEL SECURITY;
ALTER TABLE rental ENABLE ROW LEVEL SECURITY;

-- Create policies to restrict data access
CREATE POLICY select_payment ON payment FOR SELECT TO client_john_doe USING (customer_id = (SELECT customer_id FROM customer WHERE first_name = 'John' AND last_name = 'Doe'));
CREATE POLICY select_rental ON rental FOR SELECT TO client_john_doe USING (customer_id = (SELECT customer_id FROM customer WHERE first_name = 'John' AND last_name = 'Doe'));


-- And now we can check:
SET ROLE client_john_doe;
-- Test query for payment table
SELECT * FROM payment;
-- Test query for rental table
SELECT * FROM rental;
-- reset role
RESET ROLE;






