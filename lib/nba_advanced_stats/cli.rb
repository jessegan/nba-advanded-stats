class NbaAdvancedStats::CLI

    def run
        puts "Welcome to NBA Advanced Stats CLI"
        self.select_season
    end

    def select_season
        puts "Pick an NBA Season by typing in the starting year (ex. 2018 shows 2018-2019 season):"        
        input  = gets.strip
        if (input.to_i.between?(1980,2018))
            puts "#{input} season selected."
            self.load_season(input)
        else
            puts "Invalid year. Try again."
            puts ""
            select_season
        end
    end

    def load_season(year)
        puts "Loading the #{year} - #{year.to_i+1} season..."
        # NbaAdvancedStats::API.new.create_season(year) if !NbaAdvancedStats::Season.exist?(year)
        puts "Data Loaded."
        puts ""
        self.main_menu(year)
    end

    def main_menu(year)
        puts <<~DOC
            (Type the # to select the option)
            1. Team Records
            2. Home Court Advantages
            3. Point Differentitials
            4. Get data about a specific team
            5. Select a different season
            Type exit to quit.
            What do you want to know about the #{year} - #{year.to_i+1} season?
        DOC

        input = gets.strip

        case input 
        when "1"
            self.print_team_records(year)
            self.main_menu(year)
        when "2"
            self.print_home_court_advantages(year)
            self.main_menu(year)
        when "3"
            self.print_point_differentials(year)
            self.main_menu(year)
        when "4"
            self.select_team(year)
            self.main_menu(year)
        when "5"
            self.select_season
        when "exit"
            self.goodbye
        else
            puts "Invalid input. Try Again"
            self.main_menu(year)
        end
    end
    
    def print_team_records(year)
        puts "printing team records"
    end

    def print_home_court_advantages(year)
        puts "printing home court advantages"
    end

    def print_point_differentials(year)
        puts "printing point differentials"
    end

    def select_team(year)
        puts "Type in the name of the team or the city they are based in:"
        input = gets.strip
        if team = false # search for team in Team class
            self.print_team_stats(team,year)
        else
            puts "Can't find that team. Try Again."
            select_team(year)
        end
    end

    def print_team_stats(team,year)
        puts "printing team stats"
    end

    def goodbye
        puts "Goodbye."
    end
end