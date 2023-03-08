use "Flea Market";

--i


--products who have better rating than any products from category clothes
select Pr.product_id,Pr.rating
from Products_reviews Pr
where Pr.rating>any(
	select Pr.rating
	from Products_reviews Pr inner join Products P on P.id=Pr.product_id
	where P.category='clothes')

--products who have better rating than any products from category clothes
--(aggregation operator)
select Pr.product_id,Pr.rating
from Products_reviews Pr
where Pr.rating>(
	select min(Pr.rating)
	from Products_reviews Pr inner join Products P on P.id=Pr.product_id
	where P.category='clothes')

--customer id and pieces purchased who have purchased 
--more pieces than all customers whose last_name starts with G
select Pur.customer_id,Pur.pieces
from Purchases Pur
where Pur.Pieces>all(	
	select Pur.pieces
	from Purchases Pur inner join Customers C on C.id=Pur.customer_id
	where C.last_name like 'G%')


--customer id and pieces purchased who have purchased 
--more pieces than all customers whose last_name starts with G
--aggregation operator
select Pur.customer_id,Pur.pieces
from Purchases Pur
where Pur.Pieces> (	
	select max(Pur.pieces)
	from Purchases Pur inner join Customers C on C.id=Pur.customer_id
	where C.last_name like 'G%')


--sellers with stands with nr of products lower than 60
select S.first_name,S.stand_type
from Sellers S inner join Stands St on St.typpe=S.stand_type
where S.stand_type = any(
	select St.typpe
	from Stands St inner join Sellers S on St.typpe=S.stand_type
	where St.nr_of_products<60)

--sellers with stands with nr of products lower than 60
--in
select S.first_name,S.stand_type
from Sellers S inner join Stands St on St.typpe=S.stand_type
where S.stand_type in (
	select St.typpe
	from Stands St inner join Sellers S on St.typpe=S.stand_type
	where St.nr_of_products<60)

--products who have not been purchased but have a description 
-- not in
select *
from Products P
where P.id not in(
	select Pur.product_id
	from Purchases Pur join Products P1 on P1.id=Pur.product_id)
and P.id in(
	select Pd.id
	from Product_description Pd join Products P2 on P2.id=Pd.product_id)

--products who have not been purchased but have a description 
select *
from Products P
where P.id <> all(
	select Pur.product_id
	from Purchases Pur join Products P1 on P1.id=Pur.product_id)
and P.id in(
	select Pd.id
	from Product_description Pd join Products P2 on P2.id=Pd.product_id)


