class NbaAdvancedStats::Record 

    attr_accessor :wins,:losses,:games
    attr_reader :season, :team

    @@all = []

    #constructors
    def initialize()
        @wins=0
        @losses=0
        @games=[]
    end

    def self.create_record(season:,team:)
        record = NbaAdvancedStats::Record.new
        record.season = season
        record.team = team
        record.save
        record
    end

    def self.create_temp(season:,team:)
        record = NbaAdvancedStats::Record.new
        record.season = season,true
        record.team = team,true
        record
    end

    # instance setters
    def season=(season,temp=false)
        @season = season
        season.add_record(self) if !temp
    end

    def team=(team,temp=false)
        @team = team
        team.add_record(self) if !temp
    end
    
    # class getter
    def self.all
        @@all
    end

    # instance methods
    def add_win(game)
        self.wins += 1
        self.games << game
    end

    def add_loss(game)
        self.losses += 1
        self.games << game
    end

    def win_percentage()
        1.0 * self.wins/(self.wins + self.losses)
    end

    def home_court_percentage()
        home_wins = 0
        home_games = 0
        self.games.each do |game|
            if game.home_team == self.team
                home_games += 1
                home_wins+=1 if game.home_score > game.away_score
            end
        end 
        1.0 * home_wins/ home_games
    end



    def save
        @@all << self
    end

end