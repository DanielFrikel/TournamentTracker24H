CREATE DATABASE Tournaments;
use master;
use Tournaments;
DROP DATABASE Tournaments;
--Creates the Prizes Table
USE [Tournaments]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Prizes](
    [id] [int] IDENTITY(1,1) NOT NULL,
    [PlaceNumber] [int] NOT NULL,
    [PlaceName] [nvarchar](50) NOT NULL,
    [PrizeAmount] [money] NOT NULL,
    [PrizePercentage] [float] NOT NULL,
    CONSTRAINT [PK_Prizes] PRIMARY KEY CLUSTERED
    (
        [id] ASC
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON
    ) ON [PRIMARY]
)
GO

ALTER TABLE [dbo].[Prizes] ADD CONSTRAINT [DF_Prizes_PrizeAmount] DEFAULT ((0)) FOR [PrizeAmount]
GO

ALTER TABLE [dbo].[Prizes] ADD CONSTRAINT [DF_Prizes_PrizePercentage] DEFAULT ((0)) FOR [PrizePercentage]


----Stored Procedure
--CREATE PROCEDURE dbo.spTestPerson
--	@LastName nvarchar(100),
--AS
--BEGIN
--	SET NOCOUNT ON;
--	SELECT * FROM dbo.TestPerson
--	WHERE LastName = @LastName;
--END 
--GO

----Se ejecuta con:
--exec dbo.spTestPerson 'Corey'


--================================================================================================================

CREATE PROCEDURE dbo.spPrizes_Insert
	@PlaceNumber int,
	@PlaceName nvarchar(50),
	@PrizeAmount money,
	@PrizePercentage float,
	@id int = 0 output
AS
BEGIN
	SET NOCOUNT ON
		INSERT INTO dbo.Prizes(PlaceNumber,PlaceName,PrizeAmount,PrizePercentage)
		VALUES(@PlaceNumber,@PlaceName,@PrizeAmount,@PrizePercentage);

		SELECT @id = SCOPE_IDENTITY();
END
GO
--================================================================================================================
CREATE PROCEDURE dbo.spPeople_Insert
	@FirstName NVARCHAR(100),
	@LastName NVARCHAR(100),
	@EmailAddress NVARCHAR(100),
	@CellphoneNumber VARCHAR(20),
	@id INT = 0 OUTPUT
AS
BEGIN	
	SET NOCOUNT ON;

    INSERT INTO dbo.People (FirstName, LastName, EmailAddress, CellphoneNumber)
	VALUES(@FirstName,@LastName,@EmailAddress,@CellphoneNumber);

	SELECT @id=SCOPE_IDENTITY();
END
GO
--================================================================================================================

CREATE PROCEDURE dbo.spPeople_GetAll
AS
BEGIN
    SELECT * FROM People;
END
GO

--================================================================================================================

CREATE PROCEDURE [dbo].[spPrizes_GetByTournament]
	@TournamentId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT p.*
	FROM dbo.Prizes p
	INNER JOIN dbo.TournamentPrizes t ON p.id = t.PrizeId
	WHERE t.TournamentId = @TournamentId
END
GO
--================================================================================================================

CREATE PROCEDURE dbo.spTeams_Insert
	@TeamName NVARCHAR(100),
	@id INT = 0 OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO dbo.Teams(TeamName)
	VALUES (@TeamName);
    
	SELECT @id = SCOPE_IDENTITY();
END
GO

--================================================================================================================

CREATE PROCEDURE dbo.spTeamMembers_Insert
	@TeamId INT,
	@PersonId INT,
	@id INT = 0 OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO dbo.TeamMembers(TeamId, PersonId)
	VALUES (@TeamId, @PersonId);
    
	SELECT @id = SCOPE_IDENTITY();
END
GO

--================================================================================================================
CREATE PROCEDURE dbo.spTeam_GetAll
AS
BEGIN
    SELECT * FROM Teams;
END
GO

--================================================================================================================

CREATE PROCEDURE [dbo].[spTeamMembers_GetByTeam]
	@TeamId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT p.*
	FROM dbo.TeamMembers m
	INNER JOIN dbo.People p ON m.PersonId = p.id
	WHERE m.TeamId = @TeamId
