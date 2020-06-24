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

    def self.create(season:,team:,wins:0,losses:0)
        record = NbaAdvancedStats::Record.new(season:season,team:team,wins:wins,losses:losses)
        record.save
        record
    end

    def save
        self.season.add_record(self)
        self.team.add_record(self)
        @@all << self
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

    def head_to_head(opponent)
        hth_record = NbaAdvancedStats::Record.new(season:self.season,team:self.team)

        # get list of games
        self.games.each do |game|
            # look for games with opponent as home or away team
            if game.home_team == opponent || game.away_team == opponent
                # check who wins against record.team
                if game.winner == self.team
                    hth_record.add_win(game)
                else 
                    hth_record.add_loss(game)
                end
            end
        end

        hth_record
    end

    def average_point_differential
        # go through each game
        total_dif = self.games.inject(0) do |dif,game|
            # find out if team is home or away
            if game.home_team == self.team
                dif + game.point_differential
            else
                dif - game.point_differential
            end
        end
         # divide by # games then return
        1.0 * total_dif / (self.wins + self.losses)
    end


    def to_str
        "#{self.wins.to_s.rjust(2)} - #{self.losses.to_s.ljust(2)}"
    end

end