class NbaAdvancedStats::API 

    BASE_URL = "https://www.balldontlie.io/api/v1/"

    def self.create_season(year,page=13,season=nil)
        response = Net::HTTP.get_response(URI.parse(BASE_URL + "games?seasons[]=#{year}&postseason=false&per_page=100&page=#{page}")).body
        season_data = JSON.parse(response)

        # Counts for loading page
        total_games = season_data["meta"]["total_count"]
        count = (season_data["meta"]["current_page"] - 1) * 100

        # Create the new Season object
        season = NbaAdvancedStats::Season.new(year: year) if !season

        # Iterate through every game
        season_data["data"].each.with_index(count+1) do |game,i|
            print "\r#{(1.0*i/total_games*100).to_i}% games loaded"
            sleep(0.005)

            home_team = NbaAdvancedStats::Team.find_or_create_by_name(game["home_team"]["name"])
            away_team = NbaAdvancedStats::Team.find_or_create_by_name(game["visitor_team"]["name"])

            # game = NbaAdvancedStats::Game.new(
            #     home_team: home_team,
            #     away_team: away_team,
            #     date: "2019-01-30T00:00:00.000Z",
            #     home_score: 126,
            #     away_score: 94
            # )

            # puts "#{game.home_team} #{game.home_score} - #{game.away_score} #{game.away_team}"
        end

        #Checks if there is another page of data
        if season_data["meta"]["next_page"]
            # Recursively calls create_season again with next page number
            self.create_season(year,page+1,season)
        end

        season
    end

end