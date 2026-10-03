-- =====================================================================
-- Olist E-Commerce Analysis: Business Queries
-- Database: olist (MariaDB 10.4)
-- Run each query separately in phpMyAdmin (SQL tab, olist selected).
-- Late = delivered on a LATER DATE than the estimated date (time of day ignored).
-- Revenue = sum of item price (excludes freight) for DELIVERED orders,
-- unless a query says otherwise.
-- =====================================================================


-- ---------------------------------------------------------------------
-- Q1. Overall business KPIs
-- Business question: How big is the business?
-- ---------------------------------------------------------------------
SELECT
    COUNT(DISTINCT o.order_id)                              AS total_orders,
    COUNT(DISTINCT c.customer_unique_id)                    AS unique_customers,
    ROUND(SUM(oi.price), 2)                                 AS total_revenue,
    ROUND(SUM(oi.price) / COUNT(DISTINCT o.order_id), 2)    AS avg_order_value
FROM orders o
JOIN customers   c  ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id    = oi.order_id
WHERE o.order_status = 'delivered';


-- ---------------------------------------------------------------------
-- Q2. Monthly revenue, month-over-month growth and running total
-- Business question: Is revenue growing? Is there seasonality?
-- Skills: CTE + LAG() + running total window function
-- Note: 2016 months and the last 1-2 months of 2018 are incomplete.
-- ---------------------------------------------------------------------
WITH monthly AS (
    SELECT
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS order_month,
        COUNT(DISTINCT o.order_id)                       AS orders,
        ROUND(SUM(oi.price), 2)                          AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
)
SELECT
    order_month,
    orders,
    revenue,
    LAG(revenue) OVER (ORDER BY order_month)                       AS prev_month_revenue,
    ROUND((revenue - LAG(revenue) OVER (ORDER BY order_month))
          / LAG(revenue) OVER (ORDER BY order_month) * 100, 1)     AS mom_growth_pct,
    ROUND(SUM(revenue) OVER (ORDER BY order_month), 2)             AS running_total
FROM monthly
ORDER BY order_month;


-- ---------------------------------------------------------------------
-- Q3. Revenue by product category with Pareto (80/20) analysis
-- Business question: Which categories drive most of the revenue?
-- Skills: joins, COALESCE, window SUM() for cumulative share
-- ---------------------------------------------------------------------
WITH category_revenue AS (
    SELECT
        COALESCE(t.product_category_name_english,
                 p.product_category_name, 'unknown')  AS category,
        ROUND(SUM(oi.price), 2)                       AS revenue
    FROM order_items oi
    JOIN orders   o ON oi.order_id   = o.order_id
    JOIN products p ON oi.product_id = p.product_id
    LEFT JOIN category_translation t
           ON p.product_category_name = t.product_category_name
    WHERE o.order_status = 'delivered'
    GROUP BY COALESCE(t.product_category_name_english,
                      p.product_category_name, 'unknown')
)
SELECT
    category,
    revenue,
    ROUND(revenue / SUM(revenue) OVER () * 100, 2)                          AS revenue_share_pct,
    ROUND(SUM(revenue) OVER (ORDER BY revenue DESC)
          / SUM(revenue) OVER () * 100, 2)                                  AS cumulative_share_pct
FROM category_revenue
ORDER BY revenue DESC;
-- Insight to write: how many categories make up 80% of revenue?


-- ---------------------------------------------------------------------
-- Q4. Top 10 sellers by revenue
-- Business question: How dependent is the marketplace on a few sellers?
-- Skills: RANK() window function
-- ---------------------------------------------------------------------
SELECT
    RANK() OVER (ORDER BY SUM(oi.price) DESC) AS revenue_rank,
    oi.seller_id,
    s.seller_state,
    COUNT(DISTINCT oi.order_id)               AS orders,
    ROUND(SUM(oi.price), 2)                   AS revenue
FROM order_items oi
JOIN orders  o ON oi.order_id  = o.order_id
JOIN sellers s ON oi.seller_id = s.seller_id
WHERE o.order_status = 'delivered'
GROUP BY oi.seller_id, s.seller_state
ORDER BY revenue DESC
LIMIT 10;


