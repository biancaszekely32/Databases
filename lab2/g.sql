use "Flea Market";

--g

--Products that have been purchased twice or have been payed in cash and have a product description
select X.id,X.namme
from (
	select P.id,P.namme
	from Products P 
	inner join Purchases Pur on Pur.product_id=P.id
	where Pur.pieces=2 or payment='cash'
)X
where X.id in(
	select Pd.product_id
	from Product_description Pd
)

--sellers that own stands with more than 60 products and have a review
select *
from (
	select * 
	from Sellers S
	full join Stands St on St.typpe=S.stand_type
	where St.nr_of_products>60
)X
where X.id in(
	select Sr.seller_id
	from Sellers_reviews Sr
	)
