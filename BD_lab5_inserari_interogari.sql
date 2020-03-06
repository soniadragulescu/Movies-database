use FlixNet
INSERT INTO Filme
(Titlu, Gen)
VALUES ('Maleficent','Adventure');
INSERT INTO Filme
(Titlu, Gen)
VALUES ('Joker','Drama');
INSERT INTO Filme
(Titlu, Gen)
VALUES ('12YearsASlave','Drama');
INSERT INTO Filme
(Titlu, Gen)
VALUES ('Venom','Adventure');
INSERT INTO Filme
(Titlu, Gen)
VALUES ('TheNun','Horror');
INSERT INTO Filme
(Titlu, Gen)
VALUES ('TheLastSong','Romance');

select * from Filme

INSERT INTO Producator
(Nume)
VALUES('Colm');
INSERT INTO Producator
(Nume)
VALUES('Owen');
INSERT INTO Producator
(Nume)
VALUES('Disney');

select * from Producator

INSERT INTO Seriale
(Titlu, Gen, NrEp,Pid)
VALUES ('PeakyBlinders','Crime',30,1);
INSERT INTO Seriale
(Titlu, Gen, NrEp,Pid)
VALUES ('BlackMirror','Mistery',20,2);
INSERT INTO Seriale
(Titlu, Gen, NrEp,Pid)
VALUES ('HannahMontana','Comedy',74,3);
INSERT INTO Seriale
(Titlu, Gen, NrEp,Pid)
VALUES ('TheSuiteLifeofZackAndCody','Comedy',101,3);
INSERT INTO Seriale
(Titlu, Gen, NrEp,Pid)
VALUES ('GravityFalls','Cartoon',43,3);

select * from Seriale

select distinct Gen from Seriale

select * from Actori 

INSERT INTO Actori
(Nume, Prenume, DataN)
VALUES ('Angelina','Jolie','04/06/1975');
INSERT INTO Actori
(Nume, Prenume, DataN)
VALUES ('Tom','Hardy','09/15/1977');
INSERT INTO Actori
(Nume, Prenume, DataN)
VALUES ('Miley','Cyrus','11/23/1992');

INSERT INTO EnrolledF
(Fid, Aid, DataInceput,Salariu)
VALUES (1,1,'09/09/2017',1200000);
INSERT INTO EnrolledF
(Fid, Aid, DataInceput,Salariu)
VALUES (6,3,'09/09/2010',980000);
INSERT INTO EnrolledF
(Fid, Aid, DataInceput,Salariu)
VALUES (4,2,'09/09/2018',780000);

select * from EnrolledF

INSERT INTO EnrolledS
(Sid, Aid, DataInceput,Salariu)
VALUES (1,2,'09/09/2014',120000);
INSERT INTO EnrolledS
(Sid, Aid, DataInceput,Salariu)
VALUES (2,3,'09/09/2018',90000);
INSERT INTO EnrolledS
(Sid, Aid, DataInceput,Salariu)
VALUES (3,3,'09/09/1999',89000);
INSERT INTO EnrolledS
(Sid, Aid, DataInceput,Salariu)
VALUES (4,3,'09/09/2000',100000);

select * from EnrolledS

/*1.Actori care joaca in filme de aventura*/
select A.Nume,F.Gen
from Actori as A, Filme as F, EnrolledF as EF
where A.Aid=EF.Aid and F.Fid=EF.Fid and F.Gen='Adventure';

/*2.Actori care joaca in seriale de comedie*/
select A.Nume
from Actori as A, Seriale as S, EnrolledS as ES
where A.Aid=ES.Aid and S.Sid=ES.Sid and S.Gen='Comedy'
group by A.Nume;

/*3.Acotrii care au jucat mai mult de 3 ani intr-un serial*/
SELECT A.Nume,S.Titlu, DATEDIFF(year, ES.DataInceput, '2019/10/26') as Vechime
from EnrolledS as ES, Actori as A, Seriale as S
where A.Aid=ES.Aid and ES.Sid=S.Sid and DATEDIFF(year, ES.DataInceput, '2019/10/26')>3;

/*4.Actorii care au castigat mai mult de 850000 euro dupa ce au jucat intr-un film*/
Select A.Nume, EF.Salariu
from Actori as A, EnrolledF as EF, Filme as F
where A.Aid=EF.Aid and F.Fid=EF.Fid and EF.Salariu>850000;

/*5.Actorii care au castigat mai mult de 1000000 pana in momentul prezent din toate episoadele in care au aparut*/
SELECT A.Nume, sum(ES.Salariu*S.NrEp)
FROM Actori as A, EnrolledS as ES, Seriale as S
where A.Aid=ES.Aid and S.Sid=ES.Sid
GROUP BY A.Nume
having sum(ES.Salariu*S.NrEp)>1000000;

/*6.Actorii care au avut ziua de nastere de cel putin 10 ori in timpul filmarilor*/
SELECT A.Nume, max(DATEDIFF(year, A.DataN,EF.DataInceput)) as AniInrolati
FROM Actori as A, EnrolledF as EF, Filme as F
where A.Aid=EF.Aid and F.Fid=EF.Fid
GROUP BY A.Nume
having  max(DATEDIFF(year, A.DataN,EF.DataInceput))>10;

/*7.Actori care a jucat si in intr-un film si intr-un serial.*/
Select A.Nume, S.Titlu, F.Titlu
from Actori as A, Filme as F, Seriale as S, EnrolledS as ES, EnrolledF as EF
where A.Aid=ES.Aid and A.Aid=EF.Aid and F.Fid=EF.Fid and ES.Sid=S.Sid;

/*8.Actor care a jucat intr-un serial de comedie*/
select distinct A.Nume
from Actori as A, Seriale as S,EnrolledS as ES
where A.Aid=ES.Aid and ES.Sid=S.Sid and S.Gen='Comedy';

/*9.Producatori care au regizat seriale de comedie.*/
select distinct P.Nume
from Producator as P, Seriale as S
where S.Pid=P.Pid and S.Gen='Comedy'

/*10.Actori nascuti in anii 80'*/
SELECT A.Nume,A.Prenume
FROM Actori as A
WHERE DataN>'01/01/1971' and DataN<'01/01/1980';
