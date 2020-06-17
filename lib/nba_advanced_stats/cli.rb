class NbaAdvancedStats::CLI

    def run
        self.welcome
        self.select_season
    end

    def welcome
        puts "Welcome to NBA Advanced Stats CLI"
        self.add_line_break
    end

    def select_season
        puts "Pick an NBA Season by typing in the starting year (ex. 2018 shows 2018-2019 season):"        
        input  = gets.strip
        if (input.to_i.between?(1980,2018))
            self.add_line_break
            self.load_season(input)
        else
            puts "Invalid year. Try again."
            puts ""
            select_season
        end
    end

    def load_season(year)

        puts "Loading the #{year} - #{year.to_i+1} season..."
        season = NbaAdvancedStats::Season.find_or_create_with_api(year)
        puts "Data Ready."
        self.add_line_break
        self.main_menu(season)
    end

    def main_menu(season)
        puts <<~DOC

            (Type the # to select the option)
            1. Season Standings
            2. Home Court Records
            3. Home Court Advantage (Difference in win percentages between home games and all games)
            4. Get data about a specific team
            5. Select a different season
            Type exit to quit.
            What do you want to know about the #{season.year} - #{season.year.to_i+1} season?
        DOC

        input = gets.strip

        case input 
        when "1"
            self.print_standings(season)
            self.main_menu(season)
        when "2"
            self.print_home_court_records(season)
            self.main_menu(season)
        when "3"
            self.print_home_court_advantage(season)
            self.main_menu(season)
        when "4"
            self.select_team(season)
            self.main_menu(season)
        when "5"
            self.add_line_break
            self.select_season
        when "exit"
            self.goodbye
        else
            puts "Invalid input. Try Again"
            self.main_menu(season)
        end
    end
    
    def print_standings(season)
        self.add_line_break
        season.records.sort {|a,b| b.wins<=>a.wins}.each.with_index(1) do |record,i|
            puts "#{i.to_s.rjust(2)}. #{record.team.name.ljust(30)}#{record.wins.to_s.rjust(2)} - #{record.losses.to_s.ljust(2)}"
        end

        self.add_line_break
    end

    def print_home_court_records(season)
        self.add_line_break
        season.home_court_records.sort {|a,b| b.wins<=>a.wins}.each.with_index(1) do |record,i|
            puts "#{i.to_s.rjust(2)}. #{record.team.name.ljust(30)}#{record.wins.to_s.rjust(2)} - #{record.losses.to_s.ljust(2)}"
        end

        self.add_line_break
    end

    def print_home_court_advantage(season)
        puts "printing point differentials"
    end

    def select_team(season)
        puts "Type in the name of the team or the city they are based in:"
        input = gets.strip
        if team = false # search for team in Team class
            self.print_team_stats(team,season)
        else
            puts "Can't find that team. Try Again."
            select_team(season)
        end
    end

    def print_team_stats(team,season)
        puts "printing team stats"
    end

    def add_line_break
        puts "---------------------------------"
    end

    def goodbye
        puts "Goodbye."
    end
end