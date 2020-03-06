use Netflix
go

select * from Tables

--inserez in Tables tabelele Seriale, Producator si EnrolledS pt a fi testate
insert into Tables
(Name)
values ('Seriale')

insert into Tables
(Name)
values ('Producator')

insert into Tables
(Name)
values ('EnrolledS')

update Tables
set Name='Seriale'
where TableID=2

select * from Tables

--cream view-urile
--1.un view ce conţine o comandă SELECT pe tabela Producator
create view vw1_Producator as
select * from Producator;

select Nume from vw1_Producator

--2.- un view ce conţine o comandă SELECT aplicată pe cel puţin două tabele
create view vw2_ProducatorSeriale as
select P.Nume, S.Titlu, S.Gen
from Producator as P, Seriale as S
where S.Pid=P.Pid;

ALTER TABLE EnrolledS
ADD Salariu INT;

select * from EnrolledS

--3.un view ce conţine o comandă SELECT aplicată pe cel puţin două tabele şi având o clauză GROUP BY
create view vw3_Salariu as
SELECT P.Nume, sum(ES.Salariu*S.NrEp)Salariu
FROM Producator as P, EnrolledS as ES, Seriale as S
where P.Pid=S.Pid and S.Sid=ES.Sid
GROUP BY P.Nume;

--inseram cele 3 view-uri in tabela Views
insert into Views
(Name)
values ('vw1_Producator')

insert into Views
(Name)
values ('vw1_ProducatorSeriale')

update Views
set Name='vw2_ProducatorSeriale'
where ViewID=2

insert into Views
(Name)
values ('vw3_Salariu')

--inseram date in TestTables
INSERT INTO TestTables(TestID, TableID, NoOfRows, Position)
VALUES (1, 1, 500, 3);

INSERT INTO TestTables(TestID, TableID, NoOfRows, Position)
VALUES (1, 2, 500, 2);

INSERT INTO TestTables(TestID, TableID, NoOfRows, Position)
VALUES (1, 3, 500, 1);

--inseram date in TestViews
INSERT INTO TestViews(TestID, ViewID)
VALUES (1, 1);

INSERT INTO TestViews(TestID, ViewID)
VALUES (1, 2);

INSERT INTO TestViews(TestID, ViewID)
VALUES (1, 3);

CREATE TABLE Producator_Adaugati(
Pid INT PRIMARY KEY,
Nume VARCHAR(60))

CREATE TABLE Producator_Stersi(
Pid INT PRIMARY KEY,
Nume VARCHAR(60))

drop trigger dbo.adaugare_producator
on dbo.Producator
for insert
as
begin
insert into Producator_Adaugati(Pid, Nume)
select Pid, Nume from inserted
end;

drop trigger dbo.stergere_producator
on dbo.Producator
for delete
as
begin
insert into Producator_Stersi(Pid, Nume)
select Pid, Nume from deleted
end;

insert into Tests
(Name)
values
('insert_producator')

update Tests
set Name='Test1'
where TestID=1

select * from Tests

--cream 3 proceduri de inserare in tabele 
--pt Producator

create procedure insert_Producator
@cantitate int
as
begin
declare @Pid int
declare @Nume varchar(60)
set @Pid=1

while @Pid <= @cantitate
begin
	set @Nume=convert(varchar(60),'Producator'+convert(varchar(5),@Pid))
	insert into Producator (Pid,Nume)
	values (@Pid,@Nume)
	set @Pid=@Pid+1
end
end;

create procedure delete_producator
@cantitate int
as
begin
declare @Pid int
set @Pid=@cantitate

while @Pid >= 1
begin
	delete from Producator
	where Pid=@Pid
	set @Pid=@Pid-1
end
end;

exec insert_producator 5
exec delete_producator 5

select * from Producator
select * from Producator_Adaugati
select * from Producator_Stersi
delete from Producator
delete from Producator_Adaugati
delete from Producator_Stersi

--pt Seriale

alter procedure insert_Seriale
@cantitate int
as
begin
declare @Sid int
declare @Titlu varchar(50)
declare @Gen varchar(30)
declare @NrEp INT
declare @Pid INT
--cu select!!
set @Sid=1
set @Pid=1

while @Sid <= @cantitate
begin
	set @Titlu=convert(varchar(50),'Serial'+convert(varchar(5),@Sid))
	set @Gen=convert(varchar(30),'Gen'+convert(varchar(5),@Sid))
	set @NrEp=12+@Sid
	insert into Seriale(Sid,Titlu,Gen,NrEp,Pid)
	values (@Sid,@Titlu,@Gen,@NrEp,@Pid)
	set @Sid=@Sid+1
