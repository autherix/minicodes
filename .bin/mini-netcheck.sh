#! /usr/bin/bash

# set the timezone to asia/dubai
export TZ="Asia/Dubai"

export DEFAULT_HOST="8.8.8.8"

# if $1 is provided and it is a ip (validate with regex), set HOST to $1, else set it to DEFAULT_HOST
if [[ $1 =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
  export HOST=$1
else
  export HOST=$DEFAULT_HOST
fi

while getopts ":h-" opt; do
  case $opt in
    h|\?)
      if [ "$opt" = "h" ]; then
        echo "Usage: $0 [-h] [host]"
        echo "  -h: show this help"
        echo "  host: the host to ping, default is $DEFAULT_HOST"
      else
        echo "Invalid option: -$OPTARG" >&2
        exit 1
      fi
      exit 1
      ;;
    --help)
      echo "Usage: $0 [-h] [host]"
      echo "  -h: show this help"
      echo "  host: the host to ping, default is $DEFAULT_HOST"
      exit 0
      ;;
  esac
done

shift $((OPTIND-1))

round=0
while true
do
  printf "\e[35m%03d\e[0m %s " "$round" "$(date +%H:%M:%S)"
  # send a ping with a timeout of 2 second and save it's result in a variable called ping_result
  ping_result_time=$(ping -c 1 -W 2 "$HOST" | grep 'time=' | cut -d '=' -f 4 | cut -d ' ' -f 1)
  
  # check if ping_result_time is not empty and command exit status is 0
  if [ -n "$ping_result_time" ] && [ $? -eq 0 ]; then
    # print in green how much time it took
    printf "\e[32m%s ms\e[0m\n" "$ping_result_time"
  else
    # print in red that ping failed
    printf "\e[31mFAIL\e[0m\n"
  fi

  round=$((round+1))
  if [ $((round % 10)) -eq 0 ]; then
    printf "%s\n" "------------------------------------"
  fi
  sleep 2
done

