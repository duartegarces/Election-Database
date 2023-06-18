
-- Pedro Guerra 70596 Duarte Garcês 70860

USE master
GO

CREATE DATABASE Eleicao
GO

-- Criação das tabelas

USE Eleicao
GO

CREATE TABLE Pessoas
(
	
	n_eleitor INTEGER NOT NULL,
	Nome VARCHAR(50) NOT NULL,
	Apelido VARCHAR(50) NOT NULL,
	Nacionalidade VARCHAR(50) NOT NULL,
	DataNascimento SMALLDATETIME NOT NULL,
	CHECK (DataNascimento < GETDATE()),
	UNIQUE(n_eleitor),
	PRIMARY KEY (n_eleitor)

)
GO

CREATE TABLE Escritorio
(
	
	codigo_escritorio INTEGER IDENTITY(1,1) NOT NULL,
	Nome VARCHAR(50) NOT NULL,
	PRIMARY KEY (codigo_escritorio)

)
GO

CREATE TABLE Mesa_eleitoral
(
	
	id_mesa INTEGER IDENTITY(1,1) NOT NULL,
	Titulo VARCHAR(50) NOT NULL,
	Localizacao VARCHAR(50) NOT NULL,
	UNIQUE(Localizacao),
	PRIMARY KEY (id_mesa)

)
GO

CREATE TABLE Cargos
(
	
	id_cargo INTEGER IDENTITY(1,1) NOT NULL,
	Titulo VARCHAR(50) NOT NULL,
	Descricao VARCHAR(50) NOT NULL,
	UNIQUE(Descricao, Titulo),
	PRIMARY KEY (id_cargo)

)
GO

CREATE TABLE Candidatos
(
	
	n_candidato INTEGER NOT NULL,
	PRIMARY KEY(n_candidato),
	FOREIGN KEY (n_candidato) REFERENCES Pessoas(n_eleitor)

)
GO

CREATE TABLE Candidato_Escritorios
(
	
	n_candidato INTEGER NOT NULL,
	codigo_escritorio INTEGER NOT NULL,
	PRIMARY KEY(n_candidato, codigo_escritorio),
	FOREIGN KEY (n_candidato) REFERENCES Candidatos(n_candidato),
	FOREIGN KEY(codigo_escritorio) REFERENCES Escritorio(codigo_escritorio)

)
GO

CREATE TABLE Presidentes
(
	
	n_presidente INTEGER NOT NULL,
	idade INTEGER NOT NULL,
	CHECK(idade > 0),
	PRIMARY KEY(n_presidente),
	FOREIGN KEY (n_presidente) REFERENCES Pessoas(n_eleitor)

)
GO

CREATE TABLE Vogais
(
	
	n_vogal INTEGER NOT NULL,
	PRIMARY KEY(n_vogal),
	FOREIGN KEY (n_vogal) REFERENCES Pessoas(n_eleitor)

)
GO

CREATE TABLE Participar
(
	
	n_presidente INTEGER NOT NULL,
	n_vogal_a INTEGER NOT NULL,
	n_vogal_b INTEGER NOT NULL,
	id_mesa INTEGER NOT NULL,
	data_ SMALLDATETIME NOT NULL DEFAULT GETDATE(),
	hora TIME NOT NULL DEFAULT CONVERT(varchar(10), GETDATE(), 108),
	UNIQUE(n_vogal_a, n_vogal_b),
	PRIMARY KEY(n_presidente, n_vogal_a, n_vogal_b, id_mesa, data_),
	FOREIGN KEY (n_presidente) REFERENCES Presidentes(n_presidente),
	FOREIGN KEY (n_vogal_a) REFERENCES Vogais(n_vogal),
	FOREIGN KEY (n_vogal_b) REFERENCES Vogais(n_vogal),
	FOREIGN KEY (id_mesa) REFERENCES Mesa_eleitoral(id_mesa)

)
GO

