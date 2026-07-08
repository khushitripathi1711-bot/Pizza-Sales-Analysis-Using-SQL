-- ======================================================
-- Project : Pizza Sales Analysis Using SQL
-- Author  : Shruti Tiwari
-- Database: pizza_project
-- ======================================================

USE pizza_project;

-- Q1.Retrieve the total number of orders placed.
SELECT 
    COUNT(order_id) AS total_number_of_orders
FROM
    orders;

-- Q2.Calculate the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(quantity * price), 2) AS Total_Revenue
FROM
    order_details od
        JOIN
    pizzas p ON od.pizza_id = p.pizza_id;
 
 -- Q3.Identify the highest-priced pizza.
SELECT 
    pt.name, p.price
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
ORDER BY price DESC
LIMIT 1

-- Q4.Identify the most common pizza size ordered.
SELECT 
    p.size AS most_common_ordered_pizza_size,
    COUNT(od.order_details_id) AS order_count
FROM
    pizzas p
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY size
ORDER BY order_count DESC
LIMIT 1;

-- Q5.List the top 5 most ordered pizza types along with their quantities.
SELECT 
    pt.name, SUM(od.quantity) AS quantity
FROM
    pizza_types as pt
        JOIN
    pizzas as p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details as od ON od.pizza_id = p.pizza_id
GROUP BY pt.name
ORDER BY quantity DESC
LIMIT 5;

-- Q6.Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT 
    pt.category, SUM(od.quantity) AS Quantity
FROM
    pizza_types AS pt
        JOIN
    pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details AS od ON p.pizza_id = od.pizza_id
GROUP BY pt.category;

-- Q7.Analyze the order data to determine the busiest hours of the day based on the total number of orders placed.
SELECT 
    HOUR(order_time) AS order_hour,
    COUNT(order_id) AS total_orders
FROM
    orders
GROUP BY HOUR(order_time)
ORDER BY total_orders DESC;

-- Q8.Calculate the average order value by dividing the total revenue by the total number of orders.
SELECT 
    SUM(od.quantity * p.price) / COUNT(DISTINCT od.order_id)
FROM
    pizzas AS p
        JOIN
    order_details AS od ON p.pizza_id = od.pizza_id
    
-- Q9.Analyze the monthly sales trend by calculating the total revenue generated in each month and identify the highest-performing month.
SELECT
    monthname(o.order_date) AS month,
    ROUND(SUM(od.quantity * p.price), 2) AS total_revenue
FROM orders o
JOIN order_details od
    ON o.order_id = od.order_id
JOIN pizzas p
    ON od.pizza_id = p.pizza_id
GROUP BY monthname(o.order_date)
ORDER BY total_revenue DESC;

-- Q10.Join the necessary tables to find the total quantity of pizzas sold for each pizza size and rank the sizes from highest to lowest based on total quantity sold.
SELECT 
    p.size, SUM(od.quantity) AS total_quantity_sold
FROM
    pizzas AS p
        JOIN
    order_details AS od ON p.pizza_id = od.pizza_id
GROUP BY p.size
ORDER BY total_quantity_sold DESC;

-- Q11.Calculate the percentage contribution of each pizza category to the total revenue generated.
SELECT 
    pt.category,
    SUM(od.quantity * p.price) AS total_revenue,
    (SUM(od.quantity * p.price) / (SELECT 
            SUM(od2.quantity * p2.price)
        FROM
            order_details od2
                JOIN
            pizzas p2 ON od2.pizza_id = p2.pizza_id) * 100) AS revenue_percentage
FROM
    pizza_types AS pt
        JOIN
    pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details AS od ON p.pizza_id = od.pizza_id
GROUP BY pt.category
ORDER BY revenue_percentage DESC;

-- Q12.calculate the average number of pizzas ordered per day
SELECT 
    AVG(total_pizzas) AS avg_pizzas_per_day
FROM
    (SELECT 
        order_date, SUM(od.quantity) AS total_pizzas
    FROM
        orders AS o
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY order_date) AS daily_orders;

