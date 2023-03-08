use "Flea Market";

--d


--inner join and distinct
--products that have been purchased, have a review and a description
select distinct P.id,P.namme,P.price, Pur.customer_id
from Products P
inner join Purchases Pur on P.id= Pur.product_id
inner join Products_reviews Pr on P.id= Pr.product_id
inner join Product_description Pd on P.id=Pd.product_id and P.namme=Pd.title;


--right join annd order by
--all sellers that have a review ordered by stand_type
select S.id,S.first_name, S.last_name,Sr.title, Sr.rating,Sr.contentt
from Sellers S
right join Sellers_reviews Sr on Sr.seller_id= S.id
order by S.stand_type 

--left join and top
--top3 stands that were visited by customer and the number of visits
select top 3 C.first_name, S.typpe,V.number_of_visits
from Stands S
left join Visits V on V.stand_type=S.typpe
left join Customers C on C.id=V.customer_id
where number_of_visits is not null;

--full join
--customers that bought a product with a discount over 10% and reviewed the product
select distinct C.last_name,C.phone,P.namme,P.category,Pr.rating
from Products_reviews Pr
full join Customers C on C.id=Pr.customer_id
full join Products P on P.id=Pr.product_id 
where discount>=10 and last_name is not null;

