use "Flea Market";

INSERT INTO Customers
		(id,first_name,last_name, addresss, phone)
VALUES 
(1,'Andreea', 'Pop','Fabricii', 0774891233),
(2, 'Florentina', 'Arba', 'Primaverii', 0789456345),
(3, 'Andrei', 'Mutiu', 'Avram Iancu', 0723472861),
(4, 'Elena', 'Gheorghe', 'Jucu', 0789278541);

insert into Customers values
(5,'Marian', 'Giurgi','Jucu',0789654234);

insert into Stands
values
	(56, 'used phones'),
	(120, 'shoes'),
	(78, 'clothes'),
	(5, 'furniture');

insert into Sellers
		(id, first_name, last_name, phone, stand_type)
values (1, 'Flaviu', 'Lavruc', 0789654237, 'furniture'),
	   (2, 'Ioan', 'Mihai', 0989123456, 'used phones'),
	   (3, 'Lavinia', 'Popovici', 076526646, 'clothes'),
	   (4, 'Rares', 'Motoc', 0786234567, 'shoes');


insert into Visits
values 
	(1,1, 'clothes', 4),
	(2,2, 'used phones', 2),
	(3,1, 'shoes', 2),
	(4,3, 'furniture', 1);

insert into Tickets
values
	(1, 3, 1),
	(2, 1, 3),
	(3, 2, 2);

insert into Products
values
	(1,'Chair', 33, 0, 'furniture',6, 2),
	(2,'Jeans', 28, 10, 'clothes',15, 0),
	(3, 'Used Air force 1', 65, 50,'shoes', 5, 3),
	(4, 'Motorola X3', 150, 10,'used phones',1, 0),
	(5, 'Samsung S2', 230, 25, 'used phones', 4, 2);

insert into Products values 
(7,'Table', 230, 20, 'furniture', 1,4);

insert into Products values 
(8,'Y3 sneakers', 230, 25, 'used shoes', 2,1);

insert into Products
values (6,'Jeans',45,5,'clothes',4,2);

insert into Purchases
values
	(1, 1, 2,'cash',2, 'Jeans'),
	(2, 2, 5,'card',3, 'Samsung S2'),
	(3,1, 3, 'card', 1,'Used Air force 1');

insert into Purchases values (4,3,4,'card',2,'Motorola X3');
	
insert into Products_reviews
values
	(1, 2, 1, 'Jeans', 'Good quality!', 7),
	(2, 5, 2,'Samsung S2', 'It has more than one scratch on the back, that I did not notice 
	at first, but otherwise it works!', 8), 
	(3, 3,1,'User Air force 1', null,9);




insert into Product_description
values
	(1, 1, 'Chair', 'Chair made of massive wood, backrest really comfortable'),
	(2, 2, 'Jeans', 'The Denim`s original colour blue and material, length 76 cm, waist 64cm'),
	(3,4,'Motorola X3', 'Released in 2010, May 15, Android 7, 5 inch screen, 4 gb ram'),
	(4,3,'Used Air force 1', 'Bought in 2021, used for a short period of time, creases of the
	front and a little scratch on the back'),
	(5,5,'Samsung S2', null);

insert into Sellers_reviews
values
	(2, 3, 'Review Lavinias clothes', null, 8),
	(4, 2,'Review Ioan Mihai', 'I was dissapointed finding out that some of the phones are
			only for collections, they do not even work properly!! 
			Bad Service, i do not recommend.', 4);


insert into Sellers_reviews values(3, 8,'make up stand', null, 4);--statement that violates integrity constraints;
--id 8 does not exist

insert into Sellers_reviews values (1, 1, 'Review Flaviu Lavruc', 'Best Furniture at a flea market!And also a great guy!',10);

update Customers
set addresss='Fabricii de zahar'
where id<=1;

update Purchases
set payment='cash'
where pieces=1 and product_id=3;

update Tickets
set number=9
where customer_id between 2 and 3;

--delete from Tickets where number=3;

delete from Products_reviews where contennt is NULL;
delete from Visits where stand_type like 'f%';

delete from Sellers_reviews where id=1;