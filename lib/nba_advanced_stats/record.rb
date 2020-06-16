class NbaAdvancedStats::Record 

    attr_accessor :season, :team, :wins,:losses

    @@all = []

    #constructors
    def initialize(season:,team:)
        self.season = season
        self.team = team
        @wins=0
        @losses=0
        self.save
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