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
        @season=season
    end

    def self.create(date:,season:,home_team:,away_team:,home_score:,away_score:)
        game = self.new(date:date,season:season,home_team:home_team,away_team:away_team,home_score:home_score,away_score:away_score)
        game.save
        game
    end

    def save
        self.home_team.add_game(self)
        self.away_team.add_game(self)
        self.season.add_game(self)
        @@all << self
    end

    # Class getter
    def self.all
        @@all
    end

    # INSTANCE METHODS

    ## Returns a hash of winning and losing teams
    def results_hash
        if self.home_score > self.away_score
            {winner: self.home_team,loser: self.away_team}
        else 
            {winner: self.away_team,loser: self.home_team}
        end
    end

    ## Returns the winning team
    def winner
        self.results_hash[:winner]
    end

    ## Returns the point differential of the game (home - away)
    def point_differential
        self.home_score-self.away_score
    end

    ## Returns a string formatted version
    def to_str
        self.date + "\n" + "#{self.home_team.name} #{self.home_score} - #{self.away_score} #{self.away_team.name}"
    end
    
end