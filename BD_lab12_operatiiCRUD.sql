use Netflix
go

--tabele Producator, Actor, Filme, Seriale si EnrolledS

--funtie validare: returneaza 1 daca parametrul este pozitiv, altfel 1
CREATE OR ALTER FUNCTION validate_parameter (@param int)
RETURNS int
AS
BEGIN
	DECLARE @valid INT=1;
	IF (@param <= 0)
	BEGIN
		SET @valid = 0;
	END
	RETURN @valid;
END
GO

--CRUD operations for Producator(Pid,Nume)
alter procedure CRUD_Producator (@cantitate int )
as
	begin
	if (dbo.validate_parameter(@cantitate)=0)
	begin
		print('parametru invalid!')
		return
	end
	else

	--Create (insert)
	begin
		declare @Pid int
		declare @i int
		set @i=1
		declare @Nume varchar(60)
		set @Pid=(SELECT MAX(Pid)FROM Producator);
		set @Pid=@Pid+1
		if @Pid is null set @Pid=1

		while @i <= @cantitate
		begin
			set @Nume=convert(varchar(60),'Producator'+convert(varchar(5),@Pid))
				insert into Producator (Pid,Nume)
				values (@Pid,@Nume)
				set @Pid=@Pid+1
				set @i=@i+1
		end
	end
	--Read (select )
	select * from Producator
	--Update
	update Producator set Nume='AltNume'
	where Pid % 5 =0
	--Delete
	delete from Producator where Pid % 2=0

	print 'CRUD operations for Producator'
end;

exec CRUD_Producator 10;
select * from Producator
delete from Producator

--CRUD operations for Seriale(Sid,Titlu,Gen, NrEp,Pid)
create or alter procedure CRUD_Seriale (@cantitate int )
as
	begin
	if (dbo.validate_parameter(@cantitate)=0)
	begin
		print('parametru invalid!')
		return
	end
	else

	--Create (insert)
	begin
		declare @Sid int
		declare @Titlu varchar(50)
		declare @Gen varchar(30)
		declare @NrEp INT

		declare @Pid int
		declare @i int
		set @i=1
		declare @Nume varchar(60)
		set @Pid=(SELECT MAX(Pid)FROM Producator);
		set @Sid=(select max(Sid) from Seriale);
		set @Sid=@sid+1
		if @Sid is null set @Sid=1
		if @Pid is null 
		begin
			set @Pid=1
			insert into Producator(Pid,Nume)
			values (@Pid,'UnNume')
		end

		while @i <= @cantitate
		begin
			set @Titlu=convert(varchar(50),'Serial'+convert(varchar(5),@Sid))
			set @Gen=convert(varchar(30),'Gen'+convert(varchar(5),@Sid))
			set @NrEp=12+@Sid
			insert into Seriale(Sid,Titlu,Gen,NrEp,Pid)
			values (@Sid,@Titlu,@Gen,@NrEp,@Pid)
			set @Sid=@Sid+1
			set @i=@i+1
		end
	end
	--Read (select )
	select * from Seriale
	--Update
	update Seriale set Titlu='AltTitlu'
	where Sid % 5 =0
	--Delete
	delete from Seriale where Sid % 2=0

	print 'CRUD operations for Seriale'
end;

exec CRUD_Seriale -1;
exec CRUD_Seriale 2;
select * from Seriale
delete from Seriale

--CRUD operations for EnrolledS(Sid,Aid,DataInceput,Salariu)
create or alter procedure CRUD_EnrolledS (@salariu int )
as
	begin
	if (dbo.validate_parameter(@salariu)=0)
	begin
		print('parametru invalid!')
		return
	end
	else

	--Create (insert)
	begin
		declare @Sid int
		declare @Aid int
		declare @DataInceput DATE
		set @DataInceput='01/01/2020'
		set @Aid=(SELECT MAX(Aid)FROM Actori);
		set @Sid=(select max(Sid) from Seriale);
		if @Sid is null
		begin
			declare @Pid int
			set @Pid=(select max(Pid) from Producator);
			if @Pid is null
			begin
				set @Pid=1
				insert into Producator(Pid,Nume)
				values (@Pid,'UnNume')
			end
			set @Sid=1
			insert into Seriale(Sid,Titlu,Gen,NrEp,Pid)
			values (@Sid,'UnTitlu','Gen',12,@Pid)
		end
		if @Aid is null 
		begin
			insert into Actori(Nume,Prenume,DataN)
			values ('Jolie','Angelina','06/04/1975')
			set @Aid=(select max(Aid) from Actori);
		end

		insert into EnrolledS(Sid,Aid,DataInceput,Salariu)
		values (@Sid,@Aid,@DataInceput,@salariu)
	end
	--Read (select )
	select * from EnrolledS
	--Update
	update EnrolledS set DataInceput=getdate()
	where Salariu% 2 =0
	--Delete
	delete from EnrolledS where Sid=@Sid

	print 'CRUD operations for EnrolledS'
