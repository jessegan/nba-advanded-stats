class NbaAdvancedStats::Game 

    attr_accessor :date,:home_score,:away_score
    attr_reader :season,:home_team,:away_team

    @@all = []

    # Constructors
    def initialize(date:,season:,home_team:,away_team:,home_score:,away_score:)
        @date=date
        @home_score=home_score
        @away_score=away_score
        self.home_team=home_team
        self.away_team=away_team
        self.season = season
        self.save
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

    def save
        @@all << self
    end

    def to_s
        puts "#{self.home_team.name} #{self.home_score} - #{self.away_score} #{self.away_team.name}"
    end
    
end