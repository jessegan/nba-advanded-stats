class NbaAdvancedStats::Team

    attr_accessor :name

    @@all = []

    def initialize(name:)
        @name = name
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
            puts "team found"
        else 
            puts "create team"
            self.new(name:name)
        end
    end

    # Instance methods
    def save
        @@all << self
    end
end