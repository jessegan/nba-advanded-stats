class NbaAdvancedStats::Game 

    attr_accessor :home_score,:away_score
    attr_reader :date,:season,:home_team,:away_team

    @@all = []

    # Constructors
    def initialize(date:,season:,home_team:,away_team:,home_score:,away_score:)
        @date=date
        @home_score=home_score
        @away_score=away_score
        @home_team=home_team
        @away_team=away_team
        @season = season
    end

    def self.create(date:,season:,home_team:,away_team:,home_score:,away_score:)
        game = self.new(date:date,season:season,home_team:home_team,away_team:away_team,home_score:home_score,away_score:away_score)
        game.save
    end

    def save
        self.home_team.add_game(self)
        self.away_team.add_game(self)
        self.season.add_game(self)
        @@all << self
    end

    # Instance setters
    def home_team=(team)
        @home_team = team
        team.add_game(self)
    end

    def away_team=(team)
        @away_team=team
        team.add_game(self)
    end

    def season=(season)
        @season = season
        season.add_game(self)
    end

    # Class getter
    def self.all
        @@all
    end

    # instance methods
    def results_hash
        if self.home_score > self.away_score
            {winner: self.home_team,loser: self.away_team}
        else 
            {winner: self.away_team,loser: self.home_team}
        end
    end

    def winner
        self.results_hash[:winner]
    end

    def point_differential
        self.home_score-self.away_score
    end



    def to_str
        self.date + "\n" + "#{self.home_team.name} #{self.home_score} - #{self.away_score} #{self.away_team.name}"
    end
    
end