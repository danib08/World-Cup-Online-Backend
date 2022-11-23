---- TOURNAMENT Procedures ----

create procedure getTournaments
as begin
		select t.ID, t.name, StartDate, EndDate, Description, Type.Name as Type
		from Tournament as t join Type on TypeID = Type.ID
end
go

create procedure getOneTournament(@ID int)
as begin
		select t.ID, t.name, StartDate, EndDate, Description, Type.Name as Type
		from Tournament as t join Type on TypeID = Type.ID
		where t.ID = @ID
end
go

create procedure insertTournament(@Name varchar(30),
				@StartDate datetime,
				@EndDate datetime,
				@Description varchar(1000),
				@TypeID int)
as begin
		insert into dbo.Tournament(Name,StartDate,EndDate,Description,TypeID)
		values(@Name,@StartDate,@EndDate,@Description,@TypeID)
		select SCOPE_IDENTITY() as ID
end
go

create procedure editTournament(@ID int,
				@Name varchar(30),
				@StartDate datetime,
				@EndDate datetime,
				@Description varchar(1000),
				@TypeID int)
as begin
		update dbo.Tournament set Name=@Name,StartDate=@StartDate,EndDate=@EndDate,Description=@Description,TypeID=@TypeID
		where ID=@ID 	
end
go

create procedure deleteTournament(@ID int)
as begin
		delete from dbo.Tournament
		where ID = @ID
end
go

create procedure getMatchesByTournament(@ID int)
as begin
		select dbo.Match.ID, dbo.Team.Name, StartDate, StartTime, Location, dbo.State.Name as State, Score
		from ((dbo.Match join dbo.State on StateID = dbo.State.ID) join dbo.Team_In_Match on MatchID = dbo.Match.ID) join dbo.Team on TeamID = dbo.Team.ID
		where TournamentID = @ID
		order by dbo.Match.ID  
end
go

create procedure getPhasesByTournament(@ID int)
as begin
		select ID as value, Name as label
		from Phase
		where TournamentID = @ID
end
go

create procedure getTeamsByTournament(@ID int)
as begin
		select ID, Name, Confederation
		from (Team_In_Tournament join Team on TeamID = ID)
		where TournamentID = @ID
end
go

---- TEAMS Procedures ----

create procedure getTeams
as begin
		select ID, Name as label
		from dbo.Team
end
go

create procedure getOneTeam(@ID varchar(8))
as begin
		select * from dbo.Team
		where ID = @ID
end
go

create procedure getTeamsByType(@TypeID int)
as begin
		select ID, Name as label from dbo.Team
		where TypeID = @TypeID
end
go

create procedure insertTeam(@ID varchar(8),
			   	@Name varchar(30),
				@Confederation varchar(30),
				@TypeID int)
as begin
		insert into dbo.Team(ID,Name,Confederation,TypeID)
		values(@ID,@Name,@Confederation,@TypeID)
end
go

create procedure editTeam(@ID varchar(8),
			   	@Name varchar(30),
				@Confederation varchar(30),
				@TypeID int)
as begin
		update dbo.Team set Name=@Name,Confederation=@Confederation,TypeID=@TypeID
		where ID=@ID 	
end
go

create procedure deleteTeam(@ID varchar(8))
as begin
		delete from dbo.Team
		where ID = @ID
end
go

create procedure getPlayersByTeam(@ID varchar(8))
as begin
		select Player.ID as id, Player.Name + ' ' + Lastname as label
		from Player join (Team join Player_In_Team on ID = TeamID) on Player.ID = PlayerID
		where Team.ID = @ID
end
go

---- TEAM_IN_TOURNAMENT Procedures ---

create procedure getTIT
as begin
		select * from dbo.Team_In_Tournament
end
go

create procedure getOneTIT(@TeamID varchar(8),
				@TournamentID int)
