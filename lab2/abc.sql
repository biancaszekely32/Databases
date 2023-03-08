use "Flea Market";

--a

--union all
--all id's from customers that visited only 2 stands and bought more than 3 tickets
select customer_id from Tickets where number>3
union all
select customer_id from Visits where number_of_visits=2;

--or in where
--all purchases payed with card and more than 1 piece has been bought
select payment, content
from Purchases
where payment='card' and pieces>1;


--b

--intersect operator
--all products that have been purchased and have a review
select product_id from Purchases
intersect 
select product_id from Products_reviews;

--in operator
--all products that have ben purchased and have a review
select product_id from Purchases where product_id in (select product_id from Products_reviews);


--c

--not in operator
--all stands owned by sellers that have not been visited by customers
select stand_type from Sellers
where stand_type not in (select stand_type from Visits);

--except operator
--all products that have been purchased but they do not have a review
select product_id from Purchases
except 
select product_id from Products_reviews;



