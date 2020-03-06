create database Univers
go
use Univers
go

--1.Planete, Exploratori,Sateliti,Roci_predominante

create table Planete (
	cod_p int PRIMARY KEY IDENTITY,
	nume VARCHAR(100),
	descriere VARCHAR(100),
	distS int,
	distP int,
	cod_r int foreign key references Roci_predominante(cod_r));

insert into Planete (nume, descriere,distS,distP, cod_r)
values ('Pluto','planeta1',100,200,1);
insert into Planete (nume, descriere,distS,distP, cod_r)
values ('Marte','planeta2',150,2000,1);
insert into Planete (nume, descriere,distS,distP, cod_r)
values ('Jupiter','planeta3',1000,200,1);


select * from Planete

create table Sateliti(
	cod_s int primary key identity,
	denumire varchar(100),
	marime int,
	specific int,
	cod_p INT FOREIGN KEY REFERENCES Planete(cod_p));

insert into Sateliti (denumire, marime, specific, cod_p)
values ('Satelit1',1000, 1,1);
insert into Sateliti (denumire, marime, specific, cod_p)
values ('Satelit2',1400, 2,1);
insert into Sateliti (denumire, marime, specific, cod_p)
values ('Satelit3',1990, 3,2);

select * from Sateliti

create table Roci_predominante(
	cod_r int primary key identity,
	denumire varchar(100),
	duritate int,
	an int);

insert into Roci_predominante (denumire, duritate, an)
values ('piatra', 100, 1500);
select * from Roci_predominante

create table Exploratori(
	cod_e int primary key identity,
	nume varchar(100),
	gen varchar(100),
	dataN date);

insert into Exploratori ( nume, gen, dataN)
values ('Sonia', 'F', '1999-07-03');
insert into Exploratori ( nume, gen, dataN)
values ('Vlad', 'M', '1999-06-13');
insert into Exploratori ( nume, gen, dataN)
values ('Razvan', 'M', '2000-05-08');

select * from Exploratori


create table Misiune(
	cod_p INT FOREIGN KEY REFERENCES Planete(cod_p),
	cod_e INT FOREIGN KEY REFERENCES Exploratori(cod_e),
	dataM date,
	descriere varchar(100),
	constraint pk_misiune PRIMARY KEY (cod_p,cod_e));

insert into Misiune (dataM, descriere, cod_p, cod_e)
values ('2020-01-01','primaMisiunePe2020',1,1)
insert into Misiune (dataM, descriere, cod_p, cod_e)
values ('2020-02-01','altaMisiune',1,2)
insert into Misiune (dataM, descriere, cod_p, cod_e)
values ('2020-03-01','misiune',1,3)
insert into Misiune (dataM, descriere, cod_p, cod_e)
values ('2020-01-01','primaMisiunePe2020',2,1)
insert into Misiune (dataM, descriere, cod_p, cod_e)
values ('2020-02-01','altaMisiune',2,2)
insert into Misiune (dataM, descriere, cod_p, cod_e)
values ('2020-02-01','altaMisiune',2,3)



--2.procedura stocata

create procedure adaugaMisiune ( @explorator INT, @planeta int, @data date, @descriere varchar(100))
as
begin
	if( exists ( select * from Misiune where cod_p=@planeta and cod_e=@explorator))
	begin
		update Misiune set dataM=@data, descriere=@descriere
		where cod_p=@planeta and cod_e=@explorator
	end
	else
	begin
		insert into Misiune (dataM, descriere, cod_p, cod_e)
		values (@data,@descriere,@planeta,@explorator)
	end
end

select * from Misiune
exec adaugaMisiune 1, 1, '2020-01-02','misiuneTest'

--3.view
create view satelitiPlaneta
as
	select S.denumire,P.nume from Planete as P inner join Sateliti as S on P.cod_p=S.cod_p
	group by P.nume,S.denumire;

go

select * from satelitiPlaneta

--4.functie

CREATE OR ALTER FUNCTION functie(@roca INT)
RETURNS TABLE AS
	RETURN 
	        SELECT P.nume, COUNT(*) as NumarExploratori
			FROM Misiune M INNER JOIN Planete P ON M.cod_p = P.cod_p
			WHERE P.cod_r = @roca
			GROUP BY P.cod_p, P.nume
			HAVING COUNT(*) =  (SELECT MAX(f.NumarExploratori)
								FROM (SELECT P.cod_p, COUNT(*) as NumarExploratori
							 FROM Misiune MM INNER JOIN Planete P ON MM.cod_p = P.cod_p
								GROUP BY P.cod_p) AS f);

GO

select * from functie(1);
