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

    # Class methods
    def self.find_with_year(year)
        self.all.find{|season| season.year == year}
    end

    def self.find_or_create_with_api(year)
        if season = self.find_with_year(year)
            season
        else 
            NbaAdvancedStats::API.create_season(year)
        end
    end

    # Instance Methods
    def save
        @@all << self
    end


end