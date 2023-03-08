use "Flea Market";

--h

--addresses of customers and how many of them are neighbors 
select  addresss, count(*) as neighbors
from Customers
group by addresss
having count(*)>1
order by addresss desc

-- top 3 products with the biggest prices and discount bigger than 25% 
select top 3 count(P.discount) as disc,P.price
from Products P 
group by price,discount
having count(*) <(
	select count(id)
	from Products 
	where P.discount>=25)
order by P.price desc

--products with more than 2 pieces purchased
select P.id,P.namme
from Products P inner join Purchases Pur on Pur.product_id=P.id
where Pur.pieces>=2
group by P.id,P.namme
having count(*) = (
	select max(t.C)
	from (select count(*)C
		  from Products P inner join Purchases Pur on Pur.product_id=P.id
		group by P.id,P.namme)t)







