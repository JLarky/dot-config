cd -- "${0%/*}"
#screen -S timesheet -X quit
./stop.sh
if [[ -n $1 ]]
then
  S=$(($1*60))
  echo sleeping for $S seconds
  sleep $S
  echo starting...
fi
screen -d -m -S timesheet ./timelog_run.sh
