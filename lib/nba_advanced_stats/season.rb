class NbaAdvancedStats::Season 

    attr_accessor :year, :games, :records

    @@all = []

    # Hooks
    def initialize(year:,games:[])
        @year = year
        @games=games
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
    def add_game(date:,home_team:,away_team:,home_score:,away_score:)
        game = NbaAdvancedStats::Game.new(
            date:date,
            season:self,
            home_team:home_team,
            away_team:away_team,
            home_score:home_score,
            away_score:away_score
        )
        @games << game
        self.record_game(game)
    end

    def record_game(game)
        result = game.results_hash
        self.find_or_create_record(result["winner"]).add_win
        self.find_or_create_record(result["loser"]).add_loss
    end

    def save
        @@all << self
    end


end