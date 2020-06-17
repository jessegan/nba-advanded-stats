class NbaAdvancedStats::Record 

    attr_accessor :wins,:losses,:games
    attr_reader :season, :team

    @@all = []

    #constructors
    def initialize(season:nil,team:nil,wins:0,losses:0)
        @season=season
        @team=team
        @wins=wins
        @losses=losses
        @games=[]
    end

    def self.create_new_record(season:,team:,wins:0,losses:0)
        record = NbaAdvancedStats::Record.new(wins:wins,losses:losses)
        record.season = season
        record.team = team
        record.save
        record
    end

    # instance setters
    def season=(season)
        @season = season
        season.add_record(self)
    end

    def team=(team)
        @team = team
        team.add_record(self)
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

    def win_percentage
        1.0 * self.wins/(self.wins + self.losses)
    end

    def home_court_record
        home_wins = 0
        home_losses = 0
        self.games.each do |game|
            if game.home_team == self.team
                game.home_score > game.away_score ? home_wins+=1 : home_losses+=1
            end
        end 
        NbaAdvancedStats::Record.new(season:self.season,team:self.team,wins:home_wins,losses:home_losses)
    end

    def home_win_percentage
        self.home_court_record.win_percentage
    end

    def home_court_advantage
        self.home_win_percentage - self.win_percentage
    end

    def save
        @@all << self
    end

end