USE [Flea Market]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--insert rows
CREATE OR ALTER PROCEDURE [dbo].[insert_rows] 
	-- Add the parameters for the stored procedure here
	@nb_of_rows varchar(30),
	@table_name varchar(30)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @table varchar(100)
	set @table = ('[' + @table_name + ']')

	--if @table_name = 'Products' or @table_name = 'Purchases' 
	--begin
	--	DBCC CHECKIDENT (@table, RESEED, 0);
	--end

    -- Insert statements for procedure here
	if ISNUMERIC(@nb_of_rows) != 1
	BEGIN
		print('Not a number')
		return 1 
	END
	
	SET @nb_of_rows = cast(@nb_of_rows as INT)

	declare @contor int
	set @contor = 1

	--products
	declare @prid int
	declare @namme varchar(30)
	declare @price int
	declare @discount float
	declare @category varchar(30)
	declare @pieces int
	declare @review varchar(100)

	--purchases
	declare @purid int
	declare @customer_id int
	declare @product_id int
	declare @payment varchar(15)
	set @payment='CASH'
	declare @piecess int 
	declare @content varchar(100)



	--customers
	declare @cid int
	declare @first_name varchar(30)
	declare @last_name varchar(30)
	declare @address varchar(30)
	set @address = 'str. Dambovitei nr.19'
	declare @phone int
	set @phone = '0723492376'


	while @contor <= @nb_of_rows
	begin
		if @table_name = 'Products'
		begin
			set @prid =(select max(id) from Products) - @contor + 1
			set @namme = 'name' + convert(varchar(7), @contor)
			set @price = floor(rand()*1000)
			set @discount = floor(rand()*99)
			set @category= 'category' + convert(varchar(7), @contor)
			set @pieces = floor(rand()*1000)
			set @review = 'product' + convert(varchar(7), @contor)
			insert into Products(id,namme,price,discount,category,pieces,review) values (@prid,@namme,@price,@discount,@category,@pieces,@review) 
		end
		
		if @table_name = 'Purchases'
		begin
			set @purid= (select max(id) from Purchases) - @contor + 1
			set @customer_id = (select max(id) from Customers) - @contor + 1
			--SELECT id FROM Customers ORDER BY RAND() LIMIT 1
			set @product_id = (select max(id) from Products) - @contor + 1
			--SELECT id FROM Products ORDER BY RAND() LIMIT 1
			set @piecess = floor(rand()*1000)
			set @content = 'content' + convert(varchar(7), @contor)
			insert into Purchases(id,customer_id,product_id,payment,pieces,content) values (@purid,@customer_id,@product_id,@payment,@piecess,@content)
		end
		if @table_name = 'Customers'
		begin
			set @cid=(select max(id) from Customers) - @contor + 1
			set @first_name = 'first name' + convert(varchar(7), @contor)
			set @last_name = 'last name' + convert(varchar(7), @contor)
			insert into Customers(id,first_name, last_name,addresss,phone) values (@cid,@first_name,@last_name,@address,@phone)	
		end


		set @contor = @contor + 1
	end
	
END
go