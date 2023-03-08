use [Flea Market]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--delete rows
CREATE OR ALTER PROCEDURE [dbo].[delete_rows]
	-- Add the parameters for the stored procedure here
	@nb_of_rows varchar(30),
	@table_name varchar(30)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if ISNUMERIC(@nb_of_rows) != 1
	BEGIN
		print('Not a number')
		return 1 
	END
	
	SET @nb_of_rows = cast(@nb_of_rows as INT)

	declare @last_row int
	if @table_name = 'Products'
		begin
			set @last_row = (select MAX(id) from Products) - @nb_of_rows
			delete from Products
			where id > @last_row
		end
		
		if @table_name = 'Purchases'
		begin
			set @last_row =(select MAX(id) from Purchases) - @nb_of_rows
			delete from Purchases
			where id > @last_row
		end

		if @table_name = 'Customers'
		begin
			set @last_row =(select MAX(id) from Customers) - @nb_of_rows
			delete from Customers
			where id > @last_row
		end
END
go