END
GO

--================================================================================================================

CREATE PROCEDURE dbo.spTournaments_Insert
	@TournamentName NVARCHAR(200),
	@EntryFee MONEY,
	@id INT = 0 OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO dbo.Tournaments(TournamentName, EntryFee, Active)
	VALUES (@TournamentName,@EntryFee, 1);

	SELECT @id = SCOPE_IDENTITY();
END
GO

--================================================================================================================

CREATE PROCEDURE dbo.spTournamentsPrizes_Insert
	@TournamentId INT,
	@PrizeId INT,
	@id INT = 0 OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO dbo.TournamentPrizes(TournamentId, PrizeId	)
	VALUES (@TournamentId,@PrizeId);

	SELECT @id = SCOPE_IDENTITY();
END
GO

--================================================================================================================

CREATE PROCEDURE dbo.spTournamentEntries_Insert
	@TournamentId INT,
	@TeamId INT,
	@id INT = 0 OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO dbo.TournamentEntries(TournamentId, TeamId)
	VALUES (@TournamentId, @TeamId);

	SELECT @id = SCOPE_IDENTITY();
END
GO
--================================================================================================================

CREATE PROCEDURE dbo.spMatchups_Insert
	@TournamentId INT,
	@MatchupRound INT,
	@id INT = 0 OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO dbo.Matchups(TournamentId, MatchupRound)
	VALUES (@TournamentId, @MatchupRound);

	SELECT @id = SCOPE_IDENTITY();
END
GO

--================================================================================================================

ALTER TABLE Matchups ADD TournamentId INT NOT NULL,
						 FOREIGN KEY(TournamentId) REFERENCES Tournaments(id);

--================================================================================================================
--BIEN
ALTER PROCEDURE dbo.spMatchupEntries_Insert
	@MatchupId INT,
	@ParentMatchupId INT,
	@TeamCompetingId INT,
	@id INT = 0 OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO dbo.MatchupEntries(MatchupId, ParentMatchupId, TeamCompetingId)
	VALUES (@MatchupId, @ParentMatchupId, @TeamCompetingId);

	SELECT @id = SCOPE_IDENTITY();
END
GO

--================================================================================================================

CREATE PROCEDURE dbo.spTournaments_GetAll
AS
BEGIN
    SELECT * FROM Tournaments
	WHERE Active=1;
END
GO


--================================================================================================================


CREATE PROCEDURE [dbo].[spMatchups_GetByTournament]
	@TournamentId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT m.*
	FROM dbo.Matchups m	
	WHERE m.TournamentId = @TournamentId
	ORDER BY  MatchupRound;
END
GO

--================================================================================================================

CREATE PROCEDURE [dbo].[spMatchupsEntries_GetByMatchup]
	@MatchupId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT *
	FROM MatchupEntries
	WHERE MatchupId = @MatchupId
END
GO

--================================================================================================================
--[spMatchups_GetByTournament]
CREATE PROCEDURE [dbo].[spTeam_GetByTournament]
	@TournamentId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT tm.*
	FROM dbo.Teams tm
	WHERE tm.id IN (SELECT TeamId FROM TournamentEntries WHERE TournamentId = @TournamentId)
END
GO



--CREATE PROCEDURE [dbo].[spMatchups_GetByTournament]
--	@TournamentId INT
--AS
--BEGIN
--	-- SET NOCOUNT ON added to prevent extra result sets from
--	-- interfering with SELECT statements.
--	SET NOCOUNT ON;
--	SELECT m.*
--	FROM dbo.Matchups m	
--	WHERE m.TournamentId = @TournamentId
--	ORDER BY  MatchupRound;
--END
--GO
--================================================================================================================

CREATE PROCEDURE dbo.spMatchups_Update
	@id int,
	@WinnerId int
AS
BEGIN
    SET NOCOUNT ON;
	
	UPDATE dbo.Matchups SET WinnerId = @WinnerId
	WHERE id = @id;
END
GO

--================================================================================================================


