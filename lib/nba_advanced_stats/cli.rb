class NbaAdvancedStats::CLI

    # START CLI

    def run
        self.welcome
        self.select_season
    end

    # USER INPUT METHODS

    def select_season
        puts "Pick an NBA Season by typing in the starting year (1979-2018) or type 'exit' to quit.\n(ex. 2018 shows 2018-2019 season):"        
        input  = gets.strip

        if exit?(input)
            self.exit_program
        elsif (input.to_i.between?(1980,2018))
            self.add_line_break
            self.load_season(input)
        else
            puts "Invalid year. Try again."
            puts ""
            select_season
        end
    end

    def main_menu(season)
        puts <<~DOC

            (Type the # to select the option)
            1. Season Standings
            2. Home Court Records
            3. Home Court Advantage (Difference in win percentages between home games and all games)
            4. Average Point Differential
            5. Get data about a specific team
            6. Get head-to-head matchup details
            7. Select a different season
            Type 'exit' to quit.
            What do you want to know about the #{season.year}-#{season.year.to_i+1} season?
        DOC

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
            self.print_point_differentials(season)
            self.main_menu(season)
        when "5"
            self.add_line_break
            self.print_teams_list(season)
            self.print_team_stats(self.select_team(season),season)
            self.main_menu(season)
        when "6"
            self.add_line_break
            self.print_teams_list(season)
            self.select_head_to_head(season)
            self.main_menu(season)
        when "7"
            self.add_line_break
            self.select_season
        when "exit"
            self.exit_program
        else
            puts "Invalid input. Try Again"
            self.main_menu(season)
        end
    end

    def select_team(season)
        puts "Type in the name of the team or the city they are based in or type 'exit' to quit:"
        input = gets.strip.downcase
        if exit?(input)
            self.exit_program
        elsif team = season.find_a_team(input) # search for team in Team class
            team
        else
            puts "Can't find that team. Try Again."
            select_team(season)
        end
    end

    def select_head_to_head(season)
        puts "Select the first team:"
        team1 = self.select_team(season)
        self.add_line_break
        puts "Select the second team:"
        # check if teams are the same
        team2 = self.select_team(season)
        while team1 == team2
            puts "You picked the same team. Try again."
            team2=self.select_team(season)
        end
        self.print_head_to_head(team1,team2,season)
    end

    def exit?(input)
        input == "exit"
    end

    # API CALL
    def load_season(year)

        puts "Loading the #{year}-#{year.to_i+1} season..."
        season = NbaAdvancedStats::Season.find_or_create_with_api(year)
        puts "Data Ready."
        self.add_line_break
        self.main_menu(season)
    end

    # PRINTING STATISTICS

    def print_standings(season)
        self.add_line_break
        puts "Team Standings for the #{season.year}-#{season.year.to_i+1} season"
        season.standings.each.with_index(1) do |record,i|
            puts "#{i.to_s.rjust(2)}. #{record.team.name.ljust(30)}#{record.to_str}"
        end

        self.add_line_break
    end

    def print_home_court_records(season)
        self.add_line_break
        puts "Home Court Records for the #{season.year}-#{season.year.to_i+1} season"
        season.home_court_records_standings.each.with_index(1) do |record,i|
            puts "#{i.to_s.rjust(2)}. #{record.team.name.ljust(30)}#{record.to_str}"
        end

        self.add_line_break
    end

    def print_home_court_advantage(season)
        self.add_line_break
        puts "Home Court Advantages for the #{season.year}-#{season.year.to_i+1} season"
        season.home_court_advantages_standings.each.with_index(1) do |record,i|
            puts "#{i.to_s.rjust(2)}. #{record[:team].name.ljust(30)}"+ "#{record[:stat] > 0 ? "+" : ""}" +"#{"%0.2f" % [record[:stat]*100]}%"
        end

        self.add_line_break
    end

    def print_point_differentials(season)
        self.add_line_break
        puts "Average Point Differentials for the #{season.year}-#{season.year.to_i+1} season"
        season.point_differentials_standings.each.with_index(1) do |record,i|
            puts "#{i.to_s.rjust(2)}. #{record[:team].name.ljust(30)}"+ "#{record[:stat] > 0 ? "+" : ""}" +"#{"%0.2f" % [record[:stat]]}"
        end
    end

    def print_teams_list(season)
        season.teams.sort {|a,b| a.name<=>b.name}.each {|team| puts team.name}
        self.add_line_break
    end

    def print_team_stats(team,season)
        self.add_line_break
        puts "#{team.name} #{season.year}-#{season.year.to_i+1} season stats"
        # Standing
        puts "#{"Standing:".rjust(20)} ##{season.get_standing(team)}"
        # Record
        record = team.get_record_by_season(season)
        puts "#{"Record:".rjust(20)} #{record.to_str}"
        # Home Court
        home_court = record.home_court_record
        home_court_advantage = record.home_court_advantage
        puts "#{"Home Court:".rjust(20)} #{home_court.to_str} with a #{home_court_advantage > 0 ? "+" : ""}" +"#{"%0.2f" % [home_court_advantage*100]}% advantage"
        # Point Differential
        point_dif = record.average_point_differential
        puts "#{"Point Differential:".rjust(20)} #{point_dif > 0 ? "+" : ""}#{"%0.2f" % [point_dif]}"
        self.add_line_break
    end

    def print_head_to_head(team1,team2,season)
        self.add_line_break
        # print team names
        puts "#{team1.name} vs #{team2.name}"

        # print standings
        puts "Standings: ##{season.get_standing(team1)} vs ##{season.get_standing(team2)}"

        # print head-to-head stats
        record = season.get_head_to_head_record(team1,team2)
        point_dif = record.average_point_differential
        if record.games.length == 0
            puts "No games played against each other this season."
        else
            puts "Record: #{record.to_str}"
            puts "Point Differential: #{point_dif > 0 ? "+" : ""}#{"%0.2f" % [point_dif]}"
            puts ""
            puts "Games Played:"
            self.print_games(record)
        end

        self.add_line_break
    end

    def print_games(record)
        record.games.sort {|a,b| a.date<=>b.date}.each do |game|
            puts game.to_str
        end
    end

    # PRINTING METHODS
    
    def welcome
        puts "Welcome to NBA Advanced Stats CLI"
        self.add_line_break
    end

    def add_line_break
        puts "---------------------------------"
    end

    def exit_program
        self.add_line_break
        puts "Thanks for using NBA Advanced Stats CLI!"
        exit
    end

end