CREATE TABLE Presidir
(
	
	n_presidente INTEGER NOT NULL,
	id_mesa INTEGER NOT NULL,
	data_inicio SMALLDATETIME NOT NULL DEFAULT GETDATE(),
	data_fim SMALLDATETIME,
	PRIMARY KEY(n_presidente, id_mesa, data_inicio),
	FOREIGN KEY (n_presidente) REFERENCES Presidentes(n_presidente),
	FOREIGN KEY (id_mesa) REFERENCES Mesa_eleitoral(id_mesa)

)
GO

CREATE TABLE Assumir
(
	
	n_candidato INTEGER NOT NULL,
	id_cargo INTEGER NOT NULL,
	data_inicio SMALLDATETIME NOT NULL DEFAULT GETDATE(),
	data_fim SMALLDATETIME,
	n_votos INTEGER NOT NULL,
	CHECK(n_votos > 0),
	PRIMARY KEY(n_candidato, id_cargo, data_inicio),
	FOREIGN KEY (n_candidato) REFERENCES Candidatos(n_candidato),
	FOREIGN KEY (id_cargo) REFERENCES Cargos(id_cargo)

)
GO

CREATE TABLE Candidatura
(	
	n_candidato INTEGER NOT NULL,
	id_cargo INTEGER NOT NULL,
	data_ SMALLDATETIME NOT NULL DEFAULT GETDATE(),
	orcamento MONEY NOT NULL,
	CHECK(orcamento > 0),
	PRIMARY KEY(n_candidato, id_cargo, data_),
	FOREIGN KEY (n_candidato) REFERENCES Candidatos(n_candidato),
	FOREIGN KEY (id_cargo) REFERENCES Cargos(id_cargo)

)
GO

CREATE TABLE Mandatario
(
	n_candidato INTEGER NOT NULL,
	id_cargo INTEGER NOT NULL,
	data_ SMALLDATETIME NOT NULL DEFAULT GETDATE(),
	n_eleitor INTEGER NOT NULL,

	PRIMARY KEY(n_eleitor),
	FOREIGN KEY (n_candidato, id_cargo, data_) REFERENCES Candidatura(n_candidato, id_cargo, data_),
	FOREIGN KEY (n_eleitor) REFERENCES Pessoas(n_eleitor)
)
GO

CREATE TABLE Votar
(
	n_candidato INTEGER NOT NULL,
	id_cargo INTEGER NOT NULL,
	data_ SMALLDATETIME NOT NULL DEFAULT GETDATE(),
	data_voto SMALLDATETIME NOT NULL DEFAULT GETDATE(),
	local_ VARCHAR(50) NOT NULL,
	n_eleitor INTEGER NOT NULL,

	PRIMARY KEY(data_voto, n_eleitor),
	FOREIGN KEY (n_candidato, id_cargo, data_) REFERENCES Candidatura(n_candidato, id_cargo, data_),
	FOREIGN KEY (n_eleitor) REFERENCES Pessoas(n_eleitor)
)
GO

-- Inserção de dados

INSERT INTO Pessoas(n_eleitor, Nome, Apelido, Nacionalidade, DataNascimento)
VALUES 
(34567, 'Afonso', 'Rocha', 'Portuguesa', '02 Feb 1972'),
(58251, 'João', 'Almeida', 'Portuguesa', '22 Jun 1994'),
(23287, 'Joana', 'Crispim', 'Portuguesa', '12 Dec 2000'),
(47114, 'Pedro', 'Silva', 'Portuguesa', '03 Oct 1983'),
(12932, 'Arsénio', 'Mar', 'Portuguesa', '15 Mar 1981'),
(65231, 'Marco', 'Barroso', 'Portuguesa', '27 Aug 1999'),
(41923, 'Maria', 'Teixeira', 'Portuguesa', '13 Sep 1962'),
(7642, 'Joaquim', 'Garcês', 'Portuguesa', '05 Jan 1993'),
(73487, 'Naylson', 'Bispo', 'Brasileira', '30 Apr 1991'),
(22542, 'Alexandre', 'Cardoso', 'Portuguesa', '03 May 1996'),
(38125, 'Miguel', 'Henriques', 'Portuguesa', '08 Apr 1953'),
(5734, 'Jorge', 'Machado', 'Portuguesa', '16 Oct 1976'),
(9721, 'Diogo', 'Fernandes', 'Portuguesa', '17 Jul 1987'),
(69699, 'Bruno', 'Bessa', 'Portuguesa', '09 Sep 1969'),
(86259, 'Rodrigo', 'Costa', 'Portuguesa', '10 Feb 1978'),
(3167, 'António', 'Salazar', 'Portuguesa', '25 Apr 1976'),
(1921, 'Felizberto', 'Alcazar', 'Portuguesa', '1 Oct 1942'),
(50221, 'Paulo', 'Martins', 'Portuguesa', '5 Aug 1985'),
(78571, 'Josefina', 'Baptista', 'Portuguesa', '18 Nov 1964'),
(88623, 'Emmanuel', 'Leite', 'Brasileira', '3 Nov 1986'),
(93106, 'Carlos', 'Carvalho', 'Portuguesa', '1 Mar 2000'),
(97934, 'Filipe', 'Santos', 'Portuguesa', '31 May 1977'),
(102549, 'Otávio', 'Lagos', 'Portuguesa', '12 Sep 1985')
GO

