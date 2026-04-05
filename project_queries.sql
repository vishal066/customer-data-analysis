select * from customer_shopping_behavior


select Customer_ID from customer_shopping_behavior
where Discount_applied='Yes' and Purchase_Amount_USD >(select avg(Purchase_Amount_USD) from customer_shopping_behavior)


select avg(Review_Rating) as Rating, Item_Purchased from customer_shopping_behavior group by Item_Purchased order by avg(Review_Rating)
Desc OFFSET 0 rows Fetch next 5 Rows only

select round(avg(Purchase_Amount_USD),2) as Amount, Shipping_Type from customer_shopping_behavior group by Shipping_Type having Shipping_Type='Express' or Shipping_Type= 'Standard'

select avg(Purchase_Amount_USD) as avg_amount, sum(Purchase_Amount_USD) as total_amount, Subscription_Status from customer_shopping_behavior group by Subscription_Status

select Item_Purchased,round(100*sum(case when Discount_Applied='Yes' then 1 else 0 end)/count(*),2) as discount_rate from customer_shopping_behavior group by Item_Purchased order by discount_rate desc OFFSET 0 rows fetch next 5 rows only 

with customer_type as (
	select Customer_ID, Previous_Purchases,
	case 
		when Previous_Purchases = 1 then 'New'
		when Previous_Purchases between 2 and 10 then 'Returning'
		else 'Loyal'
	end as customer_segment
	from customer_shopping_behavior

)

select customer_segment,count(*) from customer_type group by customer_segment


with sampled as (select Category,Item_Purchased, count(Item_Purchased) as number, row_number() over(partition by Category order by count(Item_Purchased) desc) as item_rank from customer_shopping_behavior group by Category,Item_Purchased)

select Category,Item_purchased from sampled where item_rank <=3


select subscription_status,count(Customer_ID)  from customer_shopping_behavior where Previous_Purchases >5 group by Subscription_status

