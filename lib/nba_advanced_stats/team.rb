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

    # CLASS METHODS

    ## Class getters

    def self.all
        @@all
    end

    ## find methods

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

    # INSTANCE METHODS

    ## Adding object relationships

    # Adds a game to list of games
    def add_game(game)
        self.games << game
    end

    # Adds a record to list of records
    def add_record(record)
        self.records << record
    end

    ## Getting object relationships

    # Returns a record for the team during the given season
    def get_record_by_season(season)
        self.records.find {|record| record.season == season}
    end

    # Returns a home record for the team during the given season
    def get_home_record_by_season(season)
        self.get_record_by_season(season).home_court_record
    end

    # Returns the home court advantage for the team during the given season
    def get_home_advantage_by_season(season)
        self.get_record_by_season(season).home_court_advantage
    end

    # Returns an array of games from the given season
    def get_games_by_season(season)
        self.records.find {|record| record.season == season}
    end

end