Select *
FROM Pessoas

INSERT INTO Escritorio VALUES
('Edifício Boavista'), 
('Torre Monsanto'), 
('Edifício Lidador'), 
('Edifício Jardins Da Rocha')
GO

Select *
FROM Escritorio

INSERT INTO Mesa_eleitoral VALUES
('Mesa1','Vila Real'),
('Mesa2', 'Porto'),
('Mesa3', 'Coimbra'),
('Mesa4', 'Braga'),
('Mesa5', 'Vila Do Conde')
GO

SELECT *
FROM Mesa_eleitoral

DBCC CHECKIDENT('Cargos', RESEED, 0)

INSERT INTO Cargos VALUES
('Presidente', 'Chefe de Estado da Nação.'),
('Primeiro Ministro', 'Chefe do Governo da República.'),
('Vice Presidente', '2º mais alto magistrado da Nação.'),
('Vice Primeiro Ministro', '2º Lugar na Hierarquia do Governo.'),
('Secretário de Estado', 'Inferior a Ministro.')
GO

SELECT *
FROM Cargos

-- Verificação se o Id a ser colocado na tabela Candidatos não existe nas tabelas Presidentes e Vogais

INSERT INTO Candidatos(n_candidato) VALUES 
(34567), 
(23287), 
(58251)
GO

SELECT * 
FROM Candidatos
GO

--Trigger para garantir a hierarquia exclusiva na tabela Candidatos

CREATE TRIGGER Candidatos_VAL
   ON  Candidatos
   AFTER INSERT,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF EXISTS(
		SELECT NULL
		  FROM INSERTED I
		  JOIN Presidentes P ON I.n_candidato = P.n_presidente
	)
	OR EXISTS(
		SELECT NULL
		  FROM INSERTED I
		  JOIN Vogais V ON I.n_candidato = V.n_vogal
	)
	BEGIN
		RAISERROR('Failed to insert value in table Candidatos',16,1)
		ROLLBACK
	END

END

INSERT INTO Candidato_Escritorios(n_candidato, codigo_escritorio) VALUES
(34567, 1),
(23287, 3),
(58251, 4),
(23287, 2)
GO

SELECT *
FROM Candidato_Escritorios

INSERT INTO Presidentes(n_presidente, idade) VALUES 
(12932, DATEDIFF(YEAR, (SELECT DataNascimento FROM Pessoas WHERE n_eleitor = 12932), GETDATE())), 
(47114, DATEDIFF(YEAR, (SELECT DataNascimento FROM Pessoas WHERE n_eleitor = 47114), GETDATE())), 
(65231, DATEDIFF(YEAR, (SELECT DataNascimento FROM Pessoas WHERE n_eleitor = 65231), GETDATE())), 
(41923, DATEDIFF(YEAR, (SELECT DataNascimento FROM Pessoas WHERE n_eleitor = 41923), GETDATE())), 
(7642, DATEDIFF(YEAR, (SELECT DataNascimento FROM Pessoas WHERE n_eleitor = 7642), GETDATE()))
GO

