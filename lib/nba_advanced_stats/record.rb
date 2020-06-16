class NbaAdvancedStats::Record 

    attr_accessor :season, :team, :wins,:losses

    @@all = []

    def initialize(season:,team:)
        @season = season
        @team = team
        @wins=0
        @losses=0
        self.save
    end
    
    def self.all
        @@all
    end

    def add_win
        self.wins += 1
    end

    def add_loss
        self.losses += 1
    end

    def save
        @@all << self
    end

end