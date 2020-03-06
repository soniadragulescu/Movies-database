USE FlixNet
GO

CREATE TABLE Versiune(
version_id INT PRIMARY KEY DEFAULT 0)
GO

INSERT INTO Versiune(version_id)
VALUES (0)
GO

--1.Modific tipul coloanei (uspV1).
alter PROCEDURE uspV1
AS
BEGIN
ALTER TABLE Actori
ALTER COLUMN DataN DATETIME;
print 'Modific tipul coloanei (uspV1)'
END;

go
--undo1. Modific tipul coloanei  DataN din tabelul Actori din DATETIME in DATE (uspUndoV1).
alter PROCEDURE uspUndoV1
AS
BEGIN
ALTER TABLE Actori
ALTER COLUMN DataN DATE;
print'Modific tipul coloanei  DataN din tabelul Actori din DATETIME in DATE (uspUndoV1)'
END;

go
--2.Adauga o costrângere de DEFAULt pentru campul NrUtilizatori din tabelul Abonamente ca fiind 1(uspV2).
alter PROCEDURE uspV2
AS
BEGIN
ALTER TABLE Abonamente
ADD CONSTRAINT df_NrUtilizatori DEFAULT 1
FOR NrUtilizatori
print 'Adauga o costrângere de DEFAULt pentru campul NrUtilizatori din tabelul Abonamente ca fiind 1(uspV2)'
END;

go
--undo2.Renunta la costrângerea de DEFAULt pentru campul NrUtilizatori din tabelul Abonamente(uspUndoV2).
alter PROCEDURE uspUndoV2
AS
BEGIN
ALTER TABLE Abonamente
DROP CONSTRAINT df_NrUtilizatori
print 'Renunta la costrângerea de DEFAULt pentru campul NrUtilizatori din tabelul Abonamente(uspUndoV2)'
END;

go
--3.Creare tabela noua Cont (uspV3).
alter PROCEDURE uspV3
AS
BEGIN
CREATE TABLE Cont(
Cid INT PRIMARY KEY,
Iban VARCHAR(50))
print 'Creare tabela noua Cont (uspV3)'
END;

go
--undo3. Stergere tabela Cont (uspUndoV3).
alter PROCEDURE uspUndoV3
AS
BEGIN
DROP TABLE Cont
print 'Stergere tabela Cont (uspUndoV3)'
END;

go
--4.Adăuga un câmp nou Cid in tabela Abonamente (uspV4).
alter PROCEDURE uspV4
AS
BEGIN
ALTER TABLE Abonamente
ADD Cid INT not null
print 'Adăuga un câmp nou Cid in tabela Abonamente (uspV4)'
END;

go
--undo4. Sterge campul Cid din tabela Abonamente (uspUndoV4).
alter PROCEDURE uspUndoV4
AS
BEGIN
ALTER TABLE Abonamente
DROP COLUMN Cid
print 'Sterge campul Cid din tabela Abonamente (uspUndoV4)'
END;

go
--5.Creare constrângere de cheie străină in tabelul Abonamente (uspV5).
alter PROCEDURE uspV5
AS
begin
ALTER TABLE Abonamente
ADD CONSTRAINT fk_Cont
FOREIGN KEY(Cid) REFERENCES Cont(Cid)
print 'Creare constrângere de cheie străină in tabelul Abonamente (uspV5)'
end;
exec uspUndoV5

go
--undo5. Sterge constrangere cheie straina din tabelul Filme (uspUndoV5).
alter PROCEDURE uspUndoV5
AS
BEGIN
ALTER TABLE Abonamente
DROP CONSTRAINT fk_Cont
END;

go
--Procedura main primeste un parametru si aduce baza de date in versiunea respectiva
alter PROCEDURE Main
@versiuneNoua INT
AS
BEGIN
DECLARE @versiuneVeche INT
DECLARE @vers VARCHAR(10)
SELECT TOP 1 @versiuneVeche=version_id
FROM Versiune
IF @versiuneNoua<0 OR @versiuneNoua>5
BEGIN
	PRINT 'Versiunea trebuie sa fie intre 1 si 5!'
END
ELSE
BEGIN
	IF @versiuneVeche < @versiuneNoua
	BEGIN
		SET @versiuneVeche = @versiuneVeche+1
		WHILE @versiuneVeche <=@versiuneNoua
		BEGIN
			SET @vers = 'uspV' + CONVERT(VARCHAR(10),@versiuneVeche)
			EXEC @vers
			PRINT 'Executata procedura '+@vers
			UPDATE Versiune
			SET version_id=@versiuneVeche
			SET @versiuneVeche=@versiuneVeche+1
		END
	END
	ELSE
	BEGIN
		WHILE @versiuneVeche > @versiuneNoua
		BEGIN
			SET @vers= 'uspUndoV' + CONVERT(VARCHAR(10),@versiuneVeche)
			EXEC @vers
			PRINT 'Executata procedura'+@vers
			SET @versiuneVeche=@versiuneVeche-1
			UPDATE Versiune
			SET version_id=@versiuneVeche-1
		END
	END
END
UPDATE Versiune
SET version_id=@versiuneNoua
END;

EXEC Main 11

select * from Versiune
UPDATE Versiune
SET version_id=5


