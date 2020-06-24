class NbaAdvancedStats::Team

    attr_accessor :name, :games, :records

    @@all = []

    def initialize(name:)
        @name = name
        @games = []
        @records = []
    end

    def self.create(name:) 
        team = self.new(name:name)
        team.save
        team
    end

    def save
        @@all << self
    end

    # Class getters
    def self.all
        @@all
    end

    #Class Methods
    def self.find_by_name(name)
        @@all.find do |team|
            team.name.downcase.match(/\b#{name.downcase}\b/)
        end
    end

    def self.find_or_create_by_name(name)
        if team = self.find_by_name(name)
            team
        else 
            self.create(name:name)
        end
    end

    # Instance methods
    def add_game(game)
        self.games << game
    end

    def add_record(record)
        self.records << record
    end

    def get_record_by_season(season)
        self.records.find {|record| record.season == season}
    end

    def get_home_record_by_season(season)
        self.get_record_by_season(season).home_court_record
    end

    def get_home_advantage_by_season(season)
        self.get_record_by_season(season).home_court_advantage
    end

    def get_games_by_season(season)
        self.records.find {|record| record.season == season}
    end

end