end;

exec CRUD_EnrolledS -1;
exec CRUD_EnrolledS 1020;
select * from EnrolledS
delete from EnrolledS

SELECT GETDATE();

--CRUD operations for Filme(Fid,Titlu, Gen)
create or alter procedure CRUD_Filme (@cantitate int )
as
	begin
	if (dbo.validate_parameter(@cantitate)=0)
	begin
		print('parametru invalid!')
		return
	end
	else

	--Create (insert)
	begin
		declare @Fid int
		declare @Titlu varchar(60)
		declare @Gen varchar(60)
		declare @i int
		set @i=1
		declare @Nume varchar(60)
		set @Fid=(SELECT MAX(Fid)FROM Filme);
		set @Fid=@Fid+1
		if @Fid is null set @Fid=1

		while @i <= @cantitate
		begin
			set @Titlu=convert(varchar(60),'Film'+convert(varchar(5),@Fid))
			set @Gen=convert(varchar(60),'Gen'+convert(varchar(5),@Fid))
				insert into Filme (Fid,Titlu,Gen)
				values (@Fid,@Titlu,@Gen)
				set @Fid=@Fid+1
				set @i=@i+1
		end
	end
	--Read (select )
	select * from Filme
	--Update
	update Filme set Titlu='AltTitlu'
	where Fid % 2 =0
	--Delete
	delete from Filme where Fid % 2=1

	print 'CRUD operations for Filme'
end;

exec CRUD_Filme -1;
exec CRUD_Filme 10;
select * from Filme
delete from Filme

--CRUD operations for Actori(Aid,Nume,Prenume,DataNastere)
create or alter procedure CRUD_Actori (@cantitate int )
as
	begin
	if (dbo.validate_parameter(@cantitate)=0)
	begin
		print('parametru invalid!')
		return
	end
	else

	--Create (insert)
	begin
		declare @Nume varchar(60)
		declare @Prenume varchar(60)
		declare @DataNastere date
		set @DataNastere=GETDATE();
		declare @i int
		set @i=1

		while @i <= @cantitate
		begin
			set @Nume=convert(varchar(60),'Nume'+convert(varchar(5),@i))
			set @Prenume=convert(varchar(60),'Prenume'+convert(varchar(5),@i))
				insert into Actori (Nume,Prenume,DataN)
				values (@Nume,@Prenume,@DataNastere)
				set @i=@i+1
		end
	end
	--Read (select )
	select * from Actori
	--Update
	update Actori set Nume='AltNume'
	where Aid % 2 =0
	--Delete
	delete from Actori where Aid % 2=1

	print 'CRUD operations for Actori'
end;

ALTER TABLE Seriale
ADD CONSTRAINT chk_NrEp CHECK (NrEp >= 1);
ALTER TABLE EnrolledS
ADD CONSTRAINT chk_Salariu CHECK (Salariu >= 0);

exec CRUD_Actori -1;
exec CRUD_Actori 10;
select * from Actori
delete from Actori

IF EXISTS (SELECT NAME FROM sys.indexes WHERE name='N_idx_netflix_titlu')
DROP INDEX N_idx_netflix_titlu ON Seriale
CREATE NONCLUSTERED INDEX N_idx_netflix_titlu ON Seriale(Titlu)

create or alter view vw_seriale as
select * from Seriale
where Titlu like 'S%'

exec CRUD_Seriale 50

select * from vw_seriale order by Titlu

create or alter view vw_filme as
select * from Filme
where Gen like 'G%'

IF EXISTS (SELECT NAME FROM sys.indexes WHERE name='N_idx_netflix_gen')
DROP INDEX N_idx_netflix_gen ON Filme
CREATE NONCLUSTERED INDEX N_idx_netflix_gen ON Filme(Gen)

exec CRUD_Filme 15
select * from vw_filme order by Gen
