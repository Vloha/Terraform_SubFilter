import os
import json
import gzip
import boto3
import base64
from datetime import datetime
from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError


#client = WebClient(token=os.environ['SLACK_BOT_TOKEN'])
client = WebClient(token='')


def handler(event, context):
    
    #check if incoming data exist
    print(event)
    try:
        logData = str(
            gzip.decompress(base64.b64decode(
                event["awslogs"]["data"])), "utf-8"
        )
    except Exception as error:
        logging.error("failed to retrieve message data: %s", error)
        return 500
    
    #parsing logData    
    jsonBody = json.loads(logData)
    print(jsonBody)

    print(f"Account: {jsonBody['owner']}")
    print(f"Source LogGroup: {jsonBody['logGroup']}")
    print(f"Source LogStream: {jsonBody['logStream']}")

    for filterData in jsonBody["subscriptionFilters"]:
        print(f"Subscription Filter: {filterData}")

    print(f"Message Type: {jsonBody['messageType']}")
    
    
    snd = []
    filename='/tmp/logMessage.json'
    for logEvent in jsonBody["logEvents"]:
        print(f"logEvent = {logEvent}")
        print(f"event ID {logEvent['id']} at {datetime.fromtimestamp(logEvent['timestamp'] / 1000.0)}")
        if 'SQS' in logEvent.get('message',''):
            snd.append(logEvent.get('message',''))
    
    with open(filename, 'w+') as j_file:
        json.dump(snd, j_file, indent=4)
    try:
        filepath = filename
        response = client.files_upload(channels='', initial_comment="", file=filepath)
        assert response["file"]  # the uploaded file
    except SlackApiError as e:
        assert e.response["ok"] is False
        assert e.response["error"]
        print(f"Got an error: {e.response['error']}")
    return 0