----Nuevos procedimientos TOURNAMENT para arreglos del API----

create procedure get_tournaments
as begin
	select * from dbo.Tournament
end
go

create procedure getOneTournament(@ID int)
as begin
	select * from dbo.Tournament
		where ID = @ID
end
go

create procedure insertTournament(@ID int,
				@Name varchar(30),
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

create procedure delete_tournament(@ID int)
as begin
	delete from dbo.Tournament
	where ID = @ID
end
go

create procedure getMatchesTournament(@ID int)
as begin
		select dbo.Match.ID, dbo.Team.Name, StartDate, StartTime, Location, dbo.State.Name as State, Score
		from ((dbo.Match join dbo.State on StateID = dbo.State.ID) join dbo.Team_In_Match on MatchID = dbo.Match.ID) join dbo.Team on TeamID = dbo.Team.ID
		where TournamentID = @ID
		order by dbo.Match.ID 
end
go

create procedure getPhasesTournament(@ID int)
as begin
		select ID as value, Name as label
		from Phase
		where TournamentID = @ID
end
go

create procedure getTypesTournament
as begin
		select * from dbo.Type
end
go

create procedure getTeamsTournamentTournament(@ID int)
as begin
		select ID, Name, Confederation
		from (Team_In_Tournament join Team on TeamID = ID)
		where TournamentID = @ID
end
go

---------------------------------------------------------------------------------

create procedure proc_tournament(@ID int,
				@Name varchar(30),
				@StartDate datetime,
				@EndDate datetime,
				@Description varchar(1000),
				@TypeID int,
				@StatementType varchar(50) = '')
as begin

	if @StatementType = 'Insert'
	begin
		insert into dbo.Tournament(Name,StartDate,EndDate,Description,TypeID)
		values(@Name,@StartDate,@EndDate,@Description,@TypeID)
		select SCOPE_IDENTITY() as ID
	end

	if @StatementType = 'Select'
	begin
		select * from dbo.Tournament
	end

	if @StatementType = 'Select WebApp'
	begin
		select t.ID, t.name, StartDate, EndDate, Description, Type.Name as Type
		from Tournament as t join Type on TypeID = Type.ID
	end

	if @StatementType = 'Select One'
	begin
		select * from dbo.Tournament
		where ID = @ID
	end

	if @StatementType = 'Select One WebApp'
	begin
		select t.ID, t.name, StartDate, EndDate, Description, Type.Name as Type
		from Tournament as t join Type on TypeID = Type.ID
		where t.ID = @ID
	end

	if @StatementType = 'Update'
	begin
		update dbo.Tournament set Name=@Name,StartDate=@StartDate,EndDate=@EndDate,Description=@Description,TypeID=@TypeID
		where ID=@ID 	
	end

	if @StatementType = 'Delete'
	begin
		delete from dbo.Tournament
		where ID = @ID
	end

	if @StatementType = 'Get Matches by Tourn'
	begin	
		select dbo.Match.ID, dbo.Team.Name, StartDate, StartTime, Location, dbo.State.Name as State, Score
		from ((dbo.Match join dbo.State on StateID = dbo.State.ID) join dbo.Team_In_Match on MatchID = dbo.Match.ID) join dbo.Team on TeamID = dbo.Team.ID
		where TournamentID = @ID
		order by dbo.Match.ID 
	end

	if @StatementType = 'Get Phases by Tourn'
	begin	
		select ID as value, Name as label
		from Phase
		where TournamentID = @ID
	end

	if @StatementType = 'Get Teams by Tourn'
	begin	
		select ID, Name, Confederation
		from (Team_In_Tournament join Team on TeamID = ID)
		where TournamentID = @ID
	end

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

----Nuevos procedimientos Team_In_Tournament para arreglos del API----

create procedure get_TIT
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

create procedure delete_TIT(@TeamID varchar(8),
				@TournamentID int)
as begin
		delete from dbo.Team_In_Tournament
		where TeamID = @TeamID and TournamentID = @TournamentID
end
go

-------------------------------------------------------------------------

create procedure proc_teamInTournament(@TeamID varchar(8),
				@TournamentID int,
				@StatementType varchar(50) = '')
as begin

	if @StatementType = 'Insert'
	begin
		insert into dbo.Team_In_Tournament(TeamID,TournamentID)
		values(@TeamID,@TournamentID)
	end

	if @StatementType = 'Select'
	begin
		select * from dbo.Team_In_Tournament
	end

	if @StatementType = 'Select One'
	begin
		select * from dbo.Team_In_Tournament
		where TeamID = @TeamID and TournamentID = @TournamentID
	end

	if @StatementType = 'Delete'
	begin
		delete from dbo.Team_In_Tournament
		where TeamID = @TeamID and TournamentID = @TournamentID
	end
end
go



----Nuevos procedimientos PLAYERS para arreglos del API----

create procedure get_players
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

create procedure delete_player(@ID varchar(15))
as begin
	delete from dbo.Player
	where ID = @ID
end
go

---------------------------------------------------------------------------------


create procedure proc_player(@ID varchar(15),
				@Name varchar(30),
				@Lastname varchar(30),
				@Position varchar(30),
				@StatementType varchar(50) = '')
as begin

	if @StatementType = 'Insert'
	begin
		insert into dbo.Player(ID,Name,Lastname,Position)
		values(@ID,@Name,@Lastname,@Position)
	end

	if @StatementType = 'Select'
	begin
		select * from dbo.Player
	end

	if @StatementType = 'Select One'
	begin
		select * from dbo.Player
		where ID = @ID
	end

	if @StatementType = 'Update'
	begin
		update dbo.Player set Name=@Name,Lastname=@Lastname,Position=@Position
		where ID=@ID 	
	end

	if @StatementType = 'Delete'
	begin
		delete from dbo.Player
		where ID = @ID
	end
end
go


----Nuevos procedimientos Player_In_Team para arreglos del API----

create procedure get_PIT
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

create procedure delete_PIT(@TeamID varchar(6),
				@PlayerID varchar(15))
as begin
	delete from dbo.Player_In_Team 
	where TeamID = @TeamID and PlayerID= @PlayerID
end
go

-------------------------------------------------------------------------

create procedure proc_player_In_Team(@TeamID varchar(6),
				@PlayerID varchar(15),
				@JerseyNum int,
				@StatementType varchar(50) = '')
as begin

	if @StatementType = 'Insert'
	begin
		insert into dbo.Player_In_Team(TeamID,PlayerID,JerseyNum)
		values(@TeamID,@PlayerID,@JerseyNum)
	end

	if @StatementType = 'Select'
	begin
		select * from dbo.Player_In_Team
	end

	if @StatementType = 'Select One'
	begin
		select * from dbo.Player_In_Team
		where TeamID = @TeamID and PlayerID= @PlayerID
	end


	if @StatementType = 'Update'
	begin
		update dbo.Player_In_Team set JerseyNum=@JerseyNum
		where TeamID = @TeamID and PlayerID= @PlayerID	
	end

	if @StatementType = 'Delete'
	begin
		delete from dbo.Player_In_Team 
		where TeamID = @TeamID and PlayerID= @PlayerID
	end
end
go

----Nuevos procedimientos PHASE para arreglos del API----

create procedure get_phase
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



create procedure insertPhase(@ID int,
				@Name varchar(50),
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
insert into dbo.Phase(Name,TournamentID)
		values(@Name,@TournamentID)	
end
go

create procedure delete_phase(@ID int)
as begin
delete from dbo.Phase 
		where ID = @ID
end
go

-------------------------------------------------------------------------

create procedure proc_phase(@ID int,
				@Name varchar(50),
				@TournamentID int,
				@StatementType varchar(50) = '')
as begin

	if @StatementType = 'Insert'
	begin
		insert into dbo.Phase(Name,TournamentID)
		values(@Name,@TournamentID)
	end

	if @StatementType = 'Select'
	begin
		select ID as value, Name as label from dbo.Phase
	end

	if @StatementType = 'Select One'
	begin
		select * from dbo.Phase
		where ID = @ID
	end


	if @StatementType = 'Update'
	begin
		update dbo.Phase set Name=@Name, TournamentID=@TournamentID
		where ID = @ID	
	end

	if @StatementType = 'Delete'
	begin
		delete from dbo.Phase 
		where ID = @ID
	end
end
go

--------------------------------------------------------------

----Nuevos procedimientos MATCH para arreglos del API----

create procedure get_matches
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



create procedure insertMatch(@ID int,
			    @StartDate datetime,
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

create procedure delete_match(@ID int)
as begin
		delete from dbo.Match 
		where ID = @ID
end
go

-------------------------------------------------------------------------

create procedure proc_match(@ID int,
			    @StartDate datetime,
			    @StartTime time,
			    @Score varchar(7),
			    @Location varchar(50),
			    @StateID int,
			    @TournamentID int,
				@PhaseID int,
			    @StatementType varchar(50) = '')
as begin

	if @StatementType = 'Insert'
	begin
		insert into dbo.Match(StartDate,StartTime,Score,Location,StateID,TournamentID,PhaseID)
		values(@StartDate,@StartTime,@Score,@Location,@StateID,@TournamentID,@PhaseID)
		select SCOPE_IDENTITY() as ID
	end

	if @StatementType = 'Select'
	begin
		select * from dbo.Match
	end

	if @StatementType = 'Select One'
	begin
		select * from dbo.Match
		where ID = @ID
	end

	if @StatementType = 'Update'
	begin
		update dbo.Match set StartDate=@StartDate,StartTime=@StartTime,Location=@Location,StateID=@StateID,TournamentID=@TournamentID,PhaseID=@PhaseID
		where ID=@ID 	
	end

	if @StatementType = 'Delete'
	begin
		delete from dbo.Match 
		where ID = @ID
	end
end
go

----Nuevos procedimientos STATE para arreglos del API----

create procedure get_state
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

create procedure delete_state(@ID int)
as begin
		delete from dbo.State 
		where ID = @ID
end
go

-------------------------------------------------------------------------


create procedure proc_state(@ID int,
				@Name varchar(30),
			    @StatementType varchar(50) = '')
as begin

	if @StatementType = 'Insert'
	begin
		insert into dbo.State(Name)
		values(@Name)
	end

	if @StatementType = 'Select'
	begin
		select * from dbo.State
	end

	if @StatementType = 'Select One'
	begin
		select * from dbo.State
		where ID = @ID
	end

	if @StatementType = 'Update'
	begin
		update dbo.State set Name=@Name
		where ID=@ID 	
	end

	if @StatementType = 'Delete'
	begin
		delete from dbo.State
		where ID = @ID
	end
end
go

----Nuevos procedimientos Team_In_Match para arreglos del API----

create procedure get_TIM
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

create procedure delete_TIM(@TeamID varchar(8),
				@MatchID int)
as begin
		delete from dbo.Team_In_Match
		where TeamID = @TeamID and MatchID = @MatchID	
end
go

-------------------------------------------------------------------------


create procedure proc_teamInMatch(@TeamID varchar(8),
				@MatchID int,
			    @StatementType varchar(50) = '')
as begin

	if @StatementType = 'Insert'
	begin
		insert into dbo.Team_In_Match(TeamID,MatchID)
		values(@TeamID,@MatchID)
	end

	if @StatementType = 'Select'
	begin
		select * from dbo.Team_In_Match
	end

	if @StatementType = 'Select One'
	begin
		select * from dbo.Team_In_Match
		where TeamID = @TeamID and MatchID = @MatchID
	end

	if @StatementType = 'Delete'
	begin
		delete from dbo.Team_In_Match
		where TeamID = @TeamID and MatchID = @MatchID
	end
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

--------------------New procedures for USERS ----------------------------------

create procedure get_users
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

create procedure delete_user(@Username varchar(12))
as begin
		delete from dbo.Users
		where @Username = @Username
end
go


create procedure proc_users(@Username varchar(12),
				@Name varchar(30),
				@Lastname varchar(30),
				@Email varchar(45),
				@CountryID varchar(3),
				@Birthdate datetime,
				@Password varchar(MAX),
			    @StatementType varchar(50) = '')
as begin

	if @StatementType = 'Insert'
	begin
		insert into dbo.Users(Username, Name, Lastname, Email, CountryID, Birthdate, Password)
		values(@Username, @Name, @Lastname, @Email, @CountryID, @Birthdate, @Password)
	end

	if @StatementType = 'Select'
	begin
		select * from dbo.Users
	end


	if @StatementType = 'Select One'
	begin
		select * from dbo.Users
		where Username = @Username
	end

	if @StatementType = 'Update'
	begin
		update dbo.Users set Name=@Name, Lastname=@Lastname, Email=@Email, CountryID=@CountryID, Birthdate=@Birthdate, Password=@Password
		where Username = @Username 	
	end

	if @StatementType = 'Delete'
	begin
		delete from dbo.Users
		where Username = @Username
	end

	if @StatementType = 'Auth'
	begin
		select Username, Password from dbo.Users
		where Email = @Email
	end
end
go

create procedure proc_bet(@ID int,
				@GoalsTeam1 int,
				@GoalsTeam2 int,
				@Score int ,
				@MVP varchar(15),
				@UserID varchar(12),
				@MatchID int,
			    @StatementType varchar(50) = '')
as begin

	if @StatementType = 'Insert'
	begin
		insert into dbo.Bet(GoalsTeam1, GoalsTeam2, Score, MVP, UserID, MatchID)
		values(@GoalsTeam1, @GoalsTeam2, @Score, @MVP, @UserID, @MatchID)
	end

	if @StatementType = 'Select'
	begin
		select * from dbo.Bet
	end


	if @StatementType = 'Select One'
	begin
		select * from dbo.Bet
		where ID = @ID
	end

	if @StatementType = 'Update'
	begin
		update dbo.Bet set GoalsTeam1=@GoalsTeam1, GoalsTeam2=@GoalsTeam2, Score=@Score, MVP=@MVP, UserID=@UserID, MatchID=@MatchID
		where ID = @ID 	
	end

	if @StatementType = 'Delete'
	begin
		delete from dbo.Bet
		where ID = @ID
	end
end
go


create procedure proc_scorerInBet(@ID int,
				@BetID int,
				@PlayerID varchar(15),
			    @StatementType varchar(50) = '')
as begin

	if @StatementType = 'Insert'
	begin
		insert into dbo.Scorer_In_Bet(ID,BetID,PlayerID)
		values(@ID, @BetID,@PlayerID)
	end

	if @StatementType = 'Select'
	begin
		select * from dbo.Scorer_In_Bet
	end

	if @StatementType = 'Select One'
	begin
		select * from dbo.Scorer_In_Bet
		where BetID = @BetID and PlayerID = @PlayerID
	end

	if @StatementType = 'Delete'
	begin
		delete from dbo.Scorer_In_Bet
		where BetID = @BetID and PlayerID = @PlayerID
	end
end
go

create procedure proc_assistInBet(@ID int,
				@BetID int,
				@PlayerID varchar(15),
			    @StatementType varchar(50) = '')
as begin

	if @StatementType = 'Insert'
	begin
		insert into dbo.Assist_In_Bet(ID,BetID,PlayerID)
		values(@ID, @BetID,@PlayerID)
	end

	if @StatementType = 'Select'
	begin
		select * from dbo.Assist_In_Bet
	end

	if @StatementType = 'Select One'
	begin
		select * from dbo.Assist_In_Bet
		where BetID = @BetID and PlayerID = @PlayerID
	end

	if @StatementType = 'Delete'
	begin
		delete from dbo.Assist_In_Bet
		where BetID = @BetID and PlayerID = @PlayerID
	end
end
go


--------------------New procedures for COUNTRY ----------------------------------

create procedure get_countries
as begin
		select * from dbo.Country
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

create procedure delete_country(@ID varchar(3))
as begin
		delete from dbo.Country
		where ID = @ID
end
go


create procedure proc_country(@ID varchar(3),
				@Name varchar(31),
			    @StatementType varchar(50) = '')
as begin

	if @StatementType = 'Insert'
	begin
		insert into dbo.Country(ID, Name)
		values(@ID, @Name)
	end

	if @StatementType = 'Select'
	begin
		select * from dbo.Country
	end

	if @StatementType = 'Select WebApp'
	begin
		select ID as value, Name as label
		from dbo.Country
	end

	if @StatementType = 'Select One'
	begin
		select * from dbo.Country
		where ID = @ID
	end

	if @StatementType = 'Update'
	begin
		update dbo.Country set Name=@Name
		where ID=@ID 	
	end

	if @StatementType = 'Delete'
	begin
		delete from dbo.Country
		where ID = @ID
	end
end
go