-- ---------------------------------------------------------------------
-- Q5. Revenue and freight cost by customer state
-- Business question: Which regions earn the most, and where is shipping
-- expensive relative to the product price?
-- ---------------------------------------------------------------------
SELECT
    c.customer_state,
    COUNT(DISTINCT o.order_id)                        AS orders,
    ROUND(SUM(oi.price), 2)                           AS revenue,
    ROUND(AVG(oi.price), 2)                           AS avg_item_price,
    ROUND(SUM(oi.freight_value) / SUM(oi.price) * 100, 1) AS freight_pct_of_price
FROM orders o
JOIN customers   c  ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id    = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY revenue DESC;


-- ---------------------------------------------------------------------
-- Q6. Delivery performance by state
-- Business question: Where are deliveries slow or late?
-- ---------------------------------------------------------------------
SELECT
    c.customer_state,
    COUNT(*)                                                        AS delivered_orders,
    ROUND(AVG(DATEDIFF(o.order_delivered_customer_date,
                       o.order_purchase_timestamp)), 1)             AS avg_delivery_days,
    ROUND(AVG(DATE(o.order_delivered_customer_date) > DATE(o.order_estimated_delivery_date)) * 100, 1)          AS late_delivery_pct
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY avg_delivery_days DESC;


-- ---------------------------------------------------------------------
-- Q7. Review score: on-time vs late deliveries
-- Business question: Do late deliveries make customers unhappy?
-- (Some orders have more than one review, so reviews are averaged
--  per order first to avoid double counting.)
-- ---------------------------------------------------------------------
WITH review_per_order AS (
    SELECT order_id, AVG(review_score) AS review_score
    FROM order_reviews
    GROUP BY order_id
)
SELECT
    CASE WHEN DATE(o.order_delivered_customer_date) > DATE(o.order_estimated_delivery_date)
         THEN 'Late' ELSE 'On time' END           AS delivery_status,
    COUNT(*)                                      AS orders,
    ROUND(AVG(r.review_score), 2)                 AS avg_review_score,
    ROUND(AVG(r.review_score <= 2) * 100, 1)      AS pct_low_reviews_1_or_2
FROM orders o
JOIN review_per_order r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY CASE WHEN DATE(o.order_delivered_customer_date) > DATE(o.order_estimated_delivery_date)
              THEN 'Late' ELSE 'On time' END;
-- This is the evidence you test statistically in Python on Saturday.


-- ---------------------------------------------------------------------
-- Q8. Payment method mix
-- Business question: How do customers pay?
-- ---------------------------------------------------------------------
WITH payments AS (
    SELECT
        payment_type,
        COUNT(DISTINCT order_id)      AS orders,
        ROUND(SUM(payment_value), 2)  AS total_value,
        ROUND(AVG(payment_installments), 1) AS avg_installments
    FROM order_payments
    GROUP BY payment_type
)
SELECT
    payment_type,
    orders,
    total_value,
    ROUND(total_value / SUM(total_value) OVER () * 100, 1) AS share_of_value_pct,
    avg_installments
FROM payments
ORDER BY total_value DESC;


-- ---------------------------------------------------------------------
-- Q9. Repeat purchase rate
-- Business question: How many customers ever buy a second time?
-- Note: customer_id is new for every order; customer_unique_id
-- identifies the real person, so use that.
-- ---------------------------------------------------------------------
WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS orders
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    COUNT(*)                                       AS total_customers,
    SUM(orders > 1)                                AS repeat_customers,
    ROUND(SUM(orders > 1) / COUNT(*) * 100, 2)     AS repeat_rate_pct
FROM customer_orders;
-- Expect a very low number (a few percent). This is the retention problem.


-- ---------------------------------------------------------------------
-- Q10. Order status distribution
-- Business question: How many orders fail (cancelled, unavailable)?
-- Also explains most of the 2,965 missing delivery dates.
-- ---------------------------------------------------------------------
WITH status_counts AS (
    SELECT order_status, COUNT(*) AS orders
    FROM orders
    GROUP BY order_status
)
SELECT
    order_status,
    orders,
    ROUND(orders / SUM(orders) OVER () * 100, 2) AS pct_of_orders
FROM status_counts
ORDER BY orders DESC;
