use "Flea Market";

--customers that visited a stand and live on 'Fabricii de zahar' street
select *
from Customers C
where C.id in(
	select V.customer_id
	from Visits V inner join Stands S on S.typpe= V.stand_type
	group by V.customer_id
	having C.addresss='Fabricii de zahar')

--select in select in select
--products which have been purchased by customers
select *
from Products P
where P.id in (
	select Pur.product_id
	from Purchases Pur
	where Pur.customer_id in(
		select C.id
		from Customers C))