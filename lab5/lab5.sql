use [Flea Market]
drop table Tc
drop table Tb
drop table Ta
SET NOCOUNT ON;

create table Ta (
    aid int primary key,
    a2 int unique,
    x int
)
go
create table Tb (
    bid int primary key,
    b2 int,
    x int
)
go
create table Tc (
    cid int primary key,
    aid int references Ta(aid),
    bid int references Tb(bid)
)
go
create or alter procedure insertIntoTa(@rows int) as
    declare @max int
    set @max = @rows*2 + 100
    while @rows > 0 begin
        insert into Ta values (@rows, @max, @rows%120)
        set @rows = @rows-1
        set @max = @max-2
    end
go

create or alter procedure insertIntoTb(@rows int) as
    while @rows > 0 begin
        insert into Tb values (@rows, @rows%870, @rows%140)
        set @rows = @rows-1
    end
go

create or alter procedure insertIntoTc(@rows int) as
    declare @aid int
    declare @bid int
    while @rows > 0 begin
        set @aid = (select top 1 aid from Ta order by NEWID())
        set @bid = (select top 1 bid from Tb order by NEWID())
        insert into Tc values (@rows, @aid, @bid)
        set @rows = @rows-1
    end
go

exec insertIntoTa 10000
exec insertIntoTb 1200
exec insertIntoTc 1000

create nonclustered index index1 on Ta(x)
drop index index1 on Ta
go

--a

-- primary key constraint on aid column => clustered index automatically created on aid column
-- unique constraint on a2 column       => non-clustered index automaticall created on a2 column

-- Clustered Index Scan => have to scan the entire table for the matching rows 
select * from Ta order by aid --0.032

-- Clustered Index Seek => particular range of rows from a clustered index
select * from Ta where aid = 1 -- 0.0032

-- Nonclustered Index Scan => retrives all the rows from the table
select x from Ta order by x --0.032

-- Nonclustered Index Seek =>search for particulars values of the a2 column on which we have a unique constraint
select a2 from Ta where a2>30 -- 0.026

-- Key Lookup => non-clustered index seek and key look up
select x from Ta where a2 = 989 --0.0032



--b 
-- Clustered Index Scan 0.006 cost
select * from Tb where b2 = 40

create nonclustered index index2 on Tb(b2) include (bid, x)
drop index index2 on Tb

-- Nonclustered Index Seek 0.006 cost
select * from Tb where b2 = 40
go


--c

create or alter view view1 as
    select top 1000 T1.x, T2.b2
    from Tc T3 join Ta T1 on T3.aid = T1.aid join Tb T2 on T3.bid = T2.bid
    where T2.b2 > 500 and T1.x < 15
go

--Clustered Index Scan 0.006 cost
select * from view1

--cost with index - 
--cost without index

