use "Flea Market";

CREATE TABLE Customers(
	id int NOT NULL,
	first_name varchar(30) NOT NULL,
	last_name varchar(30) NOT NULL,
	addresss varchar(100),
	phone int NOT NUll,
	PRIMARY KEY(id)
);

CREATE TABLE Stands(
	nr_of_products int NOT NULL,
	typpe varchar(30) not null,
	PRIMARY KEY(typpe)
);

CREATE TABLE Sellers(
	id int NOT NULL,
	first_name varchar(30) NOT NULL,
	last_name varchar(30) NOT NULL,
	phone int NOT NUll,
	stand_type varchar(30) NOT NULL,
	PRIMARY KEY(id),
	FOREIGN KEY(stand_type)
	REFERENCES Stands(typpe)
	ON DELETE CASCADE

);

CREATE TABLE Products(
	id int NOT NULL,
	namme varchar(30) NOT NULL, 
	price int not null,
	discount float not null, 
	category varchar(30) not null, 
	pieces int not null,
	review varchar(100) not null, 
	PRIMARY KEY(id)
);



CREATE TABLE Purchases(
	id int NOT NULL,
	customer_id int NOT NULL,
	product_id int NOT NULL,
	payment varchar(15) NOT NULL,
	/*CASH/CARD*/
	pieces int not null, 
	content varchar(100) NOT NULL,
	PRIMARY KEY(id),
	FOREIGN KEY(product_id)
	REFERENCES Products(id)
	ON DELETE CASCADE,
	FOREIGN KEY(customer_id)
	REFERENCES Customers(id)
	ON DELETE CASCADE

	

);


CREATE TABLE Product_description(
	id int NOT NULL,
	product_id int not null,
	title varchar(30) NOT NULL,
	contentt varchar(500),
	PRIMARY KEY(id),
	FOREIGN KEY(product_id)
	REFERENCES Products(id)
	ON DELETE CASCADE
);

CREATE TABLE Products_reviews(
	id int NOT NULL,
	product_id int NOT NULL,
	customer_id int not null,
	title varchar(30) not null,
	contennt varchar(100),
	rating int not null,
	PRIMARY KEY(id),
	FOREIGN KEY(product_id)
		REFERENCES Products(id)
		ON DELETE CASCADE,
	FOREIGN KEY(customer_id)
		REFERENCES Customers(id)
		ON DELETE CASCADE

);

CREATE TABLE Visits(
	 id int NOT NULL,
	 customer_id int NOT NULL,
	 stand_type varchar(30) NOT NULL,
	 number_of_visits  int NOT NULL,
	 PRIMARY KEY(id),
     FOREIGN KEY(customer_id)
	 REFERENCES Customers(id)
	 ON DELETE CASCADE,
	 FOREIGN KEY(stand_type)
	 REFERENCES Stands(typpe)
	 ON DELETE CASCADE
);

CREATE TABLE Sellers_reviews(
	id int NOT NULL,
	seller_id int NOT NULL,
	title varchar(30) not null,
	contentt varchar(500),
	rating int not null,
	PRIMARY KEY(id),
	FOREIGN KEY(seller_id)
		REFERENCES Sellers(id)
		ON DELETE CASCADE
);


CREATE TABLE Tickets(
	id int not null,
	number int not null, 
	customer_id int not null, 
	PRIMARY KEY (id),
	FOREIGN KEY(customer_id)
		REFERENCES Customers(id)
		ON DELETE CASCADE
)