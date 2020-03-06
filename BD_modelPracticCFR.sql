create database CFR
go
use CFR;

--1.trenuri, tipuri de tren, rute, statii
create table Tip_tren (
	cod_tt int PRIMARY KEY IDENTITY,
	descriere VARCHAR(100));

create table Tren(
	cod_t INT PRIMARY KEY IDENTITY,
	nume VARCHAR(100),
	cod_tt INT FOREIGN KEY REFERENCES Tip_tren(cod_tt));

create table Rute(
	cod_r INT PRIMARY KEY IDENTITY,
	nume VARCHAR(100),
	cod_t int FOREIGN KEY REFERENCES Tren(cod_t));

create table Statii(
	cod_s INT PRIMARY KEY IDENTITY,
	nume varchar(100));

create table Rute_statii(
	cod_r INT FOREIGN KEY REFERENCES Rute(cod_r),
	cod_s INT FOREIGN KEY REFERENCES Statii(cod_s),
	oraS TIME,
	oraP TIME,
	constraint pk_rutestatii PRIMARY KEY (cod_r,cod_s));

--2. procedură stocată care primește o rută, o stație, ora sosirii, ora plecării
--și adaugă noua stație rutei. Dacă stația există deja, se actualizează ora sosirii și ora
--plecării. 

create procedure adaugaStatie ( @ruta INT, @statie int, @oraS TIME, @oraP TIME)
as
begin
	if( exists ( select * from Rute_statii where cod_s=@statie and cod_r=@ruta))
	begin
		update Rute_statii set oraS=@oraS, oraP=@oraP
		where cod_s=@statie and cod_r=@ruta
	end
	else
	begin
		insert into Rute_statii ( cod_s,cod_r, oraS,oraP)
		values (@statie,@ruta,@oraS,@oraP)
	end
end

insert into Tip_tren( descriere)
values ('Personal')

insert into Tren(nume, cod_tt)
values ('Tren1', 1)
insert into Tren(nume, cod_tt)
values ('Tren2', 1)
insert into Tren(nume, cod_tt)
values ('Tren3', 1)

insert into Rute (nume, cod_t)
values ('Cluj-Brasov',1)
insert into Rute (nume, cod_t)
values ('Cluj-Fagaras',2)
insert into Rute (nume, cod_t)
values ('Cluj-Bucuresti',3)

insert into Statii (nume)
values ('Sibiu')

insert into Rute_statii(cod_r, cod_s,oraS,oraP)
values (1,1,'17:00:00','17:30:00')
insert into Rute_statii(cod_r, cod_s,oraS,oraP)
values (2,1,'10:00:00','17:30:00')
insert into Rute_statii(cod_r, cod_s,oraS,oraP)
values (3,1,'11:00:00','13:30:00')

exec adaugaStatie 1, 1, '10:40:00','11:30:00'

select * from Rute_statii


--3.view care afișează numele rutelor care conțin toate stațiile

create view ruteComplete
as
	select R.nume from Rute as R inner join Rute_statii as RS on R.cod_r=RS.cod_r
	group by R.cod_r, R.nume having count(*) = (select count(*) from Statii);

go
select * from ruteComplete

--3'. funcție care afișează toate stațiile care au mai mult de un tren la un
--anumit moment din zi.
go
create function ufStatieNrTrenuri()
	returns table as
	return select S.nume as statie from Statii S
	inner join Rute_statii RS on S.cod_s=RS.cod_s
	inner join Rute_statii RS2 on RS.cod_s=RS2.cod_s and RS.cod_r<>RS2.cod_r
	where (RS.oraS between RS2.oraS and RS2.oraP)
	or (RS.oraP between RS2.oraS and RS2.oraP)

go

select * from ufStatieNrTrenuri();