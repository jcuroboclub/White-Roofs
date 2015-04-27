__author__ = 'Ash'
import numpy as np
import time
import http.client, urllib.parse
from pprint import pprint

API_KEY = ["H671BFO41N0TP246", "VJEFXKQ0AE4LD80D", "QPHVEZKYTKYNXOQZ"]
n_spine = [8, 8, 1]
fields = list(map(lambda x: "field"+x, map(str, range(1, 9))))
headers = {"Content-type": "application/x-www-form-urlencoded",
           "Accept": "text/plain"}

def main():
    period = np.arange(0, 2, 2/8) * np.pi
    while True:
        for dt in period:
            for n, key in zip(n_spine, API_KEY):
                sensors = np.cos(period+dt)*5 + 25
                data = dict(zip(fields, sensors))
                data["key"] = key
                params = urllib.parse.urlencode(data)
                conn = http.client.HTTPConnection("api.thingspeak.com:80")
                conn.request("POST", "/update", params, headers)
                response = conn.getresponse()
                print(response.status, response.reason)
                conn.close()
                time.sleep(16/len(API_KEY))



if __name__ == "__main__":
    main()