__author__ = 'Luke'
import numpy as np
import time
import http.client, urllib.parse
from pprint import pprint
API_KEY = "H671BFO41N0TP246"
n_spine = 8.0
fields = list(map(lambda x: "field"+x, map(str, range(1, 9))))
headers = {"Content-type": "application/x-www-form-urlencoded",
           "Accept": "text/plain"}
def main():
    period = np.arange(0, 2, 2.0/n_spine) * np.pi
    print (2.0/n_spine)
    while True:
        for dt in period:
            sensors = np.cos(period+dt)*5 + 25
            #print sensors
            data = dict(zip(fields, sensors))
            data["key"] = API_KEY
            params = urllib.parse.urlencode(data)
            conn = http.client.HTTPConnection("api.thingspeak.com:80")
            try:
                conn.request("POST", "/update", params, headers)
                response = conn.getresponse()
                #data = response.read()
                conn.close()
                print(response.status, response.reason)
            except (KeyboardInterrupt, SystemExit):
                raise
            except:
                #catch all errors, handle nothing for now
                #multiple devices uploading to the same channel will cause errors
                print ("an error occurred")
            time.sleep(16)
            
if __name__ == "__main__":
    main()