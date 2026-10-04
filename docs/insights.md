# Project Insights

## Q1. Overall business KPIs
**Result:** 96,478 delivered orders | 93,358 unique customers | R$13.22M revenue | R$137.04 average order value

**Insight:** The marketplace made about R$13.2 million from 96,478 delivered orders, and the average order was worth about R$137. The number of unique customers (93,358) is only slightly lower than the number of orders. This means almost every customer bought just once, which points to a repeat purchase problem. I will confirm this with the repeat rate query (Q9) and the cohort analysis.

**Note:** Only delivered orders are counted. All amounts are in Brazilian reais (R$).

## Q2. Monthly revenue trend
**Result:** Revenue grew from R$111,798 in Jan 2017 to R$924,645 in Jan 2018. The highest month was Nov 2017 with R$987,765 from 7,289 orders (+52.4% over October). After Mar 2018 it stayed between about R$0.84M and R$0.98M per month.

**Insight:** The business grew very fast through 2017. January 2018 revenue was about 8 times January 2017. The biggest jump was in November 2017, which is most likely Black Friday shopping, and December dropped 26.5% right after it. From March 2018 the growth slowed down and revenue stayed almost flat (for example +0.4% in May and -12.4% in June). So the marketplace is bringing in a lot of orders but is no longer growing quickly, which is why retention matters more now.

**Note:** Sep 2016 to Dec 2016 have very few orders (Nov 2016 has none), so the huge growth percentages in early months (like Jan 2017) are not meaningful. I only use Jan 2017 to Aug 2018 for trend conclusions.

## Q3. Revenue by product category (80/20 rule)
**Result:** 74 categories in total. Top 5: health_beauty (R$1.23M, 9.33%), watches_gifts (R$1.17M, 8.82%), bed_bath_table (R$1.02M, 7.74%), sports_leisure (R$0.95M, 7.22%) and computers_accessories (R$0.89M, 6.72%). The top 5 together make 39.83% of revenue and the top 10 make 62.43%.

**Insight:** Revenue is spread over a fairly wide range of categories, with no single category above 10%. It takes 18 categories (about 24% of all categories) to reach 80% of revenue, so it is close to the 80/20 rule (80% of revenue from 20% of categories) but a little less concentrated. About 48 categories bring less than 1% of revenue each. Watches_gifts is second even though it is not an everyday category, which probably means these products have a higher price per item. The business should focus marketing on the top 10 categories and review whether the very small categories are worth keeping.

**Note:** 1.29% of revenue (R$170,727) is in an "unknown" category because some products have no category name. A few category names also have spelling mistakes in the original data (for example "costruction_tools_garden"). I will mention this in the cleaning section.

## Q4. Top 10 sellers by revenue
**Result:** The top seller earned R$226,988 from 1,124 orders. The top 10 sellers together earned R$1,754,800. 9 of the top 10 sellers are in the state of SP and 1 is in BA.

**Insight:** The top 10 sellers make about 13.3% of total revenue, even though there are over 3,000 sellers on the platform. So a very small group of sellers brings a noticeable share of sales, and losing a few of them would hurt. The sellers are also very concentrated in Sao Paulo (SP). One interesting case is the seller ranked #2 from BA: only 348 orders but R$217,940 revenue, around R$626 per order, while the seller ranked #3 (SP) needs 1,772 orders to earn R$196,882, around R$111 per order. This means the #2 seller sells high-value items, and the #3 seller sells many low-value items. The platform should keep its top sellers happy (fast shipping, good reviews) and also support sellers outside SP so that it depends less on one state.

## Q5. Revenue and freight cost by customer state
**Result:** SP made R$5.07M (38.3% of revenue), RJ R$1.76M and MG R$1.55M. These 3 states together make about 63.4% of all revenue. Freight cost as a percentage of price is lowest in SP (13.9%) and highest in MA (26.3%). Average item price is lowest in SP (R$109) and highest in PB (R$192).

**Insight:** The business depends heavily on the south-east of Brazil. SP alone brings almost 4 out of every 10 reais. The states that are far from the sellers (mostly north and north-east, like MA, RO, AM, SE, PI, TO) pay around 24 to 26% of the product price as freight, compared to only 14% in SP. These states also have fewer orders but a higher average item price. Expensive shipping may be stopping customers there from buying cheaper products, so offering free-shipping limits or regional warehouses could help the platform grow in these states.

