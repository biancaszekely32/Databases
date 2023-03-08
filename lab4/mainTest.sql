USE [Flea Market]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[mainTest]
	-- Add the parameters for the stored procedure here
	@nb_of_rows varchar(30)
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
	
	--SET @nb_of_rows = cast(@nb_of_rows as INT)


	declare @all_start datetime
	set @all_start = GETDATE();

	
	declare @customers_delete_start datetime
	set @customers_delete_start = GETDATE()
	execute delete_rows @nb_of_rows, 'Customers'
	declare @customers_delete_end datetime
	set @customers_delete_end = GETDATE()

	

	declare @purchases_delete_start datetime
	set @purchases_delete_start = GETDATE()
	execute delete_rows @nb_of_rows, 'Purchases'
	declare @purchases_delete_end datetime
	set @purchases_delete_end = GETDATE()

	declare @products_delete_start datetime
	set @products_delete_start = GETDATE()
	execute delete_rows @nb_of_rows, 'Products'
	declare @products_delete_end datetime
	set @products_delete_end = GETDATE()


	declare @products_insert_start datetime
	set @products_insert_start = GETDATE()
	execute insert_rows @nb_of_rows, 'Products'
	declare @products_insert_end datetime
	set @products_insert_end = GETDATE()


	declare @purchases_insert_start datetime
	set @purchases_insert_start = GETDATE()
	execute insert_rows @nb_of_rows, 'Purchases'
	declare @purchases_insert_end datetime
	set @purchases_insert_end = GETDATE()


	declare @customers_insert_start datetime
	set @customers_insert_start = GETDATE()
	execute insert_rows @nb_of_rows, 'Customers'
	declare @customers_insert_end datetime
	set @customers_insert_end = GETDATE()

	
	declare @view_1_table_start datetime
	set @view_1_table_start = GETDATE()
	execute select_view 'View_1_table'
	declare @view_1_table_end datetime
	set @view_1_table_end = GETDATE()

	
	declare @view_2_tables_start datetime
	set @view_2_tables_start = GETDATE()
	execute select_view 'View_2_tables'
	declare @view_2_tables_end datetime
	set @view_2_tables_end = GETDATE()


	declare @view_2_tables_group_by_start datetime
	set @view_2_tables_group_by_start = GETDATE()
	execute select_view 'View_2_tables_group_by'
	declare @view_2_tables_group_by_end datetime
	set @view_2_tables_group_by_end = GETDATE()

	declare @all_stop datetime 
	set @all_stop = getdate() 

	declare @description varchar(100)
	set @description = 'TestRun' + convert(varchar(7), (select max(TestRunID) from TestRuns)) + 'delete, insert' + @nb_of_rows + 'rows, select all views'

	
	insert into TestRuns(Description, StartAt, EndAt)
	values(@description, @all_start, @all_stop);


	declare @lastTestRunID int; 
	set @lastTestRunID = (select max(TestRunID) from TestRuns);

	insert into TestRunTables
	values(@lastTestRunID, 1, @purchases_delete_start, @purchases_insert_end)

	insert into TestRunTables
	values(@lastTestRunID, 2, @customers_delete_start, @customers_insert_end)

	insert into TestRunTables
	values(@lastTestRunID, 3, @products_delete_start, @products_insert_end)

	insert into TestRunViews
	values(@lastTestRunID, 1, @view_1_table_start, @view_1_table_end)
	
	insert into TestRunViews
	values(@lastTestRunID, 2, @view_2_tables_start, @view_2_tables_end)

	insert into TestRunViews
	values(@lastTestRunID,3, @view_2_tables_group_by_start, @view_2_tables_group_by_end)
	

END
go

SELECT *
FROM [Views]
go

SELECT *
FROM [Tables]
go

SELECT *
FROM [Tests]
go

SELECT *
FROM [TestTables]
go

SELECT *
FROM [TestViews]
go

SELECT *
FROM [TestRuns]
go

SELECT *
FROM [TestRunTables]
go

SELECT *
FROM [TestRunViews]
go


--  DELETE FROM TestViews
--DELETE FROM TestRuns
--DELETE FROM Tables
--DELETE FROM Views
--DELETE FROM Tests