SELECT *
FROM Presidentes
GO

-- Trigger para garantir a hierarquia exclusiva na tabela Presidentes

CREATE TRIGGER Presidentes_VAL
   ON  Presidentes
   AFTER INSERT,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF EXISTS(
		SELECT NULL
		  FROM INSERTED I
		  JOIN Candidatos C ON I.n_presidente = C.n_candidato
	)
	OR EXISTS(
		SELECT NULL
		  FROM INSERTED I
		  JOIN Vogais V ON I.n_presidente = V.n_vogal
	)
	BEGIN
		RAISERROR('Failed to insert value in Presidentes',16,1)
		ROLLBACK
	END

END


-- Verificação se o Id a ser colocado na tabela Vogais não existe nas tabelas Candidatos e Presidentes

INSERT INTO Vogais(n_vogal) Values 
(73487), 
(22542), 
(38125), 
(5734), 
(9721), 
(69699), 
(86259), 
(3167), 
(1921), 
(50221)
GO

SELECT *
FROM Vogais
GO

-- Trigger para garantir a hierarquia exclusiva na tabela Vogais

CREATE TRIGGER Vogais_VAL
   ON  Vogais
   AFTER INSERT,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	IF EXISTS(
		SELECT NULL
		  FROM INSERTED I
		  JOIN Candidatos C ON I.n_vogal = C.n_candidato
	)
	OR EXISTS(
		SELECT NULL
		  FROM INSERTED I
		  JOIN Presidentes P ON I.n_vogal = P.n_presidente
	)
	BEGIN
		RAISERROR('Failed to insert value in Vogais',16,1)
		ROLLBACK
	END

END

INSERT INTO Participar(n_presidente, n_vogal_a, n_vogal_b, id_mesa, data_, hora) VALUES
(12932, 73487, 22542, 1, '12 Apr 2020', '13:30'),
(47114, 38125, 5734, 2, '15 Jan 2020', '10:00'),
(65231, 9721, 69699, 3, '09 Mar 2020', '08:00'),
(41923, 86259, 3167, 4, '24 Jun 2020', '16:45'),
(7642, 1921, 50221, 5, '03 Aug 2020', '12:15')
GO

SELECT *
FROM Participar

INSERT INTO Presidir(n_presidente, id_mesa, data_inicio) VALUES
(12932, (SELECT id_mesa FROM Participar WHERE n_presidente = 12932), (SELECT data_ FROM Participar WHERE n_presidente = 12932)),
(47114, (SELECT id_mesa FROM Participar WHERE n_presidente = 47114), (SELECT data_ FROM Participar WHERE n_presidente = 47114)),
(65231, (SELECT id_mesa FROM Participar WHERE n_presidente = 65231), (SELECT data_ FROM Participar WHERE n_presidente = 65231)),
(41923, (SELECT id_mesa FROM Participar WHERE n_presidente = 41923), (SELECT data_ FROM Participar WHERE n_presidente = 41923)),
(7642, (SELECT id_mesa FROM Participar WHERE n_presidente = 7642), (SELECT data_ FROM Participar WHERE n_presidente = 7642))
GO

SELECT * 
FROM Presidir

INSERT INTO Candidatura(n_candidato, id_cargo, data_, orcamento) VALUES
(34567, 1, '10 Jan 2020', 400000), 
(23287, 2, '09 Mar 2020', 750000), 
(58251, 3, '03 Feb 2020', 245000)

INSERT INTO Candidatura(n_candidato, id_cargo, data_, orcamento) VALUES
(23287, 2, '08 Mar 2019', 750000)

INSERT INTO Candidatura(n_candidato, id_cargo, data_, orcamento) VALUES
(34567, 1, '10 Jan 2021', 400000), 
(23287, 2, '09 Mar 2021', 750000), 
(58251, 3, '03 Feb 2021', 245000)

SELECT *
FROM Candidatura
GO

