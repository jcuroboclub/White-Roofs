__author__ = "Luke"
import numpy as np
import time
import httplib, urllib
from pprint import pprint
import os

SERVER_UPDATE_LIMIT = 16
MAX_RETRIES = 25
lastSentList = {}

def uploadData(data, APIKey):
    try:
        lastSent = lastSentList[APIKey]
        if ((time.time() - lastSent) < SERVER_UPDATE_LIMIT):
            #print("Could not send to", APIKey, "not enough time has passed.")
            return -1
    except KeyError:
        print("New API Key entered, no previous send record")
    fields = list(map(lambda x: "field"+x, map(str, range(1, len(data)+1))))
    headers = {"Content-type": "application/x-www-form-urlencoded",
           "Accept": "text/plain"}
    retries = 0
    sent = False
    while not(sent) and retries < MAX_RETRIES:
        sendData = dict(zip(fields, data))
        sendData["key"] = APIKey
        params = urllib.urlencode(sendData)
        conn = httplib.HTTPConnection("api.thingspeak.com:80")
        try:
            conn.request("POST", "/update", params, headers)
            response = conn.getresponse()
            conn.close()
            print(response.status, response.reason)
        except (KeyboardInterrupt, SystemExit):
            raise
        except:
            #catch all errors, handle nothing for now
            #multiple devices uploading to the same channel will cause errors
            print ("an error occurred")
            retries = retries + 1
        else:
            sent = True
    if retries >= MAX_RETRIES:
        isReset = False
        while not (isReset):
            try:
                os.system("/home/pi/miforever.rb")
            except (KeyboardInterrupt, SystemExit):
                raise
            except:
                print ("Failed to reconnect, trying again...")
            else:
                isReset = True
        return -2
    lastSentList[APIKey] = time.time()
    return 1

def main():
    n_spine = 16.0
    period = np.arange(0, 2, 2.0/n_spine) * np.pi
    while True:
        for dt in period:
            sensors = np.sin(period+dt)*5 + 25
            success = 0
            while not (success == 1):
                success = uploadData(sensors, "H671BFO41N0TP246")


if __name__ == "__main__":
    main()
