PROFILE=fl-dev
TOKEN=$(aws --profile $PROFILE logs describe-log-streams --log-group logs --log-stream-name-prefix stream | jq .logStreams[0].uploadSequenceToken | tr -d '"')

echo "token: $TOKEN"

VAL=$(shuf -i 50-1000 -n 1)
TIME=$(echo "$(date +%s%3)00")

arr[0]="200"
arr[1]="500"
arr[2]="503"

rand=$(shuf -i 0-2 -n 1)
STATUS=${arr[$rand]}
MESSAGE="DEP GET $STATUS $VAL"
echo $TIME
echo $MESSAGE
aws --profile $PROFILE logs put-log-events --log-group-name logs --log-stream-name stream --log-events timestamp=$TIME,message="$MESSAGE" --sequence-token $TOKEN

sleep 0.5
#for run in {1..10}; do ./log.sh; done