class NbaAdvancedStats::Season 

    attr_accessor :year, :games, :records

    @@all = []

    # Hooks
    def initialize(year:)
        @year = year
        @games=[]
        @records=[]
        self.save
    end
    
    # Class Getter
    def self.all
        @@all
    end

    # Class methods
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

    # Instance Methods
    def add_game(game)
        self.games << game
        self.record_game(game)
    end

    def record_game(game)
        results = game.results_hash
        self.find_or_create_record_by_team(results[:winner]).add_win(game)
        self.find_or_create_record_by_team(results[:loser]).add_loss(game)
    end

    def add_record(record)
        self.records << record
    end

    def find_record_by_team(team)
        self.records.find {|record| record.team == team}
    end

    def find_or_create_record_by_team(team)
        if record = self.find_record_by_team(team)
            record
        else
            NbaAdvancedStats::Record.create_new_record(season:self,team:team)
        end
    end

    def teams
        self.records.map {|record| record.team}
    end

    def save
        @@all << self
    end


end