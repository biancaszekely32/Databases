use "Flea Market";


--f
--exists

--sellers that have reviews and top
select top 2 S.first_name,S.last_name,S.stand_type
from Sellers S
where exists(
	select *
	from Sellers_reviews Sr
	where Sr.seller_id=S.id)


--customers that bought tickets and order by
select C.id,C.last_name
from Customers C
where exists(
	select *
	from Tickets T
	where T.customer_id=C.id)
order by C.last_name