as begin
		select * from dbo.Team_In_Tournament
		where TeamID = @TeamID and TournamentID = @TournamentID
end
go

create procedure insertTIT(@TeamID varchar(8),
				@TournamentID int)
as begin
		insert into dbo.Team_In_Tournament(TeamID,TournamentID)
		values(@TeamID,@TournamentID)
end
go

create procedure deleteTIT(@TeamID varchar(8),
				@TournamentID int)
as begin
		delete from dbo.Team_In_Tournament
		where TeamID = @TeamID and TournamentID = @TournamentID
end
go

---- PLAYERS Procedures ----

create procedure getPlayers
as begin
		select * from dbo.Player
end
go

create procedure getOnePlayer(@ID varchar(15))
as begin
		select * from dbo.Player
		where ID = @ID
end
go

create procedure insertPlayer(@ID varchar(15),
				@Name varchar(30),
				@Lastname varchar(30),
				@Position varchar(30))
as begin
		insert into dbo.Player(ID,Name,Lastname,Position)
		values(@ID,@Name,@Lastname,@Position)
end
go

create procedure editPlayer(@ID varchar(15),
				@Name varchar(30),
				@Lastname varchar(30),
				@Position varchar(30))
as begin
		update dbo.Player set Name=@Name,Lastname=@Lastname,Position=@Position
		where ID=@ID	
end
go

create procedure deletePlayer(@ID varchar(15))
as begin
		delete from dbo.Player
		where ID = @ID
end
go

---- PLAYER_IN_TEAM Procedures ----

create procedure getPIT
as begin
		select * from dbo.Player_In_Team
end
go

create procedure getOnePIT(@TeamID varchar(6),
				@PlayerID varchar(15))
as begin
		select * from dbo.Player_In_Team
		where TeamID = @TeamID and PlayerID= @PlayerID
end
go

create procedure insertPIT(@TeamID varchar(6),
				@PlayerID varchar(15),
				@JerseyNum int)
as begin
		insert into dbo.Player_In_Team(TeamID,PlayerID,JerseyNum)
		values(@TeamID,@PlayerID,@JerseyNum)
end
go

create procedure editPIT(@TeamID varchar(6),
				@PlayerID varchar(15),
				@JerseyNum int)
as begin
		update dbo.Player_In_Team set JerseyNum=@JerseyNum
		where TeamID = @TeamID and PlayerID= @PlayerID	
end
go

create procedure deletePIT(@TeamID varchar(6),
				@PlayerID varchar(15))
as begin
		delete from dbo.Player_In_Team 
		where TeamID = @TeamID and PlayerID= @PlayerID
end
go

---- PHASE procedures ----

create procedure getPhase
as begin
		select * from dbo.Phase
end
go

create procedure getOnePhase(@ID int)
as begin
		select * from dbo.Phase
		where ID = @ID
end
go

create procedure insertPhase(@Name varchar(50),
				@TournamentID int)
as begin
		insert into dbo.Phase(Name,TournamentID)
		values(@Name,@TournamentID)
end
go

create procedure editPhase(@ID int,
				@Name varchar(50),
				@TournamentID int)
as begin
		update dbo.Phase set Name=@Name, TournamentID=@TournamentID
		where ID = @ID	
end
go

create procedure deletePhase(@ID int)
as begin
		delete from dbo.Phase 
		where ID = @ID
end
go

---- MATCH procedures ----

create procedure getMatches
as begin
		select * from dbo.Match
end
go

create procedure getOneMatch(@ID int)
as begin
		select * from dbo.Match
		where ID = @ID
end
go

create procedure insertMatch(@StartDate datetime,
			    @StartTime time,
			    @Score varchar(7),
			    @Location varchar(50),
			    @StateID int,
			    @TournamentID int,
				@PhaseID int)
as begin
		insert into dbo.Match(StartDate,StartTime,Score,Location,StateID,TournamentID,PhaseID)
		values(@StartDate,@StartTime,@Score,@Location,@StateID,@TournamentID,@PhaseID)
		select SCOPE_IDENTITY() as ID
