use [Flea Market]

--Procedures for adding specific tests, tables, views and for creating the connections between them
drop procedure if exists runTest

GO 
CREATE OR ALTER PROCEDURE addToTables(@tableName VARCHAR(50)) AS
BEGIN
	IF @tableName IN(SELECT [Name] FROM [Tables])
	BEGIN
		PRINT 'Table is already present in Tables'
		RETURN 
	END

	IF @tableName NOT IN(SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES)
	BEGIN
		PRINT 'Table is not in the database'
		RETURN 
	END

	INSERT INTO [Tables]([Name])
	VALUES 
		(@tableName)
END

GO
CREATE OR ALTER PROCEDURE addToViews(@viewName VARCHAR(50)) AS
BEGIN
	IF @viewName IN (SELECT [Name] from [Views])
	BEGIN
		PRINT 'View is already in Views'
		RETURN
	END

	IF @viewName NOT IN (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS)
	BEGIN
		PRINT 'View is not in the database'
		RETURN 
	END

	INSERT INTO [Views]([Name])
	VALUES
		(@viewName)
END

GO
CREATE OR ALTER PROCEDURE addToTests(@testName VARCHAR(50)) AS
BEGIN
	IF @testName IN (SELECT [Name] FROM [Tests])
	BEGIN
		PRINT 'Test already in Tests'
		RETURN
	END

	INSERT INTO [Tests]([Name])
	VALUES
		(@testName)
END

GO
CREATE OR ALTER PROCEDURE connectTableToTest(@tableName VARCHAR(50),@testName VARCHAR(50),@rows INT, @pos INT) AS
BEGIN
	IF @tableName NOT IN (SELECT [Name] FROM [Tables])
	BEGIN
		PRINT 'The table is not in the Tables'
		RETURN
	END

	IF @testName NOT IN (SELECT [Name] FROM [Tests])
	BEGIN
		PRINT 'The test is not in the Tests'
		RETURN
	END

	IF EXISTS(
		SELECT *
		FROM TestTables T1 JOIN Tests T2 ON T1.TestID=T2.TestID
		WHERE T2.[Name]=@testName AND Position=@pos
	)
		BEGIN 
			PRINT 'Position provided conflicts with previous positions '
			RETURN
		END
	INSERT INTO [TestTables](TestID,TableID,NoOfRows,Position)
	VALUES(
		(SELECT [Tests].TestID FROM [Tests] WHERE [Name]=@testName),
		(SELECT [Tables].TableID FROM [Tables] WHERE [Name]=@tableName),
		@rows,
		@pos
	)
END

GO
CREATE OR ALTER PROCEDURE connectViewToTest(@viewName VARCHAR(50), @testName VARCHAR(50)) AS
BEGIN
	IF @viewName NOT IN (SELECT [Name] FROM [Views])
		BEGIN
			PRINT 'View not in the Views'
			RETURN
		END
	IF @testName NOT IN (SELECT [Name] FROM [Tests])
		BEGIN
			PRINT 'Test not in the Tests'
			RETURN
		END
	INSERT INTO [TestViews] (TestID,ViewID)
	VALUES(
		(SELECT [Tests].TestID FROM [Tests] WHERE [Name]=@testName),
		(SELECT [Views].ViewID FROM [Views] WHERE [Name]=@viewName)
	)
END





