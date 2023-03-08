
--a
create procedure setRatingProd_revTinyint as
alter table Products_reviews alter column rating tinyint

go

create procedure setRatingProd_revInt as 
alter table Products_reviews alter column rating int

go

--b
create procedure addAddressSeller as 
alter table Sellers add addresss varchar(100)

go


create procedure removeAddressSeller as 
alter table Sellers drop column addresss

go


--c
create procedure addDefaultToPiecesfromPurchases as 
alter table Purchases add constraint DEFAULT0 default(0) for pieces

go


create procedure removeDefaultFromPiecesfromPurchases as 
alter table Purchases drop constraint DEFAULT0

go


--g
create procedure addTransport as
	create table Transport( 
		car_id int not null,
		car_brand varchar(100) not null,
		colour varchar(100) not null,
		product_id int not null,
		customer_id int not null,
		constraint Transport_PrimaryKey primary key(car_id)
		)

go

create procedure dropTransport as 
drop table if exists Transport 

go


--d
create procedure addCarBrandPrimaryKeyTransport as
	alter table Transport 
		drop constraint Transport_PrimaryKey
	alter table Transport 
		add constraint Transport_PrimaryKey primary key (car_id,car_brand)

go

create procedure removeCarBrandPrimaryKeyTransport as
	alter table Transport 
		drop constraint Transport_PrimaryKey
	alter table Transport 
		add constraint Transport_PrimaryKey primary key (car_id)

go


--e
create procedure newCandidateKeySellers as
alter table Sellers 
	add constraint Seller_CandidateKey unique (id,first_name,last_name)

go

create procedure dropCandidateKeySellers as
alter table Sellers 
	drop constraint Seller_CandidateKey

go


--f
create procedure newForeignKeyTransport as
	alter table Transport 
		add constraint Transport_ForeignKey foreign key(product_id) references Products(id)

go

create procedure dropForeignKeyTransport as
	alter table Transport 
		drop constraint Transport_ForeignKey 

go


create table versionTable (
    version int
)

insert into versionTable values (1) -- initial version

CREATE TABLE procedureTable (
	initial_version INT,
	final_version INT,
	procedure_name VARCHAR(MAX),
	PRIMARY KEY (initial_version, final_version)
)

insert into procedureTable values (1, 2, 'setRatingProd_revTinyint')
insert into procedureTable values (2, 1, 'setRatingProd_revInt')
insert into procedureTable values (2, 3, 'addAddressSeller')
insert into procedureTable values (3, 2, 'removeAddressSeller')
insert into procedureTable values (3, 4, 'addDefaultToPiecesfromPurchases')
insert into procedureTable values (4, 3, 'removeDefaultFromPiecesfromPurchases')
insert into procedureTable values (4, 5, 'addTransport')
insert into procedureTable values (5, 4, 'dropTransport')
insert into procedureTable values (5, 6, 'addCarBrandPrimaryKeyTransport')
insert into procedureTable values (6, 5, 'removeCarBrandPrimaryKeyTransport')
insert into procedureTable values (6, 7, 'newCandidateKeySellers')
insert into procedureTable values (7, 6, 'dropCandidateKeySellers')
insert into procedureTable values (7, 8, 'newForeignKeyTransport')
insert into procedureTable values (8, 7, 'dropForeignKeyTransport')

go


-- procedure to bring the database to the specified version
GO
CREATE OR ALTER PROCEDURE goToVersion(@newVersion INT) 
AS
	DECLARE @current_version INT
	DECLARE @procedureName VARCHAR(MAX)
	SELECT @current_version = version FROM versionTable

	IF (@newVersion > (SELECT MAX(final_version) FROM procedureTable) OR @newVersion < 1)
		RAISERROR ('Bad version', 10, 1)
	ELSE
	BEGIN
		IF @newVersion = @current_version
			PRINT('You are already on this version!');
		ELSE
		BEGIN
			IF @current_version > @newVersion
			BEGIN
				WHILE @current_version > @newVersion 
					BEGIN
						SELECT @procedureName = procedure_name FROM procedureTable WHERE initial_version = @current_version AND final_version = @current_version-1
						PRINT('Executing ' + @procedureName);
						EXEC (@procedureName)
						SET @current_version = @current_version - 1
					END
			END

			IF @current_version < @newVersion
			BEGIN
				WHILE @current_version < @newVersion 
					BEGIN
						SELECT @procedureName = procedure_name FROM procedureTable WHERE initial_version = @current_version AND final_version = @current_version+1
						PRINT('Executing ' + @procedureName);
						EXEC (@procedureName)
						SET @current_version = @current_version + 1
					END
			END

			UPDATE versionTable SET version = @newVersion
		END
	END

EXEC goToVersion 1

SELECT *
FROM versionTable

SELECT *
FROM procedureTable