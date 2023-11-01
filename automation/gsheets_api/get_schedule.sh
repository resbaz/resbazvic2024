#!/usr/bin/env bash

## requires yq for JSON to YAML mangling

## not too often yeah

time_now=$(date +%s)
echo "Time now: $(date --date '@'$time_now)"
STAMPFILE=".timestamps"

if [[ -f $STAMPFILE ]]; then
  last_token_time=$(date --date "$(sed -n '1 s/Last-token-request-time: //p' $STAMPFILE)" +%s)
  last_sheet_time=$(date --date "$(sed -n '2 s/Last-sheet-update-time: //p' $STAMPFILE)" +%s)
  echo "Token last requested: $(date --date '@'$last_token_time)"
  echo "Sheet last updated: $(date --date '@'$last_sheet_time)"
else 
  last_token_time=0
  last_sheet_time=0
fi

token_interval=$(( time_now - last_token_time ))

if [[ $token_interval -gt 1800 ]]; then # todo: make this work if token file is missing, and error if .stored_token if missing
  echo "Requesting new access token ($token_interval s since last request)"
  export $(cat .stored_token | xargs) && AUTH_DATA="access_type=offline&refresh_token=$REFRESH_TOKEN&client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET&grant_type=refresh_token"
  echo $AUTH_DATA
  AUTH_RESPONSE=$(curl --request POST --data "$AUTH_DATA" https://oauth2.googleapis.com/token)
  echo "$AUTH_RESPONSE"
  export ACCESS_TOKEN=$(echo $AUTH_RESPONSE | jq -r '.access_token')
  echo "$ACCESS_TOKEN" > .access_token
  token_time=$time_now
else
  echo "Not requesting new access token ($token_interval s since last request)"
  export ACCESS_TOKEN=$(cat ".access_token")
  token_time=$last_token_time
fi


sheet_interval=$(( time_now - last_sheet_time ))

if [[ $sheet_interval -gt 30 ]]; then
  echo "Updating from spreadsheet ($sheet_interval s since last update)"
# request sessions
export $(cat .spreadsheet_info | xargs) && curl -H "Authorization: Bearer $ACCESS_TOKEN" \
	-o "raw_sessions.json" \
	"https://sheets.googleapis.com/v4/spreadsheets/$SPREADSHEET_ID/values/$RANGE1"
  jq -r '.values' raw_sessions.json | bash yq1_sessions.yq > ../../_data/sessions.yml
# request speakers
export $(cat .spreadsheet_info | xargs) && curl -H "Authorization: Bearer $ACCESS_TOKEN" \
	-o "raw_speakers.json" \
	"https://sheets.googleapis.com/v4/spreadsheets/$SPREADSHEET_ID/values/$RANGE2"
  jq -r '.values' raw_speakers.json | bash yq2_speakers.yq > ../../_data/speakers.yml
  sheet_time=$time_now
else
  echo "Not updating from spreadsheet ($sheet_interval s since last update)"
  sheet_time=$last_sheet_time  
fi

echo "Last-token-request-time: $(date --date '@'$token_time)" > $STAMPFILE
echo "Last-sheet-update-time: $(date --date '@'$sheet_time)" >> $STAMPFILE
