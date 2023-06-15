#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT W_GOALS O_GOALS
do
  if [[ $WINNER != 'winner'  ]]
  then
    # Get team_id if exists
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    # If not found
    if [[ -z $TEAM_ID ]]
    then
      # Insert winning teams
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted team, $WINNER
      fi
    fi
  fi

  if [[ $OPPONENT != 'opponent'  ]]
  then
    # Get team_id if exists
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # If not found
    if [[ -z $TEAM_ID ]]
    then
      # Insert losing teams
      INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted team, $OPPONENT
      fi
    fi
  fi

 # Games Data
  if [[ $YEAR != 'year'  ]]
  then
    # Get winning & losing team_id
    WINNING_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    LOSING_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # Insert games data
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) VALUES($YEAR, '$ROUND', $W_GOALS, $O_GOALS, $WINNING_TEAM_ID, $LOSING_TEAM_ID)")
    if [[ $INSERT_GAME_RESULT == "INSERT 0, 1" ]]
    then
      echo Inserted into games, $YEAR $ROUND $W_GOALS $O_GOALS $WINNER $OPPONENT
    fi
  fi

done