end
end;

insert into Actori(Nume,Prenume,DataN)
values ('Jolie','Angelina','06/04/1975')

--pt EnrolledS
create procedure insert_EnrolledS
@cantitate int
as
begin
declare @Sid int
declare @Aid INT
declare @DataInceput DATE
set @Sid=1
set @Aid=1
set @DataInceput='01/01/2020'

while @Sid <= @cantitate
begin
	insert into EnrolledS(Sid,Aid,DataInceput)
	values (@Sid,@Aid,@DataInceput)
	set @Sid=@Sid+1
end
end;

--cream procedura principala

alter PROCEDURE Main @test INT 
AS 
BEGIN
	IF @test NOT IN (SELECT TestID FROM Tests)
	BEGIN
		RAISERROR('Test inexistent', 11, 1);
		RETURN;
	END;

	declare @start DATETIME;
	declare @tableID INT;
	declare @cantitate int;
	declare @viewID INT;
	declare @tableName VARCHAR(50);

	DECLARE @OutputTable TABLE (ID INT)
	INSERT INTO TestRuns(Description, StartAt)
	OUTPUT INSERTED.TestRunID INTO @OutputTable(ID)
	VALUES ('Test: ' + CAST(@test AS varchar), CURRENT_TIMESTAMP); 

	DECLARE @testrun INT;
	SET @testrun = (SELECT ID FROM @OutputTable);

	DECLARE @cursor AS CURSOR;
	SET @cursor = CURSOR FOR SELECT Name FROM Tables T INNER JOIN TestTables TT ON T.TableID = TT.TableID AND TT.TestID = @test ORDER BY Position;
	OPEN @cursor;
	FETCH NEXT FROM @cursor INTO @tableName;

	--se sterg datele din cele 3 tabele
	WHILE @@FETCH_STATUS = 0
	BEGIN
			DECLARE @comanda VARCHAR(100);
			SET @comanda = 'DELETE FROM '+ @tableName;
			EXEC (@comanda);
			FETCH NEXT FROM @cursor INTO @tableName;
	END;

	/*inserez in tabele*/
	SET @cursor = CURSOR FOR SELECT Name FROM Tables T INNER JOIN TestTables TT ON T.TableID = TT.TableID AND TT.TestID = @test ORDER BY Position DESC;
	OPEN @cursor;
	FETCH NEXT FROM @cursor INTO @tableName;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @tableID = (SELECT TableID FROM Tables WHERE Name = @tableName);
		SET @cantitate = (SELECT NoOfRows FROM TestTables WHERE TestID=@test AND TableID=@tableID);

		SET @start = CURRENT_TIMESTAMP;
		SET @comanda = 'insert_'+ @tableName;
		EXEC @comanda @cantitate;
		INSERT INTO TestRunTables(TestRunID, TableID, StartAt, EndAt)
		VALUES (@testrun, @tableID, @start, CURRENT_TIMESTAMP);
		FETCH NEXT FROM @cursor INTO @tableName;
	END;

	--view-urile
	DECLARE @view_name VARCHAR(100);
	SET @cursor = CURSOR FOR SELECT Name FROM Views V INNER JOIN TestViews TV ON V.ViewID = TV.ViewID AND TV.TestID = @test;
	OPEN @cursor;
	FETCH NEXT FROM @cursor INTO @view_name;
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @viewID = (SELECT ViewID FROM Views WHERE Name = @view_name);	
		SET @comanda = 'SELECT * FROM ' + @view_name;
		SET @start = CURRENT_TIMESTAMP;
		EXEC (@comanda);
		INSERT INTO TestRunViews(TestRunID, ViewID, StartAt, EndAt)
		VALUES (@testrun, @viewID, @start, CURRENT_TIMESTAMP);
		FETCH NEXT FROM @cursor INTO @view_name;
	END;

	UPDATE TestRuns
	SET EndAt = CURRENT_TIMESTAMP
	WHERE TestRunID = @testrun	
END;
go

set nocount on

EXEC Main 1;

SELECT *FROM Tests;
SELECT *FROM TestTables;
SELECT *FROM TestViews;
SELECT *FROM Tables;
SELECT *FROM Views;

SELECT *FROM TestRuns;
SELECT *FROM TestRunTables;
SELECT *FROM TestRunViews;

DELETE FROM TestRuns;
DELETE FROM TestRunTables;
DELETE FROM TestRunViews;

select *  from Seriale
select *  from Producator
select *  from EnrolledS