INSERT INTO Votar(n_candidato, id_cargo, data_, data_voto, local_, n_eleitor) VALUES 
(34567, (SELECT id_cargo FROM Candidatura WHERE n_candidato = 34567), (SELECT data_ FROM Candidatura WHERE n_candidato = 34567), '05 Sep 2020', 'Vila Real', 34567),
(23287, (SELECT id_cargo FROM Candidatura WHERE n_candidato = 23287), (SELECT data_ FROM Candidatura WHERE n_candidato = 23287), '05 Sep 2020', 'Coimbra', 23287),
(58251, (SELECT id_cargo FROM Candidatura WHERE n_candidato = 58251), (SELECT data_ FROM Candidatura WHERE n_candidato = 58251), '05 Sep 2020', 'Coimbra', 58251),
(58251, (SELECT id_cargo FROM Candidatura WHERE n_candidato = 58251), (SELECT data_ FROM Candidatura WHERE n_candidato = 58251), '05 Sep 2020', 'Braga', 47114),
(23287, (SELECT id_cargo FROM Candidatura WHERE n_candidato = 23287), (SELECT data_ FROM Candidatura WHERE n_candidato = 23287), '05 Sep 2020', 'Porto', 12932),
(23287, (SELECT id_cargo FROM Candidatura WHERE n_candidato = 23287), (SELECT data_ FROM Candidatura WHERE n_candidato = 23287), '05 Sep 2020', 'Coimbra', 65231),
(34567, (SELECT id_cargo FROM Candidatura WHERE n_candidato = 34567), (SELECT data_ FROM Candidatura WHERE n_candidato = 34567), '05 Sep 2020', 'Vila Real', 41923),
(23287, (SELECT id_cargo FROM Candidatura WHERE n_candidato = 23287), (SELECT data_ FROM Candidatura WHERE n_candidato = 23287), '05 Sep 2020', 'Vila Do Conde', 7642),
(34567, (SELECT id_cargo FROM Candidatura WHERE n_candidato = 34567), (SELECT data_ FROM Candidatura WHERE n_candidato = 34567), '05 Sep 2021', 'Vila Real', 34567),
(23287, (SELECT id_cargo FROM Candidatura WHERE n_candidato = 23287), (SELECT data_ FROM Candidatura WHERE n_candidato = 23287), '05 Sep 2021', 'Coimbra', 23287),
(58251, (SELECT id_cargo FROM Candidatura WHERE n_candidato = 58251), (SELECT data_ FROM Candidatura WHERE n_candidato = 58251), '05 Sep 2021', 'Coimbra', 58251),
(58251, (SELECT id_cargo FROM Candidatura WHERE n_candidato = 58251), (SELECT data_ FROM Candidatura WHERE n_candidato = 58251), '05 Sep 2021', 'Braga', 47114),
(23287, (SELECT id_cargo FROM Candidatura WHERE n_candidato = 23287), (SELECT data_ FROM Candidatura WHERE n_candidato = 23287), '05 Sep 2021', 'Porto', 12932),
(23287, (SELECT id_cargo FROM Candidatura WHERE n_candidato = 23287), (SELECT data_ FROM Candidatura WHERE n_candidato = 23287), '05 Sep 2021', 'Coimbra', 65231),
(34567, (SELECT id_cargo FROM Candidatura WHERE n_candidato = 34567), (SELECT data_ FROM Candidatura WHERE n_candidato = 34567), '05 Sep 2021', 'Vila Real', 41923),
(23287, (SELECT id_cargo FROM Candidatura WHERE n_candidato = 23287), (SELECT data_ FROM Candidatura WHERE n_candidato = 23287), '05 Sep 2021', 'Vila Do Conde', 7642)
GO

INSERT INTO Votar(n_candidato, id_cargo, data_, data_voto, local_, n_eleitor) VALUES 
(34567, (SELECT id_cargo FROM Candidatura WHERE n_candidato = 34567), (SELECT data_ FROM Candidatura WHERE n_candidato = 34567), '23 May 2021', 'Vila Real', 50221)

SELECT *
FROM Votar
GO

