class NbaAdvancedStats::Season 

    attr_accessor :year

    @@all = []

    # Hooks
    def initialize(year:)
        @year = year
        self.save
    end
    
    # Class Getter
    def self.all
        @@all
    end

    # Instance Methods
    def save
        @@all << self
    end


end