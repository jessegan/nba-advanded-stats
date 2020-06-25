class NbaAdvancedStats::Season 

    attr_accessor :year, :games, :records

    @@all = []

    # CONSTRUCTORS

    def initialize(year:)
        @year = year
        @games=[]
        @records=[]
        self.save
    end

    def self.create(year:)
        season = self.new(year:year)
        season.save
        season
    end
    
    def save
        @@all << self
    end

    # CLASS METHODS

    ## Class Getter

    def self.all
        @@all
    end

    ## Find methods
    def self.find_with_year(year)
        self.all.find{|season| season.year == year}
    end

    def self.find_or_create_with_api(year)
        if season = self.find_with_year(year)
            season
        else 
            NbaAdvancedStats::API.create_season(year)
        end
    end

    # INSTANCE METHODS

    ## Adding object relationships

    # Adding a game to the season and updating the coresponding team records
    def add_game(game)
        self.games << game
        self.record_game(game)
    end

    # Update team records with game results
    def record_game(game)
        results = game.results_hash
        self.find_or_create_record_by_team(results[:winner]).add_win(game)
        self.find_or_create_record_by_team(results[:loser]).add_loss(game)
    end

    # Add a record to a season
    def add_record(record)
        self.records << record
    end

    ## Find methods

    def find_a_team(name)
        self.teams.find do |team|
            team.name.downcase.match(/\b#{name.downcase}\b/)
        end
    end

    def find_record_by_team(team)
        self.records.find {|record| record.team == team}
    end

    def find_or_create_record_by_team(team)
        if record = self.find_record_by_team(team)
            record
        else
            NbaAdvancedStats::Record.create(season:self,team:team)
        end
    end

    ## Instance getter
    def teams
        self.records.map {|record| record.team}
    end

    ## Instance stats methods

    def standings
        self.records.sort do |a,b| 
            if a.wins == b.wins
                hth = a.head_to_head(b.team)
                hth.wins <=> hth.losses
            else
                b.wins <=> a.wins
            end
        end
    end

    def get_standing(team)
        self.standings.find_index(self.find_record_by_team(team)) + 1
    end

    def home_court_records
        self.records.map {|record| record.home_court_record}
    end

    def home_court_records_standings
        self.home_court_records.sort {|a,b| b.wins<=>a.wins}
    end    

    def home_court_advantages
        self.records.map do|record|
            {team:record.team,stat:record.home_court_advantage}
        end
    end

    def home_court_advantages_standings
        self.home_court_advantages.sort {|a,b| b[:stat]<=>a[:stat]}
    end

    def point_differentials
        self.records.map do |record|
            {team:record.team,stat:record.average_point_differential}
        end
    end

    def point_differentials_standings
        self.point_differentials.sort {|a,b| b[:stat]<=>a[:stat]}
    end

    def get_head_to_head_record(team1,team2)
        self.find_record_by_team(team1).head_to_head(team2)
    end

end