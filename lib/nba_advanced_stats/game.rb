class NbaAdvancedStats::Game 

    attr_accessor :date,:season,:home_team,:away_team,:home_score,:away_score

    @@all = []

    # Constructors
    def initialize(date:,season:,home_team:,away_team:,home_score:,away_score:)
        @date=date
        @season=season
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
    def results_hash
        if home_score > away_score
            {winner: home_team,loser: away_team}
        else 
            {winner: away_team,loser: home_team}
        end
    end

    def save
        @@all << self
    end

    def to_s
        puts "#{self.home_team.name} #{self.home_score} - #{self.away_score} #{self.away_team.name}"
    end
    
end