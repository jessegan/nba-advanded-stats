class NbaAdvancedStats::Game 

    attr_accessor :date,:home_team,:away_team,:home_score,:away_score

    @@all = []

    # Constructors
    def initialize(date:,home_team:,away_team:,home_score:,away_score:)
        @date=date
        @home_team=home_team
        @away_team=away_team
        @home_score=home_score
        @away_score=away_score
        self.save
    end

    # Class getter
    def self.all
        @@all
    end

    # instance methods
    def save
        @@all << self
    end
    
end