**Note:** phpMyAdmin showed only the first 25 of 27 states. The last 2 (the states with the lowest revenue) are not in this table, so they are not used in my numbers.

## Q6. Delivery time and late deliveries by state
**Result:** SP has the fastest delivery (8.7 days average, 4.5% late). RR (29.3 days), AP (27.2) and AM (26.4) are the slowest. AL has the highest late rate at 21.4% with 24.5 days average, followed by MA at 17.4% and SE at 15.2%.

**Insight:** Delivery time depends a lot on the location of the customer. Customers in SP, MG and PR get their orders in 9 to 12 days, while customers in the north wait more than 3 weeks. Slow does not always mean late. AM, AP and RO take long but only about 3% of their orders are late, which means the estimated delivery date there is already set long. The real problem states are AL (21.4% late), MA (17.4%), SE (15.2%), PI (13.9%) and CE (13.8%), because delivery there is both slow and often later than promised. RJ also needs attention. It is the second biggest market (12,350 orders) and 12.1% of its orders are late, which is almost 3 times the late rate of SP (4.5%).

**Note:** A delivery is counted as late only if it arrives on a later date than the estimated date. RR (41 orders) and AP (67 orders) have very few orders, so their percentages are not very reliable.

## Q7. Review score: on-time vs late deliveries
**Result:** On-time orders: 89,443 orders, average review 4.29, 9.2% got 1 or 2 stars. Late orders: 6,381 orders, average review 2.27, 62.4% got 1 or 2 stars.

**Insight:** Late delivery has a big effect on customer happiness. Late orders score 2.0 points lower on average, and more than 6 out of 10 late orders get a bad review (1 or 2 stars), against only 9.2% of on-time orders, which is about 7 times higher. Only about 6.7% of delivered orders are late, so fixing late deliveries is a small operational problem with a big impact on satisfaction. I checked this again with a Mann-Whitney U test in Python (see the Python section below) to make sure the difference is not just by chance.

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

**Insight:** The order process is mostly healthy, with 97 out of every 100 orders delivered. About 1.2% of orders (625 canceled + 609 unavailable = 1,234 orders) failed completely, and the "unavailable" ones likely mean the seller did not have the product in stock. A further 1,107 orders are still marked "shipped" and 622 are stuck in earlier steps (invoiced, processing, created or approved), so about 1.7% of orders never reached the customer in this data. These non-delivered orders explain 2,957 of the 2,965 missing delivery dates I found during data checking. The other 8 are delivered orders with the date missing.

**Decision for cleaning:** For revenue, delivery and review analysis I keep only delivered orders, because the other statuses did not complete a sale or have no delivery date.

## Data quality check (SQL view, 99,441 orders)
**Result:** Orders with no item records: 775 (0.78%). Orders with no payment record: 1. Orders with no review: 768 (0.77%). Orders with no delivery date: 2,965 (2.98%).

**Insight:** The data is quite clean overall, and no column is missing more than 3% of its values. The 775 orders without items are most likely cancelled or unavailable orders, because an order that never shipped has no product lines. Later, in the Python cleaning, I confirmed that no delivered order with a delivery date is missing its items. Of the 2,965 missing delivery dates, 2,957 are orders that were not delivered (status count in Q10) and 8 are delivered orders with the date missing. Only 1 order has no payment record, which is too small to matter. About 768 orders never received a review, which is normal because customers do not always review.

**Decisions:**
- Revenue and delivery analysis uses delivered orders that have a delivery date and item records only.
- Orders without a review are kept in the data and left out only from the review score analysis, so I do not lose revenue information.
- The view was checked: it returns 99,441 rows, equal to the orders table, so joining payments, items and reviews did not create duplicate rows.

# Python Analysis Insights

## Data cleaning
**What I did:** I started with 99,441 orders. I kept only delivered orders, so 2,963 orders were removed (cancelled, still shipping, etc.). Then I removed 8 delivered orders that had no delivery date. I was left with 96,470 orders. There were no duplicate orders.

**What I found:** The 2,965 missing delivery dates are mostly orders that were never delivered (2,957 of them). Only 8 are delivered orders with the date missing. I also saw 6 cancelled orders that still have a delivery date. This looks like a data mistake, but I removed them anyway because I keep only delivered orders. 646 orders have no review. After cleaning, revenue is R$13,220,249, which is about R$1,249 less than in Q1 because of the 8 removed orders.