INSERT INTO Assumir(n_candidato, id_cargo, data_inicio, n_votos) VALUES
(34567, (SELECT id_cargo FROM Candidatura WHERE n_candidato = 34567), '25 Jan 2021', (SELECT COUNT(*) FROM Votar WHERE n_candidato = 34567)),
(23287, (SELECT id_cargo FROM Candidatura WHERE n_candidato = 23287), '03 Feb 2021', (SELECT COUNT(*) FROM Votar WHERE n_candidato = 23287)),
(58251, (SELECT id_cargo FROM Candidatura WHERE n_candidato = 58251), '03 Feb 2021', (SELECT COUNT(*) FROM Votar WHERE n_candidato = 58251))

SELECT *
FROM Assumir

INSERT INTO Mandatario(n_candidato, id_cargo, data_, n_eleitor) VALUES
(34567, (SELECT id_cargo FROM Candidatura WHERE n_candidato = 34567), (SELECT data_ FROM Candidatura WHERE n_candidato = 34567), 93106),
(23287, (SELECT id_cargo FROM Candidatura WHERE n_candidato = 23287), (SELECT data_ FROM Candidatura WHERE n_candidato = 23287), 97934),
(58251, (SELECT id_cargo FROM Candidatura WHERE n_candidato = 58251), (SELECT data_ FROM Candidatura WHERE n_candidato = 58251), 102549)

SELECT *
FROM Mandatario
GO

--2.1 Query para mostrar o último cargo assumido por cada candidato
SELECT C.Titulo, A.data_inicio, P.Nome
FROM Assumir A, Cargos C, Candidatos CA, Pessoas P
WHERE A.n_candidato = CA.n_candidato AND CA.n_candidato = P.n_eleitor AND A.id_cargo = C.id_cargo AND A.data_inicio = (SELECT MAX(data_inicio) FROM Assumir WHERE n_candidato = A.n_candidato)

--2.2 Query para mostrar quantos vogais tem cada mesa eleitoral
SELECT M.Titulo, (SELECT COUNT(*) FROM Vogais WHERE P.n_vogal_a = n_vogal OR P.n_vogal_b = n_vogal) as N_Vogais
FROM Mesa_eleitoral M, Participar P
WHERE P.id_mesa = M.id_mesa
GROUP BY M.Titulo, P.n_vogal_a, P.n_vogal_b

--2.3 Query para mostrar as 2 primeiras pessoas a votar hoje em Vila Real
SELECT P.Nome
FROM Votar V
JOIN Pessoas P ON V.n_eleitor = P.n_eleitor AND V.data_voto >= cast(getdate() As Date)
ORDER BY data_voto 

--2.4 Query para mostrar nos últimos 90 dias as pessoas que presidiram mais do que 2 mesas eleitorais. Ordenar alfabeticamente
SELECT P.Nome, P.Apelido, M.Titulo, Pr.data_inicio
FROM Presidir Pr, Mesa_eleitoral M, Pessoas P, Presidentes Pre
WHERE DATEDIFF(day, Pr.data_inicio, GETDATE()) <= 90 AND Pr.n_presidente = Pre.n_presidente AND P.n_eleitor = Pre.n_presidente AND Pr.id_mesa = M.id_mesa AND 
	(SELECT COUNT(*) FROM Presidir Prx, Presidentes PreX WHERE Prx.id_mesa = Pr.id_mesa AND Pre.n_presidente = PreX.n_presidente) > 2
ORDER BY P.Nome, P.Apelido

--2.5 Query para mostrar qual o cargo com mais candidaturas
SELECT Cg.Titulo, MAX(cands_cargo.ncands) as N_Cands
FROM Candidatura C, Cargos Cg, (SELECT id_cargo, COUNT(*) ncands FROM Candidatura group by id_cargo) as cands_cargo,
(select max(ncands) as max_ncands FROM (SELECT id_cargo, COUNT(*) ncands FROM Candidatura group by id_cargo) as cands_cargo2) mais_cands
WHERE C.id_cargo = Cg.id_cargo
  AND Cg.id_cargo = cands_cargo.id_cargo
  AND cands_cargo.ncands = mais_cands.max_ncands
GROUP BY Cg.Titulo
GO

