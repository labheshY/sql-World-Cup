#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams,games")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
    then
      #get team_id
      TEAM_ID1=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      #if not found
      if [[ -z $TEAM_ID1 ]]
       then
        #insert team_id
        INSERT_TEAM_ID=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      fi
      #get new team_id
      TEAM_ID1=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      #get team_id
      TEAM_ID2=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      #if not found
      if [[ -z $TEAM_ID2 ]]
       then
        #insert team_id
        INSERT_TEAM_ID=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      fi
      #get new team_id
      TEAM_ID2=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      #insert into games
      INSERT_GAME=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$TEAM_ID1,$TEAM_ID2,$WINNER_GOALS,$OPPONENT_GOALS)")
  fi
done