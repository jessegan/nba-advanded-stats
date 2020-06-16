class NbaAdvancedStats::Team

    attr_accessor :name,:city, :games, :records

    @@all = []

    def initialize(name:)
        @name = name
        @games = []
        @records = []
        self.save
    end

    # Class getters
    def self.all
        @@all
    end

    #Class Methods
    def self.find_by_name(name)
        @@all.find do |team|
            team.name == name
        end
    end

    def self.find_or_create_by_name(name)
        if team = self.find_by_name(name)
            team
        else 
            self.new(name:name)
        end
    end

    # Instance methods
    def add_game(game)
        self.games << game
    end

    def add_record(record)
        self.records << record
    end

    def save
        @@all << self
    end

end