**Outliers:** I checked prices, freight and delivery days with the IQR method. It flagged 7,658 orders for price, 9,694 for freight and 4,729 for delivery days. I did not remove them. Expensive products and long deliveries are real, so removing them would delete real orders.

## Customer groups (RFM)
**What I did:** I grouped customers by Recency (how recently they bought), Frequency (how many orders) and Monetary (how much they spent). I used customer_unique_id to identify a person, because customer_id changes with every order.

**What I found:** There are 93,350 customers. Only 2,801 of them (about 3%) are repeat buyers (Champions 1,208 and Repeat 1,593). This matches my SQL result in Q9. Repeat buyers spend about R$250 to R$270, while one-time buyers spend about R$130 to R$141, which is nearly double. The 3% repeat buyers bring 5.5% of revenue. Another 36,344 customers (38.9%) are in the "At risk" or "Lost" groups, which means they bought once and did not come back.

**Note:** The groups Needs attention, At risk and Lost are almost the same size (about 19% each). This is because I divided recency into 5 equal parts, so it is not a real finding.

## Customers coming back (cohort analysis)
**What I did:** I grouped customers by the month of their first order and checked how many ordered again in the next months.

**What I found:** On average, only 0.47% of customers came back in month 1, and 0.25% in month 3. So out of 1,000 new customers, fewer than 5 ordered again the next month. This agrees with the 3% repeat rate from Q9, where very few customers ever come back.

## Late delivery and reviews
**What I did:** I compared review scores of late orders and on-time orders. Review scores are not normally distributed (most are 5 stars), so instead of a t-test I used the Mann-Whitney U test, which works in this case.

**What I found:**
- On-time orders (89,443): average review 4.29, and 9.2% gave 1 or 2 stars
- Late orders (6,381): average review 2.27, and 62.4% gave 1 or 2 stars
- The p-value is below 0.001, so it is very unlikely that this difference happened by chance. (The notebook shows 0 because the value is too small to display.)

The longer the delay, the worse the review:

| Delivery | Orders | Avg review | % with 1 or 2 stars |
|---|---|---|---|
| On time or early | 89,443 | 4.29 | 9.2% |
| 1 to 3 days late | 1,852 | 3.29 | 32.2% |
| 4 to 7 days late | 1,748 | 2.11 | 67.6% |
| 8+ days late | 2,781 | 1.70 | 79.2% |

Only 6.8% of orders are late, but late orders hurt customer happiness a lot.

## Revenue at risk
I defined "revenue at risk" as the revenue from orders that were late and got 1 or 2 stars. There are 3,979 such orders worth R$618,573, which is 4.7% of total revenue. This is not money already lost. It is the revenue from customers who are unhappy and less likely to buy again.

## What I recommend
1. Improve delivery in the states with most late orders: AL (21.4% late), MA (17.4%), SE (15.2%) and RJ (12.1% late, and it is a big market with 12,350 orders).
2. Send an offer to first-time buyers (36,132 recent one-time customers) so that they order a second time, because repeat buyers spend about double.
3. Look at shipping cost in northern states. Freight is 24 to 26% of the product price there, and only 14% in SP.

# Problems I faced and what I learned
1. **Wrong customer count:** customer_id changes with every order, so counting it gives wrong results. I used customer_unique_id to count real customers.
2. **Late delivery mistake:** my first query counted orders delivered on the promised day as late, because the estimated date has no time. I saw it when I checked rows in the view. I fixed it by comparing only dates, and late orders went down from 7,661 to 6,381.
3. **Duplicate rows risk:** joining items, payments and reviews directly can repeat an order many times. I first summed each table to one row per order, and then checked the view has 99,441 rows, same as the orders table.
4. **Data loading:** phpMyAdmin guesses column types when importing CSV files (dates can become plain text). So I created the tables myself first and loaded the CSV files with Python.

# Limitations
- There is no cost or profit data, so this project is about revenue, not profit.
- The data only covers Sep 2016 to Aug 2018, and the first months have very few orders.
- Prices are in Brazilian reais (R$).
- Customer groups (RFM) depend on how I split the scores, so another split would give different group sizes.