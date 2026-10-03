# Project Insights

## Q1. Overall business KPIs
**Result:** 96,478 delivered orders | 93,358 unique customers | R$13.22M revenue | R$137.04 average order value

**Insight:** The marketplace made about R$13.2 million from 96,478 delivered orders, and the average order was worth about R$137. The number of unique customers (93,358) is only slightly lower than the number of orders. This means almost every customer bought just once, which points to a repeat purchase problem. I will confirm this with the repeat rate query (Q9) and the cohort analysis.

**Note:** Only delivered orders are counted. All amounts are in Brazilian reais (R$).

## Q2. Monthly revenue trend
**Result:** Revenue grew from R$111,798 in Jan 2017 to R$924,645 in Jan 2018. The highest month was Nov 2017 with R$987,765 from 7,289 orders (+52.4% over October). After Mar 2018 it stayed between about R$0.83M and R$0.98M per month.

**Insight:** The business grew very fast through 2017. January 2018 revenue was about 8 times January 2017. The biggest jump was in November 2017, which is most likely Black Friday shopping, and December dropped 26.5% right after it. From March 2018 the growth slowed down and revenue moved sideways (for example +0.4% in May and -12.4% in June). So the marketplace is bringing in a lot of orders but is no longer growing quickly, which is why retention matters more now.

**Note:** Sep 2016 to Dec 2016 have very few orders (Nov 2016 has none), so the huge growth percentages in early months (like Jan 2017) are not meaningful. I only use Jan 2017 to Aug 2018 for trend conclusions.

## Q3. Revenue by product category (Pareto)
**Result:** 74 categories in total. Top 5: health_beauty (R$1.23M, 9.33%), watches_gifts (R$1.17M, 8.82%), bed_bath_table (R$1.02M, 7.74%), sports_leisure (R$0.95M, 7.22%) and computers_accessories (R$0.89M, 6.72%). The top 5 together make 39.83% of revenue and the top 10 make 62.43%.

**Insight:** Revenue is spread over a fairly wide range of categories, with no single category above 10%. It takes 18 categories (about 24% of all categories) to reach 80% of revenue, so it is close to the 80/20 rule but a little less concentrated. The last 50 or so categories each bring less than 1% of revenue. Watches_gifts is second even though it is not an everyday category, which probably means these products have a higher price per item. The business should focus marketing on the top 10 categories and review whether the very small categories are worth keeping.

**Note:** 1.29% of revenue (R$170,727) is in an "unknown" category because some products have no category name. A few category names also have spelling mistakes in the original data (for example "costruction_tools_garden"). I will mention this in the cleaning section.

## Q4. Top 10 sellers by revenue
**Result:** The top seller earned R$226,988 from 1,124 orders. The top 10 sellers together earned R$1,754,800. 9 of the top 10 sellers are in the state of SP and 1 is in BA.

**Insight:** The top 10 sellers make about 13.3% of total revenue, even though there are over 3,000 sellers on the platform. So a very small group of sellers brings a noticeable share of sales, and losing a few of them would hurt. The sellers are also very concentrated in Sao Paulo (SP). One interesting case is the seller ranked #2 from BA: only 348 orders but R$217,940 revenue, around R$626 per order, while the seller ranked #3 (SP) needs 1,772 orders to earn R$196,882, around R$111 per order. This means the #2 seller sells high-value items, and the #3 seller sells many low-value items. The platform should keep its top sellers happy (fast shipping, good reviews) and also support sellers outside SP so that it depends less on one state.

## Q5. Revenue and freight cost by customer state
**Result:** SP made R$5.07M (38.3% of revenue), RJ R$1.76M and MG R$1.55M. These 3 states together make about 63.4% of all revenue. Freight cost as a percentage of price is lowest in SP (13.9%) and highest in MA (26.3%). Average item price is lowest in SP (R$109) and highest in PB (R$192).

**Insight:** The business depends heavily on the south-east of Brazil. SP alone brings almost 4 out of every 10 reais. The states that are far from the sellers (mostly north and north-east, like MA, RO, AM, SE, PI, TO) pay around 24 to 26% of the product price as freight, compared to only 14% in SP. These states also have fewer orders but a higher average item price. Expensive shipping may be stopping customers there from buying cheaper products, so offering free-shipping limits or regional warehouses could help the platform grow in these states.

**Note:** phpMyAdmin showed 25 of 27 states per page, so I checked the rest with "Show all" when needed.

## Q6. Delivery time and late deliveries by state
**Result:** SP has the fastest delivery (8.7 days average, 4.5% late). RR (29.3 days), AP (27.2) and AM (26.4) are the slowest. AL has the highest late rate at 21.4% with 24.5 days average, followed by MA at 17.4% and SE at 15.2%.