end
go

create procedure editMatch(@ID int,
			    @StartDate datetime,
			    @StartTime time,
			    @Score varchar(7),
			    @Location varchar(50),
			    @StateID int,
			    @TournamentID int,
				@PhaseID int)
as begin
		update dbo.Match set StartDate=@StartDate,StartTime=@StartTime,Location=@Location,StateID=@StateID,TournamentID=@TournamentID,PhaseID=@PhaseID
		where ID=@ID	
end
go

create procedure deleteMatch(@ID int)
as begin
		delete from dbo.Match 
		where ID = @ID
end
go

---- STATE Procedures ----

create procedure getStates
as begin
		select * from dbo.State
end
go

create procedure getOneState(@ID int)
as begin
		select * from dbo.State
		where ID = @ID
end
go

create procedure insertState(@ID int,
				@Name varchar(30))
as begin
		insert into dbo.State(Name)
		values(@Name)
end
go

create procedure editState(@ID int,
				@Name varchar(30))
as begin
		update dbo.State set Name=@Name
		where ID=@ID	
end
go

create procedure deleteState(@ID int)
as begin
		delete from dbo.State 
		where ID = @ID
end
go

---- TEAM_IN_MATCH Procedures ----

create procedure getTIM
as begin
		select * from dbo.Team_In_Match
end
go

create procedure getOneTIM(@TeamID varchar(8),
				@MatchID int)
as begin
		select * from dbo.Team_In_Match
		where TeamID = @TeamID and MatchID = @MatchID
end
go

create procedure insertTIM(@TeamID varchar(8),
				@MatchID int)
as begin
		insert into dbo.Team_In_Match(TeamID,MatchID)
		values(@TeamID,@MatchID)
end
go

create procedure deleteTIM(@TeamID varchar(8),
				@MatchID int)
as begin
		delete from dbo.Team_In_Match
		where TeamID = @TeamID and MatchID = @MatchID	
end
go


---- TYPE Procedures ----

create procedure getTypes
as begin
		select ID as value, Name as label
		from dbo.Type
end
go

create procedure getOneType(@ID int)
as begin
		select * from dbo.Type
		where ID = @ID
end
go

create procedure insertType(@ID int,
				@Name varchar(30))
as begin
		insert into dbo.Type(Name)
		values(@Name)
end
go

create procedure editType(@ID int,
				@Name varchar(30))
as begin
		update dbo.Type set Name=@Name
		where ID=@ID	
end
go

create procedure deleteType(@ID int)
as begin
		delete from dbo.Type 
		where ID = @ID
end
go


---  COUNTRY Procedures ---

create procedure getCountries
as begin
		select ID as value, Name as label
		from dbo.Country
end
go

create procedure getOneCountry(@ID varchar(3))
as begin
		select * from dbo.Country
		where ID = @ID
end
go

create procedure insertCountry(@ID varchar(3),
				@Name varchar(31))
as begin
		insert into dbo.Country(ID, Name)
		values(@ID, @Name)
end
go

create procedure editCountry(@ID varchar(3),
				@Name varchar(31))
as begin
		update dbo.Country set Name=@Name
		where ID=@ID 
end
go

create procedure deleteCountry(@ID varchar(3))
as begin
		delete from dbo.Country
		where ID = @ID
end
go


--- USERS Procedures ---

create procedure getUsers
as begin
		select * from dbo.Users
end
go

create procedure getOneUser(@Username varchar(12))
as begin
		select * from dbo.Users
		where @Username = @Username
end
go

create procedure insertUser(@Username varchar(12),
				@Name varchar(30),
				@Lastname varchar(30),
				@Email varchar(45),
				@CountryID varchar(3),
				@Birthdate datetime,
				@Password varchar(MAX))