--run a test--
GO
CREATE OR ALTER PROCEDURE runTest (@testName varchar(50)) AS
BEGIN
    IF @testName NOT IN (SELECT [Name] FROM [Tests]) 
	BEGIN
        PRINT 'test not in Tests'
        RETURN
    END
    DECLARE @command VARCHAR(100)
    DECLARE @testStartTime DATETIME2
    DECLARE @startTime DATETIME2
    DECLARE @endTime DATETIME2
    DECLARE @table VARCHAR(50)
    DECLARE @rows INT
    DECLARE @pos INT
    DECLARE @view VARCHAR(50)
    DECLARE @testId INT

    SELECT @testId=TestID     --luam id testului pe care dorim sa il executam
	FROM Tests 
	WHERE Name=@testName

    DECLARE @testRunId INT
    SET @testRunId = (SELECT MAX(TestRunID)+1 FROM TestRuns)   ---setam un nou id pentru testRunul curent
    IF @testRunId IS NULL										
        SET @testRunId = 0								---daca nu exista inca niciunul il setam la 0
    DECLARE tableCursor CURSOR SCROLL FOR
        SELECT T1.Name, T2.NoOfRows, T2.Position            ---declaram un cursor pentru tabels
        FROM [Tables] T1 JOIN TestTables T2 ON T1.TableID = T2.TableID
        WHERE T2.TestID = @testId							--selectam numele testului, nr de rows date,positia data pentru testul dat si ordonam dupa pozitii
        ORDER BY T2.Position
    DECLARE viewCursor CURSOR FOR                     ---declaram cursorul pentru views 
        SELECT V.Name								  ---selectam numele viewului pentru testul dat 
        FROM [Views] V JOIN TestViews TV ON V.ViewID = TV.ViewID
        WHERE TV.TestID = @testId

    SET @testStartTime = SYSDATETIME()
    OPEN tableCursor
    FETCH LAST FROM tableCursor INTO @table, @rows, @pos      ---Returnam ultimul rand din cursor si il facem randul curent
    WHILE @@FETCH_STATUS = 0 BEGIN                      
        EXEC ('delete from '+ @table)			
        FETCH PRIOR FROM tableCursor INTO @table, @rows, @pos   ---returnam randul rezultant situat imediat inainte de randul curent
    END
    CLOSE tableCursor

    OPEN tableCursor
    SET IDENTITY_INSERT TestRuns ON
    INSERT INTO TestRuns (TestRunID, Description, StartAt)
	VALUES (@testRunId, 'Tests results for: ' + @testName, @testStartTime)   ---inseram datele rezultate in TestRun
    SET IDENTITY_INSERT TestRuns OFF

    FETCH tableCursor INTO @table, @rows, @pos
    WHILE @@FETCH_STATUS = 0 BEGIN
        SET @command = 'populateTable' + @table      ---apelam procedura de populare ale tabelelor
        IF @command NOT IN (SELECT ROUTINE_NAME FROM INFORMATION_SCHEMA.ROUTINES) BEGIN
            PRINT @command + 'does not exist'
            RETURN
        END
        SET @startTime = SYSDATETIME()
		
        EXEC @command @rows
        SET @endTime = SYSDATETIME()
        INSERT INTO TestRunTables (TestRunID, TableId, StartAt, EndAt) 
		VALUES (@testRunId, (SELECT TableID FROM [Tables] WHERE Name=@table), @startTime, @endTime)
        FETCH tableCursor INTO @table, @rows, @pos   ---punem valorile in variabile
    END
    CLOSE tableCursor
    DEALLOCATE tableCursor

    OPEN viewCursor
    FETCH viewCursor INTO @view
    WHILE @@FETCH_STATUS = 0 BEGIN
        SET @command = 'select * from ' + @view
        SET @startTime = SYSDATETIME()
        EXEC (@command)
        SET @endTime = SYSDATETIME()
        INSERT INTO TestRunViews (TestRunID, ViewID, StartAt, EndAt) VALUES (@testRunId, (SELECT ViewID FROM Views WHERE Name=@view), @startTime, @endTime)
        FETCH viewCursor INTO @view
    END
    CLOSE viewCursor
    DEALLOCATE viewCursor

    UPDATE TestRuns
    SET EndAt=SYSDATETIME()
    WHERE TestRunID = @testRunId
END

----Views----

----a view with a SELECT statement operating on one table----
GO
CREATE OR ALTER VIEW View_1_table AS
	SELECT id, namme, price
	FROM     dbo.Products
	WHERE  (price < 210)