**Insight:** Delivery time depends a lot on the location of the customer. Customers in SP, MG and PR get their orders in 9 to 12 days, while customers in the north wait more than 3 weeks. Slow does not always mean late. AM, AP and RO take long but only about 3% of their orders are late, which means the estimated delivery date there is already set long. The real problem states are AL (21.4% late), MA (17.4%), SE (15.2%), PI (13.9%) and CE (13.8%), because delivery there is both slow and often later than promised. RJ also needs attention. It is the second biggest market (12,350 orders) and 12.1% of its orders are late, which is almost 3 times the late rate of SP (4.5%).

**Note:** A delivery is counted as late only if it arrives on a later date than the estimated date. RR (41 orders) and AP (67 orders) have very few orders, so their percentages are not very reliable.

## Q7. Review score: on-time vs late deliveries
**Result:** On-time orders: 89,443 orders, average review 4.29, 9.2% got 1 or 2 stars. Late orders: 6,381 orders, average review 2.27, 62.4% got 1 or 2 stars.

**Insight:** Late delivery has a big effect on customer happiness. Late orders score 2.0 points lower on average, and more than 6 out of 10 late orders get a bad review (1 or 2 stars), against only 9.2% of on-time orders, which is about 7 times higher. Only about 6.7% of delivered orders are late, so fixing late deliveries is a small operational problem with a big impact on satisfaction. I will confirm this difference with a Mann-Whitney U test in Python to check it is statistically significant.

**Note:** My first version counted orders delivered on the promised day as late (the estimated date has no time of day, so a same-day delivery looked late). After I found this in the view output, I changed the rule to compare dates only. This reduced late orders from 7,661 to 6,381.

## Q8. Payment method mix
**Result:** Credit card: 76,505 orders, R$12.54M, 78.3% of payment value, 3.5 installments on average. Boleto: 19,784 orders, 17.9%. Voucher: 2.4%. Debit card: 1.4%.

**Insight:** Almost 4 out of 5 reais are paid by credit card, and customers split the payment into about 3 to 4 installments on average, so installments are an important feature for buyers. Boleto (a Brazilian bank slip payment) is the second option with about 18%. Debit card is very small at 1.4%. The platform should keep installment options on credit cards, and look at boleto customers separately because they pay in one go and may have different buying behaviour.

**Note:** This query covers all orders (not only delivered), and the payment value includes freight, so the total (about R$16.0M) is higher than the product revenue in Q1. An order can also use more than one payment type, so the order counts add up to more than the number of orders. 3 orders have the type "not_defined" with a value of 0, which I will treat as bad data.

## Q9. Repeat purchase rate
**Result:** 93,358 unique customers, 2,801 repeat customers, repeat rate 3.00%.

**Insight:** This is the main business problem. Only 3 out of every 100 customers ever placed a second order, so 97% bought just once. The platform spends effort to get new customers, but almost none of them come back. Even a small improvement, for example moving the repeat rate from 3% to 5% through follow-up emails or discount offers, would mean about 1,900 more repeat customers from the existing base. This result is also the starting point of my RFM and cohort retention analysis.

## Q10. Order status distribution
**Result:** Of 99,441 orders, 96,478 are delivered (97.02%). Shipped: 1,107 (1.11%), canceled: 625 (0.63%), unavailable: 609 (0.61%), invoiced: 314, processing: 301, created: 5, approved: 2.

**Insight:** The order process is mostly healthy, with 97 out of every 100 orders delivered. About 1.2% of orders (625 canceled + 609 unavailable = 1,234 orders) failed completely, and the "unavailable" ones likely mean the seller did not have the product in stock. A further 1,107 orders are still marked "shipped" and 622 are stuck in earlier steps (invoiced, processing, created or approved), so about 1.7% of orders never reached the customer in this data. Together these non-delivered orders explain almost all of the 2,965 missing delivery dates I found during data checking.

**Decision for cleaning:** For revenue, delivery and review analysis I keep only delivered orders, because the other statuses did not complete a sale or have no delivery date.

## Data quality check (analytical view, 99,441 orders)
**Result:** Orders with no item records: 775 (0.78%). Orders with no payment record: 1. Orders with no review: 768 (0.77%). Orders with no delivery date: 2,965 (2.98%).

**Insight:** The data is quite clean overall, and no column is missing more than 3% of its values. The 775 orders without items are most likely cancelled or unavailable orders, because an order that never shipped has no product lines. The 2,965 missing delivery dates match the 2,963 orders that were not delivered in the status count (Q10). Only 1 order has no payment record, which is too small to matter. About 768 orders never received a review, which is normal because customers do not always review.

**Decisions:**
- Revenue and delivery analysis uses delivered orders that have a delivery date and item records only.
- Orders without a review are kept in the data and left out only from the review score analysis, so I do not lose revenue information.
- The view was checked: it returns 99,441 rows, equal to the orders table, so joining payments, items and reviews did not create duplicate rows.