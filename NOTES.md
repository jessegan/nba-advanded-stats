Project Process
1. Plan out CLI Gem
2. Setup project file structure
3. Setup bin run file
4. Stub out CLI
5. Retrieve data from API
6. Loaded data into Season + Game objects


Create a CLI for user to access advanced statistics based on games from an NBA season.

User is prompted to pick a season -> Load data from API into objects

Show general statistics about the season:
2018 - 2019 Season
32 Teams
1280 Games Played

Give menu of options to pick:
Pick a category of statistics to look at:
1. Season Standings
2. Home Court Advantages
3. Point Differentials
4. select a team
5. Select a different season
Exit.


Team stats:
Boston Celtics 
1-1 (#1)
1-1 Home Record with + 0.03% Home Court Advantage
+ 1 Point differential

CLASS STRUCTURES

Season:
- Should have:
 - year
 - games
- Should be able to:
 - add a game
 - show its standings
 - show various advanced stats from the games