--2.6 Query para mostrar a nacionalidade e a que cargo se candidadata o candidato mais novo
WITH Max_Date as(
	SELECT n_eleitor, DataNascimento, Nacionalidade, Nome, Apelido 
	FROM Pessoas P
	WHERE DataNascimento = (SELECT MAX(DataNascimento) FROM Pessoas JOIN Candidatos C ON n_eleitor = C.n_candidato)
)
SELECT Max_Date.Nome, Max_Date.Apelido, DATEDIFF(YEAR, Max_Date.DataNascimento, GETDATE()), Max_Date.Nacionalidade, CG.Titulo
	FROM Max_Date
	LEFT JOIN Candidatura CA ON Max_Date.n_eleitor = CA.n_candidato
	LEFT JOIN Cargos CG ON CG.id_cargo = CA.id_cargo

--2.7 Query para mostrar o total dos orçamentos de todas as candidaturas de cada candidato
SELECT P.n_eleitor, P.Nome, SUM(C.orcamento) Total_Gasto
FROM Pessoas P
JOIN Candidatura C ON P.n_eleitor = C.n_candidato
GROUP BY P.n_eleitor, P.Nome, P.Apelido
ORDER BY Total_Gasto
GO

--3.1 Dados o ID de uma Mesa Eleitoral e o Mês, apresente uma tabela com os pares de vogais que participaram em cada Mesa Eleitoral. O
--procedimento deve devolver o número total de pares distintos que participaram nas mesas eleitorais.
CREATE PROCEDURE Vogais_Mes @codMesa INTEGER, @mes INTEGER
AS
	IF @mes > 0 AND @mes < 13 AND @codMesa > 0
	BEGIN
		SELECT P.n_vogal_a, P.n_vogal_b
		FROM Participar P
		WHERE @codMesa = P.id_mesa AND @mes = MONTH(P.data_);
		--RETURN @@ROWCOUNT
		RETURN (SELECt COUNT(1) FROM (
			SELECT DISTINCT P.n_vogal_a, P.n_vogal_b
			FROM Participar P
			WHERE @codMesa = P.id_mesa AND @mes = MONTH(P.data_)
		) counter_s)
	END
	ELSE
		print 'Valores inseridos incorretos'
GO

DECLARE @rv INT
EXECUTE @rv = Vogais_Mes 2, 1
PRINT 'RV='+CAST(@rv AS VARCHAR)
GO

--3.2 Assumindo que todas as pessoas com mais de 18 anos podem votar, crie um procedimento que dado o número de eleitor do candidato, o cargo e a data da
-- candidatura, para uma votação em curso, verifique a percentagem de pessoas que já participaram na votação.
CREATE PROCEDURE PercentVotos @codcandidato INTEGER, @codCargo INTEGER, @dataCand SMALLDATETIME
AS
	DECLARE @totalvc INTEGER
	DECLARE @totalv INTEGER
	DECLARE @percentvc DECIMAL(4,2)
	SET @totalv = (SELECT COUNT(1) FROM Pessoas)
	SET @totalvc = (
		SELECT COUNT(1)
		FROM Votar
		WHERE n_candidato = @codcandidato AND id_cargo = @codCargo AND data_ = @dataCand
	)
	SET @percentvc = ROUND(CAST(@totalvc AS FLOAT)*100.0/CAST(@totalv AS FLOAT), 2)
	print 'Percentagem: ' + CAST(@percentvc as VARCHAR)
GO

EXECUTE PercentVotos 23287, 2, '2020-03-09'
GO


--3.3 Assumindo que uma Pessoa não pode assumir dois cargos em simultâneo, crie um trigger que ao inserir um registo de um cargo para um candidato na tabela assumir
--automaticamente insira a mesma data como data de fim no cargo que o candidato anteriormente ocupava.
CREATE TRIGGER Cargos_VAL
   ON  Assumir
   AFTER INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	UPDATE Assumir SET data_fim = I.data_inicio
	  FROM Assumir a
	  JOIN INSERTED I ON a.n_candidato = I.n_candidato
      WHERE a.data_fim is null

END



