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

        puts "Loading the #{year}-#{year.to_i+1} season..."
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
            5. Get head-to-head matchup details
            6. Select a different season
            Type exit to quit.
            What do you want to know about the #{season.year}-#{season.year.to_i+1} season?
        DOC
                
        #binding.pry

        input = gets.strip.downcase

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
            self.add_line_break
            self.print_team_stats(self.select_team(season),season)
            self.main_menu(season)
        when "5"
            self.add_line_break
            self.select_head_to_head(season)
            self.main_menu(season)
        when "6"
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
        puts "Team Standings for the #{season.year}-#{season.year.to_i+1} season"
        season.standings.each.with_index(1) do |record,i|
            puts "#{i.to_s.rjust(2)}. #{record.team.name.ljust(30)}#{record.wins.to_s.rjust(2)} - #{record.losses.to_s.ljust(2)}"
        end

        self.add_line_break
    end

    def print_home_court_records(season)
        self.add_line_break
        puts "Home Court Records for the #{season.year}-#{season.year.to_i+1} season"
        season.home_court_records.sort {|a,b| b.wins<=>a.wins}.each.with_index(1) do |record,i|
            puts "#{i.to_s.rjust(2)}. #{record.team.name.ljust(30)}#{record.wins.to_s.rjust(2)} - #{record.losses.to_s.ljust(2)}"
        end

        self.add_line_break
    end

    def print_home_court_advantage(season)
        self.add_line_break
        puts "Home Court Advantages for the #{season.year}-#{season.year.to_i+1} season"
        season.home_court_advantages.sort {|a,b| b[:stat]<=>a[:stat]}.each.with_index(1) do |record,i|
            puts "#{i.to_s.rjust(2)}. #{record[:team].name.ljust(30)}"+ "#{record[:stat] > 0 ? "+" : ""}" +"#{"%0.2f" % [record[:stat]*100]}%"
        end

        self.add_line_break
    end

    def select_team(season)
        puts "Type in the name of the team or the city they are based in:"
        input = gets.strip.downcase
        if team = season.find_a_team(input) # search for team in Team class
            team
        else
            puts "Can't find that team. Try Again."
            select_team(season)
        end
    end

    def print_team_stats(team,season)
        self.add_line_break
        puts "#{team.name} #{season.year}-#{season.year.to_i+1} season stats"
        puts "#{"Standing:".rjust(15)} #{season.get_standing(team)}"
        record = team.get_record_by_season(season)
        puts "#{"Record:".rjust(15)} #{record.wins.to_s.rjust(2)} - #{record.losses.to_s.ljust(2)}"
        home_court = record.home_court_record
        home_court_advantage = record.home_court_advantage
        puts "#{"Home Court:".rjust(15)} #{home_court.wins.to_s.rjust(2)} - #{home_court.losses.to_s.ljust(2)} with a #{home_court_advantage > 0 ? "+" : ""}" +"#{"%0.2f" % [home_court_advantage*100]}% advantage"
        self.add_line_break
    end

    def select_head_to_head(season)
        puts "Select the first team:"
        team1 = self.select_team(season)
        puts "Select the second team:"
        team2 = self.select_team(season)
        self.print_head_to_head(team1,team2,season)
    end

    def print_head_to_head(team1,team2,season)
        self.add_line_break
        puts "#{team1.name} vs #{team2.name}"
        record = season.get_head_to_head_record(team1,team2)
        point_dif = record.average_point_differential
        if record.games.length == 0
            puts "No games played against each other this season."
        else
            puts "Record: #{record.wins.to_s.rjust(2)} - #{record.losses.to_s.ljust(2)}"
            puts "Point Differential: #{point_dif > 0 ? "+" : ""}#{"%0.2f" % [point_dif]}"
        end
        self.add_line_break
    end

    def add_line_break
        puts "---------------------------------"
    end

    def goodbye
        puts "Goodbye."
    end
end