----a view with a SELECT statement that operates on at least 2 different tables and contains at least one JOIN operator----
GO
CREATE OR ALTER VIEW View_2_tables AS
	SELECT dbo.Customers.id, dbo.Customers.first_name, dbo.Purchases.payment, dbo.Purchases.[content]
	FROM     dbo.Customers INNER JOIN
    dbo.Purchases ON dbo.Customers.id = dbo.Purchases.customer_id


----a view with a SELECT statement that has a GROUP BY clause, operates on at least 2 different tables and contains at least one JOIN operator----
GO
CREATE OR ALTER VIEW View_2_tables_group_by AS
	SELECT dbo.Products.id, dbo.Products.namme, dbo.Purchases.product_id, dbo.Purchases.id AS PurchaseId
	FROM     dbo.Purchases INNER JOIN
    dbo.Products ON dbo.Purchases.product_id = dbo.Products.id
	GROUP BY dbo.Products.id, dbo.Products.namme, dbo.Purchases.product_id, dbo.Purchases.id
GO


-----TESTS-----
----a table with a single-column primary key and no foreign keys----

EXEC addToTables 'Products';
EXEC addToViews 'View_1_table';
EXEC addToTests 'test1';
EXEC connectTableToTest 'Products','test1',150,1;
EXEC connectViewToTest 'View_1_table','test1';


GO
CREATE OR ALTER PROCEDURE populateTableProducts(@rows INT) AS
	WHILE @rows>0
	BEGIN
		INSERT INTO Products(id,namme,price,discount,category,pieces,review)
		VALUES (@rows,'Pop Maria',FLOOR(RAND()*10000),floor(rand()*99),'category',floor(rand()*10000),'review');
		SET @rows = @rows - 1;
	END
GO
EXEC runTest 'test1'


--a table with a multicolumn primary key,
EXEC addToTables 'Purchases'
EXEC addToViews 'View_2_tables_group_by'
EXEC addToTests 'test2'
EXEC connectTableToTest 'Purchases', 'test2', 100, 2
EXEC connectTableToTest 'Products', 'test2', 150, 1
EXEC connectViewToTest 'View_2_tables_group_by', 'test2'

GO

CREATE OR ALTER PROCEDURE  populateTablePurchases(@rows INT) AS
	WHILE @rows > 0 
	BEGIN
		INSERT INTO Purchases(id,customer_id,product_id,payment,pieces,content)
		VALUES (@rows,@rows,@rows,'CARD',floor(rand()*10000),'content');
		SET @rows = @rows-1;
	END


GO

EXEC runTest 'test2'
GO


--a table with a single-column primary key and at least one foreign key
EXEC addToTables 'Customers'
EXEC addToViews 'View_2_tables'
EXEC addToTests 'test3'
EXEC connectTableToTest 'Customers','test3',100,1
EXEC connectTableToTest 'Purchases','test3',100,2
EXEC connectViewToTest 'View_2_tables', 'test3'

GO
CREATE OR ALTER PROCEDURE populateTableCustomers (@rows INT) AS
	WHILE @rows > 0
	BEGIN
		INSERT INTO Customers(id,first_name, last_name,addresss,phone)
		VALUES(@rows,'Carla','Blaga','str. Dambovitei nr.19','0723492376');
		SET @rows = @rows -1;
	END
GO
EXEC runTest 'test3'
GO

SELECT *
FROM [Views];

SELECT *
FROM [Tables];

SELECT *
FROM [Tests];

SELECT *
FROM [TestTables];

SELECT *
FROM [TestViews];

SELECT *
FROM [TestRuns];

SELECT *
FROM [TestRunTables];

SELECT *
FROM [TestRunViews];

DELETE FROM TestViews
DELETE FROM TestRuns
DELETE FROM Tables
DELETE FROM Views
DELETE FROM Tests