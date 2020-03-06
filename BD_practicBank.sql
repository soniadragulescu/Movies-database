create database bank
go 
use bank 
go

---- 1) table creation and data insertion -----

create table Persons
(
	Pid INT PRIMARY KEY,
	Name VARCHAR(50),
	Gender VARCHAR(50),
	DateOfBirth DATE 
)


create table Types
(
	Tid INT PRIMARY KEY,
	Country VARCHAR(50),
	Element VARCHAR(50)
)

create table Coins
(
	Cid INT PRIMARY KEY,
	Value INT,
	Name VARCHAR(50),
	Type INT FOREIGN KEY REFERENCES Types(Tid)
)

create table Children
(
	Chid INT PRIMARY KEY,
	Name VARCHAR(50),
	Age INT,
	CoinType INT FOREIGN KEY REFERENCES Types(Tid)
)

create table Persons_Coins
(
	Pid INT FOREIGN KEY REFERENCES Persons(Pid),
	Cid INT FOREIGN KEY REFERENCES Coins(Cid),
	NumberOFCoins INT,
	Utility VARCHAR(50)
	CONSTRAINT PCid PRIMARY KEY(Pid, Cid)
)

insert into Persons(Pid, Name, Gender, DateOfBirth) values (1, 'Razvan', 'Male', '2000-05-08'), (2, 'Sonia', 'Female', '1999-07-03'), (3, 'Catalin', 'Male', '1995-11-02'), (4, 'Catalina', 'Female', '2002-10-22')

insert into Types(Tid, Element, Country) values (1, 'Gold', 'Romania'), (2, 'Silver', 'UK'), (3, 'Copper', 'Russia')

insert into Coins(Cid, Value, Name, Type) values (1, 5, 'lei', 1), (2, 10, 'lei', 1), (3, 1, 'lire', 2), (4, 100, 'lire', 2), (5, 15, 'bani', 3) 

insert into Children(Chid, Name, Age, CoinType) values (1, 'Mitica', 10,  1), (2, 'Gigi', 8, 1), (3, 'Ionel', 10,  2), (4, 'Russ', 5, 3), (5, 'Putin', 6, 3), (6, 'Marcel', 16, 3)

insert into Persons_Coins(Pid, Cid, NumberOFCoins, Utility) values (1, 1, 10, 'mc'), (1, 2, 2, 'kfc'), (2, 1, 2, 'lapte'), (2, 3, 4, 'jocuri'), (2, 5, 3, 'cola'), (4, 4, 6, 'loto'), (4, 1, 5, 'pariuri'), (4, 2, 5, 'poker')

---- utility ----
go

create or alter function person_has_coin (@pid INT, @cid INT)
	returns int
	as begin
		if((select count(*) from Persons_Coins where Pid = @pid and Cid = @cid) > 0)
			return 1
		else
			return 0
		return 0
	end

go



---- 2) procedure creation ----

go

create or alter procedure [dbo].[InsertCoins] 
	@pid INT,
	@cid INT,
	@numberOfCoins INT, 
	@utility VARCHAR(50)
	as begin
		if(dbo.person_has_coin(@pid, @cid) = 1) begin
			update Persons_Coins
			set 
				NumberOFCoins = @numberOfCoins,
				Utility = @utility
			where 
				Pid = @pid and Cid = @cid
		end
		else begin
			insert into Persons_Coins(Pid, Cid, NumberOFCoins, Utility) values (@pid, @cid, @numberOfCoins, @utility)
		end

	end

exec dbo.InsertCoins 2, 4, 11, 'lll'
select * from Persons_Coins

---- 3) view creation ----
 go

create or alter view vw_CoinType_Children as
	select CH.Name, T.Tid, CH.Age from Types T 
		inner join Children CH on T.Tid = CH.CoinType
		where CH.Age = 10

go 

select *  from vw_CoinType_Children 

---- 4) function creation ----
go

create or alter function show_person_coin_names (@coinid INT)
	returns table
	as return select P.Name, PC.NumberOFCoins from Persons P 
			INNER JOIN Persons_Coins PC on P.Pid = PC.Pid
			INNER JOIN Coins C on C.Cid = PC.Cid
			where C.Cid = @coinid and PC.NumberOFCoins > 2

go

select * from dbo.show_person_coin_names(2)