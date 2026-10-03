-- =====================================================================
-- Olist E-Commerce Analysis: Clean analytical view (one row per order)
-- Database: olist (MariaDB 10.4)
--
-- Why pre-aggregate? order_items, order_payments and order_reviews can
-- each have several rows per order. Joining them directly would
-- duplicate rows and inflate revenue. Each table is summarised to one
-- row per order first, then joined.
-- =====================================================================

CREATE OR REPLACE VIEW vw_order_analysis AS
SELECT
    o.order_id,
    c.customer_unique_id,
    c.customer_city,
    c.customer_state,
    o.order_status,
    o.order_purchase_timestamp,
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')              AS order_month,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,

    -- Delivery metrics
    DATEDIFF(o.order_delivered_customer_date,
             o.order_purchase_timestamp)                          AS delivery_days,
    DATEDIFF(o.order_delivered_customer_date,
             o.order_estimated_delivery_date)                     AS delay_days,
    CASE
        WHEN o.order_delivered_customer_date IS NULL THEN NULL
        WHEN DATE(o.order_delivered_customer_date) > DATE(o.order_estimated_delivery_date) THEN 1
        ELSE 0
    END                                                           AS is_late,

    -- Order value metrics
    oi.items_count,
    oi.items_revenue,
    oi.freight_total,
    pay.payment_value_total,

    -- Customer satisfaction
    r.review_score
FROM orders o
JOIN customers c
       ON o.customer_id = c.customer_id
LEFT JOIN (
        SELECT order_id,
               COUNT(*)           AS items_count,
               SUM(price)         AS items_revenue,
               SUM(freight_value) AS freight_total
        FROM order_items
        GROUP BY order_id
     ) oi  ON o.order_id = oi.order_id
LEFT JOIN (
        SELECT order_id,
               SUM(payment_value) AS payment_value_total
        FROM order_payments
        GROUP BY order_id
     ) pay ON o.order_id = pay.order_id
LEFT JOIN (
        SELECT order_id,
               AVG(review_score)  AS review_score
        FROM order_reviews
        GROUP BY order_id
     ) r   ON o.order_id = r.order_id;


-- ---------------------------------------------------------------------
-- CHECKS (run these one at a time after creating the view)
-- ---------------------------------------------------------------------

-- Check 1: must return 99441 (same as the orders table = no duplicate rows)
SELECT COUNT(*) AS rows_in_view FROM vw_order_analysis;

-- Check 2: look at a few rows
SELECT * FROM vw_order_analysis LIMIT 10;

-- Check 3: missing values per column (document these in your cleaning step)
SELECT
    SUM(items_revenue IS NULL)                  AS missing_items,
    SUM(payment_value_total IS NULL)            AS missing_payments,
    SUM(review_score IS NULL)                   AS missing_reviews,
    SUM(order_delivered_customer_date IS NULL)  AS missing_delivery_date
FROM vw_order_analysis;
