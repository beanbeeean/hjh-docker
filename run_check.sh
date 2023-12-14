CHANNEL="hjh-alarm"
USERNAME="HJH-TEST"
TITLE="TITLE : JENKINS STATUS"
HOOK=https://hooks.slack.com/services/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

result=`ps -ef | grep jenkins | wc -l`
if [ $result -ge 3 ]
then
echo "jenkins is running"
MSG="MSG : JENKINS IS RUNNING!"
PAYLOAD="payload={\"channel\": \"$CHANNEL\", \"username\": \"$USERNAME\", \"text\": \"$TITLE \n\n $MSG\"}"
curl -X POST --data-urlencode "$PAYLOAD" "$HOOK"
else
echo "jenkins is not running"
echo "jenkins started"
MSG="MSG : ERROR! JENKINS IS NOT RUNNING! RESTARTING..."
PAYLOAD="payload={\"channel\": \"$CHANNEL\", \"username\": \"$USERNAME\", \"text\": \"$TITLE \n\n $MSG\"}"
curl -X POST --data-urlencode "$PAYLOAD" "$HOOK"
service jenkins start
fi