CREATE PROCEDURE dbo.spMatchupsEntries_Update
	@id int,
	@TeamCompetingId int = null,
	@Score float = null
AS
BEGIN
    SET NOCOUNT ON;
	
	UPDATE dbo.MatchupEntries 
	SET TeamCompetingId = @TeamCompetingId, Score = @Score
	WHERE id = @id;
END
GO

--================================================================================================================

CREATE PROCEDURE dbo.spTournaments_Complete
	@id INT
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE dbo.Tournaments
	SET Active = 0
	WHERE id = @id;	
END
GO

--================================================================================================================
--================================================================================================================
--================================================================================================================

CREATE TABLE Tournaments(
	id INT IDENTITY(1,1) PRIMARY KEY,
	TournamentName VARCHAR(50) NOT NULL,
	EntryFee DECIMAL
);

CREATE TABLE Teams(
	id INT IDENTITY(1,1) PRIMARY KEY,
	TeamName VARCHAR(50)
);

CREATE TABLE TournamentEntries(
	id INT IDENTITY(1,1) PRIMARY KEY,
	TournamentId INT,
	TeamId INT,
	FOREIGN KEY(TournamentId) REFERENCES Tournaments(id) ON DELETE SET NULL,
	FOREIGN KEY(TeamId) REFERENCES Teams(id) ON DELETE SET NULL
);

CREATE TABLE Prizes(
	id INT IDENTITY(1,1) PRIMARY KEY,
	PlaceNumber INT,
	PlaceName VARCHAR(50),
	PrizeAmount MONEY DEFAULT 0.00,
	PrizePercentage FLOAT,	
);

CREATE TABLE TournamentPrizes(
	id INT IDENTITY(1,1) PRIMARY KEY,
	TournamentId INT,
	PrizeId INT,
	FOREIGN KEY(TournamentId) REFERENCES Tournaments(id) ON DELETE SET NULL,
	FOREIGN KEY(PrizeId) REFERENCES Prizes(id) ON DELETE SET NULL
);

CREATE TABLE People(
	id INT IDENTITY(1,1) PRIMARY KEY,
	FirstName VARCHAR(100) NOT NULL,
	LastName VARCHAR(100) NOT NULL,
	EmailAddress VARCHAR(100) NOT NULL,
	CellphoneNumber VARCHAR(20),
);

CREATE TABLE TeamMembers(
	id INT IDENTITY(1,1) PRIMARY KEY,
	TeamId INT,
	PersonId INT,
	FOREIGN KEY(TeamId) REFERENCES Teams(id) ON DELETE SET NULL,
	FOREIGN KEY(PersonId) REFERENCES People(id) ON DELETE SET NULL
);

CREATE TABLE Matchups (
    id INT IDENTITY(1,1) PRIMARY KEY,
    WinnerId INT,
    MatchupRound INT,
    FOREIGN KEY (WinnerId) REFERENCES Teams(id) ON DELETE SET NULL
);

CREATE TABLE MatchupEntries (
    id INT IDENTITY(1,1) PRIMARY KEY,
    MatchupId INT,
    ParentMatchupId INT,
    TeamCompetingId INT,
    Score FLOAT,
    FOREIGN KEY (MatchupId) REFERENCES Matchups(id) ON DELETE NO ACTION,
    FOREIGN KEY (ParentMatchupId) REFERENCES MatchupEntries(id) ON DELETE NO ACTION,
    FOREIGN KEY (TeamCompetingId) REFERENCES Teams(id) ON DELETE SET NULL
);

SELECT TOP 5 * FROM Prizes;
USE Tournaments;

SELECT * FROM dbo.People;
SELECT * FROM dbo.Tournaments;

SELECT * FROM dbo.Teams;
SELECT TOP 5 * FROM dbo.TeamMembers;

SELECT tm.PersonId, p.FirstName, t.TeamName
FROM People p
JOIN TeamMembers tm ON p.id = tm.PersonId
JOIN Teams t ON t.id = tm.TeamId

SELECT * FROM dbo.Matchups;

SELECT * FROM dbo.MatchupEntries;

UPDATE MatchupEntries SET TeamCompetingId = 6 WHERE TeamCompetingId = 3;