as begin
		insert into dbo.Users(Username, Name, Lastname, Email, CountryID, Birthdate, Password)
		values(@Username, @Name, @Lastname, @Email, @CountryID, @Birthdate, @Password)
end
go

create procedure editUser(@Username varchar(12),
				@Name varchar(30),
				@Lastname varchar(30),
				@Email varchar(45),
				@CountryID varchar(3),
				@Birthdate datetime,
				@Password varchar(MAX))
as begin
		update dbo.Users set Name=@Name, Lastname=@Lastname, Email=@Email, CountryID=@CountryID, Birthdate=@Birthdate, Password=@Password
		where Username = @Username 
end
go

create procedure deleteUser(@Username varchar(12))
as begin
		delete from dbo.Users
		where @Username = @Username
end
go

create procedure authUser(@Email varchar(45))
as begin
		select Username, Password from dbo.Users
		where Email = @Email
end
go

--- BET Procedures ---

create procedure getBets
as begin
		select * from dbo.Bet
end
go

create procedure getOneBet(@ID int)
as begin
		select * from dbo.Bet
		where @ID = @ID
end
go

create procedure insertBet(@GoalsTeam1 int,
				@GoalsTeam2 int,
				@MVP varchar(15),
				@UserID varchar(12),
				@MatchID int)
as begin
		insert into dbo.Bet(GoalsTeam1, GoalsTeam2, Score, MVP, UserID, MatchID)
		values(@GoalsTeam1, @GoalsTeam2, 0, @MVP, @UserID, @MatchID)
		select SCOPE_IDENTITY() as ID
end
go

create procedure editBet(@ID int,
				@GoalsTeam1 int,
				@GoalsTeam2 int,
				@Score int,
				@MVP varchar(15),
				@UserID varchar(12),
				@MatchID int)
as begin
		update dbo.Bet set GoalsTeam1=@GoalsTeam1, GoalsTeam2=@GoalsTeam2, Score=@Score, MVP=@MVP, UserID=@UserID, MatchID=@MatchID
		where ID = @ID 	
end
go

create procedure deleteBet(@ID int)
as begin
		delete from dbo.Bet
		where ID = @ID
end
go


--- ASSIST_IN_BET Procedures ---

create procedure getAIB
as begin
		select * from dbo.Assist_In_Bet
end
go

create procedure getOneAIB(@ID int)
as begin
		select * from dbo.Assist_In_Bet
		where @ID = @ID
end
go

create procedure insertAIB(@BetID int,
				@PlayerID varchar(15))
as begin
		insert into dbo.Assist_In_Bet(BetID, PlayerID)
		values(@BetID, @PlayerID)
end
go

create procedure editAIB(@ID int,
				@BetID int,
				@PlayerID varchar(15))
as begin
		update dbo.Assist_In_Bet set BetID=@BetID, PlayerID=@PlayerID
		where ID = @ID 	
end
go

create procedure deleteAIB(@ID int)
as begin
		delete from dbo.Assist_In_Bet
		where ID = @ID
end
go

--- SCORER_IN_BET Procedures ---

create procedure getSIB
as begin
		select * from dbo.Scorer_In_Bet
end
go

create procedure getOneSIB(@ID int)
as begin
		select * from dbo.Scorer_In_Bet
		where @ID = @ID
end
go

create procedure insertSIB(@BetID int,
				@PlayerID varchar(15))
as begin
		insert into dbo.Scorer_In_Bet(BetID, PlayerID)
		values(@BetID, @PlayerID)
end
go

create procedure editSIB(@ID int,
				@BetID int,
				@PlayerID varchar(15))
as begin
		update dbo.Scorer_In_Bet set BetID=@BetID, PlayerID=@PlayerID
		where ID = @ID 	
end
go

create procedure deleteSIB(@ID int)
as begin
		delete from dbo.Scorer_In_Bet
		where ID = @ID
end
go